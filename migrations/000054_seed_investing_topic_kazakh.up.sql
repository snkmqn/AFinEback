begin;

-- =====================================
-- WHAT ARE INVESTMENTS — TRANSLATIONS
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Көптеген адамдар ақшаны тек сақтап қана қоймай, оны көбейту де керек екенін біледі. Алайда «жинақтау» мен «инвестициялау» арасындағы шекара көп жағдайда анық емес болып қалады."},
               {"type": "paragraph", "text": "Жинақ ағымдағы тәуекелдерден қорғайды — инвестициялар ұзақ мерзімді капитал өсімі үшін жұмыс істейді."},
               {"type": "paragraph", "text": "Бұл айырмашылықты түсіну — жеке қаржыны саналы басқарудың бастапқы нүктесі."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестициялар — болашақта табыс алу немесе құнын арттыру мақсатында капиталды активтерге орналастыру."},
               {"type": "paragraph", "text": "Жинақтан айырмашылығы, жинақ ақшаны жай сақтайды, ал инвестициялар ақшаны жұмыс істетеді."},

               {"type": "paragraph", "text": "Инвестициялардың негізгі сипаттамалары:"},

               {"type": "paragraph", "text": "Уақыт көкжиегі:"},
               {"type": "paragraph", "text": "Инвестициялар әдетте 1 жыл немесе одан да көп мерзімге есептеледі. Көкжиек неғұрлым ұзақ болса, өсу әлеуеті соғұрлым жоғары болады."},

               {"type": "paragraph", "text": "Табыстылық:"},
               {"type": "paragraph", "text": "Күтілетін табыстылық әдетте инфляция мен банк депозиттерінен жоғары болады."},

               {"type": "paragraph", "text": "Тәуекел:"},
               {"type": "paragraph", "text": "Инвестор жоғары табыстылық үшін капиталдың бір бөлігін жоғалту мүмкіндігін саналы түрде қабылдайды."},

               {"type": "paragraph", "text": "Өтімділік:"},
               {"type": "paragraph", "text": "Активті қаншалықты тез қайтадан қолма-қол ақшаға айналдыруға болатынын көрсетеді:"},
               {"type": "bullet_list", "items": ["акциялар — жоғары өтімділік", "жылжымайтын мүлік немесе бизнес — төмен өтімділік"]},

               {"type": "paragraph", "text": "Қазақстандағы инвесторларға арналған негізгі құралдар:"},

               {"type": "paragraph", "text": "Консервативті құралдар"},
               {"type": "bullet_list", "items": [
                 "екінші деңгейлі банктердегі депозиттер",
                 "мемлекеттік бағалы қағаздар (Қазақстан Қаржы министрлігінің облигациялары)"
               ]},

               {"type": "paragraph", "text": "Нарықтық құралдар"},
               {"type": "bullet_list", "items": [
                 "KASE-дегі компаниялардың акциялары мен облигациялары",
                 "AIX құралдары (Astana International Exchange)"
               ]},

               {"type": "paragraph", "text": "Халықаралық нарықтарға қолжетімділік"},
               {"type": "bullet_list", "items": [
                 "лицензияланған брокерлер арқылы шетелдік акциялар мен ETF"
               ]},

               {"type": "paragraph", "text": "Ұжымдық инвестициялар"},
               {"type": "bullet_list", "items": [
                 "пайлық инвестициялық қорлар"
               ]},

               {"type": "paragraph", "text": "Ұзақ мерзімді жинақтар"},
               {"type": "bullet_list", "items": [
                 "Бірыңғай жинақтаушы зейнетақы қоры арқылы зейнетақы жинақтары"
               ]},

               {"type": "paragraph", "text": "Мынаны түсіну маңызды: инвестициялау — алыпсатарлық емес. Алыпсатар қысқа мерзімді баға ауытқуларынан пайда табуды көздейді; инвестор актив құнының іргелі өсуін немесе тұрақты табыс алуды мақсат етеді (дивидендтер, купондар)."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қолында 1,000,000 ₸ бар екі Қазақстан азаматын қарастырайық:"},

               {
                 "type": "table",
                 "headers": ["Құрал", "Сома", "Мөлшерлеме / табыстылық", "Жылдық табыс"],
                 "rows": [
                   ["Жинақ шоты (Әлібек)", "1 000 000 ₸", "9%", "90 000 ₸"],
                   ["Депозит (Жанар)", "500 000 ₸", "9%", "45 000 ₸"],
                   ["Мемлекеттік облигациялар (Жанар)", "300 000 ₸", "12%", "36 000 ₸"],
                   ["ҚМГ акциялары (Жанар)", "200 000 ₸", "~15% (дивидендтер + өсім)", "~30 000 ₸"],
                   ["Жанар бойынша БАРЛЫҒЫ", "1 000 000 ₸", "~11.1% тиімді", "~111 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Жанардың әртараптандырылған тәсілі сол бір инвестиция сомасымен 21,000 ₸ артық табыс әкеледі — күрделі пайызды есепке алмағанның өзінде."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестициялау — бүгінгі тұтыну мен ертеңгі қаржылық өсім арасындағы саналы таңдау."},
               {"type": "paragraph", "text": "Қазақстан нарығы бастауға жеткілікті құралдар ұсынады: консервативті мемлекеттік облигациялардан бастап ұлттық компаниялардың акцияларына дейін."},
               {"type": "paragraph", "text": "Ең бастысы — ақша салмас бұрын әр құралдың табиғатын түсіну."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =====================================
-- RISK AND RETURN — TRANSLATIONS
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жаңадан бастаған инвесторлар көбіне «тәуекелсіз жоғары табыстылық» беретін құралдарды іздейді. Іс жүзінде мұндай нәрсе болмайды."},
               {"type": "paragraph", "text": "Тәуекел мен табыстылық — бір медальдың екі жағы. Олардың байланысын түсіну — кез келген инвестор үшін негізгі дағды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Табыстылық — белгілі бір кезең ішінде инвестиция құнының пайызбен көрсетілген өсуі. Ол мыналарды қамтиды:"},
               {"type": "bullet_list", "items": [
                 "Капитал өсімі: активтің нарықтық бағасының өсуі",
                 "Ағымдағы табыс: дивидендтер, купондық төлемдер, жалдау табысы"
               ]},

               {"type": "paragraph", "text": "Инвестициядағы тәуекел — нақты табыстылық күтілгеннен төмен болуы, тіпті инвестицияны толық жоғалту ықтималдығы."},

               {"type": "paragraph", "text": "Инвестициялық тәуекелдің негізгі түрлері:"},
               {"type": "bullet_list", "items": [
                 "Нарықтық тәуекел: жалпы экономикалық жағдайларға байланысты актив бағасының ауытқуы",
                 "Кредиттік тәуекел: эмитенттің дефолты (компания немесе мемлекет қарызды қайтара алмауы)",
                 "Валюталық тәуекел: айырбас бағамының өзгеруі шетелдік активтердің құнына әсер етеді",
                 "Инфляциялық тәуекел: табыстылық инфляцияны жаппайды, нақты сатып алу қабілеті төмендейді",
                 "Өтімділік тәуекелі: активті әділ бағамен тез сата алмау",
                 "Шоғырлану тәуекелі: портфельде бір активтің немесе бір сектордың тым үлкен үлес алуы"
               ]},

               {"type": "paragraph", "text": "Тәуекел/табыстылық шкаласы (төменнен жоғарыға қарай):"},
               {"type": "paragraph", "text": "Әлеуетті табыстылық неғұрлым жоғары болса — тәуекел де соғұрлым жоғары"},

               {"type": "paragraph", "text": "Төмен тәуекел"},
               {"type": "paragraph", "text": "Депозиттер (Қазақстанның депозиттерге кепілдік беру қоры) — белгіленген шек аясында қайтарылуына мемлекеттік кепілдік берілетін теңгедегі банк депозиттері"},
               {"type": "paragraph", "text": "→ Қазақстанның мемлекеттік облигациялары — мемлекетпен қамтамасыз етілгендіктен сенімді деп саналады"},

               {"type": "paragraph", "text": "Орташа тәуекел"},
               {"type": "paragraph", "text": "→ Корпоративтік облигациялар — тұрақты табыс беретін, бірақ эмитенттің қаржылық жағдайына тәуелді компаниялардың борыштық бағалы қағаздары"},
               {"type": "paragraph", "text": "→ KASE акциялары — қазақстандық компаниялардың акциялары, табыс баға өсімі мен дивидендтер арқылы қалыптасады, құны ауытқуы мүмкін"},

               {"type": "paragraph", "text": "Жоғары тәуекел"},
               {"type": "paragraph", "text": "→ Өсу акциялары (халықаралық нарықтар) — өсу әлеуеті жоғары, бірақ құбылмалылығы да жоғары компаниялардың акциялары"},
               {"type": "paragraph", "text": "→ Криптовалюталар және деривативтер — болжап болмайтын ауытқулары бар жоғары тәуекелді активтер"},

               {"type": "paragraph", "text": "Қазақстанға тән тәуекел факторлары:"},
               {"type": "bullet_list", "items": [
                 "Теңгенің валюталық тәуекелі",
                 "Мұнай бағасына тәуелділік",
                 "Реттеушілік өзгерістер"
               ]}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Үш инвестор әрқайсысы 3 жылдық көкжиекпен 2,000,000 ₸ инвестициялады:"},

               {
                 "type": "table",
                 "headers": ["Инвестор", "Құрал", "Күтілетін табыстылық", "Нақты сценарий", "Нәтиже"],
                 "rows": [
                   ["Нұрлан", "Депозит", "жылына 10%", "Кепілдендірілген", "2 662 000 ₸"],
                   ["Айгерім", "Облигациялар", "жылына 13%", "Дефолт жоқ", "2 878 000 ₸"],
                   ["Дамир", "Акциялар", "20% күтіледі", "2-жылы нарық –15% төмендеді", "2 204 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Дамир ең жоғары тәуекелді қабылдады және қысқа мерзімде ең нашар нәтижеге ие болды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "type": "scenario_selector",
             "instruction": "Сізге үш инвестор ұсынылған. Әрқайсысының жағдайы әртүрлі. Әрқайсысына қандай тәуекел деңгейі сәйкес келетінін анықтаңыз: төмен, орташа немесе жоғары.",
             "scenarios": [
               {
                 "text": "Аружан, 58 жаста. 4 жылдан кейін зейнетке шығады. Жинақтары — зейнеттегі негізгі табыс көзі. 10%-дан жоғары төмендеуге шыдауға дайын емес.",
                 "correct_answer": "Төмен тәуекел",
                 "explanation": "Қысқа көкжиек және жинаққа тәуелділік жоғары тәуекелді қолайсыз етеді."
               },
               {
                 "text": "Марат, 34 жаста. Тұрақты табысы бар, 6 айлық төтенше жағдай қоры бар. 10–15 жылға инвестициялайды.",
                 "correct_answer": "Орташа тәуекел",
                 "explanation": "Ұзақ көкжиек теңгерімді портфельге мүмкіндік береді."
               },
               {
                 "text": "Тимур, 26 жаста. IT саласында жұмыс істейді, табысы жоғары.",
                 "correct_answer": "Жоғары тәуекел",
                 "explanation": "Ұзақ көкжиек және шығындарға төзе алу қабілеті бар."
               }
             ],
             "options": ["Төмен тәуекел", "Орташа тәуекел", "Жоғары тәуекел"]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жоғары табыстылық пен нөлдік тәуекелі бар құрал болмайды."},
               {"type": "paragraph", "text": "Инвестордың міндеті — өз мақсаттарына сәйкес келетін тәуекел деңгейін таңдау."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =====================================
-- DIVERSIFICATION — TRANSLATIONS
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "«Барлық жұмыртқаны бір себетке салма» — инвестициялаудағы ең танымал ережелердің бірі шығар."},
               {"type": "paragraph", "text": "Осы қарапайым метафораның артында тәуекелді табыстылықты дәл сондай мөлшерде төмендетпей азайтатын сирек стратегиялардың бірі жатыр."},
               {"type": "paragraph", "text": "Әртараптандыру — жай ғана «әртүрлі активтер сатып алу» емес. Бұл әртүрлі инвестициялардың әртүрлі жағдайда қалай әрекет ететініне негізделген қағида."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =====================================
-- DIVERSIFICATION — CONTINUATION
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Әртараптандыру — табыстылығы бірдей бағытта қозғалмайтын активтер арасында капиталды бөлу. Бір актив төмендегенде, екіншісі өсуі немесе тұрақты қалуы мүмкін."},
               {"type": "paragraph", "text": "Бұл активтердің әртүрлі факторларға әсер етуіне байланысты:"},

               {"type": "bullet_list", "items": [
                 "акциялар экономика мен бизнес нәтижелеріне тәуелді",
                 "облигациялар пайыздық мөлшерлемелерге тәуелді",
                 "алтын дағдарыстар мен инфляцияға тәуелді"
               ]},

               {"type": "paragraph", "text": "Әртараптандыру деңгейлері:"},
               {"type": "bullet_list", "items": [
                 "Актив кластары бойынша: акциялар, облигациялар, депозиттер, жылжымайтын мүлік, бағалы металдар",
                 "География бойынша: Қазақстан нарығы, дамыған нарықтар (АҚШ, Еуропа), дамушы нарықтар",
                 "Секторлар бойынша: мұнай-газ, банк секторы, бөлшек сауда, телеком, тау-кен өндірісі",
                 "Валюталар бойынша: теңгедегі және доллардағы құралдар, еуродағы активтер",
                 "Уақыт көкжиегі бойынша: қысқа мерзімді, орта мерзімді, ұзақ мерзімді"
               ]},

               {"type": "paragraph", "text": "Әртараптандыру нені жоймайды:"},
               {"type": "bullet_list", "items": [
                 "Жүйелік (нарықтық) тәуекел",
                 "Ел деңгейіндегі валюталық тәуекел"
               ]},

               {"type": "paragraph", "text": "Қазақстан экономикасы тарихи тұрғыдан мұнай секторына қатты тәуелді болып келген."},
               {"type": "paragraph", "text": "Нағыз әртараптандыру ETF арқылы халықаралық нарықтарды да қамтиды."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "3,000,000 ₸ көлеміндегі екі портфель:"},

               {
                 "type": "table",
                 "headers": ["Позиция", "Шоғырланған портфель", "Әртараптандырылған портфель"],
                 "rows": [
                   ["ҚМГ", "1 500 000 ₸ (50%)", "600 000 ₸ (20%)"],
                   ["Kaspi.kz", "900 000 ₸ (30%)", "600 000 ₸ (20%)"],
                   ["Halyk Bank", "600 000 ₸ (20%)", "450 000 ₸ (15%)"],
                   ["Мемлекеттік облигациялар", "—", "600 000 ₸ (20%)"],
                   ["ETF", "—", "450 000 ₸ (15%)"],
                   ["Алтын", "—", "300 000 ₸ (10%)"],
                   ["Нәтиже", "-27%", "-9%"]
                 ]
               }
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "type": "portfolio_choice",
             "instruction": "Сізге 3 инвестициялық портфель нұсқасы ұсынылған. Жақсырақ әртараптандырылған нұсқаны таңдаңыз.",
             "options": [
               {
                 "name": "Шоғырланған портфель",
                 "data": ["Депозит 10%", "Мемлекеттік облигациялар 10%", "Акциялар 70%"]
               },
               {
                 "name": "Теңгерімді портфель",
                 "data": ["Депозит 20%", "Мемлекеттік облигациялар 20%", "Акциялар 20%", "ETF 25%", "Алтын 15%"]
               },
               {
                 "name": "Шектеулі портфель",
                 "data": ["Депозит 60%", "Мемлекеттік облигациялар 20%", "Акциялар 20%"]
               }
             ],
             "correct": "Теңгерімді портфель"
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Әртараптандыру — инвестициялаудағы жалғыз тегін түскі ас."},
               {"type": "paragraph", "text": "Жақсы портфель бір ғана активке тәуелді болмауы керек."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =====================================
-- SIMPLE INSTRUMENTS — TRANSLATIONS
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Күрделі құрылымдық өнімдерге, деривативтерге және балама активтерге өтпес бұрын негізгі құралдарды түсіну маңызды. Бұл кез келген инвестициялық портфельдің негізі."},
               {"type": "paragraph", "text": "Депозиттер, облигациялар және акциялар — инвесторлардың көпшілігі қолданатын үш негізгі құрал. Олардың жұмыс істеу механикасы, тәуекел деңгейі, табыстылығы және салық салу тәртібі айтарлықтай ерекшеленеді."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [

               {"type": "paragraph", "text": "ДЕПОЗИТТЕР"},
               {"type": "paragraph", "text": "Банк депозиті — банктің салымшы алдындағы борыштық міндеттемесі. Банк ақшаны қабылдайды, оны несие беруге пайдаланады және пайызымен қайтарады."},

               {"type": "paragraph", "text": "Қазақстандық инвестор үшін негізгі параметрлер:"},
               {"type": "bullet_list", "items": [
                 "ҚДКҚ кепілдігі: теңгедегі салымдар бойынша 20,000,000 ₸ дейін, шетел валютасындағы салымдар бойынша 5,000,000 ₸ дейін",
                 "Мөлшерлемелер Ұлттық Банктің базалық мөлшерлемесіне байланысты",
                 "Пайыздық табыс жеке табыс салығынан босатылады",
                 "Тәуекел іс жүзінде нөлге жақын"
               ]},

               {"type": "paragraph", "text": "ОБЛИГАЦИЯЛАР"},
               {"type": "paragraph", "text": "Облигация — борыштық бағалы қағаз. Инвестор эмитенттің кредиторына айналады."},

               {"type": "bullet_list", "items": [
                 "Номинал",
                 "Купон",
                 "Өтеу мерзімі",
                 "Нарықтық баға"
               ]},

               {"type": "paragraph", "text": "Қазақстан облигациялар нарығы:"},
               {"type": "bullet_list", "items": [
                 "Мемлекеттік облигациялар — ең сенімді",
                 "Корпоративтік облигациялар — табыстылығы мен тәуекелі жоғарырақ",
                 "Еурооблигациялар — валюталық қорғаныс"
               ]},

               {"type": "paragraph", "text": "АКЦИЯЛАР"},
               {"type": "paragraph", "text": "Акция — үлестік бағалы қағаз. Инвестор бизнестің ортақ иесіне айналады."},

               {"type": "bullet_list", "items": [
                 "Дивидендтік табыстылық",
                 "Капитал өсімі"
               ]},

               {"type": "paragraph", "text": "Қазақстандық акциялар:"},
               {"type": "bullet_list", "items": [
                 "Kaspi.kz",
                 "Halyk Bank",
                 "ҚазМұнайГаз",
                 "Қазатомөнеркәсіп",
                 "KEGOC"
               ]},

               {"type": "paragraph", "text": "Салық салу:"},
               {"type": "bullet_list", "items": [
                 "Дивидендтер жеке табыс салығынан босатылуы мүмкін",
                 "Капитал өсіміне 10% салық салынады",
                 "Купондық табысқа 10% салық салынады"
               ]}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =====================================
-- SIMPLE INSTRUMENTS — CONTINUATION
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестор 1,500,000 ₸ бөледі:"},

               {
                 "type": "table",
                 "headers": ["Құрал", "Сома", "Табыстылық", "Табыс", "Салық", "Таза табыс"],
                 "rows": [
                   ["Halyk депозиті", "500 000 ₸", "15%", "75 000 ₸", "0 ₸", "75 000 ₸"],
                   ["Мемлекеттік облигациялар", "500 000 ₸", "12%", "60 000 ₸", "0 ₸", "60 000 ₸"],
                   ["Kaspi.kz акциялары", "500 000 ₸", "8%", "40 000 ₸", "0 ₸", "40 000 ₸"]
                 ]
               }
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Депозит қорғаныс пен өтімділік береді."},
               {"type": "paragraph", "text": "Облигациялар тұрақты табыс береді."},
               {"type": "paragraph", "text": "Акциялар ұзақ мерзімді өсім береді."},
               {"type": "paragraph", "text": "Бұл құралдарды түсіну — инвестициялаудың негізі."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

-- =====================================
-- BEGINNER MISTAKES — TRANSLATIONS
-- =====================================

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестициялық қателіктердің көбі аналитикалық деректердің жетіспеуінен емес, мінез-құлықтан туындайды. Когнитивті бұрмаланулар, эмоцияға негізделген шешімдер және жүйелі қате түсініктер құралдар дұрыс таңдалғанның өзінде портфель табыстылығын төмендетеді."},
               {"type": "paragraph", "text": "Жиі кездесетін қателіктерді зерттеу — инвестициялық нәтижелерді жақсартудың ең тиімді тәсілдерінің бірі."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [

               {"type": "paragraph", "text": "1-ҚАТЕЛІК: Инвестициялауға дейін төтенше жағдай қорының болмауы"},
               {"type": "paragraph", "text": "Резервтік қорсыз инвестициялау инвесторды активтерді ең қолайсыз сәтте мәжбүрлі түрде сатуға алып келуі мүмкін. Күтпеген шығындар нарық төмендеген кезде активтерді сатуға мәжбүр етуі ықтимал."},
               {"type": "paragraph", "text": "Ереже: инвестициялаудан бұрын 3–6 айлық шығынды жабатын өтімді резерв қалыптастырыңыз."},

               {"type": "paragraph", "text": "2-ҚАТЕЛІК: Табыстылықтың соңынан қуу"},
               {"type": "paragraph", "text": "Инвесторлар көбіне бұрыннан өсіп кеткен активтерді сатып алып, төмендеген активтерді сатады."},

               {"type": "paragraph", "text": "3-ҚАТЕЛІК: Құралды түсінбеу"},
               {"type": "paragraph", "text": "Механикасын түсінбей актив сатып алу қауіпті."},

               {"type": "paragraph", "text": "4-ҚАТЕЛІК: Комиссиялар мен салықтарды елемеу"},

               {"type": "paragraph", "text": "5-ҚАТЕЛІК: Құбылмалылық кезінде үреймен сату"},

               {"type": "paragraph", "text": "6-ҚАТЕЛІК: Бір активке шоғырлану"},

               {"type": "paragraph", "text": "7-ҚАТЕЛІК: Кепілдендірілген жоғары табысқа сену"}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {
                 "type": "table",
                 "headers": ["Сценарий", "Мінез-құлық", "5 жылдан кейінгі нәтиже", "Қателіктерден болған шығын"],
                 "rows": [
                   ["Тәртіпті инвестор", "Тұрақты жарналар, үрей жоқ, қайта теңгерімдеу", "~3 500 000 ₸", "—"],
                   ["Үрейлі инвестор", "–25% төмендеу кезінде сатты, қалпына келгеннен кейін қайта кірді", "~2 600 000 ₸", "–900 000 ₸"],
                   ["Қаржы пирамидасына кірген инвестор", "40% уәде еткен схемаға 1 000 000 ₸ салды", "~1 200 000 ₸ қалды", "–800 000 ₸+"]
                 ]
               }
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "type": "error_detector",
             "instruction": "Әр сценарийді оқып, инвестор қандай қателік жасап жатқанын анықтаңыз. Берілген нұсқалардан дұрыс жауапты таңдаңыз.",

             "cases": [
               {
                 "text": "Болат Қазатомөнеркәсіп акциялары соңғы бір жылда 70%-ға өскенін көрді. Ол депозитін сатып, барлық жинағын осы акцияларға салды және келесі жылы да дәл сондай өсім болады деп күтті.",
                 "options": [
                   "A) Төтенше жағдай қорының болмауы",
                   "B) Өткен табыстылықтың соңынан қуу және бір активке шоғырлану",
                   "C) Комиссияларды елемеу",
                   "D) Үреймен сату"
                 ],
                 "correct": "B",
                 "explanation": "Өткен нәтиже болашақ табыстылыққа кепілдік бермейді. Болат екі қателік жасайды: өсімнің соңынан қуады және бүкіл капиталын бір активке шоғырландырады."
               },
               {
                 "text": "Динара Instagram-нан жылына 35% табысты «кепілдікпен» уәде ететін компания тапты. Компания Ұлттық Банктің сайтында көрсетілмеген. Ол 500,000 ₸ инвестициялауды шешеді.",
                 "options": [
                   "A) Эмоциялық шешім",
                   "B) Түсінбеушілік",
                   "C) Қаржы пирамидасының белгілері және лицензияның болмауы",
                   "D) Салықтарды елемеу"
                 ],
                 "correct": "C",
                 "explanation": "Кепілдендірілген жоғары табыс + лицензияның болмауы + әлеуметтік дәлел — қаржы пирамидасының классикалық белгілері."
               }
             ],

             "final_explanation": "Инвестициялық шығындардың көбі активті нашар таңдаудан емес, мінез-құлық қателіктерінен туындайды."
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Инвестициядағы табыс инвестордың мінез-құлқына байланысты."},
               {"type": "paragraph", "text": "Құрал таңдаудан гөрі тәртіп маңыздырақ."}
             ]
           }'::jsonb
       )
on conflict (lesson_step_id, language_code)
    do update set
                  title = excluded.title,
                  content = excluded.content;

commit;
