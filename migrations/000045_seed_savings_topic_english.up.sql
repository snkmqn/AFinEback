begin;

-- =========================================
-- TOPIC: savings
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'savings'),
           'en',
           'Savings'
       );

-- =========================================
-- SUBTOPIC 1: why_save
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'why_save'),
           'en',
           'Why Save Money'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'why_save'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Many people live from paycheck to paycheck, spending all of their income on current needs. In this model, there is no room for savings, and any unexpected expense becomes a problem."},
               {"type": "paragraph", "text": "Over time, this leads to dependence on borrowing and constant financial stress."}
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
               where s.code = 'why_save'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Savings are a part of income that is not spent immediately but set aside for the future."},
               {"type": "paragraph", "text": "They serve several important functions:"},
               {"type": "bullet_list", "items": [
                 "protection against unexpected situations",
                 "achieving financial goals",
                 "reducing stress",
                 "building financial independence"
               ]},
               {"type": "paragraph", "text": "Even small amounts saved regularly can gradually turn into significant capital."},
               {"type": "paragraph", "text": "In Kazakhstan, many people face situations where they urgently need to pay for medical treatment, car repairs, or help relatives. Having savings makes it possible to handle such situations without debt."}
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
               where s.code = 'why_save'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Suppose a person earns 250,000 ₸ per month and saves 10%."},
               {"type": "table", "headers": ["Period", "Savings"], "rows": [
                 ["1 month", "25,000 ₸"],
                 ["6 months", "150,000 ₸"],
                 ["12 months", "300,000 ₸"]
               ]},
               {"type": "paragraph", "text": "Even without interest, a meaningful amount is built over the course of a year."}
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
               where s.code = 'why_save'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Saving money is not about refusing to live — it is about having control over your life."},
               {"type": "paragraph", "text": "Regular savings provide confidence in the future and allow you to make decisions without financial pressure."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 2: emergency_fund
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'emergency_fund'),
           'en',
           'Emergency Fund'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'emergency_fund'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Many people start thinking about savings only when a problem has already appeared: urgent medical treatment, a broken appliance, loss of work, or a delay in income."},
               {"type": "paragraph", "text": "In such a situation, the absence of a reserve of money quickly leads to stress, debt, or the need to borrow from relatives and friends."}
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "An emergency fund is a reserve of money for unexpected situations."},
               {"type": "paragraph", "text": "Its purpose is to temporarily cover a person’s essential expenses if their usual income decreases or disappears."},
               {"type": "paragraph", "text": "It is usually recommended to have an amount equal to 3–6 months of expenses:"},
               {"type": "bullet_list", "items": [
                 "3 months — the minimum safety level",
                 "6 months — a more stable option"
               ]},
               {"type": "paragraph", "text": "An emergency fund is not created for major purchases, vacations, or impulsive spending. It is specifically a reserve for difficult life situations."},
               {"type": "paragraph", "text": "In Kazakhstan, an emergency fund is especially important because many families depend on a single salary, and unexpected expenses — medical treatment, car repair, moving, helping relatives — can arise at any moment."}
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Suppose a person lives in Astana and spends each month:"},
               {"type": "table", "headers": ["Category", "Amount"], "rows": [
                 ["Rent", "180,000 ₸"],
                 ["Food", "80,000 ₸"],
                 ["Transportation", "20,000 ₸"],
                 ["Utilities", "20,000 ₸"],
                 ["Other expenses", "20,000 ₸"],
                 ["Total", "320,000 ₸"]
               ]},
               {"type": "paragraph", "text": "Then the emergency fund would be:"},
               {"type": "bullet_list", "items": [
                 "minimum: 320,000 × 3 = 960,000 ₸",
                 "comfortable: 320,000 × 6 = 1,920,000 ₸"
               ]},
               {"type": "paragraph", "text": "This does not mean that such an amount must be saved immediately. It is important to understand the goal and move toward it gradually."}
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Calculate the minimum and comfortable emergency fund if monthly expenses are 160,000 ₸."}
             ]
           }'::jsonb,
           '{
             "instruction": "Calculate the minimum and comfortable emergency fund if monthly expenses are 160,000 ₸.",
             "fields": [
               {"id": "minimum_fund", "label": "Minimum fund"},
               {"id": "comfortable_fund", "label": "Comfortable fund"}
             ],
             "validation": {
               "rules": [
                 "Minimum fund = expenses × 3",
                 "Comfortable fund = expenses × 6"
               ],
               "expectedValues": {
                 "minimum_fund": 480000,
                 "comfortable_fund": 960000
               }
             },
             "exampleAnswer": {
               "minimum_fund": 480000,
               "comfortable_fund": 960000
             },
             "explanation": "An emergency fund is calculated based on monthly expenses, not income. The minimum reserve covers 3 months, and the more reliable one covers 6 months."
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "An emergency fund does not provide immediate benefit, but it creates stability and reduces financial vulnerability."},
               {"type": "paragraph", "text": "Even small regular savings gradually build a reserve that helps you get through a difficult period without debt and unnecessary stress."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 3: how_to_save
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'how_to_save'),
           'en',
           'How to Start Saving'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'how_to_save'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Many people think that saving is only possible with a high income. In practice, this is not true — what matters more is not the amount, but the habit."},
               {"type": "paragraph", "text": "Even with a modest income, it is possible to start building savings."}
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
               where s.code = 'how_to_save'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "To start saving money, it is important to follow several principles:"},
               {"type": "bullet_list", "items": [
                 "save first, then spend",
                 "choose a fixed percentage of income",
                 "do it regularly",
                 "keep the money separately"
               ]},
               {"type": "paragraph", "text": "It is often recommended to save 10–20% of income, but you can start even with 5%."},
               {"type": "paragraph", "text": "The main thing is consistency."},
               {"type": "paragraph", "text": "In Kazakhstan, several simple tools can be used for saving:"},
               {"type": "bullet_list", "items": [
                 "a regular bank account (card) — suitable for the initial stage, money is always accessible",
                 "a savings account — allows you to keep money separately and sometimes earn a small amount of interest",
                 "a bank deposit — money is placed for a specific period and earns interest income (usually higher than on regular accounts)",
                 "automatic transfers — many banking apps allow you to set up regular transfers of part of your income to a separate account"
               ]},
               {"type": "paragraph", "text": "Such tools help separate money “for life” from money “for savings,” which makes control much easier."}
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
               where s.code = 'how_to_save'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A person earns 200,000 ₸ and decides to save 10%."},
               {"type": "paragraph", "text": "Each month:"},
               {"type": "paragraph", "text": "200,000 × 0.10 = 20,000 ₸"},
               {"type": "paragraph", "text": "Over one year:"},
               {"type": "paragraph", "text": "20,000 × 12 = 240,000 ₸"},
               {"type": "paragraph", "text": "Even without increasing income, a meaningful amount is built."}
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
               where s.code = 'how_to_save'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You can start saving with any amount."},
               {"type": "paragraph", "text": "Regularity and discipline matter much more than the size of the contribution."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 4: interest_on_savings
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'interest_on_savings'),
           'en',
           'Interest on Savings'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_on_savings'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "When a person starts saving money, the next question arises: is it possible not only to keep the amount, but also to increase it a little?"},
               {"type": "paragraph", "text": "One simple way is to place money in a savings product where interest is accrued."}
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Interest on savings shows what additional income can be earned from the initial amount."},
               {"type": "paragraph", "text": "In the simplest case, the simple interest model is used. This means that interest is calculated only on the original principal amount."},
               {"type": "paragraph", "text": "Formula:"},
               {"type": "paragraph", "text": "I = P × r × t"},
               {"type": "paragraph", "text": "Where:"},
               {"type": "bullet_list", "items": [
                 "I — interest income",
                 "P — principal amount",
                 "r — annual interest rate",
                 "t — time in years"
               ]},
               {"type": "paragraph", "text": "This calculation helps explain the basic principle of growth in savings."},
               {"type": "paragraph", "text": "In Kazakhstan, the topic of savings is especially relevant because many people keep money simply on a bank card or in cash, without realizing that even a small interest rate helps partially compensate for the loss of purchasing power over time."}
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Suppose a person places 120,000 ₸ at 10% annual interest for 1 year."},
               {"type": "paragraph", "text": "Let us calculate the income:"},
               {"type": "paragraph", "text": "120,000 × 0.10 × 1 = 12,000 ₸"},
               {"type": "paragraph", "text": "So:"},
               {"type": "bullet_list", "items": [
                 "interest income = 12,000 ₸",
                 "total amount = 132,000 ₸"
               ]}
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Calculate the income and final amount if 200,000 ₸ are placed at 5% annual interest for 2 years."}
             ]
           }'::jsonb,
           '{
             "instruction": "Calculate the income and final amount if 200,000 ₸ are placed at 5% annual interest for 2 years.",
             "fields": [
               {"id": "interest_income", "label": "Income"},
               {"id": "total_amount", "label": "Final amount"}
             ],
             "validation": {
               "rules": [
                 "Income = 200000 × 0.05 × 2",
                 "Final amount = principal amount + income"
               ],
               "expectedValues": {
                 "interest_income": 20000,
                 "total_amount": 220000
               }
             },
             "exampleAnswer": {
               "interest_income": 20000,
               "total_amount": 220000
             },
             "explanation": "Note that the period is 2 years, so the interest is multiplied by time. Interest is calculated only on the original principal amount."
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Simple interest is a basic and clear way to show how savings can generate additional income."},
               {"type": "paragraph", "text": "Even if the amount seems small, this type of calculation develops useful financial thinking: money can be not only spent, but also gradually increased."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 5: saving_mistakes
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'saving_mistakes'),
           'en',
           'Mistakes in Saving'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'saving_mistakes'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Even when people want to save money, many find that savings do not build up or disappear quickly."},
               {"type": "paragraph", "text": "Most often, the reason is not income, but behavioral mistakes."}
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
               where s.code = 'saving_mistakes'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Common mistakes in saving include:"},
               {"type": "bullet_list", "items": [
                 "lack of a specific goal",
                 "irregular contributions",
                 "saving only what is left over",
                 "using savings for everyday expenses",
                 "setting the bar too high"
               ]},
               {"type": "paragraph", "text": "These mistakes interfere with the formation of a habit and reduce motivation."},
               {"type": "paragraph", "text": "In Kazakhstan, a common situation is when savings are spent on unplanned purchases or helping relatives without taking one’s own financial capacity into account."}
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
               where s.code = 'saving_mistakes'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A person plans to save 30,000 ₸ per month, but:"},
               {"type": "bullet_list", "items": [
                 "skips one month",
                 "spends part of the savings in another month",
                 "reduces the amount in a third month"
               ]},
               {"type": "paragraph", "text": "As a result, the expected outcome does not form over the course of the year."}
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
               where s.code = 'saving_mistakes'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Mistakes in saving are more often related to behavior than to mathematics."},
               {"type": "paragraph", "text": "Recognizing these mistakes helps build a sustainable financial habit."}
             ]
           }'::jsonb
       );

commit;