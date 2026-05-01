begin;

-- =========================================
-- TOPIC: financial_planning
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'financial_planning'),
           'en',
           'Financial Planning'
       );

-- =========================================
-- SUBTOPIC 1: financial_goals
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'financial_goals'),
           'en',
           'Financial Goals'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'financial_goals'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Financial planning begins with understanding where you want to get."},
               {"type": "paragraph", "text": "In Kazakhstan, where levels of income and expenses can vary significantly depending on region, profession, and economic conditions, it is especially important to take a conscious approach to managing money."},
               {"type": "paragraph", "text": "Without a specific goal, any financial actions become chaotic: income comes in and gets spent, but no noticeable result appears."},
               {"type": "paragraph", "text": "Financial goals are what give direction and turn money management into a systematic process."}
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
               where s.code = 'financial_goals'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A financial goal is a specific result that you want to achieve using your financial resources."},
               {"type": "paragraph", "text": "It answers a key question: “Why do you need savings and expense control?”"},
               {"type": "paragraph", "text": "In personal finance practice, goals can be different:"},
               {"type": "bullet_list", "items": [
                 "building an emergency fund (for example, 3–6 months of expenses)",
                 "buying real estate or making a mortgage down payment",
                 "purchasing a car",
                 "paying for education, including studying abroad",
                 "building investment capital",
                 "major purchases or travel"
               ]},
               {"type": "paragraph", "text": "In Kazakhstan, one of the most common goals is saving for a mortgage down payment, since property prices remain high relative to average income."},
               {"type": "paragraph", "text": "For a goal to truly work, it should meet three criteria:"},
               {"type": "bullet_list", "items": [
                 "specificity (it is clear what exactly you are saving for)",
                 "measurability (there is a clear amount)",
                 "time-bound nature (there is a target deadline)"
               ]},
               {"type": "paragraph", "text": "For example:"},
               {"type": "paragraph", "text": "“Save 3,000,000 ₸ for a down payment in 2 years”"},
               {"type": "paragraph", "text": "Such wording already allows you to move on to calculations and planning."},
               {"type": "paragraph", "text": "Without a clearly formulated goal, it is difficult to:"},
               {"type": "bullet_list", "items": [
                 "track progress",
                 "determine the necessary level of savings",
                 "make informed financial decisions"
               ]}
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
               where s.code = 'financial_goals'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Let us compare two formulations:"},
               {"type": "paragraph", "text": "1. “I want to start saving money”"},
               {"type": "paragraph", "text": "2. “Save 600,000 ₸ for an emergency fund in 12 months”"},
               {"type": "paragraph", "text": "In the second case:"},
               {"type": "bullet_list", "items": [
                 "the final amount is clear",
                 "there is a deadline",
                 "you can calculate the monthly contribution (50,000 ₸)",
                 "it is easier to track progress"
               ]},
               {"type": "paragraph", "text": "Such a goal turns an abstract desire into a concrete action plan."}
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
               where s.code = 'financial_goals'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Formulate your financial goal. Indicate what exactly you want to save for, what amount you plan to reach, and, if possible, the timeframe."}
             ]
           }'::jsonb,
           '{
             "instruction": "Formulate your financial goal. Indicate what exactly you want to save for, what amount you plan to reach, and, if possible, the timeframe.",
             "fields": [
               {"id": "goal_description", "label": "Your financial goal"}
             ],
             "validation": {
               "rules": [
                 "The answer must not be empty",
                 "The answer must contain a meaningful description of the goal"
               ]
             },
             "exampleAnswer": {
               "goal_description": "Save 1,000,000 ₸ for a mortgage down payment in 18 months"
             },
             "explanation": "A clearly formulated goal allows you to move on to the next stage — a savings plan and income allocation. Without a concrete goal, financial behavior remains unsystematic."
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
               where s.code = 'financial_goals'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Financial goals are the foundation of personal financial planning."},
               {"type": "paragraph", "text": "They help structure income and expenses, build savings, and support informed decision-making."},
               {"type": "paragraph", "text": "The more precisely a goal is defined, the higher the probability of achieving it and the more stable your financial situation becomes."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 2: short_vs_long_goals
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'short_vs_long_goals'),
           'en',
           'Short-Term vs Long-Term Goals'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Not all financial goals are the same in terms of timeframe and approach."},
               {"type": "paragraph", "text": "Some goals can be achieved within a few months, while others require planning over several years."},
               {"type": "paragraph", "text": "Understanding the difference between short-term and long-term goals helps allocate resources correctly and avoid financial mistakes."}
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Financial goals are usually divided into short-term and long-term depending on the time needed to achieve them."},
               {"type": "paragraph", "text": "Short-term goals are goals planned to be achieved within a short period, usually up to 1 year."},
               {"type": "paragraph", "text": "They include:"},
               {"type": "bullet_list", "items": [
                 "buying household appliances",
                 "paying for a trip or vacation",
                 "building a small emergency fund",
                 "closing current obligations"
               ]},
               {"type": "paragraph", "text": "Long-term goals are goals whose achievement requires significant time, usually 1 year or more."},
               {"type": "paragraph", "text": "They include:"},
               {"type": "bullet_list", "items": [
                 "saving for a mortgage down payment",
                 "buying property",
                 "building investment capital",
                 "forming retirement savings"
               ]},
               {"type": "paragraph", "text": "In Kazakhstan, long-term goals are often related to real estate, since housing remains expensive relative to income and saving for it requires time and discipline."},
               {"type": "paragraph", "text": "The key difference between these two types of goals lies in the approach:"},
               {"type": "bullet_list", "items": [
                 "short-term goals require high liquidity, meaning the money should be available at any time",
                 "long-term goals allow for more complex saving tools and strategies"
               ]},
               {"type": "paragraph", "text": "It is also important to take inflation into account."},
               {"type": "paragraph", "text": "In long-term planning in Kazakhstan, inflation can significantly reduce the purchasing power of savings, so simply holding money without any yield becomes less effective."}
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Let us consider two goals:"},
               {"type": "paragraph", "text": "1. Save 300,000 ₸ for a vacation in 6 months"},
               {"type": "paragraph", "text": "2. Save 5,000,000 ₸ for a mortgage down payment in 3 years"},
               {"type": "paragraph", "text": "The first goal:"},
               {"type": "bullet_list", "items": [
                 "short timeframe",
                 "relatively small amount",
                 "can be achieved using ordinary savings"
               ]},
               {"type": "paragraph", "text": "The second goal:"},
               {"type": "bullet_list", "items": [
                 "long timeframe",
                 "large amount",
                 "requires a systematic approach and regular contributions"
               ]},
               {"type": "paragraph", "text": "Trying to achieve a long-term goal with the same methods as a short-term one often leads to delays or abandonment of the goal."}
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Dividing financial goals into short-term and long-term makes it possible to choose the right strategies for achieving them."},
               {"type": "paragraph", "text": "Short-term goals require simplicity and easy access to funds, while long-term goals require planning, discipline, and consideration of economic factors such as inflation."},
               {"type": "paragraph", "text": "A clear understanding of the type of goal helps manage finances more effectively and increases the likelihood of reaching it."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 3: spending_priorities
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'spending_priorities'),
           'en',
           'Spending Priorities'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'spending_priorities'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Even with a stable income, financial goals may remain unmet if spending is not controlled."},
               {"type": "paragraph", "text": "Often the problem is not a lack of money, but the absence of clear priorities."},
               {"type": "paragraph", "text": "Understanding which expenses are essential and which are secondary allows you to manage your budget more effectively."}
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Spending priorities are a system of income allocation in which the most important financial needs are covered first, and less important ones later."},
               {"type": "paragraph", "text": "All expenses can be conditionally divided into three categories:"},
               {"type": "bullet_list", "items": [
                 "essential expenses",
                 "important but flexible expenses",
                 "non-essential (discretionary) expenses"
               ]},
               {"type": "paragraph", "text": "Essential expenses are those without which it is impossible to maintain a basic standard of living:"},
               {"type": "bullet_list", "items": [
                 "rent or mortgage",
                 "food",
                 "utilities",
                 "transportation",
                 "minimum loan payments"
               ]},
               {"type": "paragraph", "text": "Important but flexible expenses:"},
               {"type": "bullet_list", "items": [
                 "clothing",
                 "education",
                 "medical care (outside emergency situations)",
                 "household purchases"
               ]},
               {"type": "paragraph", "text": "Non-essential expenses:"},
               {"type": "bullet_list", "items": [
                 "entertainment",
                 "cafés and restaurants",
                 "impulse purchases",
                 "subscriptions and services"
               ]},
               {"type": "paragraph", "text": "Basic expenses usually take up a significant part of the budget, but it is the non-essential spending that most often remains uncontrolled and gradually reduces the ability to build savings."},
               {"type": "paragraph", "text": "Setting priorities means that after receiving income, you:"},
               {"type": "bullet_list", "items": [
                 "first cover essential expenses",
                 "then set aside money for goals and savings",
                 "and only after that distribute the remaining amount for personal spending"
               ]},
               {"type": "paragraph", "text": "This approach allows you not only to control your budget, but also to move systematically toward financial goals."}
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Your monthly income is 300,000 ₸."},
               {"type": "paragraph", "text": "Expenses:"},
               {"type": "bullet_list", "items": [
                 "rent and utilities: 120,000 ₸",
                 "food and transportation: 80,000 ₸",
                 "loans: 40,000 ₸"
               ]},
               {"type": "paragraph", "text": "After essential expenses, 60,000 ₸ remains."},
               {"type": "paragraph", "text": "If this money is spent without control on cafés, shopping, or entertainment, savings do not build up."},
               {"type": "paragraph", "text": "But if you first set aside, for example, 30,000 ₸ toward a goal and use the remaining 30,000 ₸ for personal spending, a balance appears between current comfort and future results."}
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Spending priorities allow you to manage money consciously rather than react to current desires."},
               {"type": "paragraph", "text": "A clear separation of expenses helps preserve financial stability and move toward goals on a regular basis."},
               {"type": "paragraph", "text": "Even with an average income, the right prioritization of expenses can significantly improve your financial position."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 4: savings_plan
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'savings_plan'),
           'en',
           'Savings Plan'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'savings_plan'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Once a financial goal has been defined, the next step is to create a plan for achieving it."},
               {"type": "paragraph", "text": "Without a concrete plan, even a clear goal may remain only an intention, because it is unclear how much and how regularly needs to be saved."},
               {"type": "paragraph", "text": "A savings plan helps turn a goal into a sequence of concrete actions and assess how realistic it is within the current budget."}
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
               where s.code = 'savings_plan'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A savings plan is a calculation that shows how much money needs to be set aside regularly in order to achieve a financial goal within a specified period."},
               {"type": "paragraph", "text": "The basic principle is as follows:"},
               {"type": "paragraph", "text": "monthly contribution = goal amount / number of months"},
               {"type": "paragraph", "text": "However, in practice, one calculation is not enough. It is important to understand whether this plan matches your financial capabilities."},
               {"type": "paragraph", "text": "If the required monthly contribution is too high compared to the free part of your income, the goal may turn out to be unrealistic within the chosen timeframe."},
               {"type": "paragraph", "text": "That is why, when building a savings plan, it is important to consider:"},
               {"type": "bullet_list", "items": [
                 "the goal amount",
                 "the achievement timeframe",
                 "the amount of free funds left after essential expenses",
                 "the sustainability of the plan over several months"
               ]},
               {"type": "paragraph", "text": "A realistic plan is not the maximum possible one, but a manageable one that can be followed without constant setbacks."},
               {"type": "paragraph", "text": "If the calculation shows that the burden is too high, several solutions are possible:"},
               {"type": "bullet_list", "items": [
                 "extend the savings period",
                 "reduce the target amount",
                 "review the structure of expenses",
                 "find additional sources of income"
               ]}
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
               where s.code = 'savings_plan'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You want to save 720,000 ₸ in 12 months."},
               {"type": "paragraph", "text": "The calculation shows:"},
               {"type": "paragraph", "text": "720,000 / 12 = 60,000 ₸ per month"},
               {"type": "paragraph", "text": "At the same time, after essential expenses, you only have 45,000 ₸ of free funds left."},
               {"type": "paragraph", "text": "This means that the current plan requires an amount that exceeds your actual capabilities."},
               {"type": "paragraph", "text": "In such a case, for example, you could extend the period to 16 months:"},
               {"type": "paragraph", "text": "720,000 / 16 = 45,000 ₸"},
               {"type": "paragraph", "text": "Now the goal becomes more realistic and better aligned with your budget."}
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
               where s.code = 'savings_plan'
                 and ls.order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Calculate whether the savings plan is realistic. The goal is 720,000 ₸ in 12 months. After essential expenses, you have 45,000 ₸ left per month. Determine the required monthly contribution and the difference between the required amount and the available funds."}
             ]
           }'::jsonb,
           '{
             "instruction": "Calculate whether the savings plan is realistic. The goal is 720,000 ₸ in 12 months. After essential expenses, you have 45,000 ₸ left per month. Determine the required monthly contribution and the difference between the required amount and the available funds.",
             "fields": [
               {"id": "monthly_saving_needed", "label": "Required monthly contribution"},
               {"id": "difference_amount", "label": "Shortage or remaining amount per month"}
             ],
             "validation": {
               "rules": [
                 "Required monthly contribution = 720000 / 12",
                 "Difference = 45000 - monthly_saving_needed"
               ],
               "expectedValues": {
                 "monthly_saving_needed": 60000,
                 "difference_amount": -15000
               }
             },
             "exampleAnswer": {
               "monthly_saving_needed": 60000,
               "difference_amount": -15000
             },
             "explanation": "To achieve the goal, you need to save 60,000 ₸ per month, but you only have 45,000 ₸ of free funds. This means a shortage of 15,000 ₸ every month. In its current form, the plan is unrealistic, so you need to increase the timeframe, reduce the goal, or review your expenses."
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
               where s.code = 'savings_plan'
                 and ls.order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A savings plan must be not only mathematically correct, but also realistic in everyday life."},
               {"type": "paragraph", "text": "If the goal does not match the possibilities of your budget, it is better to adjust the conditions in advance rather than constantly face failure to follow the plan."},
               {"type": "paragraph", "text": "A realistic plan increases the likelihood that the financial goal will actually be achieved."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 5: progress_control
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'progress_control'),
           'en',
           'Progress Control'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'progress_control'
                 and ls.order_index = 1
           ),
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Even with a clear financial goal and a well-designed savings plan, the result is not guaranteed."},
               {"type": "paragraph", "text": "The main reason is the lack of regular control."},
               {"type": "paragraph", "text": "Without tracking progress and adjusting actions, even a realistic plan can gradually stop working."}
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
               where s.code = 'progress_control'
                 and ls.order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Progress control is the process of regularly checking how actual actions correspond to what was planned."},
               {"type": "paragraph", "text": "It allows you to:"},
               {"type": "bullet_list", "items": [
                 "track progress toward the goal",
                 "identify deviations from the plan",
                 "adjust behavior in time"
               ]},
               {"type": "paragraph", "text": "In practice, control may include:"},
               {"type": "bullet_list", "items": [
                 "monthly checking of the saved amount",
                 "comparing actual savings with the plan",
                 "analyzing the reasons for deviations, for example unexpected expenses"
               ]},
               {"type": "paragraph", "text": "It is important to understand that deviations from the plan are normal."},
               {"type": "paragraph", "text": "Financial behavior depends on many factors:"},
               {"type": "bullet_list", "items": [
                 "changes in income",
                 "unexpected expenses",
                 "seasonal fluctuations in spending"
               ]},
               {"type": "paragraph", "text": "That is why the task of control is not to “punish yourself” for deviations, but to notice them in time and adjust the plan."},
               {"type": "paragraph", "text": "Effective control is built on regularity."},
               {"type": "paragraph", "text": "Even the simple habit of checking the state of your savings once a month already significantly increases the chance of reaching your goal."},
               {"type": "paragraph", "text": "It is also important to record progress."},
               {"type": "paragraph", "text": "When you see that the amount of savings is gradually growing, it strengthens motivation and helps maintain discipline."}
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
               where s.code = 'progress_control'
                 and ls.order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "You plan to save 50,000 ₸ per month."},
               {"type": "paragraph", "text": "After 3 months, according to the plan, you should have 150,000 ₸."},
               {"type": "paragraph", "text": "In reality, only 120,000 ₸ has been saved."},
               {"type": "paragraph", "text": "The deviation is 30,000 ₸."},
               {"type": "paragraph", "text": "This is a signal that:"},
               {"type": "bullet_list", "items": [
                 "either expenses were higher than expected",
                 "or the plan was too optimistic from the start"
               ]},
               {"type": "paragraph", "text": "In such a situation, you can:"},
               {"type": "bullet_list", "items": [
                 "adjust the monthly contribution",
                 "extend the time needed to reach the goal",
                 "review the structure of expenses"
               ]},
               {"type": "paragraph", "text": "The main thing is not to ignore the deviation, but to make a decision."}
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
               where s.code = 'progress_control'
                 and ls.order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Progress control is a key element of financial planning that turns goals and calculations into real results."},
               {"type": "paragraph", "text": "Regular tracking of progress allows you to notice problems in time and adapt the plan to real conditions."},
               {"type": "paragraph", "text": "Even simple but systematic control significantly increases the probability of achieving financial goals."}
             ]
           }'::jsonb
       );

commit;