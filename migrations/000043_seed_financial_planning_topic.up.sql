begin;

-- =========================================
-- ТЕМА: financial_planning
-- =========================================

insert into topics (code, level, order_index, is_active)
values ('financial_planning', 'intermediate', 2, true);

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'financial_planning'),
           'ru',
           'Финансовое планирование'
       );

-- =========================================
-- САБТОПИК 1: financial_goals
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'financial_planning'),
           'financial_goals',
           1,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'financial_goals'),
           'ru',
           'Финансовые цели'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'financial_goals'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Финансовое планирование начинается с понимания того, к чему вы хотите прийти."},
               {"type": "paragraph", "text": "В условиях Казахстана, где уровень доходов и расходов может значительно различаться в зависимости от региона, профессии и экономической ситуации, особенно важно осознанно подходить к управлению деньгами."},
               {"type": "paragraph", "text": "Без конкретной цели любые действия с финансами становятся хаотичными: доходы поступают и тратятся, но ощутимого результата не возникает."},
               {"type": "paragraph", "text": "Именно финансовые цели помогают задать направление и превратить управление деньгами в системный процесс."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Финансовая цель — это конкретный результат, которого вы хотите достичь с помощью своих денежных ресурсов."},
               {"type": "paragraph", "text": "Она отвечает на ключевой вопрос: «зачем вам нужны накопления и контроль расходов»."},
               {"type": "paragraph", "text": "В практике личных финансов цели могут быть разными:"},
               {"type": "bullet_list", "items": [
                 "формирование финансовой подушки безопасности (например, 3–6 месяцев расходов)",
                 "покупка недвижимости или первоначальный взнос по ипотеке",
                 "приобретение автомобиля",
                 "оплата образования (в том числе зарубежного)",
                 "создание инвестиционного капитала",
                 "крупные покупки или путешествия"
               ]},
               {"type": "paragraph", "text": "В Казахстане одной из наиболее распространённых целей является накопление на первоначальный взнос по ипотеке, так как стоимость недвижимости остаётся значительной по отношению к средним доходам."},
               {"type": "paragraph", "text": "Чтобы цель действительно работала, она должна соответствовать трём критериям:"},
               {"type": "bullet_list", "items": [
                 "конкретность (понятно, на что именно вы копите)",
                 "измеримость (есть чёткая сумма)",
                 "ограниченность по времени (указан срок достижения)"
               ]},
               {"type": "paragraph", "text": "Например:"},
               {"type": "paragraph", "text": "«накопить 3 000 000 ₸ на первоначальный взнос за 2 года»"},
               {"type": "paragraph", "text": "Такая формулировка уже позволяет перейти к расчётам и планированию."},
               {"type": "paragraph", "text": "Без чётко сформулированной цели сложно:"},
               {"type": "bullet_list", "items": [
                 "оценить прогресс",
                 "определить необходимый уровень сбережений",
                 "принимать обоснованные финансовые решения"
               ]}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассмотрим две формулировки:"},
               {"type": "paragraph", "text": "1. «Хочу начать откладывать деньги»"},
               {"type": "paragraph", "text": "2. «Накопить 600 000 ₸ на резервный фонд за 12 месяцев»"},
               {"type": "paragraph", "text": "Во втором случае:"},
               {"type": "bullet_list", "items": [
                 "понятна конечная сумма",
                 "есть срок",
                 "можно рассчитать ежемесячный взнос (50 000 ₸)",
                 "легче контролировать выполнение"
               ]},
               {"type": "paragraph", "text": "Такая цель превращается из абстрактного желания в конкретный план действий."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals')),
           'interactive',
           4,
           'input_text'
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
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сформулируйте свою финансовую цель. Укажите, на что именно вы хотите накопить, какую сумму планируете достичь и, по возможности, срок."}
             ]
           }'::jsonb,
           '{
             "instruction": "Сформулируйте свою финансовую цель. Укажите, на что именно вы хотите накопить, какую сумму планируете достичь и, по возможности, срок.",
             "fields": [
               {"id": "goal_description", "label": "Ваша финансовая цель"}
             ],
             "validation": {
               "rules": [
                 "Ответ не должен быть пустым",
                 "Ответ должен содержать осмысленное описание цели"
               ]
             },
             "exampleAnswer": {
               "goal_description": "Накопить 1 000 000 ₸ на первоначальный взнос по ипотеке за 18 месяцев"
             },
             "explanation": "Чётко сформулированная цель позволяет перейти к следующему этапу — плану накопления и распределению доходов. Без конкретной цели финансовое поведение остаётся несистемным."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'financial_goals'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Финансовые цели являются основой личного финансового планирования."},
               {"type": "paragraph", "text": "Они помогают структурировать доходы и расходы, формировать накопления и принимать обоснованные решения."},
               {"type": "paragraph", "text": "Чем точнее определена цель, тем выше вероятность её достижения и тем устойчивее становится ваше финансовое положение."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 2: short_vs_long_goals
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'financial_planning'),
           'short_vs_long_goals',
           2,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'short_vs_long_goals'),
           'ru',
           'Краткосрочные vs долгосрочные цели'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'short_vs_long_goals'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Не все финансовые цели одинаковы по срокам и подходу к их достижению."},
               {"type": "paragraph", "text": "Одни цели можно реализовать в течение нескольких месяцев, другие требуют нескольких лет планирования."},
               {"type": "paragraph", "text": "Понимание различий между краткосрочными и долгосрочными целями помогает правильно распределять ресурсы и избегать финансовых ошибок."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Финансовые цели принято делить на краткосрочные и долгосрочные в зависимости от срока их достижения."},
               {"type": "paragraph", "text": "Краткосрочные цели — это цели, которые планируется достичь в течение короткого периода, обычно до 1 года."},
               {"type": "paragraph", "text": "К ним относятся:"},
               {"type": "bullet_list", "items": [
                 "покупка бытовой техники",
                 "оплата поездки или отпуска",
                 "формирование небольшой финансовой подушки",
                 "закрытие текущих обязательств"
               ]},
               {"type": "paragraph", "text": "Долгосрочные цели — это цели, достижение которых требует значительного времени, как правило от 1 года и более."},
               {"type": "paragraph", "text": "К ним относятся:"},
               {"type": "bullet_list", "items": [
                 "накопление на первоначальный взнос по ипотеке",
                 "покупка недвижимости",
                 "создание инвестиционного капитала",
                 "формирование пенсионных накоплений"
               ]},
               {"type": "paragraph", "text": "В условиях нашей страны долгосрочные цели часто связаны с недвижимостью, так как стоимость жилья остаётся высокой относительно доходов, и накопление требует времени и дисциплины."},
               {"type": "paragraph", "text": "Ключевое различие между этими типами целей заключается в подходе:"},
               {"type": "bullet_list", "items": [
                 "краткосрочные цели требуют высокой ликвидности (деньги должны быть доступны в любой момент)",
                 "долгосрочные цели допускают более сложные инструменты и стратегии накопления"
               ]},
               {"type": "paragraph", "text": "Также важно учитывать влияние инфляции."},
               {"type": "paragraph", "text": "При долгосрочном планировании в Казахстане инфляция может существенно снижать покупательную способность накоплений, поэтому простое хранение денег без доходности становится менее эффективным."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассмотрим две цели:"},
               {"type": "paragraph", "text": "1. Накопить 300 000 ₸ на отпуск за 6 месяцев"},
               {"type": "paragraph", "text": "2. Накопить 5 000 000 ₸ на первоначальный взнос по ипотеке за 3 года"},
               {"type": "paragraph", "text": "Первая цель:"},
               {"type": "bullet_list", "items": [
                 "короткий срок",
                 "относительно небольшая сумма",
                 "можно использовать обычные накопления"
               ]},
               {"type": "paragraph", "text": "Вторая цель:"},
               {"type": "bullet_list", "items": [
                 "длительный срок",
                 "крупная сумма",
                 "требует системного подхода и регулярных взносов"
               ]},
               {"type": "paragraph", "text": "Попытка реализовать долгосрочную цель теми же методами, что и краткосрочную, часто приводит к затягиванию сроков или отказу от цели."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'short_vs_long_goals'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Разделение финансовых целей на краткосрочные и долгосрочные позволяет выбирать правильные стратегии их достижения."},
               {"type": "paragraph", "text": "Краткосрочные цели требуют простоты и доступности средств, тогда как долгосрочные — планирования, дисциплины и учёта экономических факторов, таких как инфляция."},
               {"type": "paragraph", "text": "Чёткое понимание типа цели помогает более эффективно управлять своими финансами и повышает вероятность её достижения."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 3: spending_priorities
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'financial_planning'),
           'spending_priorities',
           3,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'spending_priorities'),
           'ru',
           'Приоритеты расходов'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'spending_priorities'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Даже при стабильном доходе финансовые цели могут не достигаться, если расходы не контролируются."},
               {"type": "paragraph", "text": "Часто проблема заключается не в недостатке денег, а в отсутствии чётких приоритетов."},
               {"type": "paragraph", "text": "Понимание того, какие расходы являются обязательными, а какие — второстепенными, позволяет более эффективно управлять бюджетом."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Приоритеты расходов — это система распределения дохода, при которой сначала покрываются наиболее важные финансовые потребности, а затем — менее значимые."},
               {"type": "paragraph", "text": "Все расходы можно условно разделить на три категории:"},
               {"type": "bullet_list", "items": [
                 "обязательные расходы",
                 "важные, но гибкие расходы",
                 "необязательные (дискреционные) расходы"
               ]},
               {"type": "paragraph", "text": "Обязательные расходы — это те, без которых невозможно поддерживать базовый уровень жизни:"},
               {"type": "bullet_list", "items": [
                 "аренда или ипотека",
                 "продукты питания",
                 "коммунальные услуги",
                 "транспорт",
                 "минимальные платежи по кредитам"
               ]},
               {"type": "paragraph", "text": "Важные, но гибкие расходы:"},
               {"type": "bullet_list", "items": [
                 "одежда",
                 "образование",
                 "медицина (вне экстренных ситуаций)",
                 "бытовые покупки"
               ]},
               {"type": "paragraph", "text": "Необязательные расходы:"},
               {"type": "bullet_list", "items": [
                 "развлечения",
                 "кафе и рестораны",
                 "импульсные покупки",
                 "подписки и сервисы"
               ]},
               {"type": "paragraph", "text": "Значительную часть бюджета обычно занимают базовые расходы, однако именно необязательные траты чаще всего остаются без контроля и постепенно уменьшают возможность формировать накопления."},
               {"type": "paragraph", "text": "Расстановка приоритетов означает, что после получения дохода вы:"},
               {"type": "bullet_list", "items": [
                 "сначала покрываете обязательные расходы",
                 "затем откладываете средства на цели и накопления",
                 "и только после этого распределяете оставшуюся сумму на личные траты"
               ]},
               {"type": "paragraph", "text": "Такой подход позволяет не только контролировать бюджет, но и системно двигаться к финансовым целям."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ваш ежемесячный доход — 300 000 ₸."},
               {"type": "paragraph", "text": "Расходы:"},
               {"type": "bullet_list", "items": [
                 "аренда и коммунальные услуги: 120 000 ₸",
                 "продукты и транспорт: 80 000 ₸",
                 "кредиты: 40 000 ₸"
               ]},
               {"type": "paragraph", "text": "После обязательных расходов остаётся: 60 000 ₸"},
               {"type": "paragraph", "text": "Если эти деньги тратятся без контроля (кафе, покупки, развлечения), накопления не формируются."},
               {"type": "paragraph", "text": "Если же вы сначала откладываете, например, 30 000 ₸ на цель, а оставшиеся 30 000 ₸ используете на личные траты, появляется баланс между текущим комфортом и будущими результатами."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'spending_priorities'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Приоритеты расходов позволяют управлять деньгами осознанно, а не реагировать на текущие желания."},
               {"type": "paragraph", "text": "Чёткое разделение расходов помогает сохранять финансовую устойчивость и регулярно двигаться к целям."},
               {"type": "paragraph", "text": "Даже при среднем уровне дохода правильная расстановка приоритетов может существенно улучшить финансовое положение."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 4: savings_plan
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'financial_planning'),
           'savings_plan',
           4,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'savings_plan'),
           'ru',
           'План накопления'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'savings_plan'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "После того как финансовая цель определена, следующим шагом становится план её достижения."},
               {"type": "paragraph", "text": "Без конкретного плана даже чёткая цель может оставаться только намерением, потому что неясно, какую сумму и с какой регулярностью необходимо откладывать."},
               {"type": "paragraph", "text": "План накопления помогает превратить цель в последовательность конкретных действий и оценить, насколько она реалистична при текущем бюджете."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "План накопления — это расчёт, который показывает, какую сумму необходимо регулярно откладывать, чтобы достичь финансовой цели в установленный срок."},
               {"type": "paragraph", "text": "Базовый принцип следующий:"},
               {"type": "paragraph", "text": "ежемесячный взнос = сумма цели / количество месяцев"},
               {"type": "paragraph", "text": "Однако на практике одного расчёта недостаточно. Важно понять, соответствует ли этот план вашим финансовым возможностям."},
               {"type": "paragraph", "text": "Если необходимый ежемесячный взнос слишком высок по сравнению со свободной частью дохода, цель может оказаться нереалистичной в выбранные сроки."},
               {"type": "paragraph", "text": "Поэтому при построении плана накопления важно учитывать:"},
               {"type": "bullet_list", "items": [
                 "сумму цели",
                 "срок достижения",
                 "размер свободных средств после обязательных расходов",
                 "устойчивость плана в течение нескольких месяцев"
               ]},
               {"type": "paragraph", "text": "Реалистичный план — это не максимальный, а выполнимый план, который можно соблюдать без постоянных срывов."},
               {"type": "paragraph", "text": "Если расчёт показывает слишком высокую нагрузку, возможны несколько решений:"},
               {"type": "bullet_list", "items": [
                 "увеличить срок накопления",
                 "сократить целевую сумму",
                 "пересмотреть структуру расходов",
                 "найти дополнительные источники дохода"
               ]}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Вы хотите накопить 720 000 ₸ за 12 месяцев."},
               {"type": "paragraph", "text": "Расчёт показывает:"},
               {"type": "paragraph", "text": "720 000 / 12 = 60 000 ₸ в месяц"},
               {"type": "paragraph", "text": "При этом после обязательных расходов у вас остаётся только 45 000 ₸ свободных средств."},
               {"type": "paragraph", "text": "Это означает, что текущий план требует суммы, превышающей ваши реальные возможности."},
               {"type": "paragraph", "text": "В такой ситуации можно, например, увеличить срок до 16 месяцев:"},
               {"type": "paragraph", "text": "720 000 / 16 = 45 000 ₸"},
               {"type": "paragraph", "text": "Теперь цель становится более реалистичной и лучше соответствует вашему бюджету."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan')),
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
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассчитайте, является ли план накопления реалистичным. Цель — 720 000 ₸ за 12 месяцев. После обязательных расходов у вас остаётся 45 000 ₸ в месяц. Определите необходимый ежемесячный взнос и разницу между требуемой суммой и доступными средствами."}
             ]
           }'::jsonb,
           '{
             "instruction": "Рассчитайте, является ли план накопления реалистичным. Цель — 720 000 ₸ за 12 месяцев. После обязательных расходов у вас остаётся 45 000 ₸ в месяц. Определите необходимый ежемесячный взнос и разницу между требуемой суммой и доступными средствами.",
             "fields": [
               {"id": "monthly_saving_needed", "label": "Необходимый ежемесячный взнос"},
               {"id": "difference_amount", "label": "Нехватка или остаток в месяц"}
             ],
             "validation": {
               "rules": [
                 "Необходимый ежемесячный взнос = 720000 / 12",
                 "Разница = 45000 - monthly_saving_needed"
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
             "explanation": "Для достижения цели нужно откладывать 60 000 ₸ в месяц, но свободных средств только 45 000 ₸. Это означает нехватку 15 000 ₸ ежемесячно. В текущем виде план нереалистичен, поэтому необходимо увеличить срок, уменьшить цель или пересмотреть расходы."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'savings_plan'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "План накопления должен быть не только математически правильным, но и выполнимым в реальной жизни."},
               {"type": "paragraph", "text": "Если цель не соответствует возможностям бюджета, лучше скорректировать условия заранее, чем постоянно сталкиваться с невыполнением плана."},
               {"type": "paragraph", "text": "Реалистичный план повышает вероятность того, что финансовая цель действительно будет достигнута."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 5: progress_control
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'financial_planning'),
           'progress_control',
           5,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'progress_control'),
           'ru',
           'Контроль выполнения'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'progress_control'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Даже при наличии чёткой финансовой цели и продуманного плана накопления результат не гарантирован."},
               {"type": "paragraph", "text": "Основная причина — отсутствие регулярного контроля."},
               {"type": "paragraph", "text": "Без отслеживания прогресса и корректировки действий даже реалистичный план может постепенно перестать выполняться."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Контроль выполнения — это процесс регулярной проверки того, насколько фактические действия соответствуют запланированным."},
               {"type": "paragraph", "text": "Он позволяет:"},
               {"type": "bullet_list", "items": [
                 "отслеживать прогресс по достижению цели",
                 "выявлять отклонения от плана",
                 "своевременно корректировать поведение"
               ]},
               {"type": "paragraph", "text": "На практике контроль может включать:"},
               {"type": "bullet_list", "items": [
                 "ежемесячную проверку накопленной суммы",
                 "сравнение фактических накоплений с планом",
                 "анализ причин отклонений (например, незапланированные расходы)"
               ]},
               {"type": "paragraph", "text": "Важно понимать, что отклонения от плана — это нормальная ситуация."},
               {"type": "paragraph", "text": "Финансовое поведение зависит от множества факторов:"},
               {"type": "bullet_list", "items": [
                 "изменения дохода",
                 "непредвиденные расходы",
                 "сезонные колебания расходов"
               ]},
               {"type": "paragraph", "text": "Поэтому задача контроля — не «наказать себя» за отклонения, а вовремя их заметить и скорректировать план."},
               {"type": "paragraph", "text": "Эффективный контроль строится на регулярности."},
               {"type": "paragraph", "text": "Даже простая привычка проверять состояние накоплений один раз в месяц уже значительно повышает вероятность достижения цели."},
               {"type": "paragraph", "text": "Также важно фиксировать прогресс."},
               {"type": "paragraph", "text": "Когда вы видите, что сумма накоплений постепенно растёт, это усиливает мотивацию и помогает сохранять дисциплину."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Вы планируете откладывать 50 000 ₸ в месяц."},
               {"type": "paragraph", "text": "Через 3 месяца по плану у вас должно быть 150 000 ₸."},
               {"type": "paragraph", "text": "Фактически накоплено 120 000 ₸."},
               {"type": "paragraph", "text": "Отклонение составляет 30 000 ₸."},
               {"type": "paragraph", "text": "Это сигнал:"},
               {"type": "bullet_list", "items": [
                 "либо расходы были выше, чем ожидалось",
                 "либо план изначально был слишком оптимистичным"
               ]},
               {"type": "paragraph", "text": "В такой ситуации можно:"},
               {"type": "bullet_list", "items": [
                 "скорректировать ежемесячный взнос",
                 "увеличить срок достижения цели",
                 "пересмотреть структуру расходов"
               ]},
               {"type": "paragraph", "text": "Главное — не игнорировать отклонение, а принять решение."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id
               from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'progress_control'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Контроль выполнения — это ключевой элемент финансового планирования, который превращает цели и расчёты в реальный результат."},
               {"type": "paragraph", "text": "Регулярное отслеживание прогресса позволяет вовремя замечать проблемы и адаптировать план под реальные условия."},
               {"type": "paragraph", "text": "Даже простой, но системный контроль значительно повышает вероятность достижения финансовых целей."}
             ]
           }'::jsonb
       );

commit;