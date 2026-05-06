param(
    [string]$BaseUrl = "http://localhost:8081/api",
    [int]$QuizSearchLimit = 300,
    [string]$GoogleIdToken
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Add-Result {
    param(
        [System.Collections.Generic.List[object]]$Results,
        [string]$Endpoint,
        [int]$StatusCode
    )

    $Results.Add([pscustomobject]@{
            Endpoint   = $Endpoint
            StatusCode = $StatusCode
            Result     = "PASS"
        })
}

 function Get-HttpMethod {
     param([string]$Method)
 
     switch ($Method.ToUpperInvariant()) {
         "GET" { return [System.Net.Http.HttpMethod]::Get }
         "POST" { return [System.Net.Http.HttpMethod]::Post }
         "PUT" { return [System.Net.Http.HttpMethod]::Put }
        "PATCH" { return [System.Net.Http.HttpMethod]::new("PATCH") }
         "DELETE" { return [System.Net.Http.HttpMethod]::Delete }
         default { throw "Unsupported HTTP method: $Method" }
     }
 }

function Get-ErrorCode {
    param($Json)

    if ($null -eq $Json) {
        return $null
    }

    if ($null -ne $Json.error -and $null -ne $Json.error.code) {
        return [string]$Json.error.code
    }

    return $null
}

function Assert-Equal {
    param(
        $Actual,
        $Expected,
        [string]$Message
    )

    if ($Actual -ne $Expected) {
        throw "$Message. Expected: [$Expected], actual: [$Actual]"
    }
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Invoke-Api {
    param(
        [System.Net.Http.HttpClient]$Client,
        [string]$Method,
        [string]$BaseUrl,
        [string]$Path,
        [int[]]$ExpectedStatusCodes,
        $Body = $null,
        [string]$AccessToken = $null
    )

    $fullUrl = if ($Path.StartsWith("/")) {
        "$BaseUrl$Path"
    }
    else {
        "$BaseUrl/$Path"
    }

    $request = [System.Net.Http.HttpRequestMessage]::new((Get-HttpMethod -Method $Method), $fullUrl)

    try {
        if (-not [string]::IsNullOrWhiteSpace($AccessToken)) {
            $request.Headers.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new("Bearer", $AccessToken)
        }

        if ($null -ne $Body) {
            $jsonBody = $Body | ConvertTo-Json -Depth 30 -Compress
            $request.Content = [System.Net.Http.StringContent]::new($jsonBody, [System.Text.Encoding]::UTF8, "application/json")
        }

        $response = $Client.SendAsync($request).GetAwaiter().GetResult()
        $statusCode = [int]$response.StatusCode
        $text = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()

        $json = $null
        $mediaType = $null
        if ($null -ne $response.Content.Headers.ContentType) {
            $mediaType = $response.Content.Headers.ContentType.MediaType
        }

        if (-not [string]::IsNullOrWhiteSpace($text) -and $mediaType -like "*json*") {
            try {
                $json = $text | ConvertFrom-Json
            }
            catch {
                $json = $null
            }
        }

        if ($ExpectedStatusCodes -notcontains $statusCode) {
            throw "Unexpected status for $Method $fullUrl. Expected: $($ExpectedStatusCodes -join ', '), actual: $statusCode. Body: $text"
        }

        return [pscustomobject]@{
            Url        = $fullUrl
            StatusCode = $statusCode
            Text       = $text
            Json       = $json
        }
    }
    finally {
        $request.Dispose()
    }
}

function Find-FirstQuiz {
    param(
        [System.Net.Http.HttpClient]$Client,
        [string]$BaseUrl,
        [string]$AccessToken,
        [int]$SearchLimit
    )

    for ($quizId = 1; $quizId -le $SearchLimit; $quizId++) {
        $response = Invoke-Api -Client $Client -Method "GET" -BaseUrl $BaseUrl -Path "/assessment/quizzes/${quizId}?lang=en" -ExpectedStatusCodes @(200, 404) -AccessToken $AccessToken

        if ($response.StatusCode -eq 200) {
            return $response
        }

        $errorCode = Get-ErrorCode -Json $response.Json
        if ($errorCode -ne "QUIZ_NOT_FOUND") {
            throw "Unexpected response while probing quiz $quizId. Status: $($response.StatusCode), error: $errorCode"
        }
    }

    throw "Could not find a valid quiz id in range 1..$SearchLimit"
}

if (-not ("System.Net.Http.HttpClient" -as [type])) {
    Add-Type -AssemblyName System.Net.Http
}

$normalizedBaseUrl = $BaseUrl.TrimEnd("/")
$results = [System.Collections.Generic.List[object]]::new()
$client = [System.Net.Http.HttpClient]::new()
$client.Timeout = [TimeSpan]::FromSeconds(30)

try {
    $stamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $email = "api.test.$stamp@example.com"
    $userSuffix = ($stamp % 1000000).ToString("D6")
    $username = "api$userSuffix"
    $updatedUsername = "upd$userSuffix"
    $password = "pass${stamp}1"
    $newPassword = "new${stamp}1"

    Write-Step "Register temp user"
    $register = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/register" -ExpectedStatusCodes @(201) -Body @{
        email    = $email
        username = $username
        password = $password
    }
    Add-Result -Results $results -Endpoint "POST /auth/register" -StatusCode $register.StatusCode
    Assert-True ($null -ne $register.Json.user) "Register response does not contain user"
    Assert-Equal -Actual $register.Json.user.email -Expected $email -Message "Registered email mismatch"

    $registerAccessToken = [string]$register.Json.access_token

    Write-Step "Login with local credentials"
    $login = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/login" -ExpectedStatusCodes @(200) -Body @{
        email    = $email
        password = $password
    }
    Add-Result -Results $results -Endpoint "POST /auth/login" -StatusCode $login.StatusCode
    $loginAccessToken = [string]$login.Json.access_token
    $loginRefreshToken = [string]$login.Json.refresh_token

    if (-not [string]::IsNullOrWhiteSpace($GoogleIdToken)) {
        Write-Step "Google login"
        $google = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/google" -ExpectedStatusCodes @(200) -Body @{
            id_token = $GoogleIdToken
        }
        Add-Result -Results $results -Endpoint "POST /auth/google" -StatusCode $google.StatusCode
    }
    else {
        Write-Host "Skipping POST /auth/google because -GoogleIdToken was not provided." -ForegroundColor Yellow
    }

    Write-Step "Read current auth user"
    $me = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/auth/me" -ExpectedStatusCodes @(200) -AccessToken $registerAccessToken
    Add-Result -Results $results -Endpoint "GET /auth/me" -StatusCode $me.StatusCode
    Assert-Equal -Actual $me.Json.email -Expected $email -Message "GET /auth/me returned wrong email"

    Write-Step "Change username"
    $changeUsername = Invoke-Api -Client $client -Method "PATCH" -BaseUrl $normalizedBaseUrl -Path "/auth/me/username" -ExpectedStatusCodes @(200) -Body @{
        new_username = $updatedUsername
    } -AccessToken $registerAccessToken
    Add-Result -Results $results -Endpoint "PATCH /auth/me/username" -StatusCode $changeUsername.StatusCode
    Assert-Equal -Actual $changeUsername.Json.username -Expected $updatedUsername -Message "Username was not updated"

    Write-Step "Refresh access token"
    $refresh = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/refresh" -ExpectedStatusCodes @(200) -Body @{
        refresh_token = $loginRefreshToken
    }
    Add-Result -Results $results -Endpoint "POST /auth/refresh" -StatusCode $refresh.StatusCode
    $refreshedRefreshToken = [string]$refresh.Json.refresh_token

    Write-Step "Logout refreshed session"
    $logout = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/logout" -ExpectedStatusCodes @(200) -Body @{
        refresh_token = $refreshedRefreshToken
    }
    Add-Result -Results $results -Endpoint "POST /auth/logout" -StatusCode $logout.StatusCode
    Assert-Equal -Actual $logout.Json.message -Expected "LOGGED_OUT" -Message "Logout did not return expected message"

    Write-Step "Login again after logout"
    $loginAgain = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/login" -ExpectedStatusCodes @(200) -Body @{
        email    = $email
        password = $password
    }
    $currentAccessToken = [string]$loginAgain.Json.access_token
    $currentRefreshToken = [string]$loginAgain.Json.refresh_token

    Write-Step "Change password to temporary value"
    $changePassword = Invoke-Api -Client $client -Method "PATCH" -BaseUrl $normalizedBaseUrl -Path "/auth/me/password" -ExpectedStatusCodes @(200) -Body @{
        current_password = $password
        new_password     = $newPassword
        refresh_token    = $currentRefreshToken
    } -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "PATCH /auth/me/password" -StatusCode $changePassword.StatusCode
    Assert-Equal -Actual $changePassword.Json.message -Expected "PASSWORD_CHANGED" -Message "Password change did not return expected message"

    Write-Step "Login with new password"
    $loginWithNewPassword = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/login" -ExpectedStatusCodes @(200) -Body @{
        email    = $email
        password = $newPassword
    }
    $currentAccessToken = [string]$loginWithNewPassword.Json.access_token
    $currentRefreshToken = [string]$loginWithNewPassword.Json.refresh_token

    Write-Step "Revert password to original value"
    $revertPassword = Invoke-Api -Client $client -Method "PATCH" -BaseUrl $normalizedBaseUrl -Path "/auth/me/password" -ExpectedStatusCodes @(200) -Body @{
        current_password = $newPassword
        new_password     = $password
        refresh_token    = $currentRefreshToken
    } -AccessToken $currentAccessToken
    Assert-Equal -Actual $revertPassword.Json.message -Expected "PASSWORD_CHANGED" -Message "Password revert did not return expected message"

    Write-Step "Final login for authenticated endpoint tests"
    $finalLogin = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/login" -ExpectedStatusCodes @(200) -Body @{
        email    = $email
        password = $password
    }
    $currentAccessToken = [string]$finalLogin.Json.access_token
    $currentRefreshToken = [string]$finalLogin.Json.refresh_token

    Write-Step "Profile should not exist before onboarding"
    $missingProfile = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/profile/me" -ExpectedStatusCodes @(404) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /profile/me (missing profile)" -StatusCode $missingProfile.StatusCode
    Assert-Equal -Actual (Get-ErrorCode -Json $missingProfile.Json) -Expected "PROFILE_NOT_FOUND" -Message "Unexpected missing profile error"

    Write-Step "Settings should not exist before onboarding"
    $missingSettings = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/profile/settings" -ExpectedStatusCodes @(404) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /profile/settings (missing settings)" -StatusCode $missingSettings.StatusCode
    Assert-Equal -Actual (Get-ErrorCode -Json $missingSettings.Json) -Expected "SETTINGS_NOT_FOUND" -Message "Unexpected missing settings error"

    Write-Step "Upsert onboarding profile"
    $profilePayload = @{
        financial_literacy_level = "beginner"
        practical_experience     = "no_experience"
        learning_goal            = "saving_money"
        preferred_language       = "en"
        time_commitment          = "10_min"
        preferred_topics         = @("budgeting", "savings")
    }
    $upsertProfile = Invoke-Api -Client $client -Method "PUT" -BaseUrl $normalizedBaseUrl -Path "/profile/me" -ExpectedStatusCodes @(200) -Body $profilePayload -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "PUT /profile/me" -StatusCode $upsertProfile.StatusCode
    Assert-Equal -Actual $upsertProfile.Json.preferredLanguage -Expected "en" -Message "Profile preferred language mismatch after upsert"

    Write-Step "Read profile"
    $profile = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/profile/me" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /profile/me" -StatusCode $profile.StatusCode
    Assert-Equal -Actual $profile.Json.onboardingCompleted -Expected $true -Message "Onboarding flag mismatch"

    Write-Step "Read settings"
    $settings = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/profile/settings" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /profile/settings" -StatusCode $settings.StatusCode
    Assert-Equal -Actual $settings.Json.languageCode -Expected "en" -Message "Settings language should follow onboarding preferred language"

    Write-Step "Patch settings"
    $patchedSettings = Invoke-Api -Client $client -Method "PATCH" -BaseUrl $normalizedBaseUrl -Path "/profile/settings" -ExpectedStatusCodes @(200) -Body @{
        language_code         = "kk"
        theme                 = "dark"
        notifications_enabled = $true
        reminder_time         = "21:30:00"
    } -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "PATCH /profile/settings" -StatusCode $patchedSettings.StatusCode
    Assert-Equal -Actual $patchedSettings.Json.languageCode -Expected "kk" -Message "Settings language patch failed"
    Assert-Equal -Actual $patchedSettings.Json.theme -Expected "dark" -Message "Settings theme patch failed"

    Write-Step "Read topics"
    $topicsResponse = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/content/topics?lang=en" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /content/topics" -StatusCode $topicsResponse.StatusCode
    $topics = @($topicsResponse.Json)
    Assert-True ($topics.Count -gt 0) "No topics returned from GET /content/topics"
    $topicCode = [string]$topics[0].code

    Write-Step "Read subtopics"
    $subtopicsResponse = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/content/topics/$topicCode/subtopics?lang=en" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /content/topics/{topicCode}/subtopics" -StatusCode $subtopicsResponse.StatusCode
    $subtopics = @($subtopicsResponse.Json)
    Assert-True ($subtopics.Count -gt 0) "No subtopics returned for topic [$topicCode]"
    $subtopicCode = [string]$subtopics[0].code

    Write-Step "Read lesson"
    $lesson = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/content/subtopics/$subtopicCode/lesson?lang=en" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /content/subtopics/{subtopicCode}/lesson" -StatusCode $lesson.StatusCode
    Assert-True (@($lesson.Json.steps).Count -gt 0) "Lesson for subtopic [$subtopicCode] has no steps"

    Write-Step "Find first valid quiz"
    $quizResponse = Find-FirstQuiz -Client $client -BaseUrl $normalizedBaseUrl -AccessToken $currentAccessToken -SearchLimit $QuizSearchLimit
    $quizId = [int64]$quizResponse.Json.id
    Add-Result -Results $results -Endpoint "GET /assessment/quizzes/{quizId}" -StatusCode $quizResponse.StatusCode

    Write-Step "Read latest attempt before quiz start"
    $latestAttemptBefore = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/assessment/quizzes/$quizId/latest-attempt" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /assessment/quizzes/{quizId}/latest-attempt (before submit)" -StatusCode $latestAttemptBefore.StatusCode
    Assert-Equal -Actual $latestAttemptBefore.Json.has_attempt -Expected $false -Message "Expected no latest attempt before first submission"

    Write-Step "Start quiz"
    $startQuiz = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/assessment/quizzes/$quizId/start?lang=en" -ExpectedStatusCodes @(201) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "POST /assessment/quizzes/{quizId}/start" -StatusCode $startQuiz.StatusCode
    $attemptId = [int64]$startQuiz.Json.attempt_id
    $attemptQuestions = @($startQuiz.Json.questions)
    Assert-True ($attemptQuestions.Count -gt 0) "Started quiz returned zero questions"

    Write-Step "Submit quiz attempt"
    $answerPayload = foreach ($question in $attemptQuestions) {
        $options = @($question.options)
        Assert-True ($options.Count -gt 0) "Question [$($question.id)] has no options"

        @{
            question_id         = [int64]$question.id
            selected_option_ids = @([int64]$options[0].id)
        }
    }

    $submitAttempt = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/assessment/attempts/$attemptId/submit" -ExpectedStatusCodes @(200) -Body @{
        duration_seconds = 90
        answers          = @($answerPayload)
    } -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "POST /assessment/attempts/{attemptId}/submit" -StatusCode $submitAttempt.StatusCode
    Assert-Equal -Actual $submitAttempt.Json.attempt_id -Expected $attemptId -Message "Submit response contains wrong attempt id"

    Write-Step "Read latest attempt after submission"
    $latestAttemptAfter = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/assessment/quizzes/$quizId/latest-attempt" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /assessment/quizzes/{quizId}/latest-attempt" -StatusCode $latestAttemptAfter.StatusCode
    Assert-Equal -Actual $latestAttemptAfter.Json.has_attempt -Expected $true -Message "Expected completed latest attempt after submission"

    Write-Step "Read attempt details"
    $attemptDetail = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/assessment/attempts/${attemptId}?lang=en" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /assessment/attempts/{attemptId}" -StatusCode $attemptDetail.StatusCode
    Assert-True (@($attemptDetail.Json.answers).Count -gt 0) "Attempt detail returned no answers"

    Write-Step "Read progress overview"
    $progress = Invoke-Api -Client $client -Method "GET" -BaseUrl $normalizedBaseUrl -Path "/progress/me" -ExpectedStatusCodes @(200) -AccessToken $currentAccessToken
    Add-Result -Results $results -Endpoint "GET /progress/me" -StatusCode $progress.StatusCode
    Assert-True ($null -ne $progress.Json.progress) "Progress response does not contain progress object"
    Assert-True ($null -ne $progress.Json.stats) "Progress response does not contain stats object"

    Write-Step "Logout final session"
    $finalLogout = Invoke-Api -Client $client -Method "POST" -BaseUrl $normalizedBaseUrl -Path "/auth/logout" -ExpectedStatusCodes @(200) -Body @{
        refresh_token = $currentRefreshToken
    }
    Add-Result -Results $results -Endpoint "POST /auth/logout (final)" -StatusCode $finalLogout.StatusCode

    Write-Host ""
    Write-Host "API test run finished successfully." -ForegroundColor Green
    Write-Host "Base URL: $normalizedBaseUrl"
    Write-Host "Temp user: $email"
    Write-Host ""
    $results | Format-Table -AutoSize
}
catch {
    Write-Host ""
    Write-Host "API test run failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    if ($results.Count -gt 0) {
        Write-Host ""
        Write-Host "Completed checks before failure:"
        $results | Format-Table -AutoSize
    }

    exit 1
}
finally {
    $client.Dispose()
}
