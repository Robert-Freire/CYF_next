SET check_function_bodies = false;
CREATE SCHEMA heroku_ext;
CREATE TABLE public.buddy (
    volunteer_id integer NOT NULL,
    student_id integer NOT NULL,
    buddy_type_id integer
);
CREATE TABLE public.buddy_type (
    buddy_type_id integer NOT NULL,
    description text
);
ALTER TABLE public.buddy_type ALTER COLUMN buddy_type_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.buddy_type_buddy_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.cohort (
    cohort_id integer NOT NULL,
    region_id integer,
    description text,
    start_date date,
    end_date date,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer
);
ALTER TABLE public.cohort ALTER COLUMN cohort_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cohort_cohort_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.person (
    person_id integer NOT NULL,
    user_id integer,
    first_name text,
    last_name text,
    email text,
    telephone text,
    agree_to_tou boolean,
    agree_to_receive_communication boolean,
    region_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer
);
ALTER TABLE public.person ALTER COLUMN person_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.person_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.region (
    region_id integer NOT NULL,
    description text
);
ALTER TABLE public.region ALTER COLUMN region_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.region_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.role (
    role_id integer NOT NULL,
    name text
);
ALTER TABLE public.role ALTER COLUMN role_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.role_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.student (
    student_id integer NOT NULL,
    person_id integer,
    has_it_access boolean,
    is_eighteen boolean,
    has_disadvantaged_background boolean,
    disadvantaged_background_text text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    call boolean
);
CREATE TABLE public.student_cohort (
    student_id integer NOT NULL,
    cohort_id integer NOT NULL,
    is_active boolean
);
ALTER TABLE public.student ALTER COLUMN student_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.student_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public."user" (
    user_id integer NOT NULL,
    active boolean
);
CREATE TABLE public.volunteer (
    volunteer_id integer NOT NULL,
    person_id integer,
    other_expertise text,
    is_currently_volunteering boolean,
    has_disadvantaged_background boolean,
    is_available_on_weekends text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer
);
CREATE TABLE public.volunteer_role_cohort (
    volunteer_id integer NOT NULL,
    cohort_id integer NOT NULL,
    role_id integer NOT NULL,
    is_active boolean
);
CREATE VIEW public.user_access_person AS
 SELECT DISTINCT uas.user_id,
    uas.person_id
   FROM ( SELECT vp.user_id,
            s.person_id
           FROM (((public.buddy b
             JOIN public.volunteer v ON ((b.volunteer_id = v.volunteer_id)))
             JOIN public.person vp ON ((vp.person_id = v.person_id)))
             JOIN public.student s ON ((s.student_id = b.student_id)))
        UNION
         SELECT vp.user_id,
            s.person_id
           FROM ((((public.student_cohort sc
             JOIN public.volunteer_role_cohort vc ON ((sc.cohort_id = vc.cohort_id)))
             JOIN public.volunteer v ON ((vc.volunteer_id = v.volunteer_id)))
             JOIN public.person vp ON ((vp.person_id = v.person_id)))
             JOIN public.student s ON ((s.student_id = sc.student_id)))) uas;
CREATE VIEW public.user_access_student AS
 SELECT DISTINCT uas.user_id,
    uas.student_id
   FROM ( SELECT vp.user_id,
            s.student_id
           FROM (((public.student s
             JOIN public.buddy b ON ((s.student_id = b.student_id)))
             JOIN public.volunteer v ON ((b.volunteer_id = v.volunteer_id)))
             JOIN public.person vp ON ((vp.person_id = v.person_id)))
        UNION
         SELECT vp.user_id,
            s.student_id
           FROM ((((public.student s
             JOIN public.student_cohort sc ON ((s.student_id = sc.student_id)))
             JOIN public.volunteer_role_cohort vc ON ((sc.cohort_id = vc.cohort_id)))
             JOIN public.volunteer v ON ((vc.volunteer_id = v.volunteer_id)))
             JOIN public.person vp ON ((vp.person_id = v.person_id)))) uas;
CREATE VIEW public.user_l2_access_student AS
 SELECT vp.user_id,
    s.student_id,
    s.person_id
   FROM (((public.student s
     JOIN public.person sp ON ((sp.person_id = s.person_id)))
     JOIN public.person vp ON ((vp.region_id = sp.region_id)))
     JOIN public.volunteer v ON ((vp.person_id = v.person_id)));
CREATE TABLE public.user_role (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);
ALTER TABLE public."user" ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
ALTER TABLE public.volunteer ALTER COLUMN volunteer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.volunteer_volunteer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
ALTER TABLE ONLY public.buddy
    ADD CONSTRAINT buddy_pkey PRIMARY KEY (volunteer_id, student_id);
ALTER TABLE ONLY public.buddy_type
    ADD CONSTRAINT buddy_type_pkey PRIMARY KEY (buddy_type_id);
ALTER TABLE ONLY public.cohort
    ADD CONSTRAINT cohort_pkey PRIMARY KEY (cohort_id);
ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);
ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);
ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);
ALTER TABLE ONLY public.student_cohort
    ADD CONSTRAINT student_cohort_pkey PRIMARY KEY (student_id, cohort_id);
ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);
ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id);
ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT volunteer_pkey PRIMARY KEY (volunteer_id);
ALTER TABLE ONLY public.volunteer_role_cohort
    ADD CONSTRAINT volunteer_role_cohort_pkey PRIMARY KEY (volunteer_id, cohort_id, role_id);
ALTER TABLE ONLY public.buddy
    ADD CONSTRAINT buddy_buddy_type_fkey FOREIGN KEY (buddy_type_id) REFERENCES public.buddy_type(buddy_type_id);
ALTER TABLE ONLY public.buddy
    ADD CONSTRAINT buddy_student_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id);
ALTER TABLE ONLY public.buddy
    ADD CONSTRAINT buddy_volunteer_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer(volunteer_id);
ALTER TABLE ONLY public.cohort
    ADD CONSTRAINT cohort_region_fkey FOREIGN KEY (region_id) REFERENCES public.region(region_id);
ALTER TABLE ONLY public.cohort
    ADD CONSTRAINT cohort_updated_fkey FOREIGN KEY (updated_by) REFERENCES public."user"(user_id);
ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_region_fkey FOREIGN KEY (region_id) REFERENCES public.region(region_id);
ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_updated_fkey FOREIGN KEY (updated_by) REFERENCES public."user"(user_id);
ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_user_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);
ALTER TABLE ONLY public.student_cohort
    ADD CONSTRAINT student_cohort_cohort_fkey FOREIGN KEY (cohort_id) REFERENCES public.cohort(cohort_id);
ALTER TABLE ONLY public.student_cohort
    ADD CONSTRAINT student_cohort_student_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id);
ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id);
ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_updated_fkey FOREIGN KEY (updated_by) REFERENCES public."user"(user_id);
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_role_fkey FOREIGN KEY (role_id) REFERENCES public.role(role_id);
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_user_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);
ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT volunteer_person_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id);
ALTER TABLE ONLY public.volunteer_role_cohort
    ADD CONSTRAINT volunteer_role_cohort_cohort_fkey FOREIGN KEY (cohort_id) REFERENCES public.cohort(cohort_id);
ALTER TABLE ONLY public.volunteer_role_cohort
    ADD CONSTRAINT volunteer_role_cohort_role_fkey FOREIGN KEY (role_id) REFERENCES public.role(role_id);
ALTER TABLE ONLY public.volunteer_role_cohort
    ADD CONSTRAINT volunteer_role_cohort_volunteer_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer(volunteer_id);
ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT volunteer_updated_fkey FOREIGN KEY (updated_by) REFERENCES public."user"(user_id);
