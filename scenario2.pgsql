-- Scenario 2: Tech assistant can see all the trainees of his cohort
/*
Chis is now  Tech Assistant

*/
DO $$

DECLARE 
    chrisVolunteerId int = 2;
    wm4Id            int = 2;
    techAssistantId   int;
BEGIN

    DELETE FROM volunteer_role_cohort;
    DELETE FROM role;
    PERFORM  setval(pg_get_serial_sequence('role', 'role_id'), 1);
      

    INSERT INTO role (name) VALUES ('TA' ) RETURNING role_id INTO techAssistantId;

    INSERT INTO volunteer_role_cohort (volunteer_id, cohort_id, role_id, is_active)
    VALUES (chrisVolunteerId, wm4Id, techAssistantId, true);

END$$