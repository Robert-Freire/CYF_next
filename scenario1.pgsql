-- Scenario 1 - Tech Buddy must see only their buddies
/*
Volunteers
    Chis
    Sasha
    Ezra

Students
    Alex
    Tailor
    Robin
    Kennedy
    Akia

buddies and his trainees
    Cris	Alex
    Cris	Taylor
    Cris	Robin
    Sasha	Kennedy
    Sasha	Akia

Region 
    West Midlands

Cohort
    WM4
*/


DO $$

DECLARE 
    westMidlandsId  int;
    wm4Id           int;
    londonId        int;
    ldn8Id          int;
    pdBuddyId       int;
    techBuddyId     int;
    chrisUserId     int;
    chrisPersonId   int;
    chrisVolunteerId int;
    sashaUserId     int;
    sashaPersonId   int;
    sashaVolunteerId int;
    ezraUserId     int;
    ezraPersonId   int;
    ezraVolunteerId int;
    alexUserId     int;
    alexPersonId   int;
    alexStudentId int;
    taylorUserId     int;
    taylorPersonId   int;
    taylorStudentId int;
    robinUserId     int;
    robinPersonId   int;
    robinStudentId int;    
    kennedyUserId     int;
    kennedyPersonId   int;
    kennedyStudentId int;
    akiaUserId     int;
    akiaPersonId   int;
    akiaStudentId int;
    teshiUserId     int;
    teshiPersonId   int;
    teshiStudentId int;
BEGIN
    DELETE FROM BUDDY;
    DELETE FROM STUDENT_COHORT;
    DELETE FROM STUDENT;
    DELETE FROM VOLUNTEER;
    DELETE FROM PERSON;
    DELETE FROM public.user;
    DELETE FROM BUDDY_TYPE;
    DELETE FROM COHORT;
    DELETE FROM REGION;

    INSERT INTO region (description) VALUES ('West Midlands') RETURNING region_id INTO westMidlandsId;
    INSERT INTO cohort (region_id, description) VALUES (westMidlandsId, 'WM4') RETURNING cohort_id INTO wm4id;

    INSERT INTO region (description) VALUES ('London') RETURNING region_id INTO londonId;
    INSERT INTO cohort (region_id, description) VALUES (londonId, 'LDN8') RETURNING cohort_id INTO ldn8Id;

    INSERT INTO buddy_type (description) VALUES ('PD Buddy') RETURNING buddy_type_id INTO pdBuddyId;
    INSERT INTO buddy_type (description) VALUES ('Tech Buddy') RETURNING buddy_type_id INTO techBuddyId;

    -- VOLUNTEERS 
    -- Chris  
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO chrisUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (chrisUserId, 'Chris', westMidlandsId) RETURNING person_id INTO chrisPersonId;
    INSERT INTO volunteer(person_id) VALUES (chrisPersonId) RETURNING volunteer_id INTO chrisVolunteerId;

    -- Sasha
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO sashaUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (sashaUserId, 'Sasha', westMidlandsId) RETURNING person_id INTO sashaPersonId;
    INSERT INTO volunteer(person_id) VALUES (sashaPersonId) RETURNING volunteer_id INTO sashaVolunteerId;

    -- Ezra
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO ezraUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (ezraUserId, 'Sasha', westMidlandsId) RETURNING person_id INTO ezraPersonId;
    INSERT INTO volunteer(person_id) VALUES (ezraPersonId) RETURNING volunteer_id INTO ezraVolunteerId;

    -- STUDENTS 
    -- Alex
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO alexUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (alexUserId, 'Alex', westMidlandsId) RETURNING person_id INTO alexPersonId;
    INSERT INTO student(person_id) VALUES (alexPersonId) RETURNING student_id INTO alexStudentId;
    INSERT INTO student_cohort(student_id, cohort_id, is_active) VALUES (alexStudentId, wm4id, TRUE);

    -- Taylor
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO taylorUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (taylorUserId, 'Taylor', westMidlandsId) RETURNING person_id INTO taylorPersonId;
    INSERT INTO student(person_id) VALUES (taylorPersonId) RETURNING student_id INTO taylorStudentId;
    INSERT INTO student_cohort(student_id, cohort_id, is_active) VALUES (taylorStudentId, wm4id, TRUE);

    -- Robin
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO robinUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (robinUserId, 'Robin', westMidlandsId) RETURNING person_id INTO robinPersonId;
    INSERT INTO student(person_id) VALUES (robinPersonId) RETURNING student_id INTO robinStudentId;
    INSERT INTO student_cohort(student_id, cohort_id, is_active) VALUES (robinStudentId, wm4id, TRUE);

    -- Kennedy
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO kennedyUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (kennedyUserId, 'Kennedy', westMidlandsId) RETURNING person_id INTO kennedyPersonId;
    INSERT INTO student(person_id) VALUES (kennedyPersonId) RETURNING student_id INTO kennedyStudentId;
    INSERT INTO student_cohort(student_id, cohort_id, is_active) VALUES (kennedyStudentId, wm4id, TRUE);

    -- Akia
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO akiaUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (akiaUserId, 'Akia', westMidlandsId) RETURNING person_id INTO akiaPersonId;
    INSERT INTO student(person_id) VALUES (akiaPersonId) RETURNING student_id INTO akiaStudentId;
    INSERT INTO student_cohort(student_id, cohort_id, is_active) VALUES (akiaStudentId, wm4id, TRUE);

    -- Teshi
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO teshiUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (teshiUserId, 'Teshi', westMidlandsId) RETURNING person_id INTO teshiPersonId;
    INSERT INTO student(person_id) VALUES (akiaPersonId) RETURNING student_id INTO teshiStudentId;
    INSERT INTO student_cohort(student_id, cohort_id, is_active) VALUES (teshiStudentId, ldn8Id, TRUE);

    -- BUDDIES
    INSERT INTO BUDDY (volunteer_id, student_id, buddy_type_id) VALUES (chrisVolunteerId, alexStudentId, pdBuddyId);
    INSERT INTO BUDDY (volunteer_id, student_id, buddy_type_id) VALUES (chrisVolunteerId, taylorStudentId, pdBuddyId);
    INSERT INTO BUDDY (volunteer_id, student_id, buddy_type_id) VALUES (chrisVolunteerId, robinStudentId, pdBuddyId);
    INSERT INTO BUDDY (volunteer_id, student_id, buddy_type_id)VALUES (sashaVolunteerId, kennedyStudentId, techBuddyId);
    INSERT INTO BUDDY (volunteer_id, student_id, buddy_type_id) VALUES (sashaVolunteerId, akiaStudentId, techBuddyId);
    INSERT INTO BUDDY (volunteer_id, student_id, buddy_type_id) VALUES (chrisVolunteerId, teshiStudentId, pdBuddyId);

END$$



