begin;

-- =========================================
-- TOPIC: budgeting
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'budgeting'),
           'en',
           'Budgeting'
       );

-- =========================================
-- SUBTOPIC 1: income_expenses
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'income_expenses'),
           'en',
           'Income and Expenses'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'income_expenses'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Many people in Kazakhstan say the same thing: “I have a salary, but I still never have enough money.” At first glance, the income seems normal. So the question is: what is the reason?"},
               {"type": "paragraph", "text": "Most often, the problem is that a person does not understand where the money is going. They spend throughout the month, do not track expenses, and by the end they are left with an empty balance."}
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
               where s.code = 'income_expenses'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "The first step is to divide all money into two parts."},
               {"type": "paragraph", "text": "Income is everything that comes to you:"},
               {"type": "bullet_list", "items": ["salary", "side jobs", "bonuses", "transfers", "rental income"]},
               {"type": "paragraph", "text": "Expenses are everything that goes out:"},
               {"type": "bullet_list", "items": ["rent", "food", "transportation", "utility bills", "purchases", "subscriptions"]},
               {"type": "paragraph", "text": "In practice, most people know their income, but cannot accurately name the total amount of their expenses."}
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
               where s.code = 'income_expenses'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Suppose a person lives in Astana and earns 300,000 ₸ per month."},
               {"type": "paragraph", "text": "Now let’s look at the expenses:"},
               {
                 "type": "table",
                 "headers": ["Category", "Amount"],
                 "rows": [
                   ["One-room apartment rent", "200,000 ₸"],
                   ["Food", "90,000 ₸"],
                   ["Taxi and transportation", "30,000 ₸"],
                   ["Subscriptions", "10,000 ₸"],
                   ["Small everyday expenses", "40,000 ₸"],
                   ["Total expenses", "370,000 ₸"]
                 ]
               },
               {"type": "paragraph", "text": "Income: 300,000 ₸"},
               {"type": "paragraph", "text": "Expenses: 370,000 ₸"},
               {"type": "paragraph", "text": "Difference: –70,000 ₸ every month"},
               {"type": "paragraph", "text": "And that is without even including unexpected expenses such as medical treatment, appliance repair, or family events."}
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
               where s.code = 'income_expenses'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "For many people, income is fixed — for example, a salary. But expenses change: prices rise, new spending appears, and purchases become easier to make."},
               {"type": "paragraph", "text": "In Kazakhstan, installment-payment culture has a particularly strong impact: you can arrange a purchase in just a few minutes. This is convenient, but it also increases the burden on the budget."},
               {"type": "paragraph", "text": "That is why the first step is not to cut expenses blindly, but to see the real picture clearly."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 2: fixed_variable_expenses
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'fixed_variable_expenses'),
           'en',
           'Fixed and Variable Expenses'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Once you can already see your expenses, the next step is to understand which of them you can actually influence."
               },
               {
                 "type": "paragraph",
                 "text": "All expenses fall into two types, and this distinction changes the way you look at your budget."
               }
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Fixed expenses are payments you make every month in roughly the same amount and cannot simply remove:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "rent",
                   "utilities (electricity, gas, water)",
                   "internet and mobile communication",
                   "loan or installment payments"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "These expenses are rigid. You signed a contract, you took on an obligation. It is not easy to give them up quickly."
               },
               {
                 "type": "paragraph",
                 "text": "Variable expenses are those that depend on your daily decisions:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "eating out and food delivery (Wolt, Glovo)",
                   "taking a taxi instead of the bus",
                   "clothes and gadgets",
                   "entertainment, cafés, gifts"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "This is where the main leverage for budget management is."
               }
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "A person may not have the ability to reduce rent immediately, but at the same time may:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "take taxis every day",
                   "regularly order food delivery",
                   "make spontaneous purchases"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "In Kazakhstan, such expenses accumulate almost unnoticed:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "rides through Yandex Go or InDriver",
                   "delivery through Wolt or Glovo",
                   "purchases through Kaspi in installments"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Each of them seems small on its own, but together they significantly increase expenses."
               }
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Sort the expenses into fixed and variable."
               }
             ]
           }'::jsonb,
           '{
             "instruction": "Sort the expenses into fixed and variable.",
             "categories": [
               {"id": "fixed", "label": "Fixed"},
               {"id": "variable", "label": "Variable"}
             ],
             "items": [
               {"id": "rent", "text": "Rent"},
               {"id": "utilities", "text": "Utilities"},
               {"id": "taxi", "text": "Taxi"},
               {"id": "food_delivery", "text": "Food delivery"},
               {"id": "internet", "text": "Internet"},
               {"id": "entertainment", "text": "Entertainment"}
             ],
             "answers": [
               {"itemId": "rent", "categoryId": "fixed"},
               {"itemId": "utilities", "categoryId": "fixed"},
               {"itemId": "internet", "categoryId": "fixed"},
               {"itemId": "taxi", "categoryId": "variable"},
               {"itemId": "food_delivery", "categoryId": "variable"},
               {"itemId": "entertainment", "categoryId": "variable"}
             ],
             "explanation": "Fixed expenses repeat every month and are usually connected to obligations. Variable expenses depend on daily decisions and are the ones you can control."
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "When it feels like there is never enough money, it is important to understand that not all expenses are equally unavoidable."
               },
               {
                 "type": "paragraph",
                 "text": "Fixed expenses are difficult to change."
               },
               {
                 "type": "paragraph",
                 "text": "Variable expenses can be controlled and gradually reduced."
               },
               {
                 "type": "paragraph",
                 "text": "Real budget management begins with variable expenses."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 3: expense_accounting
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'expense_accounting'),
           'en',
           'Expense Tracking'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'expense_accounting'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Suppose you already understand how expenses are divided. Even then, without tracking, you will still make mistakes."
               },
               {
                 "type": "paragraph",
                 "text": "And that is normal — it is not about discipline, but about how the brain works. It remembers big expenses well, but barely notices small ones."
               }
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
               where s.code = 'expense_accounting'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "The brain is not designed for accurate tracking of daily expenses. It remembers rent or major purchases, but does not track regular small spending."
               },
               {
                 "type": "paragraph",
                 "text": "As a result, it creates the feeling that “everything is under control,” even though a significant part of the money disappears unnoticed."
               },
               {
                 "type": "paragraph",
                 "text": "What usually slips out of memory:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "coffee on the way to work",
                   "a snack at lunch",
                   "food delivery every few days",
                   "subscriptions charged automatically",
                   "small marketplace purchases"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Each such expense seems insignificant, but together they create a substantial burden on the budget."
               }
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
               where s.code = 'expense_accounting'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Let us look at a simple example:"
               },
               {
                 "type": "table",
                 "headers": ["Expense", "Per day", "Per month"],
                 "rows": [
                   ["Coffee", "1,500 ₸", "~45,000 ₸"],
                   ["Snack", "2,000 ₸", "~60,000 ₸"],
                   ["Total", "3,500 ₸", "~105,000 ₸"]
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "More than 100,000 ₸ — only on coffee and snacks. That is about a third of the income in our example."
               }
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
               where s.code = 'expense_accounting'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Without tracking expenses, an illusion of control appears. In reality, money can disappear in significant amounts without notice."
               },
               {
                 "type": "paragraph",
                 "text": "To avoid that, a simple system is enough:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "record expenses on the day of purchase",
                   "review the total once a week",
                   "divide spending into categories"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "You do not need complex tools. Notes, messengers, or banking apps are enough."
               },
               {
                 "type": "paragraph",
                 "text": "Many banking apps in Kazakhstan automatically show spending categories (relevant as of April 2026). For example, the Kaspi app provides spending analytics — you just need to review it regularly."
               },
               {
                 "type": "paragraph",
                 "text": "After 2–3 weeks, it becomes clear where the money is really going and where the main losses occur."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 4: budgeting_rule_50_30_20
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'budgeting_rule_50_30_20'),
           'en',
           'The 50/30/20 Rule'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "You can already see your expenses. The next question is whether they are distributed properly."
               },
               {
                 "type": "paragraph",
                 "text": "Is there a guideline you can rely on?"
               },
               {
                 "type": "paragraph",
                 "text": "Yes. One of the simplest and most practical approaches is the 50/30/20 rule."
               }
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "The idea of the rule is to divide income into three parts:"
               },
               {
                 "type": "paragraph",
                 "text": "50% — needs"
               },
               {
                 "type": "paragraph",
                 "text": "These are things you cannot do without: rent, food, utilities, transport to work, loan payments."
               },
               {
                 "type": "paragraph",
                 "text": "30% — wants"
               },
               {
                 "type": "paragraph",
                 "text": "Cafés, entertainment, clothes beyond what is necessary, subscriptions, travel. This part is responsible for comfort and quality of life."
               },
               {
                 "type": "paragraph",
                 "text": "20% — savings"
               },
               {
                 "type": "paragraph",
                 "text": "Money you set aside for an emergency fund, goals, and the future."
               }
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Let us take an income of 300,000 ₸:"
               },
               {
                 "type": "table",
                 "headers": ["Part", "Percentage", "Amount"],
                 "rows": [
                   ["Needs", "50%", "150,000 ₸"],
                   ["Wants", "30%", "90,000 ₸"],
                   ["Savings", "20%", "60,000 ₸"]
                 ]
               }
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Distribute an income of 300,000 ₸ across needs, wants, and savings."
               }
             ]
           }'::jsonb,
           '{
             "instruction": "Distribute an income of 300,000 ₸ across needs, wants, and savings.",
             "fields": [
               {"id": "needs", "label": "Needs"},
               {"id": "wants", "label": "Wants"},
               {"id": "savings", "label": "Savings"}
             ],
             "validation": {
               "sumMustEqual": 300000,
               "targetDistribution": {
                 "needs": 150000,
                 "wants": 90000,
                 "savings": 60000
               },
               "allowSmallDeviation": true
             },
             "exampleAnswer": {
               "needs": 150000,
               "wants": 90000,
               "savings": 60000
             },
             "explanation": "There is no single correct answer. What matters is that the total matches and part of the income goes to savings."
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "This is a guideline, not a rigid rule."
               },
               {
                 "type": "paragraph",
                 "text": "In Kazakhstan, especially in large cities, rent alone can take a significant share of income. In that case, the share of necessary expenses grows, while less remains for wants and savings — and that is normal at the beginning."
               },
               {
                 "type": "paragraph",
                 "text": "The key idea is not the exact percentages, but the principle: part of the money should always go to savings, even if the amount is small."
               },
               {
                 "type": "paragraph",
                 "text": "A person without a financial cushion remains vulnerable: any unexpected expense can lead to debt."
               },
               {
                 "type": "paragraph",
                 "text": "Many people in Kazakhstan live without savings not because they do not want to, but because they have not built the habit. The 50/30/20 rule is a simple way to start."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 5: budget_analysis
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'budget_analysis'),
           'en',
           'Budget Analysis'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'budget_analysis'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "You already know how to:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "separate income and expenses",
                   "understand what is fixed and what can be changed",
                   "track expenses",
                   "use the 50/30/20 rule as a guide"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Now the next step is to look at your budget as a whole and draw conclusions."
               }
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
               where s.code = 'budget_analysis'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "When analyzing a budget, it is important to pay attention to three things."
               },
               {
                 "type": "paragraph",
                 "text": "1. Is there a deficit?"
               },
               {
                 "type": "paragraph",
                 "text": "If expenses exceed income, that is the main problem. Living at a deficit means regularly increasing debt."
               },
               {
                 "type": "paragraph",
                 "text": "2. The share of variable expenses"
               },
               {
                 "type": "paragraph",
                 "text": "If a significant part of your money goes to taxis, delivery, cafés, and shopping, that is an area you can control."
               },
               {
                 "type": "paragraph",
                 "text": "3. The presence of savings"
               },
               {
                 "type": "paragraph",
                 "text": "If there are no savings, the budget remains vulnerable. Any unexpected situation can force you into debt."
               }
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
               where s.code = 'budget_analysis'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Let us look at a situation:"
               },
               {
                 "type": "paragraph",
                 "text": "Income: 300,000 ₸"
               },
               {
                 "type": "table",
                 "headers": ["Category", "Amount"],
                 "rows": [
                   ["Rent + utilities + internet", "170,000 ₸"],
                   ["Food at home", "50,000 ₸"],
                   ["Delivery and cafés", "60,000 ₸"],
                   ["Taxi", "40,000 ₸"],
                   ["Installment plan for a phone", "20,000 ₸"],
                   ["Total", "340,000 ₸"]
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Expenses: 340,000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Income: 300,000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Difference: –40,000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "There are no savings."
               },
               {
                 "type": "paragraph",
                 "text": "What can be done:"
               },
               {
                 "type": "paragraph",
                 "text": "Delivery and taxi add up to 100,000 ₸ per month. This is a significant part of the budget and belongs to variable expenses."
               },
               {
                 "type": "paragraph",
                 "text": "If these expenses are reduced even by half, the deficit disappears and it becomes possible to start saving money."
               }
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
               where s.code = 'budget_analysis'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "A budget is not a list of restrictions, but a tool for making decisions."
               },
               {
                 "type": "paragraph",
                 "text": "If there is a deficit, you need to look for ways to reduce variable expenses."
               },
               {
                 "type": "paragraph",
                 "text": "If there are no savings, start with small amounts, even 5,000–10,000 ₸ per month."
               },
               {
                 "type": "paragraph",
                 "text": "If expenses are objectively high and difficult to reduce, that is a signal to focus on income: side work, skill development, or career growth."
               },
               {
                 "type": "paragraph",
                 "text": "In Kazakhstan, there are free resources for improving financial literacy. For example, the national project “Qaryzsyz Qogam” (“Society Without Debt”) (relevant as of April 2026) offers training for everyone."
               },
               {
                 "type": "paragraph",
                 "text": "The Fingramota.kz portal is available through the Egov.kz e-government platform (relevant as of August 2025). There you can find calculators, courses, and practical materials."
               },
               {
                 "type": "paragraph",
                 "text": "Budgeting is a skill. It is formed through practice. Even one month of observing your expenses gives more understanding than having no tracking at all."
               },
               {
                 "type": "paragraph",
                 "text": "The examples provided are for informational purposes only and do not constitute recommendations."
               }
             ]
           }'::jsonb
       );

commit;