DROP TABLE IF EXISTS public.user_role;
DROP TABLE IF EXISTS public.volunteer_role_cohort;
DROP TABLE IF EXISTS public.role;
DROP TABLE IF EXISTS public.buddy;
DROP TABLE IF EXISTS public.buddy_type;
DROP TABLE IF EXISTS public.volunteer;
DROP TABLE IF EXISTS public.student_cohort;
DROP TABLE IF EXISTS public.cohort;
DROP TABLE IF EXISTS public.student;
DROP TABLE IF EXISTS public.person;
DROP TABLE IF EXISTS public.region;
DROP TABLE IF EXISTS public.user;

CREATE TABLE IF NOT EXISTS public.user
(
    user_id int GENERATED ALWAYS AS IDENTITY,
    active boolean,
    CONSTRAINT user_pkey PRIMARY KEY (User_id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user
    OWNER to postgres;

-- Table: public.Region
CREATE TABLE IF NOT EXISTS public.region
(
    region_id int GENERATED ALWAYS AS IDENTITY,
    description VARCHAR(250),
    CONSTRAINT region_pkey PRIMARY KEY (region_id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.region
    OWNER to postgres;

-- Table: public.Person
CREATE TABLE IF NOT EXISTS public.person
(
  person_id int GENERATED ALWAYS AS IDENTITY,
  user_id int,
  description VARCHAR(250),
  first_name  VARCHAR(250),
  last_name VARCHAR(250),
  email  VARCHAR(250),
  telephone  VARCHAR(250),
  agree_to_tou BOOLEAN,
  agree_to_receive_communication BOOLEAN,
  region_id int,
  created_at timestamp,
  updated_at timestamp,
  updated_by int,
  CONSTRAINT person_pkey PRIMARY KEY (person_id),
  CONSTRAINT person_user_fkey FOREIGN KEY (user_id) REFERENCES public.user (user_id),
  CONSTRAINT person_region_fkey FOREIGN KEY (region_id) REFERENCES public.region (region_id),
  CONSTRAINT person_updated_fkey FOREIGN KEY (updated_by) REFERENCES public.user (user_id) 
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.person
    OWNER to postgres;


-- Table: public.student
CREATE TABLE IF NOT EXISTS public.student
(
  student_id int GENERATED ALWAYS AS IDENTITY,
  person_id int,
  has_it_access boolean,
  is_eighteen boolean, 
  has_disadvantaged_background boolean,
  disadvantaged_background_text varchar(5000),
  created_at timestamp,
  updated_at timestamp,
  updated_by int,
  CONSTRAINT student_pkey PRIMARY KEY (student_id),
  CONSTRAINT student_person_fkey FOREIGN KEY (person_id) REFERENCES public.person (person_id),
  CONSTRAINT student_updated_fkey FOREIGN KEY (updated_by) REFERENCES public.user (user_id) 
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.student
    OWNER to postgres;


-- Table: public.cohort
CREATE TABLE IF NOT EXISTS public.cohort
(
  cohort_id int GENERATED ALWAYS AS IDENTITY,
  region_id int,
  description varchar(250),
  start_date date, 
  end_date date,
  disadvantaged_background_text varchar(5000),
  created_at timestamp,
  updated_at timestamp,
  updated_by int,
  CONSTRAINT cohort_pkey PRIMARY KEY (cohort_id),
  CONSTRAINT cohort_region_fkey FOREIGN KEY (region_id) REFERENCES public.region (region_id),
  CONSTRAINT cohort_updated_fkey FOREIGN KEY (updated_by) REFERENCES public.user (user_id) 
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cohort
    OWNER to postgres;

-- Table: public.student_cohort
CREATE TABLE IF NOT EXISTS public.student_cohort
(
  student_id int,
  cohort_id int ,
  is_active boolean,
  CONSTRAINT student_cohort_pkey PRIMARY KEY (student_id, cohort_id),
  CONSTRAINT student_cohort_student_fkey FOREIGN KEY (student_id) REFERENCES public.student (student_id),
  CONSTRAINT student_cohort_cohort_fkey FOREIGN KEY (cohort_id) REFERENCES public.cohort (cohort_id) 
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.student_cohort
    OWNER to postgres;

-- Table: public.volunteer
CREATE TABLE IF NOT EXISTS public.volunteer
(
  volunteer_id int GENERATED ALWAYS AS IDENTITY,
  person_id int,
  other_expertise varchar(250),
  is_currently_volunteering boolean, 
  has_disadvantaged_background boolean,
  is_available_on_weekends varchar(5000),
  created_at timestamp,
  updated_at timestamp,
  updated_by int,
  CONSTRAINT volunteer_pkey PRIMARY KEY (volunteer_id),
  CONSTRAINT volunteer_person_fkey FOREIGN KEY (person_id) REFERENCES public.person (person_id),
  CONSTRAINT volunteer_updated_fkey FOREIGN KEY (updated_by) REFERENCES public.user (user_id) 
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.student
    OWNER to postgres;

-- Table: public.buddy_type
CREATE TABLE IF NOT EXISTS public.buddy_type
(
  buddy_type_id int GENERATED ALWAYS AS IDENTITY,
  description varchar(250),
  CONSTRAINT buddy_type_pkey PRIMARY KEY (buddy_type_id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.buddy_type
    OWNER to postgres;

-- Table: public.buddy
CREATE TABLE IF NOT EXISTS public.buddy
(
  volunteer_id int,
  student_id int,
  buddy_type_id int,
  CONSTRAINT buddy_pkey PRIMARY KEY (volunteer_id, student_id),
  CONSTRAINT buddy_volunteer_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer (volunteer_id),
  CONSTRAINT buddy_student_fkey FOREIGN KEY (student_id) REFERENCES public.student (student_id),
  CONSTRAINT buddy_buddy_type_fkey FOREIGN KEY (buddy_type_id) REFERENCES public.buddy_type (buddy_type_id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.buddy
    OWNER to postgres;

-- Table: public.role
CREATE TABLE IF NOT EXISTS public.role
(
  role_id int GENERATED ALWAYS AS IDENTITY,
  name varchar(250),
  CONSTRAINT role_pkey PRIMARY KEY (role_id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.role
    OWNER to postgres;

-- Table: public.volunteer_role_cohort
CREATE TABLE IF NOT EXISTS public.volunteer_role_cohort
(
  volunteer_id int,
  cohort_id int,
  role_id int,
  is_active boolean,
  CONSTRAINT volunteer_role_cohort_pkey PRIMARY KEY (volunteer_id, cohort_id, role_id),
  CONSTRAINT volunteer_role_cohort_volunteer_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer (volunteer_id),
  CONSTRAINT volunteer_role_cohort_role_fkey FOREIGN KEY (role_id) REFERENCES public.role (role_id),
  CONSTRAINT volunteer_role_cohort_cohort_fkey FOREIGN KEY (cohort_id) REFERENCES public.cohort (cohort_id)

)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.volunteer_role_cohort
    OWNER to postgres;

-- Table: public.user_role
CREATE TABLE IF NOT EXISTS public.user_role
(
  user_id int,
  role_id int,
  CONSTRAINT user_role_user_fkey FOREIGN KEY (user_id) REFERENCES public.user (user_id),
  CONSTRAINT user_role_role_fkey FOREIGN KEY (role_id) REFERENCES public.role (role_id),
  CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user_role
    OWNER to postgres;
