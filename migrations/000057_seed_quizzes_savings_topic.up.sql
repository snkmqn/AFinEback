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
    "subtopic_code": "why_save",
    "title": "Квиз: Зачем откладывать деньги",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое сбережения?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Деньги, потраченные сразу",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Часть дохода, отложенная на будущее",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Только наличные дома",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Любой кредит",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Для чего нужны сбережения?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Защита от непредвиденных ситуаций",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Достижение целей",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Снижение стресса",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Рост долгов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если откладывать 10% от дохода 250 000 ₸, сколько это в месяц?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "15 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "25 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "50 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "75 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему важны даже небольшие суммы?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Со временем накапливаются",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Их можно не учитывать",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Они уменьшают доход",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Они бесполезны",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Сбережения помогают чувствовать уверенность в будущем.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Верно",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Неверно",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Только для богатых",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только для бизнеса",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "emergency_fund",
    "title": "Квиз: Финансовая подушка",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое финансовая подушка?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Деньги на отпуск",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Резерв на экстренные случаи",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Средства на покупки",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Любая карта банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какой размер подушки часто рекомендуют?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "3 месяца расходов",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "6 месяцев расходов",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "1 день расходов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только одну зарплату",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если расходы 320 000 ₸, сколько составит минимум на 3 месяца?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "640 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "960 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "1 280 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "1 920 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Для чего не используют финансовую подушку?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Лечение",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Потеря дохода",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Спонтанные покупки",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ремонт",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Даже маленькие суммы могут создать подушку со временем.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Верно",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Неверно",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Только в долларах",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при высокой зарплате",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "how_to_save",
    "title": "Квиз: Как начать откладывать",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Какой первый шаг для накоплений?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Ждать повышения зарплаты",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Определить сумму и начать регулярно",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Взять кредит",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тратить всё сразу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что помогает откладывать стабильно?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Автоперевод после зарплаты",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Конкретная цель",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Регулярность",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Случайные траты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что лучше откладывать сначала?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Остатки в конце месяца",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Часть дохода сразу после поступления",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Только бонусы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Ничего",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему важна цель накоплений?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Повышает мотивацию",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Уменьшает доход",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Создаёт долги",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Не влияет",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Регулярность важнее большой суммы один раз.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Верно",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Неверно",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Только для бизнеса",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при высокой зарплате",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "interest_on_savings",
    "title": "Квиз: Проценты на сбережения",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что означает процент по вкладу?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Комиссия банка",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Доход за хранение денег в банке",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Штраф за снятие денег",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Обязательный налог",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "От чего зависит итоговый доход по вкладу?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Сумма вклада",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Процентная ставка",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Срок размещения",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Цвет банковской карты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если положить 500 000 ₸ под 10% годовых, сколько составит простой доход за год?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "25 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "50 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "75 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "100 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему проценты помогают накоплениям расти?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Деньги начинают приносить дополнительный доход",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Банк забирает часть суммы",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Сбережения уменьшаются",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Доход не меняется",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Процент по вкладу может увеличить итоговую сумму накоплений.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Верно",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Неверно",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Только в валюте",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только на один месяц",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "saving_mistakes",
    "title": "Квиз: Ошибки при накоплении",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Какая ошибка мешает накоплениям чаще всего?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Регулярность",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Отсутствие плана и системы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Постановка цели",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Контроль расходов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие действия вредят накоплениям?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Откладывать только остатки",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тратить импульсивно",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Пропускать месяцы без причины",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Автоматически переводить часть дохода",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что лучше делать вместо ожидания большой зарплаты?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Начать с небольшой суммы уже сейчас",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ничего не откладывать",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Брать кредит",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Потратить весь доход",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему важно отслеживать прогресс накоплений?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Это поддерживает мотивацию и дисциплину",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Это уменьшает зарплату",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Это создаёт долги",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Это бесполезно",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Даже небольшие ошибки в привычках могут мешать накоплениям.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Верно",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Неверно",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Только у богатых людей",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при высоких расходах",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]$json$::jsonb);

select seed_assessment_quizzes('en', $json$[
  {
    "subtopic_code": "why_save",
    "title": "Quiz: Why Save Money",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What are savings?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Money spent immediately",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Part of income set aside for the future",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Only cash kept at home",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Any bank loan",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why are savings important?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Protection from unexpected situations",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Achieving financial goals",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Reducing stress",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Increasing debt",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If you save 10% of an income of 250,000 ₸, how much is that per month?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "15,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "25,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "50,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "75,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why are even small amounts important?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "They grow over time",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "They can be ignored",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "They reduce income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "They are useless",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Savings help people feel more secure about the future.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "True",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "False",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Only for wealthy people",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for business owners",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "emergency_fund",
    "title": "Quiz: Emergency Fund",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is an emergency fund?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Money for vacations",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Reserve money for emergencies",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Money for shopping",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Any bank card balance",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What emergency fund size is often recommended?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "3 months of expenses",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "6 months of expenses",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "1 day of expenses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only one salary",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If monthly expenses are 320,000 ₸, what is the minimum fund for 3 months?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "640,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "960,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "1,280,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "1,920,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What should an emergency fund NOT be used for?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Medical treatment",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Loss of income",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Impulse purchases",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Unexpected repairs",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Even small regular amounts can build an emergency fund over time.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "True",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "False",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Only in foreign currency",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with a high salary",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "how_to_save",
    "title": "Quiz: How to Start Saving",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is the first step to start saving?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Wait for a higher salary",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Choose an amount and save regularly",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Take a loan first",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Spend everything immediately",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What helps save money consistently?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Automatic transfer after payday",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "A clear goal",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Regular habit",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Random spending",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is better to save first?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Whatever is left at the end of the month",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Part of income immediately after receiving it",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Only bonuses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Nothing at all",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is having a savings goal important?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "It increases motivation",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "It lowers income",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "It creates debt",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "It has no effect",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Regular saving is more important than one large deposit.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "True",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "False",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Only for companies",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for high earners",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "interest_on_savings",
    "title": "Quiz: Interest on Savings",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does deposit interest mean?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "A bank fee",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Income earned for keeping money in the bank",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "A penalty for withdrawal",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "A mandatory tax",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What affects total deposit income?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Deposit amount",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Interest rate",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Term length",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Bank card color",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If you place 500,000 ₸ at 10% annual interest, what is the simple yearly income?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "25,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "50,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "75,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "100,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why does interest help savings grow?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Money starts generating additional income",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "The bank takes your savings",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Savings become smaller",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Income never changes",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Deposit interest can increase your final savings amount.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "True",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "False",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Only in foreign currency",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for one month",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "saving_mistakes",
    "title": "Quiz: Saving Mistakes",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Which mistake most often prevents people from saving?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Regular discipline",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Lack of a plan and system",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Having a goal",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Tracking expenses",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which actions harm savings progress?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Saving only leftovers",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Impulse spending",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Skipping months without reason",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Automatically transferring part of income",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is better than waiting for a big salary increase?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Start now with a small amount",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Save nothing",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Take a loan",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Spend the entire income",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is it important to track savings progress?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "It supports motivation and discipline",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "It lowers salary",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "It creates debt",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "It is useless",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Even small habit mistakes can prevent savings growth.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "True",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "False",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Only for wealthy people",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with high expenses",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]$json$::jsonb);

select seed_assessment_quizzes('kk', $json$[
  {
    "subtopic_code": "why_save",
    "title": "Квиз: Неліктен ақша жинау керек",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Жинақ дегеніміз не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Бірден жұмсалған ақша",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Болашаққа сақталған табыстың бір бөлігі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тек үйдегі қолма-қол ақша",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Кез келген несие",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жинақ не үшін қажет?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Күтпеген жағдайлардан қорғану",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қаржылық мақсаттарға жету",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Күйзелісті азайту",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Қарызды көбейту",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер 250 000 ₸ табыстың 10%-ын жинасаңыз, айына қанша болады?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "15 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "25 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "50 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "75 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен шағын сомалар да маңызды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Уақыт өте келе көбейеді",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Оларды елемеуге болады",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Табысты азайтады",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Пайдасыз",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жинақ адамға болашаққа сенімділік береді.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Дұрыс",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қате",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Тек бай адамдарға",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек бизнеске",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "emergency_fund",
    "title": "Квиз: Қаржылық қауіпсіздік қоры",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Қаржылық қауіпсіздік қоры деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Демалысқа арналған ақша",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Төтенше жағдайларға арналған резерв",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Сатып алуға арналған қаражат",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Кез келген банк картасы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қордың қандай көлемі жиі ұсынылады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "3 айлық шығын",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "6 айлық шығын",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "1 күндік шығын",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек бір жалақы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер айлық шығын 320 000 ₸ болса, 3 айға ең аз қор қанша?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "640 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "960 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "1 280 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "1 920 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қорды не үшін қолдануға болмайды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Емделуге",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Табыс жоғалғанда",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Кездейсоқ сатып алуға",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Күтпеген жөндеуге",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Аз-аздан тұрақты жинақтау арқылы да қор жасауға болады.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Дұрыс",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қате",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Тек доллармен",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек жоғары жалақымен",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "how_to_save",
    "title": "Квиз: Қалай ақша жинауды бастау керек",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Жинақтауды бастаудың алғашқы қадамы қандай?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Жалақының өсуін күту",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Белгілі бір соманы таңдап, тұрақты жинау",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Алдымен несие алу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Барлығын бірден жұмсау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Нені жасау тұрақты жинақтауға көмектеседі?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Жалақы түскен соң автоматты аударым",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Нақты мақсат",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тұрақты әдет",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Кездейсоқ шығындар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Ең дұрысы қай кезде ақша бөлу?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Ай соңында қалғанын",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Табыс түскен бойда бір бөлігін",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тек сыйақыдан",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Мүлде бөлмеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен жинақ мақсаты маңызды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Мотивацияны арттырады",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Табысты азайтады",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Қарызды көбейтеді",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Еш әсер етпейді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бір рет көп салғаннан гөрі, тұрақты жинау маңыздырақ.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Дұрыс",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қате",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Тек компанияларға",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек жоғары табысқа",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "interest_on_savings",
    "title": "Квиз: Жинақ бойынша пайыз",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Депозит пайызы нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Банк комиссиясы",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Банкте ақша сақтау үшін алынатын табыс",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Ақшаны шешкені үшін айыппұл",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Міндетті салық",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Депозиттен түсетін табыс неге байланысты?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Салым сомасына",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Пайыздық мөлшерлемеге",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Мерзіміне",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Карта түсіне",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "500 000 ₸ ақшаны жылдық 10% мөлшерлемемен салсаңыз, бір жылдағы қарапайым табыс қанша?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "25 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "50 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "75 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "100 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен пайыз жинақты өсіреді?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Ақша қосымша табыс әкеледі",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Банк ақшаны алып қояды",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Жинақ азаяды",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Табыс өзгермейді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Депозит пайызы жинақтың соңғы сомасын арттыра алады.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Дұрыс",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қате",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Тек шетел валютасында",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек бір айға",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "saving_mistakes",
    "title": "Квиз: Жинақтаудағы қателіктер",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Қай қателік көбіне ақша жинауға кедергі жасайды?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Тұрақты тәртіп",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Жоспар мен жүйенің болмауы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Мақсаттың болуы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Шығындарды бақылау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қандай әрекеттер жинаққа зиян келтіреді?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Тек қалған ақшаны жинау",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ойланбай шығын жасау",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Себепсіз айларды өткізіп жіберу",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Табыстың бір бөлігін автоматты аудару",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Үлкен жалақыны күтудің орнына не істеген дұрыс?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Қазірден аз сомадан бастау",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Мүлде жинамау",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Несие алу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Барлық табысты жұмсау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен жинақ прогресін бақылау маңызды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Мотивация мен тәртіпті сақтайды",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Жалақыны азайтады",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Қарыз тудырады",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Пайдасыз",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Кішкентай әдет қателіктері де жинақтың өсуіне кедергі болуы мүмкін.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Дұрыс",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қате",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Тек бай адамдарда",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек шығыны көп адамдарда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]$json$::jsonb);

drop function seed_assessment_quizzes(varchar, jsonb);

commit;
