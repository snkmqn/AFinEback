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
    "subtopic_code": "income_expenses",
    "title": "Квиз: Доходы и расходы",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что относится к доходам?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Аренда жилья",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Коммунальные услуги",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Зарплата",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Подписка на сервис",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что относится к расходам?",
        "question_type": "single_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Премия",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Доход от сдачи жилья",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Подработка",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Транспорт",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему человеку важно знать сумму своих расходов?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Чтобы видеть реальную картину бюджета",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Чтобы полностью отказаться от всех покупок",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Чтобы не учитывать доходы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Чтобы всегда брать рассрочку",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если доход 300 000 ₸, а расходы 370 000 ₸, что происходит с бюджетом?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Появляется профицит 70 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Появляется дефицит 70 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Бюджет полностью сбалансирован",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Расходы равны доходам",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Доходы — это всё, что приходит к человеку в виде денег.",
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
            "option_text": "Верно только для зарплаты",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Верно только для переводов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "fixed_variable_expenses",
    "title": "Квиз: Фиксированные и переменные расходы",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое фиксированные расходы?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Расходы, которые каждый день меняются",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Расходы, которые повторяются каждый месяц примерно в одинаковой сумме",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Только расходы на развлечения",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только покупки через интернет",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие расходы относятся к переменным?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Такси",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Доставка еды",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Развлечения",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Аренда жилья",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему переменные расходы важны для управления бюджетом?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Их обычно невозможно изменить",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Они зависят от ежедневных решений человека",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Они всегда меньше фиксированных расходов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Они не влияют на бюджет",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какая трата чаще всего является фиксированной?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Кафе",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Спонтанная покупка",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Аренда жилья",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Развлечения",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Фиксированные расходы изменить сложнее, чем переменные.",
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
            "option_text": "Верно только для такси",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Неверно, потому что все расходы одинаковые",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "expense_accounting",
    "title": "Квиз: Учёт расходов",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Почему без учёта расходов возникает иллюзия контроля?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Потому что человек обычно помнит только крупные траты",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Потому что мелкие траты не влияют на бюджет",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Потому что доходы всегда больше расходов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Потому что расходы не нужно записывать",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие траты часто выпадают из памяти?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Кофе по дороге",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Перекус в обед",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Автоматические подписки",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Оклад за месяц",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что помогает увидеть реальные расходы?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Записывать траты в день покупки",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Помнить расходы примерно",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Не смотреть банковские приложения",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Учитывать только аренду",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если кофе стоит 1 500 ₸ в день, сколько примерно выйдет за месяц?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "15 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "30 000 ₸",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "45 000 ₸",
            "is_correct": true,
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
        "question_text": "Для учёта расходов обязательно использовать сложные финансовые инструменты.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Верно",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Неверно",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Верно только для студентов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Верно только при высоком доходе",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "budgeting_rule_50_30_20",
    "title": "Квиз: Правило 50/30/20",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что означает 50% в правиле 50/30/20?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Желания",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Накопления",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Обязательные нужды",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Инвестиции в бизнес",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что относится к желаниям в правиле 50/30/20?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Кафе",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Развлечения",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Одежда сверх необходимого",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Коммунальные услуги",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Сколько нужно отложить по правилу 50/30/20 при доходе 300 000 ₸?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "30 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "60 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "90 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "150 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Главная идея правила 50/30/20 — это:",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Полностью отказаться от желаний",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Всегда брать кредиты",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Распределять доход и регулярно откладывать часть денег",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Тратить все деньги на обязательные нужды",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Правило 50/30/20 — это ориентир, а не жёсткое правило.",
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
            "option_text": "Верно только для дохода 300 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Неверно, проценты нельзя менять",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "budget_analysis",
    "title": "Квиз: Анализ бюджета",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что является главным признаком дефицита бюджета?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Доходы превышают расходы",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Расходы превышают доходы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Есть накопления",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Нет переменных расходов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "На что важно смотреть при анализе бюджета?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Есть ли дефицит",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Доля переменных расходов",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Наличие накоплений",
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
        "question_text": "Если доход 300 000 ₸, а расходы 340 000 ₸, какая ситуация возникает?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Профицит 40 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Дефицит 40 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Накопления 40 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Баланс без дефицита",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие расходы в примере можно сократить в первую очередь?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Доставка и такси",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Аренда и коммунальные услуги",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Интернет полностью",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Все обязательные расходы сразу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бюджет — это инструмент для принятия решений, а не просто список запретов.",
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
            "option_text": "Верно только при высоком доходе",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Неверно, бюджет нужен только для ограничений",
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
    "subtopic_code": "income_expenses",
    "title": "Quiz: Income and Expenses",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Which of the following is considered income?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Housing rent payment",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Utility bills",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Salary",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Subscription service",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which of the following is an expense?",
        "question_type": "single_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Bonus",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Rental income",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Side job income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Transport",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is it important to know your total expenses?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "To see the real financial picture",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "To stop all purchases completely",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "To ignore income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "To always use installment plans",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If income is 300,000 ₸ and expenses are 370,000 ₸, what happens?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "A surplus of 70,000 ₸ appears",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "A deficit of 70,000 ₸ appears",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "The budget is perfectly balanced",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Expenses equal income",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Income is all money that comes to a person.",
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
            "option_text": "True only for salary",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "True only for transfers",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "fixed_variable_expenses",
    "title": "Quiz: Fixed and Variable Expenses",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What are fixed expenses?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Expenses that change every day",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Expenses paid monthly in a similar amount",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Only entertainment expenses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only online purchases",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which of the following are variable expenses?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Taxi",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Food delivery",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Entertainment",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Housing rent",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why are variable expenses important for budgeting?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "They usually cannot be changed",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "They depend on daily decisions",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "They are always lower than fixed expenses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "They do not affect the budget",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which expense is most often fixed?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Cafe visits",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Impulse purchase",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Housing rent",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Entertainment",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Fixed expenses are harder to reduce than variable expenses.",
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
            "option_text": "True only for taxi",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "False because all expenses are the same",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "expense_accounting",
    "title": "Quiz: Expense Tracking",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Why does the illusion of control appear without tracking expenses?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Because people usually remember only major expenses",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Because small expenses do not matter",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Because income is always higher than expenses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Because expenses do not need to be recorded",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which expenses are often forgotten?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Coffee on the way",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Lunch snack",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Automatic subscriptions",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Monthly salary",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What helps you see your real expenses?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Recording expenses on the day of purchase",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Guessing approximate amounts",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Ignoring banking apps",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Tracking rent only",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If coffee costs 1,500 ₸ per day, how much is it approximately per month?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "15,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "30,000 ₸",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "45,000 ₸",
            "is_correct": true,
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
        "question_text": "Complex financial tools are required for expense tracking.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "True",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "False",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "True only for students",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "True only for high income earners",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "budgeting_rule_50_30_20",
    "title": "Quiz: The 50/30/20 Rule",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does the 50% part of the 50/30/20 rule represent?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Wants",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Savings",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Essential needs",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Business investments",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which of the following belong to the wants category?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Cafe visits",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Entertainment",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Extra clothing",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Utility bills",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "How much should be saved from an income of 300,000 ₸ according to the rule?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "30,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "60,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "90,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "150,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is the main idea of the 50/30/20 rule?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Completely stop spending on wants",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Always use loans",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Divide income and save regularly",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Spend everything on needs",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "The 50/30/20 rule is a guideline, not a strict rule.",
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
            "option_text": "True only for 300,000 ₸ income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "False, percentages cannot change",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "budget_analysis",
    "title": "Quiz: Budget Analysis",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is the main sign of a budget deficit?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Income is higher than expenses",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Expenses are higher than income",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "There are savings",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "There are no variable expenses",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is important to review when analyzing a budget?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Whether there is a deficit",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Share of variable expenses",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Whether savings exist",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Color of the bank card",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If income is 300,000 ₸ and expenses are 340,000 ₸, what situation occurs?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "A surplus of 40,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "A deficit of 40,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Savings of 40,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Balanced budget",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which expenses can usually be reduced first?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Food delivery and taxi",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Rent and utilities",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Internet completely",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "All essential expenses immediately",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "A budget is a decision-making tool, not just a list of restrictions.",
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
            "option_text": "True only for high-income people",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "False, budgeting is only about limits",
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
    "subtopic_code": "income_expenses",
    "title": "Квиз: Кірістер мен шығыстар",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Төмендегілердің қайсысы кіріске жатады?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Тұрғын үйді жалға алу төлемі",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Коммуналдық төлемдер",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Жалақы",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Жазылым қызметі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Төмендегілердің қайсысы шығысқа жатады?",
        "question_type": "single_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Сыйақы",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Жалға беруден түсетін табыс",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Қосымша табыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Көлік шығыны",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неліктен жалпы шығын сомасын білу маңызды?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Нақты қаржылық жағдайды көру үшін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Барлық сатып алуды толық тоқтату үшін",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Кірісті елемеу үшін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Әрдайым бөліп төлеуді қолдану үшін",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер кіріс 300 000 ₸, ал шығыс 370 000 ₸ болса, не болады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "70 000 ₸ артық қалады",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "70 000 ₸ тапшылық пайда болады",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Бюджет толық теңеседі",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Шығыс кіріске тең",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Кіріс — адамға келетін барлық ақша.",
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
            "option_text": "Тек жалақыға қатысты дұрыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек аударымдарға қатысты дұрыс",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "fixed_variable_expenses",
    "title": "Квиз: Тұрақты және айнымалы шығыстар",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Тұрақты шығыстар деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Күн сайын өзгеретін шығыстар",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Ай сайын шамалас мөлшерде төленетін шығыстар",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тек ойын-сауық шығыстары",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек онлайн сатып алулар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы айнымалы шығыстарға жатады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Такси",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тағам жеткізу",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Ойын-сауық",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Тұрғын үйді жалдау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Айнымалы шығыстар неге маңызды?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Оларды өзгерту мүмкін емес",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Олар күнделікті шешімдерге байланысты",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Олар әрқашан аз болады",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Бюджетке әсер етпейді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қай шығыс көбіне тұрақты болып саналады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Кафеге бару",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Кездейсоқ сатып алу",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Тұрғын үйді жалдау",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ойын-сауық",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Тұрақты шығыстарды азайту айнымалы шығыстарға қарағанда қиынырақ.",
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
            "option_text": "Тек таксиге қатысты дұрыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қате, барлық шығыс бірдей",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "expense_accounting",
    "title": "Квиз: Шығындарды есепке алу",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Неліктен шығындарды есепке алмаса, бақылау иллюзиясы пайда болады?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Адам көбіне ірі шығындарды ғана есте сақтайды",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ұсақ шығындардың маңызы жоқ",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Кіріс әрқашан шығыстан көп болады",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Шығындарды жазудың қажеті жоқ",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қай шығындар жиі ұмытылып кетеді?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Жолай алынған кофе",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Түскі асқа жеңіл тамақ",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Автоматты жазылымдар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Айлық жалақы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Нақты шығындарды көруге не көмектеседі?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Шығындарды сатып алған күні жазу",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Шамамен болжау",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Банк қосымшаларын қарамау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек жалдау ақысын есептеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер кофе күніне 1 500 ₸ тұрса, айына шамамен қанша болады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "15 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "30 000 ₸",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "45 000 ₸",
            "is_correct": true,
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
        "question_text": "Шығындарды есепке алу үшін міндетті түрде күрделі қаржылық құралдар керек.",
        "question_type": "true_false",
        "order_index": 5,
        "options": [
          {
            "option_text": "Дұрыс",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Қате",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тек студенттерге дұрыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек жоғары табысқа дұрыс",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "budgeting_rule_50_30_20",
    "title": "Квиз: 50/30/20 ережесі",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "50/30/20 ережесіндегі 50% нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Қалаулар",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Жинақ",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Міндетті қажеттіліктер",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Бизнеске инвестиция",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы қалаулар санатына жатады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Кафеге бару",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ойын-сауық",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Артық киім сатып алу",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Коммуналдық төлемдер",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "300 000 ₸ кірістен қанша жинақтау керек?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "30 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "60 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "90 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "150 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "50/30/20 ережесінің негізгі идеясы қандай?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Қалаулардан толық бас тарту",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Әрқашан несие қолдану",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Кірісті бөліп, тұрақты түрде жинақтау",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Барлық ақшаны қажеттілікке жұмсау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "50/30/20 ережесі — қатаң заң емес, бағыт-бағдар.",
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
            "option_text": "Тек 300 000 ₸ табысқа дұрыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қате, пайыздарды өзгертуге болмайды",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "budget_analysis",
    "title": "Квиз: Бюджетті талдау",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Бюджет тапшылығының негізгі белгісі қандай?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Кіріс шығыстан көп",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Шығыс кірістен көп",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Жинақ бар",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Айнымалы шығыс жоқ",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бюджетті талдағанда неге назар аудару маңызды?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Тапшылық бар ма",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Айнымалы шығыстардың үлесі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Жинақтың болуы",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Банк картасының түсі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер кіріс 300 000 ₸, ал шығыс 340 000 ₸ болса, қандай жағдай туындайды?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "40 000 ₸ артық қалады",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "40 000 ₸ тапшылық пайда болады",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "40 000 ₸ жинақ пайда болады",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Бюджет теңеседі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қай шығыстарды әдетте бірінші қысқартуға болады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Тағам жеткізу және такси",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Жалдау ақысы мен коммуналдық төлемдер",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Интернетті толық өшіру",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Барлық міндетті шығыстарды бірден қысқарту",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бюджет — тек шектеулер тізімі емес, шешім қабылдау құралы.",
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
            "option_text": "Тек жоғары табысқа дұрыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қате, бюджет тек шектеу үшін керек",
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
