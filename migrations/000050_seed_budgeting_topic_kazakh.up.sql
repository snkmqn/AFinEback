begin;

-- =========================================
-- TOPIC: budgeting
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'budgeting'),
           'kk',
           'Бюджеттеу'
       );

-- =========================================
-- SUBTOPIC 1: income_expenses
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'income_expenses'),
           'kk',
           'Табыс пен шығындар'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'income_expenses'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Қазақстандағы көптеген адамдар бір нәрсені айтады: «Менде жалақы бар, бірақ бәрібір ақша жетпейді». Алғаш қарағанда табыс қалыпты сияқты. Сонда сұрақ туындайды: мәселе неде?"},
               {"type": "paragraph", "text": "Көбінесе мәселе адамның ақшаның қайда кетіп жатқанын түсінбеуінде. Олар ай бойы ақша жұмсайды, шығындарын бақыламайды, нәтижесінде ай соңында баланс бос қалады."}
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
               where s.code = 'income_expenses'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Бірінші қадам — барлық ақшаны екі бөлікке бөлу."},
               {"type": "paragraph", "text": "Табыс — бұл сізге келетін барлық ақша:"},
               {"type": "bullet_list", "items": ["жалақы", "қосымша табыс", "бонус", "аударымдар", "жалға беруден түсетін табыс"]},
               {"type": "paragraph", "text": "Шығындар — бұл кететін барлық ақша:"},
               {"type": "bullet_list", "items": ["жалдау ақысы", "тамақ", "көлік", "коммуналдық төлемдер", "сатып алулар", "жазылымдар"]},
               {"type": "paragraph", "text": "Іс жүзінде адамдар табысын біледі, бірақ шығындарының жалпы сомасын дәл айта алмайды."}
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
               where s.code = 'income_expenses'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Мысалы, бір адам Астанада тұрады және айына 300,000 ₸ табыс табады."},
               {"type": "paragraph", "text": "Енді шығындарды қарайық:"},
               {
                 "type": "table",
                 "headers": ["Санат", "Сома"],
                 "rows": [
                   ["Бір бөлмелі пәтер жалдау", "200,000 ₸"],
                   ["Тамақ", "90,000 ₸"],
                   ["Такси және көлік", "30,000 ₸"],
                   ["Жазылымдар", "10,000 ₸"],
                   ["Күнделікті ұсақ шығындар", "40,000 ₸"],
                   ["Жалпы шығындар", "370,000 ₸"]
                 ]
               },
               {"type": "paragraph", "text": "Табыс: 300,000 ₸"},
               {"type": "paragraph", "text": "Шығындар: 370,000 ₸"},
               {"type": "paragraph", "text": "Ай сайынғы айырмашылық: –70,000 ₸"},
               {"type": "paragraph", "text": "Бұл жерде медициналық шығындар, техника жөндеу немесе отбасылық шаралар сияқты күтпеген шығындар әлі есепке алынбаған."}
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
               where s.code = 'income_expenses'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Көптеген адамдар үшін табыс тұрақты — мысалы, жалақы. Бірақ шығындар өзгеріп отырады: бағалар өседі, жаңа шығындар пайда болады, сатып алу оңайлай түседі."},
               {"type": "paragraph", "text": "Қазақстанда бөліп төлеу мәдениеті ерекше әсер етеді: сатып алуды бірнеше минут ішінде рәсімдеуге болады. Бұл ыңғайлы, бірақ бюджетке түсетін жүктемені арттырады."},
               {"type": "paragraph", "text": "Сондықтан бірінші қадам — шығындарды соқыр түрде қысқарту емес, нақты жағдайды анық көру."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 2: fixed_variable_expenses
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'fixed_variable_expenses'),
           'kk',
           'Тұрақты және айнымалы шығындар'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Енді сіз шығындарыңызды көре алатын болсаңыз, келесі қадам — олардың қайсысына шынымен әсер ете алатыныңызды түсіну."
               },
               {
                 "type": "paragraph",
                 "text": "Барлық шығындар екі түрге бөлінеді, және бұл айырмашылық бюджетке деген көзқарасты өзгертеді."
               }
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Тұрақты шығындар — бұл ай сайын шамамен бірдей мөлшерде төленетін және оңай алып тастауға болмайтын төлемдер:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "жалдау ақысы",
                   "коммуналдық қызметтер (электр, газ, су)",
                   "интернет және мобильді байланыс",
                   "несие немесе бөліп төлеу төлемдері"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Бұл шығындар қатаң. Сіз келісімшартқа отырдыңыз, міндеттеме алдыңыз. Оларды тез арада тоқтату оңай емес."
               },
               {
                 "type": "paragraph",
                 "text": "Айнымалы шығындар — бұл күнделікті шешімдеріңізге байланысты:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "кафеде тамақтану және жеткізу (Wolt, Glovo)",
                   "автобустың орнына такси пайдалану",
                   "киім мен гаджеттер",
                   "ойын-сауық, кафелер, сыйлықтар"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Дәл осы жерде бюджетті басқарудың негізгі мүмкіндігі жатыр."
               }
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Адам жалдау ақысын бірден азайта алмауы мүмкін, бірақ сонымен қатар:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "күн сайын такси пайдалануы мүмкін",
                   "жиі тамақ жеткізуге тапсырыс береді",
                   "ойланбай сатып алулар жасайды"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Қазақстанда мұндай шығындар байқалмай жиналады:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "Yandex Go немесе InDriver арқылы сапарлар",
                   "Wolt немесе Glovo арқылы жеткізу",
                   "Kaspi арқылы бөліп төлеумен сатып алу"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Әрқайсысы жеке алғанда аз көрінеді, бірақ бірге олар шығындарды едәуір арттырады."
               }
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Шығындарды тұрақты және айнымалы болып бөліңіз."
               }
             ]
           }'::jsonb,
           '{
             "instruction": "Шығындарды тұрақты және айнымалы болып бөліңіз.",
             "categories": [
               {"id": "fixed", "label": "Тұрақты"},
               {"id": "variable", "label": "Айнымалы"}
             ],
             "items": [
               {"id": "rent", "text": "Жалдау ақысы"},
               {"id": "utilities", "text": "Коммуналдық қызметтер"},
               {"id": "taxi", "text": "Такси"},
               {"id": "food_delivery", "text": "Тамақ жеткізу"},
               {"id": "internet", "text": "Интернет"},
               {"id": "entertainment", "text": "Ойын-сауық"}
             ],
             "answers": [
               {"itemId": "rent", "categoryId": "fixed"},
               {"itemId": "utilities", "categoryId": "fixed"},
               {"itemId": "internet", "categoryId": "fixed"},
               {"itemId": "taxi", "categoryId": "variable"},
               {"itemId": "food_delivery", "categoryId": "variable"},
               {"itemId": "entertainment", "categoryId": "variable"}
             ],
             "explanation": "Тұрақты шығындар ай сайын қайталанады және көбінесе міндеттемелермен байланысты. Айнымалы шығындар күнделікті шешімдерге байланысты және оларды бақылауға болады."
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
               where s.code = 'fixed_variable_expenses'
                 and ls.order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Ақша жетпей жатқандай сезілсе, барлық шығындардың бірдей міндетті емес екенін түсіну маңызды."
               },
               {
                 "type": "paragraph",
                 "text": "Тұрақты шығындарды өзгерту қиын."
               },
               {
                 "type": "paragraph",
                 "text": "Айнымалы шығындарды бақылауға және біртіндеп азайтуға болады."
               },
               {
                 "type": "paragraph",
                 "text": "Нағыз бюджетті басқару айнымалы шығындардан басталады."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 3: expense_accounting
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'expense_accounting'),
           'kk',
           'Шығындарды есепке алу'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'expense_accounting'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Сіз шығындардың қалай бөлінетінін түсінесіз деп елестетейік. Соған қарамастан, есеп жүргізбесеңіз, бәрібір қателіктер жасайсыз."
               },
               {
                 "type": "paragraph",
                 "text": "Және бұл қалыпты жағдай — мәселе тәртіпте емес, ми жұмысының ерекшелігінде. Ол ірі шығындарды жақсы есте сақтайды, бірақ ұсақтарын байқамайды."
               }
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
               where s.code = 'expense_accounting'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Ми күнделікті шығындарды дәл есепке алуға арналмаған. Ол жалдау ақысын немесе ірі сатып алуларды есте сақтайды, бірақ ұсақ тұрақты шығындарды бақыламайды."
               },
               {
                 "type": "paragraph",
                 "text": "Нәтижесінде «бәрі бақылауда» деген сезім пайда болады, бірақ іс жүзінде ақшаның елеулі бөлігі байқалмай кетеді."
               },
               {
                 "type": "paragraph",
                 "text": "Көбінесе назардан тыс қалатындар:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "жұмысқа барар жолдағы кофе",
                   "түскі ас кезіндегі жеңіл тамақ",
                   "бірнеше күн сайынғы жеткізу",
                   "автоматты түрде алынатын жазылымдар",
                   "маркетплейстердегі ұсақ сатып алулар"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Әрбір мұндай шығын аз көрінеді, бірақ бірге олар бюджетке айтарлықтай жүктеме жасайды."
               }
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
               where s.code = 'expense_accounting'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Қарапайым мысалды қарастырайық:"
               },
               {
                 "type": "table",
                 "headers": ["Шығын", "Күніне", "Айына"],
                 "rows": [
                   ["Кофе", "1,500 ₸", "~45,000 ₸"],
                   ["Жеңіл ас", "2,000 ₸", "~60,000 ₸"],
                   ["Барлығы", "3,500 ₸", "~105,000 ₸"]
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "100,000 ₸-дан астам — тек кофе мен жеңіл асқа. Бұл біздің мысалда табыстың шамамен үштен бірі."
               }
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
               where s.code = 'expense_accounting'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Шығындарды есепке алмай, бақылау иллюзиясы пайда болады. Шын мәнінде, ақша байқалмай-ақ елеулі көлемде кетуі мүмкін."
               },
               {
                 "type": "paragraph",
                 "text": "Бұған жол бермеу үшін қарапайым жүйе жеткілікті:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "шығындарды сатып алған күні жазу",
                   "аптасына бір рет жалпы соманы қарау",
                   "шығындарды санаттарға бөлу"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Күрделі құралдар қажет емес. Жазбалар, мессенджерлер немесе банктік қосымшалар жеткілікті."
               },
               {
                 "type": "paragraph",
                 "text": "Қазақстандағы көптеген банктік қосымшалар шығын санаттарын автоматты түрде көрсетеді (2026 жылдың сәуір айына өзекті). Мысалы, Kaspi қосымшасы шығындар аналитикасын ұсынады — оны тек тұрақты түрде қарап отыру қажет."
               },
               {
                 "type": "paragraph",
                 "text": "2–3 аптадан кейін ақшаның қайда кетіп жатқанын және негізгі шығындардың қай жерде екенін нақты көруге болады."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 4: budgeting_rule_50_30_20
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'budgeting_rule_50_30_20'),
           'kk',
           '50/30/20 ережесі'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Сіз енді шығындарыңызды көре аласыз. Келесі сұрақ — олар дұрыс бөлінген бе?"
               },
               {
                 "type": "paragraph",
                 "text": "Сүйенуге болатын қандай да бір бағдар бар ма?"
               },
               {
                 "type": "paragraph",
                 "text": "Иә. Ең қарапайым және тәжірибеде қолдануға ыңғайлы тәсілдердің бірі — 50/30/20 ережесі."
               }
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Бұл ереженің мәні — табысты үш бөлікке бөлу:"
               },
               {
                 "type": "paragraph",
                 "text": "50% — қажеттіліктер"
               },
               {
                 "type": "paragraph",
                 "text": "Бұл сіз онсыз өмір сүре алмайтын нәрселер: жалдау ақысы, тамақ, коммуналдық қызметтер, жұмысқа бару, несие төлемдері."
               },
               {
                 "type": "paragraph",
                 "text": "30% — қалаулар"
               },
               {
                 "type": "paragraph",
                 "text": "Кафелер, ойын-сауық, қажеттіліктен тыс киімдер, жазылымдар, саяхаттар. Бұл бөлік жайлылық пен өмір сапасына жауап береді."
               },
               {
                 "type": "paragraph",
                 "text": "20% — жинақ"
               },
               {
                 "type": "paragraph",
                 "text": "Төтенше жағдай қоры, мақсаттар және болашақ үшін жинайтын ақша."
               }
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "300,000 ₸ табысты қарастырайық:"
               },
               {
                 "type": "table",
                 "headers": ["Бөлік", "Пайыз", "Сома"],
                 "rows": [
                   ["Қажеттіліктер", "50%", "150,000 ₸"],
                   ["Қалаулар", "30%", "90,000 ₸"],
                   ["Жинақ", "20%", "60,000 ₸"]
                 ]
               }
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "300,000 ₸ табысты қажеттіліктер, қалаулар және жинақ арасында бөліңіз."
               }
             ]
           }'::jsonb,
           '{
             "instruction": "300,000 ₸ табысты қажеттіліктер, қалаулар және жинақ арасында бөліңіз.",
             "fields": [
               {"id": "needs", "label": "Қажеттіліктер"},
               {"id": "wants", "label": "Қалаулар"},
               {"id": "savings", "label": "Жинақ"}
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
             "explanation": "Бір ғана дұрыс жауап жоқ. Ең бастысы — жалпы сома сәйкес келуі және табыстың бір бөлігі жинаққа бағытталуы."
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
               where s.code = 'budgeting_rule_50_30_20'
                 and ls.order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Бұл қатаң ереже емес, бағыт-бағдар."
               },
               {
                 "type": "paragraph",
                 "text": "Қазақстанда, әсіресе ірі қалаларда, жалдау ақысы табыстың үлкен бөлігін алуы мүмкін. Мұндай жағдайда қажетті шығындардың үлесі артады, ал қалаулар мен жинаққа аз қалады — бұл бастапқы кезеңде қалыпты жағдай."
               },
               {
                 "type": "paragraph",
                 "text": "Негізгі идея — нақты пайыздар емес, қағида: ақшаның бір бөлігі әрқашан жинаққа кетуі керек, тіпті сома аз болса да."
               },
               {
                 "type": "paragraph",
                 "text": "Қаржылық жастығы жоқ адам осал күйде қалады: кез келген күтпеген шығын қарызға әкелуі мүмкін."
               },
               {
                 "type": "paragraph",
                 "text": "Қазақстандағы көптеген адамдар жинақ жасамайды, өйткені қаламайды емес, әдет қалыптаспаған. 50/30/20 ережесі — бастауға арналған қарапайым әдіс."
               }
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 5: budget_analysis
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'budget_analysis'),
           'kk',
           'Бюджетті талдау'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'budget_analysis'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Сіз енді келесілерді білесіз:"
               },
               {
                 "type": "bullet_list",
                 "items": [
                   "табысты және шығындарды бөлу",
                   "қайсысы тұрақты, қайсысын өзгертуге болатынын түсіну",
                   "шығындарды есепке алу",
                   "50/30/20 ережесін бағдар ретінде пайдалану"
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Енді келесі қадам — бюджетке тұтас қарап, қорытынды жасау."
               }
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
               where s.code = 'budget_analysis'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Бюджетті талдағанда үш нәрсеге назар аудару маңызды."
               },
               {
                 "type": "paragraph",
                 "text": "1. Дефицит бар ма?"
               },
               {
                 "type": "paragraph",
                 "text": "Егер шығындар табыстан асып кетсе, бұл негізгі мәселе. Дефицитпен өмір сүру қарыздың үнемі өсуіне әкеледі."
               },
               {
                 "type": "paragraph",
                 "text": "2. Айнымалы шығындардың үлесі"
               },
               {
                 "type": "paragraph",
                 "text": "Егер ақшаның елеулі бөлігі такси, жеткізу, кафе және сатып алуларға кетсе, бұл сіз бақылауға алатын аймақ."
               },
               {
                 "type": "paragraph",
                 "text": "3. Жинақтың болуы"
               },
               {
                 "type": "paragraph",
                 "text": "Егер жинақ болмаса, бюджет осал күйде қалады. Кез келген күтпеген жағдай қарызға мәжбүр етуі мүмкін."
               }
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
               where s.code = 'budget_analysis'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Келесі жағдайды қарастырайық:"
               },
               {
                 "type": "paragraph",
                 "text": "Табыс: 300,000 ₸"
               },
               {
                 "type": "table",
                 "headers": ["Санат", "Сома"],
                 "rows": [
                   ["Жалдау + коммуналдық қызметтер + интернет", "170,000 ₸"],
                   ["Үйдегі тамақ", "50,000 ₸"],
                   ["Жеткізу және кафелер", "60,000 ₸"],
                   ["Такси", "40,000 ₸"],
                   ["Телефонға бөліп төлеу", "20,000 ₸"],
                   ["Барлығы", "340,000 ₸"]
                 ]
               },
               {
                 "type": "paragraph",
                 "text": "Шығындар: 340,000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Табыс: 300,000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Айырмашылық: –40,000 ₸"
               },
               {
                 "type": "paragraph",
                 "text": "Жинақ жоқ."
               },
               {
                 "type": "paragraph",
                 "text": "Не істеуге болады:"
               },
               {
                 "type": "paragraph",
                 "text": "Жеткізу мен такси айына 100,000 ₸ құрайды. Бұл бюджеттегі елеулі бөлік және айнымалы шығындарға жатады."
               },
               {
                 "type": "paragraph",
                 "text": "Егер бұл шығындарды кем дегенде жартысына қысқартса, дефицит жойылып, ақша жинауды бастауға мүмкіндік пайда болады."
               }
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
               where s.code = 'budget_analysis'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {
                 "type": "paragraph",
                 "text": "Бюджет — бұл шектеулер тізімі емес, шешім қабылдау құралы."
               },
               {
                 "type": "paragraph",
                 "text": "Егер дефицит болса, айнымалы шығындарды азайту жолдарын іздеу қажет."
               },
               {
                 "type": "paragraph",
                 "text": "Егер жинақ болмаса, аз сомадан бастаңыз — айына 5,000–10,000 ₸ болса да."
               },
               {
                 "type": "paragraph",
                 "text": "Егер шығындар объективті түрде жоғары және азайту қиын болса, бұл табысқа назар аудару қажет екенін білдіреді: қосымша жұмыс, дағдыларды дамыту немесе мансаптық өсу."
               },
               {
                 "type": "paragraph",
                 "text": "Қазақстанда қаржылық сауаттылықты арттыруға арналған тегін ресурстар бар. Мысалы, «Қарызсыз қоғам» ұлттық жобасы (2026 жылдың сәуір айына өзекті) барлық адамға оқыту ұсынады."
               },
               {
                 "type": "paragraph",
                 "text": "Fingramota.kz порталы Egov.kz электрондық үкімет платформасы арқылы қолжетімді (2025 жылдың тамыз айына өзекті). Онда калькуляторлар, курстар және практикалық материалдар бар."
               },
               {
                 "type": "paragraph",
                 "text": "Бюджеттеу — бұл дағды. Ол тәжірибе арқылы қалыптасады. Тіпті бір ай шығындарды бақылау ешқандай есеп жүргізбегеннен әлдеқайда көп түсінік береді."
               },
               {
                 "type": "paragraph",
                 "text": "Келтірілген мысалдар тек ақпараттық мақсатта берілген және ұсыныс болып табылмайды."
               }
             ]
           }'::jsonb
       );

commit;