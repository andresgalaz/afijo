--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8 (Ubuntu 12.8-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.8 (Ubuntu 12.8-0ubuntu0.20.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: afijo_activo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_activo (
    id integer NOT NULL,
    nombre character varying(80) NOT NULL,
    fecha_ingreso date NOT NULL,
    fecha_inicio date,
    fecha_termino date,
    duracion_maxima integer NOT NULL,
    valor bigint NOT NULL,
    cantidad integer NOT NULL,
    "tipoActivo" character varying(1) NOT NULL,
    estado_id integer NOT NULL,
    planta_id integer,
    "tipoDepreciacion_id" integer NOT NULL,
    "valorResidual" bigint NOT NULL,
    fecha_baja date,
    codigo_interno character varying(30),
    familia_id integer,
    modelo character varying(80),
    serie character varying(30) NOT NULL,
    numero_interno character varying(3) NOT NULL,
    linea character varying(2) NOT NULL
);


--
-- Name: afijo_activo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_activo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_activo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_activo_id_seq OWNED BY public.afijo_activo.id;


--
-- Name: afijo_activodepreciacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_activodepreciacion (
    id integer NOT NULL,
    valor_depreciacion bigint NOT NULL,
    activo_id integer NOT NULL,
    planta_id integer NOT NULL,
    valor_contable bigint NOT NULL,
    periodo date NOT NULL
);


--
-- Name: afijo_activodepreciacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_activodepreciacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_activodepreciacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_activodepreciacion_id_seq OWNED BY public.afijo_activodepreciacion.id;


--
-- Name: afijo_estado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_estado (
    id integer NOT NULL,
    descripcion character varying(40) NOT NULL
);


--
-- Name: afijo_estado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_estado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_estado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_estado_id_seq OWNED BY public.afijo_estado.id;


--
-- Name: afijo_movimiento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_movimiento (
    id integer NOT NULL,
    ts_movim timestamp with time zone NOT NULL,
    fecha_cambio date NOT NULL,
    activo_id integer NOT NULL,
    planta_destino_id integer NOT NULL,
    planta_origen_id integer NOT NULL
);


--
-- Name: afijo_movimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_movimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_movimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_movimiento_id_seq OWNED BY public.afijo_movimiento.id;


--
-- Name: afijo_planta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_planta (
    id integer NOT NULL,
    nombre character varying(80) NOT NULL,
    ubicacion character varying(180) NOT NULL,
    fecha_apertura date NOT NULL,
    duracion_concesion integer NOT NULL,
    fecha_depreciacion date NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_termino date NOT NULL,
    region_id integer
);


--
-- Name: afijo_planta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_planta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_planta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_planta_id_seq OWNED BY public.afijo_planta.id;


--
-- Name: afijo_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_region (
    id integer NOT NULL,
    codigo character varying(2) NOT NULL,
    nombre character varying(80) NOT NULL
);


--
-- Name: afijo_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_region_id_seq OWNED BY public.afijo_region.id;


--
-- Name: afijo_tipodepreciacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_tipodepreciacion (
    id integer NOT NULL,
    descripcion character varying(40) NOT NULL
);


--
-- Name: afijo_tipodepreciacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_tipodepreciacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_tipodepreciacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_tipodepreciacion_id_seq OWNED BY public.afijo_tipodepreciacion.id;


--
-- Name: afijo_tipofamilia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afijo_tipofamilia (
    id integer NOT NULL,
    codigo character varying(2) NOT NULL,
    nombre character varying(80) NOT NULL
);


--
-- Name: afijo_tipofamilia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afijo_tipofamilia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afijo_tipofamilia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afijo_tipofamilia_id_seq OWNED BY public.afijo_tipofamilia.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: afijo_activo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activo ALTER COLUMN id SET DEFAULT nextval('public.afijo_activo_id_seq'::regclass);


--
-- Name: afijo_activodepreciacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activodepreciacion ALTER COLUMN id SET DEFAULT nextval('public.afijo_activodepreciacion_id_seq'::regclass);


--
-- Name: afijo_estado id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_estado ALTER COLUMN id SET DEFAULT nextval('public.afijo_estado_id_seq'::regclass);


--
-- Name: afijo_movimiento id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_movimiento ALTER COLUMN id SET DEFAULT nextval('public.afijo_movimiento_id_seq'::regclass);


--
-- Name: afijo_planta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_planta ALTER COLUMN id SET DEFAULT nextval('public.afijo_planta_id_seq'::regclass);


--
-- Name: afijo_region id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_region ALTER COLUMN id SET DEFAULT nextval('public.afijo_region_id_seq'::regclass);


--
-- Name: afijo_tipodepreciacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_tipodepreciacion ALTER COLUMN id SET DEFAULT nextval('public.afijo_tipodepreciacion_id_seq'::regclass);


--
-- Name: afijo_tipofamilia id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_tipofamilia ALTER COLUMN id SET DEFAULT nextval('public.afijo_tipofamilia_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Data for Name: afijo_activo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_activo (id, nombre, fecha_ingreso, fecha_inicio, fecha_termino, duracion_maxima, valor, cantidad, "tipoActivo", estado_id, planta_id, "tipoDepreciacion_id", "valorResidual", fecha_baja, codigo_interno, familia_id, modelo, serie, numero_interno, linea) FROM stdin;
15	Extra	2021-05-14	2021-05-14	2028-05-06	5	32446	1	M	1	14	1	0	\N	15-08-3-FP-004	2	ER34	1234	4	3
3	Escritorio Oficina	2021-01-13	2021-05-01	2026-05-01	5	341000	1	M	1	14	1	0	\N	15-08-0-PL-010	20	Negro	0	10	0
8	Extra	2021-05-06	2021-05-06	2028-05-06	5	32996	1	M	1	9	1	0	\N		\N	\N	0	1	1
7	Gases	2021-05-05	2020-05-01	2025-05-01	5	95000	1	M	1	15	1	0	\N		\N	\N	0	1	1
6	Silla Modelo K	2012-04-30	2012-05-01	2029-05-01	8	120000	8	M	1	11	1	20000	\N		\N	\N	0	1	1
5	Mueble moderno 370	2021-02-02	2019-10-01	2024-10-01	5	100000	1	M	1	2	1	0	\N		\N	\N	0	1	1
4	Silla para escritorio D10	2021-01-13	2021-05-01	2026-05-01	5	79000	20	M	1	1	1	0	\N		\N	\N	0	1	1
2	Impresora HP 100	2021-01-07	2021-05-01	2026-05-01	5	141000	1	M	1	2	1	0	\N		\N	\N	0	1	1
1	Notebook 5432	2021-01-07	2021-05-01	2026-05-01	5	1210000	1	M	1	1	1	0	\N		\N	\N	0	1	1
\.


--
-- Data for Name: afijo_activodepreciacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_activodepreciacion (id, valor_depreciacion, activo_id, planta_id, valor_contable, periodo) FROM stdin;
394	549	8	9	32446	2021-05-01
395	549	8	9	31896	2021-06-01
396	549	8	9	31346	2021-07-01
397	549	8	9	30796	2021-08-01
398	549	8	9	30246	2021-09-01
399	549	8	9	29696	2021-10-01
400	549	8	9	29146	2021-11-01
401	549	8	9	28596	2021-12-01
402	549	8	9	28046	2022-01-01
403	549	8	9	27496	2022-02-01
404	549	8	9	26946	2022-03-01
405	549	8	9	26396	2022-04-01
406	549	8	9	25846	2022-05-01
407	549	8	9	25296	2022-06-01
408	549	8	9	24746	2022-07-01
409	549	8	9	24197	2022-08-01
410	549	8	9	23647	2022-09-01
411	549	8	9	23097	2022-10-01
412	549	8	9	22547	2022-11-01
413	549	8	9	21997	2022-12-01
414	549	8	9	21447	2023-01-01
415	549	8	9	20897	2023-02-01
416	549	8	9	20347	2023-03-01
417	549	8	9	19797	2023-04-01
418	549	8	9	19247	2023-05-01
419	549	8	9	18697	2023-06-01
420	549	8	9	18147	2023-07-01
421	549	8	9	17597	2023-08-01
422	549	8	9	17047	2023-09-01
423	549	8	9	16497	2023-10-01
424	549	8	9	15948	2023-11-01
425	549	8	9	15398	2023-12-01
426	549	8	9	14848	2024-01-01
427	549	8	9	14298	2024-02-01
428	549	8	9	13748	2024-03-01
429	549	8	9	13198	2024-04-01
430	549	8	9	12648	2024-05-01
431	549	8	9	12098	2024-06-01
432	549	8	9	11548	2024-07-01
433	549	8	9	10998	2024-08-01
434	549	8	9	10448	2024-09-01
435	549	8	9	9898	2024-10-01
436	549	8	9	9348	2024-11-01
437	549	8	9	8798	2024-12-01
438	549	8	9	8248	2025-01-01
439	549	8	9	7699	2025-02-01
440	549	8	9	7149	2025-03-01
441	549	8	9	6599	2025-04-01
442	549	8	9	6049	2025-05-01
443	549	8	9	5499	2025-06-01
444	549	8	9	4949	2025-07-01
445	549	8	9	4399	2025-08-01
490	1583	7	15	23750	2024-09-01
491	1583	7	15	22166	2024-10-01
492	1583	7	15	20583	2024-11-01
493	1583	7	15	19000	2024-12-01
494	1583	7	15	17416	2025-01-01
495	1583	7	15	15833	2025-02-01
496	1583	7	15	14250	2025-03-01
497	1583	7	15	12666	2025-04-01
498	1583	7	15	11083	2025-05-01
2049	5683	3	14	335316	2021-05-01
2050	5683	3	14	329633	2021-06-01
2051	5683	3	14	323950	2021-07-01
2052	5683	3	14	318266	2021-08-01
2053	5683	3	14	312583	2021-09-01
2054	5683	3	14	306900	2021-10-01
2055	5683	3	14	301216	2021-11-01
2056	5683	3	14	295533	2021-12-01
2057	5683	3	14	289850	2022-01-01
2058	5683	3	14	284166	2022-02-01
2059	5683	3	14	278483	2022-03-01
2060	5683	3	14	272800	2022-04-01
2061	5683	3	14	267116	2022-05-01
2062	5683	3	14	261433	2022-06-01
2063	5683	3	14	255750	2022-07-01
2064	5683	3	14	250066	2022-08-01
2065	5683	3	14	244383	2022-09-01
2066	5683	3	14	238700	2022-10-01
2067	5683	3	14	233016	2022-11-01
2068	5683	3	14	227333	2022-12-01
2069	5683	3	14	221650	2023-01-01
2070	5683	3	14	215966	2023-02-01
2071	5683	3	14	210283	2023-03-01
2072	5683	3	14	204600	2023-04-01
2073	5683	3	14	198916	2023-05-01
2074	5683	3	14	193233	2023-06-01
2075	5683	3	14	187550	2023-07-01
2076	5683	3	14	181866	2023-08-01
2077	5683	3	14	176183	2023-09-01
2078	5683	3	14	170500	2023-10-01
2079	5683	3	14	164816	2023-11-01
2080	5683	3	14	159133	2023-12-01
2081	5683	3	14	153450	2024-01-01
2082	5683	3	14	147766	2024-02-01
2083	5683	3	14	142083	2024-03-01
2084	5683	3	14	136400	2024-04-01
499	1583	7	15	9500	2025-06-01
500	1583	7	15	7916	2025-07-01
501	1583	7	15	6333	2025-08-01
502	1583	7	15	4750	2025-09-01
503	1583	7	15	3166	2025-10-01
504	1583	7	15	1583	2025-11-01
505	1583	7	15	0	2025-12-01
506	1041	6	11	118958	2019-01-01
507	1041	6	11	117916	2019-02-01
508	1041	6	11	116874	2019-03-01
509	1041	6	11	115833	2019-04-01
510	1041	6	11	114791	2019-05-01
511	1041	6	11	113749	2019-06-01
512	1041	6	11	112708	2019-07-01
513	1041	6	11	111666	2019-08-01
514	1041	6	11	110624	2019-09-01
515	1041	6	11	109583	2019-10-01
516	1041	6	11	108541	2019-11-01
517	1041	6	11	107499	2019-12-01
518	1041	6	11	106458	2020-01-01
519	1041	6	11	105416	2020-02-01
520	1041	6	11	104374	2020-03-01
446	1583	7	15	93416	2021-01-01
447	1583	7	15	91833	2021-02-01
448	1583	7	15	90250	2021-03-01
449	1583	7	15	88666	2021-04-01
450	1583	7	15	87083	2021-05-01
451	1583	7	15	85500	2021-06-01
452	1583	7	15	83916	2021-07-01
453	1583	7	15	82333	2021-08-01
454	1583	7	15	80750	2021-09-01
455	1583	7	15	79166	2021-10-01
456	1583	7	15	77583	2021-11-01
457	1583	7	15	76000	2021-12-01
458	1583	7	15	74416	2022-01-01
459	1583	7	15	72833	2022-02-01
460	1583	7	15	71250	2022-03-01
461	1583	7	15	69666	2022-04-01
462	1583	7	15	68083	2022-05-01
463	1583	7	15	66500	2022-06-01
464	1583	7	15	64916	2022-07-01
465	1583	7	15	63333	2022-08-01
466	1583	7	15	61750	2022-09-01
467	1583	7	15	60166	2022-10-01
468	1583	7	15	58583	2022-11-01
469	1583	7	15	57000	2022-12-01
470	1583	7	15	55416	2023-01-01
471	1583	7	15	53833	2023-02-01
472	1583	7	15	52250	2023-03-01
473	1583	7	15	50666	2023-04-01
474	1583	7	15	49083	2023-05-01
475	1583	7	15	47500	2023-06-01
476	1583	7	15	45916	2023-07-01
477	1583	7	15	44333	2023-08-01
478	1583	7	15	42750	2023-09-01
479	1583	7	15	41166	2023-10-01
480	1583	7	15	39583	2023-11-01
481	1583	7	15	38000	2023-12-01
482	1583	7	15	36416	2024-01-01
483	1583	7	15	34833	2024-02-01
484	1583	7	15	33250	2024-03-01
485	1583	7	15	31666	2024-04-01
486	1583	7	15	30083	2024-05-01
2085	5683	3	14	130716	2024-05-01
2086	5683	3	14	125033	2024-06-01
2087	5683	3	14	119350	2024-07-01
2088	5683	3	14	113666	2024-08-01
2089	5683	3	14	107983	2024-09-01
2090	5683	3	14	102300	2024-10-01
2091	5683	3	14	96616	2024-11-01
2092	5683	3	14	90933	2024-12-01
2093	5683	3	14	85250	2025-01-01
2094	5683	3	14	79566	2025-02-01
2095	5683	3	14	73883	2025-03-01
2096	5683	3	14	68200	2025-04-01
2097	5683	3	14	62516	2025-05-01
2098	5683	3	14	56833	2025-06-01
2099	5683	3	14	51150	2025-07-01
2100	5683	3	14	45466	2025-08-01
2101	5683	3	14	39783	2025-09-01
2102	5683	3	14	34100	2025-10-01
2103	5683	3	14	28416	2025-11-01
2104	5683	3	14	22733	2025-12-01
2105	5683	3	14	17050	2026-01-01
2106	5683	3	14	11366	2026-02-01
2107	5683	3	14	5683	2026-03-01
2108	5683	3	14	0	2026-04-01
487	1583	7	15	28500	2024-06-01
488	1583	7	15	26916	2024-07-01
489	1583	7	15	25333	2024-08-01
521	1041	6	11	103333	2020-04-01
522	1041	6	11	102291	2020-05-01
523	1041	6	11	101249	2020-06-01
524	1041	6	11	100208	2020-07-01
525	1041	6	11	99166	2020-08-01
526	1041	6	11	98124	2020-09-01
527	1041	6	11	97083	2020-10-01
528	1041	6	11	96041	2020-11-01
529	1041	6	11	94999	2020-12-01
530	1041	6	11	93958	2021-01-01
531	1041	6	11	92916	2021-02-01
532	1041	6	11	91874	2021-03-01
533	1041	6	11	90833	2021-04-01
534	1041	6	11	89791	2021-05-01
535	1041	6	11	88749	2021-06-01
536	1041	6	11	87708	2021-07-01
537	1041	6	11	86666	2021-08-01
538	1041	6	11	85624	2021-09-01
539	1041	6	11	84583	2021-10-01
540	1041	6	11	83541	2021-11-01
541	1041	6	11	82499	2021-12-01
542	1041	6	11	81458	2022-01-01
543	1041	6	11	80416	2022-02-01
544	1041	6	11	79374	2022-03-01
545	1041	6	11	78333	2022-04-01
546	1041	6	11	77291	2022-05-01
547	1041	6	11	76249	2022-06-01
548	1041	6	11	75208	2022-07-01
549	1666	5	2	98333	2021-02-01
550	1666	5	2	96666	2021-03-01
551	1666	5	2	94999	2021-04-01
552	1666	5	2	93333	2021-05-01
553	1666	5	2	91666	2021-06-01
554	1666	5	2	89999	2021-07-01
555	1666	5	2	88333	2021-08-01
556	1666	5	2	86666	2021-09-01
557	1666	5	2	84999	2021-10-01
558	1666	5	2	83333	2021-11-01
559	1666	5	2	81666	2021-12-01
560	1666	5	2	79999	2022-01-01
561	1666	5	2	78333	2022-02-01
562	1666	5	2	76666	2022-03-01
563	1666	5	2	74999	2022-04-01
564	1666	5	2	73333	2022-05-01
565	1666	5	2	71666	2022-06-01
566	1666	5	2	69999	2022-07-01
567	1666	5	2	68333	2022-08-01
568	1666	5	2	66666	2022-09-01
569	1666	5	2	64999	2022-10-01
570	1666	5	2	63333	2022-11-01
571	1666	5	2	61666	2022-12-01
572	1666	5	2	59999	2023-01-01
573	1666	5	2	58333	2023-02-01
574	1666	5	2	56666	2023-03-01
575	1666	5	2	54999	2023-04-01
576	1666	5	2	53333	2023-05-01
577	1666	5	2	51666	2023-06-01
578	1666	5	2	49999	2023-07-01
579	1666	5	2	48333	2023-08-01
580	1666	5	2	46666	2023-09-01
581	1666	5	2	44999	2023-10-01
582	1666	5	2	43333	2023-11-01
583	1666	5	2	41666	2023-12-01
584	1666	5	2	39999	2024-01-01
585	1666	5	2	38333	2024-02-01
586	1666	5	2	36666	2024-03-01
587	1666	5	2	34999	2024-04-01
588	1666	5	2	33333	2024-05-01
589	1666	5	2	31666	2024-06-01
590	1666	5	2	29999	2024-07-01
591	1666	5	2	28333	2024-08-01
592	1666	5	2	26666	2024-09-01
593	1666	5	2	24999	2024-10-01
594	1666	5	2	23333	2024-11-01
595	1666	5	2	21666	2024-12-01
596	1666	5	2	19999	2025-01-01
597	1666	5	2	18333	2025-02-01
598	1666	5	2	16666	2025-03-01
599	1666	5	2	14999	2025-04-01
600	1666	5	2	13333	2025-05-01
601	1666	5	2	11666	2025-06-01
602	1666	5	2	9999	2025-07-01
603	1666	5	2	8333	2025-08-01
604	1666	5	2	6666	2025-09-01
605	1666	5	2	4999	2025-10-01
606	1666	5	2	3333	2025-11-01
607	1666	5	2	1666	2025-12-01
608	1666	5	2	0	2026-01-01
609	1316	4	1	77683	2021-05-01
610	1316	4	1	76366	2021-06-01
611	1316	4	1	75049	2021-07-01
612	1316	4	1	73733	2021-08-01
613	1316	4	1	72416	2021-09-01
614	1316	4	1	71099	2021-10-01
615	1316	4	1	69783	2021-11-01
616	1316	4	1	68466	2021-12-01
617	1316	4	1	67149	2022-01-01
618	1316	4	1	65833	2022-02-01
619	1316	4	1	64516	2022-03-01
620	1316	4	1	63199	2022-04-01
621	1316	4	1	61883	2022-05-01
622	1316	4	1	60566	2022-06-01
623	1316	4	1	59249	2022-07-01
624	1316	4	1	57933	2022-08-01
625	1316	4	1	56616	2022-09-01
626	1316	4	1	55299	2022-10-01
627	1316	4	1	53983	2022-11-01
628	1316	4	1	52666	2022-12-01
629	1316	4	1	51349	2023-01-01
630	1316	4	1	50033	2023-02-01
631	1316	4	1	48716	2023-03-01
632	1316	4	1	47399	2023-04-01
633	1316	4	1	46083	2023-05-01
634	1316	4	1	44766	2023-06-01
635	1316	4	1	43449	2023-07-01
636	1316	4	1	42133	2023-08-01
637	1316	4	1	40816	2023-09-01
638	1316	4	1	39500	2023-10-01
639	1316	4	1	38183	2023-11-01
640	1316	4	1	36866	2023-12-01
641	1316	4	1	35550	2024-01-01
642	1316	4	1	34233	2024-02-01
643	1316	4	1	32916	2024-03-01
644	1316	4	1	31600	2024-04-01
645	1316	4	1	30283	2024-05-01
646	1316	4	1	28966	2024-06-01
647	1316	4	1	27650	2024-07-01
648	1316	4	1	26333	2024-08-01
649	1316	4	1	25016	2024-09-01
650	1316	4	1	23700	2024-10-01
651	1316	4	1	22383	2024-11-01
652	1316	4	1	21066	2024-12-01
653	1316	4	1	19750	2025-01-01
654	1316	4	1	18433	2025-02-01
655	1316	4	1	17116	2025-03-01
656	1316	4	1	15799	2025-04-01
657	1316	4	1	14483	2025-05-01
658	1316	4	1	13166	2025-06-01
659	1316	4	1	11850	2025-07-01
660	1316	4	1	10533	2025-08-01
661	1316	4	1	9216	2025-09-01
662	1316	4	1	7900	2025-10-01
663	1316	4	1	6583	2025-11-01
664	1316	4	1	5266	2025-12-01
665	1316	4	1	3950	2026-01-01
666	1316	4	1	2633	2026-02-01
667	1316	4	1	1316	2026-03-01
668	1316	4	1	0	2026-04-01
729	2350	2	2	138650	2021-05-01
730	2350	2	2	136300	2021-06-01
731	2350	2	2	133950	2021-07-01
732	2350	2	2	131600	2021-08-01
733	2350	2	2	129250	2021-09-01
734	2350	2	2	126900	2021-10-01
735	2350	2	2	124550	2021-11-01
736	2350	2	2	122200	2021-12-01
737	2350	2	2	119850	2022-01-01
738	2350	2	2	117500	2022-02-01
739	2350	2	2	115150	2022-03-01
740	2350	2	2	112800	2022-04-01
741	2350	2	2	110450	2022-05-01
742	2350	2	2	108100	2022-06-01
743	2350	2	2	105750	2022-07-01
744	2350	2	2	103400	2022-08-01
745	2350	2	2	101050	2022-09-01
746	2350	2	2	98700	2022-10-01
747	2350	2	2	96350	2022-11-01
748	2350	2	2	94000	2022-12-01
749	2350	2	2	91650	2023-01-01
750	2350	2	2	89300	2023-02-01
751	2350	2	2	86950	2023-03-01
752	2350	2	2	84600	2023-04-01
753	2350	2	2	82250	2023-05-01
754	2350	2	2	79900	2023-06-01
755	2350	2	2	77550	2023-07-01
756	2350	2	2	75200	2023-08-01
757	2350	2	2	72850	2023-09-01
758	2350	2	2	70500	2023-10-01
759	2350	2	2	68150	2023-11-01
760	2350	2	2	65800	2023-12-01
761	2350	2	2	63450	2024-01-01
762	2350	2	2	61100	2024-02-01
763	2350	2	2	58750	2024-03-01
764	2350	2	2	56400	2024-04-01
765	2350	2	2	54050	2024-05-01
766	2350	2	2	51700	2024-06-01
767	2350	2	2	49350	2024-07-01
768	2350	2	2	47000	2024-08-01
769	2350	2	2	44650	2024-09-01
770	2350	2	2	42300	2024-10-01
771	2350	2	2	39950	2024-11-01
772	2350	2	2	37600	2024-12-01
773	2350	2	2	35250	2025-01-01
774	2350	2	2	32900	2025-02-01
775	2350	2	2	30550	2025-03-01
776	2350	2	2	28200	2025-04-01
777	2350	2	2	25850	2025-05-01
778	2350	2	2	23500	2025-06-01
779	2350	2	2	21150	2025-07-01
780	2350	2	2	18800	2025-08-01
781	2350	2	2	16450	2025-09-01
782	2350	2	2	14100	2025-10-01
783	2350	2	2	11750	2025-11-01
784	2350	2	2	9400	2025-12-01
785	2350	2	2	7050	2026-01-01
786	2350	2	2	4700	2026-02-01
787	2350	2	2	2350	2026-03-01
788	2350	2	2	0	2026-04-01
789	20166	1	1	1189833	2021-05-01
790	20166	1	1	1169666	2021-06-01
791	20166	1	1	1149499	2021-07-01
792	20166	1	1	1129333	2021-08-01
793	20166	1	1	1109166	2021-09-01
794	20166	1	1	1088999	2021-10-01
795	20166	1	1	1068833	2021-11-01
796	20166	1	1	1048666	2021-12-01
797	20166	1	1	1028499	2022-01-01
798	20166	1	1	1008333	2022-02-01
799	20166	1	1	988166	2022-03-01
800	20166	1	1	967999	2022-04-01
801	20166	1	1	947833	2022-05-01
802	20166	1	1	927666	2022-06-01
803	20166	1	1	907499	2022-07-01
804	20166	1	1	887333	2022-08-01
805	20166	1	1	867166	2022-09-01
806	20166	1	1	846999	2022-10-01
807	20166	1	1	826833	2022-11-01
808	20166	1	1	806666	2022-12-01
809	20166	1	1	786499	2023-01-01
810	20166	1	1	766333	2023-02-01
811	20166	1	1	746166	2023-03-01
812	20166	1	1	726000	2023-04-01
813	20166	1	1	705833	2023-05-01
814	20166	1	1	685666	2023-06-01
815	20166	1	1	665500	2023-07-01
816	20166	1	1	645333	2023-08-01
817	20166	1	1	625166	2023-09-01
818	20166	1	1	605000	2023-10-01
819	20166	1	1	584833	2023-11-01
820	20166	1	1	564666	2023-12-01
821	20166	1	1	544500	2024-01-01
822	20166	1	1	524333	2024-02-01
823	20166	1	1	504166	2024-03-01
824	20166	1	1	484000	2024-04-01
825	20166	1	1	463833	2024-05-01
826	20166	1	1	443666	2024-06-01
827	20166	1	1	423500	2024-07-01
828	20166	1	1	403333	2024-08-01
829	20166	1	1	383166	2024-09-01
830	20166	1	1	363000	2024-10-01
831	20166	1	1	342833	2024-11-01
832	20166	1	1	322666	2024-12-01
833	20166	1	1	302500	2025-01-01
834	20166	1	1	282333	2025-02-01
835	20166	1	1	262166	2025-03-01
836	20166	1	1	242000	2025-04-01
837	20166	1	1	221833	2025-05-01
838	20166	1	1	201666	2025-06-01
839	20166	1	1	181500	2025-07-01
840	20166	1	1	161333	2025-08-01
841	20166	1	1	141166	2025-09-01
842	20166	1	1	121000	2025-10-01
843	20166	1	1	100833	2025-11-01
844	20166	1	1	80666	2025-12-01
845	20166	1	1	60500	2026-01-01
846	20166	1	1	40333	2026-02-01
847	20166	1	1	20166	2026-03-01
848	20166	1	1	0	2026-04-01
1929	540	15	14	31905	2021-05-01
1930	540	15	14	31364	2021-06-01
1931	540	15	14	30823	2021-07-01
1932	540	15	14	30282	2021-08-01
1933	540	15	14	29742	2021-09-01
1934	540	15	14	29201	2021-10-01
1935	540	15	14	28660	2021-11-01
1936	540	15	14	28119	2021-12-01
1937	540	15	14	27579	2022-01-01
1938	540	15	14	27038	2022-02-01
1939	540	15	14	26497	2022-03-01
1940	540	15	14	25956	2022-04-01
1941	540	15	14	25416	2022-05-01
1942	540	15	14	24875	2022-06-01
1943	540	15	14	24334	2022-07-01
1944	540	15	14	23793	2022-08-01
1945	540	15	14	23252	2022-09-01
1946	540	15	14	22712	2022-10-01
1947	540	15	14	22171	2022-11-01
1948	540	15	14	21630	2022-12-01
1949	540	15	14	21089	2023-01-01
1950	540	15	14	20549	2023-02-01
1951	540	15	14	20008	2023-03-01
1952	540	15	14	19467	2023-04-01
1953	540	15	14	18926	2023-05-01
1954	540	15	14	18386	2023-06-01
1955	540	15	14	17845	2023-07-01
1956	540	15	14	17304	2023-08-01
1957	540	15	14	16763	2023-09-01
1958	540	15	14	16223	2023-10-01
1959	540	15	14	15682	2023-11-01
1960	540	15	14	15141	2023-12-01
1961	540	15	14	14600	2024-01-01
1962	540	15	14	14059	2024-02-01
1963	540	15	14	13519	2024-03-01
1964	540	15	14	12978	2024-04-01
1965	540	15	14	12437	2024-05-01
1966	540	15	14	11896	2024-06-01
1967	540	15	14	11356	2024-07-01
1968	540	15	14	10815	2024-08-01
1969	540	15	14	10274	2024-09-01
1970	540	15	14	9733	2024-10-01
1971	540	15	14	9193	2024-11-01
1972	540	15	14	8652	2024-12-01
1973	540	15	14	8111	2025-01-01
1974	540	15	14	7570	2025-02-01
1975	540	15	14	7029	2025-03-01
1976	540	15	14	6489	2025-04-01
1977	540	15	14	5948	2025-05-01
1978	540	15	14	5407	2025-06-01
1979	540	15	14	4866	2025-07-01
1980	540	15	14	4326	2025-08-01
1981	540	15	14	3785	2025-09-01
1982	540	15	14	3244	2025-10-01
1983	540	15	14	2703	2025-11-01
1984	540	15	14	2163	2025-12-01
1985	540	15	14	1622	2026-01-01
1986	540	15	14	1081	2026-02-01
1987	540	15	14	540	2026-03-01
1988	540	15	14	0	2026-04-01
\.


--
-- Data for Name: afijo_estado; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_estado (id, descripcion) FROM stdin;
2	Depreciandose
1	Vigente
3	Baja
\.


--
-- Data for Name: afijo_movimiento; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_movimiento (id, ts_movim, fecha_cambio, activo_id, planta_destino_id, planta_origen_id) FROM stdin;
1	2021-05-11 22:12:11.746432-04	2021-05-01	3	12	10
14	2021-05-14 16:01:48.12675-04	2021-05-14	8	8	2
15	2021-05-14 16:12:47.007025-04	2021-05-14	8	15	2
16	2021-05-14 16:15:50.827158-04	2021-05-14	8	12	2
17	2021-05-14 16:17:04.581256-04	2021-05-01	8	12	2
18	2021-05-14 16:18:32.451667-04	2021-05-01	8	12	2
19	2021-05-14 16:19:15.879923-04	2021-05-14	8	12	2
20	2021-05-14 16:26:41.707958-04	2021-05-14	8	7	2
21	2021-05-14 16:31:12.141463-04	2021-05-14	8	12	2
22	2021-05-14 16:34:33.759831-04	2021-05-14	8	11	2
23	2021-05-14 16:37:31.055811-04	2021-05-14	8	11	2
24	2021-05-14 16:37:49.774824-04	2021-05-14	8	11	2
33	2021-05-14 20:49:31.284067-04	2021-05-14	8	14	2
34	2021-05-14 21:03:19.112507-04	2021-05-14	8	2	14
40	2021-05-17 16:36:39.794967-04	2021-05-17	8	9	2
\.


--
-- Data for Name: afijo_planta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_planta (id, nombre, ubicacion, fecha_apertura, duracion_concesion, fecha_depreciacion, fecha_inicio, fecha_termino, region_id) FROM stdin;
15	AB1507	Calle 3 Norte 130, Arica	2019-11-01	9	2021-01-04	2017-10-01	2026-11-20	2
14	B1508	Avenida Argentina 3229, Arica	2019-12-01	9	2020-06-01	2017-10-01	2026-10-01	2
13	B0542	Limache 4165 sector El Salto, Viña del Mar	2019-10-01	8	2020-04-01	2017-09-01	2025-09-01	7
12	AB0611	El Algarrobo 1721, Sector Pueblo de Indios, San Vicente	2018-03-01	8	2018-09-01	2016-01-29	2024-01-29	8
11	AB0728	Camino Constitución a Chanco o Ruta M-50, Constitución	2018-07-01	8	2019-01-01	2014-08-07	2022-08-07	9
10	AB0727	Calle 2 Sur 631, esquina Ignacio Carrera Pinto, Parral	2017-02-01	8	2017-08-01	2014-08-07	2022-08-07	9
9	AB0541	La Hijuela Lote 2, Sector Tapihue, Casablanca	2019-06-01	8	2019-12-01	2017-09-01	2025-09-01	7
8	AB0726	Los Vidales 2221, Curicó	2016-09-01	5	2017-03-01	2016-08-31	2022-08-07	9
7	AB1307	Avenida Vicuña Mackenna 3276, Melipilla	2018-12-01	8	2019-06-01	2015-11-10	2023-11-10	16
2	AB0610	Avenida Salvador Allende 273, Rancagua	2021-07-01	5	2021-01-17	2021-01-17	2026-08-19	8
1	AB1308	El Otoño 501, Lampa	2017-10-01	11	2018-04-01	2017-11-10	2028-11-10	16
\.


--
-- Data for Name: afijo_region; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_region (id, codigo, nombre) FROM stdin;
2	15	Arica y Parinacota
3	01	Tarapacá
4	02	Antofagasta
5	03	Atacama
6	04	Coquimbo
7	05	Valparaíso
8	06	Del Libertador Bernardo O’ Higginis
9	07	Maule
10	08	Bio Bio
11	09	Araucanía
12	10	Los Lagos
13	14	Los Ríos
14	11	Aisen
15	12	Magallanes y de la Antártica Chilena
16	13	Metropolitana de Santiago
\.


--
-- Data for Name: afijo_tipodepreciacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_tipodepreciacion (id, descripcion) FROM stdin;
1	Lineal
2	Acelerada
\.


--
-- Data for Name: afijo_tipofamilia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.afijo_tipofamilia (id, codigo, nombre) FROM stdin;
1	FL	FRENOMETRO DE LIVIANOS
2	FP	FRENOMETRO DE PESADOS
3	BS	BANCO DE SUSPENSIÓN
4	AL	ALINEADOR AL PASO PARA VEHICULOS LIVIANOS
5	AP	ALINEADOR AL PASO PARA VEHICULOS PESADOS
6	DL	DETECTOR DE HOLGURAS PARA VEHICULOS LIVIANOS
7	DP	DETECTOR DE HOLGURAS PARA VEHICULOS PESADOS
8	AG	ANALIZADOR DE GASES
9	OP	OPACIMETRO
10	SM	SONOMETRO
11	LX	LUXOMETRO
12	CO	COMPRESOR
13	AH	ALZADOR HIDRAULICO
14	DY	DINAMÓMETRO
15	AN	ÁNGULO DE GIRO
16	PM	PIE DE METRO
17	HM	HUINCHA DE MEDIR
18	PF	PROFUNDÍMETRO
19	IM	IMPRESORA
20	PL	PC LINEA
21	PA	PC ADMINISTRATIVO
22	PS	PC SERVIDOR
23	MO	MONITOR
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add estado	1	add_estado
2	Can change estado	1	change_estado
3	Can delete estado	1	delete_estado
4	Can view estado	1	view_estado
5	Can add planta	2	add_planta
6	Can change planta	2	change_planta
7	Can delete planta	2	delete_planta
8	Can view planta	2	view_planta
9	Can add activo	3	add_activo
10	Can change activo	3	change_activo
11	Can delete activo	3	delete_activo
12	Can view activo	3	view_activo
13	Can add log entry	4	add_logentry
14	Can change log entry	4	change_logentry
15	Can delete log entry	4	delete_logentry
16	Can view log entry	4	view_logentry
17	Can add permission	5	add_permission
18	Can change permission	5	change_permission
19	Can delete permission	5	delete_permission
20	Can view permission	5	view_permission
21	Can add group	6	add_group
22	Can change group	6	change_group
23	Can delete group	6	delete_group
24	Can view group	6	view_group
25	Can add user	7	add_user
26	Can change user	7	change_user
27	Can delete user	7	delete_user
28	Can view user	7	view_user
29	Can add content type	8	add_contenttype
30	Can change content type	8	change_contenttype
31	Can delete content type	8	delete_contenttype
32	Can view content type	8	view_contenttype
33	Can add session	9	add_session
34	Can change session	9	change_session
35	Can delete session	9	delete_session
36	Can view session	9	view_session
37	Can add planta depreciacion	10	add_plantadepreciacion
38	Can change planta depreciacion	10	change_plantadepreciacion
39	Can delete planta depreciacion	10	delete_plantadepreciacion
40	Can view planta depreciacion	10	view_plantadepreciacion
41	Can add depreciacion	10	add_depreciacion
42	Can change depreciacion	10	change_depreciacion
43	Can delete depreciacion	10	delete_depreciacion
44	Can view depreciacion	10	view_depreciacion
45	Can add tipo depreciacion	11	add_tipodepreciacion
46	Can change tipo depreciacion	11	change_tipodepreciacion
47	Can delete tipo depreciacion	11	delete_tipodepreciacion
48	Can view tipo depreciacion	11	view_tipodepreciacion
49	Can add activo depreciacion	12	add_activodepreciacion
50	Can change activo depreciacion	12	change_activodepreciacion
51	Can delete activo depreciacion	12	delete_activodepreciacion
52	Can view activo depreciacion	12	view_activodepreciacion
53	Can add movimiento	13	add_movimiento
54	Can change movimiento	13	change_movimiento
55	Can delete movimiento	13	delete_movimiento
56	Can view movimiento	13	view_movimiento
57	Can add region	14	add_region
58	Can change region	14	change_region
59	Can delete region	14	delete_region
60	Can view region	14	view_region
61	Can add Tipo y Familia	15	add_tipofamilia
62	Can change Tipo y Familia	15	change_tipofamilia
63	Can delete Tipo y Familia	15	delete_tipofamilia
64	Can view Tipo y Familia	15	view_tipofamilia
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$150000$9x72lLEhSGgG$qqkEyubKTnkkwQDPBmieQAC/YDReoXWtZYhLv+BsFRc=	2021-09-02 20:06:03.745462-04	t	desa			andres.galaz@compustrom.com	t	t	2021-01-07 13:32:35.738888-03
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2021-01-07 13:42:20.324436-03	1	Notebook 5432	1	[{"added": {}}]	3	1
2	2021-01-07 13:55:08.677403-03	1	AB1308, El Otoño 501	1	[{"added": {}}]	2	1
3	2021-01-07 13:55:31.027663-03	1	Notebook 5432	2	[{"changed": {"fields": ["planta"]}}]	3	1
4	2021-01-07 16:24:25.410633-03	2	AB0610, Avenida Salvador Allende 273	1	[{"added": {}}]	2	1
5	2021-01-07 16:24:34.152323-03	2	Impresora HP 100	1	[{"added": {}}]	3	1
6	2021-01-13 17:41:23.683239-03	3	Escritorio Oficina	1	[{"added": {}}]	3	1
7	2021-01-13 17:42:13.038451-03	4	Silla para escritorio	1	[{"added": {}}]	3	1
8	2021-02-02 10:09:26.800561-03	5	Mueble Rojo  2000*370 color café	1	[{"added": {}}]	3	1
9	2021-04-28 13:44:47.724774-04	4	Spike	2	[{"changed": {"fields": ["nombre"]}}]	3	1
10	2021-04-28 13:46:04.960136-04	4	Silla para escritorio	2	[{"changed": {"fields": ["nombre"]}}]	3	1
11	2021-04-29 16:24:54.718507-04	1	Lineal	1	[{"added": {}}]	11	1
12	2021-04-29 16:25:13.966727-04	2	Acelerada	1	[{"added": {}}]	11	1
13	2021-04-30 13:44:00.257719-04	6	Serrucho	1	[{"added": {}}]	3	1
14	2021-04-30 16:47:45.587738-04	6	Silla	2	[{"changed": {"fields": ["nombre", "fecha_inicio", "duracion_maxima"]}}]	3	1
15	2021-04-30 16:48:40.356506-04	6	Silla Modelo K	2	[{"changed": {"fields": ["nombre"]}}]	3	1
16	2021-04-30 17:00:10.638472-04	6	Silla Modelo K	2	[{"changed": {"fields": ["cantidad"]}}]	3	1
17	2021-04-30 17:01:38.234045-04	6	Silla Modelo K	2	[{"changed": {"fields": ["estado"]}}]	3	1
18	2021-04-30 17:02:24.727268-04	6	Silla Modelo K	2	[{"changed": {"fields": ["cantidad"]}}]	3	1
19	2021-04-30 17:03:20.120253-04	5	Mueble Rojo  370 color café	2	[{"changed": {"fields": ["nombre"]}}]	3	1
20	2021-04-30 17:08:32.893534-04	5	Mueble modeerno 370 color café	2	[{"changed": {"fields": ["nombre"]}}]	3	1
21	2021-04-30 17:11:39.280909-04	5	Mueble moderno 370 color café	2	[{"changed": {"fields": ["nombre"]}}]	3	1
22	2021-04-30 17:17:55.01271-04	5	Mueble moderno 370	2	[{"changed": {"fields": ["nombre"]}}]	3	1
23	2021-04-30 17:18:47.107132-04	6	Silla Modelo K	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
24	2021-04-30 17:21:08.86026-04	5	Mueble moderno 370	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
25	2021-04-30 17:23:51.564441-04	4	Silla para escritorio D10	2	[{"changed": {"fields": ["nombre"]}}]	3	1
26	2021-04-30 17:24:09.520721-04	4	Silla para escritorio D10	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
27	2021-04-30 17:24:17.235748-04	3	Escritorio Oficina	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
28	2021-04-30 17:24:23.676684-04	2	Impresora HP 100	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
29	2021-04-30 17:24:38.615922-04	1	Notebook 5432	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
30	2021-04-30 17:24:38.619808-04	1	Notebook 5432	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
31	2021-04-30 17:56:37.691851-04	5	Mueble moderno 370	2	[{"changed": {"fields": ["fecha_inicio", "fecha_termino"]}}]	3	1
32	2021-05-04 13:46:37.274126-04	6	Silla Modelo K	2	[{"changed": {"fields": ["fecha_ingreso", "fecha_inicio"]}}]	3	1
33	2021-05-04 13:47:36.871403-04	6	Silla Modelo K	2	[{"changed": {"fields": ["valor"]}}]	3	1
34	2021-05-04 13:48:27.270738-04	6	Silla Modelo K	2	[{"changed": {"fields": ["valor", "valorResidual"]}}]	3	1
35	2021-05-04 13:50:53.695921-04	5	Mueble moderno 370	2	[{"changed": {"fields": ["fecha_inicio", "fecha_termino", "valor"]}}]	3	1
36	2021-05-05 17:14:40.651275-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_termino"]}}]	2	1
37	2021-05-05 17:15:07.994111-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["duracion_concesion"]}}]	2	1
38	2021-05-05 17:29:30.34805-04	16	Borrar, No tiene	1	[{"added": {}}]	2	1
39	2021-05-05 17:29:53.056781-04	16	Borrar, No tiene	3		2	1
40	2021-05-05 18:07:23.736994-04	7	Ejemplo	1	[{"added": {}}]	3	1
41	2021-05-05 18:08:33.015618-04	7	Ejemplo	2	[{"changed": {"fields": ["valor"]}}]	3	1
42	2021-05-05 18:10:16.872227-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
43	2021-05-05 18:12:32.237473-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
44	2021-05-05 18:13:11.060821-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
45	2021-05-05 18:14:12.17827-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
46	2021-05-05 18:14:55.184678-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
47	2021-05-05 18:16:08.693911-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
48	2021-05-05 18:20:32.376698-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
49	2021-05-05 18:21:32.807225-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["fecha_depreciacion"]}}]	2	1
50	2021-05-06 14:56:56.426677-04	2	AB0610, Avenida Salvador Allende 273, Rancagua, RM	2	[{"changed": {"fields": ["fecha_termino"]}}]	2	1
51	2021-05-06 15:19:14.490571-04	8	Extra	1	[{"added": {}}]	3	1
52	2021-05-06 22:01:17.414822-04	1	AB1308, El Otoño 501, Lampa, RM	2	[{"changed": {"fields": ["fecha_inicio", "fecha_termino"]}}]	2	1
53	2021-05-10 10:50:49.450391-04	3	Anactivo	2	[{"changed": {"fields": ["descripcion"]}}]	1	1
54	2021-05-10 10:51:11.46278-04	2	Depreciandose	2	[{"changed": {"fields": ["descripcion"]}}]	1	1
55	2021-05-10 10:51:21.216232-04	1	Baja	2	[{"changed": {"fields": ["descripcion"]}}]	1	1
56	2021-05-11 21:51:35.496736-04	8	Extra	2	[{"changed": {"fields": ["fecha_inicio"]}}]	3	1
57	2021-05-11 21:54:34.307739-04	3	Inactivo	2	[{"changed": {"fields": ["descripcion"]}}]	1	1
58	2021-05-11 21:54:48.911887-04	3	Activo	2	[{"changed": {"fields": ["descripcion"]}}]	1	1
59	2021-05-11 22:12:11.771874-04	1	Movimiento object (1)	1	[{"added": {}}]	13	1
60	2021-05-11 22:12:55.410489-04	1	Movimiento object (1)	2	[{"changed": {"fields": ["fecha_cambio"]}}]	13	1
61	2021-05-14 11:24:25.572072-04	1	Movimiento object (1)	2	[{"changed": {"fields": ["activo", "planta_destino"]}}]	13	1
62	2021-05-14 16:01:48.139079-04	14	Movimiento object (14)	1	[{"added": {}}]	13	1
63	2021-05-14 16:12:47.018766-04	15	Movimiento object (15)	1	[{"added": {}}]	13	1
64	2021-05-14 16:15:50.850685-04	16	Movimiento object (16)	1	[{"added": {}}]	13	1
65	2021-05-14 16:17:04.608421-04	17	Movimiento object (17)	1	[{"added": {}}]	13	1
66	2021-05-14 16:18:32.459446-04	18	Movimiento object (18)	1	[{"added": {}}]	13	1
67	2021-05-14 16:19:15.893391-04	19	Movimiento object (19)	1	[{"added": {}}]	13	1
68	2021-05-14 16:26:41.72313-04	20	Movimiento object (20)	1	[{"added": {}}]	13	1
69	2021-05-14 16:31:12.171156-04	21	Movimiento object (21)	1	[{"added": {}}]	13	1
70	2021-05-14 16:34:33.772205-04	22	Movimiento object (22)	1	[{"added": {}}]	13	1
71	2021-05-14 16:37:31.084274-04	23	Movimiento object (23)	1	[{"added": {}}]	13	1
72	2021-05-14 16:37:49.787255-04	24	Movimiento object (24)	1	[{"added": {}}]	13	1
73	2021-05-14 20:49:31.36888-04	33	Movimiento object (33)	1	[{"added": {}}]	13	1
74	2021-05-14 21:03:19.214877-04	34	Movimiento object (34)	1	[{"added": {}}]	13	1
75	2021-05-14 21:03:57.228328-04	14	Extra	3		3	1
76	2021-05-17 16:36:39.826677-04	40	Movimiento object (40)	1	[{"added": {}}]	13	1
77	2021-05-17 22:21:02.860094-04	8	Extra	2	[{"changed": {"fields": ["fecha_baja"]}}]	3	1
78	2021-05-17 22:21:11.615599-04	15	Extra	2	[]	3	1
79	2021-05-17 22:21:17.204586-04	8	Extra	2	[]	3	1
80	2021-05-17 22:21:32.680423-04	7	Gases	2	[{"changed": {"fields": ["nombre"]}}]	3	1
81	2021-05-17 22:21:39.176742-04	6	Silla Modelo K	2	[]	3	1
82	2021-05-17 22:21:45.196289-04	5	Mueble moderno 370	2	[]	3	1
83	2021-05-17 22:21:54.657888-04	4	Silla para escritorio D10	2	[{"changed": {"fields": ["valor"]}}]	3	1
84	2021-05-17 22:22:04.222968-04	3	Escritorio Oficina	2	[{"changed": {"fields": ["valor"]}}]	3	1
85	2021-05-17 22:22:21.554634-04	2	Impresora HP 100	2	[{"changed": {"fields": ["valor"]}}]	3	1
86	2021-05-17 22:22:35.919935-04	1	Notebook 5432	2	[{"changed": {"fields": ["valor"]}}]	3	1
87	2021-08-30 21:37:12.431863-04	2	Arica y Parinacota	1	[{"added": {}}]	14	1
88	2021-08-30 21:37:23.819538-04	3	Tarapacá	1	[{"added": {}}]	14	1
89	2021-08-30 21:37:33.573865-04	4	Antofagasta	1	[{"added": {}}]	14	1
90	2021-08-30 21:37:43.310515-04	5	Atacama	1	[{"added": {}}]	14	1
91	2021-08-30 21:37:50.223141-04	6	Coquimbo	1	[{"added": {}}]	14	1
92	2021-08-30 21:43:09.732111-04	7	05 - Valparaíso	1	[{"added": {}}]	14	1
93	2021-08-30 21:43:19.730457-04	8	06 - Del Libertador Bernardo O’ Higginis	1	[{"added": {}}]	14	1
94	2021-08-30 21:43:27.54104-04	9	07 - Maule	1	[{"added": {}}]	14	1
95	2021-08-30 21:43:35.932297-04	10	08 - Bio Bio	1	[{"added": {}}]	14	1
96	2021-08-30 21:43:42.77481-04	11	09 - Araucanía	1	[{"added": {}}]	14	1
97	2021-08-30 21:43:50.09126-04	12	10 - Los Lagos	1	[{"added": {}}]	14	1
98	2021-08-30 21:44:02.822631-04	13	14 - Los Ríos	1	[{"added": {}}]	14	1
99	2021-08-30 21:44:10.855068-04	14	11 - Aisen	1	[{"added": {}}]	14	1
100	2021-08-30 21:44:20.740781-04	15	12 - Magallanes y de la Antártica Chilena	1	[{"added": {}}]	14	1
101	2021-08-30 21:44:28.577587-04	16	13 - Metropolitana de Santiago	1	[{"added": {}}]	14	1
102	2021-08-30 21:47:19.281909-04	14	B1508, Avenida Argentina 3229, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["region"]}}]	2	1
103	2021-08-30 21:47:41.965439-04	15	AB1507, Calle 3 Norte 130, Arica, ARICA Y PARINACOTA	2	[{"changed": {"fields": ["region"]}}]	2	1
104	2021-08-30 21:48:02.101731-04	13	B0542, Limache 4165 sector El Salto, Viña del Mar, VALPARAÍSO	2	[{"changed": {"fields": ["region"]}}]	2	1
105	2021-08-30 21:48:36.535535-04	12	AB0611, El Algarrobo 1721, Sector Pueblo de Indios, San Vicente, LIBERTADOR GRAL. BERNARDO O`HIGGINS	2	[{"changed": {"fields": ["region"]}}]	2	1
106	2021-08-30 21:48:50.938806-04	11	AB0728, Camino Constitución a Chanco o Ruta M-50, Constitución, MAULE	2	[{"changed": {"fields": ["region"]}}]	2	1
107	2021-08-30 21:48:58.831264-04	10	AB0727, Calle 2 Sur 631, esquina Ignacio Carrera Pinto, Parral, MAULE	2	[{"changed": {"fields": ["region"]}}]	2	1
108	2021-08-30 21:49:25.559791-04	9	AB0541, La Hijuela Lote 2, Sector Tapihue, Casablanca, VALPARAÍSO	2	[{"changed": {"fields": ["region"]}}]	2	1
109	2021-08-30 21:49:47.465091-04	8	AB0726, Los Vidales 2221, Curicó, MAULE	2	[{"changed": {"fields": ["region"]}}]	2	1
110	2021-08-30 21:50:00.953858-04	7	AB1307, Avenida Vicuña Mackenna 3276, Melipilla, RM	2	[{"changed": {"fields": ["region"]}}]	2	1
111	2021-08-30 21:50:29.283172-04	2	AB0610, Avenida Salvador Allende 273, Rancagua, RM	2	[{"changed": {"fields": ["region"]}}]	2	1
112	2021-08-30 21:50:42.874489-04	1	AB1308, El Otoño 501, Lampa, RM	2	[{"changed": {"fields": ["region"]}}]	2	1
113	2021-08-30 21:52:12.726427-04	15	AB1507  Arica y Parinacota, Calle 3 Norte 130, Arica	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
114	2021-08-30 21:52:21.827706-04	14	B1508  Arica y Parinacota, Avenida Argentina 3229, Arica	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
115	2021-08-30 21:52:31.965655-04	13	B0542  Valparaíso, Limache 4165 sector El Salto, Viña del Mar	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
116	2021-08-30 21:52:51.872403-04	12	AB0611  Del Libertador Bernardo O’ Higginis, El Algarrobo 1721, Sector Pueblo de Indios, San Vicente	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
117	2021-08-30 21:53:03.943774-04	11	AB0728  Maule, Camino Constitución a Chanco o Ruta M-50, Constitución	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
118	2021-08-30 21:53:14.354383-04	10	AB0727  Maule, Calle 2 Sur 631, esquina Ignacio Carrera Pinto, Parral	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
119	2021-08-30 21:53:22.217971-04	9	AB0541  Valparaíso, La Hijuela Lote 2, Sector Tapihue, Casablanca	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
120	2021-08-30 21:53:43.760252-04	8	AB0726  Maule, Los Vidales 2221, Curicó	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
121	2021-08-30 21:53:53.585371-04	7	AB1307  Metropolitana de Santiago, Avenida Vicuña Mackenna 3276, Melipilla	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
122	2021-08-30 21:54:02.240362-04	2	AB0610  Del Libertador Bernardo O’ Higginis, Avenida Salvador Allende 273, Rancagua	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
123	2021-08-30 21:54:12.126681-04	1	AB1308  Metropolitana de Santiago, El Otoño 501, Lampa	2	[{"changed": {"fields": ["ubicacion"]}}]	2	1
124	2021-08-30 21:58:49.138127-04	1	FL - FRENOMETRO DE LIVIANOS	1	[{"added": {}}]	15	1
125	2021-08-30 21:59:00.4359-04	2	FP - FRENOMETRO DE PESADOS	1	[{"added": {}}]	15	1
126	2021-08-30 21:59:17.976595-04	3	BS - BANCO DE SUSPENSIÓN	1	[{"added": {}}]	15	1
127	2021-08-30 21:59:31.691943-04	4	AL - ALINEADOR AL PASO PARA VEHICULOS LIVIANOS	1	[{"added": {}}]	15	1
128	2021-08-30 21:59:43.032895-04	5	AP - ALINEADOR AL PASO PARA VEHICULOS PESADOS	1	[{"added": {}}]	15	1
129	2021-08-30 21:59:54.730206-04	6	DL - DETECTOR DE HOLGURAS PARA VEHICULOS LIVIANOS	1	[{"added": {}}]	15	1
130	2021-08-30 22:00:05.251101-04	7	DP - DETECTOR DE HOLGURAS PARA VEHICULOS PESADOS	1	[{"added": {}}]	15	1
131	2021-08-30 22:00:16.335909-04	8	AG - ANALIZADOR DE GASES	1	[{"added": {}}]	15	1
132	2021-08-30 22:00:24.701818-04	9	OP - OPACIMETRO	1	[{"added": {}}]	15	1
133	2021-08-30 22:00:33.425553-04	10	SM - SONOMETRO	1	[{"added": {}}]	15	1
134	2021-08-30 22:00:41.230822-04	11	LX - LUXOMETRO	1	[{"added": {}}]	15	1
135	2021-08-30 22:00:48.568026-04	12	CO - COMPRESOR	1	[{"added": {}}]	15	1
136	2021-08-30 22:00:58.646004-04	13	AH - ALZADOR HIDRAULICO	1	[{"added": {}}]	15	1
137	2021-08-30 22:01:08.438591-04	14	DY - DINAMÓMETRO	1	[{"added": {}}]	15	1
138	2021-08-30 22:01:17.548823-04	15	AN - ÁNGULO DE GIRO	1	[{"added": {}}]	15	1
139	2021-08-30 22:01:26.285227-04	16	PM - PIE DE METRO	1	[{"added": {}}]	15	1
140	2021-08-30 22:01:40.13501-04	17	HM - HUINCHA DE MEDIR	1	[{"added": {}}]	15	1
141	2021-08-30 22:02:40.08961-04	18	PF - PROFUNDÍMETRO	1	[{"added": {}}]	15	1
142	2021-08-30 22:02:50.256111-04	19	IM - IMPRESORA	1	[{"added": {}}]	15	1
143	2021-08-30 22:02:58.111893-04	20	PL - PC LINEA	1	[{"added": {}}]	15	1
144	2021-08-30 22:03:06.470702-04	21	PA - PC ADMINISTRATIVO	1	[{"added": {}}]	15	1
145	2021-08-30 22:03:16.947555-04	22	PS - PC SERVIDOR	1	[{"added": {}}]	15	1
146	2021-08-30 22:03:24.007563-04	23	MO - MONITOR	1	[{"added": {}}]	15	1
147	2021-08-30 22:15:24.467126-04	15	Extra	2	[{"changed": {"fields": ["modelo", "familia"]}}]	3	1
148	2021-09-02 20:28:08.600407-04	15	Extra	2	[{"changed": {"fields": ["codigo_interno"]}}]	3	1
149	2021-09-02 20:29:08.433231-04	15	Extra	2	[{"changed": {"fields": ["serie"]}}]	3	1
150	2021-09-02 20:34:19.345936-04	15	Extra	2	[]	3	1
151	2021-09-02 20:34:52.896428-04	15	Extra	2	[]	3	1
152	2021-09-02 20:35:07.911365-04	15	Extra	2	[]	3	1
153	2021-09-02 20:36:22.094087-04	15	Extra	2	[]	3	1
154	2021-09-02 20:36:43.968721-04	15	Extra	2	[]	3	1
155	2021-09-02 20:37:01.765652-04	15	Extra	2	[]	3	1
156	2021-09-02 20:37:26.243697-04	15	Extra	2	[]	3	1
157	2021-09-02 20:37:36.807515-04	15	Extra	2	[]	3	1
158	2021-09-02 20:38:28.969604-04	15	Extra	2	[]	3	1
159	2021-09-02 20:39:15.855942-04	15	Extra	2	[]	3	1
160	2021-09-02 21:40:39.981017-04	15	Extra	2	[{"changed": {"fields": ["linea", "numero_interno"]}}]	3	1
161	2021-09-02 21:41:10.064726-04	15	Extra	2	[]	3	1
162	2021-09-02 21:43:46.822589-04	15	Extra	2	[]	3	1
163	2021-09-02 21:44:00.174952-04	15	Extra	2	[]	3	1
164	2021-09-02 21:45:25.267631-04	15	Extra	2	[]	3	1
165	2021-09-02 21:45:47.439334-04	15	Extra	2	[{"changed": {"fields": ["numero_interno"]}}]	3	1
166	2021-09-02 21:53:10.910725-04	3	Escritorio Oficina	2	[{"changed": {"fields": ["modelo", "planta", "linea", "familia", "numero_interno"]}}]	3	1
167	2021-09-02 21:54:02.59508-04	3	Escritorio Oficina	2	[]	3	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	afijo	estado
2	afijo	planta
3	afijo	activo
4	admin	logentry
5	auth	permission
6	auth	group
7	auth	user
8	contenttypes	contenttype
9	sessions	session
10	afijo	depreciacion
11	afijo	tipodepreciacion
12	afijo	activodepreciacion
13	afijo	movimiento
14	afijo	region
15	afijo	tipofamilia
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-01-07 13:29:25.904352-03
2	auth	0001_initial	2021-01-07 13:29:25.934703-03
3	admin	0001_initial	2021-01-07 13:29:25.965058-03
4	admin	0002_logentry_remove_auto_add	2021-01-07 13:29:25.976004-03
5	admin	0003_logentry_add_action_flag_choices	2021-01-07 13:29:25.983383-03
6	afijo	0001_initial	2021-01-07 13:29:25.997577-03
7	contenttypes	0002_remove_content_type_name	2021-01-07 13:29:26.024804-03
8	auth	0002_alter_permission_name_max_length	2021-01-07 13:29:26.0294-03
9	auth	0003_alter_user_email_max_length	2021-01-07 13:29:26.051103-03
10	auth	0004_alter_user_username_opts	2021-01-07 13:29:26.059856-03
11	auth	0005_alter_user_last_login_null	2021-01-07 13:29:26.068124-03
12	auth	0006_require_contenttypes_0002	2021-01-07 13:29:26.070098-03
13	auth	0007_alter_validators_add_error_messages	2021-01-07 13:29:26.077401-03
14	auth	0008_alter_user_username_max_length	2021-01-07 13:29:26.087483-03
15	auth	0009_alter_user_last_name_max_length	2021-01-07 13:29:26.096289-03
16	auth	0010_alter_group_name_max_length	2021-01-07 13:29:26.105513-03
17	auth	0011_update_proxy_permissions	2021-01-07 13:29:26.114169-03
18	sessions	0001_initial	2021-01-07 13:29:26.119899-03
19	afijo	0002_auto_20210117_1536	2021-01-17 17:42:14.917005-03
20	afijo	0003_auto_20210117_1839	2021-01-17 18:39:43.492137-03
21	afijo	0004_tipodepreciacion	2021-04-29 16:24:07.440232-04
22	afijo	0005_activo_tipodepreciacion	2021-04-29 16:26:39.410664-04
23	afijo	0006_auto_20210501_2137	2021-05-01 21:37:29.61839-04
24	afijo	0007_activodepreciacion	2021-05-03 18:02:11.440864-04
25	afijo	0008_auto_20210504_1325	2021-05-04 13:25:33.955485-04
26	afijo	0009_auto_20210505_1705	2021-05-05 17:06:03.692118-04
27	afijo	0010_auto_20210505_1713	2021-05-05 17:13:23.850241-04
28	afijo	0011_auto_20210506_1049	2021-05-06 10:49:36.379292-04
29	afijo	0012_auto_20210506_1051	2021-05-06 10:51:35.387167-04
30	afijo	0013_auto_20210511_2144	2021-05-11 21:45:02.694484-04
31	afijo	0014_activo_fecha_baja	2021-05-11 21:57:51.010101-04
32	afijo	0015_movimiento	2021-05-11 22:10:37.792939-04
33	afijo	0016_auto_20210514_1540	2021-05-14 15:40:58.686007-04
34	afijo	0017_auto_20210514_2036	2021-05-14 20:36:56.007708-04
35	afijo	0018_auto_20210830_2125	2021-08-30 21:31:15.594506-04
36	afijo	0019_auto_20210830_2134	2021-08-30 21:34:34.023341-04
37	afijo	0020_auto_20210830_2142	2021-08-30 21:42:48.206957-04
38	afijo	0021_tipofamilia	2021-08-30 21:57:30.75754-04
39	afijo	0022_auto_20210830_2213	2021-08-30 22:13:55.093673-04
40	afijo	0023_auto_20210830_2214	2021-08-30 22:14:55.305654-04
41	afijo	0024_activo_numero_interno	2021-09-02 21:31:21.343464-04
42	afijo	0025_auto_20210902_2134	2021-09-02 21:34:05.855971-04
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
lcpbu5yvk72tgbnje493h14haoa213ni	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-01-21 13:32:43.485081-03
br3xgeiygir062t836mjv57kpj8c9aij	MDNiNjNlZWEyYWQzYzAwMjNmZDI0ZTlkOTc0NWQyYmIxZDYxNzJjMTp7fQ==	2021-01-26 13:21:42.398057-03
w6b8y76gxyk0bm4sw8kq0j7crecqhzbh	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-01-26 16:53:37.39963-03
05t2g7yghe5wkd6wv7piluaut7s1qyzt	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-02-01 10:50:15.802527-03
6nk2jy4tx8syufcvl27bdkgpt3zyjh00	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-02-01 12:17:48.449791-03
dtipxsw584rcfirb0ufg12pbov59edbj	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-02-11 11:39:14.417522-03
tmnw4d1kjvgewjym3x01jutrttclowtj	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-02-11 11:43:18.907378-03
97x6yakh2bdkv5ay0g0fv9v4lgazcokw	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-02-16 09:38:41.506378-03
v7mvqllar74amjijk8kfalgg3mqsdjkg	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-02-16 16:18:08.58131-03
wl7vb9o4zn3ajdp1c98xo11do39dulru	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-05-11 10:58:40.43324-04
es3qg8algmn9pcpnm1hq3sjyoqkvilyc	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-05-11 11:13:50.393891-04
oyadeke23gt7fz7ygewkcp60hixalbwh	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-05-18 13:45:57.600287-04
r9eg20tn996r34wogyfrn407z30p0ntc	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-05-24 10:48:02.875408-04
i0bgs14isxbei04flxqdmwia9mvytpyo	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-05-24 10:52:55.924124-04
hiyzcboq97h0gdlst6hwub1oybzog042	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-06-09 10:44:39.783424-04
ix8i1by38mtdtadlk4nkl4ksz4ghxjt2	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-06-09 10:44:59.499665-04
kpsomlt89z69z5o1zxj7sa652k4gqecr	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-06-09 21:04:00.314118-04
epulgs0f8iwxdemr8ka8ukv29e62qaqc	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-08-04 13:41:48.001714-04
rm6c4uyi6eawv2vhw3xn6vqc3qaudrsh	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-09-13 19:51:15.040035-03
a2otkblfhp0o64cazlpbvma9kigu689z	NjJmZTc3ZGVmNWUyYTY2ZWE2MjdiN2JmZDFjMTY4NzIzMTRkODQ2Mjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI5ZTM5MWUxZTIyNGRlY2UwZDUxMzMwMzI5Y2EwMjViNDIzOGIzNTdjIn0=	2021-09-16 21:06:03.751666-03
\.


--
-- Name: afijo_activo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_activo_id_seq', 15, true);


--
-- Name: afijo_activodepreciacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_activodepreciacion_id_seq', 2108, true);


--
-- Name: afijo_estado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_estado_id_seq', 1, false);


--
-- Name: afijo_movimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_movimiento_id_seq', 40, true);


--
-- Name: afijo_planta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_planta_id_seq', 16, true);


--
-- Name: afijo_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_region_id_seq', 16, true);


--
-- Name: afijo_tipodepreciacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_tipodepreciacion_id_seq', 2, true);


--
-- Name: afijo_tipofamilia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.afijo_tipofamilia_id_seq', 23, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 64, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 167, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 15, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 42, true);


--
-- Name: afijo_activo afijo_activo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activo
    ADD CONSTRAINT afijo_activo_pkey PRIMARY KEY (id);


--
-- Name: afijo_activodepreciacion afijo_activodepreciacion_activo_id_planta_id_peri_0a36e692_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activodepreciacion
    ADD CONSTRAINT afijo_activodepreciacion_activo_id_planta_id_peri_0a36e692_uniq UNIQUE (activo_id, planta_id, periodo);


--
-- Name: afijo_activodepreciacion afijo_activodepreciacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activodepreciacion
    ADD CONSTRAINT afijo_activodepreciacion_pkey PRIMARY KEY (id);


--
-- Name: afijo_estado afijo_estado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_estado
    ADD CONSTRAINT afijo_estado_pkey PRIMARY KEY (id);


--
-- Name: afijo_movimiento afijo_movimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_movimiento
    ADD CONSTRAINT afijo_movimiento_pkey PRIMARY KEY (id);


--
-- Name: afijo_planta afijo_planta_nombre_9c0d492f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_planta
    ADD CONSTRAINT afijo_planta_nombre_9c0d492f_uniq UNIQUE (nombre);


--
-- Name: afijo_planta afijo_planta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_planta
    ADD CONSTRAINT afijo_planta_pkey PRIMARY KEY (id);


--
-- Name: afijo_region afijo_region_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_region
    ADD CONSTRAINT afijo_region_codigo_key UNIQUE (codigo);


--
-- Name: afijo_region afijo_region_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_region
    ADD CONSTRAINT afijo_region_nombre_key UNIQUE (nombre);


--
-- Name: afijo_region afijo_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_region
    ADD CONSTRAINT afijo_region_pkey PRIMARY KEY (id);


--
-- Name: afijo_tipodepreciacion afijo_tipodepreciacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_tipodepreciacion
    ADD CONSTRAINT afijo_tipodepreciacion_pkey PRIMARY KEY (id);


--
-- Name: afijo_tipofamilia afijo_tipofamilia_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_tipofamilia
    ADD CONSTRAINT afijo_tipofamilia_codigo_key UNIQUE (codigo);


--
-- Name: afijo_tipofamilia afijo_tipofamilia_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_tipofamilia
    ADD CONSTRAINT afijo_tipofamilia_nombre_key UNIQUE (nombre);


--
-- Name: afijo_tipofamilia afijo_tipofamilia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_tipofamilia
    ADD CONSTRAINT afijo_tipofamilia_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: afijo_activo_estado_id_2aa42d49; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_activo_estado_id_2aa42d49 ON public.afijo_activo USING btree (estado_id);


--
-- Name: afijo_activo_familia_id_780b9213; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_activo_familia_id_780b9213 ON public.afijo_activo USING btree (familia_id);


--
-- Name: afijo_activo_planta_id_d1a56000; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_activo_planta_id_d1a56000 ON public.afijo_activo USING btree (planta_id);


--
-- Name: afijo_activo_tipoDepreciacion_id_8b8e0dfa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "afijo_activo_tipoDepreciacion_id_8b8e0dfa" ON public.afijo_activo USING btree ("tipoDepreciacion_id");


--
-- Name: afijo_activodepreciacion_activo_id_6cce5138; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_activodepreciacion_activo_id_6cce5138 ON public.afijo_activodepreciacion USING btree (activo_id);


--
-- Name: afijo_activodepreciacion_planta_id_9e3979e1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_activodepreciacion_planta_id_9e3979e1 ON public.afijo_activodepreciacion USING btree (planta_id);


--
-- Name: afijo_movimiento_activo_id_a753c65b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_movimiento_activo_id_a753c65b ON public.afijo_movimiento USING btree (activo_id);


--
-- Name: afijo_movimiento_planta_destino_id_130058ef; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_movimiento_planta_destino_id_130058ef ON public.afijo_movimiento USING btree (planta_destino_id);


--
-- Name: afijo_movimiento_planta_origen_id_fa0e7fe6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_movimiento_planta_origen_id_fa0e7fe6 ON public.afijo_movimiento USING btree (planta_origen_id);


--
-- Name: afijo_planta_nombre_9c0d492f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_planta_nombre_9c0d492f_like ON public.afijo_planta USING btree (nombre varchar_pattern_ops);


--
-- Name: afijo_planta_region_id_744426d8; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_planta_region_id_744426d8 ON public.afijo_planta USING btree (region_id);


--
-- Name: afijo_region_codigo_e0f6033e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_region_codigo_e0f6033e_like ON public.afijo_region USING btree (codigo varchar_pattern_ops);


--
-- Name: afijo_region_nombre_9249d157_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_region_nombre_9249d157_like ON public.afijo_region USING btree (nombre varchar_pattern_ops);


--
-- Name: afijo_tipofamilia_codigo_c838f2d5_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_tipofamilia_codigo_c838f2d5_like ON public.afijo_tipofamilia USING btree (codigo varchar_pattern_ops);


--
-- Name: afijo_tipofamilia_nombre_a37be661_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX afijo_tipofamilia_nombre_a37be661_like ON public.afijo_tipofamilia USING btree (nombre varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: afijo_activo afijo_activo_estado_id_2aa42d49_fk_afijo_estado_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activo
    ADD CONSTRAINT afijo_activo_estado_id_2aa42d49_fk_afijo_estado_id FOREIGN KEY (estado_id) REFERENCES public.afijo_estado(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_activo afijo_activo_familia_id_780b9213_fk_afijo_tipofamilia_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activo
    ADD CONSTRAINT afijo_activo_familia_id_780b9213_fk_afijo_tipofamilia_id FOREIGN KEY (familia_id) REFERENCES public.afijo_tipofamilia(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_activo afijo_activo_planta_id_d1a56000_fk_afijo_planta_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activo
    ADD CONSTRAINT afijo_activo_planta_id_d1a56000_fk_afijo_planta_id FOREIGN KEY (planta_id) REFERENCES public.afijo_planta(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_activo afijo_activo_tipoDepreciacion_id_8b8e0dfa_fk_afijo_tip; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activo
    ADD CONSTRAINT "afijo_activo_tipoDepreciacion_id_8b8e0dfa_fk_afijo_tip" FOREIGN KEY ("tipoDepreciacion_id") REFERENCES public.afijo_tipodepreciacion(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_activodepreciacion afijo_activodepreciacion_activo_id_6cce5138_fk_afijo_activo_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activodepreciacion
    ADD CONSTRAINT afijo_activodepreciacion_activo_id_6cce5138_fk_afijo_activo_id FOREIGN KEY (activo_id) REFERENCES public.afijo_activo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_activodepreciacion afijo_activodepreciacion_planta_id_9e3979e1_fk_afijo_planta_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_activodepreciacion
    ADD CONSTRAINT afijo_activodepreciacion_planta_id_9e3979e1_fk_afijo_planta_id FOREIGN KEY (planta_id) REFERENCES public.afijo_planta(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_movimiento afijo_movimiento_activo_id_a753c65b_fk_afijo_activo_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_movimiento
    ADD CONSTRAINT afijo_movimiento_activo_id_a753c65b_fk_afijo_activo_id FOREIGN KEY (activo_id) REFERENCES public.afijo_activo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_movimiento afijo_movimiento_planta_destino_id_130058ef_fk_afijo_planta_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_movimiento
    ADD CONSTRAINT afijo_movimiento_planta_destino_id_130058ef_fk_afijo_planta_id FOREIGN KEY (planta_destino_id) REFERENCES public.afijo_planta(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_movimiento afijo_movimiento_planta_origen_id_fa0e7fe6_fk_afijo_planta_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_movimiento
    ADD CONSTRAINT afijo_movimiento_planta_origen_id_fa0e7fe6_fk_afijo_planta_id FOREIGN KEY (planta_origen_id) REFERENCES public.afijo_planta(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: afijo_planta afijo_planta_region_id_744426d8_fk_afijo_region_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afijo_planta
    ADD CONSTRAINT afijo_planta_region_id_744426d8_fk_afijo_region_id FOREIGN KEY (region_id) REFERENCES public.afijo_region(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA public TO systech;


--
-- Name: TABLE afijo_activo; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.afijo_activo TO systech;


--
-- Name: SEQUENCE afijo_activo_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.afijo_activo_id_seq TO systech;


--
-- Name: TABLE afijo_activodepreciacion; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.afijo_activodepreciacion TO systech;


--
-- Name: SEQUENCE afijo_activodepreciacion_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.afijo_activodepreciacion_id_seq TO systech;


--
-- Name: TABLE afijo_estado; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.afijo_estado TO systech;


--
-- Name: SEQUENCE afijo_estado_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.afijo_estado_id_seq TO systech;


--
-- Name: TABLE afijo_movimiento; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.afijo_movimiento TO systech;


--
-- Name: SEQUENCE afijo_movimiento_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.afijo_movimiento_id_seq TO systech;


--
-- Name: TABLE afijo_planta; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.afijo_planta TO systech;


--
-- Name: SEQUENCE afijo_planta_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.afijo_planta_id_seq TO systech;


--
-- Name: TABLE afijo_tipodepreciacion; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.afijo_tipodepreciacion TO systech;


--
-- Name: SEQUENCE afijo_tipodepreciacion_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.afijo_tipodepreciacion_id_seq TO systech;


--
-- Name: TABLE auth_group; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_group TO systech;


--
-- Name: SEQUENCE auth_group_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.auth_group_id_seq TO systech;


--
-- Name: TABLE auth_group_permissions; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_group_permissions TO systech;


--
-- Name: SEQUENCE auth_group_permissions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.auth_group_permissions_id_seq TO systech;


--
-- Name: TABLE auth_permission; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_permission TO systech;


--
-- Name: SEQUENCE auth_permission_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.auth_permission_id_seq TO systech;


--
-- Name: TABLE auth_user; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_user TO systech;


--
-- Name: TABLE auth_user_groups; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_user_groups TO systech;


--
-- Name: SEQUENCE auth_user_groups_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.auth_user_groups_id_seq TO systech;


--
-- Name: SEQUENCE auth_user_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.auth_user_id_seq TO systech;


--
-- Name: TABLE auth_user_user_permissions; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auth_user_user_permissions TO systech;


--
-- Name: SEQUENCE auth_user_user_permissions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.auth_user_user_permissions_id_seq TO systech;


--
-- Name: TABLE django_admin_log; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.django_admin_log TO systech;


--
-- Name: SEQUENCE django_admin_log_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.django_admin_log_id_seq TO systech;


--
-- Name: TABLE django_content_type; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.django_content_type TO systech;


--
-- Name: SEQUENCE django_content_type_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.django_content_type_id_seq TO systech;


--
-- Name: TABLE django_migrations; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.django_migrations TO systech;


--
-- Name: SEQUENCE django_migrations_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.django_migrations_id_seq TO systech;


--
-- Name: TABLE django_session; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.django_session TO systech;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO systech;


--
-- PostgreSQL database dump complete
--

