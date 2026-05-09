begin;

create or replace function preferred_topic_code(content_topic_code varchar)
    returns varchar as $$
begin
    return case content_topic_code
               when 'credit_and_debt' then 'credits_and_debts'
               when 'investments' then 'investing'
               else content_topic_code
        end;
end;
$$ language plpgsql immutable;

commit;