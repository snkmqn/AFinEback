begin;

-- =========================================
-- ТЕМА: savings
-- =========================================

insert into topics (code, level, order_index, is_active)
values ('savings', 'beginner', 2, true);

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'savings'),
           'ru',
           'Сбережения'
       );

-- =========================================
-- САБТОПИК 1: why_save
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'savings'),
           'why_save',
           1,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'why_save'),
           'ru',
           'Зачем откладывать деньги'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'why_save'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Многие люди живут от зарплаты до зарплаты, тратя весь доход на текущие нужды. В такой модели не остаётся места для накоплений, а любые неожиданные расходы становятся проблемой."},
               {"type": "paragraph", "text": "Со временем это приводит к зависимости от займов и постоянному финансовому напряжению."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сбережения — это часть дохода, которая не тратится сразу, а откладывается на будущее."},
               {"type": "paragraph", "text": "Они выполняют несколько важных функций:"},
               {"type": "bullet_list", "items": [
                 "защита от непредвиденных ситуаций",
                 "достижение финансовых целей",
                 "снижение стресса",
                 "формирование финансовой независимости"
               ]},
               {"type": "paragraph", "text": "Даже небольшие суммы, откладываемые регулярно, со временем превращаются в значительный капитал."},
               {"type": "paragraph", "text": "В Казахстане многие люди сталкиваются с ситуациями, когда нужно срочно оплатить лечение, ремонт автомобиля или помочь родственникам. Наличие сбережений позволяет решать такие вопросы без долгов."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Допустим, человек получает 250 000 ₸ в месяц и откладывает 10%."},
               {"type": "table", "headers": ["Период", "Накопления"], "rows": [
                 ["1 месяц", "25 000 ₸"],
                 ["6 месяцев", "150 000 ₸"],
                 ["12 месяцев", "300 000 ₸"]
               ]},
               {"type": "paragraph", "text": "Даже без процентов за год формируется значимая сумма."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'why_save'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Откладывание денег — это не про отказ от жизни, а про контроль над ней."},
               {"type": "paragraph", "text": "Регулярные сбережения дают уверенность в будущем и позволяют принимать решения без финансового давления."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 2: emergency_fund
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'savings'),
           'emergency_fund',
           2,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'emergency_fund'),
           'ru',
           'Финансовая подушка'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'emergency_fund'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Многие люди задумываются о накоплениях только тогда, когда уже появляется проблема: срочное лечение, поломка техники, потеря работы или задержка дохода."},
               {"type": "paragraph", "text": "В такой ситуации отсутствие запаса денег быстро приводит к стрессу, долгам или необходимости занимать у родственников и знакомых."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Финансовая подушка — это резерв денег на случай непредвиденных ситуаций."},
               {"type": "paragraph", "text": "Её задача — временно покрывать базовые расходы человека, если привычный доход уменьшился или исчез."},
               {"type": "paragraph", "text": "Обычно рекомендуют иметь сумму, равную расходам за 3–6 месяцев:"},
               {"type": "bullet_list", "items": [
                 "3 месяца — минимальный уровень безопасности",
                 "6 месяцев — более устойчивый вариант"
               ]},
               {"type": "paragraph", "text": "Подушка не создаётся для крупных покупок, отдыха или спонтанных трат. Это именно запас на случай жизненных трудностей."},
               {"type": "paragraph", "text": "В казахстанских условиях финансовая подушка особенно важна, потому что многие семьи зависят от одной зарплаты, а неожиданные расходы — лечение, ремонт машины, переезд, помощь родственникам — могут возникнуть в любой момент."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Допустим, человек живёт в Астане и ежемесячно тратит:"},
               {"type": "table", "headers": ["Статья", "Сумма"], "rows": [
                 ["Аренда", "180 000 ₸"],
                 ["Еда", "80 000 ₸"],
                 ["Транспорт", "20 000 ₸"],
                 ["Коммунальные услуги", "20 000 ₸"],
                 ["Прочие расходы", "20 000 ₸"],
                 ["Итого", "320 000 ₸"]
               ]},
               {"type": "paragraph", "text": "Тогда финансовая подушка составит:"},
               {"type": "bullet_list", "items": [
                 "минимум: 320 000 × 3 = 960 000 ₸",
                 "комфортно: 320 000 × 6 = 1 920 000 ₸"
               ]},
               {"type": "paragraph", "text": "Это не значит, что такую сумму нужно накопить сразу. Важно понимать цель и двигаться к ней постепенно."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund')),
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
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассчитайте минимальную и комфортную финансовую подушку, если ежемесячные расходы составляют 160 000 ₸."}
             ]
           }'::jsonb,
           '{
             "instruction": "Рассчитайте минимальную и комфортную финансовую подушку, если ежемесячные расходы составляют 160 000 ₸.",
             "fields": [
               {"id": "minimum_fund", "label": "Минимальная подушка"},
               {"id": "comfortable_fund", "label": "Комфортная подушка"}
             ],
             "validation": {
               "rules": [
                 "Минимальная подушка = расходы × 3",
                 "Комфортная подушка = расходы × 6"
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
             "explanation": "Финансовая подушка рассчитывается на основе ежемесячных расходов, а не доходов. Минимальный резерв покрывает 3 месяца, более надёжный — 6 месяцев."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'emergency_fund'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Финансовая подушка не приносит мгновенной выгоды, но создаёт устойчивость и снижает финансовую уязвимость."},
               {"type": "paragraph", "text": "Даже небольшие регулярные накопления со временем формируют запас, который помогает пережить трудный период без долгов и лишнего стресса."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 3: how_to_save
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'savings'),
           'how_to_save',
           3,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'how_to_save'),
           'ru',
           'Как начать откладывать'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'how_to_save'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Многие считают, что откладывать можно только при высоком доходе. На практике это не так — важнее не сумма, а привычка."},
               {"type": "paragraph", "text": "Даже при небольшом доходе можно начать формировать сбережения."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Чтобы начать откладывать деньги, важно соблюдать несколько принципов:"},
               {"type": "bullet_list", "items": [
                 "сначала откладывать, потом тратить",
                 "выбирать фиксированный процент от дохода",
                 "делать это регулярно",
                 "хранить деньги отдельно"
               ]},
               {"type": "paragraph", "text": "Часто рекомендуют откладывать 10–20% дохода, но можно начать даже с 5%."},
               {"type": "paragraph", "text": "Главное — системность."},
               {"type": "paragraph", "text": "В Казахстане для накоплений можно использовать несколько простых инструментов:"},
               {"type": "bullet_list", "items": [
                 "текущий банковский счёт (карта) — подходит для начального этапа, деньги всегда доступны",
                 "сберегательный (накопительный) счёт — позволяет хранить деньги отдельно и иногда получать небольшой процент",
                 "банковский депозит — деньги размещаются на определённый срок и приносят процентный доход (обычно выше, чем на обычных счетах)",
                 "автоматические переводы — многие банковские приложения позволяют настроить регулярное отчисление части дохода на отдельный счёт"
               ]},
               {"type": "paragraph", "text": "Такие инструменты помогают разделить деньги «на жизнь» и «на накопления», что значительно упрощает контроль."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Человек получает 200 000 ₸ и решает откладывать 10%."},
               {"type": "paragraph", "text": "Каждый месяц:"},
               {"type": "paragraph", "text": "200 000 × 0.10 = 20 000 ₸"},
               {"type": "paragraph", "text": "За год:"},
               {"type": "paragraph", "text": "20 000 × 12 = 240 000 ₸"},
               {"type": "paragraph", "text": "Даже без увеличения дохода формируется ощутимая сумма."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'how_to_save'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Начать откладывать можно с любой суммы."},
               {"type": "paragraph", "text": "Гораздо важнее регулярность и дисциплина, чем размер вложений."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 4: interest_on_savings
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'savings'),
           'interest_on_savings',
           4,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'interest_on_savings'),
           'ru',
           'Процент на накопления'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'interest_on_savings'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Когда человек начинает откладывать деньги, возникает следующий вопрос: можно ли не только сохранять сумму, но и немного её увеличить."},
               {"type": "paragraph", "text": "Один из простых способов — размещать деньги на накопительном продукте, где начисляется процент."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Процент на накопления показывает, какой дополнительный доход можно получить от первоначальной суммы."},
               {"type": "paragraph", "text": "В самом простом случае используется модель простых процентов. Это значит, что проценты начисляются только на первоначально вложенную сумму."},
               {"type": "paragraph", "text": "Формула расчёта:"},
               {"type": "paragraph", "text": "I = P × r × t"},
               {"type": "paragraph", "text": "Где:"},
               {"type": "bullet_list", "items": [
                 "I — доход по процентам",
                 "P — первоначальная сумма",
                 "r — годовая ставка",
                 "t — срок в годах"
               ]},
               {"type": "paragraph", "text": "Такой расчёт помогает понять базовый принцип роста накоплений."},
               {"type": "paragraph", "text": "В Казахстане тема накоплений особенно актуальна, потому что люди часто хранят деньги просто на карте или наличными, не задумываясь, что даже небольшой процент помогает частично компенсировать потерю ценности денег со временем."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Допустим, человек разместил 120 000 ₸ под 10% годовых на 1 год."},
               {"type": "paragraph", "text": "Считаем доход:"},
               {"type": "paragraph", "text": "120 000 × 0.10 × 1 = 12 000 ₸"},
               {"type": "paragraph", "text": "Значит:"},
               {"type": "bullet_list", "items": [
                 "доход по процентам = 12 000 ₸",
                 "итоговая сумма = 132 000 ₸"
               ]}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings')),
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
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассчитайте доход и итоговую сумму, если 200 000 ₸ размещены под 5% годовых на 2 года."}
             ]
           }'::jsonb,
           '{
             "instruction": "Рассчитайте доход и итоговую сумму, если 200 000 ₸ размещены под 5% годовых на 2 года.",
             "fields": [
               {"id": "interest_income", "label": "Доход"},
               {"id": "total_amount", "label": "Итоговая сумма"}
             ],
             "validation": {
               "rules": [
                 "Доход = 200000 × 0.05 × 2",
                 "Итоговая сумма = первоначальная сумма + доход"
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
             "explanation": "Обратите внимание, что срок составляет 2 года, поэтому процент умножается на время. Проценты начисляются только на первоначальную сумму."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_on_savings'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Простые проценты — это базовый и понятный способ показать, как накопления могут приносить дополнительный доход."},
               {"type": "paragraph", "text": "Даже если сумма кажется небольшой, такой расчёт формирует полезное финансовое мышление: деньги можно не только тратить, но и постепенно увеличивать."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 5: saving_mistakes
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'savings'),
           'saving_mistakes',
           5,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'saving_mistakes'),
           'ru',
           'Ошибки при накоплении'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'saving_mistakes'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Даже при желании откладывать деньги многие сталкиваются с тем, что накопления не формируются или быстро исчезают."},
               {"type": "paragraph", "text": "Чаще всего причина — не в доходе, а в ошибках поведения."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Основные ошибки при накоплении"},
               {"type": "bullet_list", "items": [
                 "отсутствие конкретной цели",
                 "нерегулярные отчисления",
                 "откладывание «остатков»",
                 "использование накоплений на повседневные траты",
                 "слишком высокая планка"
               ]},
               {"type": "paragraph", "text": "Эти ошибки мешают формированию привычки и снижают мотивацию."},
               {"type": "paragraph", "text": "В казахстанской практике часто встречается ситуация, когда накопления тратятся на незапланированные покупки или помощь родственникам без учёта собственных финансовых возможностей."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Человек планирует откладывать 30 000 ₸ в месяц, но"},
               {"type": "bullet_list", "items": [
                 "один месяц пропускает",
                 "в другой тратит часть накоплений",
                 "в третий снижает сумму"
               ]},
               {"type": "paragraph", "text": "В итоге за год не формируется ожидаемый результат."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'saving_mistakes'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ошибки при накоплении чаще связаны не с математикой, а с поведением."},
               {"type": "paragraph", "text": "Осознание этих ошибок помогает выстроить устойчивую финансовую привычку."}
             ]
           }'::jsonb
       );

commit;