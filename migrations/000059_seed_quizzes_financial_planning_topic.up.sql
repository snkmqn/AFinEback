begin;

create or replace function seed_assessment_quizzes(p_language_code varchar, p_data jsonb)
    returns void as $$
declare
    quiz_item jsonb;
    question_item jsonb;
    option_item jsonb;

    v_quiz_id bigint;
    v_question_id bigint;
    v_option_id bigint;
begin
    for quiz_item in select * from jsonb_array_elements(p_data)
        loop
            insert into quizzes (subtopic_code, passing_score, is_active)
            values (
                       quiz_item ->> 'subtopic_code',
                       coalesce((quiz_item ->> 'passing_score')::int, 50),
                       true
                   )
            on conflict (subtopic_code) do update
                set passing_score = excluded.passing_score,
                    is_active = excluded.is_active,
                    updated_at = now()
            returning id into v_quiz_id;

            insert into quiz_translations (quiz_id, language_code, title)
            values (v_quiz_id, p_language_code, quiz_item ->> 'title')
            on conflict (quiz_id, language_code) do update
                set title = excluded.title;

            for question_item in select * from jsonb_array_elements(quiz_item -> 'questions')
                loop
                    insert into quiz_questions (quiz_id, question_type, order_index, points)
                    values (
                               v_quiz_id,
                               question_item ->> 'question_type',
                               (question_item ->> 'order_index')::int,
                               1
                           )
                    on conflict (quiz_id, order_index) do update
                        set question_type = excluded.question_type,
                            points = excluded.points,
                            updated_at = now()
                    returning id into v_question_id;

                    insert into quiz_question_translations (question_id, language_code, question_text)
                    values (v_question_id, p_language_code, question_item ->> 'question_text')
                    on conflict (question_id, language_code) do update
                        set question_text = excluded.question_text;

                    for option_item in select * from jsonb_array_elements(question_item -> 'options')
                        loop
                            insert into quiz_question_options (question_id, is_correct, order_index)
                            values (
                                       v_question_id,
                                       (option_item ->> 'is_correct')::boolean,
                                       (option_item ->> 'order_index')::int
                                   )
                            on conflict (question_id, order_index) do update
                                set is_correct = excluded.is_correct,
                                    updated_at = now()
                            returning id into v_option_id;

                            insert into quiz_question_option_translations (option_id, language_code, option_text)
                            values (v_option_id, p_language_code, option_item ->> 'option_text')
                            on conflict (option_id, language_code) do update
                                set option_text = excluded.option_text;
                        end loop;
                end loop;
        end loop;
end;
$$ language plpgsql;

select seed_assessment_quizzes('ru', $json$[
  {
    "subtopic_code": "financial_goals",
    "title": "Квиз: Финансовые цели",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое финансовая цель?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Любое желание потратить деньги", "is_correct": false, "order_index": 1 },
          { "option_text": "Конкретный финансовый результат, которого человек хочет достичь", "is_correct": true, "order_index": 2 },
          { "option_text": "Только покупка недвижимости", "is_correct": false, "order_index": 3 },
          { "option_text": "Случайная трата в течение месяца", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Какие признаки делают финансовую цель более понятной и рабочей?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Конкретность", "is_correct": true, "order_index": 1 },
          { "option_text": "Измеримость", "is_correct": true, "order_index": 2 },
          { "option_text": "Срок достижения", "is_correct": true, "order_index": 3 },
          { "option_text": "Полное отсутствие суммы", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Какая формулировка цели является более правильной?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Хочу больше денег", "is_correct": false, "order_index": 1 },
          { "option_text": "Хочу когда-нибудь накопить", "is_correct": false, "order_index": 2 },
          { "option_text": "Накопить 600 000 ₸ на резервный фонд за 12 месяцев", "is_correct": true, "order_index": 3 },
          { "option_text": "Буду меньше тратить без плана", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Если цель — накопить 600 000 ₸ за 12 месяцев, сколько нужно откладывать ежемесячно?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "30 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "50 000 ₸", "is_correct": true, "order_index": 2 },
          { "option_text": "60 000 ₸", "is_correct": false, "order_index": 3 },
          { "option_text": "100 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Чем точнее определена финансовая цель, тем легче планировать действия и отслеживать прогресс.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Верно", "is_correct": true, "order_index": 1 },
          { "option_text": "Неверно", "is_correct": false, "order_index": 2 },
          { "option_text": "Только для крупных покупок", "is_correct": false, "order_index": 3 },
          { "option_text": "Только при высоком доходе", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "short_vs_long_goals",
    "title": "Квиз: Краткосрочные и долгосрочные цели",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что обычно относится к краткосрочным финансовым целям?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Цели, которые планируется достичь в течение короткого периода, обычно до 1 года", "is_correct": true, "order_index": 1 },
          { "option_text": "Цели только на пенсию", "is_correct": false, "order_index": 2 },
          { "option_text": "Цели без срока и суммы", "is_correct": false, "order_index": 3 },
          { "option_text": "Цели, которые невозможно измерить", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Какие цели чаще относятся к долгосрочным?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Накопление на первоначальный взнос по ипотеке", "is_correct": true, "order_index": 1 },
          { "option_text": "Покупка недвижимости", "is_correct": true, "order_index": 2 },
          { "option_text": "Создание инвестиционного капитала", "is_correct": true, "order_index": 3 },
          { "option_text": "Покупка небольшого бытового товара за один месяц", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Почему краткосрочные цели требуют высокой ликвидности?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Потому что деньги могут понадобиться в ближайшее время", "is_correct": true, "order_index": 1 },
          { "option_text": "Потому что их нельзя планировать", "is_correct": false, "order_index": 2 },
          { "option_text": "Потому что они всегда связаны только с кредитами", "is_correct": false, "order_index": 3 },
          { "option_text": "Потому что они не требуют накоплений", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Какая цель является долгосрочной?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "Накопить 300 000 ₸ на отпуск за 6 месяцев", "is_correct": false, "order_index": 1 },
          { "option_text": "Оплатить текущую подписку", "is_correct": false, "order_index": 2 },
          { "option_text": "Накопить 5 000 000 ₸ на первоначальный взнос за 3 года", "is_correct": true, "order_index": 3 },
          { "option_text": "Купить одежду в этом месяце", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "При долгосрочном планировании важно учитывать инфляцию.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Верно", "is_correct": true, "order_index": 1 },
          { "option_text": "Неверно", "is_correct": false, "order_index": 2 },
          { "option_text": "Только для краткосрочных целей", "is_correct": false, "order_index": 3 },
          { "option_text": "Только если цель меньше одного месяца", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "spending_priorities",
    "title": "Квиз: Приоритеты расходов",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое приоритеты расходов?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Система распределения дохода по степени важности расходов", "is_correct": true, "order_index": 1 },
          { "option_text": "Полный отказ от всех личных трат", "is_correct": false, "order_index": 2 },
          { "option_text": "Покупка только самых дорогих товаров", "is_correct": false, "order_index": 3 },
          { "option_text": "Использование кредита вместо бюджета", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Какие расходы относятся к обязательным?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Аренда или ипотека", "is_correct": true, "order_index": 1 },
          { "option_text": "Продукты питания", "is_correct": true, "order_index": 2 },
          { "option_text": "Коммунальные услуги", "is_correct": true, "order_index": 3 },
          { "option_text": "Импульсные покупки", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Что лучше сделать после покрытия обязательных расходов?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Потратить всё на развлечения", "is_correct": false, "order_index": 1 },
          { "option_text": "Отложить средства на цели и накопления", "is_correct": true, "order_index": 2 },
          { "option_text": "Не учитывать остаток", "is_correct": false, "order_index": 3 },
          { "option_text": "Взять новый кредит", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Если доход 300 000 ₸, обязательные расходы 240 000 ₸, сколько остаётся после них?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "30 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "60 000 ₸", "is_correct": true, "order_index": 2 },
          { "option_text": "80 000 ₸", "is_correct": false, "order_index": 3 },
          { "option_text": "120 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Необязательные расходы чаще всего можно пересматривать, чтобы освободить деньги для целей.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Верно", "is_correct": true, "order_index": 1 },
          { "option_text": "Неверно", "is_correct": false, "order_index": 2 },
          { "option_text": "Только если нет обязательных расходов", "is_correct": false, "order_index": 3 },
          { "option_text": "Только при очень высоком доходе", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "savings_plan",
    "title": "Квиз: План накопления",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что показывает план накопления?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Какую сумму нужно регулярно откладывать для достижения цели", "is_correct": true, "order_index": 1 },
          { "option_text": "Только список случайных расходов", "is_correct": false, "order_index": 2 },
          { "option_text": "Размер всех кредитов в стране", "is_correct": false, "order_index": 3 },
          { "option_text": "Только сумму дохода без расходов", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Что важно учитывать при построении плана накопления?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Сумму цели", "is_correct": true, "order_index": 1 },
          { "option_text": "Срок достижения", "is_correct": true, "order_index": 2 },
          { "option_text": "Свободные средства после обязательных расходов", "is_correct": true, "order_index": 3 },
          { "option_text": "Цвет банковского приложения", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Если цель — 720 000 ₸ за 12 месяцев, какой ежемесячный взнос нужен?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "45 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "50 000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "60 000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "72 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Что можно сделать, если требуемый ежемесячный взнос выше свободных средств?",
        "question_type": "multiple_choice",
        "order_index": 4,
        "options": [
          { "option_text": "Увеличить срок накопления", "is_correct": true, "order_index": 1 },
          { "option_text": "Сократить целевую сумму", "is_correct": true, "order_index": 2 },
          { "option_text": "Пересмотреть структуру расходов", "is_correct": true, "order_index": 3 },
          { "option_text": "Игнорировать проблему и ничего не менять", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Реалистичный план накопления должен быть выполнимым в реальной жизни, а не только математически правильным.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Верно", "is_correct": true, "order_index": 1 },
          { "option_text": "Неверно", "is_correct": false, "order_index": 2 },
          { "option_text": "Только для краткосрочных целей", "is_correct": false, "order_index": 3 },
          { "option_text": "Только при отсутствии расходов", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "progress_control",
    "title": "Квиз: Контроль выполнения",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что означает контроль выполнения финансового плана?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Регулярную проверку соответствия фактических действий плану", "is_correct": true, "order_index": 1 },
          { "option_text": "Полный отказ от изменения плана", "is_correct": false, "order_index": 2 },
          { "option_text": "Проверку бюджета один раз в несколько лет", "is_correct": false, "order_index": 3 },
          { "option_text": "Наказание себя за любую ошибку", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Что помогает делать контроль выполнения?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Отслеживать прогресс", "is_correct": true, "order_index": 1 },
          { "option_text": "Выявлять отклонения от плана", "is_correct": true, "order_index": 2 },
          { "option_text": "Своевременно корректировать поведение", "is_correct": true, "order_index": 3 },
          { "option_text": "Не замечать финансовые проблемы", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Если план — откладывать 50 000 ₸ в месяц, сколько должно быть накоплено через 3 месяца?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "100 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "120 000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "150 000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "200 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Если по плану должно быть 150 000 ₸, а фактически накоплено 120 000 ₸, какое отклонение?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "10 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "20 000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "30 000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "50 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Отклонение от плана нужно не игнорировать, а использовать как сигнал для корректировки действий.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Верно", "is_correct": true, "order_index": 1 },
          { "option_text": "Неверно", "is_correct": false, "order_index": 2 },
          { "option_text": "Только если доход не меняется", "is_correct": false, "order_index": 3 },
          { "option_text": "Только если цель уже достигнута", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  }
]$json$::jsonb);

select seed_assessment_quizzes('en', $json$[
  {
    "subtopic_code": "financial_goals",
    "title": "Quiz: Financial Goals",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is a financial goal?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Any desire to spend money", "is_correct": false, "order_index": 1 },
          { "option_text": "A specific financial result a person wants to achieve", "is_correct": true, "order_index": 2 },
          { "option_text": "Only buying real estate", "is_correct": false, "order_index": 3 },
          { "option_text": "A random monthly expense", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Which features make a financial goal clearer and more effective?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Specificity", "is_correct": true, "order_index": 1 },
          { "option_text": "Measurability", "is_correct": true, "order_index": 2 },
          { "option_text": "A deadline", "is_correct": true, "order_index": 3 },
          { "option_text": "No amount at all", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Which goal statement is better formulated?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "I want more money", "is_correct": false, "order_index": 1 },
          { "option_text": "I want to save someday", "is_correct": false, "order_index": 2 },
          { "option_text": "Save 600,000 ₸ for an emergency fund in 12 months", "is_correct": true, "order_index": 3 },
          { "option_text": "I will spend less without a plan", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "If the goal is to save 600,000 ₸ in 12 months, how much should be saved monthly?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "30,000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "50,000 ₸", "is_correct": true, "order_index": 2 },
          { "option_text": "60,000 ₸", "is_correct": false, "order_index": 3 },
          { "option_text": "100,000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "The more clearly a financial goal is defined, the easier it is to plan actions and track progress.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "True", "is_correct": true, "order_index": 1 },
          { "option_text": "False", "is_correct": false, "order_index": 2 },
          { "option_text": "Only for large purchases", "is_correct": false, "order_index": 3 },
          { "option_text": "Only with a high income", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "short_vs_long_goals",
    "title": "Quiz: Short-Term and Long-Term Goals",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What usually belongs to short-term financial goals?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Goals planned within a short period, usually up to 1 year", "is_correct": true, "order_index": 1 },
          { "option_text": "Only retirement goals", "is_correct": false, "order_index": 2 },
          { "option_text": "Goals without time or amount", "is_correct": false, "order_index": 3 },
          { "option_text": "Goals that cannot be measured", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Which goals are more often long-term?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Saving for a mortgage down payment", "is_correct": true, "order_index": 1 },
          { "option_text": "Buying property", "is_correct": true, "order_index": 2 },
          { "option_text": "Building investment capital", "is_correct": true, "order_index": 3 },
          { "option_text": "Buying a small household item this month", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Why do short-term goals require high liquidity?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Because the money may be needed soon", "is_correct": true, "order_index": 1 },
          { "option_text": "Because they cannot be planned", "is_correct": false, "order_index": 2 },
          { "option_text": "Because they always involve loans", "is_correct": false, "order_index": 3 },
          { "option_text": "Because they do not require savings", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Which goal is long-term?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "Save 300,000 ₸ for a vacation in 6 months", "is_correct": false, "order_index": 1 },
          { "option_text": "Pay for a current subscription", "is_correct": false, "order_index": 2 },
          { "option_text": "Save 5,000,000 ₸ for a down payment in 3 years", "is_correct": true, "order_index": 3 },
          { "option_text": "Buy clothes this month", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "When planning long-term goals, it is important to consider inflation.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "True", "is_correct": true, "order_index": 1 },
          { "option_text": "False", "is_correct": false, "order_index": 2 },
          { "option_text": "Only for short-term goals", "is_correct": false, "order_index": 3 },
          { "option_text": "Only for goals under one month", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "spending_priorities",
    "title": "Quiz: Spending Priorities",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What are spending priorities?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "A system of distributing income by importance of expenses", "is_correct": true, "order_index": 1 },
          { "option_text": "Completely refusing all personal spending", "is_correct": false, "order_index": 2 },
          { "option_text": "Buying only the most expensive products", "is_correct": false, "order_index": 3 },
          { "option_text": "Using loans instead of a budget", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Which expenses are considered essential?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Rent or mortgage", "is_correct": true, "order_index": 1 },
          { "option_text": "Groceries", "is_correct": true, "order_index": 2 },
          { "option_text": "Utilities", "is_correct": true, "order_index": 3 },
          { "option_text": "Impulse purchases", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "What is better to do after covering essential expenses?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Spend everything on entertainment", "is_correct": false, "order_index": 1 },
          { "option_text": "Set aside money for goals and savings", "is_correct": true, "order_index": 2 },
          { "option_text": "Ignore the remaining amount", "is_correct": false, "order_index": 3 },
          { "option_text": "Take a new loan", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "If income is 300,000 ₸ and essential expenses are 240,000 ₸, how much remains?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "30,000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "60,000 ₸", "is_correct": true, "order_index": 2 },
          { "option_text": "80,000 ₸", "is_correct": false, "order_index": 3 },
          { "option_text": "120,000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Non-essential expenses can often be reviewed to free money for goals.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "True", "is_correct": true, "order_index": 1 },
          { "option_text": "False", "is_correct": false, "order_index": 2 },
          { "option_text": "Only if there are no essential expenses", "is_correct": false, "order_index": 3 },
          { "option_text": "Only with a very high income", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "savings_plan",
    "title": "Quiz: Savings Plan",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does a savings plan show?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "How much should be saved regularly to reach a goal", "is_correct": true, "order_index": 1 },
          { "option_text": "Only a list of random expenses", "is_correct": false, "order_index": 2 },
          { "option_text": "All loans in the country", "is_correct": false, "order_index": 3 },
          { "option_text": "Only income without expenses", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "What is important when building a savings plan?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Target amount", "is_correct": true, "order_index": 1 },
          { "option_text": "Deadline", "is_correct": true, "order_index": 2 },
          { "option_text": "Available money after essential expenses", "is_correct": true, "order_index": 3 },
          { "option_text": "The color of the banking app", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "If the goal is 720,000 ₸ in 12 months, what monthly contribution is needed?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "45,000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "50,000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "60,000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "72,000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "What can be done if the required monthly amount is higher than free cash flow?",
        "question_type": "multiple_choice",
        "order_index": 4,
        "options": [
          { "option_text": "Increase the saving period", "is_correct": true, "order_index": 1 },
          { "option_text": "Reduce the target amount", "is_correct": true, "order_index": 2 },
          { "option_text": "Review expenses", "is_correct": true, "order_index": 3 },
          { "option_text": "Ignore the problem and change nothing", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "A realistic savings plan should be practical in real life, not only mathematically correct.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "True", "is_correct": true, "order_index": 1 },
          { "option_text": "False", "is_correct": false, "order_index": 2 },
          { "option_text": "Only for short-term goals", "is_correct": false, "order_index": 3 },
          { "option_text": "Only with no expenses", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "progress_control",
    "title": "Quiz: Progress Control",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does monitoring a financial plan mean?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Regularly checking whether actual actions match the plan", "is_correct": true, "order_index": 1 },
          { "option_text": "Never changing the plan", "is_correct": false, "order_index": 2 },
          { "option_text": "Checking the budget once every few years", "is_correct": false, "order_index": 3 },
          { "option_text": "Punishing yourself for every mistake", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "What does progress control help with?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Tracking progress", "is_correct": true, "order_index": 1 },
          { "option_text": "Finding deviations from the plan", "is_correct": true, "order_index": 2 },
          { "option_text": "Adjusting behavior in time", "is_correct": true, "order_index": 3 },
          { "option_text": "Ignoring financial problems", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "If the plan is to save 50,000 ₸ monthly, how much should be saved after 3 months?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "100,000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "120,000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "150,000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "200,000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "If the plan says 150,000 ₸ should be saved, but actually 120,000 ₸ is saved, what is the deviation?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "10,000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "20,000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "30,000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "50,000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Deviation from the plan should not be ignored but used as a signal to adjust actions.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "True", "is_correct": true, "order_index": 1 },
          { "option_text": "False", "is_correct": false, "order_index": 2 },
          { "option_text": "Only if income does not change", "is_correct": false, "order_index": 3 },
          { "option_text": "Only if the goal is already reached", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  }
]$json$::jsonb);

select seed_assessment_quizzes('kk', $json$[
  {
    "subtopic_code": "financial_goals",
    "title": "Квиз: Қаржылық мақсаттар",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Қаржылық мақсат деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Ақшаны жұмсауға деген кез келген тілек", "is_correct": false, "order_index": 1 },
          { "option_text": "Адам қол жеткізгісі келетін нақты қаржылық нәтиже", "is_correct": true, "order_index": 2 },
          { "option_text": "Тек жылжымайтын мүлік сатып алу", "is_correct": false, "order_index": 3 },
          { "option_text": "Ай ішіндегі кездейсоқ шығын", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Қай қасиеттер қаржылық мақсатты түсінікті әрі тиімді етеді?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Нақтылық", "is_correct": true, "order_index": 1 },
          { "option_text": "Өлшенуі", "is_correct": true, "order_index": 2 },
          { "option_text": "Мерзімі", "is_correct": true, "order_index": 3 },
          { "option_text": "Соманың мүлде болмауы", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Қай мақсат дұрыс қойылған?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Көбірек ақша қалаймын", "is_correct": false, "order_index": 1 },
          { "option_text": "Бір күні жинаймын", "is_correct": false, "order_index": 2 },
          { "option_text": "12 айда резервтік қорға 600 000 ₸ жинау", "is_correct": true, "order_index": 3 },
          { "option_text": "Жоспарсыз аз жұмсаймын", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Егер мақсат 12 айда 600 000 ₸ жинау болса, ай сайын қанша жинау керек?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "30 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "50 000 ₸", "is_correct": true, "order_index": 2 },
          { "option_text": "60 000 ₸", "is_correct": false, "order_index": 3 },
          { "option_text": "100 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Қаржылық мақсат неғұрлым нақты болса, әрекеттерді жоспарлау мен прогресті бақылау соғұрлым оңай.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Дұрыс", "is_correct": true, "order_index": 1 },
          { "option_text": "Қате", "is_correct": false, "order_index": 2 },
          { "option_text": "Тек үлкен сатып алуларға", "is_correct": false, "order_index": 3 },
          { "option_text": "Тек жоғары табыста", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "short_vs_long_goals",
    "title": "Квиз: Қысқа және ұзақ мерзімді мақсаттар",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Қысқа мерзімді қаржылық мақсаттарға не жатады?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Әдетте 1 жылға дейін орындалатын мақсаттар", "is_correct": true, "order_index": 1 },
          { "option_text": "Тек зейнетақы мақсаттары", "is_correct": false, "order_index": 2 },
          { "option_text": "Мерзімі мен сомасы жоқ мақсаттар", "is_correct": false, "order_index": 3 },
          { "option_text": "Өлшеуге келмейтін мақсаттар", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Қай мақсаттар көбіне ұзақ мерзімді болады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Ипотекаға алғашқы жарна жинау", "is_correct": true, "order_index": 1 },
          { "option_text": "Жылжымайтын мүлік сатып алу", "is_correct": true, "order_index": 2 },
          { "option_text": "Инвестициялық капитал жинау", "is_correct": true, "order_index": 3 },
          { "option_text": "Осы айда шағын тұрмыстық зат алу", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Неліктен қысқа мерзімді мақсаттарға жоғары өтімділік қажет?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Себебі ақша жақын уақытта керек болуы мүмкін", "is_correct": true, "order_index": 1 },
          { "option_text": "Себебі оларды жоспарлау мүмкін емес", "is_correct": false, "order_index": 2 },
          { "option_text": "Себебі олар әрқашан несиемен байланысты", "is_correct": false, "order_index": 3 },
          { "option_text": "Себебі оларға жинақ қажет емес", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Қай мақсат ұзақ мерзімді?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "6 айда демалысқа 300 000 ₸ жинау", "is_correct": false, "order_index": 1 },
          { "option_text": "Қазіргі жазылымды төлеу", "is_correct": false, "order_index": 2 },
          { "option_text": "3 жылда алғашқы жарнаға 5 000 000 ₸ жинау", "is_correct": true, "order_index": 3 },
          { "option_text": "Осы айда киім сатып алу", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Ұзақ мерзімді жоспарлауда инфляцияны ескеру маңызды.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Дұрыс", "is_correct": true, "order_index": 1 },
          { "option_text": "Қате", "is_correct": false, "order_index": 2 },
          { "option_text": "Тек қысқа мерзімді мақсаттарға", "is_correct": false, "order_index": 3 },
          { "option_text": "Тек бір айдан аз мақсаттарға", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "spending_priorities",
    "title": "Квиз: Шығындар басымдығы",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Шығындар басымдығы деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Табысты шығындардың маңыздылығына қарай бөлу жүйесі", "is_correct": true, "order_index": 1 },
          { "option_text": "Жеке шығындардың бәрінен толық бас тарту", "is_correct": false, "order_index": 2 },
          { "option_text": "Тек ең қымбат заттарды сатып алу", "is_correct": false, "order_index": 3 },
          { "option_text": "Бюджет орнына несие қолдану", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Қай шығындар міндетті болып саналады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Жалдау ақысы немесе ипотека", "is_correct": true, "order_index": 1 },
          { "option_text": "Азық-түлік", "is_correct": true, "order_index": 2 },
          { "option_text": "Коммуналдық төлемдер", "is_correct": true, "order_index": 3 },
          { "option_text": "Ойланбай жасалған сатып алулар", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Міндетті шығындар жабылғаннан кейін не істеген дұрыс?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "Барлығын ойын-сауыққа жұмсау", "is_correct": false, "order_index": 1 },
          { "option_text": "Мақсаттар мен жинаққа ақша бөлу", "is_correct": true, "order_index": 2 },
          { "option_text": "Қалған соманы елемеу", "is_correct": false, "order_index": 3 },
          { "option_text": "Жаңа несие алу", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Егер табыс 300 000 ₸, ал міндетті шығындар 240 000 ₸ болса, қанша қалады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "30 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "60 000 ₸", "is_correct": true, "order_index": 2 },
          { "option_text": "80 000 ₸", "is_correct": false, "order_index": 3 },
          { "option_text": "120 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Міндетті емес шығындарды қайта қарап, мақсаттарға ақша босатуға болады.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Дұрыс", "is_correct": true, "order_index": 1 },
          { "option_text": "Қате", "is_correct": false, "order_index": 2 },
          { "option_text": "Тек міндетті шығын болмаса", "is_correct": false, "order_index": 3 },
          { "option_text": "Тек өте жоғары табыста", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "savings_plan",
    "title": "Квиз: Жинақ жоспары",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Жинақ жоспары нені көрсетеді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Мақсатқа жету үшін қанша тұрақты жинау керегін", "is_correct": true, "order_index": 1 },
          { "option_text": "Кездейсоқ шығындар тізімін ғана", "is_correct": false, "order_index": 2 },
          { "option_text": "Елдегі барлық несиелерді", "is_correct": false, "order_index": 3 },
          { "option_text": "Тек табысты шығынсыз", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Жинақ жоспарын құруда нені ескеру маңызды?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Мақсат сомасы", "is_correct": true, "order_index": 1 },
          { "option_text": "Мерзімі", "is_correct": true, "order_index": 2 },
          { "option_text": "Міндетті шығыннан кейінгі бос ақша", "is_correct": true, "order_index": 3 },
          { "option_text": "Банк қосымшасының түсі", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Егер мақсат 12 айда 720 000 ₸ болса, ай сайын қанша салу керек?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "45 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "50 000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "60 000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "72 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Егер қажет айлық сома бос қаражаттан жоғары болса, не істеуге болады?",
        "question_type": "multiple_choice",
        "order_index": 4,
        "options": [
          { "option_text": "Жинау мерзімін ұзарту", "is_correct": true, "order_index": 1 },
          { "option_text": "Мақсат сомасын азайту", "is_correct": true, "order_index": 2 },
          { "option_text": "Шығындарды қайта қарау", "is_correct": true, "order_index": 3 },
          { "option_text": "Ештеңе өзгертпей елемеу", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Шынайы жинақ жоспары тек математикалық емес, өмірде орындалатын болуы керек.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Дұрыс", "is_correct": true, "order_index": 1 },
          { "option_text": "Қате", "is_correct": false, "order_index": 2 },
          { "option_text": "Тек қысқа мерзімді мақсаттарға", "is_correct": false, "order_index": 3 },
          { "option_text": "Тек шығын болмаса", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  },
  {
    "subtopic_code": "progress_control",
    "title": "Квиз: Орындалуды бақылау",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Қаржылық жоспарды бақылау нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          { "option_text": "Нақты әрекеттердің жоспарға сай келуін тұрақты тексеру", "is_correct": true, "order_index": 1 },
          { "option_text": "Жоспарды ешқашан өзгертпеу", "is_correct": false, "order_index": 2 },
          { "option_text": "Бюджетті бірнеше жылда бір рет қарау", "is_correct": false, "order_index": 3 },
          { "option_text": "Әр қателік үшін өзіңді жазалау", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Бақылау неге көмектеседі?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          { "option_text": "Прогресті бақылауға", "is_correct": true, "order_index": 1 },
          { "option_text": "Жоспардан ауытқуды анықтауға", "is_correct": true, "order_index": 2 },
          { "option_text": "Әрекеттерді уақытында түзетуге", "is_correct": true, "order_index": 3 },
          { "option_text": "Қаржылық мәселелерді байқамауға", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Егер жоспар бойынша айына 50 000 ₸ жинау керек болса, 3 айдан кейін қанша болуы тиіс?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          { "option_text": "100 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "120 000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "150 000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "200 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Егер жоспар бойынша 150 000 ₸ болуы керек, ал нақты 120 000 ₸ болса, ауытқу қанша?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          { "option_text": "10 000 ₸", "is_correct": false, "order_index": 1 },
          { "option_text": "20 000 ₸", "is_correct": false, "order_index": 2 },
          { "option_text": "30 000 ₸", "is_correct": true, "order_index": 3 },
          { "option_text": "50 000 ₸", "is_correct": false, "order_index": 4 }
        ]
      },
      {
        "question_text": "Жоспардан ауытқуды елемей қоймай, әрекеттерді түзету сигналы ретінде пайдалану керек.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          { "option_text": "Дұрыс", "is_correct": true, "order_index": 1 },
          { "option_text": "Қате", "is_correct": false, "order_index": 2 },
          { "option_text": "Тек табыс өзгермесе", "is_correct": false, "order_index": 3 },
          { "option_text": "Тек мақсат орындалса", "is_correct": false, "order_index": 4 }
        ]
      }
    ]
  }
]$json$::jsonb);

drop function seed_assessment_quizzes(varchar, jsonb);

commit;
