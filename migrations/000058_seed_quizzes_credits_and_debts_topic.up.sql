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

select seed_assessment_quizzes('ru', $json$
[
  {
    "subtopic_code": "what_is_credit",
    "title": "Квиз: Что такое кредит",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое кредит?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Деньги, которые банк выдаёт с обязательством возврата",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Безвозмездный подарок банка",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Любой денежный перевод",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только депозитный счёт",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что обычно входит в обязательства заёмщика?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Возврат основной суммы",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Оплата процентов",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Соблюдение графика платежей",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Получение прибыли от банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему кредит может быть полезен?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Позволяет получить нужную покупку раньше",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Полностью отменяет расходы",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Всегда приносит доход",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Не требует возврата",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что произойдёт при просрочке платежа?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Могут начисляться штрафы и ухудшаться кредитная история",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Долг автоматически исчезнет",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Платеж уменьшится сам",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Банк подарит отсрочку навсегда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Кредит нужно возвращать согласно условиям договора.",
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
            "option_text": "Только крупные кредиты",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только ипотеку",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "interest_rate",
    "title": "Квиз: Процентная ставка",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что показывает процентная ставка по кредиту?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Стоимость пользования заёмными деньгами",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Количество отделений банка",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Срок жизни карты",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Размер депозита клиента",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "От чего зависит переплата по кредиту?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Ставка",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Срок кредита",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Сумма кредита",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Цвет приложения банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что обычно выгоднее при одинаковых условиях?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Более низкая ставка",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Более высокая ставка",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Скрытые комиссии",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Отсутствие договора",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему важно смотреть не только рекламу, но и условия?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Могут быть комиссии и дополнительные платежи",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Реклама всегда точнее договора",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Условия не имеют значения",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Ставка никогда не влияет",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Чем ниже ставка, тем обычно меньше переплата.",
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
            "option_text": "Только для ипотеки",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только для карт",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "credit_overpayment",
    "title": "Квиз: Переплата по кредиту",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что означает переплата по кредиту?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Сумма сверх взятого кредита",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Только первоначальный взнос",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Скидка от банка",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Возврат части долга",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что увеличивает переплату?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Высокая ставка",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Долгий срок кредита",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Дополнительные комиссии",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Быстрое досрочное погашение",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если взять 1 000 000 ₸ и вернуть 1 250 000 ₸, сколько переплата?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "100 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "200 000 ₸",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "250 000 ₸",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "1 250 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему важно считать переплату заранее?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Чтобы понять реальную стоимость кредита",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Чтобы увеличить долг",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Чтобы платить больше добровольно",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Это не имеет значения",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Переплата — это важный показатель при выборе кредита.",
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
            "option_text": "Только для крупных сумм",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "credit_load",
    "title": "Квиз: Кредитная нагрузка",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что означает кредитная нагрузка?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Доля дохода, уходящая на выплаты по долгам",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Количество банковских карт",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Размер депозита",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Стоимость телефона",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему высокая нагрузка опасна?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Сложнее покрывать повседневные расходы",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Выше риск просрочек",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Меньше возможностей копить",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Доход автоматически растёт",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если доход 400 000 ₸, а кредиты требуют 160 000 ₸ в месяц, какая доля уходит на кредиты?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "20%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "30%",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "40%",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "60%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что стоит сделать перед новым кредитом?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Оценить текущую нагрузку и бюджет",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Игнорировать существующие долги",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Взять сразу несколько кредитов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Не считать доход",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Чем ниже кредитная нагрузка, тем легче управлять бюджетом.",
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
            "option_text": "Только при ипотеке",
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
    "subtopic_code": "how_to_choose_credit",
    "title": "Квиз: Как выбрать кредит",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что важно сравнить перед оформлением кредита?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Только логотип банка",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Ставку, срок, переплату и условия",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Цвет приложения",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Количество рекламы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что поможет выбрать более безопасный кредит?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Изучение договора",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Понимание ежемесячного платежа",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Сравнение нескольких предложений",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Оформление первого попавшегося займа",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что означает доступный ежемесячный платёж?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Платёж, который не разрушает ваш бюджет",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Самый большой возможный платёж",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Платёж без договора",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Любая сумма, предложенная банком",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему нельзя брать кредит без анализа условий?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Можно столкнуться с высокой переплатой и рисками",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Потому что кредит всегда бесплатный",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Потому что банк отменит долг",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Это не влияет на финансы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Сравнение вариантов помогает принять более выгодное решение.",
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
            "option_text": "Только для ипотеки",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только для автокредита",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]
$json$::jsonb);

select seed_assessment_quizzes('en', $json$
[
  {
    "subtopic_code": "what_is_credit",
    "title": "Quiz: What Is Credit",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is credit?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Money given by a bank that must be repaid",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "A free gift from the bank",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Any money transfer",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only a deposit account",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is usually included in the borrower's obligations?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Repaying the principal amount",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Paying interest",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Following the payment schedule",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Receiving profit from the bank",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why can credit be useful?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "It allows you to get a needed purchase earlier",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "It completely removes expenses",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "It always generates income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "It never needs to be repaid",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What may happen if a payment is overdue?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Penalties may be charged and credit history may worsen",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "The debt disappears automatically",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "The payment reduces by itself",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "The bank forgives the loan forever",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Credit must be repaid according to the contract terms.",
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
            "option_text": "Only large loans",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only mortgages",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "interest_rate",
    "title": "Quiz: Interest Rate",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does a loan interest rate show?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "The cost of using borrowed money",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Number of bank branches",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Card lifetime",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Client deposit amount",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What affects total overpayment on a loan?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Interest rate",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Loan term",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Loan amount",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Bank app color",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is usually better under equal conditions?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Lower interest rate",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Higher interest rate",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Hidden fees",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "No contract",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is it important to check terms, not only advertising?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "There may be fees and extra charges",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Advertising is always more accurate than contracts",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Terms do not matter",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Interest never matters",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "The lower the rate, the smaller the overpayment is usually.",
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
            "option_text": "Only for mortgages",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for cards",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "credit_overpayment",
    "title": "Quiz: Loan Overpayment",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does loan overpayment mean?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "The amount paid above the borrowed sum",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Only the down payment",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "A discount from the bank",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Part of the debt returned to you",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What increases loan overpayment?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "High interest rate",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Long loan term",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Additional fees",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Early repayment",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If you borrow 1,000,000 ₸ and repay 1,250,000 ₸, what is the overpayment?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "100,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "200,000 ₸",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "250,000 ₸",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "1,250,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is it important to calculate overpayment in advance?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "To understand the real cost of the loan",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "To increase your debt",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "To pay more voluntarily",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "It does not matter",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Overpayment is an important factor when choosing a loan.",
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
            "option_text": "Only for business loans",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for large amounts",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "credit_load",
    "title": "Quiz: Credit Load",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does credit load mean?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "The share of income used for debt payments",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "The number of bank cards",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "The size of a deposit",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "The price of a phone",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is a high credit load risky?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "It becomes harder to cover daily expenses",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Risk of missed payments increases",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "There is less room to save money",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Income grows automatically",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If income is 400,000 ₸ and loan payments are 160,000 ₸ monthly, what share goes to loans?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "20%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "30%",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "40%",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "60%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What should you do before taking a new loan?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Evaluate your current debt load and budget",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ignore existing debts",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Take several loans at once",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Do not calculate income",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "The lower the credit load, the easier it is to manage a budget.",
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
            "option_text": "Only for mortgages",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for businesses",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "how_to_choose_credit",
    "title": "Quiz: How to Choose a Loan",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is important to compare before taking a loan?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Only the bank logo",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Rate, term, overpayment, and conditions",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "App color",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Amount of advertising",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What helps choose a safer loan?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Reading the contract carefully",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Understanding the monthly payment",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Comparing several offers",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Taking the first available loan",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What does an affordable monthly payment mean?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "A payment that does not damage your budget",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "The largest possible payment",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "A payment without a contract",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Any amount suggested by the bank",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why should you not take a loan without analyzing the terms?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "You may face high overpayment and financial risks",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Because loans are always free",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Because the bank will cancel the debt",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "It does not affect finances",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Comparing options helps make a better financial decision.",
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
            "option_text": "Only for mortgages",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for car loans",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]
$json$::jsonb);

select seed_assessment_quizzes('kk', $json$
[
  {
    "subtopic_code": "what_is_credit",
    "title": "Квиз: Несие деген не",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Несие деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Банк беретін және қайтарылуы тиіс ақша",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Банктің тегін сыйлығы",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Кез келген ақша аударымы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек депозиттік шот",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қарыз алушының міндеттеріне не кіреді?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Негізгі қарызды қайтару",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Пайыз төлеу",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Төлем кестесін сақтау",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Банктен пайда табу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен несие пайдалы болуы мүмкін?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Қажетті сатып алуды ертерек жасауға мүмкіндік береді",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Барлық шығынды жояды",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Әрқашан табыс әкеледі",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қайтаруды талап етпейді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Төлем кешіктірілсе не болуы мүмкін?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Айыппұл есептеліп, несие тарихы нашарлауы мүмкін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қарыз автоматты түрде жойылады",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Төлем өздігінен азаяды",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Банк қарызды кешіреді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несие шартқа сәйкес қайтарылуы керек.",
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
            "option_text": "Тек үлкен несиелер",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек ипотека",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "interest_rate",
    "title": "Квиз: Пайыздық мөлшерлеме",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Несие бойынша пайыздық мөлшерлеме нені көрсетеді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Қарыз ақшаны пайдаланудың құнын",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Банк бөлімшелерінің санын",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Картаның мерзімін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Клиент депозитінің көлемін",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несие бойынша артық төлем неге байланысты?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Мөлшерлемеге",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Несие мерзіміне",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Несие сомасына",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Қосымша түсіне",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бірдей шарттарда қайсысы тиімдірек?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Төмен мөлшерлеме",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Жоғары мөлшерлеме",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Жасырын комиссиялар",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Шартсыз несие",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен тек жарнамаға емес, шарттарға қарау маңызды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Қосымша төлемдер болуы мүмкін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Жарнама әрқашан дәлірек",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Шарттардың маңызы жоқ",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Пайыз әсер етпейді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Мөлшерлеме неғұрлым төмен болса, артық төлем де аз болады.",
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
            "option_text": "Тек ипотекада",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек карталарда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "credit_overpayment",
    "title": "Квиз: Несие бойынша артық төлем",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Несие бойынша артық төлем нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Алынған сомадан артық төленетін ақша",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тек алғашқы жарна",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Банк беретін жеңілдік",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қарыздың бір бөлігін қайтару",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Артық төлемді не арттырады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Жоғары мөлшерлеме",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ұзақ мерзім",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Қосымша комиссиялар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ерте өтеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "1 000 000 ₸ алып, 1 250 000 ₸ қайтарсаңыз, артық төлем қанша?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "100 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "200 000 ₸",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "250 000 ₸",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "1 250 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен артық төлемді алдын ала есептеу маңызды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Несиенің нақты құнын түсіну үшін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қарызды көбейту үшін",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Көбірек төлеу үшін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Маңызы жоқ",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Артық төлем — несие таңдауда маңызды көрсеткіш.",
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
            "option_text": "Тек бизнеске",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек үлкен сомаларға",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "credit_load",
    "title": "Квиз: Несиелік жүктеме",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Несиелік жүктеме деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Табыстың қарыз төлемдеріне кететін үлесі",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Банк карталарының саны",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Депозит көлемі",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Телефон бағасы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен жоғары жүктеме қауіпті?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Күнделікті шығындарды жабу қиындайды",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Кешіктіру қаупі өседі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Жинақтауға мүмкіндік азаяды",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Табыс автоматты өседі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер табыс 400 000 ₸, ал төлемдер 160 000 ₸ болса, қанша пайызы несиеге кетеді?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "20%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "30%",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "40%",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "60%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жаңа несие алар алдында не істеу керек?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Қазіргі жүктеме мен бюджетті бағалау",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Бар қарыздарды елемеу",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Бірнеше несие алу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Табысты есептемеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жүктеме неғұрлым төмен болса, бюджетті басқару соғұрлым оңай.",
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
            "option_text": "Тек ипотекада",
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
    "subtopic_code": "how_to_choose_credit",
    "title": "Квиз: Несиені қалай таңдау керек",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Несие рәсімдемес бұрын нені салыстыру маңызды?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Тек банк логотипін",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Мөлшерлеме, мерзім, артық төлем және шарттарды",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Қосымша түсін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Жарнама санын",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы қауіпсіз несиені таңдауға көмектеседі?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Шартты мұқият оқу",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ай сайынғы төлемді түсіну",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Бірнеше ұсынысты салыстыру",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Алғашқы кездескен несиені алу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қолжетімді ай сайынғы төлем нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Бюджетке зиян келтірмейтін төлем",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ең үлкен мүмкін төлем",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Шартсыз төлем",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Банк айтқан кез келген сома",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен шарттарды талдамай несие алуға болмайды?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Жоғары артық төлем мен тәуекелге тап болуыңыз мүмкін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Өйткені несие әрқашан тегін",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Өйткені банк қарызды кешіреді",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Бұл қаржыға әсер етпейді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Нұсқаларды салыстыру тиімді шешім қабылдауға көмектеседі.",
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
            "option_text": "Тек ипотекаға",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек автонесиеге",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]
$json$::jsonb);

drop function seed_assessment_quizzes(varchar, jsonb);

commit;
