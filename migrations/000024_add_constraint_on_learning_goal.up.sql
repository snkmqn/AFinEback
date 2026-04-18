ALTER TABLE user_learning_profiles
    DROP CONSTRAINT IF EXISTS user_learning_profiles_learning_goal_check;

ALTER TABLE user_learning_profiles
    ADD CONSTRAINT user_learning_profiles_learning_goal_check
        CHECK (
            learning_goal IN (
                              'general_improvement',
                              'saving_money',
                              'debt_management',
                              'financial_planning',
                              'increase_income',
                              'control_spending',
                              'understand_banking',
                              'start_investing',
                              'other'
                )
            );