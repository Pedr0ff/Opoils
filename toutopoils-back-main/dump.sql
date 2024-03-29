--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: public_mmwk_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO public_mmwk_user;

--
-- Name: animal_gender; Type: DOMAIN; Schema: public; Owner: public_mmwk_user
--

CREATE DOMAIN public.animal_gender AS text
	CONSTRAINT animal_gender_check CHECK ((VALUE = ANY (ARRAY['MALE'::text, 'FEMALE'::text])));


ALTER DOMAIN public.animal_gender OWNER TO public_mmwk_user;

--
-- Name: animal_size; Type: DOMAIN; Schema: public; Owner: public_mmwk_user
--

CREATE DOMAIN public.animal_size AS text
	CONSTRAINT animal_size_check CHECK ((VALUE = ANY (ARRAY['SMALL'::text, 'MEDIUM'::text, 'BIG'::text])));


ALTER DOMAIN public.animal_size OWNER TO public_mmwk_user;

--
-- Name: animal_specie; Type: DOMAIN; Schema: public; Owner: public_mmwk_user
--

CREATE DOMAIN public.animal_specie AS text
	CONSTRAINT animal_specie_check CHECK ((VALUE = ANY (ARRAY['CAT'::text, 'DOG'::text, 'OTHER'::text])));


ALTER DOMAIN public.animal_specie OWNER TO public_mmwk_user;

--
-- Name: email; Type: DOMAIN; Schema: public; Owner: public_mmwk_user
--

CREATE DOMAIN public.email AS character varying(255)
	CONSTRAINT email_check CHECK (((VALUE)::text ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,}$'::text));


ALTER DOMAIN public.email OWNER TO public_mmwk_user;

--
-- Name: feeling; Type: DOMAIN; Schema: public; Owner: public_mmwk_user
--

CREATE DOMAIN public.feeling AS text
	CONSTRAINT feeling_check CHECK ((VALUE = ANY (ARRAY['BAD'::text, 'MEDIUM'::text, 'GOOD'::text])));


ALTER DOMAIN public.feeling OWNER TO public_mmwk_user;

--
-- Name: volunteer_experience; Type: DOMAIN; Schema: public; Owner: public_mmwk_user
--

CREATE DOMAIN public.volunteer_experience AS text
	CONSTRAINT volunteer_experience_check CHECK ((VALUE = ANY (ARRAY['BEGINNER'::text, 'MEDIUM'::text, 'EXPERT'::text])));


ALTER DOMAIN public.volunteer_experience OWNER TO public_mmwk_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Animal; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."Animal" (
    id integer NOT NULL,
    species public.animal_specie NOT NULL,
    name text NOT NULL,
    gender public.animal_gender NOT NULL,
    age timestamp with time zone NOT NULL,
    size public.animal_size NOT NULL,
    volunteer_experience public.volunteer_experience DEFAULT 'BEGINNER'::text NOT NULL,
    box_id integer NOT NULL,
    url_image text,
    bio text
);


ALTER TABLE public."Animal" OWNER TO public_mmwk_user;

--
-- Name: Animal_has_tag; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."Animal_has_tag" (
    tag_id integer NOT NULL,
    animal_id integer NOT NULL
);


ALTER TABLE public."Animal_has_tag" OWNER TO public_mmwk_user;

--
-- Name: Animal_id_seq; Type: SEQUENCE; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE public."Animal" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Animal_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Walk; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."Walk" (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    comment text,
    feeling public.feeling DEFAULT 'GOOD'::text NOT NULL,
    user_id integer NOT NULL,
    animal_id integer NOT NULL,
    end_date timestamp with time zone
);


ALTER TABLE public."Walk" OWNER TO public_mmwk_user;

--
-- Name: AnimalsToWalk; Type: VIEW; Schema: public; Owner: public_mmwk_user
--

CREATE VIEW public."AnimalsToWalk" AS
 SELECT a.id,
    a.species,
    a.name,
    a.gender,
    a.age,
    a.size,
    a.volunteer_experience,
    a.box_id,
    a.url_image,
    a.bio,
    s.animal_id,
    s.last_walk
   FROM (public."Animal" a
     LEFT JOIN ( SELECT "Walk".animal_id,
            max("Walk".date) AS last_walk
           FROM public."Walk"
          GROUP BY "Walk".animal_id) s ON ((a.id = s.animal_id)))
  ORDER BY COALESCE(s.last_walk, '0999-12-31 23:50:39+00'::timestamp with time zone), a.id DESC;


ALTER VIEW public."AnimalsToWalk" OWNER TO public_mmwk_user;

--
-- Name: Box; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."Box" (
    id integer NOT NULL,
    type public.animal_specie DEFAULT 'OTHER'::text NOT NULL,
    number text NOT NULL,
    nbr_of_places integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."Box" OWNER TO public_mmwk_user;

--
-- Name: Box_id_seq; Type: SEQUENCE; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE public."Box" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Box_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Visit; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."Visit" (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    comment text,
    user_id integer NOT NULL,
    box_id integer NOT NULL,
    end_date timestamp with time zone,
    feeling public.feeling DEFAULT 'GOOD'::text NOT NULL
);


ALTER TABLE public."Visit" OWNER TO public_mmwk_user;

--
-- Name: BoxesToVisit; Type: VIEW; Schema: public; Owner: public_mmwk_user
--

CREATE VIEW public."BoxesToVisit" AS
 SELECT a.id,
    a.type,
    a.number,
    a.nbr_of_places,
    s.box_id,
    s.last_visit
   FROM (public."Box" a
     LEFT JOIN ( SELECT "Visit".box_id,
            max("Visit".date) AS last_visit
           FROM public."Visit"
          GROUP BY "Visit".box_id) s ON ((a.id = s.box_id)))
  ORDER BY COALESCE(s.last_visit, '0999-12-31 23:50:39+00'::timestamp with time zone), a.id DESC;


ALTER VIEW public."BoxesToVisit" OWNER TO public_mmwk_user;

--
-- Name: Tag; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."Tag" (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public."Tag" OWNER TO public_mmwk_user;

--
-- Name: Tag_id_seq; Type: SEQUENCE; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE public."Tag" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Tag_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    phone_number text,
    name text NOT NULL,
    firstname text NOT NULL,
    url_image text,
    admin boolean DEFAULT false NOT NULL,
    experience public.volunteer_experience DEFAULT 'BEGINNER'::text NOT NULL
);


ALTER TABLE public."User" OWNER TO public_mmwk_user;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE public."User" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."User_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Visit_id_seq; Type: SEQUENCE; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE public."Visit" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Visit_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Walk_id_seq; Type: SEQUENCE; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE public."Walk" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Walk_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: public_mmwk_user
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO public_mmwk_user;

--
-- Data for Name: Animal; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."Animal" (id, species, name, gender, age, size, volunteer_experience, box_id, url_image, bio) FROM stdin;
\.


--
-- Data for Name: Animal_has_tag; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."Animal_has_tag" (tag_id, animal_id) FROM stdin;
\.


--
-- Data for Name: Box; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."Box" (id, type, number, nbr_of_places) FROM stdin;
\.


--
-- Data for Name: Tag; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."Tag" (id, name) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."User" (id, email, password, phone_number, name, firstname, url_image, admin, experience) FROM stdin;
\.


--
-- Data for Name: Visit; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."Visit" (id, date, comment, user_id, box_id, end_date, feeling) FROM stdin;
\.


--
-- Data for Name: Walk; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public."Walk" (id, date, comment, feeling, user_id, animal_id, end_date) FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: public_mmwk_user
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
784cfdb4-cd2f-4502-b105-a80ec3f79841	8f87873ce4b4f20960553d72cb1de1f08f949d1a431b08fb59300b6531d79b1a	2024-01-07 13:12:41.243633+00	20230120102634_init_db	\N	\N	2024-01-07 13:12:41.024841+00	1
1bdeda3a-929d-4328-9ffa-868c80357778	5a8b4330570281b5928db4dfeab36027810b5ce5acca8a26b3bd1dbc60d4c173	2024-01-07 13:12:41.385966+00	20230122163225_add_url_image_to_animal	\N	\N	2024-01-07 13:12:41.284574+00	1
ca08fd04-5ed3-4a55-897c-e5a53ad4975f	59b681eb59c68979bdd3d82d745cd6d34fd5eea08136a59a1b02880647d6d105	2024-01-07 13:12:41.515863+00	20230124193226_adding_bio_to_animal	\N	\N	2024-01-07 13:12:41.420453+00	1
5b128127-ab84-419d-91ed-2ef0f841f6de	6ac7f725057f1819a4b013629b867bc9d5ed98e8bc854aa4f5fe3446284a6dd5	2024-01-07 13:12:41.680489+00	20230126083847_add_animals_to_walk_view	\N	\N	2024-01-07 13:12:41.55637+00	1
5e2c7026-8cd7-49a4-bcaa-f3d9079b0ef5	0e200cad35a9a424b95444d4c841a7dc4006ff10bf9e550c0c4c00b763830cf8	2024-01-07 13:12:41.822571+00	20230126102027_add_boxes_to_visit_view	\N	\N	2024-01-07 13:12:41.720379+00	1
4a0d15b8-3e6d-425f-a978-ff7cad503995	99168d191f8b531b0b66d6bece199915fc2098e1fe7815f282b05af38bc20c5f	2024-01-07 13:12:41.95732+00	20230130084127_add_end_date_to_walk	\N	\N	2024-01-07 13:12:41.857309+00	1
1bf69461-83ad-4e00-8ac7-97224a3b2964	789d0698ac27fe8a8471c5abf2aa7a79ea91e4b09b25aac4702b6b978288f011	2024-01-07 13:12:42.099135+00	20230130100038_rename_end_date_to_end_date	\N	\N	2024-01-07 13:12:42.008991+00	1
3067498a-19b2-435f-8fd0-0b09b1da066c	7785c899b9f055991f12205ff92e02d9d32a9ddd498588da22270320643576fc	2024-01-07 13:12:42.227444+00	20230131165405_add_end_date_to_visit	\N	\N	2024-01-07 13:12:42.132563+00	1
c9b1edb5-ecd8-457f-abe2-c1d115a7d324	9fd0ce2b0640d434d2e4f99b8f7c48b4c05e68deb7a64ddc6e5c5a0a6baeecd7	2024-01-07 13:12:42.364945+00	20230206104547_add_feeling_to_visits	\N	\N	2024-01-07 13:12:42.260222+00	1
\.


--
-- Name: Animal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: public_mmwk_user
--

SELECT pg_catalog.setval('public."Animal_id_seq"', 24, true);


--
-- Name: Box_id_seq; Type: SEQUENCE SET; Schema: public; Owner: public_mmwk_user
--

SELECT pg_catalog.setval('public."Box_id_seq"', 13, true);


--
-- Name: Tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: public_mmwk_user
--

SELECT pg_catalog.setval('public."Tag_id_seq"', 8, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: public_mmwk_user
--

SELECT pg_catalog.setval('public."User_id_seq"', 12, true);


--
-- Name: Visit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: public_mmwk_user
--

SELECT pg_catalog.setval('public."Visit_id_seq"', 4, true);


--
-- Name: Walk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: public_mmwk_user
--

SELECT pg_catalog.setval('public."Walk_id_seq"', 13, true);


--
-- Name: Animal_has_tag Animal_has_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Animal_has_tag"
    ADD CONSTRAINT "Animal_has_tag_pkey" PRIMARY KEY (animal_id, tag_id);


--
-- Name: Animal Animal_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Animal"
    ADD CONSTRAINT "Animal_pkey" PRIMARY KEY (id);


--
-- Name: Box Box_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Box"
    ADD CONSTRAINT "Box_pkey" PRIMARY KEY (id);


--
-- Name: Tag Tag_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Visit Visit_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Visit"
    ADD CONSTRAINT "Visit_pkey" PRIMARY KEY (id);


--
-- Name: Walk Walk_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Walk"
    ADD CONSTRAINT "Walk_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: public_mmwk_user
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Animal Animal_box_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Animal"
    ADD CONSTRAINT "Animal_box_id_fkey" FOREIGN KEY (box_id) REFERENCES public."Box"(id);


--
-- Name: Animal_has_tag Animal_has_tag_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Animal_has_tag"
    ADD CONSTRAINT "Animal_has_tag_animal_id_fkey" FOREIGN KEY (animal_id) REFERENCES public."Animal"(id) ON DELETE CASCADE;


--
-- Name: Animal_has_tag Animal_has_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Animal_has_tag"
    ADD CONSTRAINT "Animal_has_tag_tag_id_fkey" FOREIGN KEY (tag_id) REFERENCES public."Tag"(id) ON DELETE CASCADE;


--
-- Name: Visit Visit_box_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Visit"
    ADD CONSTRAINT "Visit_box_id_fkey" FOREIGN KEY (box_id) REFERENCES public."Box"(id) ON DELETE CASCADE;


--
-- Name: Visit Visit_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Visit"
    ADD CONSTRAINT "Visit_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id);


--
-- Name: Walk Walk_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Walk"
    ADD CONSTRAINT "Walk_animal_id_fkey" FOREIGN KEY (animal_id) REFERENCES public."Animal"(id) ON DELETE CASCADE;


--
-- Name: Walk Walk_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: public_mmwk_user
--

ALTER TABLE ONLY public."Walk"
    ADD CONSTRAINT "Walk_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO public_mmwk_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO public_mmwk_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO public_mmwk_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO public_mmwk_user;


--
-- PostgreSQL database dump complete
--

