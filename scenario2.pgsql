-- Scenario 2: Tech assistant can see all the trainees of his cohort

Chis is now  Tech Assistant


DO $$

DECLARE 
    chrisVolunteerId int = 7;
    ldn8Id           int = 3;
    techAssistantId   int;
BEGIN

    DELETE FROM volunteer_role_cohort;
    DELETE FROM role;

    INSERT INTO role (name) VALUES ('TA' ) RETURNING role_id INTO techAssistantId;

    INSERT INTO volunteer_role_cohort (volunteer_id, cohort_id, role_id, is_active)
    VALUES (chrisVolunteerId, ldn8Id, techAssistantId, true);

END