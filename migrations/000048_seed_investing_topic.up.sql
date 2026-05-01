begin;

-- =====================================
-- ТЕМА
-- =====================================

insert into topics (code, level, order_index, is_active)
values ('investments', 'advanced', 1, true);

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'investments'),
           'ru',
           'Инвестиции'
       );

-- =====================================
-- САБТОПИК
-- =====================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'investments'),
           'what_are_investments',
           1,
           7,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'what_are_investments'),
           'ru',
           'Что такое инвестиции'
       );

-- =====================================
-- LESSON
-- =====================================

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'what_are_investments'),
           true
       );

-- =====================================
-- ШАГ 1 — ВВЕДЕНИЕ
-- =====================================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Большинство людей знают, что деньги нужно не только хранить, но и приумножать. Однако граница между «откладывать» и «инвестировать» остаётся размытой."},
               {"type": "paragraph", "text": "Сбережения защищают от текущих рисков — инвестиции работают на долгосрочный рост капитала."},
               {"type": "paragraph", "text": "Понимание этой разницы — отправная точка для осознанного управления личными финансами."}
             ]
           }'::jsonb
       );

-- =====================================
-- ШАГ 2 — ОБЪЯСНЕНИЕ
-- =====================================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестиции — это вложение капитала в активы с целью получения дохода или прироста стоимости в будущем."},
               {"type": "paragraph", "text": "В отличие от сбережений, которые просто сохраняют деньги, инвестиции заставляют деньги работать."},

               {"type": "paragraph", "text": "Ключевые характеристики инвестиций:"},

               {"type": "paragraph", "text": "Временной горизонт:"},
               {"type": "paragraph", "text": "Инвестиции обычно рассчитаны на срок от 1 года и более. Чем длиннее срок — тем выше потенциал роста."},

               {"type": "paragraph", "text": "Доходность:"},
               {"type": "paragraph", "text": "Ожидаемая доходность, как правило, выше инфляции и банковских депозитов."},

               {"type": "paragraph", "text": "Риск:"},
               {"type": "paragraph", "text": "Инвестор осознанно принимает возможность потери части капитала ради более высокой доходности."},

               {"type": "paragraph", "text": "Ликвидность:"},
               {"type": "paragraph", "text": "Показывает, насколько быстро актив можно превратить обратно в деньги:"},
               {"type": "bullet_list", "items": ["акции — высокая ликвидность", "недвижимость или бизнес — низкая"]},

               {"type": "paragraph", "text": "Основные инструменты для инвестора в Казахстане:"},

               {"type": "paragraph", "text": "Консервативные инструменты"},
               {"type": "bullet_list", "items": [
                 "Депозиты в банках второго уровня",
                 "Государственные ценные бумаги (облигации Министерства финансов РК)"
               ]},

               {"type": "paragraph", "text": "Рыночные инструменты"},
               {"type": "bullet_list", "items": [
                 "Акции и облигации компаний на KASE",
                 "Инструменты МФЦА (AIX)"
               ]},

               {"type": "paragraph", "text": "Доступ к международным рынкам"},
               {"type": "bullet_list", "items": [
                 "Зарубежные акции и ETF через лицензированных брокеров"
               ]},

               {"type": "paragraph", "text": "Коллективные инвестиции"},
               {"type": "bullet_list", "items": [
                 "Паевые инвестиционные фонды (ПИФ)"
               ]},

               {"type": "paragraph", "text": "Долгосрочные накопления"},
               {"type": "bullet_list", "items": [
                 "Пенсионные накопления через ЕНПФ"
               ]},

               {"type": "paragraph", "text": "Важно понимать: инвестирование — это не спекуляция. Спекулянт стремится заработать на краткосрочных колебаниях цены; инвестор — на фундаментальном росте стоимости актива или получении регулярного дохода (дивиденды, купоны)."}
             ]
           }'::jsonb
       );

-- =====================================
-- ШАГ 3 — ПРИМЕР
-- =====================================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Рассмотрим двух казахстанцев, каждый из которых имеет свободные 1 000 000 ₸:"},

               {
                 "type": "table",
                 "headers": ["Инструмент", "Сумма", "Ставка / Доходность", "Доход за год"],
                 "rows": [
                   ["Сберегательный счёт (Алибек)", "1 000 000 ₸", "9%", "90 000 ₸"],
                   ["Депозит (Жанар)", "500 000 ₸", "9%", "45 000 ₸"],
                   ["ГЦБ РК (Жанар)", "300 000 ₸", "12%", "36 000 ₸"],
                   ["Акции KMG (Жанар)", "200 000 ₸", "~15% (дивиденды + рост)", "~30 000 ₸"],
                   ["ИТОГО Жанар", "1 000 000 ₸", "~11.1% эффективная", "~111 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Диверсифицированный подход Жанар даёт на 21 000 ₸ больше при тех же вложениях — и это без учёта сложного процента."}
             ]
           }'::jsonb
       );

-- =====================================
-- ШАГ 4 — ВЫВОД
-- =====================================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестиции — это осознанный выбор между потреблением сегодня и финансовым ростом завтра."},
               {"type": "paragraph", "text": "Казахстанский рынок предлагает достаточно инструментов для старта: от консервативных ГЦБ до акций национальных компаний."},
               {"type": "paragraph", "text": "Главное — понять природу каждого инструмента, прежде чем вкладывать деньги."}
             ]
           }'::jsonb
       );

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'investments'),
           'risk_and_return',
           2,
           8,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'risk_and_return'),
           'ru',
           'Риск и доходность'
       );

-- =====================================
-- LESSON
-- =====================================

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'risk_and_return'),
           true
       );

-- =====================
-- ШАГ 1 — ВВЕДЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Начинающие инвесторы нередко ищут инструменты с «высокой доходностью без риска». На практике такого не существует."},
               {"type": "paragraph", "text": "Риск и доходность — две стороны одной медали. Понимание их взаимосвязи — фундаментальный навык любого инвестора."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 2 — ОБЪЯСНЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Доходность — это прирост стоимости инвестиции за определённый период, выраженный в процентах. Включает в себя:"},
               {"type": "bullet_list", "items": [
                 "Капитальный прирост: рост рыночной цены актива",
                 "Текущий доход: дивиденды, купонные выплаты, арендный доход"
               ]},

               {"type": "paragraph", "text": "Риск в инвестициях — это вероятность того, что фактическая доходность окажется ниже ожидаемой, вплоть до полной потери вложений."},

               {"type": "paragraph", "text": "Основные виды инвестиционного риска:"},
               {"type": "bullet_list", "items": [
                 "Рыночный риск: колебания цен на активы под влиянием общей экономической конъюнктуры",
                 "Кредитный риск: дефолт эмитента (компания или государство не выплачивает долг)",
                 "Валютный риск: изменение курса тенге влияет на стоимость зарубежных активов",
                 "Инфляционный риск: доходность не покрывает инфляцию, реальная покупательная способность падает",
                 "Риск ликвидности: невозможность быстро продать актив по справедливой цене",
                 "Концентрационный риск: чрезмерная доля одного актива или сектора в портфеле"
               ]},

               {"type": "paragraph", "text": "Шкала риск/доходность (от низкого к высокому):"},
               {"type": "paragraph", "text": "Чем выше потенциальная доходность — тем выше риск"},

               {"type": "paragraph", "text": "Низкий риск"},
               {"type": "paragraph", "text": "Депозиты (КФГД) — банковские вклады в тенге с государственной гарантией возврата средств в пределах установленного лимита"},
               {"type": "paragraph", "text": "→ ГЦБ РК — облигации Министерства финансов, считаются надёжными, так как обеспечены государством"},

               {"type": "paragraph", "text": "Средний риск"},
               {"type": "paragraph", "text": "→ Корпоративные облигации — долговые бумаги компаний, приносят фиксированный доход, но зависят от финансового состояния эмитента"},
               {"type": "paragraph", "text": "→ Акции KASE — акции казахстанских компаний, доход формируется за счёт роста цены и дивидендов, возможны колебания стоимости"},

               {"type": "paragraph", "text": "Высокий риск"},
               {"type": "paragraph", "text": "→ Акции роста (зарубежные рынки) — акции компаний с высоким потенциалом роста, но с сильной волатильностью (цены могут резко меняться)"},
               {"type": "paragraph", "text": "→ Криптовалюты и производные инструменты — высокорискованные активы с непредсказуемыми колебаниями, возможны как быстрые прибыли, так и значительные потери"},

               {"type": "paragraph", "text": "Казахстанский контекст — дополнительные факторы риска:"},
               {"type": "bullet_list", "items": [
                 "Валютный риск тенге: в 2015 и 2022 годах тенге существенно девальвировал, что уничтожило реальную доходность тенговых депозитов",
                 "Страновой риск: концентрация экономики в сырьевом секторе означает высокую зависимость от цен на нефть",
                 "Риск регуляторных изменений: налоговое и финансовое законодательство РК продолжает развиваться"
               ]}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 3 — ПРИМЕР
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Три инвестора вложили по 2 000 000 ₸ на горизонте 3 лет:"},

               {
                 "type": "table",
                 "headers": ["Инвестор", "Инструмент", "Ожидаемая доходность", "Реализованный сценарий", "Итог"],
                 "rows": [
                   ["Нурлан", "Депозит КФГД", "10% годовых", "Гарантированный", "2 662 000 ₸"],
                   ["Айгерим", "Облигации КМГ", "13% годовых", "Без дефолта", "2 878 000 ₸"],
                   ["Дамир", "Акции KASE", "20% ожидаемые", "Падение рынка –15% в год 2", "2 204 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Дамир принял наибольший риск — и получил наихудший результат на коротком горизонте."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 4 — ИНТЕРАКТИВ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return')),
           'interactive',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "type": "scenario_selector",
             "instruction": "Перед вами три инвестора. У каждого — своя ситуация. Определите, какой уровень риска подходит каждому из них: низкий, умеренный или высокий.",
             "scenarios": [
               {
                 "text": "Аружан, 58 лет. Выходит на пенсию через 4 года. Накопления — основной источник дохода на пенсии. Не готова терпеть просадку более 10%.",
                 "correct_answer": "Низкий риск",
                 "explanation": "Короткий горизонт и зависимость от накоплений делают высокий риск неприемлемым. Подходят депозиты КФГД и ГЦБ."
               },
               {
                 "text": "Марат, 34 года. Стабильная зарплата, есть подушка безопасности на 6 месяцев. Инвестирует на 10–15 лет.",
                 "correct_answer": "Умеренный риск",
                 "explanation": "Длинный горизонт позволяет держать смешанный портфель."
               },
               {
                 "text": "Тимур, 26 лет. Работает в IT, высокий доход.",
                 "correct_answer": "Высокий риск",
                 "explanation": "Длинный горизонт и готовность к потерям."
               }
             ],
             "options": ["Низкий риск", "Умеренный риск", "Высокий риск"]
           }'::jsonb
       );

-- =====================
-- ШАГ 5 — ВЫВОД
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Не существует инструмента с высокой доходностью и нулевым риском."},
               {"type": "paragraph", "text": "Задача инвестора — выбрать уровень риска, соответствующий его целям."}
             ]
           }'::jsonb
       );

-- =====================================
-- САБТОПИК
-- =====================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'investments'),
           'diversification',
           3,
           8,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'diversification'),
           'ru',
           'Диверсификация'
       );

-- =====================================
-- LESSON
-- =====================================

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'diversification'),
           true
       );

-- =====================
-- ШАГ 1 — ВВЕДЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "«Не клади все яйца в одну корзину» — возможно, самое известное правило инвестирования."},
               {"type": "paragraph", "text": "За этой простой метафорой стоит одна из немногих стратегий, позволяющих снизить риск без пропорционального снижения доходности."},
               {"type": "paragraph", "text": "Диверсификация — это не просто «купить разные активы». Это принцип, основанный на том, как разные инвестиции ведут себя в разных условиях."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 2 — ОБЪЯСНЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Диверсификация — это распределение капитала между активами, доходности которых не движутся одинаково. Когда один актив падает, другой может расти или оставаться стабильным."},
               {"type": "paragraph", "text": "Это происходит потому, что активы реагируют на разные факторы:"},

               {"type": "bullet_list", "items": [
                 "акции зависят от экономики и бизнеса",
                 "облигации — от процентных ставок",
                 "золото — от кризисов и инфляции"
               ]},

               {"type": "paragraph", "text": "Уровни диверсификации:"},
               {"type": "bullet_list", "items": [
                 "По классам активов: акции, облигации, депозиты, недвижимость, драгоценные металлы",
                 "По географии: казахстанский рынок, развитые рынки (США, Европа), развивающиеся рынки",
                 "По секторам: нефтегаз, банки, ритейл, телеком, горнодобыча",
                 "По валютам: тенговые и долларовые инструменты, активы в евро",
                 "По срокам: краткосрочные, среднесрочные, долгосрочные"
               ]},

               {"type": "paragraph", "text": "Что диверсификация НЕ устраняет:"},
               {"type": "bullet_list", "items": [
                 "Систематический (рыночный) риск",
                 "Валютный риск на уровне страны"
               ]},

               {"type": "paragraph", "text": "Экономика РК исторически сильно зависит от нефтяного сектора."},
               {"type": "paragraph", "text": "Истинная диверсификация включает зарубежные рынки через ETF."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 3 — ПРИМЕР
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Два портфеля по 3 000 000 ₸:"},

               {
                 "type": "table",
                 "headers": ["Позиция", "Концентрированный портфель", "Диверсифицированный портфель"],
                 "rows": [
                   ["KMG", "1 500 000 ₸ (50%)", "600 000 ₸ (20%)"],
                   ["Kaspi.kz", "900 000 ₸ (30%)", "600 000 ₸ (20%)"],
                   ["Halyk Bank", "600 000 ₸ (20%)", "450 000 ₸ (15%)"],
                   ["ГЦБ", "—", "600 000 ₸ (20%)"],
                   ["ETF", "—", "450 000 ₸ (15%)"],
                   ["Золото", "—", "300 000 ₸ (10%)"],
                   ["Результат", "-27%", "-9%"]
                 ]
               }
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 4 — ИНТЕРАКТИВ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification')),
           'interactive',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "type": "portfolio_choice",
             "instruction": "Перед вами 3 варианта инвестиционного портфеля. Выберите тот, который лучше диверсифицирован.",
             "options": [
               {
                 "name": "Концентрированный портфель",
                 "data": ["Депозит 10%", "ГЦБ 10%", "Акции 70%"]
               },
               {
                 "name": "Сбалансированный портфель",
                 "data": ["Депозит 20%", "ГЦБ 20%", "Акции 20%", "ETF 25%", "Золото 15%"]
               },
               {
                 "name": "Ограниченный портфель",
                 "data": ["Депозит 60%", "ГЦБ 20%", "Акции 20%"]
               }
             ],
             "correct": "Сбалансированный портфель"
           }'::jsonb
       );

-- =====================
-- ШАГ 5 — ВЫВОД
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Диверсификация — единственный бесплатный обед в инвестировании."},
               {"type": "paragraph", "text": "Хороший портфель не должен зависеть от одного актива."}
             ]
           }'::jsonb
       );


-- =====================================
-- САБТОПИК
-- =====================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'investments'),
           'simple_instruments',
           4,
           10,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'simple_instruments'),
           'ru',
           'Простые инструменты (депозит, акции, облигации)'
       );

-- =====================================
-- LESSON
-- =====================================

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'simple_instruments'),
           true
       );

-- =====================
-- ШАГ 1 — ВВЕДЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Прежде чем переходить к сложным структурным продуктам, производным инструментам и альтернативным активам, важно хорошо понять базовые инструменты. Это основа, на которой строится любой инвестиционный портфель."},
               {"type": "paragraph", "text": "Депозиты, облигации и акции — три ключевых инструмента, которые используются большинством инвесторов. Их механика, уровень риска, доходность и налогообложение существенно различаются."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 2 — ОБЪЯСНЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [

               {"type": "paragraph", "text": "ДЕПОЗИТЫ"},
               {"type": "paragraph", "text": "Банковский депозит — это долговое обязательство банка перед вкладчиком. Банк принимает деньги, использует их для кредитования, и возвращает с процентами."},

               {"type": "paragraph", "text": "Ключевые параметры для казахстанского инвестора:"},
               {"type": "bullet_list", "items": [
                 "Гарантия КФГД: до 20 000 000 ₸ в тенге, до 5 000 000 ₸ в валюте",
                 "Ставки привязаны к базовой ставке НБРК",
                 "Вознаграждение освобождено от ИПН",
                 "Риск практически нулевой"
               ]},

               {"type": "paragraph", "text": "ОБЛИГАЦИИ"},
               {"type": "paragraph", "text": "Облигация — это долговая ценная бумага. Инвестор становится кредитором эмитента."},

               {"type": "bullet_list", "items": [
                 "Номинал",
                 "Купон",
                 "Срок обращения",
                 "Рыночная цена"
               ]},

               {"type": "paragraph", "text": "Казахстанский рынок облигаций:"},
               {"type": "bullet_list", "items": [
                 "ГЦБ — самые надёжные",
                 "Корпоративные облигации — выше доходность и риск",
                 "Еврооблигации — валютная защита"
               ]},

               {"type": "paragraph", "text": "АКЦИИ"},
               {"type": "paragraph", "text": "Акция — долевая ценная бумага. Инвестор становится совладельцем бизнеса."},

               {"type": "bullet_list", "items": [
                 "Дивидендная доходность",
                 "Прирост капитала"
               ]},

               {"type": "paragraph", "text": "Казахстанские акции:"},
               {"type": "bullet_list", "items": [
                 "Kaspi.kz",
                 "Halyk Bank",
                 "КазМунайГаз",
                 "Казатомпром",
                 "KEGOC"
               ]},

               {"type": "paragraph", "text": "Налогообложение:"},
               {"type": "bullet_list", "items": [
                 "Дивиденды могут быть освобождены от ИПН",
                 "Прирост капитала облагается 10%",
                 "Купонный доход облагается 10%"
               ]}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 3 — ПРИМЕР
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестор вкладывает 1 500 000 ₸:"},

               {
                 "type": "table",
                 "headers": ["Инструмент", "Сумма", "Доходность", "Доход", "Налог", "Чистый доход"],
                 "rows": [
                   ["Депозит Halyk", "500 000 ₸", "15%", "75 000 ₸", "0 ₸", "75 000 ₸"],
                   ["ГЦБ", "500 000 ₸", "12%", "60 000 ₸", "0 ₸", "60 000 ₸"],
                   ["Акции Kaspi.kz", "500 000 ₸", "8%", "40 000 ₸", "0 ₸", "40 000 ₸"]
                 ]
               }
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 4 — ВЫВОД
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Депозит — защита и ликвидность."},
               {"type": "paragraph", "text": "Облигации — стабильный доход."},
               {"type": "paragraph", "text": "Акции — долгосрочный рост."},
               {"type": "paragraph", "text": "Понимание этих инструментов — база инвестирования."}
             ]
           }'::jsonb
       );


-- =====================================
-- САБТОПИК
-- =====================================

insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'investments'),
           'beginner_mistakes',
           5,
           9,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'beginner_mistakes'),
           'ru',
           'Ошибки начинающих'
       );

-- =====================================
-- LESSON
-- =====================================

insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'beginner_mistakes'),
           true
       );

-- =====================
-- ШАГ 1 — ВВЕДЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Большинство инвестиционных ошибок не являются следствием нехватки аналитических данных — они поведенческие. Когнитивные искажения, эмоциональные решения и системные заблуждения разрушают доходность портфеля даже при правильно подобранных инструментах."},
               {"type": "paragraph", "text": "Изучение типичных ошибок — один из самых эффективных способов повысить инвестиционный результат."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 2 — ОБЪЯСНЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [

               {"type": "paragraph", "text": "ОШИБКА 1: Отсутствие финансовой подушки безопасности перед инвестированием"},
               {"type": "paragraph", "text": "Инвестировать без резервного фонда — значит подвергать себя риску принудительной продажи активов в худший момент. Если случается непредвиденный расход (болезнь, потеря работы, ремонт), инвестор вынужден продавать позиции, возможно, в период просадки."},
               {"type": "paragraph", "text": "Правило: перед началом инвестирования необходимо сформировать ликвидный резерв на 3–6 месяцев расходов на депозите с возможностью снятия."},

               {"type": "paragraph", "text": "ОШИБКА 2: Погоня за доходностью"},
               {"type": "paragraph", "text": "Инвесторы часто покупают то, что уже выросло, и продают то, что упало. Это поведение прямо противоположно логике «купить дёшево, продать дорого»."},
               {"type": "paragraph", "text": "Казахстанский пример: в 2021 году акции «Казатомпрома» выросли более чем на 80% на волне роста цен на уран. Многие розничные инвесторы зашли на пике — и затем пережили коррекцию (снижение цены после роста). Аналогичная история повторялась с криптовалютами в 2021 году."},

               {"type": "paragraph", "text": "ОШИБКА 3: Непонимание инструмента, в который вкладываются деньги"},
               {"type": "paragraph", "text": "Покупка актива без понимания его природы, рисков и механики — одна из самых опасных ошибок. Это касается структурных облигаций (сложные долговые инструменты с дополнительными условиями и зависимостью от других активов) со скрытыми условиями, ПИФов (паевые инвестиционные фонды — коллективные инвестиции, где деньги управляются компанией) с высокими комиссиями, а также инструментов, продвигаемых через социальные сети."},
               {"type": "paragraph", "text": "Правило: если нельзя объяснить механику инструмента простыми словами — не инвестировать."},

               {"type": "paragraph", "text": "ОШИБКА 4: Игнорирование комиссий и налогов"},
               {"type": "paragraph", "text": "Комиссии брокера, управляющей компании, а также налог на прирост капитала существенно влияют на итоговую доходность. Активный трейдер, совершающий 50+ сделок в год, может отдать значительную часть прибыли в виде транзакционных издержек и ИПН (индивидуальный подоходный налог — налог на доходы физических лиц)."},
               {"type": "paragraph", "text": "Пример: ПИФ с комиссией за управление 2% годовых при среднерыночной доходности 12% забирает более 16% вашего инвестиционного дохода ежегодно."},

               {"type": "paragraph", "text": "ОШИБКА 5: Эмоциональные решения в период волатильности (паническая продажа)"},
               {"type": "paragraph", "text": "Продажа активов в период рыночной паники — наиболее деструктивная ошибка долгосрочного инвестора. Инвестор фиксирует убыток, выходит с рынка, затем наблюдает за восстановлением уже без позиции."},
               {"type": "paragraph", "text": "Данные показывают: инвесторы, которые остались в индексных фондах во время пандемического обвала марта 2020 года, полностью восстановили потери в течение 5 месяцев."},
               {"type": "paragraph", "text": "ОШИБКА 6: Концентрация в одном активе или секторе"},
                {"type": "paragraph", "text" : "Особенно актуально для казахстанцев, имеющих большую долю сбережений в недвижимости или акциях одного работодателя. Потеря работы одновременно со снижением стоимости акций компании-работодателя удваивает финансовый удар."},

               {"type": "paragraph", "text": "ОШИБКА 7: Доверие к «гарантированной высокой доходности»"},
                {"type": "paragraph", "text": "Финансовые пирамиды и мошеннические схемы регулярно появляются на казахстанском рынке. НБРК (Национальный банк Республики Казахстан — регулятор финансового рынка) ведёт реестр компаний без лицензии. Обещание доходности 30–50% в год при «нулевом риске» — классический признак мошенничества."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 3 — ПРИМЕР
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {
                 "type": "table",
                 "headers": ["Сценарий", "Поведение", "Итог через 5 лет", "Потери от ошибок"],
                 "rows": [
                   ["Дисциплинированный инвестор", "Регулярные взносы, без паники, ребалансировка", "~3 500 000 ₸", "—"],
                   ["Инвестор-паникёр", "Продал в просадку –25%, вернулся после восстановления", "~2 600 000 ₸", "–900 000 ₸"],
                   ["«Инвестор» в пирамиду", "Вложил 1 000 000 ₸ в схему с обещанием 40%", "~1 200 000 ₸ остатка", "–800 000 ₸+"]
                 ]
               }
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 4 — ИНТЕРАКТИВ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes')),
           'interactive',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 4
           ),
           'ru',
           'Интерактив',
           '{
             "type": "error_detector",
             "instruction": "Прочитайте каждый сценарий и определите, какую ошибку допускает инвестор. Выберите правильный ответ из предложенных вариантов.",

             "cases": [
               {
                 "text": "Болат увидел, что акции «Казатомпрома» выросли на 70% за прошлый год. Он продал депозит и вложил все накопления в эти акции, рассчитывая на такой же рост в следующем году.",
                 "options": [
                   "A) Отсутствие подушки безопасности",
                   "B) Погоня за прошлой доходностью и концентрация в одном активе",
                   "C) Игнорирование комиссий",
                   "D) Паническая продажа"
                 ],
                 "correct": "B",
                 "explanation": "Прошлая доходность не гарантирует будущей. Болат совершает сразу две ошибки: гонится за уже случившимся ростом и концентрирует 100% капитала в одном активе."
               },
               {
                 "text": "Динара нашла в Instagram компанию, которая обещает 35% годовых с «гарантией возврата средств». Компания не упоминается на сайте НБРК. Динара решает вложить 500 000 ₸, потому что знакомая уже получила первые выплаты.",
                 "options": [
                   "A) Эмоциональное решение под давлением рынка",
                   "B) Непонимание инструмента",
                   "C) Признаки финансовой пирамиды, отсутствие лицензии НБРК",
                   "D) Игнорирование налогов"
                 ],
                 "correct": "C",
                 "explanation": "Обещание гарантированной высокой доходности + отсутствие лицензии НБРК + социальное доказательство — классическая схема финансовой пирамиды."
               }
             ],

             "final_explanation": "Большинство инвестиционных потерь связаны не с плохим выбором активов, а с поведенческими ошибками: страхом, жадностью и доверием к непроверенным обещаниям."
           }'::jsonb
       );

-- =====================
-- ШАГ 5 — ВЫВОД
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes')),
           'conclusion',
           5
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 5
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестиционный успех определяется не только выбором правильных активов, но и способностью придерживаться стратегии в условиях неопределённости."},
               {"type": "paragraph", "text": "Системный подход защищает от большинства ошибок."},
               {"type": "paragraph", "text": "В казахстанском контексте важно избегать нелицензированных компаний и концентрации активов."}
             ]
           }'::jsonb
       );

commit;