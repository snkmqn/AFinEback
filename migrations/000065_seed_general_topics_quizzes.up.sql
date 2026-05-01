begin;

create or replace function seed_topic_final_quizzes(
    p_language_code varchar,
    p_reset_questions boolean,
    p_data jsonb
)
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
            if not exists (select 1 from topics where code = quiz_item ->> 'topic_code') then
                raise exception 'TOPIC_NOT_FOUND: %', quiz_item ->> 'topic_code';
            end if;

            insert into quizzes (subtopic_code, topic_code, quiz_type, passing_score, is_active)
            values (
                       null,
                       quiz_item ->> 'topic_code',
                       'topic_final_quiz',
                       coalesce((quiz_item ->> 'passing_score')::int, 70),
                       true
                   )
            on conflict (topic_code) where quiz_type = 'topic_final_quiz' do update
            set passing_score = excluded.passing_score,
                is_active = excluded.is_active,
                updated_at = now()
            returning id into v_quiz_id;

            insert into quiz_translations (quiz_id, language_code, title)
            values (v_quiz_id, p_language_code, quiz_item ->> 'title')
            on conflict (quiz_id, language_code) do update
                set title = excluded.title;

            if p_reset_questions then
                delete from quiz_questions where quiz_id = v_quiz_id;
            end if;

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

select seed_topic_final_quizzes('ru', true, $json$
[
  {
    "topic_code": "budgeting",
    "title": "Квиз: Бюджетирование",
    "passing_score": 70,
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
            "option_text": "Зарплата",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Такси",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Подписка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что относится к расходам?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Еда",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Транспорт",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Премия",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Коммунальные услуги",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если расходы больше доходов, возникает дефицит бюджета.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Верно только при кредитах",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Зависит от банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие расходы обычно считаются фиксированными?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Кафе",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Развлечения",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Аренда жилья",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Такси",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие расходы относятся к переменным?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Доставка еды",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Развлечения",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Интернет",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Такси",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Мелкие ежедневные траты не влияют на бюджет.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Верно только для кофе",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Зависит только от дохода",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Сколько процентов по правилу 50/30/20 рекомендуется направлять на накопления?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "10%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "20%",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "30%",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "50%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что входит в обязательные нужды по правилу 50/30/20?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Аренда",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Еда",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Путешествия",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Коммунальные услуги",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Даже небольшие накопления повышают финансовую устойчивость.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Только при высоком доходе",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при отсутствии расходов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что нужно сделать в первую очередь при дефиците бюджета?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Игнорировать проблему",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Увеличить случайные покупки",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Проанализировать и сократить переменные расходы",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Перестать учитывать деньги",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "savings",
    "title": "Квиз: Сбережения",
    "passing_score": 70,
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
            "option_text": "Кредитные средства",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Обязательные расходы",
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
            "option_text": "Достижение финансовых целей",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Увеличение долгов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Снижение стресса",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Финансовая подушка создаётся для спонтанных покупок.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Только для крупных покупок",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только для отдыха",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какой минимальный размер финансовой подушки часто рекомендуют?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Расходы за 1 месяц",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Расходы за 3 месяца",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Расходы за 10 месяцев",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Один доход",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что помогает начать откладывать деньги?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Регулярность",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Фиксированный процент от дохода",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тратить сначала всё",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Хранить отдельно",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Откладывать деньги можно только при высоком доходе.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Верно только при кредите",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Зависит только от банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что показывает процент на накопления?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Размер коммунальных услуг",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Дополнительный доход от суммы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Размер кредита",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Штраф банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие ошибки мешают накоплениям?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Отсутствие цели",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Нерегулярные отчисления",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Регулярность",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Трата накоплений на повседневные нужды",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Даже небольшие регулярные суммы могут вырасти со временем.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Только при высокой зарплате",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при кредите",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что важнее при накоплении?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Случайные большие суммы",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Регулярность и дисциплина",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Постоянные траты",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Игнорирование цели",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "credit_and_debt",
    "title": "Квиз: Кредиты и долги",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Что такое кредит?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Безвозмездная помощь",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Деньги во временное пользование с обязательством возврата",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Подарок от банка",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Вклад в банк",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что обычно включает кредит?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Срок возврата",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Процентную ставку",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "График платежей",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Бесплатное списание долга",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Процентная ставка влияет на стоимость кредита.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Только при депозите",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при наличных",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что показывает переплата по кредиту?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Размер зарплаты",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Разницу между полученной суммой и общей суммой возврата",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Количество кредитов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Сумму накоплений",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "От чего зависит переплата по кредиту?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Процентная ставка",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Срок кредита",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Комиссии",
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
        "question_text": "Чем длиннее срок кредита, тем переплата обычно ниже.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Только при нулевой ставке",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Зависит от цвета карты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что такое кредитная нагрузка?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Количество банковских приложений",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Доля дохода, уходящая на платежи по кредитам",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Размер вклада",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Сумма наличных денег",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что важно учитывать при выборе кредита?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "ГЭСВ",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Срок кредита",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Комиссии",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Только рекламу банка",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Низкий ежемесячный платеж всегда означает самый выгодный кредит.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Верно только при большом сроке",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Зависит только от рекламы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что стоит сделать перед оформлением нового кредита?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Оценить текущую кредитную нагрузку",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Игнорировать доходы",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Взять максимальную сумму",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Не читать условия",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "financial_planning",
    "title": "Квиз: Финансовое планирование",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Что является финансовой целью?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Потратить всю зарплату",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Накопить 1 000 000 ₸ на первоначальный взнос",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Не учитывать расходы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Покупать всё сразу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какими признаками должна обладать хорошая финансовая цель?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Конкретность",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Измеримость",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Срок достижения",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Полная неопределённость",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Без чёткой цели финансовые действия часто становятся хаотичными.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Только при высоком доходе",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при кредитах",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какая цель относится к краткосрочным?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Пенсионные накопления",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Покупка недвижимости через 5 лет",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Накопить на отпуск за 6 месяцев",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Создание инвестиционного капитала на 10 лет",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что относится к обязательным расходам?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Аренда",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Продукты",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Транспорт",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Импульсные покупки",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Сначала разумно покрыть обязательные расходы, затем накопления, потом личные траты.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Только при отсутствии целей",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при высоком доходе",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Как рассчитывается ежемесячный взнос в плане накопления?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Доход × 2",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Сумма цели / количество месяцев",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Расходы / 12",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Любая случайная сумма",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что можно сделать, если план накопления нереалистичен?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Увеличить срок",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Сократить цель",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Пересмотреть расходы",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Игнорировать проблему",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Регулярный контроль прогресса повышает шанс достижения цели.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Только для краткосрочных целей",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при отсутствии расходов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если накоплено меньше плана, что лучше сделать?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Игнорировать отклонение",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Скорректировать план или действия",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Полностью отказаться от цели",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Взять кредит без анализа",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "investments",
    "title": "Квиз: Инвестиции",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Что такое инвестиции?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Хранение денег без цели",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Вложение капитала для дохода или роста стоимости",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Только траты на покупки",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Краткосрочный займ",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие характеристики относятся к инвестициям?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Доходность",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Риск",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Ликвидность",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Гарантированная прибыль всегда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Высокая доходность без риска обычно не существует.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Только для акций",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только для депозитов",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что означает диверсификация?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Вложить всё в один актив",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Распределить капитал между разными активами",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Хранить деньги дома",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Покупать только валюту",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "По каким направлениям можно диверсифицировать портфель?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "По классам активов",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "По географии",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "По валютам",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Только по названию компании",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Диверсификация полностью устраняет рыночный риск.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Только при ETF",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при депозитах",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что обычно считается более консервативным инструментом?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Акции роста",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Криптовалюта",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Государственные облигации",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Спекулятивные опционы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие ошибки часто совершают начинающие инвесторы?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Погоня за прошлой доходностью",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Отсутствие финансовой подушки",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Концентрация в одном активе",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Долгосрочное планирование",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Эмоциональная паническая продажа может навредить результату инвестора.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Только при облигациях",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при депозитах",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что важно сделать перед инвестированием?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Понять инструмент и его риски",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Следовать любому совету из соцсетей",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Вложить всё сразу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Игнорировать комиссии",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]
$json$::jsonb);

select seed_topic_final_quizzes('en', false, $json$
[
  {
    "topic_code": "budgeting",
    "title": "Quiz: Budgeting",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "What is considered income?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Rent payment",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Salary",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Taxi cost",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Subscription",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What are examples of expenses?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Food",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Transport",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Bonus",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Utility bills",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If expenses are higher than income, there is a budget deficit.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "True only with loans",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Depends on the bank",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which expense is usually fixed?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Cafe visits",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Entertainment",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Housing rent",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Taxi rides",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which expenses are variable?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Food delivery",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Entertainment",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Internet",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Taxi",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Small daily purchases do not affect the budget.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Only coffee does not matter",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Depends only on income",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "According to the 50/30/20 rule, what percentage should go to savings?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "10%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "20%",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "30%",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "50%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What belongs to essential needs in the 50/30/20 rule?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Rent",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Food",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Travel",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Utilities",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Even small savings improve financial stability.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Only with high income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only without expenses",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What should be done first when there is a budget deficit?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Ignore the issue",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Increase random spending",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Analyze and reduce variable expenses",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Stop tracking money",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "savings",
    "title": "Quiz: Savings",
    "passing_score": 70,
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
            "option_text": "Borrowed money",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Required expenses",
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
            "option_text": "Protection from emergencies",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Achieving financial goals",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Increasing debt",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Reducing stress",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "An emergency fund is meant for spontaneous purchases.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Only for large purchases",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for vacations",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What minimum emergency fund is often recommended?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "1 month of expenses",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "3 months of expenses",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "10 months of expenses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "One salary only",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What helps people start saving money?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Consistency",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Fixed percentage of income",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Spend everything first",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Keep savings separately",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "You can save money only with a high income.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "True only with a loan",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Depends only on the bank",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What does interest on savings represent?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Utility bill amount",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Additional income from money saved",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Loan payment",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Bank penalty",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which mistakes prevent successful saving?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "No clear goal",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Irregular contributions",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Consistency",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Using savings for daily spending",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Even small regular amounts can grow over time.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Only with a high salary",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with a loan",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What matters most when building savings?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Random large deposits",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Consistency and discipline",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Constant spending",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Ignoring goals",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "credit_and_debt",
    "title": "Quiz: Credits and Debt",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "What is a credit loan?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Free financial help",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Money given for temporary use with repayment obligation",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "A gift from a bank",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "A savings deposit",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What does a credit agreement usually include?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Repayment term",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Interest rate",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Payment schedule",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Automatic debt cancellation",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "The interest rate affects the total cost of a loan.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Only for deposits",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for cash",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What does loan overpayment mean?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Monthly salary",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Difference between borrowed amount and total repaid amount",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Number of loans",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Savings balance",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What factors influence overpayment?",
        "question_type": "multiple_choice",
        "order_index": 5,
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
            "option_text": "Fees and commissions",
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
        "question_text": "A longer loan term usually means lower total overpayment.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Only with a zero rate",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Depends on card color",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is credit load?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Number of banking apps",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Share of income used for loan payments",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Deposit amount",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Cash in wallet",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is important when choosing a loan?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "APR / effective annual rate",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Loan term",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Fees",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Only bank advertising",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "A low monthly payment always means the best loan option.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Only with a long term",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Depends only on advertising",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What should you do before taking a new loan?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Evaluate current credit load",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ignore income",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Borrow the maximum amount",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Skip reading terms",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "financial_planning",
    "title": "Quiz: Financial Planning",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Which example is a financial goal?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Spend the full salary",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Save 1,000,000 ₸ for a down payment",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Ignore expenses",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Buy everything immediately",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What qualities should a good financial goal have?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Specific",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Measurable",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Time-bound",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Completely unclear",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Without a clear goal, financial actions often become chaotic.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Only with high income",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with loans",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which is a short-term goal?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Retirement savings",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Buying property in 5 years",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Save for a vacation in 6 months",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Build investment capital for 10 years",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which are essential expenses?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Rent",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Groceries",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Transport",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Impulse purchases",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "A smart order is: essential expenses first, then savings, then personal spending.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Only without goals",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with high income",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "How is a monthly savings contribution usually calculated?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Income × 2",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Goal amount / number of months",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Expenses / 12",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Any random amount",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What can you do if a savings plan is unrealistic?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Extend the timeline",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Reduce the target amount",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Review expenses",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ignore the issue",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Regular progress tracking increases the chance of reaching a goal.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Only for short-term goals",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only without expenses",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If saved less than planned, what is the best next step?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Ignore the gap",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Adjust the plan or behavior",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Give up completely",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Take a loan immediately",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "investments",
    "title": "Quiz: Investments",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "What are investments?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Keeping money with no purpose",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Allocating capital to earn income or future growth",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Only spending on purchases",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "A short-term loan",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which are key characteristics of investments?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Return",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Risk",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Liquidity",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Guaranteed profit at all times",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "High return with zero risk usually does not exist.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Only for stocks",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for deposits",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What does diversification mean?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Put everything into one asset",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Spread capital across different assets",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Keep money at home",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Buy only foreign currency",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "How can a portfolio be diversified?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "By asset classes",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "By geography",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "By currencies",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Only by company name",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Diversification completely removes market risk.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Only with ETFs",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with deposits",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which is usually a more conservative investment?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Growth stocks",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Cryptocurrency",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Government bonds",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Speculative options",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which mistakes are common among beginner investors?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Chasing past returns",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "No emergency fund",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Concentrating in one asset",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Long-term planning",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Emotional panic selling can harm investment results.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Only with bonds",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with deposits",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is important before investing?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Understand the instrument and its risks",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Follow any social media tip",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Invest everything immediately",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Ignore fees",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]
$json$::jsonb);

select seed_topic_final_quizzes('kk', false, $json$
[
  {
    "topic_code": "budgeting",
    "title": "Квиз: Бюджеттеу",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Қайсысы табысқа жатады?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Пәтерақы",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Жалақы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Такси шығыны",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Жазылым",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы шығындарға жатады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Тамақ",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Көлік",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Сыйақы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Коммуналдық төлемдер",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер шығын табыстан көп болса, бюджет тапшылығы пайда болады.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Тек несие болғанда дұрыс",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Банкке байланысты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қай шығын тұрақты шығын болып саналады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Кафе",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Ойын-сауық",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Пәтерақы",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Такси",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы айнымалы шығындарға жатады?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Тамақ жеткізу",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Ойын-сауық",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Интернет",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Такси",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Күнделікті ұсақ шығындар бюджетке әсер етпейді.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Тек кофе әсер етпейді",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек табысқа байланысты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "50/30/20 ережесі бойынша қанша пайыз жинаққа бөлінеді?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "10%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "20%",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "30%",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "50%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "50/30/20 ережесі бойынша міндетті қажеттіліктерге не жатады?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Пәтерақы",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тамақ",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Саяхат",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Коммуналдық төлемдер",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Тіпті аз жинақтың өзі қаржылық тұрақтылықты арттырады.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Тек жоғары табыста",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек шығын болмаса",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бюджет тапшылығы болса, бірінші не істеу керек?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Мәселені елемеу",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Кездейсоқ шығындарды көбейту",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Айнымалы шығындарды талдап, азайту",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ақша есебін тоқтату",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "savings",
    "title": "Квиз: Жинақ",
    "passing_score": 70,
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
            "option_text": "Қарыз ақша",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Міндетті шығындар",
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
            "option_text": "Төтенше жағдайлардан қорғану",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қаржылық мақсаттарға жету",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Қарызды көбейту",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Стресті азайту",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қаржылық жастықша кездейсоқ сатып алулар үшін жасалады.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Тек ірі сатып алулар үшін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек демалыс үшін",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қаржылық жастықшаның ең аз ұсынылатын көлемі қандай?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "1 айлық шығын",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "3 айлық шығын",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "10 айлық шығын",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Бір жалақы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Ақша жинауды бастауға не көмектеседі?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Тұрақтылық",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Табыстың белгіленген пайызы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Алдымен бәрін жұмсау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Бөлек сақтау",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Ақша жинау тек жоғары табыспен ғана мүмкін.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Тек несие болса",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек банкке байланысты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жинақтағы пайыз нені көрсетеді?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Коммуналдық төлем көлемін",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Жинақтан түсетін қосымша табысты",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Несие төлемін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Банк айыппұлын",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қандай қателіктер жинақ жасауға кедергі болады?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Мақсаттың болмауы",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тұрақсыз аударымдар",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тұрақтылық",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Жинақты күнделікті шығынға жұмсау",
            "is_correct": true,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Тіпті аз тұрақты сомалар уақыт өте өседі.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Тек жоғары жалақымен",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек несие арқылы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жинақ қалыптастыруда ең маңыздысы не?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Кездейсоқ үлкен сомалар",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Тұрақтылық пен тәртіп",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Үнемі шығын жасау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Мақсатты елемеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "credit_and_debt",
    "title": "Квиз: Несиелер және қарыздар",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Несие дегеніміз не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Тегін көмек",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Уақытша пайдалануға берілетін, қайтарылуы тиіс ақша",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Банктің сыйлығы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Жинақ салымы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несие шартына әдетте не кіреді?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Қайтару мерзімі",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Пайыздық мөлшерлеме",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Төлем кестесі",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Қарызды автоматты кешіру",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Пайыздық мөлшерлеме несиенің жалпы құнына әсер етеді.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Тек депозит үшін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек қолма-қол ақша үшін",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несие бойынша артық төлем нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Айлық жалақыны",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Алынған сома мен қайтарылған жалпы соманың айырмасын",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Несие санын",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Жинақ көлемін",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Артық төлемге не әсер етеді?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Пайыздық мөлшерлеме",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Несие мерзімі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Комиссиялар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Карта түсі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несие мерзімі ұзақ болса, жалпы артық төлем әдетте азаяды.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Тек нөлдік мөлшерлемеде",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Карта түсіне байланысты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несиелік жүктеме дегеніміз не?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Банк қосымшалары саны",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Табыстың несие төлемдеріне кететін үлесі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Салым көлемі",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қолма-қол ақша",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Несие таңдағанда нені ескеру керек?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "ЖЭСМ / тиімді жылдық мөлшерлеме",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Несие мерзімі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Комиссиялар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Тек жарнаманы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Төмен айлық төлем әрқашан ең тиімді несие дегенді білдіреді.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Тек ұзақ мерзімде",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек жарнамаға байланысты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жаңа несие алмас бұрын не істеу керек?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Қазіргі несиелік жүктемені бағалау",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Табысты елемеу",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Ең көп соманы алу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Шарттарды оқымау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "financial_planning",
    "title": "Квиз: Қаржылық жоспарлау",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Қайсысы қаржылық мақсатқа жатады?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Жалақыны толық жұмсау",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Бастапқы жарнаға 1 000 000 ₸ жинау",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Шығындарды елемеу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Барлығын бірден сатып алу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жақсы қаржылық мақсат қандай болуы керек?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Нақты",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Өлшенетін",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Мерзімі бар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Белгісіз",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Нақты мақсат болмаса, қаржылық әрекеттер ретсіз болуы мүмкін.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Тек жоғары табыста",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек несие болғанда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы қысқа мерзімді мақсат?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Зейнетақы жинағы",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "5 жылдан кейін үй сатып алу",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "6 айда демалысқа ақша жинау",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "10 жылға инвестициялық капитал құру",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы міндетті шығындарға жатады?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Пәтерақы",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Азық-түлік",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Көлік",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Кездейсоқ сатып алулар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Алдымен міндетті шығындарды жабу, кейін жинақ, содан соң жеке шығындар дұрыс тәсіл.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Тек мақсат болмаса",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек жоғары табыста",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Ай сайынғы жинақ жарнасы қалай есептеледі?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Табыс × 2",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Мақсат сомасы / ай саны",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Шығындар / 12",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Кез келген кездейсоқ сома",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жинақ жоспары шынайы болмаса не істеуге болады?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Мерзімді ұзарту",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Мақсат сомасын азайту",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Шығындарды қайта қарау",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Мәселені елемеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Тұрақты прогресс бақылауы мақсатқа жету мүмкіндігін арттырады.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Тек қысқа мерзімді мақсаттар үшін",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек шығын болмаса",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жоспардан аз жинақталса, не істеген дұрыс?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Айырманы елемеу",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Жоспарды не әрекетті түзету",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Мақсаттан бас тарту",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Бірден несие алу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "topic_code": "investments",
    "title": "Квиз: Инвестициялар",
    "passing_score": 70,
    "questions": [
      {
        "question_text": "Инвестиция дегеніміз не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Мақсатсыз ақша сақтау",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Табыс немесе өсім алу үшін капитал салу",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тек сатып алуға жұмсау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Қысқа мерзімді қарыз",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Инвестицияның негізгі сипаттары қайсысы?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Табыстылық",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тәуекел",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Өтімділік",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Әрқашан кепілді пайда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жоғары табыс және нөлдік тәуекел әдетте болмайды.",
        "question_type": "true_false",
        "order_index": 3,
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
            "option_text": "Тек акцияларда",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек депозиттерде",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Диверсификация нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Барлығын бір активке салу",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Капиталды әртүрлі активтерге бөлу",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Ақшаны үйде сақтау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек валюта сатып алу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Портфельді қалай әртараптандыруға болады?",
        "question_type": "multiple_choice",
        "order_index": 5,
        "options": [
          {
            "option_text": "Актив класы бойынша",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "География бойынша",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Валюта бойынша",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Тек компания атауы бойынша",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Диверсификация нарықтық тәуекелді толық жояды.",
        "question_type": "true_false",
        "order_index": 6,
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
            "option_text": "Тек ETF арқылы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек депозиттерде",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қайсысы әдетте консервативті құрал болып саналады?",
        "question_type": "single_choice",
        "order_index": 7,
        "options": [
          {
            "option_text": "Өсу акциялары",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Криптовалюта",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Мемлекеттік облигациялар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Алыпсатарлық опциондар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бастаушы инвесторлардың жиі қателіктері қайсысы?",
        "question_type": "multiple_choice",
        "order_index": 8,
        "options": [
          {
            "option_text": "Өткен табысты қуу",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Қаржылық жастықшаның болмауы",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Бір активке шоғырлану",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ұзақ мерзімді жоспарлау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қорқынышпен паникалық сату инвестиция нәтижесіне зиян келтіруі мүмкін.",
        "question_type": "true_false",
        "order_index": 9,
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
            "option_text": "Тек облигацияларда",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек депозиттерде",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Инвестиция алдында не маңызды?",
        "question_type": "single_choice",
        "order_index": 10,
        "options": [
          {
            "option_text": "Құралды және оның тәуекелдерін түсіну",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Әлеуметтік желідегі кез келген кеңеске сену",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Барлық ақшаны бірден салу",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Комиссияларды елемеу",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  }
]
$json$::jsonb);

drop function if exists seed_topic_final_quizzes(varchar, boolean, jsonb);

commit;
