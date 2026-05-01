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
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Most people know that money should not only be stored but also grown. However, the boundary between “saving” and “investing” remains blurred."},
               {"type": "paragraph", "text": "Savings protect against current risks — investments work for long-term capital growth."},
               {"type": "paragraph", "text": "Understanding this difference is the starting point for conscious personal financial management."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Investments are the allocation of capital into assets with the goal of generating income or increasing value in the future."},
               {"type": "paragraph", "text": "Unlike savings, which simply preserve money, investments make money work."},

               {"type": "paragraph", "text": "Key characteristics of investments:"},

               {"type": "paragraph", "text": "Time horizon:"},
               {"type": "paragraph", "text": "Investments are usually designed for a period of 1 year or more. The longer the horizon, the higher the growth potential."},

               {"type": "paragraph", "text": "Return:"},
               {"type": "paragraph", "text": "Expected returns are typically higher than inflation and bank deposits."},

               {"type": "paragraph", "text": "Risk:"},
               {"type": "paragraph", "text": "The investor consciously accepts the possibility of losing part of the capital in exchange for higher returns."},

               {"type": "paragraph", "text": "Liquidity:"},
               {"type": "paragraph", "text": "Shows how quickly an asset can be converted back into cash:"},
               {"type": "bullet_list", "items": ["stocks — high liquidity", "real estate or business — low liquidity"]},

               {"type": "paragraph", "text": "Main instruments for investors in Kazakhstan:"},

               {"type": "paragraph", "text": "Conservative instruments"},
               {"type": "bullet_list", "items": [
                 "Deposits in second-tier banks",
                 "Government securities (bonds of the Ministry of Finance of Kazakhstan)"
               ]},

               {"type": "paragraph", "text": "Market instruments"},
               {"type": "bullet_list", "items": [
                 "Stocks and bonds of companies on KASE",
                 "AIX instruments (Astana International Exchange)"
               ]},

               {"type": "paragraph", "text": "Access to international markets"},
               {"type": "bullet_list", "items": [
                 "Foreign stocks and ETFs through licensed brokers"
               ]},

               {"type": "paragraph", "text": "Collective investments"},
               {"type": "bullet_list", "items": [
                 "Mutual funds"
               ]},

               {"type": "paragraph", "text": "Long-term savings"},
               {"type": "bullet_list", "items": [
                 "Pension savings through the Unified Accumulative Pension Fund"
               ]},

               {"type": "paragraph", "text": "It is important to understand: investing is not speculation. A speculator aims to profit from short-term price fluctuations; an investor aims for fundamental growth in asset value or regular income (dividends, coupons)."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Let us consider two Kazakhstan citizens, each with 1,000,000 ₸ available:"},

               {
                 "type": "table",
                 "headers": ["Instrument", "Amount", "Rate / Return", "Income per year"],
                 "rows": [
                   ["Savings account (Alibek)", "1 000 000 ₸", "9%", "90 000 ₸"],
                   ["Deposit (Zhanar)", "500 000 ₸", "9%", "45 000 ₸"],
                   ["Government bonds (Zhanar)", "300 000 ₸", "12%", "36 000 ₸"],
                   ["KMG stocks (Zhanar)", "200 000 ₸", "~15% (dividends + growth)", "~30 000 ₸"],
                   ["TOTAL Zhanar", "1 000 000 ₸", "~11.1% effective", "~111 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Zhanar’s diversified approach generates 21,000 ₸ more with the same investment — even without accounting for compound interest."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'what_are_investments'))
                 and order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Investing is a conscious choice between consumption today and financial growth tomorrow."},
               {"type": "paragraph", "text": "The Kazakhstan market offers sufficient instruments to get started: from conservative government bonds to shares of national companies."},
               {"type": "paragraph", "text": "The key is to understand the nature of each instrument before investing money."}
             ]
           }'::jsonb
       );

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
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Beginner investors often look for instruments with “high returns without risk.” In practice, this does not exist."},
               {"type": "paragraph", "text": "Risk and return are two sides of the same coin. Understanding their relationship is a fundamental skill for any investor."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Return is the increase in the value of an investment over a certain period, expressed as a percentage. It includes:"},
               {"type": "bullet_list", "items": [
                 "Capital gain: increase in the market price of an asset",
                 "Current income: dividends, coupon payments, rental income"
               ]},

               {"type": "paragraph", "text": "Risk in investing is the probability that the actual return will be lower than expected, up to a complete loss of the investment."},

               {"type": "paragraph", "text": "Main types of investment risk:"},
               {"type": "bullet_list", "items": [
                 "Market risk: price fluctuations of assets due to overall economic conditions",
                 "Credit risk: default of the issuer (company or government fails to repay debt)",
                 "Currency risk: exchange rate changes affect the value of foreign assets",
                 "Inflation risk: returns do not cover inflation, real purchasing power decreases",
                 "Liquidity risk: inability to quickly sell an asset at a fair price",
                 "Concentration risk: excessive share of a single asset or sector in a portfolio"
               ]},

               {"type": "paragraph", "text": "Risk/return scale (from low to high):"},
               {"type": "paragraph", "text": "The higher the potential return — the higher the risk"},

               {"type": "paragraph", "text": "Low risk"},
               {"type": "paragraph", "text": "Deposits (Kazakhstan Deposit Guarantee Fund) — bank deposits in tenge with a state guarantee of return within the established limit"},
               {"type": "paragraph", "text": "→ Government bonds of Kazakhstan — considered reliable because they are backed by the state"},

               {"type": "paragraph", "text": "Medium risk"},
               {"type": "paragraph", "text": "→ Corporate bonds — debt securities of companies that provide fixed income but depend on the financial condition of the issuer"},
               {"type": "paragraph", "text": "→ KASE stocks — shares of Kazakh companies, income is generated through price growth and dividends, value may fluctuate"},

               {"type": "paragraph", "text": "High risk"},
               {"type": "paragraph", "text": "→ Growth stocks (international markets) — shares of companies with high growth potential but high volatility"},
               {"type": "paragraph", "text": "→ Cryptocurrencies and derivatives — high-risk assets with unpredictable fluctuations"},

               {"type": "paragraph", "text": "Kazakhstan-specific risk factors:"},
               {"type": "bullet_list", "items": [
                 "Tenge currency risk",
                 "Dependence on oil prices",
                 "Regulatory changes"
               ]}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Three investors invested 2,000,000 ₸ each over a 3-year horizon:"},

               {
                 "type": "table",
                 "headers": ["Investor", "Instrument", "Expected return", "Actual scenario", "Result"],
                 "rows": [
                   ["Nurlan", "Deposit", "10% annually", "Guaranteed", "2 662 000 ₸"],
                   ["Aigerim", "Bonds", "13% annually", "No default", "2 878 000 ₸"],
                   ["Damir", "Stocks", "20% expected", "Market drop –15% in year 2", "2 204 000 ₸"]
                 ]
               },

               {"type": "paragraph", "text": "Damir took the highest risk and got the worst result in the short term."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "type": "scenario_selector",
             "instruction": "You are presented with three investors. Each has a different situation. Determine which level of risk is suitable for each: low, moderate, or high.",
             "scenarios": [
               {
                 "text": "Aruzhan, 58 years old. Retiring in 4 years. Savings are the main source of retirement income. Not willing to tolerate a drawdown of more than 10%.",
                 "correct_answer": "Low risk",
                 "explanation": "Short horizon and dependence on savings make high risk unacceptable."
               },
               {
                 "text": "Marat, 34 years old. Stable income, has a 6-month emergency fund. Investing for 10–15 years.",
                 "correct_answer": "Moderate risk",
                 "explanation": "Long horizon allows a balanced portfolio."
               },
               {
                 "text": "Timur, 26 years old. Works in IT, high income.",
                 "correct_answer": "High risk",
                 "explanation": "Long horizon and ability to tolerate losses."
               }
             ],
             "options": ["Low risk", "Moderate risk", "High risk"]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'risk_and_return'))
                 and order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "There is no instrument with high return and zero risk."},
               {"type": "paragraph", "text": "The investor’s task is to choose a level of risk that matches their goals."}
             ]
           }'::jsonb
       );

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
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "“Do not put all your eggs in one basket” is perhaps the most famous rule in investing."},
               {"type": "paragraph", "text": "Behind this simple metaphor lies one of the few strategies that reduces risk without proportionally reducing return."},
               {"type": "paragraph", "text": "Diversification is not just “buying different assets”. It is a principle based on how different investments behave under different conditions."}
             ]
           }'::jsonb
       );


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
           'en',
           'Explanation',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Diversification is the allocation of capital across assets whose returns do not move in the same way. When one asset declines, another may rise or remain stable."},
               {"type": "paragraph", "text": "This happens because assets react to different factors:"},

               {"type": "bullet_list", "items": [
                 "stocks depend on the economy and business performance",
                 "bonds depend on interest rates",
                 "gold depends on crises and inflation"
               ]},

               {"type": "paragraph", "text": "Levels of diversification:"},
               {"type": "bullet_list", "items": [
                 "By asset classes: stocks, bonds, deposits, real estate, precious metals",
                 "By geography: Kazakhstan market, developed markets (USA, Europe), emerging markets",
                 "By sectors: oil and gas, banking, retail, telecom, mining",
                 "By currencies: tenge-denominated and dollar-denominated instruments, assets in euros",
                 "By time horizon: short-term, medium-term, long-term"
               ]},

               {"type": "paragraph", "text": "What diversification does NOT eliminate:"},
               {"type": "bullet_list", "items": [
                 "Systematic (market) risk",
                 "Country-level currency risk"
               ]},

               {"type": "paragraph", "text": "Kazakhstan’s economy has historically been heavily dependent on the oil sector."},
               {"type": "paragraph", "text": "True diversification includes international markets through ETFs."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Two portfolios of 3,000,000 ₸:"},

               {
                 "type": "table",
                 "headers": ["Position", "Concentrated portfolio", "Diversified portfolio"],
                 "rows": [
                   ["KMG", "1 500 000 ₸ (50%)", "600 000 ₸ (20%)"],
                   ["Kaspi.kz", "900 000 ₸ (30%)", "600 000 ₸ (20%)"],
                   ["Halyk Bank", "600 000 ₸ (20%)", "450 000 ₸ (15%)"],
                   ["Government bonds", "—", "600 000 ₸ (20%)"],
                   ["ETF", "—", "450 000 ₸ (15%)"],
                   ["Gold", "—", "300 000 ₸ (10%)"],
                   ["Result", "-27%", "-9%"]
                 ]
               }
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "type": "portfolio_choice",
             "instruction": "You are presented with 3 investment portfolio options. Choose the one that is better diversified.",
             "options": [
               {
                 "name": "Concentrated portfolio",
                 "data": ["Deposit 10%", "Government bonds 10%", "Stocks 70%"]
               },
               {
                 "name": "Balanced portfolio",
                 "data": ["Deposit 20%", "Government bonds 20%", "Stocks 20%", "ETF 25%", "Gold 15%"]
               },
               {
                 "name": "Limited portfolio",
                 "data": ["Deposit 60%", "Government bonds 20%", "Stocks 20%"]
               }
             ],
             "correct": "Balanced portfolio"
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'diversification'))
                 and order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Diversification is the only free lunch in investing."},
               {"type": "paragraph", "text": "A good portfolio should not depend on a single asset."}
             ]
           }'::jsonb
       );

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
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Before moving to complex structured products, derivatives, and alternative assets, it is important to understand the basic instruments. This is the foundation of any investment portfolio."},
               {"type": "paragraph", "text": "Deposits, bonds, and stocks are three key instruments used by most investors. Their mechanics, risk levels, returns, and taxation differ significantly."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [

               {"type": "paragraph", "text": "DEPOSITS"},
               {"type": "paragraph", "text": "A bank deposit is a debt obligation of the bank to the depositor. The bank takes the money, uses it for lending, and returns it with interest."},

               {"type": "paragraph", "text": "Key parameters for a Kazakhstan investor:"},
               {"type": "bullet_list", "items": [
                 "KDGF guarantee: up to 20,000,000 ₸ in tenge, up to 5,000,000 ₸ in foreign currency",
                 "Rates are linked to the base rate of the National Bank",
                 "Interest income is exempt from personal income tax",
                 "Risk is practically zero"
               ]},

               {"type": "paragraph", "text": "BONDS"},
               {"type": "paragraph", "text": "A bond is a debt security. The investor becomes a creditor of the issuer."},

               {"type": "bullet_list", "items": [
                 "Face value",
                 "Coupon",
                 "Maturity",
                 "Market price"
               ]},

               {"type": "paragraph", "text": "Kazakhstan bond market:"},
               {"type": "bullet_list", "items": [
                 "Government bonds — most reliable",
                 "Corporate bonds — higher return and risk",
                 "Eurobonds — currency protection"
               ]},

               {"type": "paragraph", "text": "STOCKS"},
               {"type": "paragraph", "text": "A stock is an equity security. The investor becomes a co-owner of the business."},

               {"type": "bullet_list", "items": [
                 "Dividend yield",
                 "Capital appreciation"
               ]},

               {"type": "paragraph", "text": "Kazakhstan stocks:"},
               {"type": "bullet_list", "items": [
                 "Kaspi.kz",
                 "Halyk Bank",
                 "KazMunayGas",
                 "Kazatomprom",
                 "KEGOC"
               ]},

               {"type": "paragraph", "text": "Taxation:"},
               {"type": "bullet_list", "items": [
                 "Dividends may be exempt from personal income tax",
                 "Capital gains are taxed at 10%",
                 "Coupon income is taxed at 10%"
               ]}
             ]
           }'::jsonb
       );

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
           'en',
           'Example',
           '{
             "blocks": [
               {"type": "paragraph", "text": "An investor allocates 1,500,000 ₸:"},

               {
                 "type": "table",
                 "headers": ["Instrument", "Amount", "Return", "Income", "Tax", "Net income"],
                 "rows": [
                   ["Halyk deposit", "500 000 ₸", "15%", "75 000 ₸", "0 ₸", "75 000 ₸"],
                   ["Government bonds", "500 000 ₸", "12%", "60 000 ₸", "0 ₸", "60 000 ₸"],
                   ["Kaspi.kz stocks", "500 000 ₸", "8%", "40 000 ₸", "0 ₸", "40 000 ₸"]
                 ]
               }
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'simple_instruments'))
                 and order_index = 4
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "A deposit provides protection and liquidity."},
               {"type": "paragraph", "text": "Bonds provide stable income."},
               {"type": "paragraph", "text": "Stocks provide long-term growth."},
               {"type": "paragraph", "text": "Understanding these instruments is the foundation of investing."}
             ]
           }'::jsonb
       );

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
           'en',
           'Introduction',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Most investment mistakes are not caused by a lack of analytical data — they are behavioral. Cognitive biases, emotional decisions, and systematic misconceptions destroy portfolio returns even when the instruments are chosen correctly."},
               {"type": "paragraph", "text": "Studying typical mistakes is one of the most effective ways to improve investment results."}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 2
           ),
           'en',
           'Explanation',
           '{
             "blocks": [

               {"type": "paragraph", "text": "MISTAKE 1: Lack of an emergency fund before investing"},
               {"type": "paragraph", "text": "Investing without a reserve fund exposes the investor to forced selling of assets at the worst possible moment. Unexpected expenses may force liquidation during market downturns."},
               {"type": "paragraph", "text": "Rule: build a liquid reserve covering 3–6 months of expenses before investing."},

               {"type": "paragraph", "text": "MISTAKE 2: Chasing returns"},
               {"type": "paragraph", "text": "Investors often buy assets that have already risen and sell those that have fallen."},

               {"type": "paragraph", "text": "MISTAKE 3: Lack of understanding of the instrument"},
               {"type": "paragraph", "text": "Buying an asset without understanding its mechanics is dangerous."},

               {"type": "paragraph", "text": "MISTAKE 4: Ignoring fees and taxes"},

               {"type": "paragraph", "text": "MISTAKE 5: Panic selling during volatility"},

               {"type": "paragraph", "text": "MISTAKE 6: Concentration in a single asset"},

               {"type": "paragraph", "text": "MISTAKE 7: Trust in guaranteed high returns"}
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 3
           ),
           'en',
           'Example',
           '{
             "blocks": [
               {
                 "type": "table",
                 "headers": ["Scenario", "Behavior", "Result after 5 years", "Losses from mistakes"],
                 "rows": [
                   ["Disciplined investor", "Regular contributions, no panic, rebalancing", "~3 500 000 ₸", "—"],
                   ["Panic investor", "Sold during a –25% drawdown, re-entered after recovery", "~2 600 000 ₸", "–900 000 ₸"],
                   ["Pyramid scheme investor", "Invested 1 000 000 ₸ in a scheme promising 40%", "~1 200 000 ₸ remaining", "–800 000 ₸+"]
                 ]
               }
             ]
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 4
           ),
           'en',
           'Interactive',
           '{
             "type": "error_detector",
             "instruction": "Read each scenario and determine which mistake the investor is making. Choose the correct answer from the options provided.",

             "cases": [
               {
                 "text": "Bolat saw that Kazatomprom shares increased by 70% over the past year. He sold his deposit and invested all his savings in these shares, expecting the same growth next year.",
                 "options": [
                   "A) Lack of emergency fund",
                   "B) Chasing past returns and concentration in one asset",
                   "C) Ignoring fees",
                   "D) Panic selling"
                 ],
                 "correct": "B",
                 "explanation": "Past performance does not guarantee future returns. Bolat makes two mistakes: chasing growth and concentrating all capital in one asset."
               },
               {
                 "text": "Dinara found a company on Instagram promising 35% annual returns with a “guarantee.” The company is not listed on the National Bank website. She decides to invest 500,000 ₸.",
                 "options": [
                   "A) Emotional decision",
                   "B) Lack of understanding",
                   "C) Pyramid scheme signs and lack of license",
                   "D) Ignoring taxes"
                 ],
                 "correct": "C",
                 "explanation": "Guaranteed high returns + no license + social proof are classic signs of a financial pyramid."
               }
             ],

             "final_explanation": "Most investment losses are caused not by poor asset selection but by behavioral mistakes."
           }'::jsonb
       );

insert into lesson_step_translations (lesson_step_id, language_code, title, content)
values (
           (
               select id from lesson_steps
               where lesson_id = (select id from lessons where subtopic_id = (select id from subtopics where code = 'beginner_mistakes'))
                 and order_index = 5
           ),
           'en',
           'Conclusion',
           '{
             "blocks": [
               {"type": "paragraph", "text": "Investment success depends on investor behavior."},
               {"type": "paragraph", "text": "Discipline is more important than choosing instruments."}
             ]
           }'::jsonb
       );

commit;