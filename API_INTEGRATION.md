# API Integration Notes for Flutter

This document is based on the current Go backend code in this repository.

## Base conventions

- Base path for every endpoint: `/api`
- Auth for protected endpoints: `Authorization: Bearer <access_token>`
- Content type: `application/json`
- Error format:

```json
{
  "error": {
    "code": "SOME_ERROR_CODE"
  }
}
```

- Timestamps are standard Go `time.Time` JSON values, so expect RFC3339 strings, for example:

```json
"2026-05-01T12:34:56Z"
```

## Important integration quirks

1. JSON naming is inconsistent across modules:
   - `auth`, `assessment`, `progress` mostly use `snake_case`
   - `content` responses use `camelCase`
   - `profile/settings` requests use `snake_case`, but responses use `camelCase`
2. `lang` query param is supported only on content and assessment read endpoints.
   - Supported values: `ru`, `kk`, `en`
   - If omitted or invalid, backend silently falls back to `kk`
3. There is no public endpoint for questionnaire option dictionaries, even though the service has that logic internally.
4. `profile/settings` enum validation is not consistently mapped to clean 4xx API errors right now. Invalid enum values may end up as `500 INTERNAL_ERROR` instead of the declared domain codes.

## Common auth errors on protected routes

Possible auth middleware errors:

- `401 MISSING_TOKEN`
- `401 INVALID_TOKEN_FORMAT`
- `401 INVALID_TOKEN`
- `401 UNAUTHORIZED` for handlers that fail to read user from context

---

## 1. Auth

### `POST /api/auth/register`

Creates a local account.

Request:

```json
{
  "email": "user@example.com",
  "username": "John",
  "password": "pass123"
}
```

Success: `201 Created`

```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "John",
    "is_active": true
  },
  "access_token": "jwt",
  "refresh_token": "refresh-token"
}
```

Known business errors:

- `400 EMPTY_USERNAME`
- `400 USERNAME_TOO_SHORT`
- `400 USERNAME_TOO_LONG`
- `400 USERNAME_BAD_SYMBOLS`
- `400 EMPTY_EMAIL`
- `400 INVALID_EMAIL_FORMAT`
- `400 EMPTY_PASSWORD`
- `400 PASSWORD_TOO_SHORT`
- `400 PASSWORD_MUST_HAVE_DIGIT`
- `400 PASSWORD_INVALID_CHARS`
- `409 EMAIL_ALREADY_EXISTS`
- `400 INVALID_REQUEST` for malformed JSON

Validation details:

- `username`: normalized trim/spaces, length `2..20`
- `password`: min length `5`, must contain at least one digit, no spaces, commas, or unsupported chars

### `POST /api/auth/login`

Request:

```json
{
  "email": "user@example.com",
  "password": "pass123"
}
```

Success: `200 OK`

```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "John",
    "is_active": true
  },
  "access_token": "jwt",
  "refresh_token": "refresh-token"
}
```

Known business errors:

- `400 EMPTY_EMAIL`
- `400 INVALID_EMAIL_FORMAT`
- `400 EMPTY_PASSWORD`
- `400 PASSWORD_TOO_SHORT`
- `400 PASSWORD_MUST_HAVE_DIGIT`
- `400 PASSWORD_INVALID_CHARS`
- `401 INVALID_CREDENTIALS`
- `403 INACTIVE_USER`
- `429 TOO_MANY_LOGIN_ATTEMPTS`
- `400 INVALID_REQUEST`

Behavior note:

- After 5 failed password attempts, login is blocked for 20 minutes.

### `POST /api/auth/google`

Uses a Google ID token from the client. Send the Google `id_token`, not a Google access token.

Request:

```json
{
  "id_token": "google-id-token"
}
```

Success: `200 OK`

```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "John",
    "is_active": true
  },
  "access_token": "jwt",
  "refresh_token": "refresh-token"
}
```

Known business errors:

- `401 INVALID_GOOGLE_TOKEN`
- `403 GOOGLE_EMAIL_NOT_VERIFIED`
- `403 INACTIVE_USER`
- `409 GOOGLE_EMAIL_ALREADY_EXISTS`
- `400 INVALID_REQUEST`

### `POST /api/auth/refresh`

Request:

```json
{
  "refresh_token": "refresh-token"
}
```

Success: `200 OK`

```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "John",
    "is_active": true
  },
  "access_token": "new-jwt",
  "refresh_token": "new-refresh-token"
}
```

Known business errors:

- `401 INVALID_REFRESH_TOKEN`
- `401 REFRESH_TOKEN_EXPIRED`
- `401 REFRESH_TOKEN_REVOKED`
- `403 INACTIVE_USER`
- `400 INVALID_REQUEST`

Behavior note:

- Refresh revokes the old refresh token and issues a new one.

### `POST /api/auth/logout`

No bearer token required. Logout is driven by refresh token.

Request:

```json
{
  "refresh_token": "refresh-token"
}
```

Success: `200 OK`

```json
{
  "message": "LOGGED_OUT"
}
```

Known business errors:

- `401 INVALID_REFRESH_TOKEN`
- `401 REFRESH_TOKEN_EXPIRED`
- `401 REFRESH_TOKEN_REVOKED`
- `400 INVALID_REQUEST`

### `GET /api/auth/me`

Protected.

Success: `200 OK`

```json
{
  "id": 1,
  "email": "user@example.com",
  "username": "John",
  "is_active": true
}
```

### `PATCH /api/auth/me/username`

Protected.

Request:

```json
{
  "new_username": "New Name"
}
```

Success: `200 OK`

```json
{
  "id": 1,
  "email": "user@example.com",
  "username": "New Name",
  "is_active": true
}
```

Known business errors:

- `400 EMPTY_USERNAME`
- `400 USERNAME_TOO_SHORT`
- `400 USERNAME_TOO_LONG`
- `400 USERNAME_BAD_SYMBOLS`
- `400 USERNAME_SAME_AS_CURRENT`
- `400 INVALID_REQUEST`

### `PATCH /api/auth/me/password`

Protected.

Request:

```json
{
  "current_password": "old123",
  "new_password": "new123",
  "refresh_token": "current-device-refresh-token"
}
```

Success: `200 OK`

```json
{
  "message": "PASSWORD_CHANGED"
}
```

Known business errors:

- `401 INVALID_CREDENTIALS`
- `401 INVALID_REFRESH_TOKEN`
- `401 REFRESH_TOKEN_EXPIRED`
- `401 REFRESH_TOKEN_REVOKED`
- `400 PASSWORD_TOO_SHORT`
- `400 PASSWORD_MUST_HAVE_DIGIT`
- `400 PASSWORD_INVALID_CHARS`
- `400 PASSWORD_SAME_AS_CURRENT`
- `400 INVALID_REQUEST`

Behavior note:

- Password change revokes all other refresh tokens for the user except the one passed in the request.

---

## 2. Profile

## Allowed profile values

- `financial_literacy_level`: `beginner`, `basic`, `intermediate`, `advanced`
- `practical_experience`: `no_experience`, `tracks_expenses`, `plans_budget`, `manages_finances`
- `learning_goal`: `general_improvement`, `saving_money`, `debt_management`, `financial_planning`, `increase_income`, `control_spending`, `understand_banking`, `start_investing`, `other`
- `preferred_language`: `ru`, `kk`, `en`
- `time_commitment`: `5_min`, `10_min`, `15_min`, `20_plus_min`
- `preferred_topics`: `budgeting`, `savings`, `credits_and_debts`, `financial_planning`, `investing`

## Allowed settings values

- `theme`: `light`, `dark`, `system`
- `language_code`: `ru`, `kk`, `en`
- `reminder_time`: DB `TIME`, so use `HH:MM:SS` unless backend is changed

### `GET /api/profile/me`

Protected.

Success: `200 OK`

```json
{
  "userId": 1,
  "financialLiteracyLevel": "beginner",
  "practicalExperience": "no_experience",
  "learningGoal": "saving_money",
  "preferredLanguage": "kk",
  "timeCommitment": "10_min",
  "preferredTopics": ["budgeting", "savings"],
  "onboardingCompleted": true
}
```

Known business errors:

- `404 PROFILE_NOT_FOUND`

### `PUT /api/profile/me`

Protected.

Request uses `snake_case`:

```json
{
  "financial_literacy_level": "beginner",
  "practical_experience": "no_experience",
  "learning_goal": "saving_money",
  "preferred_language": "kk",
  "time_commitment": "10_min",
  "preferred_topics": ["budgeting", "savings"]
}
```

Success: `200 OK`

Response uses `camelCase`:

```json
{
  "userId": 1,
  "financialLiteracyLevel": "beginner",
  "practicalExperience": "no_experience",
  "learningGoal": "saving_money",
  "preferredLanguage": "kk",
  "timeCommitment": "10_min",
  "preferredTopics": ["budgeting", "savings"],
  "onboardingCompleted": true
}
```

Known business errors:

- `400 PREFERRED_TOPICS_REQUIRED`
- `400 INVALID_REQUEST`

Behavior notes:

- Creates the profile if it does not exist, otherwise updates it
- Also creates default user settings if missing
- Also syncs settings language with `preferred_language`

### `GET /api/profile/settings`

Protected.

Success: `200 OK`

```json
{
  "userId": 1,
  "languageCode": "kk",
  "theme": "system",
  "notificationsEnabled": true,
  "reminderTime": "09:00:00"
}
```

`reminderTime` can be `null`.

Known business errors:

- `404 SETTINGS_NOT_FOUND`

### `PATCH /api/profile/settings`

Protected.

Request uses `snake_case`. All fields are optional.

```json
{
  "language_code": "en",
  "theme": "dark",
  "notifications_enabled": true,
  "reminder_time": "21:30:00"
}
```

Success: `200 OK`

```json
{
  "userId": 1,
  "languageCode": "en",
  "theme": "dark",
  "notificationsEnabled": true,
  "reminderTime": "21:30:00"
}
```

Behavior notes:

- Creates settings with defaults if they do not exist
- If `language_code` is passed, backend also syncs profile preferred language

Known business errors:

- `400 INVALID_REQUEST`
- `404 PROFILE_NOT_FOUND` can happen when `language_code` is passed but profile is absent

Backend risk:

- Invalid enum/time values are intended to have domain errors, but current implementation may return `500 INTERNAL_ERROR` instead.

---

## 3. Content

All content endpoints are protected and support `?lang=ru|kk|en`. Invalid or missing `lang` becomes `kk`.

### `GET /api/content/topics`

Success: `200 OK`

```json
[
  {
    "code": "budgeting",
    "level": "beginner",
    "orderIndex": 1,
    "title": "Budgeting",
    "description": "Optional description"
  }
]
```

### `GET /api/content/topics/{topicCode}/subtopics`

Success: `200 OK`

```json
[
  {
    "code": "income_expenses",
    "orderIndex": 1,
    "estimatedMinutes": 5,
    "title": "Income and expenses",
    "description": "Optional description"
  }
]
```

Known business errors:

- `400 INVALID_TOPIC_CODE`
- `404 TOPIC_NOT_FOUND`

### `GET /api/content/subtopics/{subtopicCode}/lesson`

Success: `200 OK`

```json
{
  "lessonId": 1,
  "topicCode": "budgeting",
  "topicTitle": "Budgeting",
  "topicLevel": "beginner",
  "subtopicCode": "income_expenses",
  "subtopicTitle": "Income and expenses",
  "steps": [
    {
      "id": 11,
      "stepType": "introduction",
      "orderIndex": 1,
      "title": "Introduction",
      "content": {
        "blocks": [
          {
            "type": "paragraph",
            "text": "..."
          }
        ]
      }
    }
  ]
}
```

Known business errors:

- `400 INVALID_SUBTOPIC_CODE`
- `404 LESSON_NOT_FOUND`

### Content rendering notes

Observed `stepType` values in seeded content:

- `introduction`
- `explanation`
- `example`
- `interactive`
- `conclusion`

Observed `content.blocks[].type` values:

- `paragraph`
- `bullet_list`
- `table`

Observed interactive step types:

- `drag_drop`
- `single_choice`
- `input_numbers`
- `input_text`

For interactive steps:

- `interactiveType` defines the widget type
- `interactiveContent` shape depends on that type
- `content` is still present and usually contains explanatory blocks

Observed `interactiveContent` patterns:

- `drag_drop`: `instruction`, `categories`, `items`, `answers`
- `single_choice`: `instruction`, `question`, `options`, `correctAnswer`, `data`, `explanation`
- `input_numbers`: `instruction`, `fields`, `validation`, `exampleAnswer`, `explanation`
- `input_text`: `instruction`, `fields`, `validation`, `exampleAnswer`, `explanation`

The backend currently treats `content` and `interactiveContent` as raw JSON blobs. There is no typed schema endpoint for them.

---

## 4. Assessment

All assessment endpoints are protected.

Read endpoints support `?lang=ru|kk|en`. Invalid or missing `lang` becomes `kk`.

### Quiz types

- `subtopic_quiz`
- `topic_final_quiz`

### Question types

- `single_choice`
- `multiple_choice`
- `true_false`

### `GET /api/assessment/quizzes/{quizId}`

Returns the full quiz definition with all questions and options.

Success: `200 OK`

```json
{
  "id": 10,
  "quiz_type": "subtopic_quiz",
  "subtopic_code": "income_expenses",
  "title": "Income and expenses quiz",
  "passing_score": 50,
  "time_limit_seconds": null,
  "questions": [
    {
      "id": 101,
      "question_type": "single_choice",
      "order_index": 1,
      "question_text": "Question text",
      "options": [
        {
          "id": 1001,
          "order_index": 1,
          "text": "Option"
        }
      ]
    }
  ]
}
```

Known business errors:

- `400 INVALID_QUIZ_ID`
- `404 QUIZ_NOT_FOUND`

Field note:

- `subtopic_code` and `topic_code` are optional and may be omitted from JSON, not returned as `null`

### `POST /api/assessment/quizzes/{quizId}/start`

Starts an attempt and returns a randomized subset of questions for that attempt.

Request body: empty

Success: `201 Created`

```json
{
  "attempt_id": 555,
  "quiz_id": 10,
  "quiz_type": "subtopic_quiz",
  "title": "Income and expenses quiz",
  "total_questions": 2,
  "questions": [
    {
      "id": 101,
      "question_type": "single_choice",
      "order_index": 1,
      "question_text": "Question text",
      "options": [
        {
          "id": 1001,
          "order_index": 1,
          "text": "Option"
        }
      ]
    }
  ]
}
```

Known business errors:

- `400 INVALID_QUIZ_ID`
- `404 QUIZ_NOT_FOUND`
- `400 NOT_ENOUGH_QUIZ_QUESTIONS`

Behavior notes:

- `subtopic_quiz`: backend selects random questions by topic level
  - `beginner` / `basic` => 2 questions
  - `intermediate` / `advanced` => 3 questions
- `topic_final_quiz` => 10 random questions
- Attempt is created immediately with status `in_progress`

### `POST /api/assessment/attempts/{attemptId}/submit`

Submits the current attempt.

Request:

```json
{
  "duration_seconds": 180,
  "answers": [
    {
      "question_id": 101,
      "selected_option_ids": [1001]
    },
    {
      "question_id": 102,
      "selected_option_ids": [1004, 1005]
    }
  ]
}
```

Success: `200 OK`

```json
{
  "attempt_id": 555,
  "quiz_id": 10,
  "score_percent": 50,
  "total_questions": 2,
  "correct_answers": 1,
  "wrong_answers": 1,
  "passed": true,
  "xp_for_score": 10,
  "submitted_at": "2026-05-01T12:34:56Z"
}
```

Known business errors:

- `400 INVALID_ATTEMPT_ID`
- `404 ATTEMPT_NOT_FOUND`
- `400 INCOMPLETE_QUIZ_ATTEMPT`
- `400 DUPLICATE_QUESTION_IN_ATTEMPT`
- `400 EMPTY_SELECTED_OPTIONS`
- `400 INVALID_SELECTED_OPTIONS_COUNT`
- `400 INVALID_ATTEMPT_QUESTION`
- `400 INVALID_OPTION_ID`
- `400 ATTEMPT_ALREADY_COMPLETED`
- `400 ATTEMPT_NOT_IN_PROGRESS`
- `400 ATTEMPT_EXPIRED`
- `400 INVALID_REQUEST`

Behavior notes:

- `duration_seconds < 0` is coerced to `0`
- Single-choice and true/false must contain exactly one selected option
- Multiple-choice must match the full correct set to count as correct
- Attempt expires after 30 minutes from `start`
- Submitting a completed attempt is rejected
- On successful submit, progress service is updated

XP rules:

- `subtopic_quiz`
  - `100%` => `15`
  - `50..99%` => `10`
  - `<50%` => `5`
- `topic_final_quiz`
  - `>=75%` => `50`
  - `<75%` => `10`

### `GET /api/assessment/quizzes/{quizId}/latest-attempt`

Returns only the latest completed attempt for this user and quiz.

Success with no attempts:

```json
{
  "has_attempt": false,
  "attempt": null
}
```

Success with data:

```json
{
  "has_attempt": true,
  "attempt": {
    "attempt_id": 555,
    "quiz_id": 10,
    "score_percent": 100,
    "total_questions": 2,
    "correct_answers": 2,
    "wrong_answers": 0,
    "passed": true,
    "xp_for_score": 15,
    "submitted_at": "2026-05-01T12:34:56Z"
  }
}
```

Known business errors:

- `400 INVALID_QUIZ_ID`

### `GET /api/assessment/attempts/{attemptId}`

Returns detailed data for a completed attempt only.

Success: `200 OK`

```json
{
  "attempt_id": 555,
  "quiz_id": 10,
  "score_percent": 100,
  "total_questions": 2,
  "correct_answers": 2,
  "wrong_answers": 0,
  "passed": true,
  "xp_for_score": 15,
  "submitted_at": "2026-05-01T12:34:56Z",
  "answers": [
    {
      "question_id": 101,
      "question_text": "Question text",
      "question_type": "single_choice",
      "order_index": 1,
      "selected_options": [
        {
          "option_id": 1001,
          "text": "Option A",
          "is_correct": true
        }
      ],
      "correct_options": [
        {
          "option_id": 1001,
          "text": "Option A"
        }
      ],
      "is_question_correct": true
    }
  ]
}
```

Known business errors:

- `400 INVALID_ATTEMPT_ID`
- `404 ATTEMPT_NOT_FOUND`

Behavior note:

- In-progress attempts are not returned here. Only completed attempts are queryable.

---

## 5. Progress

### `GET /api/progress/me`

Protected.

Success: `200 OK`

```json
{
  "progress": {
    "total_xp": 60,
    "progress_level": "amateur",
    "last_activity_at": "2026-05-01T12:34:56Z"
  },
  "stats": {
    "total_quiz_attempts": 8,
    "completed_quizzes_count": 5,
    "completed_subtopic_quizzes_count": 4,
    "completed_topic_final_quizzes_count": 1,
    "completed_subtopics_count": 4,
    "completed_topics_count": 1,
    "average_best_score_percent": 78.5,
    "average_all_attempts_score_percent": 71.25,
    "max_score_quizzes_count": 2,
    "best_topic_code": "budgeting",
    "weakest_topic_code": "investing",
    "last_quiz_completed_at": "2026-05-01T12:34:56Z"
  }
}
```

Possible `progress_level` values:

- `beginner`
- `amateur`
- `practitioner`
- `advanced_learner`

Behavior notes:

- Backend auto-creates a zeroed progress row if missing
- `best_topic_code`, `weakest_topic_code`, `last_activity_at`, `last_quiz_completed_at` may be omitted from JSON when absent
- Score averages are JSON numbers and come from DB numeric values

---

## Suggested Flutter modeling notes

1. Do not use one global snake/camel serializer assumption. Model each endpoint explicitly.
2. Treat content `content` and `interactiveContent` as `Map<String, dynamic>`.
3. Store both `access_token` and `refresh_token`.
4. Use `refresh_token` for:
   - refresh flow
   - logout
   - password change
5. For quizzes, use `POST /start` result as the source of truth for what the user must answer. Do not submit answers based on the full quiz from `GET /quizzes/{quizId}`.
6. Treat `latest-attempt` and `attempt detail` as history endpoints for completed attempts only.

## Missing public endpoints

These capabilities exist in code but are not exposed by router:

- questionnaire option dictionaries for onboarding
