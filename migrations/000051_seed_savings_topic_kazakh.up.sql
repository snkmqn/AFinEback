begin;

-- =========================================
-- TOPIC: savings
-- =========================================

insert into topic_translations (topic_id, language_code, title)
values (
           (select id from topics where code = 'savings'),
           'kk',
           'Жинақ'
       );

-- =========================================
-- SUBTOPIC 1: why_save
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'why_save'),
           'kk',
           'Ақшаны не үшін жинау керек'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'why_save'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Көптеген адамдар жалақыдан жалақыға дейін өмір сүріп, бүкіл табысын ағымдағы қажеттіліктерге жұмсайды. Мұндай модельде жинаққа орын қалмайды, ал кез келген күтпеген шығын проблемаға айналады."},
               {"type": "paragraph", "text": "Уақыт өте келе бұл қарызға тәуелділікке және тұрақты қаржылық күйзеліске әкеледі."}
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
               where s.code = 'why_save'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ — бұл бірден жұмсалмай, болашаққа қалдырылатын табыстың бір бөлігі."},
               {"type": "paragraph", "text": "Ол бірнеше маңызды қызмет атқарады:"},
               {"type": "bullet_list", "items": [
                 "күтпеген жағдайлардан қорғау",
                 "қаржылық мақсаттарға жету",
                 "күйзелісті азайту",
                 "қаржылық тәуелсіздікті қалыптастыру"
               ]},
               {"type": "paragraph", "text": "Тұрақты түрде жиналатын аз соманың өзі біртіндеп елеулі капиталға айналуы мүмкін."},
               {"type": "paragraph", "text": "Қазақстанда көптеген адамдар шұғыл түрде емделуге, көлікті жөндеуге немесе туыстарына көмектесуге ақша қажет болатын жағдайларға тап болады. Жинақтың болуы мұндай жағдайларды қарызсыз шешуге мүмкіндік береді."}
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
               where s.code = 'why_save'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Мысалы, адам айына 250,000 ₸ табыс табады және 10% жинайды."},
               {"type": "table", "headers": ["Кезең", "Жинақ"], "rows": [
                 ["1 ай", "25,000 ₸"],
                 ["6 ай", "150,000 ₸"],
                 ["12 ай", "300,000 ₸"]
               ]},
               {"type": "paragraph", "text": "Тіпті пайызсыз да бір жыл ішінде маңызды сома жиналады."}
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
               where s.code = 'why_save'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ақша жинау — өмірден бас тарту емес, өз өміріңізді бақылауда ұстау."},
               {"type": "paragraph", "text": "Тұрақты жинақ болашаққа сенімділік береді және қаржылық қысымсыз шешім қабылдауға мүмкіндік береді."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 2: emergency_fund
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'emergency_fund'),
           'kk',
           'Төтенше жағдай қоры'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'emergency_fund'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Көптеген адамдар жинақ туралы мәселе пайда болған кезде ғана ойлана бастайды: шұғыл емделу, тұрмыстық техниканың бұзылуы, жұмыстан айырылу немесе табыстың кешігуі."},
               {"type": "paragraph", "text": "Мұндай жағдайда ақша қорының болмауы тез арада күйзеліске, қарызға немесе туыстар мен достардан қарыз сұрау қажеттілігіне әкеледі."}
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Төтенше жағдай қоры — күтпеген жағдайларға арналған ақша қоры."},
               {"type": "paragraph", "text": "Оның мақсаты — адамның әдеттегі табысы азайса немесе тоқтаса, негізгі шығындарын уақытша жабу."},
               {"type": "paragraph", "text": "Әдетте 3–6 айлық шығынға тең соманың болғаны ұсынылады:"},
               {"type": "bullet_list", "items": [
                 "3 ай — ең төменгі қауіпсіздік деңгейі",
                 "6 ай — тұрақтырақ нұсқа"
               ]},
               {"type": "paragraph", "text": "Төтенше жағдай қоры ірі сатып алуларға, демалысқа немесе импульсивті шығындарға арналмайды. Бұл нақты қиын өмірлік жағдайларға арналған қор."},
               {"type": "paragraph", "text": "Қазақстанда төтенше жағдай қоры әсіресе маңызды, себебі көптеген отбасылар бір ғана жалақыға тәуелді, ал күтпеген шығындар — емделу, көлікті жөндеу, көшу, туыстарға көмектесу — кез келген сәтте пайда болуы мүмкін."}
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Мысалы, адам Астанада тұрады және ай сайын мынадай шығындары бар:"},
               {"type": "table", "headers": ["Санат", "Сома"], "rows": [
                 ["Жалдау ақысы", "180,000 ₸"],
                 ["Тамақ", "80,000 ₸"],
                 ["Көлік", "20,000 ₸"],
                 ["Коммуналдық қызметтер", "20,000 ₸"],
                 ["Басқа шығындар", "20,000 ₸"],
                 ["Барлығы", "320,000 ₸"]
               ]},
               {"type": "paragraph", "text": "Онда төтенше жағдай қоры:"},
               {"type": "bullet_list", "items": [
                 "минимум: 320,000 × 3 = 960,000 ₸",
                 "ыңғайлы деңгей: 320,000 × 6 = 1,920,000 ₸"
               ]},
               {"type": "paragraph", "text": "Бұл мұндай соманы бірден жинау керек дегенді білдірмейді. Мақсатты түсініп, оған біртіндеп жылжу маңызды."}
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ай сайынғы шығындар 160,000 ₸ болса, ең төменгі және ыңғайлы төтенше жағдай қорын есептеңіз."}
             ]
           }'::jsonb,
           '{
             "instruction": "Ай сайынғы шығындар 160,000 ₸ болса, ең төменгі және ыңғайлы төтенше жағдай қорын есептеңіз.",
             "fields": [
               {"id": "minimum_fund", "label": "Ең төменгі қор"},
               {"id": "comfortable_fund", "label": "Ыңғайлы қор"}
             ],
             "validation": {
               "rules": [
                 "Ең төменгі қор = шығындар × 3",
                 "Ыңғайлы қор = шығындар × 6"
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
             "explanation": "Төтенше жағдай қоры табысқа емес, ай сайынғы шығындарға қарай есептеледі. Ең төменгі қор 3 айды, ал сенімдірек қор 6 айды жабады."
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
               where s.code = 'emergency_fund'
                 and ls.order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Төтенше жағдай қоры бірден пайда әкелмейді, бірақ тұрақтылық қалыптастырып, қаржылық осалдықты азайтады."},
               {"type": "paragraph", "text": "Тіпті аз мөлшердегі тұрақты жинақ біртіндеп қарызсыз және артық күйзеліссіз қиын кезеңнен өтуге көмектесетін қор қалыптастырады."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 3: how_to_save
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'how_to_save'),
           'kk',
           'Жинақтауды қалай бастау керек'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'how_to_save'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Көптеген адамдар жинақ жасау тек жоғары табыспен ғана мүмкін деп ойлайды. Іс жүзінде бұл дұрыс емес — сомадан гөрі әдет маңыздырақ."},
               {"type": "paragraph", "text": "Табысы қарапайым болса да, жинақ қалыптастыруды бастауға болады."}
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
               where s.code = 'how_to_save'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Ақша жинауды бастау үшін бірнеше қағиданы ұстану маңызды:"},
               {"type": "bullet_list", "items": [
                 "алдымен жинаққа бөліп, содан кейін жұмсау",
                 "табыстың тұрақты пайызын таңдау",
                 "мұны тұрақты түрде жасау",
                 "ақшаны бөлек сақтау"
               ]},
               {"type": "paragraph", "text": "Көбіне табыстың 10–20%-ын жинау ұсынылады, бірақ 5%-дан да бастауға болады."},
               {"type": "paragraph", "text": "Ең бастысы — тұрақтылық."},
               {"type": "paragraph", "text": "Қазақстанда жинақ үшін бірнеше қарапайым құралды қолдануға болады:"},
               {"type": "bullet_list", "items": [
                 "қарапайым банк шоты (карта) — бастапқы кезеңге қолайлы, ақша әрдайым қолжетімді",
                 "жинақ шоты — ақшаны бөлек сақтауға және кейде аз мөлшерде пайыз алуға мүмкіндік береді",
                 "банк депозиті — ақша белгілі бір мерзімге орналастырылады және пайыздық табыс әкеледі (әдетте қарапайым шоттарға қарағанда жоғары)",
                 "автоматты аударымдар — көптеген банктік қосымшалар табыстың бір бөлігін бөлек шотқа тұрақты түрде аударуды баптауға мүмкіндік береді"
               ]},
               {"type": "paragraph", "text": "Мұндай құралдар «өмірге арналған» ақшаны «жинаққа арналған» ақшадан бөлуге көмектеседі, бұл бақылауды әлдеқайда жеңілдетеді."}
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
               where s.code = 'how_to_save'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Адам 200,000 ₸ табыс табады және 10% жинауды шешеді."},
               {"type": "paragraph", "text": "Ай сайын:"},
               {"type": "paragraph", "text": "200,000 × 0.10 = 20,000 ₸"},
               {"type": "paragraph", "text": "Бір жыл ішінде:"},
               {"type": "paragraph", "text": "20,000 × 12 = 240,000 ₸"},
               {"type": "paragraph", "text": "Табысты арттырмай-ақ, маңызды сома жиналады."}
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
               where s.code = 'how_to_save'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақтауды кез келген сомадан бастауға болады."},
               {"type": "paragraph", "text": "Жарна мөлшерінен гөрі тұрақтылық пен тәртіп әлдеқайда маңызды."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 4: interest_on_savings
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'interest_on_savings'),
           'kk',
           'Жинақ бойынша пайыз'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'interest_on_savings'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Адам ақша жинауды бастағанда, келесі сұрақ туындайды: соманы жай ғана сақтап қоймай, оны аздап көбейтуге бола ма?"},
               {"type": "paragraph", "text": "Қарапайым тәсілдердің бірі — ақшаны пайыз есептелетін жинақ өніміне орналастыру."}
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ бойынша пайыз бастапқы сомадан қандай қосымша табыс алуға болатынын көрсетеді."},
               {"type": "paragraph", "text": "Ең қарапайым жағдайда жай пайыз моделі қолданылады. Бұл пайыз тек бастапқы негізгі сомаға есептелетінін білдіреді."},
               {"type": "paragraph", "text": "Формула:"},
               {"type": "paragraph", "text": "I = P × r × t"},
               {"type": "paragraph", "text": "Мұнда:"},
               {"type": "bullet_list", "items": [
                 "I — пайыздық табыс",
                 "P — негізгі сома",
                 "r — жылдық пайыздық мөлшерлеме",
                 "t — жылмен есептелетін уақыт"
               ]},
               {"type": "paragraph", "text": "Бұл есептеу жинақтың өсуінің негізгі қағидасын түсіндіруге көмектеседі."},
               {"type": "paragraph", "text": "Қазақстанда жинақ тақырыбы әсіресе өзекті, себебі көптеген адамдар ақшасын жай ғана банк картасында немесе қолма-қол сақтайды және тіпті шағын пайыздық мөлшерлеменің өзі уақыт өте келе сатып алу қабілетінің төмендеуін ішінара өтеуге көмектесетінін түсінбейді."}
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Мысалы, адам 120,000 ₸ соманы жылдық 10% пайызбен 1 жылға орналастырады."},
               {"type": "paragraph", "text": "Табысты есептейік:"},
               {"type": "paragraph", "text": "120,000 × 0.10 × 1 = 12,000 ₸"},
               {"type": "paragraph", "text": "Сонда:"},
               {"type": "bullet_list", "items": [
                 "пайыздық табыс = 12,000 ₸",
                 "жалпы сома = 132,000 ₸"
               ]}
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 4
           ),
           'kk',
           'Интерактив',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Егер 200,000 ₸ жылдық 5% пайызбен 2 жылға орналастырылса, табыс пен соңғы соманы есептеңіз."}
             ]
           }'::jsonb,
           '{
             "instruction": "Егер 200,000 ₸ жылдық 5% пайызбен 2 жылға орналастырылса, табыс пен соңғы соманы есептеңіз.",
             "fields": [
               {"id": "interest_income", "label": "Табыс"},
               {"id": "total_amount", "label": "Соңғы сома"}
             ],
             "validation": {
               "rules": [
                 "Табыс = 200000 × 0.05 × 2",
                 "Соңғы сома = негізгі сома + табыс"
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
             "explanation": "Назар аударыңыз: мерзім 2 жыл, сондықтан пайыз уақытқа көбейтіледі. Пайыз тек бастапқы негізгі сомаға есептеледі."
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
               where s.code = 'interest_on_savings'
                 and ls.order_index = 5
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жай пайыз — жинақтың қалай қосымша табыс әкеле алатынын көрсететін негізгі әрі түсінікті тәсіл."},
               {"type": "paragraph", "text": "Сома аз болып көрінсе де, мұндай есептеу пайдалы қаржылық ойлауды дамытады: ақшаны тек жұмсап қана қоймай, оны біртіндеп көбейтуге де болады."}
             ]
           }'::jsonb
       );

-- =========================================
-- SUBTOPIC 5: saving_mistakes
-- =========================================

insert into subtopic_translations (subtopic_id, language_code, title)
values (
           (select id from subtopics where code = 'saving_mistakes'),
           'kk',
           'Жинақ жасаудағы қателіктер'
       );

-- STEP 1 — INTRODUCTION
insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select ls.id
               from lesson_steps ls
                        join lessons l on l.id = ls.lesson_id
                        join subtopics s on s.id = l.subtopic_id
               where s.code = 'saving_mistakes'
                 and ls.order_index = 1
           ),
           'kk',
           'Кіріспе',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Адамдар ақша жинағысы келсе де, көп жағдайда жинақ көбеймейді немесе тез жұмсалып кетеді."},
               {"type": "paragraph", "text": "Көбінесе себеп табыста емес, мінез-құлықтағы қателіктерде болады."}
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
               where s.code = 'saving_mistakes'
                 and ls.order_index = 2
           ),
           'kk',
           'Түсіндіру',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ жасауда жиі кездесетін қателіктер:"},
               {"type": "bullet_list", "items": [
                 "нақты мақсаттың болмауы",
                 "тұрақсыз жарналар",
                 "тек артылған ақшаны ғана жинау",
                 "жинақты күнделікті шығындарға пайдалану",
                 "талапты тым жоғары қою"
               ]},
               {"type": "paragraph", "text": "Бұл қателіктер әдеттің қалыптасуына кедергі келтіреді және мотивацияны төмендетеді."},
               {"type": "paragraph", "text": "Қазақстанда жиі кездесетін жағдай — жинақтың жоспарланбаған сатып алуларға немесе өз қаржылық мүмкіндігін ескермей туыстарға көмектесуге жұмсалып кетуі."}
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
               where s.code = 'saving_mistakes'
                 and ls.order_index = 3
           ),
           'kk',
           'Мысал',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Адам айына 30,000 ₸ жинауды жоспарлайды, бірақ:"},
               {"type": "bullet_list", "items": [
                 "бір айды өткізіп алады",
                 "келесі айда жинақтың бір бөлігін жұмсап қояды",
                 "үшінші айда соманы азайтады"
               ]},
               {"type": "paragraph", "text": "Нәтижесінде жыл ішінде күткен нәтиже қалыптаспайды."}
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
               where s.code = 'saving_mistakes'
                 and ls.order_index = 4
           ),
           'kk',
           'Қорытынды',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Жинақ жасаудағы қателіктер көбіне математикаға емес, мінез-құлыққа байланысты."},
               {"type": "paragraph", "text": "Осы қателіктерді тану тұрақты қаржылық әдет қалыптастыруға көмектеседі."}
             ]
           }'::jsonb
       );

commit;