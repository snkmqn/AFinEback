-- 000039_seed_budgeting_remaining_subtopics.up.sql

begin;

-- =========================================
-- САБТОПИК 2: fixed_variable_expenses
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'budgeting'),
           'fixed_variable_expenses',
           2,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'fixed_variable_expenses'),
           'ru',
           'Фиксированные и переменные расходы'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'fixed_variable_expenses'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Когда вы уже видите свои расходы, следующий шаг — разобраться, над какими из них вы реально имеете влияние."
               },
               {
                 "type": "paragraph",
                 "text": "Все траты делятся на два типа, и это деление меняет взгляд на бюджет."
               }
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Фиксированные расходы — это то, что вы платите каждый месяц примерно в одинаковой сумме и не можете просто взять и убрать:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "аренда жилья",
                   "коммунальные услуги (свет, газ, вода)",
                   "интернет и мобильная связь",
                   "выплаты по кредиту или рассрочке"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Эти расходы «жёсткие». Вы подписали договор, взяли обязательство. Быстро отказаться от них не получится."
               },
               {
                 "type": "paragraph",
                 "text": "Переменные расходы — это то, что зависит от ваших ежедневных решений:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "еда вне дома и доставка (Wolt, Glovo)",
                   "поездки на такси вместо автобуса",
                   "одежда и гаджеты",
                   "развлечения, кафе, подарки"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Именно здесь находится основной рычаг управления бюджетом."
               }
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Человек может не иметь возможности сразу снизить аренду, но при этом:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "ежедневно ездить на такси",
                   "регулярно заказывать доставку еды",
                   "делать спонтанные покупки"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "В казахстанских реалиях такие траты накапливаются незаметно:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "поездки через Яндекс Go или InDriver",
                   "доставка через Wolt или Glovo",
                   "покупки через Kaspi в рассрочку"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Каждая из них кажется небольшой, но в сумме они существенно увеличивают расходы."
               }
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses')),
           'interactive',
           4,
           'drag_drop'
       );

insert into lesson_step_translations (
    lesson_step_id,
    language_code,
    title,
    content,
    interactive_content
)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Распределите расходы на фиксированные и переменные."
               }
             ]
           }'::jsonb,
           '{
             "instruction": "Распределите расходы на фиксированные и переменные.",
             "categories": [
               {"id": "fixed", "label": "Фиксированные"},
               {"id": "variable", "label": "Переменные"}
             ],
             "items": [
               {"id": "rent", "text": "Аренда жилья"},
               {"id": "utilities", "text": "Коммунальные услуги"},
               {"id": "taxi", "text": "Такси"},
               {"id": "food_delivery", "text": "Доставка еды"},
               {"id": "internet", "text": "Интернет"},
               {"id": "entertainment", "text": "Развлечения"}
             ],
             "answers": [
               {"itemId": "rent", "categoryId": "fixed"},
               {"itemId": "utilities", "categoryId": "fixed"},
               {"itemId": "internet", "categoryId": "fixed"},
               {"itemId": "taxi", "categoryId": "variable"},
               {"itemId": "food_delivery", "categoryId": "variable"},
               {"itemId": "entertainment", "categoryId": "variable"}
             ],
             "explanation": "Фиксированные расходы повторяются каждый месяц и обычно связаны с обязательствами. Переменные зависят от ежедневных решений и именно их можно контролировать."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'fixed_variable_expenses'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Когда кажется, что «денег не хватает», важно понимать: не все расходы одинаково неизбежны."
               },
               {
                 "type": "paragraph",
                 "text": "Фиксированные расходы изменить сложно."
               },
               {
                 "type": "paragraph",
                 "text": "Переменные — можно контролировать и постепенно сокращать."
               },
               {
                 "type": "paragraph",
                 "text": "Именно с переменных расходов начинается реальное управление бюджетом."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 3: expense_accounting
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'budgeting'),
           'expense_accounting',
           3,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'expense_accounting'),
           'ru',
           'Учёт расходов'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'expense_accounting'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Допустим, вы понимаете, как делятся расходы. Но без учёта вы всё равно будете ошибаться."
               },
               {
                 "type": "paragraph",
                 "text": "И это нормально — дело не в дисциплине, а в том, как работает мозг. Он хорошо запоминает крупные траты, но почти не фиксирует мелкие."
               }
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Мозг не создан для точного учёта ежедневных расходов. Он запоминает аренду или крупные покупки, но не отслеживает регулярные мелкие траты."
               },
               {
                 "type": "paragraph",
                 "text": "В результате создаётся ощущение, что «всё под контролем», хотя значительная часть денег уходит незаметно."
               },
               {
                 "type": "paragraph",
                 "text": "Что обычно выпадает из памяти:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "кофе по дороге на работу",
                   "перекус в обед",
                   "доставка еды раз в несколько дней",
                   "подписки, которые списываются автоматически",
                   "мелкие покупки на маркетплейсах"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Каждая такая трата кажется незначительной, но в сумме даёт существенную нагрузку на бюджет."
               }
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Посмотрим на простую ситуацию:"
               },
               {
                 "type": "table",
                 "headers": ["Трата", "В день", "В месяц"],
                 "rows": [
                   ["Кофе", "1 500 ₸", "~45 000 ₸"],
                   ["Перекус", "2 000 ₸", "~60 000 ₸"],
                   ["Итого", "3 500 ₸", "~105 000 ₸"]
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Больше 100 000 ₸ — только на кофе и перекусы. Это примерно треть от дохода в нашем примере."
               }
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'expense_accounting'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Без учёта расходов создаётся иллюзия контроля. На практике деньги могут уходить в значительных объёмах незаметно."
               },
               {
                 "type": "paragraph",
                 "text": "Чтобы этого избежать, достаточно простой системы:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "фиксировать траты в день покупки",
                   "раз в неделю смотреть итог",
                   "делить расходы по категориям"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Не обязательно использовать сложные инструменты. Подойдут заметки, мессенджеры или банковские приложения."
               },
               {
                 "type": "paragraph",
                 "text": "Многие банковские приложения в Казахстане автоматически показывают категории расходов (актуально на апрель 2026). Например, приложение Kaspi формирует аналитику по тратам — достаточно регулярно её просматривать."
               },
               {
                 "type": "paragraph",
                 "text": "Через 2–3 недели становится видно, куда реально уходят деньги и где возникают основные потери."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 4: budgeting_rule_50_30_20
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'budgeting'),
           'budgeting_rule_50_30_20',
           4,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'budgeting_rule_50_30_20'),
           'ru',
           'Правило 50/30/20'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'budgeting_rule_50_30_20'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Вы уже видите свои расходы. Следующий вопрос — правильно ли они распределены."
               },
               {
                 "type": "paragraph",
                 "text": "Есть ли ориентир, на который можно опереться?"
               },
               {
                 "type": "paragraph",
                 "text": "Да. Один из самых простых и рабочих подходов — правило 50/30/20."
               }
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Суть правила в том, чтобы разделить доход на три части:"
               },
               {
                 "type": "paragraph",
                 "text": "50% — обязательные нужды"
               },
               {
                 "type": "paragraph",
                 "text": "Это всё, без чего нельзя: аренда, еда, коммунальные услуги, транспорт до работы, выплаты по кредитам."
               },
               {
                 "type": "paragraph",
                 "text": "30% — желания"
               },
               {
                 "type": "paragraph",
                 "text": "Кафе, развлечения, одежда сверх необходимого, подписки, путешествия. Эта часть отвечает за комфорт и качество жизни."
               },
               {
                 "type": "paragraph",
                 "text": "20% — накопления"
               },
               {
                 "type": "paragraph",
                 "text": "Деньги, которые вы откладываете: на подушку безопасности, цели и будущее."
               }
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Рассмотрим доход 300 000 ₸:"
               },
               {
                 "type": "table",
                 "headers": ["Часть", "Процент", "Сумма"],
                 "rows": [
                   ["Обязательные нужды", "50%", "150 000 ₸"],
                   ["Желания", "30%", "90 000 ₸"],
                   ["Накопления", "20%", "60 000 ₸"]
                 ]
               }
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20')),
           'interactive',
           4,
           'input_numbers'
       );

insert into lesson_step_translations (
    lesson_step_id,
    language_code,
    title,
    content,
    interactive_content
)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Распределите доход 300 000 ₸ по категориям: нужды, желания и накопления."
               }
             ]
           }'::jsonb,
           '{
             "instruction": "Распределите доход 300 000 ₸ по категориям: нужды, желания и накопления.",
             "fields": [
               {"id": "needs", "label": "Обязательные нужды"},
               {"id": "wants", "label": "Желания"},
               {"id": "savings", "label": "Накопления"}
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
             "explanation": "Правильного единственного ответа нет. Важно, чтобы сумма сходилась и часть дохода уходила в накопления."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budgeting_rule_50_30_20'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Это ориентир, а не жёсткое правило."
               },
               {
                 "type": "paragraph",
                 "text": "В казахстанских условиях, особенно в крупных городах, одна аренда может занимать значительную часть дохода. В этом случае доля обязательных расходов увеличивается, а на желания и накопления остаётся меньше — это нормально на начальном этапе."
               },
               {
                 "type": "paragraph",
                 "text": "Главная идея не в точных процентах, а в принципе: часть денег должна уходить в накопления всегда, даже если это небольшая сумма."
               },
               {
                 "type": "paragraph",
                 "text": "Человек без финансовой подушки остаётся уязвимым: любой неожиданный расход может привести к кредиту."
               },
               {
                 "type": "paragraph",
                 "text": "Многие казахстанцы живут без накоплений не потому, что не хотят, а потому что не выстроили эту привычку. Правило 50/30/20 — простой способ её начать."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 5: budget_analysis
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'budgeting'),
           'budget_analysis',
           5,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'budget_analysis'),
           'ru',
           'Анализ бюджета'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'budget_analysis'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Вы уже умеете:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "разделять доходы и расходы",
                   "понимать, что фиксировано, а что можно изменить",
                   "вести учёт",
                   "ориентироваться на правило 50/30/20"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Теперь следующий шаг — посмотреть на бюджет в целом и сделать выводы."
               }
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "При анализе бюджета важно обратить внимание на три вещи."
               },
               {
                 "type": "paragraph",
                 "text": "1. Есть ли дефицит"
               },
               {
                 "type": "paragraph",
                 "text": "Если расходы превышают доход — это основная проблема. Жить в минус значит регулярно увеличивать долг."
               },
               {
                 "type": "paragraph",
                 "text": "2. Доля переменных расходов"
               },
               {
                 "type": "paragraph",
                 "text": "Если значительная часть денег уходит на такси, доставку, кафе и покупки — это зона, которую можно контролировать."
               },
               {
                 "type": "paragraph",
                 "text": "3. Наличие накоплений"
               },
               {
                 "type": "paragraph",
                 "text": "Если накоплений нет, бюджет остаётся уязвимым. Любая неожиданная ситуация — и приходится брать кредит."
               }
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Рассмотрим ситуацию:"
               },
               {
                 "type": "paragraph",
                 "text": "Доход: 300 000 ₸"
               },
               {
                 "type": "table",
                 "headers": ["Статья", "Сумма"],
                 "rows": [
                   ["Аренда + коммунальные + интернет", "170 000 ₸"],
                   ["Еда дома", "50 000 ₸"],
                   ["Доставка и кафе", "60 000 ₸"],
                   ["Такси", "40 000 ₸"],
                   ["Рассрочка на телефон", "20 000 ₸"],
                   ["Итого", "340 000 ₸"]
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Расходы: 340 000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Доход: 300 000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Разница: –40 000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Накоплений нет."
               },
               {
                 "type": "paragraph",
                 "text": "Что можно сделать:"
               },
               {
                 "type": "paragraph",
                 "text": "Доставка и такси — это 100 000 ₸ в месяц. Это значительная часть бюджета, которая относится к переменным расходам."
               },
               {
                 "type": "paragraph",
                 "text": "Если сократить эти траты хотя бы вдвое, дефицит исчезает и появляется возможность откладывать деньги."
               }
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'budget_analysis'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Бюджет — это не список запретов, а инструмент для принятия решений."
               },
               {
                 "type": "paragraph",
                 "text": "Если есть дефицит — нужно искать, где сократить переменные расходы."
               },
               {
                 "type": "paragraph",
                 "text": "Если нет накоплений — начинать с небольших сумм, даже 5 000–10 000 ₸ в месяц."
               },
               {
                 "type": "paragraph",
                 "text": "Если расходы объективно высокие и их сложно сократить, это сигнал обратить внимание на доход: подработка, развитие навыков, карьерный рост."
               },
               {
                 "type": "paragraph",
                 "text": "В Казахстане есть бесплатные ресурсы для повышения финансовой грамотности. Например, национальный проект «Қарызсыз қоғам» («Общество без долгов») (актуально на апрель 2026) предлагает обучение для всех желающих."
               },
               {
                 "type": "paragraph",
                 "text": "Портал Fingramota.kz доступен через платформу электронного правительства Egov.kz (актуально на август 2025). Там можно найти калькуляторы, курсы и практические материалы."
               },
               {
                 "type": "paragraph",
                 "text": "Бюджетирование — это навык. Он формируется через практику. Даже один месяц наблюдения за расходами даёт больше понимания, чем отсутствие учёта."
               },
               {
                 "type": "paragraph",
                 "text": "Приведённые примеры носят ознакомительный характер и не являются рекомендацией."
               }
             ]
           }'::jsonb
       );

commit;