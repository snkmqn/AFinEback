ALTER TABLE user_preferred_topics
    DROP CONSTRAINT IF EXISTS user_preferred_topics_topic_code_check;

ALTER TABLE user_preferred_topics
    ADD CONSTRAINT user_preferred_topics_topic_code_check
        CHECK (
            topic_code IN (
                           'budgeting',
                           'savings',
                           'credits_and_debts',
                           'financial_planning',
                           'investing'
                )
            );