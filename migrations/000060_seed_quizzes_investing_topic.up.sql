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
    "subtopic_code": "what_are_investments",
    "title": "Квиз: Что такое инвестиции",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое инвестиции?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Любая покупка в магазине",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Вложение денег с целью получения дохода в будущем",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Только хранение наличных дома",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Любой банковский кредит",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Во что можно инвестировать?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Акции",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Облигации",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Фонды",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Штрафы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Чем инвестиции отличаются от обычных сбережений?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Инвестиции направлены на рост капитала и могут иметь риск",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Инвестиции всегда без риска",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Сбережения всегда приносят высокий доход",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Разницы нет",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если вложить 100 000 ₸ и получить доход 10%, сколько станет через период без учета комиссий?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "105 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "110 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "120 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "100 100 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Инвестиции обычно рассматриваются как способ увеличения капитала в долгосрочном периоде.",
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
            "option_text": "Только за один день",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только для компаний",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_risk_and_return",
    "title": "Квиз: Риск и доходность",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что означает риск в инвестициях?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Вероятность отклонения результата и возможных потерь",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Гарантированный доход",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Комиссия брокера",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только рост цены",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что часто связано с более высокой потенциальной доходностью?",
        "question_type": "single_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Более высокий риск",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Полное отсутствие риска",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Отсутствие срока вложений",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Случайные решения",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие факторы влияют на риск инвестиций?",
        "question_type": "multiple_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Волатильность рынка",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Срок инвестирования",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Качество актива",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Цвет приложения",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если актив упал со 100 000 ₸ до 90 000 ₸, какова убыль?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "5%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "10%",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "15%",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "20%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Высокая доходность в прошлом не гарантирует такую же доходность в будущем.",
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
            "option_text": "Только для депозитов",
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
    "subtopic_code": "investments_diversification",
    "title": "Квиз: Диверсификация",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Что такое диверсификация?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Распределение средств между разными активами",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Вложение всех денег в один актив",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Отказ от инвестиций",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Покупка только валюты",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Зачем инвестору диверсификация?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Снижение концентрации риска",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Более устойчивый портфель",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Снижение зависимости от одного актива",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Гарантия прибыли каждый день",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какой портфель более диверсифицирован?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "100% в одной акции",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Средства распределены между акциями, облигациями и фондом",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Все деньги в наличных дома",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Все деньги в одном стартапе",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если портфель состоит из 50% акций и 50% облигаций, сколько из 200 000 ₸ вложено в облигации?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "50 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "100 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "150 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "200 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Диверсификация снижает риск, но не устраняет его полностью.",
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
            "option_text": "Только на короткий срок",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_simple_instruments",
    "title": "Квиз: Простые инвестиционные инструменты",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Какой инструмент обычно считается более консервативным?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Облигации высокого качества",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Спекулятивные акции",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Случайные мем-активы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Непроверенные схемы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие инструменты доступны начинающему инвестору?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "ETF/фонды",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Акции",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Облигации",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Финансовые пирамиды",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Что обычно дает долю в компании?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Акция",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Облигация",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Штраф",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Квитанция",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если облигация приносит 8% годовых на 100 000 ₸, какой простой доход за год?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "5 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "8 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "10 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "18 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Перед выбором инструмента важно понимать его риск, доходность и назначение.",
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
            "option_text": "Только для профессионалов",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при крупной сумме",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_beginner_mistakes",
    "title": "Квиз: Ошибки начинающих инвесторов",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Какая ошибка распространена у начинающих инвесторов?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Инвестировать без понимания инструмента",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Изучать риски заранее",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Диверсифицировать портфель",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Планировать горизонт инвестиций",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Какие действия считаются ошибочными?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Паническая продажа при падении рынка",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Вложение всех денег в один актив",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Следование слухам без анализа",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Постепенное обучение",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Почему опасно инвестировать последние деньги без резерва?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Можно столкнуться с нехваткой средств при срочной необходимости",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Это всегда дает высокий доход",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Это снижает риск до нуля",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Так советуют все инвесторы",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Если инвестор вложил 100% капитала в один актив, какой риск особенно высок?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Риск концентрации",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Отсутствие дохода навсегда",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Нулевой риск",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Риск отсутствует",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Эмоциональные решения часто вредят долгосрочному инвестированию.",
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
            "option_text": "Только для крупных компаний",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Только при росте рынка",
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
    "subtopic_code": "what_are_investments",
    "title": "Quiz: What Are Investments",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What are investments?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Any purchase in a store",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Placing money with the goal of earning income in the future",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Only keeping cash at home",
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
        "question_text": "What can people invest in?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Stocks",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Bonds",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Funds",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Fines",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "How do investments differ from regular savings?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Investments aim to grow capital and may involve risk",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Investments are always risk-free",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Savings always provide high returns",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "There is no difference",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If you invest 100,000 ₸ and earn 10%, how much will you have after the period excluding fees?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "105,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "110,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "120,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "100,100 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Investments are usually viewed as a way to grow wealth over the long term.",
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
            "option_text": "Only in one day",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only for companies",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_risk_and_return",
    "title": "Quiz: Risk and Return",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What does risk mean in investing?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "The possibility of different outcomes and potential losses",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Guaranteed profit",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Broker commission",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only price growth",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What is often associated with higher potential returns?",
        "question_type": "single_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Higher risk",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "No risk at all",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "No investment period",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Random decisions",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which factors affect investment risk?",
        "question_type": "multiple_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Market volatility",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Investment time horizon",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Asset quality",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "App color",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If an asset falls from 100,000 ₸ to 90,000 ₸, what is the loss?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "5%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "10%",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "15%",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "20%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "High returns in the past do not guarantee the same returns in the future.",
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
            "option_text": "Only for deposits",
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
    "subtopic_code": "investments_diversification",
    "title": "Quiz: Diversification",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "What is diversification?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Spreading money across different assets",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Putting all money into one asset",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Refusing to invest",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Buying only currency",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why does an investor use diversification?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Reduce concentration risk",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Build a more stable portfolio",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Reduce dependence on one asset",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Guarantee profit every day",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which portfolio is more diversified?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "100% in one stock",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Money split between stocks, bonds, and a fund",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "All money in cash at home",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "All money in one startup",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If a portfolio has 50% stocks and 50% bonds, how much of 200,000 ₸ is invested in bonds?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "50,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "100,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "150,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "200,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Diversification reduces risk but does not eliminate it completely.",
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
            "option_text": "Only for short periods",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_simple_instruments",
    "title": "Quiz: Simple Investment Instruments",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Which instrument is usually considered more conservative?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "High-quality bonds",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Speculative stocks",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Random meme assets",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Unverified schemes",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which instruments are available to a beginner investor?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "ETF/Funds",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Stocks",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Bonds",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Ponzi schemes",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "What usually gives ownership in a company?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "A stock",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "A bond",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "A fine",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "A receipt",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If a bond yields 8% annually on 100,000 ₸, what is the simple yearly income?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "5,000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "8,000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "10,000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "18,000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Before choosing an instrument, it is important to understand its risk, return, and purpose.",
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
            "option_text": "Only for professionals",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only with large amounts",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_beginner_mistakes",
    "title": "Quiz: Beginner Investor Mistakes",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Which mistake is common among beginner investors?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Investing without understanding the instrument",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Studying risks in advance",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Diversifying a portfolio",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Planning the investment horizon",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Which actions are considered mistakes?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Panic selling during a market drop",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Putting all money into one asset",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Following rumors without analysis",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Learning gradually",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Why is it risky to invest your last money without a reserve fund?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "You may face a shortage of money in an urgent situation",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "It always gives high returns",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "It reduces risk to zero",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "All investors recommend it",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "If an investor puts 100% of capital into one asset, which risk is especially high?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Concentration risk",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "No income forever",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Zero risk",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "There is no risk",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Emotional decisions often harm long-term investing.",
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
            "option_text": "Only for large companies",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Only when markets rise",
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
    "subtopic_code": "what_are_investments",
    "title": "Квиз: Инвестиция деген не",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Инвестиция деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Дүкендегі кез келген сатып алу",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Болашақта табыс алу мақсатында ақша салу",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Тек қолма-қол ақшаны үйде сақтау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Кез келген банк несиесі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Неге инвестиция салуға болады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Акциялар",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Облигациялар",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Қорлар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Айыппұлдар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Инвестиция қарапайым жинақтан несімен ерекшеленеді?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Инвестиция капиталды өсіруге бағытталады және тәуекелі болуы мүмкін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Инвестиция әрқашан тәуекелсіз болады",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Жинақ әрқашан жоғары табыс әкеледі",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Айырмашылық жоқ",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер 100 000 ₸ салып, 10% табыс алсаңыз, комиссияларды есептемегенде кезең соңында қанша болады?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "105 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "110 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "120 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "100 100 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Инвестициялар әдетте капиталды ұзақ мерзімде көбейту тәсілі ретінде қарастырылады.",
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
            "option_text": "Тек бір күнге",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек компанияларға",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_risk_and_return",
    "title": "Квиз: Тәуекел және табыстылық",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Инвестициядағы тәуекел нені білдіреді?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Нәтиженің өзгеруі және ықтимал шығындар мүмкіндігі",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Кепілдендірілген пайда",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Брокер комиссиясы",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек бағаның өсуі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Жоғары ықтимал табыстылық көбіне немен байланысты?",
        "question_type": "single_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Жоғары тәуекелмен",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тәуекелдің толық болмауымен",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Инвестиция мерзімінің болмауымен",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Кездейсоқ шешімдермен",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Инвестиция тәуекеліне қандай факторлар әсер етеді?",
        "question_type": "multiple_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Нарық құбылмалылығы",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Инвестициялау мерзімі",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Актив сапасы",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Қосымша түсі",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер актив 100 000 ₸-ден 90 000 ₸-ге түссе, шығын қанша?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "5%",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "10%",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "15%",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "20%",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Өткен кезеңдегі жоғары табыс болашақта дәл сондай табысқа кепілдік бермейді.",
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
            "option_text": "Тек депозиттерге",
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
    "subtopic_code": "investments_diversification",
    "title": "Квиз: Диверсификация",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Диверсификация деген не?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Қаражатты әртүрлі активтер арасында бөлу",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Барлық ақшаны бір активке салу",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Инвестициядан бас тарту",
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
        "question_text": "Инвесторға диверсификация не үшін қажет?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Тәуекелдің шоғырлануын азайту үшін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Портфельді тұрақтырақ ету үшін",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Бір активке тәуелділікті азайту үшін",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Күн сайын пайдаға кепілдік беру үшін",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қай портфель көбірек диверсификацияланған?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "100% бір акцияға салынған",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "Қаражат акциялар, облигациялар және қор арасында бөлінген",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Барлық ақша үйде қолма-қол сақталған",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Барлық ақша бір стартапқа салынған",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер портфель 50% акциялардан және 50% облигациялардан тұрса, 200 000 ₸-нің қаншасы облигацияларға салынған?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "50 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "100 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "150 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "200 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Диверсификация тәуекелді азайтады, бірақ оны толық жоймайды.",
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
            "option_text": "Тек қысқа мерзімге",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_simple_instruments",
    "title": "Квиз: Қарапайым инвестициялық құралдар",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Қай құрал әдетте консервативті болып саналады?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Сапалы облигациялар",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Спекулятивті акциялар",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Кездейсоқ мем-активтер",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тексерілмеген схемалар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Бастаушы инвесторға қандай құралдар қолжетімді?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "ETF/қорлар",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Акциялар",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Облигациялар",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Қаржылық пирамидалар",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Компаниядағы үлесті әдетте не береді?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Акция",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Облигация",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Айыппұл",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Түбіртек",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер облигация 100 000 ₸ сомасына жылына 8% табыс әкелсе, бір жылдағы қарапайым табыс қанша?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "5 000 ₸",
            "is_correct": false,
            "order_index": 1
          },
          {
            "option_text": "8 000 ₸",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "10 000 ₸",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "18 000 ₸",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Құралды таңдаудан бұрын оның тәуекелін, табыстылығын және мақсатын түсіну маңызды.",
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
            "option_text": "Тек кәсіби мамандарға",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек үлкен сома болғанда",
            "is_correct": false,
            "order_index": 4
          }
        ]
      }
    ]
  },
  {
    "subtopic_code": "investments_beginner_mistakes",
    "title": "Квиз: Бастаушы инвесторлардың қателіктері",
    "passing_score": 50,
    "questions": [
      {
        "question_text": "Бастаушы инвесторларда қандай қате жиі кездеседі?",
        "question_type": "single_choice",
        "order_index": 1,
        "options": [
          {
            "option_text": "Құралды түсінбей инвестиция салу",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Тәуекелдерді алдын ала зерттеу",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Портфельді диверсификациялау",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Инвестиция мерзімін жоспарлау",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Қандай әрекеттер қате болып саналады?",
        "question_type": "multiple_choice",
        "order_index": 2,
        "options": [
          {
            "option_text": "Нарық төмендегенде үреймен сату",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Барлық ақшаны бір активке салу",
            "is_correct": true,
            "order_index": 2
          },
          {
            "option_text": "Талдаусыз қауесеттерге еру",
            "is_correct": true,
            "order_index": 3
          },
          {
            "option_text": "Біртіндеп үйрену",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Резервсіз соңғы ақшаны инвестициялау неге қауіпті?",
        "question_type": "single_choice",
        "order_index": 3,
        "options": [
          {
            "option_text": "Шұғыл жағдайда ақша жетіспеуі мүмкін",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Бұл әрқашан жоғары табыс береді",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Бұл тәуекелді нөлге дейін азайтады",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Барлық инвесторлар осылай кеңес береді",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Егер инвестор капиталының 100%-ын бір активке салса, қандай тәуекел әсіресе жоғары?",
        "question_type": "single_choice",
        "order_index": 4,
        "options": [
          {
            "option_text": "Шоғырлану тәуекелі",
            "is_correct": true,
            "order_index": 1
          },
          {
            "option_text": "Мәңгі табыс болмауы",
            "is_correct": false,
            "order_index": 2
          },
          {
            "option_text": "Нөлдік тәуекел",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тәуекел жоқ",
            "is_correct": false,
            "order_index": 4
          }
        ]
      },
      {
        "question_text": "Эмоцияға негізделген шешімдер ұзақ мерзімді инвестициялауға жиі зиян келтіреді.",
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
            "option_text": "Тек ірі компанияларға",
            "is_correct": false,
            "order_index": 3
          },
          {
            "option_text": "Тек нарық өскенде",
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
