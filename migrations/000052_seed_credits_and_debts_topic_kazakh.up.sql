begin;

-- =========================================
-- TOPIC: credit_and_debt
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'credit_and_debt'),
           'kk',
           'Несиелер мен қарыздар'
       )
on conflict (topic_id, language_code)
    do update set title = excluded.title;

-- =========================================
-- SUBTOPIC 1: what_is_credit
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'what_is_credit'),
           'kk',
           'Несие дегеніміз не'
       )
on conflict (subtopic_id, language_code)
    do update set title = excluded.title;

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
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Өмірде белгілі бір ақша сомасы дәл қазір қажет болатын жағдайлар жиі кездеседі: техника сатып алу, емделуге, оқуға немесе күтпеген шығындарға төлеу."},
               {"type": "paragraph", "text": "Егер өз қаражатыңыз жеткіліксіз болса, мүмкін шешімдердің бірі — несие."},
               {"type": "paragraph", "text": "Алайда несиенің қазір ақша алудың жай ғана тәсілі емес, болашақ табысыңызға тікелей әсер ететін қаржылық міндеттеме екенін түсіну маңызды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие — банк немесе қаржы ұйымы сізге белгілі бір шарттармен уақытша пайдалануға беретін ақша."},
               {"type": "paragraph", "text": "Бұл шарттарға мыналар кіреді:"},
               {"type": "bullet_list", "items": ["қайтару мерзімі", "пайыздық мөлшерлеме", "төлем кестесі"]},
               {"type": "paragraph", "text": "Несиенің негізгі қағидасы — артық төлеммен қайтару."},
               {"type": "paragraph", "text": "Бұл сіз тек негізгі қарыз сомасын ғана емес, пайызды да қайтаратыныңызды білдіреді — бұл ақшаны пайдаланудың бағасы."},
               {"type": "paragraph", "text": "Қаржылық тұрғыдан несие ресурстарды уақыт бойынша қайта бөлу құралы ретінде қарастырылуы мүмкін: сіз ақшаны қазір пайдаланасыз, ал оны болашақ табысыңыздан төлейсіз."},
               {"type": "paragraph", "text": "Сондықтан әрбір несие болашақтағы қаржылық икемділігіңізді азайтып, міндеттемелеріңізді арттырады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сіз 12 айға 100,000 ₸ несие аласыз."},
               {"type": "paragraph", "text": "Бір жыл ішінде банкке, мысалы, 120,000 ₸ қайтарасыз."},
               {"type": "paragraph", "text": "100,000 ₸ — несиенің негізгі сомасы"},
               {"type": "paragraph", "text": "20,000 ₸ — пайыздар (несиенің құны)"},
               {"type": "paragraph", "text": "Іс жүзінде сіз ақшаны өзіңіз жинап алғаннан ертерек пайдалану мүмкіндігі үшін төлейсіз."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие — болашақ табысты пайдалана отырып, қазіргі мәселені шешуге мүмкіндік беретін қаржылық құрал."},
               {"type": "paragraph", "text": "Оны саналы түрде қолданса, пайдалы болуы мүмкін, бірақ ол әрқашан қосымша шығындармен және міндеттемелермен байланысты."},
               {"type": "paragraph", "text": "Несие алмас бұрын тек қазіргі қажеттілікті ғана емес, болашақта осы міндеттемелерді ыңғайлы түрде орындай алу мүмкіндігіңізді де бағалау маңызды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 2: interest_rate
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'interest_rate'),
           'kk',
           'Пайыздық мөлшерлеме'
       )
on conflict (subtopic_id, language_code)
    do update set title = excluded.title;

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
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие алған кезде негізгі параметрлердің бірі — пайыздық мөлшерлеме."},
               {"type": "paragraph", "text": "Ол негізгі қарыз сомасына қосымша ақшаны пайдаланғаныңыз үшін қанша төлейтініңізді анықтайды."},
               {"type": "paragraph", "text": "Мөлшерлемедегі аз ғана айырмашылықтың өзі жалпы артық төлемге едәуір әсер етуі мүмкін."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Пайыздық мөлшерлеме — белгілі бір кезеңдегі, әдетте бір жылдағы қарызға алынған соманың пайызымен көрсетілетін несиенің құны."},
               {"type": "paragraph", "text": "Ол банктің ақшасын пайдалану мүмкіндігі үшін несие сомасының қандай үлесін төлейтініңізді көрсетеді."},
               {"type": "paragraph", "text": "Мысалы, мөлшерлеме жылына 20% болса, бұл есептеу ерекшеліктерін ескермегенде, бір жыл ішінде несие сомасының шамамен 20%-ын пайыз ретінде төлейтініңізді білдіреді."},
               {"type": "paragraph", "text": "Шын мәнінде банктер пайыз есептеудің әртүрлі схемаларын қолданатынын ескеру маңызды:"},
               {"type": "bullet_list", "items": ["аннуитеттік төлемдер (ай сайынғы тең төлемдер)", "дифференциалды төлемдер"]},
               {"type": "paragraph", "text": "Сонымен қатар пайыздарды ғана емес, қосымша алымдар мен комиссияларды да қамтитын APR түріндегі көрсеткіш бар."},
               {"type": "paragraph", "text": "Бұл көрсеткіш несиенің нақты құны туралы дәлірек түсінік береді."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сіз жылдық 20% мөлшерлемемен 200,000 ₸ несие аласыз."},
               {"type": "paragraph", "text": "Қарапайым есеп бойынша, бір жылдағы артық төлем шамамен 40,000 ₸ болады деп күтуге болады."},
               {"type": "paragraph", "text": "Алайда нақты төлем кестесі мен комиссиялар ескерілгенде, соңғы сома жоғары болуы мүмкін."},
               {"type": "paragraph", "text": "Мысалы:"},
               {"type": "bullet_list", "items": ["бір мөлшерлемемен 240,000 ₸ қайтаруыңыз мүмкін", "басқа мөлшерлемемен 260,000 ₸-ға дейін қайтаруыңыз мүмкін"]},
               {"type": "paragraph", "text": "Пайыздық айырмашылық аз көрінуі мүмкін, бірақ ақшаға шаққанда ол байқалады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сізге бірдей сомаға екі несие нұсқасы берілген. Жалпы қайтару сомасына қарай тиімдірек болып көрінетін нұсқаны таңдаңыз."}
             ]
           }'::jsonb,
           '{
             "instruction": "Сізге бірдей сомаға екі несие нұсқасы берілген. Жалпы қайтару сомасына қарай тиімдірек нұсқаны таңдаңыз.",
             "question": "Жалпы қайтару сомасына қарай қай несие нұсқасы жақсырақ?",
             "options": [
               {"id": "1", "text": "A нұсқасы"},
               {"id": "2", "text": "B нұсқасы"}
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
             "explanation": "Екі несие де бірдей сомаға берілген, бірақ пайыздық мөлшерлемелері әртүрлі. Төмен мөлшерлеме несиенің жалпы құнын азайтады. Бұл жағдайда бірнеше пайыздық пункт айырмашылықтың өзі жалпы қайтару сомасында айтарлықтай айырмашылыққа әкеледі."
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content,
                  interactive_content = excluded.interactive_content;

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
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Пайыздық мөлшерлеме — несиенің құнын анықтайтын негізгі факторлардың бірі."},
               {"type": "paragraph", "text": "Несие таңдағанда тек «төмен мөлшерлемеге» ғана емес, комиссиялар мен өтеу шарттарын қоса алғандағы толық құнға назар аудару маңызды."},
               {"type": "paragraph", "text": "Мөлшерлеменің аз ғана төмендеуі де жалпы артық төлемді едәуір азайта алады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 3: credit_overpayment
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'credit_overpayment'),
           'kk',
           'Несие бойынша артық төлем'
       )
on conflict (subtopic_id, language_code)
    do update set title = excluded.title;

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
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие алған кезде сіз банкке алған сомаңыздан көбірек қайтарасыз."},
               {"type": "paragraph", "text": "Бұл айырмашылық артық төлем деп аталады және несиенің нақты құнын көрсетеді."},
               {"type": "paragraph", "text": "Іс жүзінде несие рәсімдеген кезде адамдар көбіне дәл осы артық төлемді жете бағаламайды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие бойынша артық төлем — сіз алған сома мен соңында банкке қайтаратын жалпы соманың айырмашылығы."},
               {"type": "paragraph", "text": "Ол мыналар арқылы қалыптасады:"},
               {"type": "bullet_list", "items": ["пайыздық мөлшерлеме", "несие мерзімі", "төлем схемасы", "мүмкін комиссиялар мен қосымша төлемдер"]},
               {"type": "paragraph", "text": "Несие мерзімі неғұрлым ұзақ және пайыздық мөлшерлеме неғұрлым жоғары болса, жалпы артық төлем соғұрлым көп болады."},
               {"type": "paragraph", "text": "Бірдей несие сомасының өзінде жалпы артық төлем шарттарға байланысты айтарлықтай өзгеше болуы мүмкін екенін түсіну маңызды."},
               {"type": "paragraph", "text": "Сонымен қатар аннуитеттік төлемдерде (ай сайынғы тең төлемдер) пайыздың едәуір бөлігі алғашқы айларда төленеді, бұл да бюджетке нақты жүктемені арттырады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сіз 2 жылға 300,000 ₸ несие аласыз."},
               {"type": "paragraph", "text": "Соңында банкке 420,000 ₸ қайтарасыз."},
               {"type": "paragraph", "text": "300,000 ₸ — несие сомасы"},
               {"type": "paragraph", "text": "120,000 ₸ — артық төлем"},
               {"type": "paragraph", "text": "Іс жүзінде сіз ақшаны ертерек пайдалану мүмкіндігі үшін 40% артық төлейсіз."},
               {"type": "paragraph", "text": "Егер несие мерзімі 3 жылға дейін ұзартылса, жалпы сома, мысалы, 480,000 ₸-ға дейін өсуі мүмкін."},
               {"type": "paragraph", "text": "Онда артық төлем 180,000 ₸ болады."},
               {"type": "paragraph", "text": "Бұл мерзімнің несиенің жалпы құнына тікелей әсер ететінін көрсетеді."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Артық төлем — несиенің нақты құнын көрсететін негізгі көрсеткіш."},
               {"type": "paragraph", "text": "Несие таңдағанда ай сайынғы төлем мөлшеріне ғана емес, жалпы қайтарылатын сомаға да назар аудару маңызды."},
               {"type": "paragraph", "text": "Артық төлем неғұрлым жоғары болса, ұзақ мерзімдегі қаржылық жүктеме соғұрлым көп болады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 4: credit_load
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'credit_load'),
           'kk',
           'Несие жүктемесі'
       )
on conflict (subtopic_id, language_code)
    do update set title = excluded.title;

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
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несиелерді пайдаланғанда олардың құнын ғана емес, ай сайынғы бюджетіңізге қаншалықты әсер ететінін де ескеру маңызды."},
               {"type": "paragraph", "text": "Тіпті «тиімді» мөлшерлеме болса да, төлемдер табысыңыздың тым үлкен бөлігін алса, несие проблемаға айналуы мүмкін."},
               {"type": "paragraph", "text": "Дәл сондықтан несие жүктемесі ұғымы қолданылады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие жүктемесі — барлық несие мен қарыздарды өтеуге кететін табысыңыздың үлесі."},
               {"type": "paragraph", "text": "Ол ай сайынғы несие төлемдерінің табысқа қатынасы ретінде есептеледі."},
               {"type": "paragraph", "text": "Қарапайым түрде:"},
               {"type": "paragraph", "text": "несие жүктемесі = (ай сайынғы төлемдер / табыс) × 100%"},
               {"type": "paragraph", "text": "Мысалы: егер сіз 300,000 ₸ табыс тауып, ай сайын несиелерге 90,000 ₸ төлесеңіз, несие жүктемеңіз 30% болады."},
               {"type": "paragraph", "text": "Қаржылық тәжірибеде әдетте былай есептеледі:"},
               {"type": "bullet_list", "items": ["30%-ға дейін — қауіпсіз деңгей", "30–50% — жоғарылаған жүктеме", "50%-дан жоғары — қаржылық мәселелердің жоғары қаупі"]},
               {"type": "paragraph", "text": "Несие жүктемесі неғұрлым жоғары болса, күнделікті шығындарға, жинаққа және күтпеген жағдайларға соғұрлым аз ақша қалады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ай сайынғы табысыңыз 250,000 ₸."},
               {"type": "paragraph", "text": "Сіз төлейсіз:"},
               {"type": "bullet_list", "items": ["бір несие бойынша 40,000 ₸", "басқа несие бойынша 30,000 ₸"]},
               {"type": "paragraph", "text": "Жалпы төлем: 70,000 ₸"},
               {"type": "paragraph", "text": "Несие жүктемесі:"},
               {"type": "paragraph", "text": "70,000 / 250,000 × 100% = 28%"},
               {"type": "paragraph", "text": "Бұл қауіпсіз деңгейге жақын, бірақ міндеттемелер көбейсе, жағдай тез нашарлауы мүмкін."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ай сайынғы табысыңыз 300,000 ₸, ал ай сайынғы жалпы несие төлемдеріңіз 120,000 ₸ болса, несие жүктемеңізді есептеңіз."}
             ]
           }'::jsonb,
           '{
             "instruction": "Ай сайынғы табысыңыз 300,000 ₸, ал ай сайынғы жалпы несие төлемдеріңіз 120,000 ₸ болса, несие жүктемеңізді есептеңіз.",
             "fields": [
               {"id": "credit_load_percent", "label": "Несие жүктемесі (%)"}
             ],
             "validation": {
               "formula": "(120000 / 300000) * 100",
               "expectedValue": 40
             },
             "exampleAnswer": {
               "credit_load_percent": 40
             },
             "explanation": "Бұл жағдайда табыстың 40%-ы несиелерге кетеді. Бұл қазірдің өзінде жоғарылаған жүктеме деңгейі, мұнда қаржылық икемділік азаяды және табыс төмендесе немесе қосымша шығындар пайда болса, мәселелер қаупі артады."
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content,
                  interactive_content = excluded.interactive_content;

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
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие жүктемесі несиелеріңіздің бюджетіңізге қаншалықты әсер ететінін көрсетеді."},
               {"type": "paragraph", "text": "Әрбір жеке несие қолайлы болып көрінсе де, олардың жиынтық әсері қаржыңызға елеулі қысым тудыруы мүмкін."},
               {"type": "paragraph", "text": "Жаңа несие алмас бұрын қазіргі жүктемеңізді ескеріп, болашақта қаржылық тұрақтылық сақтала ма, соны бағалау маңызды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 5: choose_credit
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'choose_credit'),
           'kk',
           'Несиені қалай таңдау керек'
       )
on conflict (subtopic_id, language_code)
    do update set title = excluded.title;

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
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Нарықта көптеген несие ұсыныстары бар және алғаш қарағанда олар бір-біріне ұқсас болып көрінуі мүмкін."},
               {"type": "paragraph", "text": "Алайда шарттардағы айырмашылықтар несиенің жалпы құнына және сіздің қаржылық жүктемеңізге едәуір әсер етуі мүмкін."},
               {"type": "paragraph", "text": "Сондықтан несие таңдау мұқият әрі саналы тәсілді қажет етеді."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие таңдағанда бір ғана параметрді емес, шарттардың жалпы жиынтығын ескеру маңызды."},
               {"type": "paragraph", "text": "Назар аудару қажет негізгі факторлар:"},
               {"type": "bullet_list", "items": [
                 "Пайыздық мөлшерлеме — несиенің негізгі құнын анықтайды. Мөлшерлеме неғұрлым төмен болса, артық төлем соғұрлым аз болады.",
                 "APR түріндегі тиімді жылдық мөлшерлеме — барлық комиссиялар мен қосымша төлемдерді ескере отырып, несиенің нақты құнын көрсетеді. Бұл көрсеткіш шығындар туралы ең дәл түсінік береді.",
                 "Несие мерзімі — ұзақ мерзім ай сайынғы төлемді азайтады, бірақ жалпы артық төлемді арттырады.",
                 "Ай сайынғы төлем мөлшері — оның бюджетке шамадан тыс қысым жасамауы және басқа шығындарға орын қалдыруы маңызды.",
                 "Қосымша комиссиялар — кейбір несиелерде өтінімді өңдеу, қызмет көрсету немесе мерзімінен бұрын өтеу үшін алымдар болуы мүмкін.",
                 "Мерзімінен бұрын өтеу шарттары — икемді шарттар мүмкіндік пайда болса, несиені ертерек жауып, артық төлемді азайтуға көмектеседі."
               ]},
               {"type": "paragraph", "text": "Бірінші қолжетімді ұсынысты таңдаудың орнына бірнеше ұсынысты салыстыру маңызды."},
               {"type": "paragraph", "text": "Шарттардағы аз ғана айырмашылықтың өзі жалпы қайтарылатын сомада едәуір айырмашылыққа әкелуі мүмкін."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сіз 300,000 ₸ көлеміндегі екі несие нұсқасын қарастырып жатырсыз:"},
               {"type": "paragraph", "text": "A нұсқасы:"},
               {"type": "bullet_list", "items": ["Мөлшерлеме: 18%", "Мерзім: 2 жыл", "Жалпы сома: 390,000 ₸"]},
               {"type": "paragraph", "text": "B нұсқасы:"},
               {"type": "bullet_list", "items": ["Мөлшерлеме: 20%", "Мерзім: 3 жыл", "Жалпы сома: 450,000 ₸"]},
               {"type": "paragraph", "text": "Екінші нұсқада ай сайынғы төлем төменірек болғанымен, жалпы артық төлем әлдеқайда жоғары."},
               {"type": "paragraph", "text": "Бұл тек төлем мөлшеріне ғана назар аудару жеткіліксіз екенін көрсетеді."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

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
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Несие таңдау жеке параметрлерге емес, толық құнын талдауға негізделуі керек."},
               {"type": "paragraph", "text": "Пайыздық мөлшерлемені, мерзімді, комиссияларды және өзіңіздің несие жүктемеңізді ескеру маңызды."},
               {"type": "paragraph", "text": "Саналы таңдау артық төлемді азайтуға және ұзақ мерзімді қаржылық тұрақтылықты сақтауға көмектеседі."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

commit;