begin;

-- =========================================
-- ТЕМА 2: credit_and_debt
-- =========================================

insert into topics (code, level, order_index, is_active)
values ('credit_and_debt', 'intermediate', 1, true);

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'credit_and_debt'),
           'ru',
           'Кредиты и долги'
       );

-- =========================================
-- САБТОПИК 1: what_is_credit
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'credit_and_debt'),
           'what_is_credit',
           1,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'what_is_credit'),
           'ru',
           'Что такое кредит'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'what_is_credit'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "В жизни часто возникают ситуации, когда нужная сумма требуется сразу: покупка техники, лечение, обучение или непредвиденные расходы."},
               {"type": "paragraph", "text": "Если собственных средств недостаточно, одним из решений становится кредит."},
               {"type": "paragraph", "text": "Однако важно понимать, что кредит — это не просто способ получить деньги сейчас, а финансовое обязательство, которое напрямую влияет на ваши будущие доходы."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Кредит — это денежные средства, которые банк или финансовая организация предоставляет вам во временное пользование на определённых условиях."},
               {"type": "paragraph", "text": "Эти условия включают:"},
               {"type": "bullet_list", "items": ["срок возврата", "процентную ставку", "график платежей"]},
               {"type": "paragraph", "text": "Ключевой принцип кредита — возврат с переплатой."},
               {"type": "paragraph", "text": "Это означает, что вы возвращаете не только основную сумму долга (тело кредита), но и проценты — плату за использование денежных средств."},
               {"type": "paragraph", "text": "С точки зрения финансов, кредит можно рассматривать как инструмент перераспределения ресурсов во времени: вы используете деньги сейчас, а оплачиваете их за счёт будущих доходов."},
               {"type": "paragraph", "text": "Поэтому каждый оформленный кредит снижает вашу финансовую гибкость в будущем и увеличивает обязательства."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Вы оформляете кредит на сумму 100 000 ₸ сроком на 12 месяцев."},
               {"type": "paragraph", "text": "В течение года вы возвращаете банку, например, 120 000 ₸."},
               {"type": "paragraph", "text": "100 000 ₸ — тело кредита"},
               {"type": "paragraph", "text": "20 000 ₸ — проценты (стоимость кредита)"},
               {"type": "paragraph", "text": "Фактически вы платите за возможность воспользоваться деньгами раньше, чем смогли бы их накопить самостоятельно."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_is_credit'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Кредит — это финансовый инструмент, который позволяет решить текущую задачу за счёт будущих доходов."},
               {"type": "paragraph", "text": "Он может быть полезным, если используется осознанно, но всегда связан с дополнительными расходами и обязательствами."},
               {"type": "paragraph", "text": "Перед оформлением кредита важно оценивать не только текущую необходимость, но и свою способность комфортно выполнять обязательства в будущем."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 2: interest_rate
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'credit_and_debt'),
           'interest_rate',
           2,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'interest_rate'),
           'ru',
           'Процентная ставка'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'interest_rate'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "При оформлении кредита одним из ключевых параметров является процентная ставка."},
               {"type": "paragraph", "text": "Именно она определяет, сколько вы заплатите за пользование деньгами сверх основной суммы долга."},
               {"type": "paragraph", "text": "Даже небольшая разница в ставке может существенно повлиять на итоговую переплату."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Процентная ставка — это стоимость кредита, выраженная в процентах от суммы займа за определённый период (обычно за год)."},
               {"type": "paragraph", "text": "Она показывает, какую долю от суммы кредита вы платите банку за возможность пользоваться его деньгами."},
               {"type": "paragraph", "text": "Например: если ставка составляет 20% годовых, это означает, что за год вы заплатите около 20% от суммы кредита в виде процентов (без учёта особенностей расчёта)."},
               {"type": "paragraph", "text": "Важно учитывать, что в реальности банки используют разные схемы начисления процентов:"},
               {"type": "bullet_list", "items": ["аннуитетные платежи (равные ежемесячные выплаты)", "дифференцированные платежи"]},
               {"type": "paragraph", "text": "Кроме того, существует показатель ГЭСВ (годовая эффективная ставка вознаграждения), который включает в себя не только проценты, но и дополнительные комиссии."},
               {"type": "paragraph", "text": "Именно ГЭСВ даёт более точное представление о реальной стоимости кредита."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Вы берёте кредит 200 000 ₸ под 20% годовых."},
               {"type": "paragraph", "text": "Упрощённо можно ожидать, что за год переплата составит около 40 000 ₸."},
               {"type": "paragraph", "text": "Однако если учитывать реальный график платежей и комиссии, итоговая сумма может быть выше."},
               {"type": "paragraph", "text": "Например:"},
               {"type": "bullet_list", "items": ["при одной ставке вы вернёте 240 000 ₸", "при другой — уже 260 000 ₸"]},
               {"type": "paragraph", "text": "Разница кажется небольшой в процентах, но в деньгах она становится заметной."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate')),
           'interactive',
           4,
           'single_choice'
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
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Перед вами два варианта кредита на одинаковую сумму. Выберите вариант, который выглядит более выгодным по итоговой сумме возврата."}
             ]
           }'::jsonb,
           '{
             "instruction": "Перед вами два варианта кредита на одинаковую сумму. Выберите вариант, который выглядит более выгодным по итоговой сумме возврата.",
             "question": "Какой вариант кредита выгоднее по итоговой сумме возврата?",
             "options": [
               {"id": "1", "text": "Вариант A"},
               {"id": "2", "text": "Вариант B"}
             ],
             "correctAnswer": "1",
             "data": {
               "variantA": {
                 "amount": "200 000 ₸",
                 "rate": "18%",
                 "totalReturn": "236 000 ₸"
               },
               "variantB": {
                 "amount": "200 000 ₸",
                 "rate": "22%",
                 "totalReturn": "252 000 ₸"
               }
             },
             "explanation": "Оба кредита выданы на одну и ту же сумму, но отличаются по процентной ставке. Более низкая ставка уменьшает итоговую стоимость кредита. В данном случае разница всего в несколько процентов приводит к заметной разнице в общей сумме возврата."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'interest_rate'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Процентная ставка — один из главных факторов, определяющих стоимость кредита."},
               {"type": "paragraph", "text": "При выборе кредита важно ориентироваться не только на «низкий процент», но и на полную стоимость, включая комиссии и условия выплат."},
               {"type": "paragraph", "text": "Даже небольшое снижение ставки может существенно уменьшить итоговую переплату."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 3: credit_overpayment
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'credit_and_debt'),
           'credit_overpayment',
           3,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'credit_overpayment'),
           'ru',
           'Переплата по кредиту'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'credit_overpayment'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Когда вы берёте кредит, вы возвращаете банку больше, чем получили."},
               {"type": "paragraph", "text": "Эта разница называется переплатой, и именно она показывает реальную стоимость кредита."},
               {"type": "paragraph", "text": "На практике именно переплата часто становится тем фактором, который недооценивают при оформлении займа."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Переплата по кредиту — это разница между суммой, которую вы получили, и общей суммой, которую вы в итоге возвращаете банку."},
               {"type": "paragraph", "text": "Она формируется за счёт:"},
               {"type": "bullet_list", "items": ["процентной ставки", "срока кредита", "схемы платежей", "возможных комиссий и дополнительных платежей"]},
               {"type": "paragraph", "text": "Чем дольше срок кредита и выше процентная ставка, тем больше итоговая переплата."},
               {"type": "paragraph", "text": "Важно понимать, что даже при одинаковой сумме кредита итоговая переплата может сильно различаться в зависимости от условий."},
               {"type": "paragraph", "text": "Кроме того, при аннуитетных платежах (равных ежемесячных выплатах) значительная часть процентов выплачивается в первые месяцы, что также увеличивает фактическую нагрузку на бюджет."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Вы берёте кредит 300 000 ₸ на 2 года."},
               {"type": "paragraph", "text": "В итоге вы возвращаете банку 420 000 ₸."},
               {"type": "paragraph", "text": "300 000 ₸ — сумма кредита"},
               {"type": "paragraph", "text": "120 000 ₸ — переплата"},
               {"type": "paragraph", "text": "Фактически вы платите 40% сверху за возможность воспользоваться деньгами раньше."},
               {"type": "paragraph", "text": "Если увеличить срок кредита до 3 лет, итоговая сумма может вырасти, например, до 480 000 ₸."},
               {"type": "paragraph", "text": "переплата уже составит 180 000 ₸"},
               {"type": "paragraph", "text": "Это показывает, как срок напрямую влияет на итоговую стоимость кредита."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_overpayment'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Переплата — это ключевой показатель, который отражает реальную стоимость кредита."},
               {"type": "paragraph", "text": "При выборе кредита важно обращать внимание не только на размер ежемесячного платежа, но и на итоговую сумму возврата."},
               {"type": "paragraph", "text": "Чем выше переплата, тем больше финансовая нагрузка в долгосрочной перспективе."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 4: credit_load
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'credit_and_debt'),
           'credit_load',
           4,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'credit_load'),
           'ru',
           'Кредитная нагрузка'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'credit_load'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "При использовании кредитов важно учитывать не только их стоимость, но и то, насколько они влияют на ваш ежемесячный бюджет."},
               {"type": "paragraph", "text": "Даже при «выгодной» ставке кредит может стать проблемой, если платежи занимают слишком большую часть дохода."},
               {"type": "paragraph", "text": "Именно для этого используется понятие кредитной нагрузки."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Кредитная нагрузка — это доля вашего дохода, которая уходит на погашение всех кредитов и займов."},
               {"type": "paragraph", "text": "Она рассчитывается как отношение ежемесячных платежей по кредитам к вашему доходу."},
               {"type": "paragraph", "text": "В упрощённом виде:"},
               {"type": "paragraph", "text": "кредитная нагрузка = (ежемесячные платежи / доход) × 100%"},
               {"type": "paragraph", "text": "Например: если вы зарабатываете 300 000 ₸ и платите по кредитам 90 000 ₸ в месяц, ваша кредитная нагрузка составляет 30%."},
               {"type": "paragraph", "text": "В финансовой практике считается, что:"},
               {"type": "bullet_list", "items": ["до 30% — безопасный уровень", "30–50% — повышенная нагрузка", "более 50% — высокий риск финансовых проблем"]},
               {"type": "paragraph", "text": "Чем выше кредитная нагрузка, тем меньше у вас остаётся средств на повседневные расходы, накопления и непредвиденные ситуации."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ваш ежемесячный доход — 250 000 ₸."},
               {"type": "paragraph", "text": "Вы платите:"},
               {"type": "bullet_list", "items": ["40 000 ₸ по одному кредиту", "30 000 ₸ по другому"]},
               {"type": "paragraph", "text": "Общий платёж: 70 000 ₸"},
               {"type": "paragraph", "text": "Кредитная нагрузка:"},
               {"type": "paragraph", "text": "70 000 / 250 000 × 100% = 28%"},
               {"type": "paragraph", "text": "Это близко к безопасному уровню, но при увеличении обязательств ситуация может быстро ухудшиться."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ИНТЕРАКТИВ
insert into lesson_steps (lesson_id, step_type, order_index, interactive_type)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load')),
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
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассчитайте свою кредитную нагрузку, если ежемесячный доход составляет 300 000 ₸, а суммарные платежи по кредитам — 120 000 ₸."}
             ]
           }'::jsonb,
           '{
             "instruction": "Рассчитайте свою кредитную нагрузку, если ежемесячный доход составляет 300 000 ₸, а суммарные платежи по кредитам — 120 000 ₸.",
             "fields": [
               {"id": "credit_load_percent", "label": "Кредитная нагрузка (%)"}
             ],
             "validation": {
               "formula": "(120000 / 300000) * 100",
               "expectedValue": 40
             },
             "exampleAnswer": {
               "credit_load_percent": 40
             },
             "explanation": "В данном случае 40% дохода уходит на кредиты. Это уже повышенный уровень нагрузки, при котором остаётся меньше финансовой гибкости и возрастает риск проблем при снижении дохода или появлении дополнительных расходов."
           }'::jsonb
       );

-- ШАГ 5 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'credit_load'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Кредитная нагрузка показывает, насколько ваши кредиты влияют на ваш бюджет."},
               {"type": "paragraph", "text": "Даже если каждый отдельный кредит выглядит manageable, их совокупный эффект может создавать значительное давление на финансы."},
               {"type": "paragraph", "text": "Перед оформлением нового кредита важно учитывать текущую нагрузку и оценивать, сохранится ли финансовая устойчивость в будущем."}
             ]
           }'::jsonb
       );

-- =========================================
-- САБТОПИК 5: choose_credit
-- =========================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'credit_and_debt'),
           'choose_credit',
           5,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'choose_credit'),
           'ru',
           'Как выбрать кредит'
       );

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'choose_credit'),
           true
       );

-- ШАГ 1 — ВВЕДЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "На рынке представлено множество кредитных предложений, и на первый взгляд они могут выглядеть похожими."},
               {"type": "paragraph", "text": "Однако различия в условиях могут существенно повлиять на итоговую стоимость кредита и вашу финансовую нагрузку."},
               {"type": "paragraph", "text": "Поэтому выбор кредита требует внимательного и осознанного подхода."}
             ]
           }'::jsonb
       );

-- ШАГ 2 — ОБЪЯСНЕНИЕ
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "При выборе кредита важно учитывать не один параметр, а совокупность условий."},
               {"type": "paragraph", "text": "Основные факторы, на которые стоит обратить внимание:"},
               {"type": "bullet_list", "items": [
                 "Процентная ставка — определяет базовую стоимость кредита. Чем ниже ставка, тем меньше переплата.",
                 "ГЭСВ (годовая эффективная ставка вознаграждения) — показывает реальную стоимость кредита с учётом всех комиссий и дополнительных платежей. Именно этот показатель даёт наиболее точное представление о расходах.",
                 "Срок кредита — более длительный срок уменьшает ежемесячный платёж, но увеличивает итоговую переплату.",
                 "Размер ежемесячного платежа — важно, чтобы он не создавал чрезмерной нагрузки на бюджет и оставлял пространство для других расходов.",
                 "Дополнительные комиссии — некоторые кредиты включают комиссии за оформление, обслуживание или досрочное погашение.",
                 "Условия досрочного погашения — гибкие условия позволяют сократить переплату, если у вас появится возможность погасить кредит раньше."
               ]},
               {"type": "paragraph", "text": "Важно сравнивать несколько предложений, а не выбирать первое доступное."},
               {"type": "paragraph", "text": "Даже небольшие различия в условиях могут привести к значительной разнице в итоговой сумме выплат."}
             ]
           }'::jsonb
       );

-- ШАГ 3 — ПРИМЕР
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Вы рассматриваете два варианта кредита на 300 000 ₸:"},
               {"type": "paragraph", "text": "Вариант A:"},
               {"type": "bullet_list", "items": ["Ставка: 18%", "Срок: 2 года", "Итоговая сумма: 390 000 ₸"]},
               {"type": "paragraph", "text": "Вариант B:"},
               {"type": "bullet_list", "items": ["Ставка: 20%", "Срок: 3 года", "Итоговая сумма: 450 000 ₸"]},
               {"type": "paragraph", "text": "Несмотря на более низкий ежемесячный платёж во втором варианте, итоговая переплата значительно выше."},
               {"type": "paragraph", "text": "Это показывает, что ориентироваться только на размер платежа недостаточно."}
             ]
           }'::jsonb
       );

-- ШАГ 4 — ВЫВОД
insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'choose_credit'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Выбор кредита должен основываться на анализе полной стоимости, а не только отдельных параметров."},
               {"type": "paragraph", "text": "Важно учитывать процентную ставку, срок, комиссии и свою кредитную нагрузку."},
               {"type": "paragraph", "text": "Осознанный выбор позволяет снизить переплату и сохранить финансовую устойчивость в долгосрочной перспективе."}
             ]
           }'::jsonb
       );

commit;