begin;

-- 1. ТЕМА
insert into topics (code, level, order_index, is_active)
values ('budgeting', 'beginner', 1, true);

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'budgeting'),
           'ru',
           'Бюджетирование'
       );

-- 2. САБТОПИК
insert into subtopics (topic_id, code, order_index, estimated_minutes, is_active)
values (
           (select id from topics where code = 'budgeting'),
           'income_expenses',
           1,
           5,
           true
       );

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'income_expenses'),
           'ru',
           'Доходы и расходы'
       );

-- 3. LESSON
insert into lessons (subtopic_id, is_published)
values (
           (select id from subtopics where code = 'income_expenses'),
           true
       );

-- получаем lesson_id
-- (будем использовать через подзапрос)

-- =====================
-- ШАГ 1 — ВВЕДЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses')),
           'introduction',
           1
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses'))
                 and order_index = 1
           ),
           'ru',
           'Введение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Многие казахстанцы говорят одно и то же: «Зарплата есть, но денег всё равно не хватает». При этом доход кажется нормальным. Возникает вопрос — в чём причина."},
               {"type": "paragraph", "text": "Чаще всего проблема в том, что человек не понимает, куда уходят деньги. Он тратит в течение месяца, не фиксирует расходы и в конце сталкивается с пустым счётом."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 2 — ОБЪЯСНЕНИЕ
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses')),
           'explanation',
           2
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses'))
                 and order_index = 2
           ),
           'ru',
           'Объяснение',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Первый шаг — разделить все деньги на две части."},

               {"type": "paragraph", "text": "Доходы — это всё, что к вам приходит:"},
               {"type": "bullet_list", "items": ["зарплата", "подработки", "премии", "переводы", "доход от сдачи жилья"]},

               {"type": "paragraph", "text": "Расходы — это всё, что уходит:"},
               {"type": "bullet_list", "items": ["аренда", "еда", "транспорт", "коммунальные услуги", "покупки", "подписки"]},

               {"type": "paragraph", "text": "На практике большинство людей знает свой доход, но не может точно назвать сумму расходов."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 3 — ПРИМЕР
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses')),
           'example',
           3
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses'))
                 and order_index = 3
           ),
           'ru',
           'Пример',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Допустим, человек живёт в Астане и зарабатывает 300 000 ₸ в месяц."},
               {"type": "paragraph", "text": "Смотрим на расходы:"},

               {
                 "type": "table",
                 "headers": ["Статья", "Сумма"],
                 "rows": [
                   ["Аренда однокомнатной квартиры", "200 000 ₸"],
                   ["Еда", "90 000 ₸"],
                   ["Такси и транспорт", "30 000 ₸"],
                   ["Подписки", "10 000 ₸"],
                   ["Мелкие траты", "40 000 ₸"],
                   ["Итого расходов", "370 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Доход: 300 000 ₸"},
               {"type": "paragraph", "text": "Расходы: 370 000 ₸"},
               {"type": "paragraph", "text": "Разница: –70 000 ₸ каждый месяц"},
               {"type": "paragraph", "text": "И это без учёта непредвиденных расходов: лечение, ремонт техники, семейные мероприятия."}
             ]
           }'::jsonb
       );

-- =====================
-- ШАГ 4 — ВЫВОД
-- =====================

insert into lesson_steps (lesson_id, step_type, order_index)
values (
           (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses')),
           'conclusion',
           4
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'income_expenses'))
                 and order_index = 4
           ),
           'ru',
           'Вывод',
           '{
             "blocks": [
               {"type": "paragraph", "text": "У многих доход фиксированный — это оклад. Расходы при этом меняются: растут цены, появляются новые траты, упрощается доступ к покупкам."},
               {"type": "paragraph", "text": "В Казахстане особенно влияет культура рассрочек: оформить покупку можно за несколько минут. Это удобно, но увеличивает нагрузку на бюджет."},
               {"type": "paragraph", "text": "Поэтому первый шаг — не сокращать расходы вслепую, а увидеть реальную картину."}
             ]
           }'::jsonb
       );

commit;