-- Scenario 3: We have a new volunteer (John) in london (it is neither a buddy nor a TA)

John is a new volunteer in London

New Trainees in London
Blake       -- Call
Brooklyn    -- Call
Cameron     -- Call
Charlie     -- Call
Emerson     -- Call
Kyle
Logan
Marion
Ryan

DO $$

DECLARE 
    johnUserId     int;
    johnPersonId   int;
    johnVolunteerId int;
    londonId        int;

    blakeUserId     int;
    blakePersonId   int;
    blakeStudentId  int;

    BrooklynUserId     int;
    BrooklynPersonId   int;
    BrooklynStudentId  int;

    cameronUserId     int;
    cameronPersonId   int;
    cameronStudentId  int;

    charlieUserId     int;
    charliePersonId   int;
    charlieStudentId  int;

    emersonUserId     int;
    emersonPersonId   int;
    emersonStudentId  int;

    kyleUserId     int;
    kylePersonId   int;
    kyleStudentId  int;

    loganUserId     int;
    loganPersonId   int;
    loganStudentId  int;

    marionUserId     int;
    marionPersonId   int;
    marionStudentId  int;

    ryanUserId     int;
    ryanPersonId   int;
    ryanStudentId  int;
BEGIN

    -- VOLUNTEERS 
    -- John  
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO johnUserId;
    INSERT INTO person(user_id, first_name, region_id) VALUES (johnUserId, 'John', westMidlandsId) RETURNING person_id INTO johnPersonId;
    INSERT INTO volunteer(person_id) VALUES (johnPersonId) RETURNING volunteer_id INTO johnVolunteerId;


    -- STUDENTS 
    -- Blake
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO blakeUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (blakeUserId, 'Blake', londonId) RETURNING person_id INTO blakePersonId;
    INSERT INTO student (person_id, call) VALUES (blakePersonId, true) RETURNING student_id INTO blakeStudentId;

    -- Brooklyn 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO brooklynUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (brooklynUserId, 'Brooklyn', londonId) RETURNING person_id INTO brooklynPersonId;
    INSERT INTO student (person_id, call) VALUES (brooklynPersonId, true) RETURNING student_id INTO brooklynStudentId;

    -- Cameron 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO cameronUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (cameronUserId, 'Cameron', londonId) RETURNING person_id INTO cameronPersonId;
    INSERT INTO student (person_id, call) VALUES (cameronPersonId, true) RETURNING student_id INTO cameronStudentId;

    -- Charlie 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO charlieUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (charlieUserId, 'Charlie', londonId) RETURNING person_id INTO charliePersonId;
    INSERT INTO student (person_id, call) VALUES (charliePersonId, true) RETURNING student_id INTO charlieStudentId;

    -- Emerson 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO emersonUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (emersonUserId, 'Emerson', londonId) RETURNING person_id INTO emersonPersonId;
    INSERT INTO student (person_id, call) VALUES (emersonPersonId, true) RETURNING student_id INTO emersonStudentId;

    -- Kyle 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO kyleUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (emersonUserId, 'Kyle', londonId) RETURNING person_id INTO kylePersonId;
    INSERT INTO student (person_id, call) VALUES (kylePersonId, false) RETURNING student_id INTO kyleStudentId;

    -- Logan 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO loganUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (emersonUserId, 'Logan', londonId) RETURNING person_id INTO loganPersonId;
    INSERT INTO student (person_id, call) VALUES (loganPersonId, false) RETURNING student_id INTO loganStudentId;

    -- Marion 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO marionUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (emersonUserId, 'Marion', londonId) RETURNING person_id INTO marionPersonId;
    INSERT INTO student (person_id, call) VALUES (marionPersonId, false) RETURNING student_id INTO marionStudentId;

    -- Ryan 
    INSERT INTO public.user (active) VALUES (true) RETURNING user_id INTO ryanUserId;
    INSERT INTO person (user_id, first_name, region_id) VALUES (emersonUserId, 'Ryan', londonId) RETURNING person_id INTO ryanPersonId;
    INSERT INTO student (person_id, call) VALUES (ryanPersonId, false) RETURNING student_id INTO ryanStudentId;    
END