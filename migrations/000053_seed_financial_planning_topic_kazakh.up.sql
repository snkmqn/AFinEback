begin;

-- =========================================
-- TOPIC: financial_planning
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'financial_planning'),
           'kk',
           'Қаржылық жоспарлау'
       )
on conflict (topic_id, language_code)
    do update set title = excluded.title;

-- =========================================
-- SUBTOPIC 1: financial_goals
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'financial_goals'),
           'kk',
           'Қаржылық мақсаттар'
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
               where s.code = 'financial_goals'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық жоспарлау қай жерге жеткіңіз келетінін түсінуден басталады."},
               {"type": "paragraph", "text": "Қазақстанда табыс пен шығын деңгейі өңірге, мамандыққа және экономикалық жағдайларға байланысты айтарлықтай өзгеруі мүмкін, сондықтан ақшаны басқаруға саналы түрде қарау әсіресе маңызды."},
               {"type": "paragraph", "text": "Нақты мақсат болмаса, кез келген қаржылық әрекет ретсіз болады: табыс келеді де жұмсалып кетеді, бірақ көзге көрінетін нәтиже пайда болмайды."},
               {"type": "paragraph", "text": "Қаржылық мақсаттар бағыт береді және ақшаны басқаруды жүйелі процеске айналдырады."}
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
               where s.code = 'financial_goals'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсат — қаржылық ресурстарыңызды пайдаланып қол жеткізгіңіз келетін нақты нәтиже."},
               {"type": "paragraph", "text": "Ол негізгі сұраққа жауап береді: «Сізге жинақ пен шығындарды бақылау не үшін қажет?»"},
               {"type": "paragraph", "text": "Жеке қаржы тәжірибесінде мақсаттар әртүрлі болуы мүмкін:"},
               {"type": "bullet_list", "items": [
                 "төтенше жағдай қорын қалыптастыру (мысалы, 3–6 айлық шығын)",
                 "жылжымайтын мүлік сатып алу немесе ипотеканың бастапқы жарнасын жинау",
                 "көлік сатып алу",
                 "оқу ақысын төлеу, соның ішінде шетелде оқу",
                 "инвестициялық капитал қалыптастыру",
                 "ірі сатып алулар немесе саяхат"
               ]},
               {"type": "paragraph", "text": "Қазақстанда ең кең таралған мақсаттардың бірі — ипотеканың бастапқы жарнасына ақша жинау, себебі жылжымайтын мүлік бағасы орташа табысқа қарағанда жоғары болып қала береді."},
               {"type": "paragraph", "text": "Мақсат шынымен жұмыс істеуі үшін үш критерийге сай болуы керек:"},
               {"type": "bullet_list", "items": [
                 "нақтылық (нақты не үшін жинап жатқаныңыз түсінікті)",
                 "өлшенімділік (нақты сома бар)",
                 "мерзімнің болуы (мақсатты уақыт шегі бар)"
               ]},
               {"type": "paragraph", "text": "Мысалы:"},
               {"type": "paragraph", "text": "«2 жыл ішінде бастапқы жарнаға 3,000,000 ₸ жинау»"},
               {"type": "paragraph", "text": "Мұндай тұжырым есептеу мен жоспарлауға көшуге мүмкіндік береді."},
               {"type": "paragraph", "text": "Анық тұжырымдалған мақсат болмаса, мыналар қиын болады:"},
               {"type": "bullet_list", "items": [
                 "прогресті бақылау",
                 "қажетті жинақ деңгейін анықтау",
                 "саналы қаржылық шешімдер қабылдау"
               ]}
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
               where s.code = 'financial_goals'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Екі тұжырымды салыстырайық:"},
               {"type": "paragraph", "text": "1. «Ақша жинауды бастағым келеді»"},
               {"type": "paragraph", "text": "2. «12 ай ішінде төтенше жағдай қорына 600,000 ₸ жинау»"},
               {"type": "paragraph", "text": "Екінші жағдайда:"},
               {"type": "bullet_list", "items": [
                 "соңғы сома түсінікті",
                 "мерзім бар",
                 "ай сайынғы жарнаны есептеуге болады (50,000 ₸)",
                 "прогресті бақылау оңайырақ"
               ]},
               {"type": "paragraph", "text": "Мұндай мақсат абстрактілі қалауды нақты әрекет жоспарына айналдырады."}
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
               where s.code = 'financial_goals'
                 and ls.order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсатыңызды тұжырымдаңыз. Нақты не үшін жинағыңыз келетінін, қандай сомаға жеткіңіз келетінін және мүмкін болса, мерзімін көрсетіңіз."}
             ]
           }'::jsonb,
           '{
             "instruction": "Қаржылық мақсатыңызды тұжырымдаңыз. Нақты не үшін жинағыңыз келетінін, қандай сомаға жеткіңіз келетінін және мүмкін болса, мерзімін көрсетіңіз.",
             "fields": [
               {"id": "goal_description", "label": "Сіздің қаржылық мақсатыңыз"}
             ],
             "validation": {
               "rules": [
                 "Жауап бос болмауы керек",
                 "Жауапта мақсаттың мағыналы сипаттамасы болуы керек"
               ]
             },
             "exampleAnswer": {
               "goal_description": "18 ай ішінде ипотеканың бастапқы жарнасына 1,000,000 ₸ жинау"
             },
             "explanation": "Анық тұжырымдалған мақсат келесі кезеңге — жинақ жоспары мен табысты бөлуге көшуге мүмкіндік береді. Нақты мақсат болмаса, қаржылық мінез-құлық жүйесіз болып қала береді."
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
               where s.code = 'financial_goals'
                 and ls.order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсаттар — жеке қаржылық жоспарлаудың негізі."},
               {"type": "paragraph", "text": "Олар табыс пен шығындарды құрылымдауға, жинақ қалыптастыруға және саналы шешім қабылдауға көмектеседі."},
               {"type": "paragraph", "text": "Мақсат неғұрлым нақты анықталса, оған жету ықтималдығы соғұрлым жоғары болады және қаржылық жағдайыңыз тұрақтырақ бола түседі."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 2: short_vs_long_goals
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'short_vs_long_goals'),
           'kk',
           'Қысқа мерзімді және ұзақ мерзімді мақсаттар'
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Барлық қаржылық мақсаттар мерзімі мен тәсілі бойынша бірдей емес."},
               {"type": "paragraph", "text": "Кейбір мақсаттарға бірнеше ай ішінде жетуге болады, ал кейбіреулері бірнеше жылдық жоспарлауды талап етеді."},
               {"type": "paragraph", "text": "Қысқа мерзімді және ұзақ мерзімді мақсаттардың айырмашылығын түсіну ресурстарды дұрыс бөлуге және қаржылық қателіктерден аулақ болуға көмектеседі."}
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсаттар әдетте оларға жетуге қажет уақытқа байланысты қысқа мерзімді және ұзақ мерзімді болып бөлінеді."},
               {"type": "paragraph", "text": "Қысқа мерзімді мақсаттар — қысқа кезең ішінде, әдетте 1 жылға дейін жету жоспарланған мақсаттар."},
               {"type": "paragraph", "text": "Оларға мыналар жатады:"},
               {"type": "bullet_list", "items": [
                 "тұрмыстық техника сатып алу",
                 "сапар немесе демалыс ақысын төлеу",
                 "шағын төтенше жағдай қорын қалыптастыру",
                 "ағымдағы міндеттемелерді жабу"
               ]},
               {"type": "paragraph", "text": "Ұзақ мерзімді мақсаттар — жету үшін едәуір уақыт қажет болатын, әдетте 1 жыл немесе одан көп уақытты қамтитын мақсаттар."},
               {"type": "paragraph", "text": "Оларға мыналар жатады:"},
               {"type": "bullet_list", "items": [
                 "ипотеканың бастапқы жарнасына жинау",
                 "жылжымайтын мүлік сатып алу",
                 "инвестициялық капитал қалыптастыру",
                 "зейнетақы жинағын қалыптастыру"
               ]},
               {"type": "paragraph", "text": "Қазақстанда ұзақ мерзімді мақсаттар көбіне жылжымайтын мүлікпен байланысты, себебі тұрғын үй табысқа қарағанда қымбат болып қала береді және оған жинау уақыт пен тәртіпті талап етеді."},
               {"type": "paragraph", "text": "Бұл екі мақсат түрінің негізгі айырмашылығы тәсілде жатыр:"},
               {"type": "bullet_list", "items": [
                 "қысқа мерзімді мақсаттар жоғары өтімділікті талап етеді, яғни ақша кез келген уақытта қолжетімді болуы керек",
                 "ұзақ мерзімді мақсаттар күрделірек жинақ құралдары мен стратегияларды қолдануға мүмкіндік береді"
               ]},
               {"type": "paragraph", "text": "Инфляцияны да ескеру маңызды."},
               {"type": "paragraph", "text": "Қазақстанда ұзақ мерзімді жоспарлау кезінде инфляция жинақтың сатып алу қабілетін айтарлықтай төмендетуі мүмкін, сондықтан ақшаны табыссыз жай ғана сақтау тиімділігі төмен болады."}
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Екі мақсатты қарастырайық:"},
               {"type": "paragraph", "text": "1. 6 ай ішінде демалысқа 300,000 ₸ жинау"},
               {"type": "paragraph", "text": "2. 3 жыл ішінде ипотеканың бастапқы жарнасына 5,000,000 ₸ жинау"},
               {"type": "paragraph", "text": "Бірінші мақсат:"},
               {"type": "bullet_list", "items": [
                 "қысқа мерзім",
                 "салыстырмалы түрде шағын сома",
                 "қарапайым жинақ арқылы орындалуы мүмкін"
               ]},
               {"type": "paragraph", "text": "Екінші мақсат:"},
               {"type": "bullet_list", "items": [
                 "ұзақ мерзім",
                 "үлкен сома",
                 "жүйелі тәсіл мен тұрақты жарналарды талап етеді"
               ]},
               {"type": "paragraph", "text": "Ұзақ мерзімді мақсатқа қысқа мерзімді мақсаттағы әдістермен жетуге тырысу көбіне кешігуге немесе мақсаттан бас тартуға әкеледі."}
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
               where s.code = 'short_vs_long_goals'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсаттарды қысқа мерзімді және ұзақ мерзімді деп бөлу оларға жетудің дұрыс стратегияларын таңдауға мүмкіндік береді."},
               {"type": "paragraph", "text": "Қысқа мерзімді мақсаттар қарапайымдылық пен қаражатқа оңай қолжетімділікті талап етеді, ал ұзақ мерзімді мақсаттар жоспарлауды, тәртіпті және инфляция сияқты экономикалық факторларды ескеруді қажет етеді."},
               {"type": "paragraph", "text": "Мақсат түрін нақты түсіну қаржыны тиімдірек басқаруға көмектеседі және оған жету ықтималдығын арттырады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 3: spending_priorities
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'spending_priorities'),
           'kk',
           'Шығындар басымдығы'
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Табыс тұрақты болса да, шығындар бақыланбаса, қаржылық мақсаттар орындалмай қалуы мүмкін."},
               {"type": "paragraph", "text": "Көбіне мәселе ақшаның жетіспеуінде емес, нақты басымдықтардың болмауында."},
               {"type": "paragraph", "text": "Қай шығындар міндетті, ал қайсысы екінші кезектегі екенін түсіну бюджетті тиімдірек басқаруға мүмкіндік береді."}
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Шығындар басымдығы — табысты бөлу жүйесі, мұнда ең маңызды қаржылық қажеттіліктер алдымен жабылады, ал маңыздылығы төмендері кейінге қалдырылады."},
               {"type": "paragraph", "text": "Барлық шығындарды шартты түрде үш санатқа бөлуге болады:"},
               {"type": "bullet_list", "items": [
                 "міндетті шығындар",
                 "маңызды, бірақ икемді шығындар",
                 "міндетті емес (дискрециялық) шығындар"
               ]},
               {"type": "paragraph", "text": "Міндетті шығындар — негізгі өмір сүру деңгейін сақтау мүмкін емес шығындар:"},
               {"type": "bullet_list", "items": [
                 "жалдау ақысы немесе ипотека",
                 "тамақ",
                 "коммуналдық қызметтер",
                 "көлік",
                 "несиелер бойынша ең төменгі төлемдер"
               ]},
               {"type": "paragraph", "text": "Маңызды, бірақ икемді шығындар:"},
               {"type": "bullet_list", "items": [
                 "киім",
                 "білім",
                 "медициналық көмек (шұғыл жағдайлардан тыс)",
                 "үйге қажетті сатып алулар"
               ]},
               {"type": "paragraph", "text": "Міндетті емес шығындар:"},
               {"type": "bullet_list", "items": [
                 "ойын-сауық",
                 "кафелер мен мейрамханалар",
                 "импульсивті сатып алулар",
                 "жазылымдар мен сервистер"
               ]},
               {"type": "paragraph", "text": "Негізгі шығындар әдетте бюджеттің едәуір бөлігін алады, бірақ көбіне дәл міндетті емес шығындар бақылаусыз қалып, жинақ қалыптастыру мүмкіндігін біртіндеп азайтады."},
               {"type": "paragraph", "text": "Басымдықтарды белгілеу дегеніміз — табыс алғаннан кейін сіз:"},
               {"type": "bullet_list", "items": [
                 "алдымен міндетті шығындарды жабасыз",
                 "содан кейін мақсаттар мен жинаққа ақша бөлесіз",
                 "содан кейін ғана қалған соманы жеке шығындарға бөлесіз"
               ]},
               {"type": "paragraph", "text": "Бұл тәсіл бюджетті бақылауға ғана емес, қаржылық мақсаттарға жүйелі түрде жақындауға да мүмкіндік береді."}
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ай сайынғы табысыңыз 300,000 ₸."},
               {"type": "paragraph", "text": "Шығындар:"},
               {"type": "bullet_list", "items": [
                 "жалдау ақысы және коммуналдық қызметтер: 120,000 ₸",
                 "тамақ және көлік: 80,000 ₸",
                 "несиелер: 40,000 ₸"
               ]},
               {"type": "paragraph", "text": "Міндетті шығындардан кейін 60,000 ₸ қалады."},
               {"type": "paragraph", "text": "Егер бұл ақша бақылаусыз кафелерге, саудаға немесе ойын-сауыққа жұмсалса, жинақ қалыптаспайды."},
               {"type": "paragraph", "text": "Ал егер алдымен, мысалы, 30,000 ₸ мақсатқа бөліп, қалған 30,000 ₸ жеке шығындарға жұмсалса, қазіргі жайлылық пен болашақ нәтиже арасында тепе-теңдік пайда болады."}
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
               where s.code = 'spending_priorities'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Шығындар басымдығы ақшаны ағымдағы қалауларға жауап ретінде емес, саналы түрде басқаруға мүмкіндік береді."},
               {"type": "paragraph", "text": "Шығындарды нақты бөлу қаржылық тұрақтылықты сақтауға және мақсаттарға тұрақты түрде жылжуға көмектеседі."},
               {"type": "paragraph", "text": "Орташа табыстың өзінде шығындарды дұрыс басымдыққа қою қаржылық жағдайыңызды едәуір жақсарта алады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 4: savings_plan
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'savings_plan'),
           'kk',
           'Жинақ жоспары'
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
               where s.code = 'savings_plan'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсат анықталғаннан кейін келесі қадам — оған жету жоспарын жасау."},
               {"type": "paragraph", "text": "Нақты жоспар болмаса, анық мақсаттың өзі тек ниет күйінде қалуы мүмкін, өйткені қанша және қаншалықты тұрақты жинау керек екені түсініксіз болады."},
               {"type": "paragraph", "text": "Жинақ жоспары мақсатты нақты әрекеттер тізбегіне айналдыруға және оның қазіргі бюджет жағдайында қаншалықты шынайы екенін бағалауға көмектеседі."}
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
               where s.code = 'savings_plan'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ жоспары — белгіленген мерзім ішінде қаржылық мақсатқа жету үшін тұрақты түрде қанша ақша бөліп отыру керектігін көрсететін есеп."},
               {"type": "paragraph", "text": "Негізгі қағида мынадай:"},
               {"type": "paragraph", "text": "ай сайынғы жарна = мақсат сомасы / айлар саны"},
               {"type": "paragraph", "text": "Алайда іс жүзінде бір есеп жеткіліксіз. Бұл жоспар сіздің қаржылық мүмкіндіктеріңізге сәйкес келе ме, соны түсіну маңызды."},
               {"type": "paragraph", "text": "Егер қажетті ай сайынғы жарна табысыңыздың бос бөлігімен салыстырғанда тым жоғары болса, мақсат таңдалған мерзім ішінде шынайы болмай шығуы мүмкін."},
               {"type": "paragraph", "text": "Сондықтан жинақ жоспарын құрғанда мыналарды ескеру маңызды:"},
               {"type": "bullet_list", "items": [
                 "мақсат сомасы",
                 "оған жету мерзімі",
                 "міндетті шығындардан кейін қалатын бос қаражат мөлшері",
                 "жоспардың бірнеше ай бойы тұрақты орындалу мүмкіндігі"
               ]},
               {"type": "paragraph", "text": "Шынайы жоспар — мүмкін болатын ең жоғары жоспар емес, тұрақты түрде орындауға болатын және үнемі сәтсіздікке әкелмейтін жоспар."},
               {"type": "paragraph", "text": "Егер есеп жүктеменің тым жоғары екенін көрсетсе, бірнеше шешім болуы мүмкін:"},
               {"type": "bullet_list", "items": [
                 "жинақ мерзімін ұзарту",
                 "мақсатты соманы азайту",
                 "шығындар құрылымын қайта қарау",
                 "қосымша табыс көздерін табу"
               ]}
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
               where s.code = 'savings_plan'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сіз 12 айда 720,000 ₸ жинағыңыз келеді."},
               {"type": "paragraph", "text": "Есеп мынаны көрсетеді:"},
               {"type": "paragraph", "text": "720,000 / 12 = айына 60,000 ₸"},
               {"type": "paragraph", "text": "Сонымен қатар міндетті шығындардан кейін сізде тек 45,000 ₸ бос қаражат қалады."},
               {"type": "paragraph", "text": "Бұл қазіргі жоспар нақты мүмкіндіктеріңізден жоғары соманы талап ететінін білдіреді."},
               {"type": "paragraph", "text": "Мұндай жағдайда, мысалы, мерзімді 16 айға дейін ұзартуға болады:"},
               {"type": "paragraph", "text": "720,000 / 16 = 45,000 ₸"},
               {"type": "paragraph", "text": "Енді мақсат шынайырақ болады және бюджетіңізге жақсырақ сәйкес келеді."}
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
               where s.code = 'savings_plan'
                 and ls.order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ жоспары шынайы ма, соны есептеңіз. Мақсат — 12 айда 720,000 ₸. Міндетті шығындардан кейін айына 45,000 ₸ қалады. Қажетті ай сайынғы жарнаны және қажетті сома мен қолжетімді қаражат арасындағы айырмашылықты анықтаңыз."}
             ]
           }'::jsonb,
           '{
             "instruction": "Жинақ жоспары шынайы ма, соны есептеңіз. Мақсат — 12 айда 720,000 ₸. Міндетті шығындардан кейін айына 45,000 ₸ қалады. Қажетті ай сайынғы жарнаны және қажетті сома мен қолжетімді қаражат арасындағы айырмашылықты анықтаңыз.",
             "fields": [
               {"id": "monthly_saving_needed", "label": "Қажетті ай сайынғы жарна"},
               {"id": "difference_amount", "label": "Ай сайынғы жетіспейтін немесе қалған сома"}
             ],
             "validation": {
               "rules": [
                 "Қажетті ай сайынғы жарна = 720000 / 12",
                 "Айырмашылық = 45000 - monthly_saving_needed"
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
             "explanation": "Мақсатқа жету үшін айына 60,000 ₸ жинау қажет, бірақ сізде тек 45,000 ₸ бос қаражат бар. Бұл ай сайын 15,000 ₸ жетіспейтінін білдіреді. Қазіргі түрінде жоспар шынайы емес, сондықтан мерзімді ұзарту, мақсатты азайту немесе шығындарды қайта қарау қажет."
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
               where s.code = 'savings_plan'
                 and ls.order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ жоспары математикалық тұрғыдан ғана дұрыс емес, күнделікті өмірде де шынайы болуы керек."},
               {"type": "paragraph", "text": "Егер мақсат бюджет мүмкіндіктеріңізге сәйкес келмесе, жоспарды үнемі орындай алмаумен бетпе-бет келгеннен гөрі, шарттарды алдын ала түзеткен дұрыс."},
               {"type": "paragraph", "text": "Шынайы жоспар қаржылық мақсатқа шынымен жету ықтималдығын арттырады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =========================================
-- SUBTOPIC 5: progress_control
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'progress_control'),
           'kk',
           'Прогресті бақылау'
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
               where s.code = 'progress_control'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қаржылық мақсат анық және жинақ жоспары жақсы жасалған болса да, нәтиже кепілдендірілмейді."},
               {"type": "paragraph", "text": "Негізгі себеп — тұрақты бақылаудың болмауы."},
               {"type": "paragraph", "text": "Прогресті бақыламай және әрекеттерді түзетпей, тіпті шынайы жоспардың өзі біртіндеп жұмыс істемей қалуы мүмкін."}
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
               where s.code = 'progress_control'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Прогресті бақылау — нақты әрекеттердің жоспарланғанға қаншалықты сәйкес келетінін тұрақты түрде тексеру процесі."},
               {"type": "paragraph", "text": "Ол мыналарға мүмкіндік береді:"},
               {"type": "bullet_list", "items": [
                 "мақсатқа қарай ілгерілеуді бақылау",
                 "жоспардан ауытқуларды анықтау",
                 "мінез-құлықты уақытында түзету"
               ]},
               {"type": "paragraph", "text": "Іс жүзінде бақылау мыналарды қамтуы мүмкін:"},
               {"type": "bullet_list", "items": [
                 "жиналған соманы ай сайын тексеру",
                 "нақты жинақты жоспармен салыстыру",
                 "ауытқу себептерін талдау, мысалы күтпеген шығындар"
               ]},
               {"type": "paragraph", "text": "Жоспардан ауытқу қалыпты жағдай екенін түсіну маңызды."},
               {"type": "paragraph", "text": "Қаржылық мінез-құлық көптеген факторларға байланысты:"},
               {"type": "bullet_list", "items": [
                 "табыстың өзгеруі",
                 "күтпеген шығындар",
                 "шығындардың маусымдық өзгерістері"
               ]},
               {"type": "paragraph", "text": "Сондықтан бақылаудың міндеті — ауытқулар үшін «өзіңізді жазалау» емес, оларды уақытында байқап, жоспарды түзету."},
               {"type": "paragraph", "text": "Тиімді бақылау тұрақтылыққа негізделеді."},
               {"type": "paragraph", "text": "Айына бір рет жинақ жағдайын тексерудің қарапайым әдетінің өзі мақсатқа жету мүмкіндігін айтарлықтай арттырады."},
               {"type": "paragraph", "text": "Прогресті жазып отыру да маңызды."},
               {"type": "paragraph", "text": "Жинақ сомасының біртіндеп өсіп жатқанын көргенде, бұл мотивацияны күшейтіп, тәртіпті сақтауға көмектеседі."}
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
               where s.code = 'progress_control'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Сіз айына 50,000 ₸ жинауды жоспарлайсыз."},
               {"type": "paragraph", "text": "3 айдан кейін жоспар бойынша сізде 150,000 ₸ болуы керек."},
               {"type": "paragraph", "text": "Іс жүзінде тек 120,000 ₸ жиналған."},
               {"type": "paragraph", "text": "Ауытқу 30,000 ₸."},
               {"type": "paragraph", "text": "Бұл мынаны білдіретін белгі:"},
               {"type": "bullet_list", "items": [
                 "не шығындар күткеннен жоғары болды",
                 "не жоспар бастапқыдан тым оптимистік болды"
               ]},
               {"type": "paragraph", "text": "Мұндай жағдайда сіз:"},
               {"type": "bullet_list", "items": [
                 "ай сайынғы жарнаны түзете аласыз",
                 "мақсатқа жету мерзімін ұзарта аласыз",
                 "шығындар құрылымын қайта қарай аласыз"
               ]},
               {"type": "paragraph", "text": "Ең бастысы — ауытқуды елемей қоймай, шешім қабылдау."}
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
               where s.code = 'progress_control'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Прогресті бақылау — мақсаттар мен есептеулерді нақты нәтижеге айналдыратын қаржылық жоспарлаудың негізгі элементі."},
               {"type": "paragraph", "text": "Прогресті тұрақты бақылау мәселелерді уақытында байқап, жоспарды нақты жағдайларға бейімдеуге мүмкіндік береді."},
               {"type": "paragraph", "text": "Қарапайым, бірақ жүйелі бақылаудың өзі қаржылық мақсаттарға жету ықтималдығын айтарлықтай арттырады."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

commit;