begin;

-- =========================================
-- TOPIC: credit_and_debt
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'credit_and_debt'),
           'en',
           'Loans and Debt'
       );

-- =========================================
-- SUBTOPIC 1: what_is_credit
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'what_is_credit'),
           'en',
           'What Is a Loan'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'what_is_credit'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "In life, situations often arise when a certain amount of money is needed immediately: buying equipment, paying for treatment, education, or unexpected expenses."},
               {"type": "paragraph", "text": "If your own funds are not enough, one possible solution is a loan."},
               {"type": "paragraph", "text": "However, it is important to understand that a loan is not just a way to get money now, but a financial obligation that directly affects your future income."}
             ]
           }'::jsonb
       );

-- STEP 2 — EXPLANATION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'what_is_credit'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A loan is money that a bank or financial institution provides to you for temporary use under specific conditions."},
               {"type": "paragraph", "text": "These conditions include:"},
               {"type": "bullet_list", "items": ["repayment term", "interest rate", "payment schedule"]},
               {"type": "paragraph", "text": "The key principle of a loan is repayment with overpayment."},
               {"type": "paragraph", "text": "This means that you repay not only the principal amount of the debt, but also interest — the price of using the money."},
               {"type": "paragraph", "text": "From a financial point of view, a loan can be seen as a tool for reallocating resources over time: you use the money now, and pay for it from future income."},
               {"type": "paragraph", "text": "That is why every loan reduces your financial flexibility in the future and increases your obligations."}
             ]
           }'::jsonb
       );

-- STEP 3 — EXAMPLE
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'what_is_credit'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You take out a loan of 100,000 ₸ for 12 months."},
               {"type": "paragraph", "text": "Over the course of the year, you repay the bank, for example, 120,000 ₸."},
               {"type": "paragraph", "text": "100,000 ₸ — loan principal"},
               {"type": "paragraph", "text": "20,000 ₸ — interest (the cost of the loan)"},
               {"type": "paragraph", "text": "In practice, you are paying for the opportunity to use the money earlier than you could have saved it on your own."}
             ]
           }'::jsonb
       );

-- STEP 4 — CONCLUSION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'what_is_credit'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A loan is a financial tool that allows you to solve a current problem using future income."},
               {"type": "paragraph", "text": "It can be useful if used consciously, but it is always connected with additional costs and obligations."},
               {"type": "paragraph", "text": "Before taking a loan, it is important to assess not only the current need, but also your ability to meet those obligations comfortably in the future."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 2: interest_rate
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'interest_rate'),
           'en',
           'Interest Rate'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_rate'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "When taking out a loan, one of the key parameters is the interest rate."},
               {"type": "paragraph", "text": "It determines how much you will pay for using the money on top of the principal amount."},
               {"type": "paragraph", "text": "Even a small difference in the rate can significantly affect the total overpayment."}
             ]
           }'::jsonb
       );

-- STEP 2 — EXPLANATION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_rate'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "The interest rate is the cost of a loan expressed as a percentage of the borrowed amount over a certain period, usually one year."},
               {"type": "paragraph", "text": "It shows what share of the loan amount you pay to the bank for the opportunity to use its money."},
               {"type": "paragraph", "text": "For example, if the rate is 20% per year, this means that over one year you will pay about 20% of the loan amount as interest, without taking calculation specifics into account."},
               {"type": "paragraph", "text": "It is important to consider that in reality banks use different interest calculation schemes:"},
               {"type": "bullet_list", "items": ["annuity payments (equal monthly payments)", "differentiated payments"]},
               {"type": "paragraph", "text": "In addition, there is an APR-type indicator that includes not only interest, but also additional fees and commissions."},
               {"type": "paragraph", "text": "This indicator gives a more accurate picture of the real cost of the loan."}
             ]
           }'::jsonb
       );

-- STEP 3 — EXAMPLE
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_rate'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You take a loan of 200,000 ₸ at 20% annual interest."},
               {"type": "paragraph", "text": "In a simplified view, you can expect the overpayment for one year to be about 40,000 ₸."},
               {"type": "paragraph", "text": "However, when the real payment schedule and commissions are taken into account, the final amount may be higher."},
               {"type": "paragraph", "text": "For example:"},
               {"type": "bullet_list", "items": ["with one rate, you may repay 240,000 ₸", "with another, as much as 260,000 ₸"]},
               {"type": "paragraph", "text": "The percentage difference may seem small, but in money terms it becomes noticeable."}
             ]
           }'::jsonb
       );

-- STEP 4 — INTERACTIVE
insert into lesson_step_translations (
    lesson_step_id,
    language_code,
    title,
    content,
    interactive_content
)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_rate'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You are given two loan options for the same amount. Choose the one that seems more выгодным based on the total repayment amount."}
             ]
           }'::jsonb,
           '{
             "instruction": "You are given two loan options for the same amount. Choose the one that seems more favorable based on the total repayment amount.",
             "question": "Which loan option is better based on the total repayment amount?",
             "options": [
               {"id": "1", "text": "Option A"},
               {"id": "2", "text": "Option B"}
             ],
             "correctAnswer": "1",
             "data": {
               "variantA": {
                 "amount": "200,000 ₸",
                 "rate": "18%",
                 "totalReturn": "236,000 ₸"
               },
               "variantB": {
                 "amount": "200,000 ₸",
                 "rate": "22%",
                 "totalReturn": "252,000 ₸"
               }
             },
             "explanation": "Both loans are issued for the same amount, but they differ in interest rate. A lower rate reduces the total cost of the loan. In this case, a difference of only a few percentage points leads to a noticeable difference in the total repayment amount."
           }'::jsonb
       );

-- STEP 5 — CONCLUSION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_rate'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "The interest rate is one of the main factors that determines the cost of a loan."},
               {"type": "paragraph", "text": "When choosing a loan, it is important to focus not only on a “low rate,” but on the full cost, including commissions and repayment conditions."},
               {"type": "paragraph", "text": "Even a small reduction in the rate can significantly reduce the total overpayment."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 3: credit_overpayment
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'credit_overpayment'),
           'en',
           'Loan Overpayment'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_overpayment'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "When you take a loan, you return more to the bank than you received."},
               {"type": "paragraph", "text": "This difference is called overpayment, and it shows the real cost of the loan."},
               {"type": "paragraph", "text": "In practice, overpayment is often the factor that people underestimate when applying for a loan."}
             ]
           }'::jsonb
       );

-- STEP 2 — EXPLANATION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_overpayment'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Loan overpayment is the difference between the amount you received and the total amount you eventually repay to the bank."},
               {"type": "paragraph", "text": "It is formed by:"},
               {"type": "bullet_list", "items": ["interest rate", "loan term", "payment scheme", "possible fees and additional charges"]},
               {"type": "paragraph", "text": "The longer the loan term and the higher the interest rate, the greater the total overpayment."},
               {"type": "paragraph", "text": "It is important to understand that even with the same loan amount, the total overpayment can differ greatly depending on the conditions."},
               {"type": "paragraph", "text": "In addition, with annuity payments (equal monthly installments), a significant share of the interest is paid in the first months, which also increases the actual burden on the budget."}
             ]
           }'::jsonb
       );

-- STEP 3 — EXAMPLE
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_overpayment'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You take a loan of 300,000 ₸ for 2 years."},
               {"type": "paragraph", "text": "In the end, you repay the bank 420,000 ₸."},
               {"type": "paragraph", "text": "300,000 ₸ — loan amount"},
               {"type": "paragraph", "text": "120,000 ₸ — overpayment"},
               {"type": "paragraph", "text": "In effect, you pay 40% extra for the opportunity to use the money earlier."},
               {"type": "paragraph", "text": "If the loan term is increased to 3 years, the total amount may rise, for example, to 480,000 ₸."},
               {"type": "paragraph", "text": "The overpayment would then be 180,000 ₸."},
               {"type": "paragraph", "text": "This shows how the term directly affects the total cost of the loan."}
             ]
           }'::jsonb
       );

-- STEP 4 — CONCLUSION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_overpayment'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Overpayment is a key indicator that reflects the real cost of a loan."},
               {"type": "paragraph", "text": "When choosing a loan, it is important to pay attention not only to the size of the monthly payment, but also to the total repayment amount."},
               {"type": "paragraph", "text": "The higher the overpayment, the greater the financial burden in the long term."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 4: credit_load
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'credit_load'),
           'en',
           'Credit Load'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_load'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "When using loans, it is important to consider not only their cost, but also how much they affect your monthly budget."},
               {"type": "paragraph", "text": "Even with a “favorable” rate, a loan can become a problem if the payments take up too large a share of your income."},
               {"type": "paragraph", "text": "That is exactly why the concept of credit load is used."}
             ]
           }'::jsonb
       );

-- STEP 2 — EXPLANATION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_load'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Credit load is the share of your income that goes toward repaying all loans and debts."},
               {"type": "paragraph", "text": "It is calculated as the ratio of monthly loan payments to your income."},
               {"type": "paragraph", "text": "In simplified form:"},
               {"type": "paragraph", "text": "credit load = (monthly payments / income) × 100%"},
               {"type": "paragraph", "text": "For example: if you earn 300,000 ₸ and pay 90,000 ₸ per month on loans, your credit load is 30%."},
               {"type": "paragraph", "text": "In financial practice, it is usually considered that:"},
               {"type": "bullet_list", "items": ["up to 30% — safe level", "30–50% — elevated burden", "more than 50% — high risk of financial problems"]},
               {"type": "paragraph", "text": "The higher the credit load, the less money remains for daily expenses, savings, and unexpected situations."}
             ]
           }'::jsonb
       );

-- STEP 3 — EXAMPLE
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_load'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Your monthly income is 250,000 ₸."},
               {"type": "paragraph", "text": "You pay:"},
               {"type": "bullet_list", "items": ["40,000 ₸ on one loan", "30,000 ₸ on another"]},
               {"type": "paragraph", "text": "Total payment: 70,000 ₸"},
               {"type": "paragraph", "text": "Credit load:"},
               {"type": "paragraph", "text": "70,000 / 250,000 × 100% = 28%"},
               {"type": "paragraph", "text": "This is close to a safe level, but if obligations increase, the situation can quickly worsen."}
             ]
           }'::jsonb
       );

-- STEP 4 — INTERACTIVE
insert into lesson_step_translations (
    lesson_step_id,
    language_code,
    title,
    content,
    interactive_content
)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_load'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Calculate your credit load if your monthly income is 300,000 ₸ and your total monthly loan payments are 120,000 ₸."}
             ]
           }'::jsonb,
           '{
             "instruction": "Calculate your credit load if your monthly income is 300,000 ₸ and your total monthly loan payments are 120,000 ₸.",
             "fields": [
               {"id": "credit_load_percent", "label": "Credit load (%)"}
             ],
             "validation": {
               "formula": "(120000 / 300000) * 100",
               "expectedValue": 40
             },
             "exampleAnswer": {
               "credit_load_percent": 40
             },
             "explanation": "In this case, 40% of income goes to loans. This is already an elevated burden level, where less financial flexibility remains and the risk of problems grows if income decreases or additional expenses appear."
           }'::jsonb
       );

-- STEP 5 — CONCLUSION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'credit_load'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Credit load shows how much your loans affect your budget."},
               {"type": "paragraph", "text": "Even if each individual loan seems manageable, their combined effect can create significant pressure on your finances."},
               {"type": "paragraph", "text": "Before taking a new loan, it is important to consider your current burden and assess whether financial stability will remain in the future."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 5: choose_credit
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'choose_credit'),
           'en',
           'How to Choose a Loan'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'choose_credit'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "There are many loan offers on the market, and at first glance they may look similar."},
               {"type": "paragraph", "text": "However, differences in conditions can significantly affect the total cost of the loan and your financial burden."},
               {"type": "paragraph", "text": "That is why choosing a loan requires a careful and informed approach."}
             ]
           }'::jsonb
       );

-- STEP 2 — EXPLANATION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'choose_credit'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "When choosing a loan, it is important to consider not just one parameter, but the overall set of conditions."},
               {"type": "paragraph", "text": "The main factors to pay attention to are:"},
               {"type": "bullet_list", "items": [
                 "Interest rate — determines the basic cost of the loan. The lower the rate, the smaller the overpayment.",
                 "APR-type effective annual rate — shows the real cost of the loan, taking into account all fees and additional charges. This indicator gives the most accurate picture of the expenses.",
                 "Loan term — a longer term reduces the monthly payment, but increases the total overpayment.",
                 "Monthly payment amount — it is important that it does not create excessive pressure on the budget and still leaves room for other expenses.",
                 "Additional commissions — some loans include fees for application processing, servicing, or early repayment.",
                 "Early repayment conditions — flexible terms allow you to reduce the overpayment if you get the opportunity to repay the loan earlier."
               ]},
               {"type": "paragraph", "text": "It is important to compare several offers rather than choosing the first available one."},
               {"type": "paragraph", "text": "Even small differences in conditions can lead to a significant difference in the total amount repaid."}
             ]
           }'::jsonb
       );

-- STEP 3 — EXAMPLE
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'choose_credit'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You are considering two loan options for 300,000 ₸:"},
               {"type": "paragraph", "text": "Option A:"},
               {"type": "bullet_list", "items": ["Rate: 18%", "Term: 2 years", "Total amount: 390,000 ₸"]},
               {"type": "paragraph", "text": "Option B:"},
               {"type": "bullet_list", "items": ["Rate: 20%", "Term: 3 years", "Total amount: 450,000 ₸"]},
               {"type": "paragraph", "text": "Despite the lower monthly payment in the second option, the total overpayment is much higher."},
               {"type": "paragraph", "text": "This shows that it is not enough to focus only on the payment amount."}
             ]
           }'::jsonb
       );

-- STEP 4 — CONCLUSION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'choose_credit'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Choosing a loan should be based on analyzing the full cost, not just individual parameters."},
               {"type": "paragraph", "text": "It is important to consider the interest rate, term, fees, and your own credit load."},
               {"type": "paragraph", "text": "An informed choice helps reduce overpayment and preserve long-term financial stability."}
             ]
           }'::jsonb
       );

commit;