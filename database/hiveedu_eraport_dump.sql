--
-- PostgreSQL database dump
--

\restrict M1mGfvT3WhxXFb9ZNAW8VdSMDT3cpDluCdc8zjLJfQXzLRTC0NuMUwlLHAvrs8T

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: attendance_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendance_status_enum AS ENUM (
    'PRESENT',
    'ABSENT',
    'LATE'
);


ALTER TYPE public.attendance_status_enum OWNER TO postgres;

--
-- Name: intervention_notes_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.intervention_notes_status_enum AS ENUM (
    'OPEN',
    'IN_PROGRESS',
    'RESOLVED'
);


ALTER TYPE public.intervention_notes_status_enum OWNER TO postgres;

--
-- Name: mlr_run_history_coefficientmode_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.mlr_run_history_coefficientmode_enum AS ENUM (
    'AUTO_TRAINED',
    'MANUAL_OVERRIDE'
);


ALTER TYPE public.mlr_run_history_coefficientmode_enum OWNER TO postgres;

--
-- Name: system_config_coefficientmode_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.system_config_coefficientmode_enum AS ENUM (
    'AUTO_TRAINED',
    'MANUAL_OVERRIDE'
);


ALTER TYPE public.system_config_coefficientmode_enum OWNER TO postgres;

--
-- Name: users_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_role_enum AS ENUM (
    'ADMIN',
    'TEACHER',
    'USER'
);


ALTER TYPE public.users_role_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: analytics_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analytics_records (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid NOT NULL,
    "attendancePercentage" numeric(5,2) NOT NULL,
    "avgTryoutScore" numeric(5,2) NOT NULL,
    "teacherObjectiveScore" numeric(5,2) NOT NULL,
    "tryoutCount" integer DEFAULT 0 NOT NULL,
    "predictedScore" numeric(5,2),
    "actualExamScore" numeric(5,2),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.analytics_records OWNER TO postgres;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid NOT NULL,
    date date NOT NULL,
    status public.attendance_status_enum NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    action character varying(80) NOT NULL,
    "actorId" uuid,
    "actorRole" character varying(20),
    "targetType" character varying(80),
    "targetId" character varying(255),
    description text NOT NULL,
    metadata jsonb,
    "ipAddress" character varying(100),
    "userAgent" character varying(500),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: intervention_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intervention_notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid NOT NULL,
    "createdById" uuid,
    "riskLevel" character varying(20) NOT NULL,
    "predictedScore" numeric(5,2),
    note text NOT NULL,
    "actionPlan" text,
    status public.intervention_notes_status_enum DEFAULT 'OPEN'::public.intervention_notes_status_enum NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.intervention_notes OWNER TO postgres;

--
-- Name: mlr_run_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mlr_run_history (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "generatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "generatedById" uuid,
    "coefficientMode" public.mlr_run_history_coefficientmode_enum NOT NULL,
    intercept double precision NOT NULL,
    "attendanceCoefficient" double precision NOT NULL,
    "tryoutCoefficient" double precision NOT NULL,
    mse double precision,
    "totalUserCount" integer NOT NULL,
    "activeUserCount" integer NOT NULL,
    "eligibleUserCount" integer NOT NULL,
    "excludedUserCount" integer NOT NULL,
    "excludedInactiveCount" integer NOT NULL,
    "excludedInsufficientTryoutCount" integer NOT NULL,
    "excludedNullScoreCount" integer NOT NULL,
    "trainingSampleCount" integer NOT NULL,
    "predictionCount" integer NOT NULL,
    "fallbackUsed" boolean DEFAULT false NOT NULL,
    "fallbackReason" text,
    notes text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "teacherObjectiveCoefficient" double precision DEFAULT '0.1'::double precision NOT NULL
);


ALTER TABLE public.mlr_run_history OWNER TO postgres;

--
-- Name: records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.records (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "userId" uuid NOT NULL,
    "mathematicsScore" double precision NOT NULL,
    "logicalReasoningScore" double precision NOT NULL,
    "englishScore" double precision NOT NULL,
    "teacherFeedback" text,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "mathScore" double precision,
    "logicScore" double precision,
    "averageScore" double precision,
    "actualExamScore" double precision,
    "examDate" date,
    "examLabel" character varying(255),
    "isUsedForTraining" boolean DEFAULT true NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "teacherObjectiveScore" double precision
);


ALTER TABLE public.records OWNER TO postgres;

--
-- Name: system_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_config (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "x1Weight" double precision DEFAULT '40'::double precision NOT NULL,
    "x2Weight" double precision DEFAULT '50'::double precision NOT NULL,
    "x3Weight" double precision DEFAULT '10'::double precision NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    intercept double precision DEFAULT '0'::double precision NOT NULL,
    "attendanceCoefficient" double precision DEFAULT '0.4'::double precision NOT NULL,
    "tryoutCoefficient" double precision DEFAULT '0.5'::double precision NOT NULL,
    "coefficientMode" public.system_config_coefficientmode_enum DEFAULT 'AUTO_TRAINED'::public.system_config_coefficientmode_enum NOT NULL,
    "teacherObjectiveCoefficient" double precision DEFAULT '0.1'::double precision NOT NULL
);


ALTER TABLE public.system_config OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "fullName" character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role public.users_role_enum DEFAULT 'USER'::public.users_role_enum NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "assignedTutorId" uuid
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: analytics_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analytics_records (id, "userId", "attendancePercentage", "avgTryoutScore", "teacherObjectiveScore", "tryoutCount", "predictedScore", "actualExamScore", "createdAt", "updatedAt") FROM stdin;
06e96485-d5dc-4a22-94ce-a2c53adc1d45	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	100.00	91.07	91.07	5	\N	91.00	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
82189156-c7cb-4270-9867-74b179ef1e89	0bbafb53-a86f-4de6-a8af-09c3215025f6	91.67	86.00	86.00	5	\N	86.00	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
37f661f5-0ff3-4934-86c4-9d106fe36152	c60fc6de-46f8-482c-922b-7f684b5263b1	33.33	65.40	65.40	5	\N	64.60	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
b5da594f-b884-413b-8ced-8bd967ac8b12	80adb604-99a6-4b85-bf98-8d812ff9fa5e	41.67	78.80	78.80	5	\N	78.20	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
05ca7d14-2fb5-4a61-a4c2-2f6995dac88c	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	91.67	89.27	89.27	5	\N	89.60	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
b51ae609-a9d3-4320-ae68-3d80e403a537	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	83.33	74.80	74.80	5	\N	\N	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
17bab156-fe46-4f20-9a13-4534ff7d9e96	75050bc8-0c4a-4d3b-be88-12d5536778a3	50.00	69.80	69.80	5	\N	\N	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
9d5b3517-9bc1-4878-ab16-b849860658cb	7585de50-6bf7-49d6-bfae-5740892a2e5f	83.33	78.75	79.00	4	\N	\N	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
01be749d-76b4-48de-8e28-b8bf04348096	e40c050d-1705-4911-98ef-4aa4743e0140	75.00	82.50	0.00	4	\N	\N	2026-04-30 20:59:22.382666	2026-04-30 20:59:22.382666
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, "userId", date, status, "createdAt") FROM stdin;
140b6b30-416d-47ce-b80c-4fd175d360a4	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	2026-03-10	PRESENT	2026-04-30 20:59:22.327961
91d63df1-7965-48cf-b087-2474167cfc7f	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	2026-03-11	PRESENT	2026-04-30 20:59:22.327961
59503547-0211-4014-bb4f-c3fa12f0185c	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	2026-03-12	PRESENT	2026-04-30 20:59:22.327961
f8ed3cf9-5191-4e5a-b3b8-9d37fa3a891e	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
434333cf-a87d-496a-af84-7a7ef3c08179	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	2026-03-14	PRESENT	2026-04-30 20:59:22.327961
f36a1115-58d1-422a-a05c-8e96cc47dfb9	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	2026-03-15	PRESENT	2026-04-30 20:59:22.327961
dd070b45-4449-4bd8-849f-1f138ada6581	0bbafb53-a86f-4de6-a8af-09c3215025f6	2026-03-10	PRESENT	2026-04-30 20:59:22.327961
bc940d6f-62b3-475e-99a4-5956e40d8698	0bbafb53-a86f-4de6-a8af-09c3215025f6	2026-03-11	PRESENT	2026-04-30 20:59:22.327961
e27e74e1-37eb-4eac-bf6d-718c04ff1ce1	0bbafb53-a86f-4de6-a8af-09c3215025f6	2026-03-12	LATE	2026-04-30 20:59:22.327961
bdb1e68a-060e-4b2a-8933-aec4d7a73e48	0bbafb53-a86f-4de6-a8af-09c3215025f6	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
8d826aff-e50d-4c6d-9b64-801acade7b45	0bbafb53-a86f-4de6-a8af-09c3215025f6	2026-03-14	PRESENT	2026-04-30 20:59:22.327961
1c8e80d3-34fe-4bd2-8d13-02cb8b7ff6e1	0bbafb53-a86f-4de6-a8af-09c3215025f6	2026-03-15	PRESENT	2026-04-30 20:59:22.327961
7e1916a9-736d-44b1-b6dd-180c950fae23	c60fc6de-46f8-482c-922b-7f684b5263b1	2026-03-10	ABSENT	2026-04-30 20:59:22.327961
9527e83d-ac1b-4726-b922-66025931dd43	c60fc6de-46f8-482c-922b-7f684b5263b1	2026-03-11	LATE	2026-04-30 20:59:22.327961
f2eb0e6c-0029-4249-94fb-99116edd56ff	c60fc6de-46f8-482c-922b-7f684b5263b1	2026-03-12	ABSENT	2026-04-30 20:59:22.327961
100e6598-43d8-44b5-8f35-286b9b3cd877	c60fc6de-46f8-482c-922b-7f684b5263b1	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
7b510883-914d-4f67-b1d5-8b05d1e7230d	c60fc6de-46f8-482c-922b-7f684b5263b1	2026-03-14	LATE	2026-04-30 20:59:22.327961
31f167d0-775b-46a7-be40-33502fc4031c	c60fc6de-46f8-482c-922b-7f684b5263b1	2026-03-15	ABSENT	2026-04-30 20:59:22.327961
11fcbcf0-63c6-4bf5-8d6e-916393026d28	80adb604-99a6-4b85-bf98-8d812ff9fa5e	2026-03-10	LATE	2026-04-30 20:59:22.327961
7721a328-a4ef-4666-9c5a-ac6ef8b5fbab	80adb604-99a6-4b85-bf98-8d812ff9fa5e	2026-03-11	ABSENT	2026-04-30 20:59:22.327961
e9ec7748-c9a2-4e7b-bb4d-f982a895ec15	80adb604-99a6-4b85-bf98-8d812ff9fa5e	2026-03-12	LATE	2026-04-30 20:59:22.327961
08e64be4-8232-4705-ba1d-27c411115c19	80adb604-99a6-4b85-bf98-8d812ff9fa5e	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
f76f5a65-f45d-45e1-89bc-86dc637f2a16	80adb604-99a6-4b85-bf98-8d812ff9fa5e	2026-03-14	LATE	2026-04-30 20:59:22.327961
4b5e611c-1f2d-4467-8759-fad62283f3dc	80adb604-99a6-4b85-bf98-8d812ff9fa5e	2026-03-15	ABSENT	2026-04-30 20:59:22.327961
b0c8c1db-4c93-46bb-8fac-d1c797e57bd4	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	2026-03-10	PRESENT	2026-04-30 20:59:22.327961
1a64bd5a-f8cd-40a7-92fd-13b65ebccb82	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	2026-03-11	PRESENT	2026-04-30 20:59:22.327961
bf50da80-03bb-456a-a911-6b568963e075	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	2026-03-12	PRESENT	2026-04-30 20:59:22.327961
5964c7cf-4494-4373-99d3-d5c073af7751	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	2026-03-13	LATE	2026-04-30 20:59:22.327961
0a99aa68-7b96-4a0f-8d12-9f4c38239623	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	2026-03-14	PRESENT	2026-04-30 20:59:22.327961
a2a8f376-0251-431b-a84a-34ed565101e7	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	2026-03-15	PRESENT	2026-04-30 20:59:22.327961
916ebfbf-602d-4c16-b42f-fcfa3d5c330c	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	2026-03-10	PRESENT	2026-04-30 20:59:22.327961
3a94803f-3946-49bf-b248-0cff8f5c77fd	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	2026-03-11	LATE	2026-04-30 20:59:22.327961
b7cd7d79-e9d7-49ac-bbf1-5cbca3387f6b	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	2026-03-12	PRESENT	2026-04-30 20:59:22.327961
3f1511c4-225e-4ddf-b100-a953ea7a67b1	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
7c68b5e1-11d8-4aba-8c98-72574a2609e0	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	2026-03-14	LATE	2026-04-30 20:59:22.327961
fb2d85ff-8158-46d7-a282-2a9385ee4b07	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	2026-03-15	PRESENT	2026-04-30 20:59:22.327961
24dcd393-92ea-46d9-b222-25e32cd0a71b	75050bc8-0c4a-4d3b-be88-12d5536778a3	2026-03-10	LATE	2026-04-30 20:59:22.327961
c0cac9c3-70ec-4d9b-845b-05391b9bcf5f	75050bc8-0c4a-4d3b-be88-12d5536778a3	2026-03-11	ABSENT	2026-04-30 20:59:22.327961
b83623b3-a585-4ef2-9cdb-ef8a956889f0	75050bc8-0c4a-4d3b-be88-12d5536778a3	2026-03-12	PRESENT	2026-04-30 20:59:22.327961
200294d5-cd36-40fe-a9e1-3cfbcaa25954	75050bc8-0c4a-4d3b-be88-12d5536778a3	2026-03-13	LATE	2026-04-30 20:59:22.327961
ba59f1a5-ed0e-4225-a15e-76421a6911ac	75050bc8-0c4a-4d3b-be88-12d5536778a3	2026-03-14	ABSENT	2026-04-30 20:59:22.327961
91cb9970-cba9-4e64-ae6c-8346bd7320df	75050bc8-0c4a-4d3b-be88-12d5536778a3	2026-03-15	PRESENT	2026-04-30 20:59:22.327961
b179ea35-5afe-4d29-985e-4a5588a0d190	7585de50-6bf7-49d6-bfae-5740892a2e5f	2026-03-10	PRESENT	2026-04-30 20:59:22.327961
7b14711e-00bf-4ba5-b2d6-2ec95375ef8c	7585de50-6bf7-49d6-bfae-5740892a2e5f	2026-03-11	LATE	2026-04-30 20:59:22.327961
a341a4f3-20ea-4a10-9105-a6843d1940f5	7585de50-6bf7-49d6-bfae-5740892a2e5f	2026-03-12	PRESENT	2026-04-30 20:59:22.327961
86665a01-050d-465a-8ae9-cb775f31de93	7585de50-6bf7-49d6-bfae-5740892a2e5f	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
71b897d1-3c5d-4abc-a25f-24a45a636d82	7585de50-6bf7-49d6-bfae-5740892a2e5f	2026-03-14	PRESENT	2026-04-30 20:59:22.327961
e561a112-aa81-432d-a5e4-3a34f8786c45	7585de50-6bf7-49d6-bfae-5740892a2e5f	2026-03-15	LATE	2026-04-30 20:59:22.327961
b512c018-10d0-44d5-859e-1108f92f3e23	e40c050d-1705-4911-98ef-4aa4743e0140	2026-03-10	PRESENT	2026-04-30 20:59:22.327961
a56e155a-7f34-4244-8fe6-afc687c5b4a2	e40c050d-1705-4911-98ef-4aa4743e0140	2026-03-11	PRESENT	2026-04-30 20:59:22.327961
8dd6f47a-da42-449a-be8b-83090b33ddf2	e40c050d-1705-4911-98ef-4aa4743e0140	2026-03-12	LATE	2026-04-30 20:59:22.327961
0b9192b7-17f3-4819-9bf1-c2fdf533fe13	e40c050d-1705-4911-98ef-4aa4743e0140	2026-03-13	PRESENT	2026-04-30 20:59:22.327961
979c0caa-864d-4c8d-a9ae-d71a5add92f8	e40c050d-1705-4911-98ef-4aa4743e0140	2026-03-14	ABSENT	2026-04-30 20:59:22.327961
ce63d140-f784-4cc9-96e5-a8fe24e12972	e40c050d-1705-4911-98ef-4aa4743e0140	2026-03-15	PRESENT	2026-04-30 20:59:22.327961
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, action, "actorId", "actorRole", "targetType", "targetId", description, metadata, "ipAddress", "userAgent", "createdAt") FROM stdin;
7109b9bd-1534-4a4e-99f7-42d43e8f32d1	LOGIN_SUCCESS	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	auth	64e25fea-5439-4a0d-a6b7-f72b58a28209	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 00:56:14.823849
22c9bbf9-b95b-4422-a49e-a374673460ae	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	5e753a2e-76cd-45f2-b9ed-1ddc01da51b4	Analytics Excel export generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:01.826997
63616747-a549-4e89-8291-b09795d76398	ANALYTICS_EXPORTED	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	analytics_export	5e753a2e-76cd-45f2-b9ed-1ddc01da51b4	Exported analytics workbook.	{"mse": null, "mlrRunHistoryId": "5e753a2e-76cd-45f2-b9ed-1ddc01da51b4", "predictionCount": 1}	\N	\N	2026-04-29 00:57:01.997513
a1eb49bd-702b-4073-bb7e-99d576fb0f20	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	4e3f95f9-c7b7-4858-86bc-81a76b29af74	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:11.357689
79a0ee07-1e7f-48b7-ac57-5da9ba9e5f6e	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	22d5703e-55e7-4dd4-8815-3e2c792b9ef2	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:11.407398
368fef4d-112e-4eda-a325-dd4b2b73422f	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	2bcf319a-9ac1-457e-9b88-16845235dd38	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:19.479466
da759d7e-c16e-4a10-b9c9-d5b37491c749	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	541725e0-a7ca-4bb1-9dc9-20dcb47bc056	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:19.546933
3c609089-8588-4a86-b561-2ce63707428d	LOGIN_SUCCESS	49a8b31b-c632-4e24-8740-bd4673554138	USER	auth	49a8b31b-c632-4e24-8740-bd4673554138	Successful login for username "natte".	{"username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 00:57:53.301638
0a3de4cc-4f65-4c52-8549-4072f2740a86	MLR_BATCH_RUN	49a8b31b-c632-4e24-8740-bd4673554138	USER	mlr_run_history	694cf4ba-58e0-4ffd-a823-8ff9d65f7a6c	Global analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:53.738262
23148891-aedd-4201-af6f-5b8d7982c9e5	MLR_BATCH_RUN	49a8b31b-c632-4e24-8740-bd4673554138	USER	mlr_run_history	0b156b78-14af-4d7b-b396-f4d6b31e6d09	Global analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:57:53.768986
3de3b817-319e-4774-ac5a-67328707f438	MLR_BATCH_RUN	49a8b31b-c632-4e24-8740-bd4673554138	USER	mlr_run_history	c6b79108-8432-489a-bc3f-638a9536ab65	Global analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:00.483752
a580238b-b2ee-4d58-9b21-380eaf236501	LOGIN_SUCCESS	b9cfd99b-4a07-4464-84bb-3c03fdd2395f	TEACHER	auth	b9cfd99b-4a07-4464-84bb-3c03fdd2395f	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 00:58:06.834011
af61230a-d935-4052-832c-1bd48cf38648	MLR_BATCH_RUN	b9cfd99b-4a07-4464-84bb-3c03fdd2395f	TEACHER	mlr_run_history	aa95b52b-dbe0-441c-99ae-d6532c078b3f	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:09.937748
33ea0631-a2ed-4c86-bb50-81c106ff413c	MLR_BATCH_RUN	b9cfd99b-4a07-4464-84bb-3c03fdd2395f	TEACHER	mlr_run_history	05b16e19-9051-4aa0-8dd0-9edd938750e0	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:09.974835
ec3fddb4-0391-42e0-8145-8fd91390a795	MLR_BATCH_RUN	b9cfd99b-4a07-4464-84bb-3c03fdd2395f	TEACHER	mlr_run_history	943926c3-a922-42ba-86d6-647584851ccf	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:11.706502
0f689e06-da81-41ea-bef4-bd3767b68870	MLR_BATCH_RUN	b9cfd99b-4a07-4464-84bb-3c03fdd2395f	TEACHER	mlr_run_history	bba35222-227a-46fb-8718-b2e08e8c2a97	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:11.756069
970c0be0-e671-4fbe-97dd-ebac51c184ec	LOGIN_SUCCESS	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	auth	64e25fea-5439-4a0d-a6b7-f72b58a28209	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 00:58:24.604769
8533df3a-2094-423e-a8df-4c3f880a6e95	USER_UPDATED	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	user	543e7e36-8aac-4bad-9728-8c22f024982f	Updated account "user2".	{"role": "USER", "isActive": true, "changedFields": ["fullName", "username", "password", "role", "isActive", "assignedTutorId"], "assignedTutorId": "b9cfd99b-4a07-4464-84bb-3c03fdd2395f"}	\N	\N	2026-04-29 00:58:40.319274
4c5f5485-80f2-4176-8695-f68c81486b0e	USER_ASSIGNED_TUTOR_UPDATED	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	user	543e7e36-8aac-4bad-9728-8c22f024982f	Updated assigned tutor for "user2".	{"nextAssignedTutorId": "b9cfd99b-4a07-4464-84bb-3c03fdd2395f", "previousAssignedTutorId": null}	\N	\N	2026-04-29 00:58:40.333738
9c2b4ba7-be37-46e1-b5d7-d114ac9d0839	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	096aca8b-6a31-450a-981b-76bbfa2a727f	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:42.287977
03bced33-73d2-4db2-b6d5-3b1de5c6a6e3	MLR_BATCH_RUN	64e25fea-5439-4a0d-a6b7-f72b58a28209	ADMIN	mlr_run_history	a753cc17-8437-4b20-b27f-432939a56a8d	Tutor analytics batch generation.	{"mse": null, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 1, "trainingSampleCount": 0}	\N	\N	2026-04-29 00:58:42.344647
3de4794c-8c65-4152-9c2b-29a8f4b47665	LOGIN_FAILED	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Failed login attempt for username "admin".	{"reason": "INVALID_PASSWORD", "username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 15:28:01.603289
ee47e09f-15fc-4b2a-bb5d-62125416da9e	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 15:28:04.147793
66082dc8-1afd-4d2b-8a38-f41358aa06d1	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 15:28:04.679882
a9159156-1bfa-4b43-93f3-8eef7fb95f7f	LOGIN_FAILED	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Failed login attempt for username "admin".	{"reason": "INVALID_PASSWORD", "username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 15:28:07.64536
2e98856f-517b-486c-82d7-15c1cd8199a0	LOGIN_SUCCESS	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Successful login for username "admin".	{"username": "admin"}	::1	node	2026-04-29 19:19:44.49538
026f0c45-e7e2-46af-9bc9-c7c1916e363b	LOGIN_SUCCESS	1d368d2a-4ff4-4a5e-b4f6-444f7f52bbc8	TEACHER	auth	1d368d2a-4ff4-4a5e-b4f6-444f7f52bbc8	Successful login for username "teacher1".	{"username": "teacher1"}	::1	node	2026-04-29 19:19:44.638968
220aee9f-97a1-488a-add7-9bb75456e25d	LOGIN_SUCCESS	74453a36-cf85-4aeb-b79d-c55ff4c4c865	USER	auth	74453a36-cf85-4aeb-b79d-c55ff4c4c865	Successful login for username "user1".	{"username": "user1"}	::1	node	2026-04-29 19:19:44.719235
e0384fce-6b26-44ad-9ba8-e99ae0ddba29	LOGIN_SUCCESS	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Successful login for username "admin".	{"username": "admin"}	::1	node	2026-04-29 19:20:33.276326
6b8933f3-5b19-48b4-9a76-39246636401d	LOGIN_SUCCESS	1d368d2a-4ff4-4a5e-b4f6-444f7f52bbc8	TEACHER	auth	1d368d2a-4ff4-4a5e-b4f6-444f7f52bbc8	Successful login for username "teacher1".	{"username": "teacher1"}	::1	node	2026-04-29 19:20:33.379057
5ae1b43e-8d77-4946-b2a9-8e6919ab5650	LOGIN_SUCCESS	74453a36-cf85-4aeb-b79d-c55ff4c4c865	USER	auth	74453a36-cf85-4aeb-b79d-c55ff4c4c865	Successful login for username "user1".	{"username": "user1"}	::1	node	2026-04-29 19:20:33.459507
7e5b1cb2-641c-4b9f-a1b7-1398ab7b0bc8	LOGIN_FAILED	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Failed login attempt for username "admin".	{"reason": "INVALID_PASSWORD", "username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:21:13.193473
804e8af4-82a1-45f7-96b7-b9009a189d87	LOGIN_FAILED	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Failed login attempt for username "admin".	{"reason": "INVALID_PASSWORD", "username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:13.018834
76292e6c-5ba5-4ce9-acc1-01dbdd63e91d	LOGIN_FAILED	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Failed login attempt for username "admin".	{"reason": "INVALID_PASSWORD", "username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:13.966413
ad00e08e-e147-4841-8a72-1b473434db2f	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:16.146969
5ee9e7dc-70ca-4e44-93bd-244cc7778d48	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:16.802351
60a59ebe-dca4-4c9c-97c3-00403b7b9c60	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:17.17863
f65395e9-8820-42fa-80bd-b6742a3bd9fd	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:17.64167
86d89d32-16f4-4741-936b-2437c91921ac	LOGIN_FAILED	\N	\N	auth	\N	Failed login attempt for username "natte".	{"reason": "USER_NOT_FOUND", "username": "natte"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:45.09441
8d265c29-3d2b-44c2-82f8-9a0c8001ba66	LOGIN_FAILED	e1712459-a2c1-417b-a587-52c898adb923	ADMIN	auth	e1712459-a2c1-417b-a587-52c898adb923	Failed login attempt for username "admin".	{"reason": "INVALID_PASSWORD", "username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:47.657716
3f3dad8b-8d65-4b2d-ac8d-dae4b9608243	LOGIN_SUCCESS	74453a36-cf85-4aeb-b79d-c55ff4c4c865	USER	auth	74453a36-cf85-4aeb-b79d-c55ff4c4c865	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:24:51.474503
407b6962-ab95-4833-b5b4-1edde0faf56f	LOGIN_SUCCESS	5a521b58-2b38-4fe7-9e54-8adadd7f418f	ADMIN	auth	5a521b58-2b38-4fe7-9e54-8adadd7f418f	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:25:51.843926
e66f6e14-d006-4507-8108-bf6bfd078b1e	MLR_BATCH_RUN	5a521b58-2b38-4fe7-9e54-8adadd7f418f	ADMIN	mlr_run_history	306d5fb3-2c20-4727-a887-839e4dd5931a	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:26:13.089647
a8ba30a8-b09c-4018-96bd-bf748aedaa54	MLR_BATCH_RUN	5a521b58-2b38-4fe7-9e54-8adadd7f418f	ADMIN	mlr_run_history	4a4286e9-9dcd-4a24-a681-eee3ee6b87eb	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:26:13.150487
32ee0b7f-254b-40bd-ac1a-76b17382062a	LOGIN_SUCCESS	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	auth	32717cec-19fa-44f2-9a39-421ec4450e37	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:27:14.696565
87eac607-3c3d-4df0-a0bc-3d7253551e07	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	4e4d063b-59fd-40f7-840b-72e522c6cb60	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:27:23.644509
b96845fe-bb68-443c-ab3a-d491de81e182	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	747832e2-0c51-4798-beb6-698146c7b543	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:27:23.690532
bba15125-8764-42e6-b0ce-a12169a83446	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	8b19a370-c54a-4933-a708-0a9c1874b5e3	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:27:24.604965
4d20a41f-f757-4621-ad7a-3189e89d9da7	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	27d37ec9-9d2b-4e3d-9a8b-fad61540c7eb	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:27:24.647643
acc60d5a-b94c-4536-91dd-44520bf40679	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	d7e8c01f-9a09-4c3b-a6c6-88b814f811f7	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:27:27.77418
41589265-60c7-4279-8168-2f427feaf38f	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	bfdddd56-48fe-430b-a991-783ada7289ac	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:27:27.839129
a7553159-01ea-4c83-ab62-d1abab002b49	LOGIN_SUCCESS	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	USER	auth	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:28:58.932358
4584f073-24b0-46d1-aaec-bba9291f39f8	LOGIN_SUCCESS	5a521b58-2b38-4fe7-9e54-8adadd7f418f	ADMIN	auth	5a521b58-2b38-4fe7-9e54-8adadd7f418f	Successful login for username "admin".	{"username": "admin"}	::1	node	2026-04-29 19:31:38.542743
35bcda30-837d-43f6-9cdb-db9189a4c1fb	LOGIN_SUCCESS	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	auth	32717cec-19fa-44f2-9a39-421ec4450e37	Successful login for username "teacher1".	{"username": "teacher1"}	::1	node	2026-04-29 19:31:38.643026
4f25266b-8472-4a2a-aceb-20894c67c0c7	LOGIN_SUCCESS	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	USER	auth	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	Successful login for username "user1".	{"username": "user1"}	::1	node	2026-04-29 19:31:38.725499
196a14e3-2fee-4461-b342-1f4c2975d4c9	LOGIN_SUCCESS	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	USER	auth	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:33:06.142734
d11ae786-d767-4016-aa87-9ad9bb96f68a	LOGIN_SUCCESS	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	auth	32717cec-19fa-44f2-9a39-421ec4450e37	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:33:27.720268
dfb833ae-ca62-4955-883f-cd35d162a90e	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	073d37db-2c19-462a-8b9c-8f97163cc828	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:33:31.584791
f022f937-4cf3-40c1-a55f-06b3a16efd68	MLR_BATCH_RUN	32717cec-19fa-44f2-9a39-421ec4450e37	TEACHER	mlr_run_history	1fbf91a3-81aa-43ad-a787-24904f03c4eb	Tutor analytics batch generation.	{"mse": 0.02590094053282079, "fallbackUsed": false, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 19:33:31.625184
7b35d278-5f54-4495-952c-8cde1adea0d0	LOGIN_SUCCESS	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	USER	auth	730d361f-cc68-468b-9f7c-b3c2f5d8e92f	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:35:14.23533
9188af71-b95b-4c92-b727-ff611f28cf8f	LOGIN_SUCCESS	5a521b58-2b38-4fe7-9e54-8adadd7f418f	ADMIN	auth	5a521b58-2b38-4fe7-9e54-8adadd7f418f	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 19:50:15.919874
50bef396-1c76-49d5-b4e9-e5e3153f5e0f	LOGIN_SUCCESS	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	auth	9a5f4e73-152d-4869-bf4f-376b0412c572	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:00:34.343704
a088de49-37ac-4d4e-b040-456d156add0c	MLR_BATCH_RUN	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	mlr_run_history	7f83d6e2-6ffc-468b-b4e6-620b0940bd59	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:00:51.052528
f8c688b1-7752-4dba-b166-b932cb9e9347	MLR_BATCH_RUN	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	mlr_run_history	2a2a61ab-0d39-430b-874f-1c6a35924a09	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:00:51.10014
65e39747-617d-47a9-bf4f-2ba9952ab3eb	MLR_BATCH_RUN	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	mlr_run_history	39de40f6-cf72-4327-bbd3-da57a6f9e8c2	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:01:05.231247
f2f8ae8d-cbd6-4ef8-b74c-d911616675d0	MLR_BATCH_RUN	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	mlr_run_history	a71ba1dd-68b7-42b4-ab0d-86ed49335d48	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:01:05.280018
972f535c-327e-43a3-9dfb-94475453f4c2	MLR_BATCH_RUN	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	mlr_run_history	fc9a3a4b-859f-486e-af5a-79ab7a760ff4	Analytics Excel export generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:01:16.86269
7fd177da-6011-4b15-a934-829255d31635	ANALYTICS_EXPORTED	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	analytics_export	fc9a3a4b-859f-486e-af5a-79ab7a760ff4	Exported analytics workbook.	{"mse": 73.31943519999997, "mlrRunHistoryId": "fc9a3a4b-859f-486e-af5a-79ab7a760ff4", "predictionCount": 7}	\N	\N	2026-04-29 20:01:17.067633
91530984-6c23-4a48-843b-3767bee2b26a	LOGIN_SUCCESS	9a5f4e73-152d-4869-bf4f-376b0412c572	ADMIN	auth	9a5f4e73-152d-4869-bf4f-376b0412c572	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:04:43.103975
95183472-b483-484b-b798-9e585b23856c	LOGIN_SUCCESS	e59e2fc7-e92d-4854-b50e-0ee82e849656	USER	auth	e59e2fc7-e92d-4854-b50e-0ee82e849656	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:04:48.611412
d44fb1bb-96d4-43fc-8a09-369e4932958f	LOGIN_SUCCESS	e59e2fc7-e92d-4854-b50e-0ee82e849656	USER	auth	e59e2fc7-e92d-4854-b50e-0ee82e849656	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:11:14.767902
f2cdb39c-d44a-4b8d-87bc-3ea7a9ed7174	LOGIN_SUCCESS	e59e2fc7-e92d-4854-b50e-0ee82e849656	USER	auth	e59e2fc7-e92d-4854-b50e-0ee82e849656	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:11:27.271213
546c5854-6a7b-4e89-afb8-271a8bbb5b6c	LOGIN_SUCCESS	5e885aff-3195-496c-8b68-7ca2686e2c53	USER	auth	5e885aff-3195-496c-8b68-7ca2686e2c53	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:19:04.52826
89b7c6ad-7984-46d5-9195-76123cf153f4	LOGIN_SUCCESS	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	auth	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:19:56.322718
f9db7958-662d-4aeb-836d-1c761d359579	LOGIN_SUCCESS	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	auth	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:25:51.821519
3315c0c7-433d-43b5-8125-74f081f338ac	MLR_BATCH_RUN	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	mlr_run_history	08054951-d074-4b32-8631-06dc502012d0	Analytics Excel export generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:25:56.304554
1d55777c-e04a-4fd6-a78a-e1c1181af374	ANALYTICS_EXPORTED	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	analytics_export	08054951-d074-4b32-8631-06dc502012d0	Exported analytics workbook.	{"mse": 73.31943519999997, "mlrRunHistoryId": "08054951-d074-4b32-8631-06dc502012d0", "predictionCount": 7}	\N	\N	2026-04-29 20:25:56.421928
4bc7dd26-7aaf-4030-9648-80b97762d842	MLR_BATCH_RUN	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	mlr_run_history	cf22cc05-b986-45a5-9d9c-387a1dacb8ae	Analytics Excel export generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:26:15.91671
726084a3-b099-4a3c-8db6-e2dd00567317	ANALYTICS_EXPORTED	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	analytics_export	cf22cc05-b986-45a5-9d9c-387a1dacb8ae	Exported analytics workbook.	{"mse": 73.31943519999997, "mlrRunHistoryId": "cf22cc05-b986-45a5-9d9c-387a1dacb8ae", "predictionCount": 7}	\N	\N	2026-04-29 20:26:15.97489
b1d02f5d-42fc-4e96-aa40-af49904ef465	MLR_BATCH_RUN	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	mlr_run_history	ae13fb9c-3e47-4ff5-a3d3-2fc135f0defa	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:26:22.127464
a3f3f979-d5ab-4fa8-94de-75dbedb1001b	MLR_BATCH_RUN	0afbae8e-4bad-45d2-aadc-ca020cc36d7d	ADMIN	mlr_run_history	5e13ef8c-c786-4c17-96f3-4b4e364ce2f4	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:26:22.194757
7aa2dff4-63fe-4813-85d4-be61125e6628	LOGIN_SUCCESS	d69c4756-36f7-47d2-851b-87ad407c942f	TEACHER	auth	d69c4756-36f7-47d2-851b-87ad407c942f	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:26:55.486971
abff11ec-ad7c-4a4f-83ad-cd953504eb13	ATTENDANCE_CREATED	d69c4756-36f7-47d2-851b-87ad407c942f	TEACHER	attendance	a90bff34-e8fe-41de-8ed3-69de15d113d1	Created attendance for user "eb4876c4-2ede-4acd-b021-9b01f6134129" on "2026-04-29".	{"date": "2026-04-29", "status": "ABSENT", "userId": "eb4876c4-2ede-4acd-b021-9b01f6134129"}	\N	\N	2026-04-29 20:27:22.329574
f94c9e20-65f6-42e4-b78d-9b3ea26e4938	MLR_BATCH_RUN	d69c4756-36f7-47d2-851b-87ad407c942f	TEACHER	mlr_run_history	ceff450c-4864-4ae4-a143-3222ad9ef252	Tutor analytics batch generation.	{"mse": 74.05722719999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:27:27.11241
fc058390-cb11-411f-8da5-f169b8e9e053	MLR_BATCH_RUN	d69c4756-36f7-47d2-851b-87ad407c942f	TEACHER	mlr_run_history	abf5e818-d29c-4aff-b797-60a12f2f14cf	Tutor analytics batch generation.	{"mse": 74.05722719999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-29 20:27:27.185352
c736dc39-b03c-4a8a-9f0b-fdf3c763911a	LOGIN_SUCCESS	eb4876c4-2ede-4acd-b021-9b01f6134129	USER	auth	eb4876c4-2ede-4acd-b021-9b01f6134129	Successful login for username "user2".	{"username": "user2"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-29 20:27:39.244444
09afacbf-2650-4ff3-a04b-a0b6a42cf6a2	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 20:59:59.708358
20e2a765-9f2d-4ffb-a0eb-5a104281c559	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	32707906-bcd8-40a8-a396-1a9fbb5b3438	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-30 21:00:11.954565
83e9b96e-0f08-4287-be7a-1bb520146f58	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	fa357726-952f-41c0-9365-14d72ad9baab	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-30 21:00:12.017438
ccfecd65-6be5-4477-b165-751146032935	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 21:00:21.632014
2ccb8edc-dea7-4968-9b1b-a0b9c8e3849b	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 21:10:14.92677
7237ec6b-f21b-459a-92d4-7619af86eb8d	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 21:10:23.129159
ef506f4d-29db-4a74-ab2f-2a952b85ee85	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 21:43:19.566417
cc2c28ee-30cd-45e8-8b5f-dccd80918194	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	9e8bcf76-27b3-40ea-8b50-3367bbf9e74d	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-30 21:43:40.507484
6b44465d-296a-4278-8c9e-73191b5c7d96	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	a8460bee-0718-45a3-b7df-5dff91473767	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-04-30 21:43:40.596962
37e246b5-41d8-4c09-a755-896315f938da	USER_UPDATED	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	user	1d237f55-d1c7-4800-8ee8-2237944e7791	Deleted account "user8".	{"role": "USER", "deleted": true, "isActive": false, "assignedTutorId": "fb34dd3f-655d-43ac-806a-c396af627252"}	\N	\N	2026-04-30 21:43:48.915953
5e65345f-5277-481f-84b9-88eba1dde1fa	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 21:43:58.036478
28c7ac9b-216b-430a-b516-193ae0d1f55c	LOGIN_SUCCESS	02524791-420d-4e5a-b922-0943ea116476	TEACHER	auth	02524791-420d-4e5a-b922-0943ea116476	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 21:44:35.017474
67ebb497-861b-4115-92d5-f3354dace259	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	40329241-66be-4193-b5dc-7b9fbc260c78	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-30 21:54:21.933313
75bab755-43b1-4101-83fc-cf0b4826dfa6	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	4180e40f-11f3-4c3b-be2e-749acbbf5790	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-30 22:01:00.656914
f7310ffe-cb74-4533-bff6-a7f3b30587e6	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	dd4d8bca-faca-43b3-a3f0-c607d1111a8d	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-30 22:01:35.815857
bb204814-0e88-4b7b-8963-741502060159	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	2ef145b7-53fc-4206-b986-7f603125d6bd	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-30 22:01:42.827494
faf8ca98-f98f-4069-9525-2ecaab00abed	LOGIN_SUCCESS	02524791-420d-4e5a-b922-0943ea116476	TEACHER	auth	02524791-420d-4e5a-b922-0943ea116476	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 22:02:13.567637
2fb29e5f-72b3-4cbe-8fc8-1d7d83be596f	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	ad372e2b-cfb5-4faf-bb6f-13cb6dc133ab	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-30 22:02:14.138811
bc9b0429-ee6b-4810-b6e5-e3730a19b331	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	044428ab-844d-4e21-bb8d-d222d4c53bfe	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-04-30 22:02:14.18162
f156c1ef-b16e-4712-a18e-85b50bb4d2fd	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 22:02:21.347705
9ee62db3-921a-4a9e-a035-3343d09d2336	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-04-30 22:02:44.931279
a8b64fdc-0da3-44b6-9f21-111e2af2e9d2	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-01 21:00:25.461593
c7ec1167-0894-48b6-a1a8-7fb47dd13691	LOGIN_SUCCESS	02524791-420d-4e5a-b922-0943ea116476	TEACHER	auth	02524791-420d-4e5a-b922-0943ea116476	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-01 21:01:18.023663
dc2f5d46-c9c8-497c-8b4f-b876198e3178	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	cd899ee0-9acd-4321-a65f-9966c4f82392	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-01 21:01:18.320957
c37b11e2-2c9f-4239-988f-fcd714438744	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	0069b6d3-279f-4935-954c-9c07eaa918e3	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-01 21:01:18.386496
6871452b-54f2-45f4-8af2-713bdab5f653	LOGIN_SUCCESS	c60fc6de-46f8-482c-922b-7f684b5263b1	USER	auth	c60fc6de-46f8-482c-922b-7f684b5263b1	Successful login for username "user3".	{"username": "user3"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-01 21:01:30.438848
100b74cf-635f-40f8-a81e-ecec70ad62fa	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-01 21:04:52.824836
4b57a907-9e1e-43a9-8dba-26886746cd26	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:16:33.782877
fbf1cf59-36aa-4af3-879d-a3fff855cfba	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	e3600a42-92be-4640-9cf6-877487af2544	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:18:11.497384
ae60e050-a719-4223-a690-58ce6a43222b	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	eefeeb57-5c47-4ba9-8360-d511899cc78c	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:18:11.650127
d1fed277-93c1-4f01-be6b-3362a1e415b7	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	3d17b002-1cb7-4ee5-8de3-7951ecf364b5	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:18:54.375887
9956a633-50ea-41f3-ac14-3cfccc24e0be	MLR_BATCH_RUN	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	mlr_run_history	85ad370a-c5bf-4d1f-890c-5ab98c3950a3	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 7, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:18:54.450591
509032d2-6eba-45ad-91fe-5fd1ab5c76e5	LOGIN_SUCCESS	02524791-420d-4e5a-b922-0943ea116476	TEACHER	auth	02524791-420d-4e5a-b922-0943ea116476	Successful login for username "teacher1".	{"username": "teacher1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:19:08.725198
5c83308c-f807-41f5-8179-9d9b764c220f	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	782e9fa8-c387-48a7-b965-77895a4f0343	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:19:08.920043
6b0238c7-f93d-48f1-abcb-7a572346a2f8	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	12acbe32-65cb-4ec4-ac75-181ea910deec	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:19:08.957892
d28e46f7-6558-4ba2-80a5-34e13109ab84	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	fb42574b-e5e3-40ff-abe6-360e31e04568	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:19:19.176672
6cf368fb-7841-4917-bbc9-f290e246dd66	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	98e8b5ed-7410-4ecf-873a-b54deae231d0	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:19:19.256302
2e429b09-5583-461d-bc61-aa3dad8e8e40	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	043103c0-cf5b-406e-a696-60bef26c8d91	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:19:21.838256
717e9579-ec91-44f3-bd74-d0f9734fe96a	MLR_BATCH_RUN	02524791-420d-4e5a-b922-0943ea116476	TEACHER	mlr_run_history	e91039e1-801d-49d8-b28d-7318df05c5ac	Tutor analytics batch generation.	{"mse": 73.31943519999997, "fallbackUsed": true, "coefficientMode": "AUTO_TRAINED", "predictionCount": 4, "trainingSampleCount": 5}	\N	\N	2026-05-03 18:19:21.89079
7823e846-1371-4f16-aed5-a816387731a5	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:19:26.689357
426315de-757d-4e22-a59d-8ed584ad1953	LOGIN_SUCCESS	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	USER	auth	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	Successful login for username "user1".	{"username": "user1"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:19:57.910117
390f9cc1-510f-4818-89c9-db09a7d03cbd	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:26:22.973445
f6ad6c4e-4f35-45a7-9842-4c4f16b19bfe	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:26:52.21574
00372388-87b2-4d21-8c2f-58f5a56f23b3	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	2026-05-03 18:37:10.923394
c088596f-8074-4aa2-8c76-6f359b77cdcb	LOGIN_SUCCESS	1192869c-34b8-46e6-9a49-26fec400302d	ADMIN	auth	1192869c-34b8-46e6-9a49-26fec400302d	Successful login for username "admin".	{"username": "admin"}	::1	Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1	2026-05-03 18:37:21.807649
\.


--
-- Data for Name: intervention_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intervention_notes (id, "userId", "createdById", "riskLevel", "predictedScore", note, "actionPlan", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: mlr_run_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mlr_run_history (id, "generatedAt", "generatedById", "coefficientMode", intercept, "attendanceCoefficient", "tryoutCoefficient", mse, "totalUserCount", "activeUserCount", "eligibleUserCount", "excludedUserCount", "excludedInactiveCount", "excludedInsufficientTryoutCount", "excludedNullScoreCount", "trainingSampleCount", "predictionCount", "fallbackUsed", "fallbackReason", notes, "createdAt", "teacherObjectiveCoefficient") FROM stdin;
32707906-bcd8-40a8-a396-1a9fbb5b3438	2026-04-30 21:00:11.937	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	10	9	7	3	1	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 21:00:11.939807	0.1
fa357726-952f-41c0-9365-14d72ad9baab	2026-04-30 21:00:11.997	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	10	9	7	3	1	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 21:00:11.99993	0.1
9e8bcf76-27b3-40ea-8b50-3367bbf9e74d	2026-04-30 21:43:40.49	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	10	9	7	3	1	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 21:43:40.49172	0.1
a8460bee-0718-45a3-b7df-5dff91473767	2026-04-30 21:43:40.569	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	10	9	7	3	1	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 21:43:40.570574	0.1
40329241-66be-4193-b5dc-7b9fbc260c78	2026-04-30 21:54:21.92	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 21:54:21.920758	0.1
4180e40f-11f3-4c3b-be2e-749acbbf5790	2026-04-30 22:01:00.644	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 22:01:00.645699	0.1
dd4d8bca-faca-43b3-a3f0-c607d1111a8d	2026-04-30 22:01:35.805	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 22:01:35.80645	0.1
2ef145b7-53fc-4206-b986-7f603125d6bd	2026-04-30 22:01:42.81	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 22:01:42.812079	0.1
ad372e2b-cfb5-4faf-bb6f-13cb6dc133ab	2026-04-30 22:02:14.126	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 22:02:14.127154	0.1
044428ab-844d-4e21-bb8d-d222d4c53bfe	2026-04-30 22:02:14.17	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-04-30 22:02:14.171446	0.1
cd899ee0-9acd-4321-a65f-9966c4f82392	2026-05-01 21:01:18.301	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-01 21:01:18.304047	0.1
0069b6d3-279f-4935-954c-9c07eaa918e3	2026-05-01 21:01:18.372	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-01 21:01:18.373272	0.1
e3600a42-92be-4640-9cf6-877487af2544	2026-05-03 18:18:11.422	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:18:11.424133	0.1
eefeeb57-5c47-4ba9-8360-d511899cc78c	2026-05-03 18:18:11.607	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:18:11.608681	0.1
3d17b002-1cb7-4ee5-8de3-7951ecf364b5	2026-05-03 18:18:54.361	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:18:54.363729	0.1
85ad370a-c5bf-4d1f-890c-5ab98c3950a3	2026-05-03 18:18:54.423	1192869c-34b8-46e6-9a49-26fec400302d	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	7	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:18:54.425472	0.1
782e9fa8-c387-48a7-b965-77895a4f0343	2026-05-03 18:19:08.903	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:19:08.905314	0.1
12acbe32-65cb-4ec4-ac75-181ea910deec	2026-05-03 18:19:08.948	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:19:08.95044	0.1
fb42574b-e5e3-40ff-abe6-360e31e04568	2026-05-03 18:19:19.161	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:19:19.163226	0.1
98e8b5ed-7410-4ecf-873a-b54deae231d0	2026-05-03 18:19:19.22	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:19:19.222211	0.1
043103c0-cf5b-406e-a696-60bef26c8d91	2026-05-03 18:19:21.817	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:19:21.819457	0.1
e91039e1-801d-49d8-b28d-7318df05c5ac	2026-05-03 18:19:21.876	02524791-420d-4e5a-b922-0943ea116476	AUTO_TRAINED	0	0.4	0.5	73.31943519999997	9	9	7	2	0	2	0	5	4	t	Coefficient fitting failed because the training matrix is singular.	Tutor analytics batch generation.	2026-05-03 18:19:21.878	0.1
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.records (id, "userId", "mathematicsScore", "logicalReasoningScore", "englishScore", "teacherFeedback", "createdAt", "mathScore", "logicScore", "averageScore", "actualExamScore", "examDate", "examLabel", "isUsedForTraining", "updatedAt", "teacherObjectiveScore") FROM stdin;
32a14b01-cf18-468e-a30e-9baad0cd2f2a	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	91	90	88	Excellent consistency and strong analytical focus.	2026-04-30 20:59:22.2602	91	90	89.67	89	2026-01-10	Diagnostic 1	t	2026-04-30 20:59:22.2602	87.67
208f44f6-004e-4f92-866b-ca88de9882f3	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	90	92	89	Keeps strong momentum across all competencies.	2026-04-30 20:59:22.2602	90	92	90.33	90	2026-02-11	Diagnostic 2	t	2026-04-30 20:59:22.2602	91.33
b11951da-1ae1-4109-bd7f-a2b024615a82	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	93	91	90	Feedback is complete and performance is stable.	2026-04-30 20:59:22.2602	93	91	91.33	92	2026-03-12	Diagnostic 3	t	2026-04-30 20:59:22.2602	91.33
7283c7bd-4ec4-461a-bc80-9ed257b489b8	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	92	90	91	Shows reliable exam readiness.	2026-04-30 20:59:22.2602	92	90	91	91	2026-04-13	Diagnostic 4	t	2026-04-30 20:59:22.2602	93
0c8833c0-5e06-4f92-81b6-715f8148b366	84164b5d-a3fe-4abb-b1b3-85f3982a6b03	94	92	93	Top-tier demo sample for safe-zone prediction.	2026-04-30 20:59:22.2602	94	92	93	93	2026-05-14	Diagnostic 5	t	2026-04-30 20:59:22.2602	92
14520306-aec3-40fb-95ec-377a4df5cb5f	0bbafb53-a86f-4de6-a8af-09c3215025f6	85	87	84	Strong performance with room to refine pacing.	2026-04-30 20:59:22.2602	85	87	85.33	84	2026-01-10	Benchmark 1	t	2026-04-30 20:59:22.2602	83.33
d3a0aea5-9214-42cc-a22b-75319841add5	0bbafb53-a86f-4de6-a8af-09c3215025f6	86	85	83	Feedback completed with positive progress.	2026-04-30 20:59:22.2602	86	85	84.67	85	2026-02-11	Benchmark 2	t	2026-04-30 20:59:22.2602	85.67
806aed41-d929-482f-9bd4-edc62d6b8ad9	0bbafb53-a86f-4de6-a8af-09c3215025f6	88	86	84	Maintains healthy tryout momentum.	2026-04-30 20:59:22.2602	88	86	86	86	2026-03-12	Benchmark 3	t	2026-04-30 20:59:22.2602	86
02145570-fa3d-41af-bd51-53e4da992e8d	0bbafb53-a86f-4de6-a8af-09c3215025f6	87	88	85	Consistent completion and focus.	2026-04-30 20:59:22.2602	87	88	86.67	87	2026-04-13	Benchmark 4	t	2026-04-30 20:59:22.2602	88.67
09ec8dea-c566-49b4-916c-c30d91a72245	0bbafb53-a86f-4de6-a8af-09c3215025f6	89	87	86	Safe-zone sample with complete records.	2026-04-30 20:59:22.2602	89	87	87.33	88	2026-05-14	Benchmark 5	t	2026-04-30 20:59:22.2602	86.33
c3aca518-3de1-4841-b561-9da0c4d6b7d0	c60fc6de-46f8-482c-922b-7f684b5263b1	67	64	66	Needs structured recovery on core concepts.	2026-04-30 20:59:22.2602	67	64	65.67	65	2026-01-10	Intervention 1	t	2026-04-30 20:59:22.2602	63.67
77ce244d-a684-4e70-bc11-f858a941042d	c60fc6de-46f8-482c-922b-7f684b5263b1	65	63	64	Tryout quality is below safe benchmark.	2026-04-30 20:59:22.2602	65	63	64	64	2026-02-11	Intervention 2	t	2026-04-30 20:59:22.2602	65
2aef1d89-3151-41ef-b477-21197bc74738	c60fc6de-46f8-482c-922b-7f684b5263b1	68	65	67	Teacher feedback confirms intervention need.	2026-04-30 20:59:22.2602	68	65	66.67	66	2026-03-12	Intervention 3	t	2026-04-30 20:59:22.2602	66.67
487ee72d-2314-452c-837b-b1c04dd337be	c60fc6de-46f8-482c-922b-7f684b5263b1	66	62	65	Performance dips when attendance slips.	2026-04-30 20:59:22.2602	66	62	64.33	63	2026-04-13	Intervention 4	t	2026-04-30 20:59:22.2602	66.33
5e227c6c-ec2f-4a80-8e7a-3d62c8564f3d	c60fc6de-46f8-482c-922b-7f684b5263b1	69	64	66	Useful at-risk demo sample.	2026-04-30 20:59:22.2602	69	64	66.33	65	2026-05-14	Intervention 5	t	2026-04-30 20:59:22.2602	65.33
4cd4a3e3-3543-4878-9d21-32e0c52d8498	80adb604-99a6-4b85-bf98-8d812ff9fa5e	78	80	79	Tryout base is decent but attendance is unstable.	2026-04-30 20:59:22.2602	78	80	79	77	2026-01-10	Recovery 1	t	2026-04-30 20:59:22.2602	77
06aa1f41-6679-49d6-9dc2-f8a41c702c63	80adb604-99a6-4b85-bf98-8d812ff9fa5e	80	78	77	Needs stronger session consistency.	2026-04-30 20:59:22.2602	80	78	78.33	78	2026-02-11	Recovery 2	t	2026-04-30 20:59:22.2602	79.33
ab8ee43e-12ae-405d-a177-a36eebeef83d	80adb604-99a6-4b85-bf98-8d812ff9fa5e	79	81	78	Feedback completed for monitoring.	2026-04-30 20:59:22.2602	79	81	79.33	79	2026-03-12	Recovery 3	t	2026-04-30 20:59:22.2602	79.33
2cafe48e-e049-4158-a8de-19a016e132a9	80adb604-99a6-4b85-bf98-8d812ff9fa5e	77	79	76	Performance can recover with better attendance.	2026-04-30 20:59:22.2602	77	79	77.33	77	2026-04-13	Recovery 4	t	2026-04-30 20:59:22.2602	79.33
61b86c76-1ced-462b-9b24-450e58f65b3e	80adb604-99a6-4b85-bf98-8d812ff9fa5e	81	80	79	Balanced profile with medium risk potential.	2026-04-30 20:59:22.2602	81	80	80	80	2026-05-14	Recovery 5	t	2026-04-30 20:59:22.2602	79
a0689157-4de3-4966-8ee1-3f6fc1d497b0	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	88	90	87	High-achieving sample for safe-zone analytics.	2026-04-30 20:59:22.2602	88	90	88.33	89	2026-01-10	Mastery 1	t	2026-04-30 20:59:22.2602	86.33
badae7cc-94eb-47a1-9701-ba8afbd2d89b	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	89	88	90	Feedback confirms strong exam readiness.	2026-04-30 20:59:22.2602	89	88	89	88	2026-02-11	Mastery 2	t	2026-04-30 20:59:22.2602	90
86380080-f176-4f5a-b795-204f91ac86e0	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	90	89	88	Consistent training-quality dataset.	2026-04-30 20:59:22.2602	90	89	89	90	2026-03-12	Mastery 3	t	2026-04-30 20:59:22.2602	89
51296b2c-89ee-42c3-9912-f856d962dbff	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	91	90	89	Strong performance with completed feedback.	2026-04-30 20:59:22.2602	91	90	90	91	2026-04-13	Mastery 4	t	2026-04-30 20:59:22.2602	92
f3661278-a0c3-4016-a023-6e3bc4170372	0cef1ee2-4aaf-4beb-aff8-a56e449436d6	89	91	90	Another safe-zone sample with valid MSE.	2026-04-30 20:59:22.2602	89	91	90	90	2026-05-14	Mastery 5	t	2026-04-30 20:59:22.2602	89
4c098cb6-de0d-407c-9dbf-3a8221954fee	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	73	75	74	Feedback completed while monitoring improvement.	2026-04-30 20:59:22.2602	73	75	74	\N	2026-01-10	Practice 1	t	2026-04-30 20:59:22.2602	72
345138fe-846a-484b-9a93-069061e97eff	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	74	73	75	Ground truth pending but complete training sample.	2026-04-30 20:59:22.2602	74	73	74	\N	2026-02-11	Practice 2	t	2026-04-30 20:59:22.2602	75
4b7a4b42-d09e-47b9-8301-b578d3d4243d	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	76	74	75	Useful eligible sample without actual exam score.	2026-04-30 20:59:22.2602	76	74	75	\N	2026-03-12	Practice 3	t	2026-04-30 20:59:22.2602	75
af816540-edfa-4934-9f81-7c319b57737e	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	75	76	74	Can support tutor averages and eligibility.	2026-04-30 20:59:22.2602	75	76	75	\N	2026-04-13	Practice 4	t	2026-04-30 20:59:22.2602	77
cda5f2b3-2303-46b1-b56b-12c7ad1d86ee	9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	77	75	76	Stable, moderate demo sample.	2026-04-30 20:59:22.2602	77	75	76	\N	2026-05-14	Practice 5	t	2026-04-30 20:59:22.2602	75
6bd648f5-63d5-46c4-bb77-605ce138f1b2	75050bc8-0c4a-4d3b-be88-12d5536778a3	70	68	69	Needs closer tryout support.	2026-04-30 20:59:22.2602	70	68	69	\N	2026-01-10	Support 1	t	2026-04-30 20:59:22.2602	67
3ea97aab-48dd-46ce-8b89-f6712f9217e0	75050bc8-0c4a-4d3b-be88-12d5536778a3	71	69	70	Feedback keeps the user inside monitoring scope.	2026-04-30 20:59:22.2602	71	69	70	\N	2026-02-11	Support 2	t	2026-04-30 20:59:22.2602	71
4737ba6f-7990-45c9-b686-9a5cfa570d39	75050bc8-0c4a-4d3b-be88-12d5536778a3	69	70	68	Scores are complete and training-ready.	2026-04-30 20:59:22.2602	69	70	69	\N	2026-03-12	Support 3	t	2026-04-30 20:59:22.2602	69
1f68da6d-a255-4495-9163-97917e1fa532	75050bc8-0c4a-4d3b-be88-12d5536778a3	72	71	70	Valid but at-risk sample without actual exam score.	2026-04-30 20:59:22.2602	72	71	71	\N	2026-04-13	Support 4	t	2026-04-30 20:59:22.2602	73
7d9b395c-6ff6-41c9-babf-1900f3c721a1	75050bc8-0c4a-4d3b-be88-12d5536778a3	70	69	71	Supports early warning demonstration.	2026-04-30 20:59:22.2602	70	69	70	\N	2026-05-14	Support 5	t	2026-04-30 20:59:22.2602	69
cef2480d-19a2-4647-834f-1ee2f60d80f7	7585de50-6bf7-49d6-bfae-5740892a2e5f	79	78	77	Eligible-looking start but incomplete total count.	2026-04-30 20:59:22.2602	79	78	78	\N	2026-01-10	Incomplete 1	t	2026-04-30 20:59:22.2602	76
d32d793b-9cd1-4063-a3d8-e99830282ec2	7585de50-6bf7-49d6-bfae-5740892a2e5f	80	79	78	Below minimum complete tryout requirement.	2026-04-30 20:59:22.2602	80	79	79	\N	2026-02-11	Incomplete 2	t	2026-04-30 20:59:22.2602	80
9a055433-231e-46dc-9127-5108e34a29b5	7585de50-6bf7-49d6-bfae-5740892a2e5f	78	77	79	Used to demonstrate insufficient tryout exclusion.	2026-04-30 20:59:22.2602	78	77	78	\N	2026-03-12	Incomplete 3	t	2026-04-30 20:59:22.2602	78
998c6125-0480-4ef4-a918-bc0c21c7e249	7585de50-6bf7-49d6-bfae-5740892a2e5f	81	80	79	Still under the minimum 5 complete tryout rule.	2026-04-30 20:59:22.2602	81	80	80	\N	2026-04-13	Incomplete 4	t	2026-04-30 20:59:22.2602	82
00514ead-2141-40ee-b3a9-75b3882adfbd	7585de50-6bf7-49d6-bfae-5740892a2e5f	82	0	0	\N	2026-04-30 20:59:22.2602	82	0	27.33	\N	2026-05-14	Incomplete 5	f	2026-04-30 20:59:22.2602	76
7c4117aa-1fc4-48ac-b89b-4ef53326703f	e40c050d-1705-4911-98ef-4aa4743e0140	84	83	82	Contains one valid record but also null-score rows for exclusion demo.	2026-04-30 20:59:22.2602	84	83	83	\N	2026-01-10	Null Mix 1	t	2026-04-30 20:59:22.2602	\N
46c6c6b0-f871-4940-956a-cc2129871501	e40c050d-1705-4911-98ef-4aa4743e0140	85	84	83	\N	2026-04-30 20:59:22.2602	85	84	84	\N	2026-02-11	Null Mix 2	t	2026-04-30 20:59:22.2602	\N
d074229e-81e6-4130-aef4-c8ade677906e	e40c050d-1705-4911-98ef-4aa4743e0140	83	82	81	\N	2026-04-30 20:59:22.2602	83	82	82	\N	2026-03-12	Null Mix 3	t	2026-04-30 20:59:22.2602	\N
4d3581e2-208d-4bcc-b2b6-9249468cb59f	e40c050d-1705-4911-98ef-4aa4743e0140	82	81	80	\N	2026-04-30 20:59:22.2602	82	81	81	\N	2026-04-13	Null Mix 4	t	2026-04-30 20:59:22.2602	\N
ff02bd3e-cc11-44a9-8f97-13e60371f480	e40c050d-1705-4911-98ef-4aa4743e0140	0	84	83	\N	2026-04-30 20:59:22.2602	0	84	55.67	\N	2026-05-14	Null Mix 5	f	2026-04-30 20:59:22.2602	74
\.


--
-- Data for Name: system_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_config (id, "x1Weight", "x2Weight", "x3Weight", "createdAt", "updatedAt", intercept, "attendanceCoefficient", "tryoutCoefficient", "coefficientMode", "teacherObjectiveCoefficient") FROM stdin;
083bc9d8-aac2-42e4-a53e-8ccbd2049435	50	50	10	2026-04-28 14:54:54.00853	2026-04-28 15:06:07.764837	0	0.4	0.5	AUTO_TRAINED	0.1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, "fullName", username, password, role, "isActive", "createdAt", "updatedAt", "assignedTutorId") FROM stdin;
1192869c-34b8-46e6-9a49-26fec400302d	HiveEdu Admin	admin	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	ADMIN	t	2026-04-30 20:59:22.139236	2026-04-30 20:59:22.139236	\N
02524791-420d-4e5a-b922-0943ea116476	HiveEdu Teacher 1	teacher1	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	TEACHER	t	2026-04-30 20:59:22.139236	2026-04-30 20:59:22.139236	\N
fb34dd3f-655d-43ac-806a-c396af627252	HiveEdu Teacher 2	teacher2	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	TEACHER	t	2026-04-30 20:59:22.139236	2026-04-30 20:59:22.139236	\N
84164b5d-a3fe-4abb-b1b3-85f3982a6b03	HiveEdu User 1	user1	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	02524791-420d-4e5a-b922-0943ea116476
0bbafb53-a86f-4de6-a8af-09c3215025f6	HiveEdu User 2	user2	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	02524791-420d-4e5a-b922-0943ea116476
c60fc6de-46f8-482c-922b-7f684b5263b1	HiveEdu User 3	user3	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	02524791-420d-4e5a-b922-0943ea116476
80adb604-99a6-4b85-bf98-8d812ff9fa5e	HiveEdu User 4	user4	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	02524791-420d-4e5a-b922-0943ea116476
0cef1ee2-4aaf-4beb-aff8-a56e449436d6	HiveEdu User 5	user5	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	fb34dd3f-655d-43ac-806a-c396af627252
9ffcdb3b-df5c-4a77-9e9a-d9727eb16153	HiveEdu User 6	user6	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	fb34dd3f-655d-43ac-806a-c396af627252
75050bc8-0c4a-4d3b-be88-12d5536778a3	HiveEdu User 7	user7	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	fb34dd3f-655d-43ac-806a-c396af627252
7585de50-6bf7-49d6-bfae-5740892a2e5f	HiveEdu User 9	user9	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	02524791-420d-4e5a-b922-0943ea116476
e40c050d-1705-4911-98ef-4aa4743e0140	HiveEdu User 10	user10	$2b$10$gnd08KnmAxN7U3He2aaAIOH7HYrlPziT/GRAESd8Qui33SuxLz86i	USER	t	2026-04-30 20:59:22.237788	2026-04-30 20:59:22.237788	fb34dd3f-655d-43ac-806a-c396af627252
\.


--
-- Name: records PK_188149422ee2454660abf1d5ee5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT "PK_188149422ee2454660abf1d5ee5" PRIMARY KEY (id);


--
-- Name: audit_logs PK_1bb179d048bbc581caa3b013439; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "PK_1bb179d048bbc581caa3b013439" PRIMARY KEY (id);


--
-- Name: analytics_records PK_94cace6e56221f9f8848588d4b6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_records
    ADD CONSTRAINT "PK_94cace6e56221f9f8848588d4b6" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: intervention_notes PK_cbc077b624e8fa827f555c7f07c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_notes
    ADD CONSTRAINT "PK_cbc077b624e8fa827f555c7f07c" PRIMARY KEY (id);


--
-- Name: system_config PK_db4e70ac0d27e588176e9bb44a0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_config
    ADD CONSTRAINT "PK_db4e70ac0d27e588176e9bb44a0" PRIMARY KEY (id);


--
-- Name: attendance PK_ee0ffe42c1f1a01e72b725c0cb2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT "PK_ee0ffe42c1f1a01e72b725c0cb2" PRIMARY KEY (id);


--
-- Name: mlr_run_history PK_f7d77f1934cc01284c61be23ee0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mlr_run_history
    ADD CONSTRAINT "PK_f7d77f1934cc01284c61be23ee0" PRIMARY KEY (id);


--
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- Name: analytics_records FK_27b3b3236651ad6387bc98860fc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analytics_records
    ADD CONSTRAINT "FK_27b3b3236651ad6387bc98860fc" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: intervention_notes FK_317b400c80592cfc6eee3b2deed; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_notes
    ADD CONSTRAINT "FK_317b400c80592cfc6eee3b2deed" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mlr_run_history FK_445017a99a1c5ea0cacc79e3d77; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mlr_run_history
    ADD CONSTRAINT "FK_445017a99a1c5ea0cacc79e3d77" FOREIGN KEY ("generatedById") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: attendance FK_466e85b813d871bfb693f443528; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT "FK_466e85b813d871bfb693f443528" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users FK_861fec82b206f0b904d38c96b03; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_861fec82b206f0b904d38c96b03" FOREIGN KEY ("assignedTutorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: records FK_b392510e8a9898d395a871bd9cf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT "FK_b392510e8a9898d395a871bd9cf" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: intervention_notes FK_fdacf8549f79633cbd47c961678; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intervention_notes
    ADD CONSTRAINT "FK_fdacf8549f79633cbd47c961678" FOREIGN KEY ("createdById") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict M1mGfvT3WhxXFb9ZNAW8VdSMDT3cpDluCdc8zjLJfQXzLRTC0NuMUwlLHAvrs8T

