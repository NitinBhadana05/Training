--
-- PostgreSQL database dump
--

\restrict WzQlqmjTxSNj50rbxMRYN6jxNQbzggL03fbDmPYGazvYuHn0tVpbYGk4jGFX2Yh

-- Dumped from database version 17.8 (Ubuntu 17.8-1.pgdg24.04+1)
-- Dumped by pg_dump version 17.8 (Ubuntu 17.8-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: airline; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA airline;


ALTER SCHEMA airline OWNER TO postgres;

--
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- Name: ecommerce; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ecommerce;


ALTER SCHEMA ecommerce OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aircraft; Type: TABLE; Schema: airline; Owner: postgres
--

CREATE TABLE airline.aircraft (
    aid integer NOT NULL,
    aname character varying(100) NOT NULL,
    cruisingrange integer NOT NULL,
    CONSTRAINT aircraft_cruisingrange_check CHECK ((cruisingrange > 0))
);


ALTER TABLE airline.aircraft OWNER TO postgres;

--
-- Name: certified; Type: TABLE; Schema: airline; Owner: postgres
--

CREATE TABLE airline.certified (
    eid integer NOT NULL,
    aid integer NOT NULL
);


ALTER TABLE airline.certified OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: airline; Owner: postgres
--

CREATE TABLE airline.employees (
    eid integer NOT NULL,
    ename character varying(100) NOT NULL,
    salary integer NOT NULL,
    CONSTRAINT employees_salary_check CHECK ((salary > 0))
);


ALTER TABLE airline.employees OWNER TO postgres;

--
-- Name: flights; Type: TABLE; Schema: airline; Owner: postgres
--

CREATE TABLE airline.flights (
    flno integer NOT NULL,
    "from" character varying(100) NOT NULL,
    "to" character varying(100) NOT NULL,
    distance integer NOT NULL,
    departs time without time zone NOT NULL,
    arrives time without time zone NOT NULL,
    price integer NOT NULL,
    CONSTRAINT arrival_after_departure CHECK ((arrives > departs)),
    CONSTRAINT flights_check CHECK ((("from")::text <> ("to")::text)),
    CONSTRAINT flights_distance_check CHECK ((distance > 0)),
    CONSTRAINT flights_price_check CHECK ((price > 0))
);


ALTER TABLE airline.flights OWNER TO postgres;

--
-- Name: attendance; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.attendance (
    attendance_id integer NOT NULL,
    employee_id integer NOT NULL,
    attendance_date date NOT NULL,
    check_in_time timestamp without time zone,
    check_out_time timestamp without time zone,
    status character varying(10) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['present'::character varying, 'absent'::character varying])::text[]))),
    CONSTRAINT chk_status_time_logic CHECK (((((status)::text = 'present'::text) AND (check_in_time IS NOT NULL) AND (check_out_time IS NOT NULL)) OR (((status)::text = 'absent'::text) AND (check_in_time IS NULL) AND (check_out_time IS NULL)))),
    CONSTRAINT chk_time_order CHECK (((check_out_time IS NULL) OR (check_out_time > check_in_time)))
);


ALTER TABLE core.attendance OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.attendance_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.attendance_attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.attendance_attendance_id_seq OWNED BY core.attendance.attendance_id;


--
-- Name: departments; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.departments (
    department_id integer NOT NULL,
    department_name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);


ALTER TABLE core.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.departments_department_id_seq OWNED BY core.departments.department_id;


--
-- Name: employee_projects; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.employee_projects (
    assignment_id integer NOT NULL,
    employee_id integer NOT NULL,
    project_id integer NOT NULL,
    project_role character varying(20) NOT NULL,
    assigned_date date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_project_role CHECK (((project_role)::text = ANY ((ARRAY['frontend'::character varying, 'backend'::character varying, 'fullstack'::character varying, 'lead'::character varying, 'tester'::character varying])::text[])))
);


ALTER TABLE core.employee_projects OWNER TO postgres;

--
-- Name: employee_projects_assignment_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.employee_projects_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.employee_projects_assignment_id_seq OWNER TO postgres;

--
-- Name: employee_projects_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.employee_projects_assignment_id_seq OWNED BY core.employee_projects.assignment_id;


--
-- Name: employees; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.employees (
    employee_id integer NOT NULL,
    employee_name character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    salary numeric(10,2) NOT NULL,
    date_of_join date NOT NULL,
    department_id integer,
    manager_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true,
    CONSTRAINT chk_role CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'manager'::character varying, 'employee'::character varying])::text[]))),
    CONSTRAINT chk_salary CHECK ((salary >= (0)::numeric))
);


ALTER TABLE core.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.employees_employee_id_seq OWNED BY core.employees.employee_id;


--
-- Name: projects; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.projects (
    project_id integer NOT NULL,
    project_name character varying(100) NOT NULL,
    department_id integer NOT NULL,
    project_budget numeric(10,2) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true,
    CONSTRAINT chk_budget CHECK ((project_budget >= (0)::numeric)),
    CONSTRAINT chk_end_date CHECK (((end_date IS NULL) OR (end_date > start_date)))
);


ALTER TABLE core.projects OWNER TO postgres;

--
-- Name: projects_project_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.projects_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.projects_project_id_seq OWNER TO postgres;

--
-- Name: projects_project_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.projects_project_id_seq OWNED BY core.projects.project_id;


--
-- Name: categories; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.categories (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE ecommerce.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.categories_id_seq OWNED BY ecommerce.categories.id;


--
-- Name: inventory; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.inventory (
    id integer NOT NULL,
    product_id integer,
    stock integer,
    warehouse_location character varying(100),
    last_updated timestamp without time zone
);


ALTER TABLE ecommerce.inventory OWNER TO postgres;

--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.inventory_id_seq OWNER TO postgres;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.inventory_id_seq OWNED BY ecommerce.inventory.id;


--
-- Name: order_items; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.order_items (
    id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer,
    price numeric(10,2)
);


ALTER TABLE ecommerce.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.order_items_id_seq OWNED BY ecommerce.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.orders (
    id integer NOT NULL,
    user_id integer,
    order_date timestamp without time zone,
    status character varying(50)
);


ALTER TABLE ecommerce.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.orders_id_seq OWNED BY ecommerce.orders.id;


--
-- Name: payments; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.payments (
    id integer NOT NULL,
    order_id integer,
    payment_method character varying(50),
    payment_date timestamp without time zone,
    amount numeric(10,2),
    status character varying(50)
);


ALTER TABLE ecommerce.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.payments_id_seq OWNED BY ecommerce.payments.id;


--
-- Name: products; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.products (
    id integer NOT NULL,
    name character varying(150),
    category_id integer,
    price numeric(10,2),
    created_at timestamp without time zone
);


ALTER TABLE ecommerce.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.products_id_seq OWNED BY ecommerce.products.id;


--
-- Name: reviews; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.reviews (
    id integer NOT NULL,
    user_id integer,
    product_id integer,
    rating integer,
    comment text,
    review_date timestamp without time zone
);


ALTER TABLE ecommerce.reviews OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.reviews_id_seq OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.reviews_id_seq OWNED BY ecommerce.reviews.id;


--
-- Name: shipments; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.shipments (
    id integer NOT NULL,
    order_id integer,
    shipped_date timestamp without time zone,
    delivery_date timestamp without time zone,
    carrier character varying(100),
    tracking_number character varying(100)
);


ALTER TABLE ecommerce.shipments OWNER TO postgres;

--
-- Name: shipments_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.shipments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.shipments_id_seq OWNER TO postgres;

--
-- Name: shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.shipments_id_seq OWNED BY ecommerce.shipments.id;


--
-- Name: users; Type: TABLE; Schema: ecommerce; Owner: postgres
--

CREATE TABLE ecommerce.users (
    id integer NOT NULL,
    name character varying(100),
    email character varying(150),
    city character varying(100),
    signup_date date
);


ALTER TABLE ecommerce.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: ecommerce; Owner: postgres
--

CREATE SEQUENCE ecommerce.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ecommerce.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: ecommerce; Owner: postgres
--

ALTER SEQUENCE ecommerce.users_id_seq OWNED BY ecommerce.users.id;


--
-- Name: attendance attendance_id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('core.attendance_attendance_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.departments ALTER COLUMN department_id SET DEFAULT nextval('core.departments_department_id_seq'::regclass);


--
-- Name: employee_projects assignment_id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employee_projects ALTER COLUMN assignment_id SET DEFAULT nextval('core.employee_projects_assignment_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employees ALTER COLUMN employee_id SET DEFAULT nextval('core.employees_employee_id_seq'::regclass);


--
-- Name: projects project_id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.projects ALTER COLUMN project_id SET DEFAULT nextval('core.projects_project_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.categories ALTER COLUMN id SET DEFAULT nextval('ecommerce.categories_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.inventory ALTER COLUMN id SET DEFAULT nextval('ecommerce.inventory_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.order_items ALTER COLUMN id SET DEFAULT nextval('ecommerce.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.orders ALTER COLUMN id SET DEFAULT nextval('ecommerce.orders_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.payments ALTER COLUMN id SET DEFAULT nextval('ecommerce.payments_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.products ALTER COLUMN id SET DEFAULT nextval('ecommerce.products_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.reviews ALTER COLUMN id SET DEFAULT nextval('ecommerce.reviews_id_seq'::regclass);


--
-- Name: shipments id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.shipments ALTER COLUMN id SET DEFAULT nextval('ecommerce.shipments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.users ALTER COLUMN id SET DEFAULT nextval('ecommerce.users_id_seq'::regclass);


--
-- Data for Name: aircraft; Type: TABLE DATA; Schema: airline; Owner: postgres
--

COPY airline.aircraft (aid, aname, cruisingrange) FROM stdin;
1	Boeing 737	3200
2	Boeing 747	8000
3	Boeing 767	7000
4	Boeing 777	9700
5	Boeing 787 Dreamliner	7600
6	Airbus A320	3300
7	Airbus A330	7200
8	Airbus A340	8000
9	Airbus A350	8100
10	Airbus A380	9400
11	Embraer E190	2800
12	Bombardier CRJ900	2500
13	Cessna 172	800
14	Gulfstream G650	7500
15	ATR 72	900
\.


--
-- Data for Name: certified; Type: TABLE DATA; Schema: airline; Owner: postgres
--

COPY airline.certified (eid, aid) FROM stdin;
1	7
1	4
1	10
2	10
3	4
3	6
3	7
3	5
4	7
4	2
5	15
6	12
6	15
6	7
7	6
8	4
8	15
9	6
9	3
9	8
9	12
10	15
10	13
10	7
11	3
12	2
12	8
12	7
12	5
13	8
13	9
13	14
14	3
14	4
14	15
14	9
14	10
15	12
15	9
15	6
16	11
16	10
16	15
16	14
16	8
17	5
17	6
17	12
18	12
18	2
18	13
19	11
19	4
19	8
20	12
20	3
20	14
20	2
1	1
2	1
3	1
4	1
5	1
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: airline; Owner: postgres
--

COPY airline.employees (eid, ename, salary) FROM stdin;
4	Rahul Deshmukh	83000
6	Aniket Pawar	45000
7	Neha Patil	58000
8	Vikram Shinde	76000
9	Priya Kulkarni	67000
10	Sagar Jadhav	52000
11	Kiran Patil	64000
12	Anjali Sharma	71000
13	Ramesh Pawar	49000
14	Sunita Deshmukh	55000
15	Ajay Kulkarni	88000
16	Meena Patil	62000
17	Sanjay Shinde	59000
18	Deepak Jadhav	77000
19	Kavita Pawar	53000
20	Nitin Patil	81000
21	Shweta Kulkarni	60000
22	Prakash Jadhav	56000
23	Manisha Deshmukh	63000
24	Yogesh Patil	74000
25	Vaishali Pawar	51000
26	Mahesh Kulkarni	82000
27	Gauri Patil	47000
28	Akash Shinde	69000
29	Reshma Jadhav	54000
30	Rohini Pawar	62000
31	Swapnil Patil	70000
32	Madhuri Kulkarni	65000
33	Abhishek Sharma	78000
34	Sonal Patil	59000
35	Tejas Jadhav	73000
36	Varsha Deshmukh	52000
37	Amol Pawar	61000
38	Pallavi Patil	66000
39	Ganesh Kulkarni	84000
40	Archana Shinde	57000
41	Tushar Patil	75000
42	Nisha Jadhav	53000
43	Omkar Pawar	68000
44	Komal Kulkarni	62000
45	Sachin Patil	79000
46	Bhavana Deshmukh	56000
47	Harish Pawar	64000
48	Tanvi Kulkarni	60000
49	Rohit Jadhav	72000
50	Anita Patil	58000
1	Amit Sharma	90000
2	Rohit Patil	90000
3	Sneha Kulkarni	90000
5	Pooja Joshi	90000
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: airline; Owner: postgres
--

COPY airline.flights (flno, "from", "to", distance, departs, arrives, price) FROM stdin;
101	Los Angeles	Chicago	2800	06:00:00	10:00:00	350
102	Los Angeles	Chicago	2800	12:00:00	16:00:00	370
103	Los Angeles	Chicago	2800	18:00:00	22:00:00	360
104	Los Angeles	Honolulu	4100	07:00:00	12:00:00	550
105	Los Angeles	Honolulu	4100	13:00:00	18:00:00	580
106	Chicago	New York	1200	08:00:00	11:00:00	200
107	Chicago	New York	1200	14:00:00	17:00:00	210
108	Chicago	New York	1200	19:00:00	22:00:00	205
109	Madison	Chicago	250	06:30:00	08:00:00	120
110	Madison	Chicago	250	11:30:00	13:00:00	125
111	Madison	Chicago	250	17:30:00	19:00:00	130
112	Chicago	Honolulu	4200	09:00:00	15:00:00	600
113	Chicago	Honolulu	4200	15:00:00	21:00:00	620
114	New York	Los Angeles	2800	07:30:00	12:30:00	400
115	New York	Los Angeles	2800	16:00:00	21:00:00	420
116	New York	Chicago	1200	09:30:00	12:00:00	190
117	New York	Chicago	1200	17:30:00	20:00:00	200
118	Madison	New York	1400	07:00:00	11:00:00	240
119	Madison	New York	1400	15:00:00	19:00:00	250
120	Los Angeles	New York	2800	08:00:00	14:00:00	450
121	Los Angeles	New York	2800	17:00:00	23:00:00	470
122	Honolulu	Los Angeles	4100	08:30:00	14:30:00	540
123	Honolulu	Los Angeles	4100	15:30:00	21:30:00	560
124	Chicago	Madison	250	10:00:00	11:30:00	115
125	Chicago	Madison	250	18:00:00	19:30:00	120
126	New York	Madison	1400	06:00:00	10:00:00	230
127	New York	Madison	1400	14:00:00	18:00:00	240
128	Los Angeles	Seattle	1500	09:00:00	12:00:00	210
129	Los Angeles	Seattle	1500	18:00:00	21:00:00	220
130	Seattle	Chicago	2000	07:00:00	11:00:00	300
131	Seattle	Chicago	2000	15:00:00	19:00:00	320
132	Chicago	Seattle	2000	08:30:00	12:30:00	310
133	Chicago	Seattle	2000	17:30:00	21:30:00	330
134	Seattle	Los Angeles	1500	06:30:00	09:30:00	205
135	Seattle	Los Angeles	1500	16:30:00	19:30:00	215
136	Honolulu	Chicago	4200	09:00:00	16:00:00	610
137	Honolulu	Chicago	4200	20:00:00	23:59:00	630
138	New York	Honolulu	5000	06:00:00	14:00:00	700
139	New York	Honolulu	5000	13:00:00	21:00:00	720
140	Honolulu	New York	5000	10:00:00	18:00:00	690
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.attendance (attendance_id, employee_id, attendance_date, check_in_time, check_out_time, status, created_at) FROM stdin;
6	3	2025-12-02	2025-12-02 09:41:57.009527	2025-12-02 17:07:34.936258	present	2026-03-02 15:43:44.318533
7	4	2025-12-02	2025-12-02 09:51:33.340951	2025-12-02 17:32:04.646245	present	2026-03-02 15:43:44.318533
8	5	2025-12-02	2025-12-02 09:23:40.606291	2025-12-02 17:46:58.629176	present	2026-03-02 15:43:44.318533
9	6	2025-12-02	2025-12-02 09:09:24.680555	2025-12-02 17:41:40.015035	present	2026-03-02 15:43:44.318533
10	10	2025-12-02	2025-12-02 09:51:04.002091	2025-12-02 17:48:22.930447	present	2026-03-02 15:43:44.318533
11	11	2025-12-02	2025-12-02 09:49:43.162688	2025-12-02 17:58:58.965831	present	2026-03-02 15:43:44.318533
12	27	2025-12-02	2025-12-02 09:37:39.485707	2025-12-02 17:25:26.428795	present	2026-03-02 15:43:44.318533
13	33	2025-12-02	2025-12-02 09:15:47.905626	2025-12-02 17:13:32.779792	present	2026-03-02 15:43:44.318533
14	35	2025-12-02	2025-12-02 09:14:33.674156	2025-12-02 17:24:51.915806	present	2026-03-02 15:43:44.318533
15	37	2025-12-02	2025-12-02 09:32:18.305797	2025-12-02 17:55:40.519478	present	2026-03-02 15:43:44.318533
16	43	2025-12-02	2025-12-02 09:41:37.108452	2025-12-02 17:23:38.998964	present	2026-03-02 15:43:44.318533
17	45	2025-12-02	2025-12-02 09:19:49.976464	2025-12-02 17:10:03.846696	present	2026-03-02 15:43:44.318533
18	46	2025-12-02	2025-12-02 09:41:48.490411	2025-12-02 17:00:37.248826	present	2026-03-02 15:43:44.318533
19	47	2025-12-02	2025-12-02 09:03:02.343528	2025-12-02 17:22:16.848931	present	2026-03-02 15:43:44.318533
20	48	2025-12-02	2025-12-02 09:00:47.854667	2025-12-02 17:29:56.899094	present	2026-03-02 15:43:44.318533
21	50	2025-12-02	2025-12-02 09:43:21.154246	2025-12-02 17:23:52.247368	present	2026-03-02 15:43:44.318533
22	52	2025-12-02	2025-12-02 09:28:46.345601	2025-12-02 17:19:43.719415	present	2026-03-02 15:43:44.318533
23	59	2025-12-02	2025-12-02 09:41:03.458196	2025-12-02 17:44:44.871648	present	2026-03-02 15:43:44.318533
24	60	2025-12-02	2025-12-02 09:33:36.769062	2025-12-02 17:29:21.476026	present	2026-03-02 15:43:44.318533
25	62	2025-12-02	2025-12-02 09:33:13.893842	2025-12-02 17:26:47.308984	present	2026-03-02 15:43:44.318533
26	63	2025-12-02	2025-12-02 09:31:11.933709	2025-12-02 17:59:38.573171	present	2026-03-02 15:43:44.318533
27	64	2025-12-02	2025-12-02 09:59:22.510804	2025-12-02 17:25:34.916097	present	2026-03-02 15:43:44.318533
28	65	2025-12-02	2025-12-02 09:28:17.271872	2025-12-02 17:18:39.374316	present	2026-03-02 15:43:44.318533
29	66	2025-12-02	2025-12-02 09:51:15.125314	2025-12-02 17:07:13.807649	present	2026-03-02 15:43:44.318533
30	70	2025-12-02	2025-12-02 09:42:34.56615	2025-12-02 17:38:31.984018	present	2026-03-02 15:43:44.318533
31	71	2025-12-02	2025-12-02 09:49:37.528383	2025-12-02 17:23:37.460837	present	2026-03-02 15:43:44.318533
32	73	2025-12-02	2025-12-02 09:34:39.61708	2025-12-02 17:55:14.962703	present	2026-03-02 15:43:44.318533
33	74	2025-12-02	2025-12-02 09:48:38.273082	2025-12-02 17:15:53.745783	present	2026-03-02 15:43:44.318533
34	78	2025-12-02	2025-12-02 09:23:51.050792	2025-12-02 17:13:41.237571	present	2026-03-02 15:43:44.318533
35	79	2025-12-02	2025-12-02 09:58:29.455102	2025-12-02 17:58:09.183985	present	2026-03-02 15:43:44.318533
36	82	2025-12-02	2025-12-02 09:00:02.941797	2025-12-02 17:53:07.511359	present	2026-03-02 15:43:44.318533
37	83	2025-12-02	2025-12-02 09:22:47.124397	2025-12-02 17:57:39.931666	present	2026-03-02 15:43:44.318533
38	84	2025-12-02	2025-12-02 09:37:10.295354	2025-12-02 17:41:39.144377	present	2026-03-02 15:43:44.318533
39	85	2025-12-02	2025-12-02 09:34:31.54806	2025-12-02 17:08:04.671977	present	2026-03-02 15:43:44.318533
40	88	2025-12-02	2025-12-02 09:48:46.562033	2025-12-02 17:09:28.301321	present	2026-03-02 15:43:44.318533
41	89	2025-12-02	2025-12-02 09:11:27.58691	2025-12-02 17:48:42.43002	present	2026-03-02 15:43:44.318533
42	96	2025-12-02	2025-12-02 09:13:29.882969	2025-12-02 17:45:28.459394	present	2026-03-02 15:43:44.318533
43	97	2025-12-02	2025-12-02 09:50:52.597777	2025-12-02 17:28:29.548035	present	2026-03-02 15:43:44.318533
44	1	2025-12-02	2025-12-02 09:31:33.470813	2025-12-02 17:33:18.39085	present	2026-03-02 15:43:44.318533
45	2	2025-12-02	2025-12-02 09:25:07.155549	2025-12-02 17:13:46.817514	present	2026-03-02 15:43:44.318533
46	7	2025-12-02	2025-12-02 09:43:57.416919	2025-12-02 17:16:46.92993	present	2026-03-02 15:43:44.318533
47	8	2025-12-02	2025-12-02 09:26:27.067519	2025-12-02 17:27:54.393855	present	2026-03-02 15:43:44.318533
48	9	2025-12-02	2025-12-02 09:31:06.592745	2025-12-02 17:19:37.493268	present	2026-03-02 15:43:44.318533
49	12	2025-12-02	2025-12-02 09:05:05.287247	2025-12-02 17:50:07.194839	present	2026-03-02 15:43:44.318533
50	13	2025-12-02	2025-12-02 09:49:06.719961	2025-12-02 17:53:45.029506	present	2026-03-02 15:43:44.318533
51	14	2025-12-02	2025-12-02 09:35:06.810055	2025-12-02 17:33:07.970633	present	2026-03-02 15:43:44.318533
52	15	2025-12-02	2025-12-02 09:53:25.170855	2025-12-02 17:46:02.502746	present	2026-03-02 15:43:44.318533
53	16	2025-12-02	2025-12-02 09:04:10.417378	2025-12-02 17:21:12.003372	present	2026-03-02 15:43:44.318533
54	17	2025-12-02	2025-12-02 09:25:45.710537	2025-12-02 17:19:09.12329	present	2026-03-02 15:43:44.318533
55	18	2025-12-02	2025-12-02 09:42:52.081788	2025-12-02 17:31:26.601807	present	2026-03-02 15:43:44.318533
56	19	2025-12-02	2025-12-02 09:17:56.161511	2025-12-02 17:58:52.062174	present	2026-03-02 15:43:44.318533
57	20	2025-12-02	2025-12-02 09:10:47.267077	2025-12-02 17:33:36.543267	present	2026-03-02 15:43:44.318533
58	21	2025-12-02	2025-12-02 09:40:53.299879	2025-12-02 17:03:11.975732	present	2026-03-02 15:43:44.318533
59	22	2025-12-02	2025-12-02 09:59:03.352483	2025-12-02 17:12:20.987311	present	2026-03-02 15:43:44.318533
60	23	2025-12-02	2025-12-02 09:02:30.709153	2025-12-02 17:23:48.057351	present	2026-03-02 15:43:44.318533
61	24	2025-12-02	2025-12-02 09:10:33.30033	2025-12-02 17:12:54.385457	present	2026-03-02 15:43:44.318533
62	25	2025-12-02	2025-12-02 09:40:32.832	2025-12-02 17:43:07.274514	present	2026-03-02 15:43:44.318533
63	26	2025-12-02	2025-12-02 09:01:31.503702	2025-12-02 17:41:50.17396	present	2026-03-02 15:43:44.318533
64	28	2025-12-02	2025-12-02 09:00:33.643664	2025-12-02 17:32:08.539654	present	2026-03-02 15:43:44.318533
65	29	2025-12-02	2025-12-02 09:47:59.019914	2025-12-02 17:27:38.680688	present	2026-03-02 15:43:44.318533
66	30	2025-12-02	2025-12-02 09:32:02.976517	2025-12-02 17:33:22.000847	present	2026-03-02 15:43:44.318533
67	31	2025-12-02	2025-12-02 09:38:28.682074	2025-12-02 17:51:30.410939	present	2026-03-02 15:43:44.318533
68	32	2025-12-02	2025-12-02 09:40:55.235146	2025-12-02 17:39:11.143665	present	2026-03-02 15:43:44.318533
69	34	2025-12-02	2025-12-02 09:16:36.455244	2025-12-02 17:21:27.623667	present	2026-03-02 15:43:44.318533
70	36	2025-12-02	2025-12-02 09:38:55.934069	2025-12-02 17:39:01.561737	present	2026-03-02 15:43:44.318533
71	38	2025-12-02	2025-12-02 09:22:32.383343	2025-12-02 17:30:43.068309	present	2026-03-02 15:43:44.318533
72	39	2025-12-02	2025-12-02 09:37:18.000096	2025-12-02 17:28:56.370138	present	2026-03-02 15:43:44.318533
73	40	2025-12-02	2025-12-02 09:39:29.242909	2025-12-02 17:49:25.574842	present	2026-03-02 15:43:44.318533
74	41	2025-12-02	2025-12-02 09:57:39.522767	2025-12-02 17:13:36.545945	present	2026-03-02 15:43:44.318533
75	42	2025-12-02	2025-12-02 09:29:51.517285	2025-12-02 17:25:36.488045	present	2026-03-02 15:43:44.318533
76	44	2025-12-02	2025-12-02 09:13:25.425007	2025-12-02 17:32:12.099087	present	2026-03-02 15:43:44.318533
77	49	2025-12-02	2025-12-02 09:50:13.323463	2025-12-02 17:07:54.715507	present	2026-03-02 15:43:44.318533
78	51	2025-12-02	2025-12-02 09:14:17.511389	2025-12-02 17:04:55.576675	present	2026-03-02 15:43:44.318533
79	53	2025-12-02	2025-12-02 09:12:59.551022	2025-12-02 17:31:46.18316	present	2026-03-02 15:43:44.318533
80	54	2025-12-02	2025-12-02 09:28:45.523391	2025-12-02 17:21:35.720147	present	2026-03-02 15:43:44.318533
81	55	2025-12-02	2025-12-02 09:33:06.833866	2025-12-02 17:46:43.515514	present	2026-03-02 15:43:44.318533
82	56	2025-12-02	2025-12-02 09:08:08.693482	2025-12-02 17:13:39.753983	present	2026-03-02 15:43:44.318533
83	57	2025-12-02	2025-12-02 09:48:30.994125	2025-12-02 17:59:52.860607	present	2026-03-02 15:43:44.318533
84	58	2025-12-02	2025-12-02 09:21:01.233973	2025-12-02 17:13:52.85412	present	2026-03-02 15:43:44.318533
85	61	2025-12-02	2025-12-02 09:24:28.268653	2025-12-02 17:53:40.47962	present	2026-03-02 15:43:44.318533
86	67	2025-12-02	2025-12-02 09:42:36.121757	2025-12-02 17:19:13.420618	present	2026-03-02 15:43:44.318533
87	68	2025-12-02	2025-12-02 09:08:47.061543	2025-12-02 17:09:19.491165	present	2026-03-02 15:43:44.318533
88	69	2025-12-02	2025-12-02 09:57:39.590701	2025-12-02 17:27:25.320173	present	2026-03-02 15:43:44.318533
89	72	2025-12-02	2025-12-02 09:37:17.605089	2025-12-02 17:07:55.463007	present	2026-03-02 15:43:44.318533
90	75	2025-12-02	2025-12-02 09:10:11.094533	2025-12-02 17:02:06.892192	present	2026-03-02 15:43:44.318533
91	76	2025-12-02	2025-12-02 09:34:22.754321	2025-12-02 17:45:14.13994	present	2026-03-02 15:43:44.318533
92	77	2025-12-02	2025-12-02 09:18:53.282089	2025-12-02 17:00:45.577946	present	2026-03-02 15:43:44.318533
93	80	2025-12-02	2025-12-02 09:14:23.840933	2025-12-02 17:27:23.688269	present	2026-03-02 15:43:44.318533
94	81	2025-12-02	2025-12-02 09:26:21.54899	2025-12-02 17:25:43.201221	present	2026-03-02 15:43:44.318533
95	86	2025-12-02	2025-12-02 09:10:41.007702	2025-12-02 17:04:37.271683	present	2026-03-02 15:43:44.318533
96	87	2025-12-02	2025-12-02 09:18:10.316782	2025-12-02 17:17:37.955255	present	2026-03-02 15:43:44.318533
97	90	2025-12-02	2025-12-02 09:58:05.632971	2025-12-02 17:52:41.480006	present	2026-03-02 15:43:44.318533
98	91	2025-12-02	2025-12-02 09:40:44.385985	2025-12-02 17:49:30.429533	present	2026-03-02 15:43:44.318533
99	92	2025-12-02	2025-12-02 09:09:11.494342	2025-12-02 17:49:22.328702	present	2026-03-02 15:43:44.318533
100	93	2025-12-02	2025-12-02 09:14:59.110339	2025-12-02 17:40:20.053694	present	2026-03-02 15:43:44.318533
101	94	2025-12-02	2025-12-02 09:34:21.965546	2025-12-02 17:59:59.039328	present	2026-03-02 15:43:44.318533
102	95	2025-12-02	2025-12-02 09:09:33.847897	2025-12-02 17:27:29.309877	present	2026-03-02 15:43:44.318533
103	98	2025-12-02	2025-12-02 09:11:19.156337	2025-12-02 17:58:22.67004	present	2026-03-02 15:43:44.318533
104	99	2025-12-02	2025-12-02 09:25:55.067903	2025-12-02 17:47:26.87213	present	2026-03-02 15:43:44.318533
105	100	2025-12-02	2025-12-02 09:59:00.367249	2025-12-02 17:02:08.493239	present	2026-03-02 15:43:44.318533
106	3	2025-12-03	2025-12-03 09:33:15.042042	2025-12-03 17:00:37.575065	present	2026-03-02 15:43:44.318533
107	4	2025-12-03	2025-12-03 09:09:32.843555	2025-12-03 17:32:49.702541	present	2026-03-02 15:43:44.318533
108	5	2025-12-03	2025-12-03 09:11:34.382761	2025-12-03 17:53:27.125288	present	2026-03-02 15:43:44.318533
109	6	2025-12-03	2025-12-03 09:50:25.651308	2025-12-03 17:49:49.262116	present	2026-03-02 15:43:44.318533
110	10	2025-12-03	2025-12-03 09:32:51.959739	2025-12-03 17:57:10.516122	present	2026-03-02 15:43:44.318533
111	11	2025-12-03	2025-12-03 09:25:15.011043	2025-12-03 17:03:59.591516	present	2026-03-02 15:43:44.318533
112	27	2025-12-03	2025-12-03 09:12:39.943838	2025-12-03 17:49:55.787595	present	2026-03-02 15:43:44.318533
113	33	2025-12-03	2025-12-03 09:10:54.590091	2025-12-03 17:03:00.377982	present	2026-03-02 15:43:44.318533
114	35	2025-12-03	2025-12-03 09:53:05.843269	2025-12-03 17:43:14.146757	present	2026-03-02 15:43:44.318533
115	37	2025-12-03	2025-12-03 09:10:04.442656	2025-12-03 17:44:51.850309	present	2026-03-02 15:43:44.318533
116	43	2025-12-03	2025-12-03 09:44:50.281064	2025-12-03 17:26:50.320204	present	2026-03-02 15:43:44.318533
117	45	2025-12-03	2025-12-03 09:39:15.924448	2025-12-03 17:54:59.447951	present	2026-03-02 15:43:44.318533
118	46	2025-12-03	2025-12-03 09:32:00.615472	2025-12-03 17:54:05.119088	present	2026-03-02 15:43:44.318533
119	47	2025-12-03	2025-12-03 09:20:27.739664	2025-12-03 17:59:50.409147	present	2026-03-02 15:43:44.318533
120	48	2025-12-03	2025-12-03 09:34:53.528002	2025-12-03 17:27:17.294041	present	2026-03-02 15:43:44.318533
121	50	2025-12-03	2025-12-03 09:09:46.828618	2025-12-03 17:33:50.553795	present	2026-03-02 15:43:44.318533
122	52	2025-12-03	2025-12-03 09:48:24.041217	2025-12-03 17:24:15.528309	present	2026-03-02 15:43:44.318533
123	59	2025-12-03	2025-12-03 09:54:14.497665	2025-12-03 17:37:57.024872	present	2026-03-02 15:43:44.318533
124	60	2025-12-03	2025-12-03 09:35:08.820202	2025-12-03 17:07:56.04977	present	2026-03-02 15:43:44.318533
125	62	2025-12-03	2025-12-03 09:40:30.571786	2025-12-03 17:39:48.169343	present	2026-03-02 15:43:44.318533
126	63	2025-12-03	2025-12-03 09:30:58.091494	2025-12-03 17:44:53.735158	present	2026-03-02 15:43:44.318533
127	64	2025-12-03	2025-12-03 09:35:10.567775	2025-12-03 17:47:12.115688	present	2026-03-02 15:43:44.318533
128	65	2025-12-03	2025-12-03 09:11:38.561832	2025-12-03 17:44:52.911287	present	2026-03-02 15:43:44.318533
129	66	2025-12-03	2025-12-03 09:33:40.123744	2025-12-03 17:23:12.850922	present	2026-03-02 15:43:44.318533
130	70	2025-12-03	2025-12-03 09:27:25.577631	2025-12-03 17:56:40.330968	present	2026-03-02 15:43:44.318533
131	71	2025-12-03	2025-12-03 09:22:20.27721	2025-12-03 17:25:20.630721	present	2026-03-02 15:43:44.318533
132	73	2025-12-03	2025-12-03 09:38:42.004948	2025-12-03 17:44:58.950575	present	2026-03-02 15:43:44.318533
133	74	2025-12-03	2025-12-03 09:23:25.411455	2025-12-03 17:57:27.091871	present	2026-03-02 15:43:44.318533
134	78	2025-12-03	2025-12-03 09:52:41.730643	2025-12-03 17:23:01.240261	present	2026-03-02 15:43:44.318533
135	79	2025-12-03	2025-12-03 09:33:12.463775	2025-12-03 17:56:12.883838	present	2026-03-02 15:43:44.318533
136	82	2025-12-03	2025-12-03 09:39:12.394154	2025-12-03 17:30:17.540754	present	2026-03-02 15:43:44.318533
137	83	2025-12-03	2025-12-03 09:44:42.320339	2025-12-03 17:41:29.349037	present	2026-03-02 15:43:44.318533
138	84	2025-12-03	2025-12-03 09:46:38.348405	2025-12-03 17:59:19.250722	present	2026-03-02 15:43:44.318533
139	85	2025-12-03	2025-12-03 09:50:35.961031	2025-12-03 17:50:47.184005	present	2026-03-02 15:43:44.318533
140	88	2025-12-03	2025-12-03 09:07:45.879579	2025-12-03 17:03:52.885722	present	2026-03-02 15:43:44.318533
141	89	2025-12-03	2025-12-03 09:41:22.561033	2025-12-03 17:12:44.946402	present	2026-03-02 15:43:44.318533
142	96	2025-12-03	2025-12-03 09:42:52.07563	2025-12-03 17:18:48.303513	present	2026-03-02 15:43:44.318533
143	97	2025-12-03	2025-12-03 09:49:44.427917	2025-12-03 17:11:44.994049	present	2026-03-02 15:43:44.318533
144	1	2025-12-03	2025-12-03 09:59:42.86097	2025-12-03 17:10:45.536951	present	2026-03-02 15:43:44.318533
145	2	2025-12-03	2025-12-03 09:08:23.335888	2025-12-03 17:45:02.392974	present	2026-03-02 15:43:44.318533
146	7	2025-12-03	2025-12-03 09:11:27.181122	2025-12-03 17:07:16.013505	present	2026-03-02 15:43:44.318533
147	8	2025-12-03	2025-12-03 09:44:23.08684	2025-12-03 17:22:22.893948	present	2026-03-02 15:43:44.318533
148	9	2025-12-03	2025-12-03 09:04:55.055295	2025-12-03 17:18:24.607805	present	2026-03-02 15:43:44.318533
149	12	2025-12-03	2025-12-03 09:24:40.34522	2025-12-03 17:23:23.591408	present	2026-03-02 15:43:44.318533
150	13	2025-12-03	2025-12-03 09:56:24.716016	2025-12-03 17:52:58.588968	present	2026-03-02 15:43:44.318533
151	14	2025-12-03	2025-12-03 09:30:18.107347	2025-12-03 17:17:37.405987	present	2026-03-02 15:43:44.318533
152	15	2025-12-03	2025-12-03 09:15:16.137642	2025-12-03 17:34:25.927352	present	2026-03-02 15:43:44.318533
153	16	2025-12-03	2025-12-03 09:38:34.472648	2025-12-03 17:50:26.268679	present	2026-03-02 15:43:44.318533
154	17	2025-12-03	2025-12-03 09:17:59.264895	2025-12-03 17:03:48.238788	present	2026-03-02 15:43:44.318533
155	18	2025-12-03	2025-12-03 09:44:47.626998	2025-12-03 17:11:11.066416	present	2026-03-02 15:43:44.318533
156	19	2025-12-03	2025-12-03 09:09:55.646888	2025-12-03 17:26:54.406909	present	2026-03-02 15:43:44.318533
157	20	2025-12-03	2025-12-03 09:21:17.266801	2025-12-03 17:17:57.382474	present	2026-03-02 15:43:44.318533
158	21	2025-12-03	2025-12-03 09:27:25.428446	2025-12-03 17:28:53.53672	present	2026-03-02 15:43:44.318533
159	22	2025-12-03	2025-12-03 09:38:24.387474	2025-12-03 17:30:46.805748	present	2026-03-02 15:43:44.318533
160	23	2025-12-03	2025-12-03 09:54:05.255927	2025-12-03 17:33:22.660968	present	2026-03-02 15:43:44.318533
161	24	2025-12-03	2025-12-03 09:27:30.373735	2025-12-03 17:39:13.495711	present	2026-03-02 15:43:44.318533
162	25	2025-12-03	2025-12-03 09:46:17.985214	2025-12-03 17:17:27.812289	present	2026-03-02 15:43:44.318533
163	26	2025-12-03	2025-12-03 09:28:29.926489	2025-12-03 17:13:33.493841	present	2026-03-02 15:43:44.318533
164	28	2025-12-03	2025-12-03 09:50:42.151618	2025-12-03 17:22:03.62266	present	2026-03-02 15:43:44.318533
165	29	2025-12-03	2025-12-03 09:48:19.912155	2025-12-03 17:21:36.439566	present	2026-03-02 15:43:44.318533
166	30	2025-12-03	2025-12-03 09:37:14.699008	2025-12-03 17:32:07.011272	present	2026-03-02 15:43:44.318533
167	31	2025-12-03	2025-12-03 09:22:58.66955	2025-12-03 17:11:32.756513	present	2026-03-02 15:43:44.318533
168	32	2025-12-03	2025-12-03 09:01:06.090164	2025-12-03 17:10:10.531275	present	2026-03-02 15:43:44.318533
169	34	2025-12-03	2025-12-03 09:38:18.70815	2025-12-03 17:12:30.018391	present	2026-03-02 15:43:44.318533
170	36	2025-12-03	2025-12-03 09:35:23.447119	2025-12-03 17:17:35.507828	present	2026-03-02 15:43:44.318533
171	38	2025-12-03	2025-12-03 09:02:52.745546	2025-12-03 17:22:22.896926	present	2026-03-02 15:43:44.318533
172	39	2025-12-03	2025-12-03 09:05:52.414234	2025-12-03 17:03:23.571603	present	2026-03-02 15:43:44.318533
173	40	2025-12-03	2025-12-03 09:27:06.02704	2025-12-03 17:47:55.231365	present	2026-03-02 15:43:44.318533
174	41	2025-12-03	2025-12-03 09:44:33.759556	2025-12-03 17:19:07.142381	present	2026-03-02 15:43:44.318533
175	42	2025-12-03	2025-12-03 09:58:29.12113	2025-12-03 17:46:12.332379	present	2026-03-02 15:43:44.318533
176	44	2025-12-03	2025-12-03 09:58:37.965747	2025-12-03 17:06:08.431483	present	2026-03-02 15:43:44.318533
177	49	2025-12-03	2025-12-03 09:09:55.204287	2025-12-03 17:33:43.515815	present	2026-03-02 15:43:44.318533
178	51	2025-12-03	2025-12-03 09:52:18.871993	2025-12-03 17:57:23.645895	present	2026-03-02 15:43:44.318533
179	53	2025-12-03	2025-12-03 09:14:51.768834	2025-12-03 17:30:59.393158	present	2026-03-02 15:43:44.318533
180	54	2025-12-03	2025-12-03 09:21:39.018687	2025-12-03 17:35:18.214351	present	2026-03-02 15:43:44.318533
181	55	2025-12-03	2025-12-03 09:44:56.308751	2025-12-03 17:26:08.54862	present	2026-03-02 15:43:44.318533
182	56	2025-12-03	2025-12-03 09:08:21.883295	2025-12-03 17:46:47.746363	present	2026-03-02 15:43:44.318533
183	57	2025-12-03	2025-12-03 09:05:36.970102	2025-12-03 17:55:16.460009	present	2026-03-02 15:43:44.318533
184	58	2025-12-03	2025-12-03 09:10:43.72122	2025-12-03 17:14:55.670276	present	2026-03-02 15:43:44.318533
185	61	2025-12-03	2025-12-03 09:41:06.704662	2025-12-03 17:06:16.538748	present	2026-03-02 15:43:44.318533
186	67	2025-12-03	2025-12-03 09:32:45.860805	2025-12-03 17:57:07.396194	present	2026-03-02 15:43:44.318533
187	68	2025-12-03	2025-12-03 09:51:52.628926	2025-12-03 17:37:36.08156	present	2026-03-02 15:43:44.318533
188	69	2025-12-03	2025-12-03 09:38:51.515681	2025-12-03 17:45:13.425464	present	2026-03-02 15:43:44.318533
189	72	2025-12-03	2025-12-03 09:56:46.742759	2025-12-03 17:58:40.743131	present	2026-03-02 15:43:44.318533
190	75	2025-12-03	2025-12-03 09:54:59.416126	2025-12-03 17:31:05.768931	present	2026-03-02 15:43:44.318533
191	76	2025-12-03	2025-12-03 09:58:11.641363	2025-12-03 17:33:59.399481	present	2026-03-02 15:43:44.318533
192	77	2025-12-03	2025-12-03 09:26:37.795424	2025-12-03 17:06:55.081146	present	2026-03-02 15:43:44.318533
193	80	2025-12-03	2025-12-03 09:38:04.740536	2025-12-03 17:29:36.914977	present	2026-03-02 15:43:44.318533
194	81	2025-12-03	2025-12-03 09:16:18.082001	2025-12-03 17:28:29.92243	present	2026-03-02 15:43:44.318533
195	86	2025-12-03	2025-12-03 09:56:37.611215	2025-12-03 17:02:29.665353	present	2026-03-02 15:43:44.318533
196	87	2025-12-03	2025-12-03 09:41:53.590865	2025-12-03 17:39:40.601448	present	2026-03-02 15:43:44.318533
197	90	2025-12-03	2025-12-03 09:08:22.490803	2025-12-03 17:52:34.603166	present	2026-03-02 15:43:44.318533
198	91	2025-12-03	2025-12-03 09:08:25.63491	2025-12-03 17:26:19.335973	present	2026-03-02 15:43:44.318533
199	92	2025-12-03	2025-12-03 09:01:49.91456	2025-12-03 17:44:32.291624	present	2026-03-02 15:43:44.318533
200	93	2025-12-03	2025-12-03 09:39:46.347403	2025-12-03 17:06:39.418555	present	2026-03-02 15:43:44.318533
201	94	2025-12-03	2025-12-03 09:28:23.467762	2025-12-03 17:41:30.162377	present	2026-03-02 15:43:44.318533
202	95	2025-12-03	2025-12-03 09:19:18.646578	2025-12-03 17:28:20.356546	present	2026-03-02 15:43:44.318533
203	98	2025-12-03	2025-12-03 09:23:09.913684	2025-12-03 17:12:49.58799	present	2026-03-02 15:43:44.318533
204	99	2025-12-03	2025-12-03 09:19:14.442725	2025-12-03 17:07:36.687013	present	2026-03-02 15:43:44.318533
205	100	2025-12-03	2025-12-03 09:15:10.917474	2025-12-03 17:02:26.860078	present	2026-03-02 15:43:44.318533
206	3	2025-12-04	2025-12-04 09:08:26.845184	2025-12-04 17:00:48.191573	present	2026-03-02 15:43:44.318533
207	4	2025-12-04	2025-12-04 09:06:27.325725	2025-12-04 17:56:24.191514	present	2026-03-02 15:43:44.318533
208	5	2025-12-04	2025-12-04 09:43:06.112528	2025-12-04 17:58:08.217089	present	2026-03-02 15:43:44.318533
209	6	2025-12-04	2025-12-04 09:58:36.462225	2025-12-04 17:49:44.079529	present	2026-03-02 15:43:44.318533
210	10	2025-12-04	2025-12-04 09:17:27.673457	2025-12-04 17:42:02.951138	present	2026-03-02 15:43:44.318533
211	11	2025-12-04	2025-12-04 09:25:55.362366	2025-12-04 17:51:10.102606	present	2026-03-02 15:43:44.318533
212	27	2025-12-04	2025-12-04 09:08:32.030251	2025-12-04 17:12:41.305156	present	2026-03-02 15:43:44.318533
213	33	2025-12-04	2025-12-04 09:34:15.767126	2025-12-04 17:26:49.440952	present	2026-03-02 15:43:44.318533
214	35	2025-12-04	2025-12-04 09:42:14.997992	2025-12-04 17:37:24.695052	present	2026-03-02 15:43:44.318533
215	37	2025-12-04	2025-12-04 09:23:15.690462	2025-12-04 17:56:41.481015	present	2026-03-02 15:43:44.318533
216	43	2025-12-04	2025-12-04 09:45:46.683519	2025-12-04 17:19:50.602301	present	2026-03-02 15:43:44.318533
217	45	2025-12-04	2025-12-04 09:06:27.140618	2025-12-04 17:21:11.758488	present	2026-03-02 15:43:44.318533
218	46	2025-12-04	2025-12-04 09:04:13.458017	2025-12-04 17:13:19.694046	present	2026-03-02 15:43:44.318533
219	47	2025-12-04	2025-12-04 09:04:36.469121	2025-12-04 17:41:01.763399	present	2026-03-02 15:43:44.318533
220	48	2025-12-04	2025-12-04 09:18:38.943998	2025-12-04 17:31:00.222685	present	2026-03-02 15:43:44.318533
221	50	2025-12-04	2025-12-04 09:49:38.061695	2025-12-04 17:22:41.689864	present	2026-03-02 15:43:44.318533
222	52	2025-12-04	2025-12-04 09:33:48.591987	2025-12-04 17:58:41.718397	present	2026-03-02 15:43:44.318533
223	59	2025-12-04	2025-12-04 09:34:34.921643	2025-12-04 17:19:16.597731	present	2026-03-02 15:43:44.318533
224	60	2025-12-04	2025-12-04 09:52:23.813379	2025-12-04 17:47:48.087464	present	2026-03-02 15:43:44.318533
225	62	2025-12-04	2025-12-04 09:50:00.352901	2025-12-04 17:13:33.068706	present	2026-03-02 15:43:44.318533
226	63	2025-12-04	2025-12-04 09:05:47.829205	2025-12-04 17:20:12.984364	present	2026-03-02 15:43:44.318533
227	64	2025-12-04	2025-12-04 09:22:58.260416	2025-12-04 17:45:49.594108	present	2026-03-02 15:43:44.318533
228	65	2025-12-04	2025-12-04 09:31:15.603052	2025-12-04 17:10:17.635898	present	2026-03-02 15:43:44.318533
229	66	2025-12-04	2025-12-04 09:03:02.309205	2025-12-04 17:00:00.288819	present	2026-03-02 15:43:44.318533
230	70	2025-12-04	2025-12-04 09:00:38.189663	2025-12-04 17:22:18.905542	present	2026-03-02 15:43:44.318533
231	71	2025-12-04	2025-12-04 09:17:37.954654	2025-12-04 17:26:20.492963	present	2026-03-02 15:43:44.318533
232	73	2025-12-04	2025-12-04 09:01:55.457154	2025-12-04 17:48:05.985145	present	2026-03-02 15:43:44.318533
233	74	2025-12-04	2025-12-04 09:08:53.400119	2025-12-04 17:54:43.929444	present	2026-03-02 15:43:44.318533
234	78	2025-12-04	2025-12-04 09:14:09.375499	2025-12-04 17:05:21.47728	present	2026-03-02 15:43:44.318533
235	79	2025-12-04	2025-12-04 09:33:45.278435	2025-12-04 17:49:37.65951	present	2026-03-02 15:43:44.318533
236	82	2025-12-04	2025-12-04 09:30:15.878252	2025-12-04 17:13:32.59644	present	2026-03-02 15:43:44.318533
237	83	2025-12-04	2025-12-04 09:08:57.153296	2025-12-04 17:21:12.425154	present	2026-03-02 15:43:44.318533
238	84	2025-12-04	2025-12-04 09:30:19.973461	2025-12-04 17:50:24.425303	present	2026-03-02 15:43:44.318533
239	85	2025-12-04	2025-12-04 09:32:15.337099	2025-12-04 17:44:55.620554	present	2026-03-02 15:43:44.318533
240	88	2025-12-04	2025-12-04 09:33:25.533205	2025-12-04 17:06:52.266767	present	2026-03-02 15:43:44.318533
241	89	2025-12-04	2025-12-04 09:43:16.01106	2025-12-04 17:54:04.958847	present	2026-03-02 15:43:44.318533
242	96	2025-12-04	2025-12-04 09:13:32.990883	2025-12-04 17:55:29.11413	present	2026-03-02 15:43:44.318533
243	97	2025-12-04	2025-12-04 09:55:51.097011	2025-12-04 17:50:42.5606	present	2026-03-02 15:43:44.318533
244	1	2025-12-04	2025-12-04 09:26:14.915327	2025-12-04 17:35:55.219018	present	2026-03-02 15:43:44.318533
245	2	2025-12-04	2025-12-04 09:09:45.804587	2025-12-04 17:09:23.491926	present	2026-03-02 15:43:44.318533
246	7	2025-12-04	2025-12-04 09:43:03.767217	2025-12-04 17:23:19.710832	present	2026-03-02 15:43:44.318533
247	8	2025-12-04	2025-12-04 09:02:17.990568	2025-12-04 17:45:07.888624	present	2026-03-02 15:43:44.318533
248	9	2025-12-04	2025-12-04 09:44:02.442572	2025-12-04 17:22:25.416869	present	2026-03-02 15:43:44.318533
249	12	2025-12-04	2025-12-04 09:23:55.866362	2025-12-04 17:46:20.408694	present	2026-03-02 15:43:44.318533
250	13	2025-12-04	2025-12-04 09:13:19.019156	2025-12-04 17:43:36.657752	present	2026-03-02 15:43:44.318533
251	14	2025-12-04	2025-12-04 09:28:55.583975	2025-12-04 17:33:04.804288	present	2026-03-02 15:43:44.318533
252	15	2025-12-04	2025-12-04 09:53:39.381687	2025-12-04 17:29:49.806855	present	2026-03-02 15:43:44.318533
253	16	2025-12-04	2025-12-04 09:24:47.542298	2025-12-04 17:07:53.068067	present	2026-03-02 15:43:44.318533
254	17	2025-12-04	2025-12-04 09:27:15.102496	2025-12-04 17:59:41.225638	present	2026-03-02 15:43:44.318533
255	18	2025-12-04	2025-12-04 09:58:41.783246	2025-12-04 17:08:22.989116	present	2026-03-02 15:43:44.318533
256	19	2025-12-04	2025-12-04 09:08:01.151108	2025-12-04 17:43:31.106544	present	2026-03-02 15:43:44.318533
257	20	2025-12-04	2025-12-04 09:08:58.934006	2025-12-04 17:47:47.212989	present	2026-03-02 15:43:44.318533
258	21	2025-12-04	2025-12-04 09:24:05.710785	2025-12-04 17:01:41.241492	present	2026-03-02 15:43:44.318533
259	22	2025-12-04	2025-12-04 09:59:08.784687	2025-12-04 17:15:28.758818	present	2026-03-02 15:43:44.318533
260	23	2025-12-04	2025-12-04 09:12:54.035045	2025-12-04 17:32:24.113584	present	2026-03-02 15:43:44.318533
261	24	2025-12-04	2025-12-04 09:05:40.020133	2025-12-04 17:57:26.535997	present	2026-03-02 15:43:44.318533
262	25	2025-12-04	2025-12-04 09:44:26.956258	2025-12-04 17:23:35.773873	present	2026-03-02 15:43:44.318533
263	26	2025-12-04	2025-12-04 09:24:43.000958	2025-12-04 17:06:25.59759	present	2026-03-02 15:43:44.318533
264	28	2025-12-04	2025-12-04 09:15:11.327656	2025-12-04 17:45:05.745702	present	2026-03-02 15:43:44.318533
265	29	2025-12-04	2025-12-04 09:12:32.696424	2025-12-04 17:17:30.455345	present	2026-03-02 15:43:44.318533
266	30	2025-12-04	2025-12-04 09:54:14.045679	2025-12-04 17:33:34.332174	present	2026-03-02 15:43:44.318533
267	31	2025-12-04	2025-12-04 09:54:02.4884	2025-12-04 17:27:37.54083	present	2026-03-02 15:43:44.318533
268	32	2025-12-04	2025-12-04 09:57:20.266148	2025-12-04 17:58:07.420739	present	2026-03-02 15:43:44.318533
269	34	2025-12-04	2025-12-04 09:45:33.27854	2025-12-04 17:56:25.674049	present	2026-03-02 15:43:44.318533
270	36	2025-12-04	2025-12-04 09:16:03.373967	2025-12-04 17:24:38.324134	present	2026-03-02 15:43:44.318533
271	38	2025-12-04	2025-12-04 09:07:47.75358	2025-12-04 17:36:14.439431	present	2026-03-02 15:43:44.318533
272	39	2025-12-04	2025-12-04 09:16:35.415446	2025-12-04 17:41:40.022448	present	2026-03-02 15:43:44.318533
273	40	2025-12-04	2025-12-04 09:37:52.90462	2025-12-04 17:32:55.503499	present	2026-03-02 15:43:44.318533
274	41	2025-12-04	2025-12-04 09:23:10.116173	2025-12-04 17:12:17.610112	present	2026-03-02 15:43:44.318533
275	42	2025-12-04	2025-12-04 09:27:43.053263	2025-12-04 17:28:24.135519	present	2026-03-02 15:43:44.318533
276	44	2025-12-04	2025-12-04 09:09:29.144708	2025-12-04 17:26:40.553299	present	2026-03-02 15:43:44.318533
277	49	2025-12-04	2025-12-04 09:36:49.270836	2025-12-04 17:45:42.200906	present	2026-03-02 15:43:44.318533
278	51	2025-12-04	2025-12-04 09:31:21.907076	2025-12-04 17:09:31.336551	present	2026-03-02 15:43:44.318533
279	53	2025-12-04	2025-12-04 09:59:23.812382	2025-12-04 17:31:46.503589	present	2026-03-02 15:43:44.318533
280	54	2025-12-04	2025-12-04 09:01:40.43094	2025-12-04 17:35:35.24297	present	2026-03-02 15:43:44.318533
281	55	2025-12-04	2025-12-04 09:26:47.555141	2025-12-04 17:46:52.976571	present	2026-03-02 15:43:44.318533
282	56	2025-12-04	2025-12-04 09:48:50.989846	2025-12-04 17:20:47.023395	present	2026-03-02 15:43:44.318533
283	57	2025-12-04	2025-12-04 09:22:57.280075	2025-12-04 17:11:48.841023	present	2026-03-02 15:43:44.318533
284	58	2025-12-04	2025-12-04 09:32:32.52953	2025-12-04 17:36:22.615192	present	2026-03-02 15:43:44.318533
285	61	2025-12-04	2025-12-04 09:06:10.052987	2025-12-04 17:43:24.837086	present	2026-03-02 15:43:44.318533
286	67	2025-12-04	2025-12-04 09:00:06.268535	2025-12-04 17:49:19.822087	present	2026-03-02 15:43:44.318533
287	68	2025-12-04	2025-12-04 09:43:19.710518	2025-12-04 17:55:41.520466	present	2026-03-02 15:43:44.318533
288	69	2025-12-04	2025-12-04 09:14:10.580326	2025-12-04 17:08:45.093039	present	2026-03-02 15:43:44.318533
289	72	2025-12-04	2025-12-04 09:38:06.966109	2025-12-04 17:22:17.012688	present	2026-03-02 15:43:44.318533
290	75	2025-12-04	2025-12-04 09:02:28.653187	2025-12-04 17:28:23.893966	present	2026-03-02 15:43:44.318533
291	76	2025-12-04	2025-12-04 09:33:51.296676	2025-12-04 17:07:27.057301	present	2026-03-02 15:43:44.318533
292	77	2025-12-04	2025-12-04 09:13:02.459749	2025-12-04 17:37:36.42227	present	2026-03-02 15:43:44.318533
293	80	2025-12-04	2025-12-04 09:30:50.208122	2025-12-04 17:36:23.916658	present	2026-03-02 15:43:44.318533
294	81	2025-12-04	2025-12-04 09:59:33.563362	2025-12-04 17:41:03.217045	present	2026-03-02 15:43:44.318533
295	86	2025-12-04	2025-12-04 09:24:45.000008	2025-12-04 17:58:50.044428	present	2026-03-02 15:43:44.318533
296	87	2025-12-04	2025-12-04 09:55:19.796645	2025-12-04 17:16:22.038819	present	2026-03-02 15:43:44.318533
297	90	2025-12-04	2025-12-04 09:59:13.349639	2025-12-04 17:17:06.455592	present	2026-03-02 15:43:44.318533
298	91	2025-12-04	2025-12-04 09:42:56.999536	2025-12-04 17:28:26.657188	present	2026-03-02 15:43:44.318533
299	92	2025-12-04	2025-12-04 09:56:38.095393	2025-12-04 17:53:00.941164	present	2026-03-02 15:43:44.318533
300	93	2025-12-04	2025-12-04 09:29:53.723515	2025-12-04 17:40:47.31549	present	2026-03-02 15:43:44.318533
301	94	2025-12-04	2025-12-04 09:20:31.030404	2025-12-04 17:40:00.742934	present	2026-03-02 15:43:44.318533
302	95	2025-12-04	2025-12-04 09:53:55.828044	2025-12-04 17:55:14.438599	present	2026-03-02 15:43:44.318533
303	98	2025-12-04	2025-12-04 09:08:57.843816	2025-12-04 17:48:10.554302	present	2026-03-02 15:43:44.318533
304	99	2025-12-04	2025-12-04 09:59:00.245354	2025-12-04 17:43:30.854395	present	2026-03-02 15:43:44.318533
305	100	2025-12-04	2025-12-04 09:48:48.536159	2025-12-04 17:29:19.781283	present	2026-03-02 15:43:44.318533
306	3	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
307	4	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
308	5	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
309	6	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
310	10	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
311	11	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
312	27	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
313	33	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
314	35	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
315	37	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
316	43	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
317	45	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
318	46	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
319	47	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
320	48	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
321	50	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
322	52	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
323	59	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
324	60	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
325	62	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
326	63	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
327	64	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
328	65	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
329	66	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
330	70	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
331	71	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
332	73	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
333	74	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
334	78	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
335	79	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
336	82	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
337	83	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
338	84	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
339	85	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
340	88	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
341	89	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
342	96	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
343	97	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
344	1	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
345	2	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
346	7	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
347	8	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
348	9	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
349	12	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
350	13	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
351	14	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
352	15	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
353	16	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
354	17	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
355	18	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
356	19	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
357	20	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
358	21	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
359	22	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
360	23	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
361	24	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
362	25	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
363	26	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
364	28	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
365	29	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
366	30	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
367	31	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
368	32	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
369	34	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
370	36	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
371	38	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
372	39	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
373	40	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
374	41	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
375	42	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
376	44	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
377	49	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
378	51	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
379	53	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
380	54	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
381	55	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
382	56	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
383	57	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
384	58	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
385	61	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
386	67	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
387	68	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
388	69	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
389	72	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
390	75	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
391	76	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
392	77	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
393	80	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
394	81	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
395	86	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
396	87	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
397	90	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
398	91	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
399	92	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
400	93	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
401	94	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
402	95	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
403	98	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
404	99	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
405	100	2025-12-05	\N	\N	absent	2026-03-02 15:43:44.318533
406	3	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
407	4	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
408	5	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
409	6	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
410	10	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
411	11	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
412	27	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
413	33	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
414	35	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
415	37	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
416	43	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
417	45	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
418	46	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
419	47	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
420	48	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
421	50	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
422	52	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
423	59	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
424	60	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
425	62	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
426	63	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
427	64	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
428	65	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
429	66	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
430	70	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
431	71	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
432	73	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
433	74	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
434	78	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
435	79	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
436	82	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
437	83	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
438	84	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
439	85	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
440	88	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
441	89	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
442	96	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
443	97	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
444	1	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
445	2	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
446	7	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
447	8	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
448	9	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
449	12	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
450	13	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
451	14	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
452	15	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
453	16	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
454	17	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
455	18	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
456	19	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
457	20	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
458	21	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
459	22	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
460	23	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
461	24	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
462	25	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
463	26	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
464	28	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
465	29	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
466	30	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
467	31	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
468	32	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
469	34	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
470	36	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
471	38	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
472	39	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
473	40	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
474	41	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
475	42	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
476	44	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
477	49	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
478	51	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
479	53	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
480	54	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
481	55	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
482	56	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
483	57	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
484	58	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
485	61	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
486	67	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
487	68	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
488	69	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
489	72	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
490	75	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
491	76	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
492	77	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
493	80	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
494	81	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
495	86	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
496	87	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
497	90	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
498	91	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
499	92	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
500	93	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
501	94	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
502	95	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
503	98	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
504	99	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
505	100	2025-12-06	\N	\N	absent	2026-03-02 15:43:44.318533
506	3	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
507	4	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
508	5	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
509	6	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
510	10	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
511	11	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
512	27	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
513	33	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
514	35	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
515	37	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
516	43	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
517	45	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
518	46	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
519	47	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
520	48	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
521	50	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
522	52	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
523	59	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
524	60	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
525	62	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
526	63	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
527	64	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
528	65	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
529	66	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
530	70	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
531	71	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
532	73	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
533	74	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
534	78	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
535	79	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
536	82	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
537	83	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
538	84	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
539	85	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
540	88	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
541	89	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
542	96	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
543	97	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
544	1	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
545	2	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
546	7	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
547	8	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
548	9	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
549	12	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
550	13	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
551	14	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
552	15	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
553	16	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
554	17	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
555	18	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
556	19	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
557	20	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
558	21	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
559	22	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
560	23	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
561	24	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
562	25	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
563	26	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
564	28	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
565	29	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
566	30	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
567	31	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
568	32	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
569	34	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
570	36	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
571	38	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
572	39	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
573	40	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
574	41	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
575	42	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
576	44	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
577	49	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
578	51	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
579	53	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
580	54	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
581	55	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
582	56	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
583	57	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
584	58	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
585	61	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
586	67	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
587	68	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
588	69	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
589	72	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
590	75	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
591	76	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
592	77	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
593	80	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
594	81	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
595	86	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
596	87	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
597	90	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
598	91	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
599	92	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
600	93	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
601	94	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
602	95	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
603	98	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
604	99	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
605	100	2025-12-07	\N	\N	absent	2026-03-02 15:43:44.318533
606	3	2025-12-08	2025-12-08 09:24:58.314763	2025-12-08 17:23:55.844918	present	2026-03-02 15:43:44.318533
607	4	2025-12-08	2025-12-08 09:11:48.075906	2025-12-08 17:32:01.727472	present	2026-03-02 15:43:44.318533
608	5	2025-12-08	2025-12-08 09:08:19.384737	2025-12-08 17:17:41.774946	present	2026-03-02 15:43:44.318533
609	6	2025-12-08	2025-12-08 09:07:19.091717	2025-12-08 17:22:25.967094	present	2026-03-02 15:43:44.318533
610	10	2025-12-08	2025-12-08 09:05:02.135672	2025-12-08 17:07:58.304802	present	2026-03-02 15:43:44.318533
611	11	2025-12-08	2025-12-08 09:46:42.0683	2025-12-08 17:26:19.215032	present	2026-03-02 15:43:44.318533
612	27	2025-12-08	2025-12-08 09:51:28.652289	2025-12-08 17:43:41.794034	present	2026-03-02 15:43:44.318533
613	33	2025-12-08	2025-12-08 09:46:44.528676	2025-12-08 17:10:17.939797	present	2026-03-02 15:43:44.318533
614	35	2025-12-08	2025-12-08 09:58:39.608571	2025-12-08 17:49:01.068652	present	2026-03-02 15:43:44.318533
615	37	2025-12-08	2025-12-08 09:22:10.797065	2025-12-08 17:27:33.026516	present	2026-03-02 15:43:44.318533
616	43	2025-12-08	2025-12-08 09:29:37.32348	2025-12-08 17:46:08.354193	present	2026-03-02 15:43:44.318533
617	45	2025-12-08	2025-12-08 09:42:51.969555	2025-12-08 17:49:15.363066	present	2026-03-02 15:43:44.318533
618	46	2025-12-08	2025-12-08 09:45:07.946167	2025-12-08 17:14:25.479156	present	2026-03-02 15:43:44.318533
619	47	2025-12-08	2025-12-08 09:45:49.899867	2025-12-08 17:44:59.834237	present	2026-03-02 15:43:44.318533
620	48	2025-12-08	2025-12-08 09:44:22.21447	2025-12-08 17:39:43.354521	present	2026-03-02 15:43:44.318533
621	50	2025-12-08	2025-12-08 09:29:41.481771	2025-12-08 17:48:29.393046	present	2026-03-02 15:43:44.318533
622	52	2025-12-08	2025-12-08 09:08:05.114494	2025-12-08 17:46:07.557738	present	2026-03-02 15:43:44.318533
623	59	2025-12-08	2025-12-08 09:57:19.842651	2025-12-08 17:46:59.48557	present	2026-03-02 15:43:44.318533
624	60	2025-12-08	2025-12-08 09:49:10.880742	2025-12-08 17:13:49.692903	present	2026-03-02 15:43:44.318533
625	62	2025-12-08	2025-12-08 09:21:39.183589	2025-12-08 17:40:19.461072	present	2026-03-02 15:43:44.318533
626	63	2025-12-08	2025-12-08 09:08:02.253434	2025-12-08 17:59:18.951996	present	2026-03-02 15:43:44.318533
627	64	2025-12-08	2025-12-08 09:30:02.024897	2025-12-08 17:38:20.111281	present	2026-03-02 15:43:44.318533
628	65	2025-12-08	2025-12-08 09:11:54.183652	2025-12-08 17:48:51.149641	present	2026-03-02 15:43:44.318533
629	66	2025-12-08	2025-12-08 09:21:26.218588	2025-12-08 17:35:17.984236	present	2026-03-02 15:43:44.318533
630	70	2025-12-08	2025-12-08 09:36:51.272488	2025-12-08 17:29:09.894238	present	2026-03-02 15:43:44.318533
631	71	2025-12-08	2025-12-08 09:59:55.877959	2025-12-08 17:47:37.715338	present	2026-03-02 15:43:44.318533
632	73	2025-12-08	2025-12-08 09:21:54.890123	2025-12-08 17:26:02.199922	present	2026-03-02 15:43:44.318533
633	74	2025-12-08	2025-12-08 09:44:49.126648	2025-12-08 17:21:25.247115	present	2026-03-02 15:43:44.318533
634	78	2025-12-08	2025-12-08 09:12:29.830914	2025-12-08 17:19:36.62774	present	2026-03-02 15:43:44.318533
635	79	2025-12-08	2025-12-08 09:52:05.000007	2025-12-08 17:48:16.724078	present	2026-03-02 15:43:44.318533
636	82	2025-12-08	2025-12-08 09:15:12.556907	2025-12-08 17:35:08.494499	present	2026-03-02 15:43:44.318533
637	83	2025-12-08	2025-12-08 09:41:11.949288	2025-12-08 17:24:31.388502	present	2026-03-02 15:43:44.318533
638	84	2025-12-08	2025-12-08 09:28:01.017443	2025-12-08 17:25:40.978418	present	2026-03-02 15:43:44.318533
639	85	2025-12-08	2025-12-08 09:58:02.198976	2025-12-08 17:55:09.039657	present	2026-03-02 15:43:44.318533
640	88	2025-12-08	2025-12-08 09:48:35.768137	2025-12-08 17:54:23.55772	present	2026-03-02 15:43:44.318533
641	89	2025-12-08	2025-12-08 09:19:02.792292	2025-12-08 17:28:47.348318	present	2026-03-02 15:43:44.318533
642	96	2025-12-08	2025-12-08 09:27:39.549815	2025-12-08 17:51:07.109475	present	2026-03-02 15:43:44.318533
643	97	2025-12-08	2025-12-08 09:24:15.001596	2025-12-08 17:04:46.44113	present	2026-03-02 15:43:44.318533
644	1	2025-12-08	2025-12-08 09:58:13.278975	2025-12-08 17:43:31.43907	present	2026-03-02 15:43:44.318533
645	2	2025-12-08	2025-12-08 09:15:07.050192	2025-12-08 17:07:44.334656	present	2026-03-02 15:43:44.318533
646	7	2025-12-08	2025-12-08 09:53:14.715443	2025-12-08 17:27:20.339817	present	2026-03-02 15:43:44.318533
647	8	2025-12-08	2025-12-08 09:56:27.162378	2025-12-08 17:04:33.173305	present	2026-03-02 15:43:44.318533
648	9	2025-12-08	2025-12-08 09:28:36.204031	2025-12-08 17:29:39.119367	present	2026-03-02 15:43:44.318533
649	12	2025-12-08	2025-12-08 09:59:03.027518	2025-12-08 17:50:32.000054	present	2026-03-02 15:43:44.318533
650	13	2025-12-08	2025-12-08 09:46:43.833328	2025-12-08 17:33:30.649565	present	2026-03-02 15:43:44.318533
651	14	2025-12-08	2025-12-08 09:24:50.795716	2025-12-08 17:04:05.984412	present	2026-03-02 15:43:44.318533
652	15	2025-12-08	2025-12-08 09:30:25.727193	2025-12-08 17:29:32.194475	present	2026-03-02 15:43:44.318533
653	16	2025-12-08	2025-12-08 09:48:57.787808	2025-12-08 17:18:14.468287	present	2026-03-02 15:43:44.318533
654	17	2025-12-08	2025-12-08 09:57:27.368531	2025-12-08 17:23:58.750888	present	2026-03-02 15:43:44.318533
655	18	2025-12-08	2025-12-08 09:27:32.731876	2025-12-08 17:59:05.364744	present	2026-03-02 15:43:44.318533
656	19	2025-12-08	2025-12-08 09:37:43.781797	2025-12-08 17:33:51.179646	present	2026-03-02 15:43:44.318533
657	20	2025-12-08	2025-12-08 09:37:15.816238	2025-12-08 17:26:50.63684	present	2026-03-02 15:43:44.318533
658	21	2025-12-08	2025-12-08 09:59:56.922521	2025-12-08 17:24:08.581295	present	2026-03-02 15:43:44.318533
659	22	2025-12-08	2025-12-08 09:55:44.366599	2025-12-08 17:52:38.031544	present	2026-03-02 15:43:44.318533
660	23	2025-12-08	2025-12-08 09:11:05.521553	2025-12-08 17:39:30.521061	present	2026-03-02 15:43:44.318533
661	24	2025-12-08	2025-12-08 09:14:49.781304	2025-12-08 17:19:28.410626	present	2026-03-02 15:43:44.318533
662	25	2025-12-08	2025-12-08 09:51:44.6181	2025-12-08 17:23:13.772748	present	2026-03-02 15:43:44.318533
663	26	2025-12-08	2025-12-08 09:40:43.906096	2025-12-08 17:13:37.153755	present	2026-03-02 15:43:44.318533
664	28	2025-12-08	2025-12-08 09:29:27.514485	2025-12-08 17:21:31.099185	present	2026-03-02 15:43:44.318533
665	29	2025-12-08	2025-12-08 09:41:28.466927	2025-12-08 17:52:58.527608	present	2026-03-02 15:43:44.318533
666	30	2025-12-08	2025-12-08 09:30:09.18228	2025-12-08 17:29:47.243109	present	2026-03-02 15:43:44.318533
667	31	2025-12-08	2025-12-08 09:58:59.212	2025-12-08 17:56:33.319957	present	2026-03-02 15:43:44.318533
668	32	2025-12-08	2025-12-08 09:28:09.499304	2025-12-08 17:14:59.155134	present	2026-03-02 15:43:44.318533
669	34	2025-12-08	2025-12-08 09:27:56.260166	2025-12-08 17:11:28.454483	present	2026-03-02 15:43:44.318533
670	36	2025-12-08	2025-12-08 09:48:41.467807	2025-12-08 17:08:34.597713	present	2026-03-02 15:43:44.318533
671	38	2025-12-08	2025-12-08 09:52:06.10448	2025-12-08 17:35:24.5791	present	2026-03-02 15:43:44.318533
672	39	2025-12-08	2025-12-08 09:23:15.577904	2025-12-08 17:57:14.399771	present	2026-03-02 15:43:44.318533
673	40	2025-12-08	2025-12-08 09:49:07.136429	2025-12-08 17:23:36.181841	present	2026-03-02 15:43:44.318533
674	41	2025-12-08	2025-12-08 09:06:10.324443	2025-12-08 17:56:14.841386	present	2026-03-02 15:43:44.318533
675	42	2025-12-08	2025-12-08 09:22:33.082069	2025-12-08 17:28:25.967607	present	2026-03-02 15:43:44.318533
676	44	2025-12-08	2025-12-08 09:09:35.679194	2025-12-08 17:16:30.071138	present	2026-03-02 15:43:44.318533
677	49	2025-12-08	2025-12-08 09:40:50.574215	2025-12-08 17:27:53.689384	present	2026-03-02 15:43:44.318533
678	51	2025-12-08	2025-12-08 09:47:53.905273	2025-12-08 17:02:58.982844	present	2026-03-02 15:43:44.318533
679	53	2025-12-08	2025-12-08 09:55:28.201861	2025-12-08 17:33:01.842751	present	2026-03-02 15:43:44.318533
680	54	2025-12-08	2025-12-08 09:52:47.371597	2025-12-08 17:39:21.084555	present	2026-03-02 15:43:44.318533
681	55	2025-12-08	2025-12-08 09:33:50.13052	2025-12-08 17:14:24.34697	present	2026-03-02 15:43:44.318533
682	56	2025-12-08	2025-12-08 09:11:53.979796	2025-12-08 17:39:35.004762	present	2026-03-02 15:43:44.318533
683	57	2025-12-08	2025-12-08 09:05:48.164451	2025-12-08 17:51:24.494537	present	2026-03-02 15:43:44.318533
684	58	2025-12-08	2025-12-08 09:30:23.313165	2025-12-08 17:28:00.092953	present	2026-03-02 15:43:44.318533
685	61	2025-12-08	2025-12-08 09:36:21.84811	2025-12-08 17:03:55.035401	present	2026-03-02 15:43:44.318533
686	67	2025-12-08	2025-12-08 09:25:46.944399	2025-12-08 17:12:33.067265	present	2026-03-02 15:43:44.318533
687	68	2025-12-08	2025-12-08 09:02:08.794913	2025-12-08 17:08:11.460416	present	2026-03-02 15:43:44.318533
688	69	2025-12-08	2025-12-08 09:04:31.209928	2025-12-08 17:55:59.815089	present	2026-03-02 15:43:44.318533
689	72	2025-12-08	2025-12-08 09:37:36.598278	2025-12-08 17:24:28.756797	present	2026-03-02 15:43:44.318533
690	75	2025-12-08	2025-12-08 09:02:18.66545	2025-12-08 17:49:10.617286	present	2026-03-02 15:43:44.318533
691	76	2025-12-08	2025-12-08 09:02:33.857392	2025-12-08 17:43:07.632255	present	2026-03-02 15:43:44.318533
692	77	2025-12-08	2025-12-08 09:19:33.691371	2025-12-08 17:56:12.460232	present	2026-03-02 15:43:44.318533
693	80	2025-12-08	2025-12-08 09:20:42.037338	2025-12-08 17:48:45.921721	present	2026-03-02 15:43:44.318533
694	81	2025-12-08	2025-12-08 09:58:56.674763	2025-12-08 17:38:24.933223	present	2026-03-02 15:43:44.318533
695	86	2025-12-08	2025-12-08 09:20:56.338665	2025-12-08 17:16:44.106823	present	2026-03-02 15:43:44.318533
696	87	2025-12-08	2025-12-08 09:23:36.628895	2025-12-08 17:12:22.994665	present	2026-03-02 15:43:44.318533
697	90	2025-12-08	2025-12-08 09:12:33.852364	2025-12-08 17:57:16.259589	present	2026-03-02 15:43:44.318533
698	91	2025-12-08	2025-12-08 09:35:49.997897	2025-12-08 17:28:00.993728	present	2026-03-02 15:43:44.318533
699	92	2025-12-08	2025-12-08 09:42:59.734607	2025-12-08 17:30:38.652428	present	2026-03-02 15:43:44.318533
700	93	2025-12-08	2025-12-08 09:48:17.705384	2025-12-08 17:26:33.190737	present	2026-03-02 15:43:44.318533
701	94	2025-12-08	2025-12-08 09:12:27.061123	2025-12-08 17:57:10.621322	present	2026-03-02 15:43:44.318533
702	95	2025-12-08	2025-12-08 09:20:11.18666	2025-12-08 17:31:37.536491	present	2026-03-02 15:43:44.318533
703	98	2025-12-08	2025-12-08 09:58:24.814382	2025-12-08 17:54:29.243457	present	2026-03-02 15:43:44.318533
704	99	2025-12-08	2025-12-08 09:50:19.896835	2025-12-08 17:44:47.891444	present	2026-03-02 15:43:44.318533
705	100	2025-12-08	2025-12-08 09:37:02.902622	2025-12-08 17:25:18.713957	present	2026-03-02 15:43:44.318533
706	3	2025-12-09	2025-12-09 09:35:00.332019	2025-12-09 17:23:37.918178	present	2026-03-02 15:43:44.318533
707	4	2025-12-09	2025-12-09 09:23:46.526097	2025-12-09 17:26:51.064595	present	2026-03-02 15:43:44.318533
708	5	2025-12-09	2025-12-09 09:15:23.879153	2025-12-09 17:37:05.350763	present	2026-03-02 15:43:44.318533
709	6	2025-12-09	2025-12-09 09:39:47.893542	2025-12-09 17:41:50.012396	present	2026-03-02 15:43:44.318533
710	10	2025-12-09	2025-12-09 09:42:33.06381	2025-12-09 17:20:51.801679	present	2026-03-02 15:43:44.318533
711	11	2025-12-09	2025-12-09 09:46:48.276693	2025-12-09 17:18:32.933647	present	2026-03-02 15:43:44.318533
712	27	2025-12-09	2025-12-09 09:22:41.1988	2025-12-09 17:24:38.426257	present	2026-03-02 15:43:44.318533
713	33	2025-12-09	2025-12-09 09:53:23.068994	2025-12-09 17:44:09.134193	present	2026-03-02 15:43:44.318533
714	35	2025-12-09	2025-12-09 09:24:35.206677	2025-12-09 17:11:59.974463	present	2026-03-02 15:43:44.318533
715	37	2025-12-09	2025-12-09 09:16:23.59336	2025-12-09 17:18:53.730057	present	2026-03-02 15:43:44.318533
716	43	2025-12-09	2025-12-09 09:43:00.393545	2025-12-09 17:16:53.8449	present	2026-03-02 15:43:44.318533
717	45	2025-12-09	2025-12-09 09:27:35.54972	2025-12-09 17:17:41.542037	present	2026-03-02 15:43:44.318533
718	46	2025-12-09	2025-12-09 09:09:08.2945	2025-12-09 17:38:13.232586	present	2026-03-02 15:43:44.318533
719	47	2025-12-09	2025-12-09 09:57:05.057736	2025-12-09 17:54:42.863135	present	2026-03-02 15:43:44.318533
720	48	2025-12-09	2025-12-09 09:39:28.853519	2025-12-09 17:20:08.738246	present	2026-03-02 15:43:44.318533
721	50	2025-12-09	2025-12-09 09:07:35.591387	2025-12-09 17:37:49.452749	present	2026-03-02 15:43:44.318533
722	52	2025-12-09	2025-12-09 09:52:48.662169	2025-12-09 17:30:39.384302	present	2026-03-02 15:43:44.318533
723	59	2025-12-09	2025-12-09 09:37:32.57569	2025-12-09 17:52:15.345284	present	2026-03-02 15:43:44.318533
724	60	2025-12-09	2025-12-09 09:01:52.327494	2025-12-09 17:30:51.68622	present	2026-03-02 15:43:44.318533
725	62	2025-12-09	2025-12-09 09:49:43.674191	2025-12-09 17:16:21.957915	present	2026-03-02 15:43:44.318533
726	63	2025-12-09	2025-12-09 09:07:46.498504	2025-12-09 17:48:46.346778	present	2026-03-02 15:43:44.318533
727	64	2025-12-09	2025-12-09 09:50:14.302139	2025-12-09 17:17:46.960657	present	2026-03-02 15:43:44.318533
728	65	2025-12-09	2025-12-09 09:35:25.625614	2025-12-09 17:41:01.404306	present	2026-03-02 15:43:44.318533
729	66	2025-12-09	2025-12-09 09:00:18.092204	2025-12-09 17:53:21.576131	present	2026-03-02 15:43:44.318533
730	70	2025-12-09	2025-12-09 09:44:14.409507	2025-12-09 17:41:43.009833	present	2026-03-02 15:43:44.318533
731	71	2025-12-09	2025-12-09 09:35:01.821291	2025-12-09 17:48:24.78244	present	2026-03-02 15:43:44.318533
732	73	2025-12-09	2025-12-09 09:26:24.799709	2025-12-09 17:58:10.669647	present	2026-03-02 15:43:44.318533
733	74	2025-12-09	2025-12-09 09:08:19.349376	2025-12-09 17:40:44.629814	present	2026-03-02 15:43:44.318533
734	78	2025-12-09	2025-12-09 09:01:58.062273	2025-12-09 17:00:11.907478	present	2026-03-02 15:43:44.318533
735	79	2025-12-09	2025-12-09 09:20:58.316747	2025-12-09 17:52:17.919898	present	2026-03-02 15:43:44.318533
736	82	2025-12-09	2025-12-09 09:33:39.61961	2025-12-09 17:49:11.052322	present	2026-03-02 15:43:44.318533
737	83	2025-12-09	2025-12-09 09:15:06.665736	2025-12-09 17:29:52.331129	present	2026-03-02 15:43:44.318533
738	84	2025-12-09	2025-12-09 09:21:55.945865	2025-12-09 17:32:53.4427	present	2026-03-02 15:43:44.318533
739	85	2025-12-09	2025-12-09 09:43:46.791321	2025-12-09 17:24:29.049602	present	2026-03-02 15:43:44.318533
740	88	2025-12-09	2025-12-09 09:36:22.640528	2025-12-09 17:01:52.76249	present	2026-03-02 15:43:44.318533
741	89	2025-12-09	2025-12-09 09:34:55.045764	2025-12-09 17:20:06.847485	present	2026-03-02 15:43:44.318533
742	96	2025-12-09	2025-12-09 09:53:02.134989	2025-12-09 17:06:27.863768	present	2026-03-02 15:43:44.318533
743	97	2025-12-09	2025-12-09 09:15:20.224054	2025-12-09 17:15:54.117223	present	2026-03-02 15:43:44.318533
744	1	2025-12-09	2025-12-09 09:25:04.031918	2025-12-09 17:01:53.597029	present	2026-03-02 15:43:44.318533
745	2	2025-12-09	2025-12-09 09:58:36.48095	2025-12-09 17:30:09.413138	present	2026-03-02 15:43:44.318533
746	7	2025-12-09	2025-12-09 09:48:39.842708	2025-12-09 17:36:09.408347	present	2026-03-02 15:43:44.318533
747	8	2025-12-09	2025-12-09 09:39:43.131918	2025-12-09 17:50:11.962563	present	2026-03-02 15:43:44.318533
748	9	2025-12-09	2025-12-09 09:08:26.51295	2025-12-09 17:19:24.25648	present	2026-03-02 15:43:44.318533
749	12	2025-12-09	2025-12-09 09:39:52.599247	2025-12-09 17:32:51.998365	present	2026-03-02 15:43:44.318533
750	13	2025-12-09	2025-12-09 09:41:04.551732	2025-12-09 17:09:09.106296	present	2026-03-02 15:43:44.318533
751	14	2025-12-09	2025-12-09 09:39:38.015389	2025-12-09 17:02:01.965745	present	2026-03-02 15:43:44.318533
752	15	2025-12-09	2025-12-09 09:11:51.386309	2025-12-09 17:23:32.697819	present	2026-03-02 15:43:44.318533
753	16	2025-12-09	2025-12-09 09:14:55.465829	2025-12-09 17:58:26.563056	present	2026-03-02 15:43:44.318533
754	17	2025-12-09	2025-12-09 09:59:22.909531	2025-12-09 17:33:17.704467	present	2026-03-02 15:43:44.318533
755	18	2025-12-09	2025-12-09 09:46:50.583505	2025-12-09 17:47:46.423955	present	2026-03-02 15:43:44.318533
756	19	2025-12-09	2025-12-09 09:19:53.10633	2025-12-09 17:05:59.884878	present	2026-03-02 15:43:44.318533
757	20	2025-12-09	2025-12-09 09:07:27.232075	2025-12-09 17:17:13.478542	present	2026-03-02 15:43:44.318533
758	21	2025-12-09	2025-12-09 09:50:52.556305	2025-12-09 17:39:22.118672	present	2026-03-02 15:43:44.318533
759	22	2025-12-09	2025-12-09 09:55:48.142343	2025-12-09 17:39:53.344246	present	2026-03-02 15:43:44.318533
760	23	2025-12-09	2025-12-09 09:37:31.076318	2025-12-09 17:14:36.281135	present	2026-03-02 15:43:44.318533
761	24	2025-12-09	2025-12-09 09:00:17.078168	2025-12-09 17:36:34.984021	present	2026-03-02 15:43:44.318533
762	25	2025-12-09	2025-12-09 09:42:12.853888	2025-12-09 17:41:41.088325	present	2026-03-02 15:43:44.318533
763	26	2025-12-09	2025-12-09 09:50:33.52518	2025-12-09 17:40:57.666892	present	2026-03-02 15:43:44.318533
764	28	2025-12-09	2025-12-09 09:01:50.2308	2025-12-09 17:34:47.819942	present	2026-03-02 15:43:44.318533
765	29	2025-12-09	2025-12-09 09:07:19.376152	2025-12-09 17:38:18.68935	present	2026-03-02 15:43:44.318533
766	30	2025-12-09	2025-12-09 09:53:33.295742	2025-12-09 17:35:44.59365	present	2026-03-02 15:43:44.318533
767	31	2025-12-09	2025-12-09 09:20:17.776634	2025-12-09 17:20:07.880144	present	2026-03-02 15:43:44.318533
768	32	2025-12-09	2025-12-09 09:33:32.051209	2025-12-09 17:22:14.789753	present	2026-03-02 15:43:44.318533
769	34	2025-12-09	2025-12-09 09:21:30.306287	2025-12-09 17:36:26.715824	present	2026-03-02 15:43:44.318533
770	36	2025-12-09	2025-12-09 09:00:20.034927	2025-12-09 17:41:08.98423	present	2026-03-02 15:43:44.318533
771	38	2025-12-09	2025-12-09 09:19:15.24964	2025-12-09 17:05:25.313758	present	2026-03-02 15:43:44.318533
772	39	2025-12-09	2025-12-09 09:02:11.244279	2025-12-09 17:13:16.021864	present	2026-03-02 15:43:44.318533
773	40	2025-12-09	2025-12-09 09:33:06.228209	2025-12-09 17:44:26.072821	present	2026-03-02 15:43:44.318533
774	41	2025-12-09	2025-12-09 09:13:58.171408	2025-12-09 17:03:34.097021	present	2026-03-02 15:43:44.318533
775	42	2025-12-09	2025-12-09 09:58:19.45503	2025-12-09 17:34:57.187257	present	2026-03-02 15:43:44.318533
776	44	2025-12-09	2025-12-09 09:16:58.818864	2025-12-09 17:31:31.154021	present	2026-03-02 15:43:44.318533
777	49	2025-12-09	2025-12-09 09:31:15.678446	2025-12-09 17:59:24.161167	present	2026-03-02 15:43:44.318533
778	51	2025-12-09	2025-12-09 09:57:15.499876	2025-12-09 17:29:50.26792	present	2026-03-02 15:43:44.318533
779	53	2025-12-09	2025-12-09 09:25:19.065549	2025-12-09 17:50:58.867826	present	2026-03-02 15:43:44.318533
780	54	2025-12-09	2025-12-09 09:10:48.874078	2025-12-09 17:57:18.385775	present	2026-03-02 15:43:44.318533
781	55	2025-12-09	2025-12-09 09:30:45.706634	2025-12-09 17:39:33.673884	present	2026-03-02 15:43:44.318533
782	56	2025-12-09	2025-12-09 09:56:39.637749	2025-12-09 17:22:53.465123	present	2026-03-02 15:43:44.318533
783	57	2025-12-09	2025-12-09 09:42:36.353817	2025-12-09 17:06:10.599273	present	2026-03-02 15:43:44.318533
784	58	2025-12-09	2025-12-09 09:49:57.566942	2025-12-09 17:39:34.636491	present	2026-03-02 15:43:44.318533
785	61	2025-12-09	2025-12-09 09:06:11.796339	2025-12-09 17:40:25.981395	present	2026-03-02 15:43:44.318533
786	67	2025-12-09	2025-12-09 09:25:42.85528	2025-12-09 17:29:04.640259	present	2026-03-02 15:43:44.318533
787	68	2025-12-09	2025-12-09 09:58:04.659097	2025-12-09 17:11:00.508126	present	2026-03-02 15:43:44.318533
788	69	2025-12-09	2025-12-09 09:23:56.819687	2025-12-09 17:13:57.126254	present	2026-03-02 15:43:44.318533
789	72	2025-12-09	2025-12-09 09:54:42.786445	2025-12-09 17:15:00.038106	present	2026-03-02 15:43:44.318533
790	75	2025-12-09	2025-12-09 09:56:51.921314	2025-12-09 17:53:32.890311	present	2026-03-02 15:43:44.318533
791	76	2025-12-09	2025-12-09 09:36:44.885458	2025-12-09 17:42:45.691217	present	2026-03-02 15:43:44.318533
792	77	2025-12-09	2025-12-09 09:55:39.415829	2025-12-09 17:50:17.048568	present	2026-03-02 15:43:44.318533
793	80	2025-12-09	2025-12-09 09:00:27.263404	2025-12-09 17:20:06.535607	present	2026-03-02 15:43:44.318533
794	81	2025-12-09	2025-12-09 09:01:44.697757	2025-12-09 17:58:47.3357	present	2026-03-02 15:43:44.318533
795	86	2025-12-09	2025-12-09 09:50:02.858203	2025-12-09 17:12:19.824155	present	2026-03-02 15:43:44.318533
796	87	2025-12-09	2025-12-09 09:34:55.463346	2025-12-09 17:49:47.366621	present	2026-03-02 15:43:44.318533
797	90	2025-12-09	2025-12-09 09:11:24.610691	2025-12-09 17:30:53.748381	present	2026-03-02 15:43:44.318533
798	91	2025-12-09	2025-12-09 09:50:23.869982	2025-12-09 17:52:20.251756	present	2026-03-02 15:43:44.318533
799	92	2025-12-09	2025-12-09 09:05:37.605357	2025-12-09 17:54:07.163663	present	2026-03-02 15:43:44.318533
800	93	2025-12-09	2025-12-09 09:46:00.045619	2025-12-09 17:05:16.496786	present	2026-03-02 15:43:44.318533
801	94	2025-12-09	2025-12-09 09:23:41.178409	2025-12-09 17:25:09.765364	present	2026-03-02 15:43:44.318533
802	95	2025-12-09	2025-12-09 09:29:30.991647	2025-12-09 17:55:55.170849	present	2026-03-02 15:43:44.318533
803	98	2025-12-09	2025-12-09 09:09:29.383858	2025-12-09 17:26:15.849962	present	2026-03-02 15:43:44.318533
804	99	2025-12-09	2025-12-09 09:29:43.442811	2025-12-09 17:13:27.046919	present	2026-03-02 15:43:44.318533
805	100	2025-12-09	2025-12-09 09:53:02.295127	2025-12-09 17:07:40.236368	present	2026-03-02 15:43:44.318533
806	3	2025-12-10	2025-12-10 09:17:26.020439	2025-12-10 17:29:12.607003	present	2026-03-02 15:43:44.318533
807	4	2025-12-10	2025-12-10 09:47:29.131382	2025-12-10 17:21:12.485769	present	2026-03-02 15:43:44.318533
808	5	2025-12-10	2025-12-10 09:43:27.486298	2025-12-10 17:14:47.571013	present	2026-03-02 15:43:44.318533
809	6	2025-12-10	2025-12-10 09:46:41.681717	2025-12-10 17:21:09.244185	present	2026-03-02 15:43:44.318533
810	10	2025-12-10	2025-12-10 09:08:34.771389	2025-12-10 17:32:17.326998	present	2026-03-02 15:43:44.318533
811	11	2025-12-10	2025-12-10 09:47:00.938699	2025-12-10 17:46:47.654133	present	2026-03-02 15:43:44.318533
812	27	2025-12-10	2025-12-10 09:47:24.283964	2025-12-10 17:17:48.73836	present	2026-03-02 15:43:44.318533
813	33	2025-12-10	2025-12-10 09:44:08.039401	2025-12-10 17:49:21.895411	present	2026-03-02 15:43:44.318533
814	35	2025-12-10	2025-12-10 09:31:17.522657	2025-12-10 17:12:45.268662	present	2026-03-02 15:43:44.318533
815	37	2025-12-10	2025-12-10 09:11:31.448266	2025-12-10 17:17:46.263668	present	2026-03-02 15:43:44.318533
816	43	2025-12-10	2025-12-10 09:08:21.422028	2025-12-10 17:25:59.713032	present	2026-03-02 15:43:44.318533
817	45	2025-12-10	2025-12-10 09:49:07.258238	2025-12-10 17:08:18.241697	present	2026-03-02 15:43:44.318533
818	46	2025-12-10	2025-12-10 09:37:34.197954	2025-12-10 17:08:35.229729	present	2026-03-02 15:43:44.318533
819	47	2025-12-10	2025-12-10 09:36:54.952707	2025-12-10 17:56:55.696907	present	2026-03-02 15:43:44.318533
820	48	2025-12-10	2025-12-10 09:24:03.954397	2025-12-10 17:09:13.352961	present	2026-03-02 15:43:44.318533
821	50	2025-12-10	2025-12-10 09:30:42.403033	2025-12-10 17:44:18.423367	present	2026-03-02 15:43:44.318533
822	52	2025-12-10	2025-12-10 09:10:32.694049	2025-12-10 17:44:24.299309	present	2026-03-02 15:43:44.318533
823	59	2025-12-10	2025-12-10 09:42:06.350707	2025-12-10 17:23:13.649827	present	2026-03-02 15:43:44.318533
824	60	2025-12-10	2025-12-10 09:26:02.991305	2025-12-10 17:26:07.075736	present	2026-03-02 15:43:44.318533
825	62	2025-12-10	2025-12-10 09:52:13.278956	2025-12-10 17:01:24.74817	present	2026-03-02 15:43:44.318533
826	63	2025-12-10	2025-12-10 09:46:17.023187	2025-12-10 17:36:13.79526	present	2026-03-02 15:43:44.318533
827	64	2025-12-10	2025-12-10 09:41:57.68674	2025-12-10 17:21:21.334106	present	2026-03-02 15:43:44.318533
828	65	2025-12-10	2025-12-10 09:54:30.842849	2025-12-10 17:06:10.318928	present	2026-03-02 15:43:44.318533
829	66	2025-12-10	2025-12-10 09:02:15.350779	2025-12-10 17:36:35.180581	present	2026-03-02 15:43:44.318533
830	70	2025-12-10	2025-12-10 09:06:52.860827	2025-12-10 17:54:25.137941	present	2026-03-02 15:43:44.318533
831	71	2025-12-10	2025-12-10 09:33:16.90857	2025-12-10 17:20:12.991944	present	2026-03-02 15:43:44.318533
832	73	2025-12-10	2025-12-10 09:10:18.474959	2025-12-10 17:07:00.630829	present	2026-03-02 15:43:44.318533
833	74	2025-12-10	2025-12-10 09:26:03.083377	2025-12-10 17:01:48.325977	present	2026-03-02 15:43:44.318533
834	78	2025-12-10	2025-12-10 09:07:28.636848	2025-12-10 17:47:54.791109	present	2026-03-02 15:43:44.318533
835	79	2025-12-10	2025-12-10 09:44:49.138549	2025-12-10 17:50:27.496507	present	2026-03-02 15:43:44.318533
836	82	2025-12-10	2025-12-10 09:28:12.397727	2025-12-10 17:21:01.53931	present	2026-03-02 15:43:44.318533
837	83	2025-12-10	2025-12-10 09:23:00.328225	2025-12-10 17:18:38.436896	present	2026-03-02 15:43:44.318533
838	84	2025-12-10	2025-12-10 09:32:24.589178	2025-12-10 17:31:48.461725	present	2026-03-02 15:43:44.318533
839	85	2025-12-10	2025-12-10 09:34:40.573634	2025-12-10 17:19:09.679109	present	2026-03-02 15:43:44.318533
840	88	2025-12-10	2025-12-10 09:41:33.254549	2025-12-10 17:34:18.197628	present	2026-03-02 15:43:44.318533
841	89	2025-12-10	2025-12-10 09:19:58.118054	2025-12-10 17:42:27.846906	present	2026-03-02 15:43:44.318533
842	96	2025-12-10	2025-12-10 09:30:51.262509	2025-12-10 17:18:14.838056	present	2026-03-02 15:43:44.318533
843	97	2025-12-10	2025-12-10 09:18:56.374681	2025-12-10 17:55:58.00126	present	2026-03-02 15:43:44.318533
844	1	2025-12-10	2025-12-10 09:00:34.833303	2025-12-10 17:34:22.996449	present	2026-03-02 15:43:44.318533
845	2	2025-12-10	2025-12-10 09:19:41.011358	2025-12-10 17:30:00.585543	present	2026-03-02 15:43:44.318533
846	7	2025-12-10	2025-12-10 09:58:04.92448	2025-12-10 17:47:44.794495	present	2026-03-02 15:43:44.318533
847	8	2025-12-10	2025-12-10 09:15:38.420919	2025-12-10 17:02:48.706452	present	2026-03-02 15:43:44.318533
848	9	2025-12-10	2025-12-10 09:32:27.82346	2025-12-10 17:55:42.044917	present	2026-03-02 15:43:44.318533
849	12	2025-12-10	2025-12-10 09:21:13.559151	2025-12-10 17:00:57.09075	present	2026-03-02 15:43:44.318533
850	13	2025-12-10	2025-12-10 09:23:32.185561	2025-12-10 17:59:56.159334	present	2026-03-02 15:43:44.318533
851	14	2025-12-10	2025-12-10 09:20:27.080419	2025-12-10 17:43:31.163298	present	2026-03-02 15:43:44.318533
852	15	2025-12-10	2025-12-10 09:32:41.846219	2025-12-10 17:57:53.986193	present	2026-03-02 15:43:44.318533
853	16	2025-12-10	2025-12-10 09:30:17.275098	2025-12-10 17:13:37.63481	present	2026-03-02 15:43:44.318533
854	17	2025-12-10	2025-12-10 09:01:00.62062	2025-12-10 17:30:49.564324	present	2026-03-02 15:43:44.318533
855	18	2025-12-10	2025-12-10 09:36:41.421914	2025-12-10 17:24:17.148951	present	2026-03-02 15:43:44.318533
856	19	2025-12-10	2025-12-10 09:31:58.938806	2025-12-10 17:54:39.807238	present	2026-03-02 15:43:44.318533
857	20	2025-12-10	2025-12-10 09:22:49.914728	2025-12-10 17:48:35.585566	present	2026-03-02 15:43:44.318533
858	21	2025-12-10	2025-12-10 09:51:34.795645	2025-12-10 17:17:59.379267	present	2026-03-02 15:43:44.318533
859	22	2025-12-10	2025-12-10 09:32:07.185567	2025-12-10 17:19:38.473808	present	2026-03-02 15:43:44.318533
860	23	2025-12-10	2025-12-10 09:52:01.579234	2025-12-10 17:42:33.195466	present	2026-03-02 15:43:44.318533
861	24	2025-12-10	2025-12-10 09:53:02.549611	2025-12-10 17:48:38.249243	present	2026-03-02 15:43:44.318533
862	25	2025-12-10	2025-12-10 09:57:06.66951	2025-12-10 17:27:14.955651	present	2026-03-02 15:43:44.318533
863	26	2025-12-10	2025-12-10 09:32:38.08809	2025-12-10 17:45:28.439507	present	2026-03-02 15:43:44.318533
864	28	2025-12-10	2025-12-10 09:01:57.001559	2025-12-10 17:34:39.167079	present	2026-03-02 15:43:44.318533
865	29	2025-12-10	2025-12-10 09:06:18.581559	2025-12-10 17:13:45.720451	present	2026-03-02 15:43:44.318533
866	30	2025-12-10	2025-12-10 09:58:41.7859	2025-12-10 17:57:48.518026	present	2026-03-02 15:43:44.318533
867	31	2025-12-10	2025-12-10 09:41:43.547953	2025-12-10 17:13:41.978461	present	2026-03-02 15:43:44.318533
868	32	2025-12-10	2025-12-10 09:55:40.406531	2025-12-10 17:25:56.77875	present	2026-03-02 15:43:44.318533
869	34	2025-12-10	2025-12-10 09:04:37.074558	2025-12-10 17:21:36.673057	present	2026-03-02 15:43:44.318533
870	36	2025-12-10	2025-12-10 09:07:52.966993	2025-12-10 17:17:14.431427	present	2026-03-02 15:43:44.318533
871	38	2025-12-10	2025-12-10 09:51:34.368191	2025-12-10 17:05:12.554542	present	2026-03-02 15:43:44.318533
872	39	2025-12-10	2025-12-10 09:06:21.803388	2025-12-10 17:09:33.956548	present	2026-03-02 15:43:44.318533
873	40	2025-12-10	2025-12-10 09:42:21.994684	2025-12-10 17:11:24.013306	present	2026-03-02 15:43:44.318533
874	41	2025-12-10	2025-12-10 09:24:00.149148	2025-12-10 17:31:50.242704	present	2026-03-02 15:43:44.318533
875	42	2025-12-10	2025-12-10 09:31:10.778345	2025-12-10 17:20:11.927872	present	2026-03-02 15:43:44.318533
876	44	2025-12-10	2025-12-10 09:16:01.627518	2025-12-10 17:23:13.820415	present	2026-03-02 15:43:44.318533
877	49	2025-12-10	2025-12-10 09:07:19.907823	2025-12-10 17:50:57.020725	present	2026-03-02 15:43:44.318533
878	51	2025-12-10	2025-12-10 09:58:20.323786	2025-12-10 17:32:58.663836	present	2026-03-02 15:43:44.318533
879	53	2025-12-10	2025-12-10 09:53:57.363405	2025-12-10 17:30:12.848824	present	2026-03-02 15:43:44.318533
880	54	2025-12-10	2025-12-10 09:03:56.221367	2025-12-10 17:43:04.765981	present	2026-03-02 15:43:44.318533
881	55	2025-12-10	2025-12-10 09:48:17.44544	2025-12-10 17:42:14.006414	present	2026-03-02 15:43:44.318533
882	56	2025-12-10	2025-12-10 09:18:06.167346	2025-12-10 17:24:52.61905	present	2026-03-02 15:43:44.318533
883	57	2025-12-10	2025-12-10 09:23:32.64889	2025-12-10 17:23:22.246567	present	2026-03-02 15:43:44.318533
884	58	2025-12-10	2025-12-10 09:14:43.739232	2025-12-10 17:09:38.152638	present	2026-03-02 15:43:44.318533
885	61	2025-12-10	2025-12-10 09:01:15.079658	2025-12-10 17:27:23.445874	present	2026-03-02 15:43:44.318533
886	67	2025-12-10	2025-12-10 09:00:54.829568	2025-12-10 17:27:34.150225	present	2026-03-02 15:43:44.318533
887	68	2025-12-10	2025-12-10 09:45:24.76475	2025-12-10 17:14:26.362093	present	2026-03-02 15:43:44.318533
888	69	2025-12-10	2025-12-10 09:38:08.636606	2025-12-10 17:14:43.902206	present	2026-03-02 15:43:44.318533
889	72	2025-12-10	2025-12-10 09:15:41.4354	2025-12-10 17:25:40.752872	present	2026-03-02 15:43:44.318533
890	75	2025-12-10	2025-12-10 09:44:31.942652	2025-12-10 17:32:50.841145	present	2026-03-02 15:43:44.318533
891	76	2025-12-10	2025-12-10 09:47:46.659455	2025-12-10 17:22:21.839783	present	2026-03-02 15:43:44.318533
892	77	2025-12-10	2025-12-10 09:19:21.447321	2025-12-10 17:18:27.152067	present	2026-03-02 15:43:44.318533
893	80	2025-12-10	2025-12-10 09:53:34.861602	2025-12-10 17:59:41.345205	present	2026-03-02 15:43:44.318533
894	81	2025-12-10	2025-12-10 09:27:04.398454	2025-12-10 17:15:57.271434	present	2026-03-02 15:43:44.318533
895	86	2025-12-10	2025-12-10 09:39:52.132847	2025-12-10 17:40:45.555517	present	2026-03-02 15:43:44.318533
896	87	2025-12-10	2025-12-10 09:37:32.955765	2025-12-10 17:25:11.470764	present	2026-03-02 15:43:44.318533
897	90	2025-12-10	2025-12-10 09:56:40.326028	2025-12-10 17:13:52.184526	present	2026-03-02 15:43:44.318533
898	91	2025-12-10	2025-12-10 09:04:01.925483	2025-12-10 17:51:49.385733	present	2026-03-02 15:43:44.318533
899	92	2025-12-10	2025-12-10 09:16:19.30903	2025-12-10 17:48:45.614002	present	2026-03-02 15:43:44.318533
900	93	2025-12-10	2025-12-10 09:22:34.980171	2025-12-10 17:31:28.198456	present	2026-03-02 15:43:44.318533
901	94	2025-12-10	2025-12-10 09:45:31.499721	2025-12-10 17:40:57.788412	present	2026-03-02 15:43:44.318533
902	95	2025-12-10	2025-12-10 09:07:59.974599	2025-12-10 17:10:50.97147	present	2026-03-02 15:43:44.318533
903	98	2025-12-10	2025-12-10 09:30:43.200348	2025-12-10 17:54:34.61459	present	2026-03-02 15:43:44.318533
904	99	2025-12-10	2025-12-10 09:08:47.552967	2025-12-10 17:21:18.413796	present	2026-03-02 15:43:44.318533
905	100	2025-12-10	2025-12-10 09:16:15.304313	2025-12-10 17:57:27.709706	present	2026-03-02 15:43:44.318533
906	3	2025-12-11	2025-12-11 09:31:21.73896	2025-12-11 17:33:48.973181	present	2026-03-02 15:43:44.318533
907	4	2025-12-11	2025-12-11 09:13:21.807817	2025-12-11 17:37:27.757296	present	2026-03-02 15:43:44.318533
908	5	2025-12-11	2025-12-11 09:25:12.92485	2025-12-11 17:53:13.246107	present	2026-03-02 15:43:44.318533
909	6	2025-12-11	2025-12-11 09:16:11.740414	2025-12-11 17:42:54.747759	present	2026-03-02 15:43:44.318533
910	10	2025-12-11	2025-12-11 09:29:35.225062	2025-12-11 17:43:45.673206	present	2026-03-02 15:43:44.318533
911	11	2025-12-11	2025-12-11 09:55:22.754806	2025-12-11 17:29:54.245002	present	2026-03-02 15:43:44.318533
912	27	2025-12-11	2025-12-11 09:19:07.639274	2025-12-11 17:50:59.212018	present	2026-03-02 15:43:44.318533
913	33	2025-12-11	2025-12-11 09:31:56.230262	2025-12-11 17:09:03.916057	present	2026-03-02 15:43:44.318533
914	35	2025-12-11	2025-12-11 09:42:26.562493	2025-12-11 17:50:29.496419	present	2026-03-02 15:43:44.318533
915	37	2025-12-11	2025-12-11 09:07:20.278314	2025-12-11 17:39:33.885484	present	2026-03-02 15:43:44.318533
916	43	2025-12-11	2025-12-11 09:17:46.471016	2025-12-11 17:37:09.178732	present	2026-03-02 15:43:44.318533
917	45	2025-12-11	2025-12-11 09:46:50.536837	2025-12-11 17:26:33.187657	present	2026-03-02 15:43:44.318533
918	46	2025-12-11	2025-12-11 09:33:22.991257	2025-12-11 17:58:20.434639	present	2026-03-02 15:43:44.318533
919	47	2025-12-11	2025-12-11 09:43:51.631219	2025-12-11 17:11:31.242342	present	2026-03-02 15:43:44.318533
920	48	2025-12-11	2025-12-11 09:47:03.284742	2025-12-11 17:19:23.056694	present	2026-03-02 15:43:44.318533
921	50	2025-12-11	2025-12-11 09:14:53.449318	2025-12-11 17:59:04.30092	present	2026-03-02 15:43:44.318533
922	52	2025-12-11	2025-12-11 09:34:34.493162	2025-12-11 17:36:43.588056	present	2026-03-02 15:43:44.318533
923	59	2025-12-11	2025-12-11 09:36:19.128891	2025-12-11 17:58:44.892062	present	2026-03-02 15:43:44.318533
924	60	2025-12-11	2025-12-11 09:21:22.658269	2025-12-11 17:30:18.810208	present	2026-03-02 15:43:44.318533
925	62	2025-12-11	2025-12-11 09:43:52.019417	2025-12-11 17:00:50.418629	present	2026-03-02 15:43:44.318533
926	63	2025-12-11	2025-12-11 09:33:37.145737	2025-12-11 17:23:55.766412	present	2026-03-02 15:43:44.318533
927	64	2025-12-11	2025-12-11 09:22:58.301584	2025-12-11 17:02:53.323829	present	2026-03-02 15:43:44.318533
928	65	2025-12-11	2025-12-11 09:28:19.499739	2025-12-11 17:15:50.088775	present	2026-03-02 15:43:44.318533
929	66	2025-12-11	2025-12-11 09:19:28.999831	2025-12-11 17:04:41.558105	present	2026-03-02 15:43:44.318533
930	70	2025-12-11	2025-12-11 09:40:59.408728	2025-12-11 17:16:25.572259	present	2026-03-02 15:43:44.318533
931	71	2025-12-11	2025-12-11 09:40:49.958354	2025-12-11 17:56:06.257301	present	2026-03-02 15:43:44.318533
932	73	2025-12-11	2025-12-11 09:32:57.174686	2025-12-11 17:51:15.148519	present	2026-03-02 15:43:44.318533
933	74	2025-12-11	2025-12-11 09:10:58.404341	2025-12-11 17:28:15.273868	present	2026-03-02 15:43:44.318533
934	78	2025-12-11	2025-12-11 09:06:16.626759	2025-12-11 17:52:53.318758	present	2026-03-02 15:43:44.318533
935	79	2025-12-11	2025-12-11 09:45:32.859669	2025-12-11 17:59:38.477054	present	2026-03-02 15:43:44.318533
936	82	2025-12-11	2025-12-11 09:23:15.52003	2025-12-11 17:37:28.507373	present	2026-03-02 15:43:44.318533
937	83	2025-12-11	2025-12-11 09:13:27.211578	2025-12-11 17:40:52.542025	present	2026-03-02 15:43:44.318533
938	84	2025-12-11	2025-12-11 09:11:41.22609	2025-12-11 17:29:46.722845	present	2026-03-02 15:43:44.318533
939	85	2025-12-11	2025-12-11 09:50:36.271226	2025-12-11 17:34:14.83796	present	2026-03-02 15:43:44.318533
940	88	2025-12-11	2025-12-11 09:56:13.778589	2025-12-11 17:39:31.386275	present	2026-03-02 15:43:44.318533
941	89	2025-12-11	2025-12-11 09:57:32.529396	2025-12-11 17:05:21.529221	present	2026-03-02 15:43:44.318533
942	96	2025-12-11	2025-12-11 09:57:46.590407	2025-12-11 17:56:55.746878	present	2026-03-02 15:43:44.318533
943	97	2025-12-11	2025-12-11 09:03:18.532063	2025-12-11 17:38:11.825215	present	2026-03-02 15:43:44.318533
944	1	2025-12-11	2025-12-11 09:29:51.28964	2025-12-11 17:23:12.459215	present	2026-03-02 15:43:44.318533
945	2	2025-12-11	2025-12-11 09:26:56.004656	2025-12-11 17:05:19.787911	present	2026-03-02 15:43:44.318533
946	7	2025-12-11	2025-12-11 09:12:37.839922	2025-12-11 17:03:18.187291	present	2026-03-02 15:43:44.318533
947	8	2025-12-11	2025-12-11 09:41:09.479915	2025-12-11 17:18:01.748525	present	2026-03-02 15:43:44.318533
948	9	2025-12-11	2025-12-11 09:40:55.824213	2025-12-11 17:31:16.470763	present	2026-03-02 15:43:44.318533
949	12	2025-12-11	2025-12-11 09:26:28.284638	2025-12-11 17:37:34.558373	present	2026-03-02 15:43:44.318533
950	13	2025-12-11	2025-12-11 09:38:59.534725	2025-12-11 17:46:27.979561	present	2026-03-02 15:43:44.318533
951	14	2025-12-11	2025-12-11 09:04:43.360037	2025-12-11 17:39:55.126155	present	2026-03-02 15:43:44.318533
952	15	2025-12-11	2025-12-11 09:29:00.500461	2025-12-11 17:42:39.593098	present	2026-03-02 15:43:44.318533
953	16	2025-12-11	2025-12-11 09:05:36.154012	2025-12-11 17:36:49.750295	present	2026-03-02 15:43:44.318533
954	17	2025-12-11	2025-12-11 09:35:20.484125	2025-12-11 17:38:46.360735	present	2026-03-02 15:43:44.318533
955	18	2025-12-11	2025-12-11 09:13:57.235937	2025-12-11 17:22:27.714295	present	2026-03-02 15:43:44.318533
956	19	2025-12-11	2025-12-11 09:24:46.865348	2025-12-11 17:02:18.544323	present	2026-03-02 15:43:44.318533
957	20	2025-12-11	2025-12-11 09:46:38.720092	2025-12-11 17:21:39.621607	present	2026-03-02 15:43:44.318533
958	21	2025-12-11	2025-12-11 09:44:06.653255	2025-12-11 17:42:29.453293	present	2026-03-02 15:43:44.318533
959	22	2025-12-11	2025-12-11 09:09:48.48035	2025-12-11 17:03:12.007371	present	2026-03-02 15:43:44.318533
960	23	2025-12-11	2025-12-11 09:33:34.883531	2025-12-11 17:05:44.929609	present	2026-03-02 15:43:44.318533
961	24	2025-12-11	2025-12-11 09:36:19.117208	2025-12-11 17:53:50.200779	present	2026-03-02 15:43:44.318533
962	25	2025-12-11	2025-12-11 09:22:27.549619	2025-12-11 17:23:14.573156	present	2026-03-02 15:43:44.318533
963	26	2025-12-11	2025-12-11 09:03:06.447225	2025-12-11 17:20:34.947112	present	2026-03-02 15:43:44.318533
964	28	2025-12-11	2025-12-11 09:44:47.559317	2025-12-11 17:50:28.345092	present	2026-03-02 15:43:44.318533
965	29	2025-12-11	2025-12-11 09:16:26.292946	2025-12-11 17:26:09.788902	present	2026-03-02 15:43:44.318533
966	30	2025-12-11	2025-12-11 09:18:47.349767	2025-12-11 17:11:30.670297	present	2026-03-02 15:43:44.318533
967	31	2025-12-11	2025-12-11 09:36:49.565373	2025-12-11 17:39:03.509423	present	2026-03-02 15:43:44.318533
968	32	2025-12-11	2025-12-11 09:21:42.67265	2025-12-11 17:32:15.828955	present	2026-03-02 15:43:44.318533
969	34	2025-12-11	2025-12-11 09:44:39.074396	2025-12-11 17:13:34.368272	present	2026-03-02 15:43:44.318533
970	36	2025-12-11	2025-12-11 09:21:50.846909	2025-12-11 17:09:06.315721	present	2026-03-02 15:43:44.318533
971	38	2025-12-11	2025-12-11 09:57:09.971679	2025-12-11 17:18:05.454006	present	2026-03-02 15:43:44.318533
972	39	2025-12-11	2025-12-11 09:47:57.76114	2025-12-11 17:11:37.145654	present	2026-03-02 15:43:44.318533
973	40	2025-12-11	2025-12-11 09:05:58.326724	2025-12-11 17:10:49.95337	present	2026-03-02 15:43:44.318533
974	41	2025-12-11	2025-12-11 09:40:32.479709	2025-12-11 17:30:10.232531	present	2026-03-02 15:43:44.318533
975	42	2025-12-11	2025-12-11 09:00:18.437933	2025-12-11 17:55:11.478707	present	2026-03-02 15:43:44.318533
976	44	2025-12-11	2025-12-11 09:01:20.734087	2025-12-11 17:51:14.26612	present	2026-03-02 15:43:44.318533
977	49	2025-12-11	2025-12-11 09:26:38.170363	2025-12-11 17:09:08.026215	present	2026-03-02 15:43:44.318533
978	51	2025-12-11	2025-12-11 09:09:51.289533	2025-12-11 17:45:28.380085	present	2026-03-02 15:43:44.318533
979	53	2025-12-11	2025-12-11 09:27:20.043212	2025-12-11 17:20:18.535212	present	2026-03-02 15:43:44.318533
980	54	2025-12-11	2025-12-11 09:13:24.934347	2025-12-11 17:14:11.973249	present	2026-03-02 15:43:44.318533
981	55	2025-12-11	2025-12-11 09:20:03.057357	2025-12-11 17:35:51.140603	present	2026-03-02 15:43:44.318533
982	56	2025-12-11	2025-12-11 09:08:40.717426	2025-12-11 17:19:26.212586	present	2026-03-02 15:43:44.318533
983	57	2025-12-11	2025-12-11 09:12:13.450916	2025-12-11 17:52:22.186555	present	2026-03-02 15:43:44.318533
984	58	2025-12-11	2025-12-11 09:21:48.856371	2025-12-11 17:31:46.990198	present	2026-03-02 15:43:44.318533
985	61	2025-12-11	2025-12-11 09:48:32.610597	2025-12-11 17:22:27.278455	present	2026-03-02 15:43:44.318533
986	67	2025-12-11	2025-12-11 09:31:36.13297	2025-12-11 17:54:01.497949	present	2026-03-02 15:43:44.318533
987	68	2025-12-11	2025-12-11 09:03:54.565711	2025-12-11 17:39:49.193671	present	2026-03-02 15:43:44.318533
988	69	2025-12-11	2025-12-11 09:50:00.724214	2025-12-11 17:00:38.544852	present	2026-03-02 15:43:44.318533
989	72	2025-12-11	2025-12-11 09:34:43.905628	2025-12-11 17:24:19.036926	present	2026-03-02 15:43:44.318533
990	75	2025-12-11	2025-12-11 09:33:49.738282	2025-12-11 17:10:41.791026	present	2026-03-02 15:43:44.318533
991	76	2025-12-11	2025-12-11 09:19:26.740803	2025-12-11 17:33:05.526419	present	2026-03-02 15:43:44.318533
992	77	2025-12-11	2025-12-11 09:41:20.949573	2025-12-11 17:06:16.396553	present	2026-03-02 15:43:44.318533
993	80	2025-12-11	2025-12-11 09:40:39.505517	2025-12-11 17:34:26.186588	present	2026-03-02 15:43:44.318533
994	81	2025-12-11	2025-12-11 09:29:09.938008	2025-12-11 17:51:30.354524	present	2026-03-02 15:43:44.318533
995	86	2025-12-11	2025-12-11 09:18:08.786782	2025-12-11 17:45:57.686841	present	2026-03-02 15:43:44.318533
996	87	2025-12-11	2025-12-11 09:50:21.083875	2025-12-11 17:21:02.216085	present	2026-03-02 15:43:44.318533
997	90	2025-12-11	2025-12-11 09:44:36.984829	2025-12-11 17:45:33.631198	present	2026-03-02 15:43:44.318533
998	91	2025-12-11	2025-12-11 09:42:06.485397	2025-12-11 17:23:28.239355	present	2026-03-02 15:43:44.318533
999	92	2025-12-11	2025-12-11 09:28:26.441535	2025-12-11 17:28:08.188845	present	2026-03-02 15:43:44.318533
1000	93	2025-12-11	2025-12-11 09:59:28.487114	2025-12-11 17:05:48.02558	present	2026-03-02 15:43:44.318533
1001	94	2025-12-11	2025-12-11 09:07:52.371051	2025-12-11 17:54:47.557199	present	2026-03-02 15:43:44.318533
1002	95	2025-12-11	2025-12-11 09:49:45.840309	2025-12-11 17:29:13.243541	present	2026-03-02 15:43:44.318533
1003	98	2025-12-11	2025-12-11 09:34:07.087003	2025-12-11 17:06:41.589677	present	2026-03-02 15:43:44.318533
1004	99	2025-12-11	2025-12-11 09:44:06.424298	2025-12-11 17:48:20.351858	present	2026-03-02 15:43:44.318533
1005	100	2025-12-11	2025-12-11 09:39:44.286953	2025-12-11 17:55:30.602933	present	2026-03-02 15:43:44.318533
1006	3	2025-12-12	2025-12-12 09:46:57.291553	2025-12-12 17:10:02.917098	present	2026-03-02 15:43:44.318533
1007	4	2025-12-12	2025-12-12 09:27:11.678529	2025-12-12 17:28:38.272678	present	2026-03-02 15:43:44.318533
1008	5	2025-12-12	2025-12-12 09:06:29.340737	2025-12-12 17:49:51.084674	present	2026-03-02 15:43:44.318533
1009	6	2025-12-12	2025-12-12 09:43:07.875372	2025-12-12 17:45:33.455679	present	2026-03-02 15:43:44.318533
1010	10	2025-12-12	2025-12-12 09:28:43.653552	2025-12-12 17:49:22.869098	present	2026-03-02 15:43:44.318533
1011	11	2025-12-12	2025-12-12 09:45:41.311041	2025-12-12 17:44:34.089481	present	2026-03-02 15:43:44.318533
1012	27	2025-12-12	2025-12-12 09:48:09.049639	2025-12-12 17:10:27.820367	present	2026-03-02 15:43:44.318533
1013	33	2025-12-12	2025-12-12 09:04:18.578092	2025-12-12 17:20:21.352119	present	2026-03-02 15:43:44.318533
1014	35	2025-12-12	2025-12-12 09:10:27.104844	2025-12-12 17:55:36.97781	present	2026-03-02 15:43:44.318533
1015	37	2025-12-12	2025-12-12 09:45:21.769956	2025-12-12 17:58:51.904302	present	2026-03-02 15:43:44.318533
1016	43	2025-12-12	2025-12-12 09:40:13.118347	2025-12-12 17:32:54.313341	present	2026-03-02 15:43:44.318533
1017	45	2025-12-12	2025-12-12 09:31:42.005776	2025-12-12 17:47:21.727776	present	2026-03-02 15:43:44.318533
1018	46	2025-12-12	2025-12-12 09:15:24.773078	2025-12-12 17:59:57.081059	present	2026-03-02 15:43:44.318533
1019	47	2025-12-12	2025-12-12 09:54:55.703751	2025-12-12 17:16:06.946694	present	2026-03-02 15:43:44.318533
1020	48	2025-12-12	2025-12-12 09:52:18.338934	2025-12-12 17:11:22.351191	present	2026-03-02 15:43:44.318533
1021	50	2025-12-12	2025-12-12 09:02:45.521561	2025-12-12 17:36:59.548272	present	2026-03-02 15:43:44.318533
1022	52	2025-12-12	2025-12-12 09:40:15.650126	2025-12-12 17:29:19.736794	present	2026-03-02 15:43:44.318533
1023	59	2025-12-12	2025-12-12 09:27:24.568242	2025-12-12 17:26:23.032505	present	2026-03-02 15:43:44.318533
1024	60	2025-12-12	2025-12-12 09:14:25.621073	2025-12-12 17:31:35.499893	present	2026-03-02 15:43:44.318533
1025	62	2025-12-12	2025-12-12 09:15:38.116324	2025-12-12 17:33:26.472374	present	2026-03-02 15:43:44.318533
1026	63	2025-12-12	2025-12-12 09:22:32.211064	2025-12-12 17:35:11.086371	present	2026-03-02 15:43:44.318533
1027	64	2025-12-12	2025-12-12 09:36:41.225574	2025-12-12 17:40:56.52446	present	2026-03-02 15:43:44.318533
1028	65	2025-12-12	2025-12-12 09:41:03.06304	2025-12-12 17:58:42.93508	present	2026-03-02 15:43:44.318533
1029	66	2025-12-12	2025-12-12 09:12:26.036497	2025-12-12 17:42:47.145459	present	2026-03-02 15:43:44.318533
1030	70	2025-12-12	2025-12-12 09:24:07.339708	2025-12-12 17:17:12.092658	present	2026-03-02 15:43:44.318533
1031	71	2025-12-12	2025-12-12 09:03:29.030496	2025-12-12 17:23:06.10146	present	2026-03-02 15:43:44.318533
1032	73	2025-12-12	2025-12-12 09:43:22.902372	2025-12-12 17:00:50.293554	present	2026-03-02 15:43:44.318533
1033	74	2025-12-12	2025-12-12 09:28:57.555293	2025-12-12 17:59:04.424848	present	2026-03-02 15:43:44.318533
1034	78	2025-12-12	2025-12-12 09:52:13.80878	2025-12-12 17:08:40.256116	present	2026-03-02 15:43:44.318533
1035	79	2025-12-12	2025-12-12 09:35:19.946914	2025-12-12 17:53:48.152725	present	2026-03-02 15:43:44.318533
1036	82	2025-12-12	2025-12-12 09:19:23.951812	2025-12-12 17:56:51.259925	present	2026-03-02 15:43:44.318533
1037	83	2025-12-12	2025-12-12 09:05:58.735472	2025-12-12 17:17:10.5749	present	2026-03-02 15:43:44.318533
1038	84	2025-12-12	2025-12-12 09:00:57.455934	2025-12-12 17:00:07.328732	present	2026-03-02 15:43:44.318533
1039	85	2025-12-12	2025-12-12 09:28:31.587278	2025-12-12 17:49:27.677596	present	2026-03-02 15:43:44.318533
1040	88	2025-12-12	2025-12-12 09:46:38.072444	2025-12-12 17:55:13.452721	present	2026-03-02 15:43:44.318533
1041	89	2025-12-12	2025-12-12 09:58:44.732902	2025-12-12 17:23:25.160942	present	2026-03-02 15:43:44.318533
1042	96	2025-12-12	2025-12-12 09:46:23.549357	2025-12-12 17:51:27.874077	present	2026-03-02 15:43:44.318533
1043	97	2025-12-12	2025-12-12 09:33:15.53236	2025-12-12 17:45:30.336994	present	2026-03-02 15:43:44.318533
1044	1	2025-12-12	2025-12-12 09:59:47.833478	2025-12-12 17:41:52.709988	present	2026-03-02 15:43:44.318533
1045	2	2025-12-12	2025-12-12 09:09:49.740691	2025-12-12 17:58:19.105777	present	2026-03-02 15:43:44.318533
1046	7	2025-12-12	2025-12-12 09:44:46.140601	2025-12-12 17:51:42.473935	present	2026-03-02 15:43:44.318533
1047	8	2025-12-12	2025-12-12 09:10:57.19454	2025-12-12 17:30:59.536775	present	2026-03-02 15:43:44.318533
1048	9	2025-12-12	2025-12-12 09:32:47.154061	2025-12-12 17:37:05.271143	present	2026-03-02 15:43:44.318533
1049	12	2025-12-12	2025-12-12 09:52:14.654392	2025-12-12 17:49:11.86289	present	2026-03-02 15:43:44.318533
1050	13	2025-12-12	2025-12-12 09:02:23.521195	2025-12-12 17:14:51.574876	present	2026-03-02 15:43:44.318533
1051	14	2025-12-12	2025-12-12 09:01:45.393687	2025-12-12 17:39:29.633246	present	2026-03-02 15:43:44.318533
1052	15	2025-12-12	2025-12-12 09:55:03.468038	2025-12-12 17:02:09.15973	present	2026-03-02 15:43:44.318533
1053	16	2025-12-12	2025-12-12 09:54:21.284407	2025-12-12 17:17:45.610603	present	2026-03-02 15:43:44.318533
1054	17	2025-12-12	2025-12-12 09:02:23.906382	2025-12-12 17:19:55.397184	present	2026-03-02 15:43:44.318533
1055	18	2025-12-12	2025-12-12 09:27:01.710442	2025-12-12 17:41:46.961836	present	2026-03-02 15:43:44.318533
1056	19	2025-12-12	2025-12-12 09:43:14.059965	2025-12-12 17:45:57.343004	present	2026-03-02 15:43:44.318533
1057	20	2025-12-12	2025-12-12 09:46:41.459438	2025-12-12 17:01:34.237098	present	2026-03-02 15:43:44.318533
1058	21	2025-12-12	2025-12-12 09:59:07.428224	2025-12-12 17:46:25.109421	present	2026-03-02 15:43:44.318533
1059	22	2025-12-12	2025-12-12 09:47:07.039072	2025-12-12 17:56:43.345124	present	2026-03-02 15:43:44.318533
1060	23	2025-12-12	2025-12-12 09:02:42.830122	2025-12-12 17:07:28.982455	present	2026-03-02 15:43:44.318533
1061	24	2025-12-12	2025-12-12 09:30:45.102953	2025-12-12 17:46:12.377259	present	2026-03-02 15:43:44.318533
1062	25	2025-12-12	2025-12-12 09:54:03.990889	2025-12-12 17:37:40.496466	present	2026-03-02 15:43:44.318533
1063	26	2025-12-12	2025-12-12 09:20:22.342765	2025-12-12 17:07:48.61809	present	2026-03-02 15:43:44.318533
1064	28	2025-12-12	2025-12-12 09:46:07.397188	2025-12-12 17:53:48.937887	present	2026-03-02 15:43:44.318533
1065	29	2025-12-12	2025-12-12 09:39:31.191663	2025-12-12 17:10:26.172238	present	2026-03-02 15:43:44.318533
1066	30	2025-12-12	2025-12-12 09:35:51.032337	2025-12-12 17:00:33.197376	present	2026-03-02 15:43:44.318533
1067	31	2025-12-12	2025-12-12 09:12:57.501741	2025-12-12 17:57:19.934512	present	2026-03-02 15:43:44.318533
1068	32	2025-12-12	2025-12-12 09:19:41.135098	2025-12-12 17:18:54.356567	present	2026-03-02 15:43:44.318533
1069	34	2025-12-12	2025-12-12 09:38:59.955212	2025-12-12 17:12:06.232761	present	2026-03-02 15:43:44.318533
1070	36	2025-12-12	2025-12-12 09:56:11.500935	2025-12-12 17:45:49.365862	present	2026-03-02 15:43:44.318533
1071	38	2025-12-12	2025-12-12 09:08:08.123577	2025-12-12 17:07:25.779027	present	2026-03-02 15:43:44.318533
1072	39	2025-12-12	2025-12-12 09:21:26.865971	2025-12-12 17:30:02.262658	present	2026-03-02 15:43:44.318533
1073	40	2025-12-12	2025-12-12 09:54:45.24634	2025-12-12 17:10:24.570073	present	2026-03-02 15:43:44.318533
1074	41	2025-12-12	2025-12-12 09:26:31.230756	2025-12-12 17:36:18.720105	present	2026-03-02 15:43:44.318533
1075	42	2025-12-12	2025-12-12 09:00:36.812881	2025-12-12 17:16:16.6919	present	2026-03-02 15:43:44.318533
1076	44	2025-12-12	2025-12-12 09:01:16.050766	2025-12-12 17:20:45.792276	present	2026-03-02 15:43:44.318533
1077	49	2025-12-12	2025-12-12 09:26:23.002702	2025-12-12 17:33:28.429525	present	2026-03-02 15:43:44.318533
1078	51	2025-12-12	2025-12-12 09:32:38.7429	2025-12-12 17:09:09.447374	present	2026-03-02 15:43:44.318533
1079	53	2025-12-12	2025-12-12 09:38:17.737477	2025-12-12 17:31:58.446045	present	2026-03-02 15:43:44.318533
1080	54	2025-12-12	2025-12-12 09:25:05.812868	2025-12-12 17:40:27.311012	present	2026-03-02 15:43:44.318533
1081	55	2025-12-12	2025-12-12 09:48:05.830086	2025-12-12 17:09:28.860857	present	2026-03-02 15:43:44.318533
1082	56	2025-12-12	2025-12-12 09:51:39.108287	2025-12-12 17:49:47.324826	present	2026-03-02 15:43:44.318533
1083	57	2025-12-12	2025-12-12 09:59:32.383305	2025-12-12 17:11:58.447061	present	2026-03-02 15:43:44.318533
1084	58	2025-12-12	2025-12-12 09:20:01.304925	2025-12-12 17:43:39.194933	present	2026-03-02 15:43:44.318533
1085	61	2025-12-12	2025-12-12 09:01:12.395597	2025-12-12 17:04:25.192727	present	2026-03-02 15:43:44.318533
1086	67	2025-12-12	2025-12-12 09:15:26.312692	2025-12-12 17:58:47.908514	present	2026-03-02 15:43:44.318533
1087	68	2025-12-12	2025-12-12 09:56:01.064734	2025-12-12 17:03:15.706859	present	2026-03-02 15:43:44.318533
1088	69	2025-12-12	2025-12-12 09:49:05.150272	2025-12-12 17:58:08.21788	present	2026-03-02 15:43:44.318533
1089	72	2025-12-12	2025-12-12 09:37:07.228659	2025-12-12 17:08:44.770944	present	2026-03-02 15:43:44.318533
1090	75	2025-12-12	2025-12-12 09:54:38.133162	2025-12-12 17:13:40.829081	present	2026-03-02 15:43:44.318533
1091	76	2025-12-12	2025-12-12 09:25:26.868377	2025-12-12 17:39:31.256509	present	2026-03-02 15:43:44.318533
1092	77	2025-12-12	2025-12-12 09:50:39.70331	2025-12-12 17:09:43.992976	present	2026-03-02 15:43:44.318533
1093	80	2025-12-12	2025-12-12 09:55:19.573072	2025-12-12 17:29:11.688079	present	2026-03-02 15:43:44.318533
1094	81	2025-12-12	2025-12-12 09:32:14.70346	2025-12-12 17:02:18.695284	present	2026-03-02 15:43:44.318533
1095	86	2025-12-12	2025-12-12 09:07:28.056865	2025-12-12 17:35:42.677144	present	2026-03-02 15:43:44.318533
1096	87	2025-12-12	2025-12-12 09:58:59.224729	2025-12-12 17:38:50.686981	present	2026-03-02 15:43:44.318533
1097	90	2025-12-12	2025-12-12 09:39:38.108967	2025-12-12 17:35:46.672097	present	2026-03-02 15:43:44.318533
1098	91	2025-12-12	2025-12-12 09:47:09.072211	2025-12-12 17:25:19.743252	present	2026-03-02 15:43:44.318533
1099	92	2025-12-12	2025-12-12 09:26:09.352393	2025-12-12 17:14:26.988081	present	2026-03-02 15:43:44.318533
1100	93	2025-12-12	2025-12-12 09:21:48.551907	2025-12-12 17:31:17.310083	present	2026-03-02 15:43:44.318533
1101	94	2025-12-12	2025-12-12 09:28:30.720471	2025-12-12 17:03:23.537292	present	2026-03-02 15:43:44.318533
1102	95	2025-12-12	2025-12-12 09:53:14.409409	2025-12-12 17:11:54.412145	present	2026-03-02 15:43:44.318533
1103	98	2025-12-12	2025-12-12 09:07:51.73846	2025-12-12 17:12:29.709317	present	2026-03-02 15:43:44.318533
1104	99	2025-12-12	2025-12-12 09:36:58.289332	2025-12-12 17:40:52.260763	present	2026-03-02 15:43:44.318533
1105	100	2025-12-12	2025-12-12 09:05:44.124945	2025-12-12 17:25:30.213522	present	2026-03-02 15:43:44.318533
1106	3	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1107	4	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1108	5	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1109	6	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1110	10	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1111	11	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1112	27	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1113	33	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1114	35	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1115	37	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1116	43	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1117	45	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1118	46	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1119	47	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1120	48	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1121	50	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1122	52	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1123	59	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1124	60	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1125	62	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1126	63	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1127	64	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1128	65	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1129	66	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1130	70	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1131	71	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1132	73	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1133	74	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1134	78	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1135	79	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1136	82	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1137	83	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1138	84	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1139	85	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1140	88	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1141	89	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1142	96	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1143	97	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1144	1	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1145	2	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1146	7	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1147	8	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1148	9	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1149	12	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1150	13	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1151	14	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1152	15	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1153	16	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1154	17	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1155	18	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1156	19	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1157	20	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1158	21	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1159	22	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1160	23	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1161	24	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1162	25	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1163	26	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1164	28	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1165	29	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1166	30	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1167	31	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1168	32	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1169	34	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1170	36	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1171	38	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1172	39	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1173	40	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1174	41	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1175	42	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1176	44	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1177	49	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1178	51	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1179	53	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1180	54	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1181	55	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1182	56	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1183	57	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1184	58	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1185	61	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1186	67	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1187	68	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1188	69	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1189	72	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1190	75	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1191	76	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1192	77	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1193	80	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1194	81	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1195	86	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1196	87	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1197	90	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1198	91	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1199	92	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1200	93	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1201	94	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1202	95	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1203	98	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1204	99	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1205	100	2025-12-13	\N	\N	absent	2026-03-02 15:43:44.318533
1206	3	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1207	4	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1208	5	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1209	6	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1210	10	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1211	11	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1212	27	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1213	33	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1214	35	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1215	37	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1216	43	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1217	45	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1218	46	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1219	47	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1220	48	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1221	50	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1222	52	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1223	59	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1224	60	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1225	62	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1226	63	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1227	64	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1228	65	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1229	66	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1230	70	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1231	71	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1232	73	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1233	74	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1234	78	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1235	79	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1236	82	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1237	83	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1238	84	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1239	85	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1240	88	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1241	89	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1242	96	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1243	97	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1244	1	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1245	2	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1246	7	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1247	8	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1248	9	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1249	12	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1250	13	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1251	14	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1252	15	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1253	16	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1254	17	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1255	18	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1256	19	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1257	20	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1258	21	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1259	22	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1260	23	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1261	24	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1262	25	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1263	26	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1264	28	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1265	29	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1266	30	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1267	31	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1268	32	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1269	34	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1270	36	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1271	38	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1272	39	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1273	40	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1274	41	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1275	42	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1276	44	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1277	49	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1278	51	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1279	53	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1280	54	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1281	55	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1282	56	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1283	57	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1284	58	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1285	61	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1286	67	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1287	68	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1288	69	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1289	72	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1290	75	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1291	76	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1292	77	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1293	80	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1294	81	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1295	86	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1296	87	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1297	90	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1298	91	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1299	92	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1300	93	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1301	94	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1302	95	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1303	98	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1304	99	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1305	100	2025-12-14	\N	\N	absent	2026-03-02 15:43:44.318533
1306	3	2025-12-15	2025-12-15 09:25:14.254388	2025-12-15 17:40:47.867847	present	2026-03-02 15:43:44.318533
1307	4	2025-12-15	2025-12-15 09:03:00.906655	2025-12-15 17:14:54.656497	present	2026-03-02 15:43:44.318533
1308	5	2025-12-15	2025-12-15 09:30:18.333808	2025-12-15 17:53:28.871483	present	2026-03-02 15:43:44.318533
1309	6	2025-12-15	2025-12-15 09:20:55.398749	2025-12-15 17:48:50.359787	present	2026-03-02 15:43:44.318533
1310	10	2025-12-15	2025-12-15 09:09:09.336748	2025-12-15 17:56:12.774096	present	2026-03-02 15:43:44.318533
1311	11	2025-12-15	2025-12-15 09:46:14.785924	2025-12-15 17:06:05.218968	present	2026-03-02 15:43:44.318533
1312	27	2025-12-15	2025-12-15 09:44:44.76739	2025-12-15 17:37:51.384683	present	2026-03-02 15:43:44.318533
1313	33	2025-12-15	2025-12-15 09:13:43.932998	2025-12-15 17:27:34.595735	present	2026-03-02 15:43:44.318533
1314	35	2025-12-15	2025-12-15 09:17:04.759703	2025-12-15 17:31:00.164321	present	2026-03-02 15:43:44.318533
1315	37	2025-12-15	2025-12-15 09:28:45.28518	2025-12-15 17:59:11.010025	present	2026-03-02 15:43:44.318533
1316	43	2025-12-15	2025-12-15 09:17:13.289828	2025-12-15 17:45:34.911858	present	2026-03-02 15:43:44.318533
1317	45	2025-12-15	2025-12-15 09:19:38.144998	2025-12-15 17:56:13.161655	present	2026-03-02 15:43:44.318533
1318	46	2025-12-15	2025-12-15 09:47:45.865503	2025-12-15 17:20:04.44655	present	2026-03-02 15:43:44.318533
1319	47	2025-12-15	2025-12-15 09:42:05.804273	2025-12-15 17:12:36.068192	present	2026-03-02 15:43:44.318533
1320	48	2025-12-15	2025-12-15 09:17:26.64152	2025-12-15 17:56:32.100699	present	2026-03-02 15:43:44.318533
1321	50	2025-12-15	2025-12-15 09:11:11.287835	2025-12-15 17:24:36.59803	present	2026-03-02 15:43:44.318533
1322	52	2025-12-15	2025-12-15 09:33:09.889522	2025-12-15 17:42:18.43757	present	2026-03-02 15:43:44.318533
1323	59	2025-12-15	2025-12-15 09:10:19.535978	2025-12-15 17:56:04.482363	present	2026-03-02 15:43:44.318533
1324	60	2025-12-15	2025-12-15 09:31:19.97259	2025-12-15 17:32:23.423244	present	2026-03-02 15:43:44.318533
1325	62	2025-12-15	2025-12-15 09:33:54.147934	2025-12-15 17:07:27.782981	present	2026-03-02 15:43:44.318533
1326	63	2025-12-15	2025-12-15 09:20:26.309481	2025-12-15 17:30:06.89704	present	2026-03-02 15:43:44.318533
1327	64	2025-12-15	2025-12-15 09:14:46.159473	2025-12-15 17:19:56.087726	present	2026-03-02 15:43:44.318533
1328	65	2025-12-15	2025-12-15 09:21:22.42763	2025-12-15 17:45:04.370182	present	2026-03-02 15:43:44.318533
1329	66	2025-12-15	2025-12-15 09:47:58.828255	2025-12-15 17:59:57.181303	present	2026-03-02 15:43:44.318533
1330	70	2025-12-15	2025-12-15 09:29:15.284962	2025-12-15 17:28:47.338326	present	2026-03-02 15:43:44.318533
1331	71	2025-12-15	2025-12-15 09:44:16.653549	2025-12-15 17:35:57.66072	present	2026-03-02 15:43:44.318533
1332	73	2025-12-15	2025-12-15 09:15:58.956455	2025-12-15 17:03:49.358151	present	2026-03-02 15:43:44.318533
1333	74	2025-12-15	2025-12-15 09:56:22.529022	2025-12-15 17:31:30.414492	present	2026-03-02 15:43:44.318533
1334	78	2025-12-15	2025-12-15 09:12:12.882827	2025-12-15 17:55:33.614987	present	2026-03-02 15:43:44.318533
1335	79	2025-12-15	2025-12-15 09:19:35.039787	2025-12-15 17:44:16.207164	present	2026-03-02 15:43:44.318533
1336	82	2025-12-15	2025-12-15 09:28:25.886287	2025-12-15 17:53:09.95717	present	2026-03-02 15:43:44.318533
1337	83	2025-12-15	2025-12-15 09:56:30.033938	2025-12-15 17:09:01.217344	present	2026-03-02 15:43:44.318533
1338	84	2025-12-15	2025-12-15 09:29:41.843495	2025-12-15 17:39:48.711245	present	2026-03-02 15:43:44.318533
1339	85	2025-12-15	2025-12-15 09:54:16.965647	2025-12-15 17:31:04.421198	present	2026-03-02 15:43:44.318533
1340	88	2025-12-15	2025-12-15 09:50:03.796007	2025-12-15 17:30:07.423595	present	2026-03-02 15:43:44.318533
1341	89	2025-12-15	2025-12-15 09:27:01.791644	2025-12-15 17:27:51.157705	present	2026-03-02 15:43:44.318533
1342	96	2025-12-15	2025-12-15 09:40:10.216669	2025-12-15 17:16:33.419911	present	2026-03-02 15:43:44.318533
1343	97	2025-12-15	2025-12-15 09:53:30.115444	2025-12-15 17:16:31.064594	present	2026-03-02 15:43:44.318533
1344	1	2025-12-15	2025-12-15 09:07:54.361238	2025-12-15 17:43:36.644727	present	2026-03-02 15:43:44.318533
1345	2	2025-12-15	2025-12-15 09:46:00.385813	2025-12-15 17:04:18.767055	present	2026-03-02 15:43:44.318533
1346	7	2025-12-15	2025-12-15 09:20:25.569432	2025-12-15 17:21:08.998841	present	2026-03-02 15:43:44.318533
1347	8	2025-12-15	2025-12-15 09:54:01.139939	2025-12-15 17:47:52.763144	present	2026-03-02 15:43:44.318533
1348	9	2025-12-15	2025-12-15 09:12:23.430151	2025-12-15 17:59:33.031915	present	2026-03-02 15:43:44.318533
1349	12	2025-12-15	2025-12-15 09:09:22.791946	2025-12-15 17:52:28.210263	present	2026-03-02 15:43:44.318533
1350	13	2025-12-15	2025-12-15 09:30:35.915015	2025-12-15 17:23:36.362108	present	2026-03-02 15:43:44.318533
1351	14	2025-12-15	2025-12-15 09:56:00.873959	2025-12-15 17:50:59.19449	present	2026-03-02 15:43:44.318533
1352	15	2025-12-15	2025-12-15 09:33:45.492544	2025-12-15 17:46:40.398309	present	2026-03-02 15:43:44.318533
1353	16	2025-12-15	2025-12-15 09:21:59.71719	2025-12-15 17:02:36.417345	present	2026-03-02 15:43:44.318533
1354	17	2025-12-15	2025-12-15 09:28:10.35399	2025-12-15 17:04:17.980993	present	2026-03-02 15:43:44.318533
1355	18	2025-12-15	2025-12-15 09:22:22.493205	2025-12-15 17:54:28.620628	present	2026-03-02 15:43:44.318533
1356	19	2025-12-15	2025-12-15 09:03:26.674565	2025-12-15 17:07:19.199369	present	2026-03-02 15:43:44.318533
1357	20	2025-12-15	2025-12-15 09:02:16.572482	2025-12-15 17:05:23.421615	present	2026-03-02 15:43:44.318533
1358	21	2025-12-15	2025-12-15 09:39:50.057678	2025-12-15 17:11:32.968841	present	2026-03-02 15:43:44.318533
1359	22	2025-12-15	2025-12-15 09:40:09.756405	2025-12-15 17:31:18.338927	present	2026-03-02 15:43:44.318533
1360	23	2025-12-15	2025-12-15 09:35:25.395657	2025-12-15 17:31:39.942026	present	2026-03-02 15:43:44.318533
1361	24	2025-12-15	2025-12-15 09:23:41.90782	2025-12-15 17:45:34.562224	present	2026-03-02 15:43:44.318533
1362	25	2025-12-15	2025-12-15 09:38:34.009792	2025-12-15 17:53:40.9605	present	2026-03-02 15:43:44.318533
1363	26	2025-12-15	2025-12-15 09:50:51.101783	2025-12-15 17:50:44.237933	present	2026-03-02 15:43:44.318533
1364	28	2025-12-15	2025-12-15 09:26:08.353573	2025-12-15 17:58:24.410859	present	2026-03-02 15:43:44.318533
1365	29	2025-12-15	2025-12-15 09:55:41.276101	2025-12-15 17:47:57.630866	present	2026-03-02 15:43:44.318533
1366	30	2025-12-15	2025-12-15 09:19:28.660517	2025-12-15 17:48:32.914483	present	2026-03-02 15:43:44.318533
1367	31	2025-12-15	2025-12-15 09:53:32.166303	2025-12-15 17:28:14.586703	present	2026-03-02 15:43:44.318533
1368	32	2025-12-15	2025-12-15 09:41:47.559131	2025-12-15 17:47:55.427802	present	2026-03-02 15:43:44.318533
1369	34	2025-12-15	2025-12-15 09:34:12.949739	2025-12-15 17:30:01.369629	present	2026-03-02 15:43:44.318533
1370	36	2025-12-15	2025-12-15 09:12:05.690435	2025-12-15 17:01:38.874421	present	2026-03-02 15:43:44.318533
1371	38	2025-12-15	2025-12-15 09:17:02.134917	2025-12-15 17:54:25.775008	present	2026-03-02 15:43:44.318533
1372	39	2025-12-15	2025-12-15 09:32:29.467309	2025-12-15 17:41:53.04858	present	2026-03-02 15:43:44.318533
1373	40	2025-12-15	2025-12-15 09:03:46.730153	2025-12-15 17:27:37.020365	present	2026-03-02 15:43:44.318533
1374	41	2025-12-15	2025-12-15 09:08:43.123483	2025-12-15 17:45:34.647528	present	2026-03-02 15:43:44.318533
1375	42	2025-12-15	2025-12-15 09:32:00.044829	2025-12-15 17:29:18.481887	present	2026-03-02 15:43:44.318533
1376	44	2025-12-15	2025-12-15 09:14:45.45463	2025-12-15 17:46:07.914043	present	2026-03-02 15:43:44.318533
1377	49	2025-12-15	2025-12-15 09:07:46.8312	2025-12-15 17:11:44.064497	present	2026-03-02 15:43:44.318533
1378	51	2025-12-15	2025-12-15 09:32:30.302106	2025-12-15 17:39:59.617015	present	2026-03-02 15:43:44.318533
1379	53	2025-12-15	2025-12-15 09:30:56.66678	2025-12-15 17:09:30.353198	present	2026-03-02 15:43:44.318533
1380	54	2025-12-15	2025-12-15 09:03:20.445258	2025-12-15 17:02:20.148727	present	2026-03-02 15:43:44.318533
1381	55	2025-12-15	2025-12-15 09:08:51.436509	2025-12-15 17:41:35.875551	present	2026-03-02 15:43:44.318533
1382	56	2025-12-15	2025-12-15 09:22:13.747878	2025-12-15 17:35:33.645314	present	2026-03-02 15:43:44.318533
1383	57	2025-12-15	2025-12-15 09:33:51.950466	2025-12-15 17:43:35.9116	present	2026-03-02 15:43:44.318533
1384	58	2025-12-15	2025-12-15 09:41:52.338811	2025-12-15 17:45:40.624345	present	2026-03-02 15:43:44.318533
1385	61	2025-12-15	2025-12-15 09:59:15.918814	2025-12-15 17:44:54.647181	present	2026-03-02 15:43:44.318533
1386	67	2025-12-15	2025-12-15 09:43:22.173092	2025-12-15 17:13:41.9323	present	2026-03-02 15:43:44.318533
1387	68	2025-12-15	2025-12-15 09:06:45.958579	2025-12-15 17:54:56.128498	present	2026-03-02 15:43:44.318533
1388	69	2025-12-15	2025-12-15 09:48:10.174214	2025-12-15 17:15:07.962212	present	2026-03-02 15:43:44.318533
1389	72	2025-12-15	2025-12-15 09:22:18.383705	2025-12-15 17:24:47.616899	present	2026-03-02 15:43:44.318533
1390	75	2025-12-15	2025-12-15 09:44:14.457468	2025-12-15 17:56:43.946537	present	2026-03-02 15:43:44.318533
1391	76	2025-12-15	2025-12-15 09:47:49.044143	2025-12-15 17:36:27.452968	present	2026-03-02 15:43:44.318533
1392	77	2025-12-15	2025-12-15 09:11:20.128273	2025-12-15 17:41:07.446924	present	2026-03-02 15:43:44.318533
1393	80	2025-12-15	2025-12-15 09:38:52.092399	2025-12-15 17:57:23.238132	present	2026-03-02 15:43:44.318533
1394	81	2025-12-15	2025-12-15 09:36:37.993909	2025-12-15 17:14:00.609718	present	2026-03-02 15:43:44.318533
1395	86	2025-12-15	2025-12-15 09:38:27.578912	2025-12-15 17:44:12.970839	present	2026-03-02 15:43:44.318533
1396	87	2025-12-15	2025-12-15 09:20:34.972574	2025-12-15 17:21:09.792267	present	2026-03-02 15:43:44.318533
1397	90	2025-12-15	2025-12-15 09:58:54.92666	2025-12-15 17:15:56.094175	present	2026-03-02 15:43:44.318533
1398	91	2025-12-15	2025-12-15 09:15:03.923972	2025-12-15 17:54:03.695849	present	2026-03-02 15:43:44.318533
1399	92	2025-12-15	2025-12-15 09:35:13.161549	2025-12-15 17:57:21.731452	present	2026-03-02 15:43:44.318533
1400	93	2025-12-15	2025-12-15 09:42:50.840194	2025-12-15 17:57:40.545351	present	2026-03-02 15:43:44.318533
1401	94	2025-12-15	2025-12-15 09:17:49.712769	2025-12-15 17:25:27.048358	present	2026-03-02 15:43:44.318533
1402	95	2025-12-15	2025-12-15 09:58:55.971204	2025-12-15 17:52:15.193939	present	2026-03-02 15:43:44.318533
1403	98	2025-12-15	2025-12-15 09:13:10.142346	2025-12-15 17:01:33.401182	present	2026-03-02 15:43:44.318533
1404	99	2025-12-15	2025-12-15 09:36:17.022722	2025-12-15 17:55:31.082088	present	2026-03-02 15:43:44.318533
1405	100	2025-12-15	2025-12-15 09:33:26.233058	2025-12-15 17:21:08.291151	present	2026-03-02 15:43:44.318533
1406	3	2025-12-16	2025-12-16 09:51:31.781506	2025-12-16 17:46:41.991614	present	2026-03-02 15:43:44.318533
1407	4	2025-12-16	2025-12-16 09:40:38.012562	2025-12-16 17:26:06.497512	present	2026-03-02 15:43:44.318533
1408	5	2025-12-16	2025-12-16 09:33:29.421597	2025-12-16 17:11:32.963019	present	2026-03-02 15:43:44.318533
1409	6	2025-12-16	2025-12-16 09:09:17.634916	2025-12-16 17:36:01.534978	present	2026-03-02 15:43:44.318533
1410	10	2025-12-16	2025-12-16 09:29:37.023883	2025-12-16 17:55:06.647116	present	2026-03-02 15:43:44.318533
1411	11	2025-12-16	2025-12-16 09:32:46.734557	2025-12-16 17:49:27.484358	present	2026-03-02 15:43:44.318533
1412	27	2025-12-16	2025-12-16 09:26:19.135266	2025-12-16 17:57:35.911535	present	2026-03-02 15:43:44.318533
1413	33	2025-12-16	2025-12-16 09:17:50.11585	2025-12-16 17:13:02.034433	present	2026-03-02 15:43:44.318533
1414	35	2025-12-16	2025-12-16 09:47:47.819083	2025-12-16 17:31:47.740426	present	2026-03-02 15:43:44.318533
1415	37	2025-12-16	2025-12-16 09:52:20.698474	2025-12-16 17:08:59.936436	present	2026-03-02 15:43:44.318533
1416	43	2025-12-16	2025-12-16 09:19:49.655529	2025-12-16 17:40:36.377756	present	2026-03-02 15:43:44.318533
1417	45	2025-12-16	2025-12-16 09:45:07.802586	2025-12-16 17:58:35.381825	present	2026-03-02 15:43:44.318533
1418	46	2025-12-16	2025-12-16 09:17:46.930786	2025-12-16 17:24:45.8179	present	2026-03-02 15:43:44.318533
1419	47	2025-12-16	2025-12-16 09:48:49.901231	2025-12-16 17:58:16.927705	present	2026-03-02 15:43:44.318533
1420	48	2025-12-16	2025-12-16 09:59:45.217799	2025-12-16 17:30:26.090548	present	2026-03-02 15:43:44.318533
1421	50	2025-12-16	2025-12-16 09:08:42.262437	2025-12-16 17:13:38.020624	present	2026-03-02 15:43:44.318533
1422	52	2025-12-16	2025-12-16 09:37:18.261749	2025-12-16 17:46:34.43333	present	2026-03-02 15:43:44.318533
1423	59	2025-12-16	2025-12-16 09:33:55.602279	2025-12-16 17:00:47.694623	present	2026-03-02 15:43:44.318533
1424	60	2025-12-16	2025-12-16 09:02:05.392676	2025-12-16 17:11:24.51216	present	2026-03-02 15:43:44.318533
1425	62	2025-12-16	2025-12-16 09:02:10.548757	2025-12-16 17:00:50.549021	present	2026-03-02 15:43:44.318533
1426	63	2025-12-16	2025-12-16 09:25:51.15711	2025-12-16 17:15:42.705733	present	2026-03-02 15:43:44.318533
1427	64	2025-12-16	2025-12-16 09:25:15.034263	2025-12-16 17:17:39.172912	present	2026-03-02 15:43:44.318533
1428	65	2025-12-16	2025-12-16 09:57:59.592834	2025-12-16 17:54:38.806574	present	2026-03-02 15:43:44.318533
1429	66	2025-12-16	2025-12-16 09:45:26.202622	2025-12-16 17:24:39.602183	present	2026-03-02 15:43:44.318533
1430	70	2025-12-16	2025-12-16 09:12:02.503369	2025-12-16 17:34:27.89019	present	2026-03-02 15:43:44.318533
1431	71	2025-12-16	2025-12-16 09:49:48.715433	2025-12-16 17:18:16.661096	present	2026-03-02 15:43:44.318533
1432	73	2025-12-16	2025-12-16 09:45:09.545339	2025-12-16 17:29:24.59095	present	2026-03-02 15:43:44.318533
1433	74	2025-12-16	2025-12-16 09:33:01.002028	2025-12-16 17:44:55.145844	present	2026-03-02 15:43:44.318533
1434	78	2025-12-16	2025-12-16 09:26:44.725842	2025-12-16 17:59:56.717572	present	2026-03-02 15:43:44.318533
1435	79	2025-12-16	2025-12-16 09:06:41.211648	2025-12-16 17:50:21.908448	present	2026-03-02 15:43:44.318533
1436	82	2025-12-16	2025-12-16 09:01:06.747355	2025-12-16 17:19:04.901377	present	2026-03-02 15:43:44.318533
1437	83	2025-12-16	2025-12-16 09:21:41.528643	2025-12-16 17:13:50.036461	present	2026-03-02 15:43:44.318533
1438	84	2025-12-16	2025-12-16 09:11:54.66351	2025-12-16 17:20:58.864155	present	2026-03-02 15:43:44.318533
1439	85	2025-12-16	2025-12-16 09:55:15.842352	2025-12-16 17:23:28.180533	present	2026-03-02 15:43:44.318533
1440	88	2025-12-16	2025-12-16 09:27:37.999339	2025-12-16 17:20:54.21355	present	2026-03-02 15:43:44.318533
1441	89	2025-12-16	2025-12-16 09:01:42.111446	2025-12-16 17:53:46.926543	present	2026-03-02 15:43:44.318533
1442	96	2025-12-16	2025-12-16 09:53:42.934107	2025-12-16 17:33:53.020069	present	2026-03-02 15:43:44.318533
1443	97	2025-12-16	2025-12-16 09:36:07.67057	2025-12-16 17:40:58.25758	present	2026-03-02 15:43:44.318533
1444	1	2025-12-16	2025-12-16 09:37:56.633785	2025-12-16 17:11:24.076548	present	2026-03-02 15:43:44.318533
1445	2	2025-12-16	2025-12-16 09:44:31.391761	2025-12-16 17:15:36.748611	present	2026-03-02 15:43:44.318533
1446	7	2025-12-16	2025-12-16 09:00:59.552057	2025-12-16 17:09:06.437673	present	2026-03-02 15:43:44.318533
1447	8	2025-12-16	2025-12-16 09:26:26.986838	2025-12-16 17:04:43.389108	present	2026-03-02 15:43:44.318533
1448	9	2025-12-16	2025-12-16 09:02:12.76775	2025-12-16 17:18:05.886903	present	2026-03-02 15:43:44.318533
1449	12	2025-12-16	2025-12-16 09:50:35.70407	2025-12-16 17:02:33.148921	present	2026-03-02 15:43:44.318533
1450	13	2025-12-16	2025-12-16 09:09:37.188863	2025-12-16 17:41:39.769225	present	2026-03-02 15:43:44.318533
1451	14	2025-12-16	2025-12-16 09:40:06.316525	2025-12-16 17:04:37.932324	present	2026-03-02 15:43:44.318533
1452	15	2025-12-16	2025-12-16 09:50:27.833634	2025-12-16 17:21:59.962566	present	2026-03-02 15:43:44.318533
1453	16	2025-12-16	2025-12-16 09:36:45.706243	2025-12-16 17:37:51.591837	present	2026-03-02 15:43:44.318533
1454	17	2025-12-16	2025-12-16 09:45:59.335014	2025-12-16 17:31:04.331789	present	2026-03-02 15:43:44.318533
1455	18	2025-12-16	2025-12-16 09:06:57.748936	2025-12-16 17:09:08.349187	present	2026-03-02 15:43:44.318533
1456	19	2025-12-16	2025-12-16 09:20:20.194276	2025-12-16 17:42:34.165579	present	2026-03-02 15:43:44.318533
1457	20	2025-12-16	2025-12-16 09:42:55.884477	2025-12-16 17:07:13.507905	present	2026-03-02 15:43:44.318533
1458	21	2025-12-16	2025-12-16 09:05:54.656699	2025-12-16 17:51:29.495854	present	2026-03-02 15:43:44.318533
1459	22	2025-12-16	2025-12-16 09:50:17.381708	2025-12-16 17:45:11.441556	present	2026-03-02 15:43:44.318533
1460	23	2025-12-16	2025-12-16 09:14:24.302887	2025-12-16 17:27:35.031693	present	2026-03-02 15:43:44.318533
1461	24	2025-12-16	2025-12-16 09:11:17.660488	2025-12-16 17:14:04.662533	present	2026-03-02 15:43:44.318533
1462	25	2025-12-16	2025-12-16 09:16:24.673396	2025-12-16 17:29:10.603054	present	2026-03-02 15:43:44.318533
1463	26	2025-12-16	2025-12-16 09:23:24.642915	2025-12-16 17:08:05.553522	present	2026-03-02 15:43:44.318533
1464	28	2025-12-16	2025-12-16 09:23:08.81775	2025-12-16 17:12:39.666601	present	2026-03-02 15:43:44.318533
1465	29	2025-12-16	2025-12-16 09:44:05.927841	2025-12-16 17:21:06.233264	present	2026-03-02 15:43:44.318533
1466	30	2025-12-16	2025-12-16 09:04:25.070714	2025-12-16 17:38:40.089924	present	2026-03-02 15:43:44.318533
1467	31	2025-12-16	2025-12-16 09:35:12.447479	2025-12-16 17:48:22.171448	present	2026-03-02 15:43:44.318533
1468	32	2025-12-16	2025-12-16 09:46:30.60254	2025-12-16 17:42:27.800018	present	2026-03-02 15:43:44.318533
1469	34	2025-12-16	2025-12-16 09:00:12.993301	2025-12-16 17:13:44.75698	present	2026-03-02 15:43:44.318533
1470	36	2025-12-16	2025-12-16 09:55:09.002586	2025-12-16 17:21:05.353064	present	2026-03-02 15:43:44.318533
1471	38	2025-12-16	2025-12-16 09:32:27.904311	2025-12-16 17:23:57.902536	present	2026-03-02 15:43:44.318533
1472	39	2025-12-16	2025-12-16 09:59:30.67544	2025-12-16 17:48:07.412409	present	2026-03-02 15:43:44.318533
1473	40	2025-12-16	2025-12-16 09:45:48.686055	2025-12-16 17:58:15.425645	present	2026-03-02 15:43:44.318533
1474	41	2025-12-16	2025-12-16 09:47:48.044343	2025-12-16 17:15:16.455099	present	2026-03-02 15:43:44.318533
1475	42	2025-12-16	2025-12-16 09:40:14.893293	2025-12-16 17:02:49.935604	present	2026-03-02 15:43:44.318533
1476	44	2025-12-16	2025-12-16 09:39:36.203709	2025-12-16 17:23:59.089894	present	2026-03-02 15:43:44.318533
1477	49	2025-12-16	2025-12-16 09:10:50.945607	2025-12-16 17:04:23.401058	present	2026-03-02 15:43:44.318533
1478	51	2025-12-16	2025-12-16 09:06:50.617482	2025-12-16 17:27:06.187666	present	2026-03-02 15:43:44.318533
1479	53	2025-12-16	2025-12-16 09:20:33.957103	2025-12-16 17:40:47.534495	present	2026-03-02 15:43:44.318533
1480	54	2025-12-16	2025-12-16 09:04:04.869574	2025-12-16 17:35:48.908517	present	2026-03-02 15:43:44.318533
1481	55	2025-12-16	2025-12-16 09:08:41.338601	2025-12-16 17:35:43.784782	present	2026-03-02 15:43:44.318533
1482	56	2025-12-16	2025-12-16 09:23:21.82802	2025-12-16 17:32:15.290154	present	2026-03-02 15:43:44.318533
1483	57	2025-12-16	2025-12-16 09:18:39.346982	2025-12-16 17:21:35.26717	present	2026-03-02 15:43:44.318533
1484	58	2025-12-16	2025-12-16 09:06:06.097038	2025-12-16 17:34:25.670007	present	2026-03-02 15:43:44.318533
1485	61	2025-12-16	2025-12-16 09:26:16.882096	2025-12-16 17:24:37.658667	present	2026-03-02 15:43:44.318533
1486	67	2025-12-16	2025-12-16 09:54:10.356184	2025-12-16 17:59:34.317496	present	2026-03-02 15:43:44.318533
1487	68	2025-12-16	2025-12-16 09:21:45.279419	2025-12-16 17:56:42.138937	present	2026-03-02 15:43:44.318533
1488	69	2025-12-16	2025-12-16 09:32:37.401814	2025-12-16 17:17:07.799029	present	2026-03-02 15:43:44.318533
1489	72	2025-12-16	2025-12-16 09:05:53.103407	2025-12-16 17:18:13.506668	present	2026-03-02 15:43:44.318533
1490	75	2025-12-16	2025-12-16 09:58:36.071697	2025-12-16 17:13:55.169676	present	2026-03-02 15:43:44.318533
1491	76	2025-12-16	2025-12-16 09:06:57.618519	2025-12-16 17:43:35.552697	present	2026-03-02 15:43:44.318533
1492	77	2025-12-16	2025-12-16 09:38:14.003434	2025-12-16 17:20:07.645026	present	2026-03-02 15:43:44.318533
1493	80	2025-12-16	2025-12-16 09:31:22.863751	2025-12-16 17:21:49.633079	present	2026-03-02 15:43:44.318533
1494	81	2025-12-16	2025-12-16 09:11:25.038005	2025-12-16 17:45:48.719731	present	2026-03-02 15:43:44.318533
1495	86	2025-12-16	2025-12-16 09:30:11.867351	2025-12-16 17:20:30.437518	present	2026-03-02 15:43:44.318533
1496	87	2025-12-16	2025-12-16 09:19:11.586432	2025-12-16 17:49:01.044517	present	2026-03-02 15:43:44.318533
1497	90	2025-12-16	2025-12-16 09:48:31.485679	2025-12-16 17:12:55.583238	present	2026-03-02 15:43:44.318533
1498	91	2025-12-16	2025-12-16 09:13:44.071442	2025-12-16 17:26:39.281332	present	2026-03-02 15:43:44.318533
1499	92	2025-12-16	2025-12-16 09:44:56.460889	2025-12-16 17:16:39.337669	present	2026-03-02 15:43:44.318533
1500	93	2025-12-16	2025-12-16 09:23:23.340515	2025-12-16 17:00:51.799858	present	2026-03-02 15:43:44.318533
1501	94	2025-12-16	2025-12-16 09:07:03.595747	2025-12-16 17:12:39.210893	present	2026-03-02 15:43:44.318533
1502	95	2025-12-16	2025-12-16 09:02:03.074838	2025-12-16 17:16:40.363654	present	2026-03-02 15:43:44.318533
1503	98	2025-12-16	2025-12-16 09:13:33.7271	2025-12-16 17:01:57.022129	present	2026-03-02 15:43:44.318533
1504	99	2025-12-16	2025-12-16 09:16:43.376245	2025-12-16 17:59:36.446372	present	2026-03-02 15:43:44.318533
1505	100	2025-12-16	2025-12-16 09:13:06.101418	2025-12-16 17:06:09.730117	present	2026-03-02 15:43:44.318533
1506	3	2025-12-17	2025-12-17 09:45:04.216914	2025-12-17 17:53:28.767837	present	2026-03-02 15:43:44.318533
1507	4	2025-12-17	2025-12-17 09:33:21.330651	2025-12-17 17:31:12.825765	present	2026-03-02 15:43:44.318533
1508	5	2025-12-17	2025-12-17 09:45:19.993969	2025-12-17 17:39:59.897016	present	2026-03-02 15:43:44.318533
1509	6	2025-12-17	2025-12-17 09:37:04.86818	2025-12-17 17:43:30.382786	present	2026-03-02 15:43:44.318533
1510	10	2025-12-17	2025-12-17 09:33:00.151893	2025-12-17 17:47:21.763929	present	2026-03-02 15:43:44.318533
1511	11	2025-12-17	2025-12-17 09:51:59.93142	2025-12-17 17:08:14.060796	present	2026-03-02 15:43:44.318533
1512	27	2025-12-17	2025-12-17 09:31:25.60479	2025-12-17 17:22:35.377663	present	2026-03-02 15:43:44.318533
1513	33	2025-12-17	2025-12-17 09:53:38.469705	2025-12-17 17:01:22.753461	present	2026-03-02 15:43:44.318533
1514	35	2025-12-17	2025-12-17 09:20:14.86332	2025-12-17 17:12:28.632632	present	2026-03-02 15:43:44.318533
1515	37	2025-12-17	2025-12-17 09:54:10.56683	2025-12-17 17:33:29.390789	present	2026-03-02 15:43:44.318533
1516	43	2025-12-17	2025-12-17 09:21:48.83787	2025-12-17 17:24:16.363228	present	2026-03-02 15:43:44.318533
1517	45	2025-12-17	2025-12-17 09:50:56.92355	2025-12-17 17:03:06.70405	present	2026-03-02 15:43:44.318533
1518	46	2025-12-17	2025-12-17 09:32:20.039031	2025-12-17 17:53:45.728477	present	2026-03-02 15:43:44.318533
1519	47	2025-12-17	2025-12-17 09:15:03.294409	2025-12-17 17:23:07.36054	present	2026-03-02 15:43:44.318533
1520	48	2025-12-17	2025-12-17 09:52:02.658048	2025-12-17 17:10:24.252482	present	2026-03-02 15:43:44.318533
1521	50	2025-12-17	2025-12-17 09:23:46.238238	2025-12-17 17:12:43.146307	present	2026-03-02 15:43:44.318533
1522	52	2025-12-17	2025-12-17 09:20:28.200492	2025-12-17 17:36:39.427348	present	2026-03-02 15:43:44.318533
1523	59	2025-12-17	2025-12-17 09:33:45.875418	2025-12-17 17:19:23.121906	present	2026-03-02 15:43:44.318533
1524	60	2025-12-17	2025-12-17 09:55:31.071907	2025-12-17 17:55:58.858183	present	2026-03-02 15:43:44.318533
1525	62	2025-12-17	2025-12-17 09:32:34.970795	2025-12-17 17:59:37.318973	present	2026-03-02 15:43:44.318533
1526	63	2025-12-17	2025-12-17 09:18:16.247352	2025-12-17 17:49:52.313735	present	2026-03-02 15:43:44.318533
1527	64	2025-12-17	2025-12-17 09:53:40.869695	2025-12-17 17:53:34.195044	present	2026-03-02 15:43:44.318533
1528	65	2025-12-17	2025-12-17 09:17:44.431926	2025-12-17 17:04:57.39749	present	2026-03-02 15:43:44.318533
1529	66	2025-12-17	2025-12-17 09:09:20.57964	2025-12-17 17:58:59.168408	present	2026-03-02 15:43:44.318533
1530	70	2025-12-17	2025-12-17 09:28:49.725672	2025-12-17 17:06:41.702792	present	2026-03-02 15:43:44.318533
1531	71	2025-12-17	2025-12-17 09:36:08.612828	2025-12-17 17:55:53.837551	present	2026-03-02 15:43:44.318533
1532	73	2025-12-17	2025-12-17 09:12:51.762977	2025-12-17 17:24:38.164548	present	2026-03-02 15:43:44.318533
1533	74	2025-12-17	2025-12-17 09:09:04.494747	2025-12-17 17:35:21.715995	present	2026-03-02 15:43:44.318533
1534	78	2025-12-17	2025-12-17 09:52:08.427389	2025-12-17 17:13:48.477963	present	2026-03-02 15:43:44.318533
1535	79	2025-12-17	2025-12-17 09:02:49.254933	2025-12-17 17:30:45.409502	present	2026-03-02 15:43:44.318533
1536	82	2025-12-17	2025-12-17 09:17:20.935652	2025-12-17 17:05:22.8086	present	2026-03-02 15:43:44.318533
1537	83	2025-12-17	2025-12-17 09:17:20.649033	2025-12-17 17:07:24.093891	present	2026-03-02 15:43:44.318533
1538	84	2025-12-17	2025-12-17 09:17:01.852524	2025-12-17 17:13:43.396189	present	2026-03-02 15:43:44.318533
1539	85	2025-12-17	2025-12-17 09:59:30.196037	2025-12-17 17:20:26.187926	present	2026-03-02 15:43:44.318533
1540	88	2025-12-17	2025-12-17 09:26:33.159301	2025-12-17 17:02:20.974354	present	2026-03-02 15:43:44.318533
1541	89	2025-12-17	2025-12-17 09:04:01.725952	2025-12-17 17:14:48.448464	present	2026-03-02 15:43:44.318533
1542	96	2025-12-17	2025-12-17 09:15:03.965922	2025-12-17 17:08:29.841315	present	2026-03-02 15:43:44.318533
1543	97	2025-12-17	2025-12-17 09:19:51.771437	2025-12-17 17:17:39.601176	present	2026-03-02 15:43:44.318533
1544	1	2025-12-17	2025-12-17 09:17:49.003723	2025-12-17 17:01:11.31446	present	2026-03-02 15:43:44.318533
1545	2	2025-12-17	2025-12-17 09:23:32.050706	2025-12-17 17:35:01.633388	present	2026-03-02 15:43:44.318533
1546	7	2025-12-17	2025-12-17 09:46:13.23989	2025-12-17 17:40:15.089461	present	2026-03-02 15:43:44.318533
1547	8	2025-12-17	2025-12-17 09:05:18.666234	2025-12-17 17:19:50.532694	present	2026-03-02 15:43:44.318533
1548	9	2025-12-17	2025-12-17 09:53:38.518598	2025-12-17 17:51:44.992904	present	2026-03-02 15:43:44.318533
1549	12	2025-12-17	2025-12-17 09:28:29.028966	2025-12-17 17:03:59.198788	present	2026-03-02 15:43:44.318533
1550	13	2025-12-17	2025-12-17 09:25:20.493685	2025-12-17 17:15:59.519092	present	2026-03-02 15:43:44.318533
1551	14	2025-12-17	2025-12-17 09:48:53.852292	2025-12-17 17:35:14.673691	present	2026-03-02 15:43:44.318533
1552	15	2025-12-17	2025-12-17 09:56:02.580649	2025-12-17 17:27:29.135838	present	2026-03-02 15:43:44.318533
1553	16	2025-12-17	2025-12-17 09:43:32.329012	2025-12-17 17:02:15.908005	present	2026-03-02 15:43:44.318533
1554	17	2025-12-17	2025-12-17 09:25:36.393401	2025-12-17 17:24:53.3056	present	2026-03-02 15:43:44.318533
1555	18	2025-12-17	2025-12-17 09:05:02.420065	2025-12-17 17:48:26.579426	present	2026-03-02 15:43:44.318533
1556	19	2025-12-17	2025-12-17 09:19:37.5162	2025-12-17 17:22:02.359896	present	2026-03-02 15:43:44.318533
1557	20	2025-12-17	2025-12-17 09:17:26.919114	2025-12-17 17:25:19.047847	present	2026-03-02 15:43:44.318533
1558	21	2025-12-17	2025-12-17 09:44:12.245023	2025-12-17 17:53:50.466177	present	2026-03-02 15:43:44.318533
1559	22	2025-12-17	2025-12-17 09:50:00.383947	2025-12-17 17:02:15.089387	present	2026-03-02 15:43:44.318533
1560	23	2025-12-17	2025-12-17 09:57:02.771244	2025-12-17 17:01:53.915508	present	2026-03-02 15:43:44.318533
1561	24	2025-12-17	2025-12-17 09:57:23.184299	2025-12-17 17:23:09.155881	present	2026-03-02 15:43:44.318533
1562	25	2025-12-17	2025-12-17 09:01:50.532199	2025-12-17 17:29:57.358255	present	2026-03-02 15:43:44.318533
1563	26	2025-12-17	2025-12-17 09:55:09.767685	2025-12-17 17:48:07.187513	present	2026-03-02 15:43:44.318533
1564	28	2025-12-17	2025-12-17 09:09:57.344443	2025-12-17 17:58:47.14763	present	2026-03-02 15:43:44.318533
1565	29	2025-12-17	2025-12-17 09:20:33.066653	2025-12-17 17:29:17.355734	present	2026-03-02 15:43:44.318533
1566	30	2025-12-17	2025-12-17 09:29:01.121854	2025-12-17 17:57:21.693611	present	2026-03-02 15:43:44.318533
1567	31	2025-12-17	2025-12-17 09:27:03.679091	2025-12-17 17:37:11.668825	present	2026-03-02 15:43:44.318533
1568	32	2025-12-17	2025-12-17 09:40:35.561685	2025-12-17 17:04:54.527573	present	2026-03-02 15:43:44.318533
1569	34	2025-12-17	2025-12-17 09:52:58.9108	2025-12-17 17:36:46.917241	present	2026-03-02 15:43:44.318533
1570	36	2025-12-17	2025-12-17 09:14:32.440003	2025-12-17 17:55:39.135065	present	2026-03-02 15:43:44.318533
1571	38	2025-12-17	2025-12-17 09:11:11.300773	2025-12-17 17:59:20.731762	present	2026-03-02 15:43:44.318533
1572	39	2025-12-17	2025-12-17 09:59:52.087049	2025-12-17 17:35:55.460516	present	2026-03-02 15:43:44.318533
1573	40	2025-12-17	2025-12-17 09:07:02.106643	2025-12-17 17:02:05.112899	present	2026-03-02 15:43:44.318533
1574	41	2025-12-17	2025-12-17 09:25:21.364376	2025-12-17 17:13:38.088854	present	2026-03-02 15:43:44.318533
1575	42	2025-12-17	2025-12-17 09:53:00.023298	2025-12-17 17:11:57.429149	present	2026-03-02 15:43:44.318533
1576	44	2025-12-17	2025-12-17 09:32:52.560774	2025-12-17 17:19:59.976931	present	2026-03-02 15:43:44.318533
1577	49	2025-12-17	2025-12-17 09:47:58.767108	2025-12-17 17:48:02.334154	present	2026-03-02 15:43:44.318533
1578	51	2025-12-17	2025-12-17 09:29:46.78777	2025-12-17 17:40:52.300251	present	2026-03-02 15:43:44.318533
1579	53	2025-12-17	2025-12-17 09:11:04.285407	2025-12-17 17:04:47.055794	present	2026-03-02 15:43:44.318533
1580	54	2025-12-17	2025-12-17 09:37:08.396976	2025-12-17 17:47:45.297362	present	2026-03-02 15:43:44.318533
1581	55	2025-12-17	2025-12-17 09:48:17.964059	2025-12-17 17:16:57.132231	present	2026-03-02 15:43:44.318533
1582	56	2025-12-17	2025-12-17 09:29:11.212996	2025-12-17 17:04:39.922507	present	2026-03-02 15:43:44.318533
1583	57	2025-12-17	2025-12-17 09:31:39.600972	2025-12-17 17:34:38.935132	present	2026-03-02 15:43:44.318533
1584	58	2025-12-17	2025-12-17 09:30:33.212706	2025-12-17 17:35:47.152457	present	2026-03-02 15:43:44.318533
1585	61	2025-12-17	2025-12-17 09:27:44.03883	2025-12-17 17:15:52.268247	present	2026-03-02 15:43:44.318533
1586	67	2025-12-17	2025-12-17 09:31:43.881052	2025-12-17 17:04:28.9546	present	2026-03-02 15:43:44.318533
1587	68	2025-12-17	2025-12-17 09:31:32.626485	2025-12-17 17:24:09.997828	present	2026-03-02 15:43:44.318533
1588	69	2025-12-17	2025-12-17 09:46:51.390543	2025-12-17 17:16:26.772974	present	2026-03-02 15:43:44.318533
1589	72	2025-12-17	2025-12-17 09:14:43.309482	2025-12-17 17:35:12.681706	present	2026-03-02 15:43:44.318533
1590	75	2025-12-17	2025-12-17 09:01:12.25593	2025-12-17 17:04:12.842222	present	2026-03-02 15:43:44.318533
1591	76	2025-12-17	2025-12-17 09:04:45.68687	2025-12-17 17:20:49.700854	present	2026-03-02 15:43:44.318533
1592	77	2025-12-17	2025-12-17 09:52:25.960195	2025-12-17 17:29:59.75724	present	2026-03-02 15:43:44.318533
1593	80	2025-12-17	2025-12-17 09:33:58.676653	2025-12-17 17:43:47.113412	present	2026-03-02 15:43:44.318533
1594	81	2025-12-17	2025-12-17 09:44:41.887765	2025-12-17 17:40:28.377886	present	2026-03-02 15:43:44.318533
1595	86	2025-12-17	2025-12-17 09:43:53.102808	2025-12-17 17:42:54.302452	present	2026-03-02 15:43:44.318533
1596	87	2025-12-17	2025-12-17 09:03:09.869808	2025-12-17 17:07:59.656477	present	2026-03-02 15:43:44.318533
1597	90	2025-12-17	2025-12-17 09:53:53.807726	2025-12-17 17:44:05.454294	present	2026-03-02 15:43:44.318533
1598	91	2025-12-17	2025-12-17 09:26:03.735727	2025-12-17 17:35:58.666489	present	2026-03-02 15:43:44.318533
1599	92	2025-12-17	2025-12-17 09:11:48.838285	2025-12-17 17:19:30.000246	present	2026-03-02 15:43:44.318533
1600	93	2025-12-17	2025-12-17 09:27:52.997337	2025-12-17 17:29:10.763235	present	2026-03-02 15:43:44.318533
1601	94	2025-12-17	2025-12-17 09:41:27.044762	2025-12-17 17:03:36.863923	present	2026-03-02 15:43:44.318533
1602	95	2025-12-17	2025-12-17 09:35:57.876899	2025-12-17 17:27:59.529719	present	2026-03-02 15:43:44.318533
1603	98	2025-12-17	2025-12-17 09:53:47.96994	2025-12-17 17:13:33.675285	present	2026-03-02 15:43:44.318533
1604	99	2025-12-17	2025-12-17 09:02:44.485862	2025-12-17 17:17:11.250601	present	2026-03-02 15:43:44.318533
1605	100	2025-12-17	2025-12-17 09:44:17.174705	2025-12-17 17:00:21.354637	present	2026-03-02 15:43:44.318533
1606	3	2025-12-18	2025-12-18 09:57:18.511484	2025-12-18 17:43:09.949005	present	2026-03-02 15:43:44.318533
1607	4	2025-12-18	2025-12-18 09:37:08.557301	2025-12-18 17:32:55.246435	present	2026-03-02 15:43:44.318533
1608	5	2025-12-18	2025-12-18 09:07:46.371532	2025-12-18 17:57:16.100143	present	2026-03-02 15:43:44.318533
1609	6	2025-12-18	2025-12-18 09:33:51.792572	2025-12-18 17:08:01.211089	present	2026-03-02 15:43:44.318533
1610	10	2025-12-18	2025-12-18 09:29:06.503255	2025-12-18 17:24:32.149254	present	2026-03-02 15:43:44.318533
1611	11	2025-12-18	2025-12-18 09:40:39.02941	2025-12-18 17:48:35.202489	present	2026-03-02 15:43:44.318533
1612	27	2025-12-18	2025-12-18 09:41:30.573923	2025-12-18 17:52:20.689127	present	2026-03-02 15:43:44.318533
1613	33	2025-12-18	2025-12-18 09:10:28.960128	2025-12-18 17:43:31.62452	present	2026-03-02 15:43:44.318533
1614	35	2025-12-18	2025-12-18 09:37:46.555369	2025-12-18 17:49:25.447954	present	2026-03-02 15:43:44.318533
1615	37	2025-12-18	2025-12-18 09:25:45.85952	2025-12-18 17:47:48.064482	present	2026-03-02 15:43:44.318533
1616	43	2025-12-18	2025-12-18 09:31:05.843985	2025-12-18 17:15:16.490326	present	2026-03-02 15:43:44.318533
1617	45	2025-12-18	2025-12-18 09:37:45.734515	2025-12-18 17:51:44.255094	present	2026-03-02 15:43:44.318533
1618	46	2025-12-18	2025-12-18 09:27:48.646912	2025-12-18 17:23:16.426662	present	2026-03-02 15:43:44.318533
1619	47	2025-12-18	2025-12-18 09:38:16.825876	2025-12-18 17:24:29.080831	present	2026-03-02 15:43:44.318533
1620	48	2025-12-18	2025-12-18 09:40:23.357994	2025-12-18 17:50:52.763331	present	2026-03-02 15:43:44.318533
1621	50	2025-12-18	2025-12-18 09:47:32.26726	2025-12-18 17:24:38.666762	present	2026-03-02 15:43:44.318533
1622	52	2025-12-18	2025-12-18 09:48:37.205672	2025-12-18 17:26:44.257316	present	2026-03-02 15:43:44.318533
1623	59	2025-12-18	2025-12-18 09:54:40.983187	2025-12-18 17:25:56.77606	present	2026-03-02 15:43:44.318533
1624	60	2025-12-18	2025-12-18 09:15:04.235501	2025-12-18 17:10:24.297881	present	2026-03-02 15:43:44.318533
1625	62	2025-12-18	2025-12-18 09:38:44.778079	2025-12-18 17:24:00.618123	present	2026-03-02 15:43:44.318533
1626	63	2025-12-18	2025-12-18 09:46:20.020987	2025-12-18 17:41:17.907867	present	2026-03-02 15:43:44.318533
1627	64	2025-12-18	2025-12-18 09:03:08.373918	2025-12-18 17:45:01.240478	present	2026-03-02 15:43:44.318533
1628	65	2025-12-18	2025-12-18 09:31:30.530778	2025-12-18 17:42:18.332032	present	2026-03-02 15:43:44.318533
1629	66	2025-12-18	2025-12-18 09:06:12.52204	2025-12-18 17:14:24.247491	present	2026-03-02 15:43:44.318533
1630	70	2025-12-18	2025-12-18 09:46:51.24202	2025-12-18 17:37:43.534265	present	2026-03-02 15:43:44.318533
1631	71	2025-12-18	2025-12-18 09:05:42.935138	2025-12-18 17:02:52.040015	present	2026-03-02 15:43:44.318533
1632	73	2025-12-18	2025-12-18 09:43:36.598858	2025-12-18 17:24:27.738702	present	2026-03-02 15:43:44.318533
1633	74	2025-12-18	2025-12-18 09:14:49.552377	2025-12-18 17:56:23.812306	present	2026-03-02 15:43:44.318533
1634	78	2025-12-18	2025-12-18 09:18:51.719189	2025-12-18 17:10:24.768912	present	2026-03-02 15:43:44.318533
1635	79	2025-12-18	2025-12-18 09:48:38.344651	2025-12-18 17:26:39.499246	present	2026-03-02 15:43:44.318533
1636	82	2025-12-18	2025-12-18 09:48:33.928159	2025-12-18 17:47:09.884805	present	2026-03-02 15:43:44.318533
1637	83	2025-12-18	2025-12-18 09:53:52.716336	2025-12-18 17:04:45.675881	present	2026-03-02 15:43:44.318533
1638	84	2025-12-18	2025-12-18 09:43:17.927947	2025-12-18 17:00:21.527562	present	2026-03-02 15:43:44.318533
1639	85	2025-12-18	2025-12-18 09:36:30.207235	2025-12-18 17:24:21.509766	present	2026-03-02 15:43:44.318533
1640	88	2025-12-18	2025-12-18 09:31:23.578428	2025-12-18 17:36:13.008738	present	2026-03-02 15:43:44.318533
1641	89	2025-12-18	2025-12-18 09:54:46.125768	2025-12-18 17:05:24.522441	present	2026-03-02 15:43:44.318533
1642	96	2025-12-18	2025-12-18 09:13:16.828234	2025-12-18 17:01:09.841163	present	2026-03-02 15:43:44.318533
1643	97	2025-12-18	2025-12-18 09:28:27.604034	2025-12-18 17:02:49.942634	present	2026-03-02 15:43:44.318533
1644	1	2025-12-18	2025-12-18 09:17:10.381116	2025-12-18 17:59:44.175729	present	2026-03-02 15:43:44.318533
1645	2	2025-12-18	2025-12-18 09:21:27.311889	2025-12-18 17:53:28.505123	present	2026-03-02 15:43:44.318533
1646	7	2025-12-18	2025-12-18 09:56:32.510991	2025-12-18 17:17:55.461472	present	2026-03-02 15:43:44.318533
1647	8	2025-12-18	2025-12-18 09:19:36.1168	2025-12-18 17:15:04.039096	present	2026-03-02 15:43:44.318533
1648	9	2025-12-18	2025-12-18 09:23:19.977026	2025-12-18 17:43:04.357798	present	2026-03-02 15:43:44.318533
1649	12	2025-12-18	2025-12-18 09:39:29.428027	2025-12-18 17:15:42.68281	present	2026-03-02 15:43:44.318533
1650	13	2025-12-18	2025-12-18 09:05:26.938185	2025-12-18 17:55:28.361769	present	2026-03-02 15:43:44.318533
1651	14	2025-12-18	2025-12-18 09:17:41.867009	2025-12-18 17:22:17.625828	present	2026-03-02 15:43:44.318533
1652	15	2025-12-18	2025-12-18 09:12:34.9691	2025-12-18 17:57:19.984752	present	2026-03-02 15:43:44.318533
1653	16	2025-12-18	2025-12-18 09:59:18.625043	2025-12-18 17:43:48.529476	present	2026-03-02 15:43:44.318533
1654	17	2025-12-18	2025-12-18 09:44:16.917828	2025-12-18 17:44:29.903987	present	2026-03-02 15:43:44.318533
1655	18	2025-12-18	2025-12-18 09:52:11.806406	2025-12-18 17:28:33.431588	present	2026-03-02 15:43:44.318533
1656	19	2025-12-18	2025-12-18 09:21:29.086033	2025-12-18 17:44:57.959619	present	2026-03-02 15:43:44.318533
1657	20	2025-12-18	2025-12-18 09:44:38.667351	2025-12-18 17:53:50.969832	present	2026-03-02 15:43:44.318533
1658	21	2025-12-18	2025-12-18 09:17:43.765428	2025-12-18 17:07:05.878309	present	2026-03-02 15:43:44.318533
1659	22	2025-12-18	2025-12-18 09:29:29.093751	2025-12-18 17:59:36.898604	present	2026-03-02 15:43:44.318533
1660	23	2025-12-18	2025-12-18 09:03:56.12979	2025-12-18 17:07:59.854268	present	2026-03-02 15:43:44.318533
1661	24	2025-12-18	2025-12-18 09:58:39.004123	2025-12-18 17:25:58.045701	present	2026-03-02 15:43:44.318533
1662	25	2025-12-18	2025-12-18 09:32:39.402067	2025-12-18 17:39:04.942855	present	2026-03-02 15:43:44.318533
1663	26	2025-12-18	2025-12-18 09:26:19.880065	2025-12-18 17:43:08.735997	present	2026-03-02 15:43:44.318533
1664	28	2025-12-18	2025-12-18 09:21:24.789665	2025-12-18 17:37:42.869785	present	2026-03-02 15:43:44.318533
1665	29	2025-12-18	2025-12-18 09:08:32.81647	2025-12-18 17:50:56.404959	present	2026-03-02 15:43:44.318533
1666	30	2025-12-18	2025-12-18 09:59:52.704272	2025-12-18 17:48:25.280986	present	2026-03-02 15:43:44.318533
1667	31	2025-12-18	2025-12-18 09:51:59.809604	2025-12-18 17:39:39.981078	present	2026-03-02 15:43:44.318533
1668	32	2025-12-18	2025-12-18 09:24:16.378482	2025-12-18 17:06:37.299654	present	2026-03-02 15:43:44.318533
1669	34	2025-12-18	2025-12-18 09:28:47.378194	2025-12-18 17:53:15.173293	present	2026-03-02 15:43:44.318533
1670	36	2025-12-18	2025-12-18 09:59:18.351148	2025-12-18 17:08:29.769644	present	2026-03-02 15:43:44.318533
1671	38	2025-12-18	2025-12-18 09:58:08.497695	2025-12-18 17:56:41.630441	present	2026-03-02 15:43:44.318533
1672	39	2025-12-18	2025-12-18 09:29:03.206131	2025-12-18 17:48:22.025081	present	2026-03-02 15:43:44.318533
1673	40	2025-12-18	2025-12-18 09:56:54.217672	2025-12-18 17:43:27.417424	present	2026-03-02 15:43:44.318533
1674	41	2025-12-18	2025-12-18 09:55:38.541772	2025-12-18 17:44:32.630968	present	2026-03-02 15:43:44.318533
1675	42	2025-12-18	2025-12-18 09:28:05.692005	2025-12-18 17:27:32.769828	present	2026-03-02 15:43:44.318533
1676	44	2025-12-18	2025-12-18 09:04:27.933345	2025-12-18 17:44:22.434224	present	2026-03-02 15:43:44.318533
1677	49	2025-12-18	2025-12-18 09:37:06.336954	2025-12-18 17:23:55.129843	present	2026-03-02 15:43:44.318533
1678	51	2025-12-18	2025-12-18 09:25:01.189221	2025-12-18 17:35:38.478471	present	2026-03-02 15:43:44.318533
1679	53	2025-12-18	2025-12-18 09:56:30.163445	2025-12-18 17:20:32.788775	present	2026-03-02 15:43:44.318533
1680	54	2025-12-18	2025-12-18 09:32:19.448793	2025-12-18 17:51:06.563437	present	2026-03-02 15:43:44.318533
1681	55	2025-12-18	2025-12-18 09:32:27.889175	2025-12-18 17:18:24.438846	present	2026-03-02 15:43:44.318533
1682	56	2025-12-18	2025-12-18 09:49:17.286811	2025-12-18 17:06:28.542009	present	2026-03-02 15:43:44.318533
1683	57	2025-12-18	2025-12-18 09:17:04.787122	2025-12-18 17:45:11.83437	present	2026-03-02 15:43:44.318533
1684	58	2025-12-18	2025-12-18 09:41:43.995919	2025-12-18 17:24:31.418098	present	2026-03-02 15:43:44.318533
1685	61	2025-12-18	2025-12-18 09:36:47.944361	2025-12-18 17:19:21.020272	present	2026-03-02 15:43:44.318533
1686	67	2025-12-18	2025-12-18 09:38:56.94679	2025-12-18 17:33:06.151286	present	2026-03-02 15:43:44.318533
1687	68	2025-12-18	2025-12-18 09:32:45.868121	2025-12-18 17:44:05.349927	present	2026-03-02 15:43:44.318533
1688	69	2025-12-18	2025-12-18 09:38:08.571684	2025-12-18 17:27:56.96064	present	2026-03-02 15:43:44.318533
1689	72	2025-12-18	2025-12-18 09:38:22.616899	2025-12-18 17:46:03.78464	present	2026-03-02 15:43:44.318533
1690	75	2025-12-18	2025-12-18 09:46:14.979446	2025-12-18 17:49:36.184206	present	2026-03-02 15:43:44.318533
1691	76	2025-12-18	2025-12-18 09:16:09.54016	2025-12-18 17:27:05.685657	present	2026-03-02 15:43:44.318533
1692	77	2025-12-18	2025-12-18 09:56:24.275848	2025-12-18 17:27:45.765953	present	2026-03-02 15:43:44.318533
1693	80	2025-12-18	2025-12-18 09:26:16.712245	2025-12-18 17:06:57.584878	present	2026-03-02 15:43:44.318533
1694	81	2025-12-18	2025-12-18 09:03:33.253324	2025-12-18 17:43:42.129568	present	2026-03-02 15:43:44.318533
1695	86	2025-12-18	2025-12-18 09:04:18.062974	2025-12-18 17:20:48.174765	present	2026-03-02 15:43:44.318533
1696	87	2025-12-18	2025-12-18 09:55:16.131154	2025-12-18 17:51:21.687426	present	2026-03-02 15:43:44.318533
1697	90	2025-12-18	2025-12-18 09:09:25.166488	2025-12-18 17:10:06.950402	present	2026-03-02 15:43:44.318533
1698	91	2025-12-18	2025-12-18 09:13:26.642559	2025-12-18 17:39:41.065001	present	2026-03-02 15:43:44.318533
1699	92	2025-12-18	2025-12-18 09:45:13.757469	2025-12-18 17:09:16.221251	present	2026-03-02 15:43:44.318533
1700	93	2025-12-18	2025-12-18 09:06:01.295907	2025-12-18 17:18:14.003461	present	2026-03-02 15:43:44.318533
1701	94	2025-12-18	2025-12-18 09:31:24.918358	2025-12-18 17:28:31.774848	present	2026-03-02 15:43:44.318533
1702	95	2025-12-18	2025-12-18 09:24:16.054867	2025-12-18 17:41:47.552143	present	2026-03-02 15:43:44.318533
1703	98	2025-12-18	2025-12-18 09:03:31.589376	2025-12-18 17:06:27.460355	present	2026-03-02 15:43:44.318533
1704	99	2025-12-18	2025-12-18 09:45:26.589162	2025-12-18 17:32:07.664248	present	2026-03-02 15:43:44.318533
1705	100	2025-12-18	2025-12-18 09:08:48.66419	2025-12-18 17:53:29.082575	present	2026-03-02 15:43:44.318533
1706	3	2025-12-19	2025-12-19 09:18:22.934658	2025-12-19 17:48:52.64969	present	2026-03-02 15:43:44.318533
1707	4	2025-12-19	2025-12-19 09:00:09.56159	2025-12-19 17:54:01.861159	present	2026-03-02 15:43:44.318533
1708	5	2025-12-19	2025-12-19 09:52:45.098497	2025-12-19 17:53:11.097907	present	2026-03-02 15:43:44.318533
1709	6	2025-12-19	2025-12-19 09:40:02.503876	2025-12-19 17:18:11.55224	present	2026-03-02 15:43:44.318533
1710	10	2025-12-19	2025-12-19 09:50:38.145973	2025-12-19 17:19:25.79217	present	2026-03-02 15:43:44.318533
1711	11	2025-12-19	2025-12-19 09:02:10.351114	2025-12-19 17:51:27.760553	present	2026-03-02 15:43:44.318533
1712	27	2025-12-19	2025-12-19 09:50:27.525598	2025-12-19 17:43:48.562689	present	2026-03-02 15:43:44.318533
1713	33	2025-12-19	2025-12-19 09:15:15.177328	2025-12-19 17:46:41.304284	present	2026-03-02 15:43:44.318533
1714	35	2025-12-19	2025-12-19 09:20:18.520927	2025-12-19 17:24:44.942473	present	2026-03-02 15:43:44.318533
1715	37	2025-12-19	2025-12-19 09:41:21.722391	2025-12-19 17:40:49.183616	present	2026-03-02 15:43:44.318533
1716	43	2025-12-19	2025-12-19 09:33:28.309665	2025-12-19 17:28:44.922142	present	2026-03-02 15:43:44.318533
1717	45	2025-12-19	2025-12-19 09:42:32.624349	2025-12-19 17:44:54.046858	present	2026-03-02 15:43:44.318533
1718	46	2025-12-19	2025-12-19 09:45:39.199666	2025-12-19 17:56:06.601333	present	2026-03-02 15:43:44.318533
1719	47	2025-12-19	2025-12-19 09:26:47.793156	2025-12-19 17:47:25.822326	present	2026-03-02 15:43:44.318533
1720	48	2025-12-19	2025-12-19 09:20:33.067332	2025-12-19 17:02:30.410648	present	2026-03-02 15:43:44.318533
1721	50	2025-12-19	2025-12-19 09:43:36.081447	2025-12-19 17:21:24.448959	present	2026-03-02 15:43:44.318533
1722	52	2025-12-19	2025-12-19 09:50:09.278965	2025-12-19 17:43:25.729266	present	2026-03-02 15:43:44.318533
1723	59	2025-12-19	2025-12-19 09:01:46.551348	2025-12-19 17:07:46.565532	present	2026-03-02 15:43:44.318533
1724	60	2025-12-19	2025-12-19 09:25:14.267965	2025-12-19 17:29:16.731812	present	2026-03-02 15:43:44.318533
1725	62	2025-12-19	2025-12-19 09:50:57.692708	2025-12-19 17:34:16.730921	present	2026-03-02 15:43:44.318533
1726	63	2025-12-19	2025-12-19 09:47:21.446059	2025-12-19 17:48:19.82435	present	2026-03-02 15:43:44.318533
1727	64	2025-12-19	2025-12-19 09:41:42.678038	2025-12-19 17:38:25.000325	present	2026-03-02 15:43:44.318533
1728	65	2025-12-19	2025-12-19 09:49:17.524072	2025-12-19 17:50:19.162391	present	2026-03-02 15:43:44.318533
1729	66	2025-12-19	2025-12-19 09:50:41.568172	2025-12-19 17:02:22.85956	present	2026-03-02 15:43:44.318533
1730	70	2025-12-19	2025-12-19 09:01:23.321543	2025-12-19 17:29:12.448721	present	2026-03-02 15:43:44.318533
1731	71	2025-12-19	2025-12-19 09:43:12.385721	2025-12-19 17:13:05.529276	present	2026-03-02 15:43:44.318533
1732	73	2025-12-19	2025-12-19 09:12:14.886684	2025-12-19 17:50:52.244635	present	2026-03-02 15:43:44.318533
1733	74	2025-12-19	2025-12-19 09:36:30.934034	2025-12-19 17:10:53.25663	present	2026-03-02 15:43:44.318533
1734	78	2025-12-19	2025-12-19 09:39:28.747388	2025-12-19 17:56:06.172833	present	2026-03-02 15:43:44.318533
1735	79	2025-12-19	2025-12-19 09:17:03.920922	2025-12-19 17:49:15.619987	present	2026-03-02 15:43:44.318533
1736	82	2025-12-19	2025-12-19 09:32:56.178177	2025-12-19 17:18:46.876015	present	2026-03-02 15:43:44.318533
1737	83	2025-12-19	2025-12-19 09:14:59.115787	2025-12-19 17:15:40.74465	present	2026-03-02 15:43:44.318533
1738	84	2025-12-19	2025-12-19 09:53:47.671786	2025-12-19 17:16:02.171589	present	2026-03-02 15:43:44.318533
1739	85	2025-12-19	2025-12-19 09:32:25.036188	2025-12-19 17:31:38.622344	present	2026-03-02 15:43:44.318533
1740	88	2025-12-19	2025-12-19 09:04:11.562168	2025-12-19 17:25:44.944755	present	2026-03-02 15:43:44.318533
1741	89	2025-12-19	2025-12-19 09:57:39.628666	2025-12-19 17:47:35.462543	present	2026-03-02 15:43:44.318533
1742	96	2025-12-19	2025-12-19 09:44:36.33716	2025-12-19 17:46:40.760418	present	2026-03-02 15:43:44.318533
1743	97	2025-12-19	2025-12-19 09:39:29.989704	2025-12-19 17:05:53.594433	present	2026-03-02 15:43:44.318533
1744	1	2025-12-19	2025-12-19 09:32:30.652402	2025-12-19 17:22:26.754131	present	2026-03-02 15:43:44.318533
1745	2	2025-12-19	2025-12-19 09:06:52.397006	2025-12-19 17:53:24.936912	present	2026-03-02 15:43:44.318533
1746	7	2025-12-19	2025-12-19 09:52:08.129216	2025-12-19 17:20:17.80102	present	2026-03-02 15:43:44.318533
1747	8	2025-12-19	2025-12-19 09:42:58.882559	2025-12-19 17:03:33.158833	present	2026-03-02 15:43:44.318533
1748	9	2025-12-19	2025-12-19 09:55:48.666206	2025-12-19 17:05:23.917913	present	2026-03-02 15:43:44.318533
1749	12	2025-12-19	2025-12-19 09:32:35.188435	2025-12-19 17:09:05.096921	present	2026-03-02 15:43:44.318533
1750	13	2025-12-19	2025-12-19 09:33:18.708362	2025-12-19 17:49:01.479774	present	2026-03-02 15:43:44.318533
1751	14	2025-12-19	2025-12-19 09:10:57.106173	2025-12-19 17:07:29.747282	present	2026-03-02 15:43:44.318533
1752	15	2025-12-19	2025-12-19 09:16:45.949472	2025-12-19 17:28:05.950067	present	2026-03-02 15:43:44.318533
1753	16	2025-12-19	2025-12-19 09:30:27.801329	2025-12-19 17:32:19.352791	present	2026-03-02 15:43:44.318533
1754	17	2025-12-19	2025-12-19 09:27:20.82815	2025-12-19 17:27:04.590504	present	2026-03-02 15:43:44.318533
1755	18	2025-12-19	2025-12-19 09:56:54.455435	2025-12-19 17:18:33.879261	present	2026-03-02 15:43:44.318533
1756	19	2025-12-19	2025-12-19 09:49:13.481552	2025-12-19 17:01:06.232029	present	2026-03-02 15:43:44.318533
1757	20	2025-12-19	2025-12-19 09:45:57.920964	2025-12-19 17:16:33.113014	present	2026-03-02 15:43:44.318533
1758	21	2025-12-19	2025-12-19 09:39:59.172568	2025-12-19 17:06:05.605427	present	2026-03-02 15:43:44.318533
1759	22	2025-12-19	2025-12-19 09:08:23.740179	2025-12-19 17:59:27.429915	present	2026-03-02 15:43:44.318533
1760	23	2025-12-19	2025-12-19 09:58:41.493214	2025-12-19 17:31:14.980101	present	2026-03-02 15:43:44.318533
1761	24	2025-12-19	2025-12-19 09:52:16.941161	2025-12-19 17:30:51.254128	present	2026-03-02 15:43:44.318533
1762	25	2025-12-19	2025-12-19 09:21:01.97774	2025-12-19 17:45:55.017918	present	2026-03-02 15:43:44.318533
1763	26	2025-12-19	2025-12-19 09:42:56.63746	2025-12-19 17:19:09.860106	present	2026-03-02 15:43:44.318533
1764	28	2025-12-19	2025-12-19 09:12:40.918274	2025-12-19 17:40:09.039185	present	2026-03-02 15:43:44.318533
1765	29	2025-12-19	2025-12-19 09:07:05.287807	2025-12-19 17:41:54.288406	present	2026-03-02 15:43:44.318533
1766	30	2025-12-19	2025-12-19 09:36:33.69013	2025-12-19 17:02:07.486153	present	2026-03-02 15:43:44.318533
1767	31	2025-12-19	2025-12-19 09:46:36.673837	2025-12-19 17:51:33.430027	present	2026-03-02 15:43:44.318533
1768	32	2025-12-19	2025-12-19 09:20:30.820682	2025-12-19 17:52:05.599909	present	2026-03-02 15:43:44.318533
1769	34	2025-12-19	2025-12-19 09:16:10.673489	2025-12-19 17:59:52.83883	present	2026-03-02 15:43:44.318533
1770	36	2025-12-19	2025-12-19 09:35:23.041683	2025-12-19 17:20:48.119476	present	2026-03-02 15:43:44.318533
1771	38	2025-12-19	2025-12-19 09:19:12.90905	2025-12-19 17:48:44.633237	present	2026-03-02 15:43:44.318533
1772	39	2025-12-19	2025-12-19 09:14:44.718133	2025-12-19 17:27:49.622076	present	2026-03-02 15:43:44.318533
1773	40	2025-12-19	2025-12-19 09:44:49.776925	2025-12-19 17:46:36.052243	present	2026-03-02 15:43:44.318533
1774	41	2025-12-19	2025-12-19 09:49:27.928666	2025-12-19 17:19:01.008478	present	2026-03-02 15:43:44.318533
1775	42	2025-12-19	2025-12-19 09:22:03.644038	2025-12-19 17:14:09.348305	present	2026-03-02 15:43:44.318533
1776	44	2025-12-19	2025-12-19 09:30:08.773118	2025-12-19 17:33:02.77421	present	2026-03-02 15:43:44.318533
1777	49	2025-12-19	2025-12-19 09:32:57.228893	2025-12-19 17:49:38.519582	present	2026-03-02 15:43:44.318533
1778	51	2025-12-19	2025-12-19 09:26:13.023826	2025-12-19 17:50:56.48704	present	2026-03-02 15:43:44.318533
1779	53	2025-12-19	2025-12-19 09:09:45.743299	2025-12-19 17:27:15.14165	present	2026-03-02 15:43:44.318533
1780	54	2025-12-19	2025-12-19 09:09:50.417617	2025-12-19 17:29:59.978246	present	2026-03-02 15:43:44.318533
1781	55	2025-12-19	2025-12-19 09:44:58.391329	2025-12-19 17:46:27.020124	present	2026-03-02 15:43:44.318533
1782	56	2025-12-19	2025-12-19 09:09:54.61393	2025-12-19 17:47:15.866348	present	2026-03-02 15:43:44.318533
1783	57	2025-12-19	2025-12-19 09:09:25.253991	2025-12-19 17:45:31.652299	present	2026-03-02 15:43:44.318533
1784	58	2025-12-19	2025-12-19 09:23:39.603039	2025-12-19 17:15:13.630731	present	2026-03-02 15:43:44.318533
1785	61	2025-12-19	2025-12-19 09:36:07.484949	2025-12-19 17:41:44.234686	present	2026-03-02 15:43:44.318533
1786	67	2025-12-19	2025-12-19 09:18:02.758971	2025-12-19 17:38:28.058618	present	2026-03-02 15:43:44.318533
1787	68	2025-12-19	2025-12-19 09:29:10.41626	2025-12-19 17:05:32.719144	present	2026-03-02 15:43:44.318533
1788	69	2025-12-19	2025-12-19 09:38:00.601802	2025-12-19 17:24:37.572421	present	2026-03-02 15:43:44.318533
1789	72	2025-12-19	2025-12-19 09:11:02.08942	2025-12-19 17:06:23.753264	present	2026-03-02 15:43:44.318533
1790	75	2025-12-19	2025-12-19 09:05:01.194575	2025-12-19 17:47:34.617042	present	2026-03-02 15:43:44.318533
1791	76	2025-12-19	2025-12-19 09:27:47.588588	2025-12-19 17:58:16.114568	present	2026-03-02 15:43:44.318533
1792	77	2025-12-19	2025-12-19 09:32:49.851821	2025-12-19 17:21:56.081558	present	2026-03-02 15:43:44.318533
1793	80	2025-12-19	2025-12-19 09:00:21.714678	2025-12-19 17:15:30.087683	present	2026-03-02 15:43:44.318533
1794	81	2025-12-19	2025-12-19 09:38:11.424605	2025-12-19 17:12:25.978224	present	2026-03-02 15:43:44.318533
1795	86	2025-12-19	2025-12-19 09:00:43.049261	2025-12-19 17:39:22.001481	present	2026-03-02 15:43:44.318533
1796	87	2025-12-19	2025-12-19 09:12:00.188173	2025-12-19 17:10:07.965484	present	2026-03-02 15:43:44.318533
1797	90	2025-12-19	2025-12-19 09:59:22.266935	2025-12-19 17:01:11.563662	present	2026-03-02 15:43:44.318533
1798	91	2025-12-19	2025-12-19 09:09:28.105445	2025-12-19 17:25:18.907374	present	2026-03-02 15:43:44.318533
1799	92	2025-12-19	2025-12-19 09:27:39.117906	2025-12-19 17:01:47.357369	present	2026-03-02 15:43:44.318533
1800	93	2025-12-19	2025-12-19 09:35:30.726528	2025-12-19 17:13:50.11051	present	2026-03-02 15:43:44.318533
1801	94	2025-12-19	2025-12-19 09:52:28.821113	2025-12-19 17:15:19.795333	present	2026-03-02 15:43:44.318533
1802	95	2025-12-19	2025-12-19 09:45:47.129815	2025-12-19 17:04:27.722108	present	2026-03-02 15:43:44.318533
1803	98	2025-12-19	2025-12-19 09:13:24.213462	2025-12-19 17:44:11.506943	present	2026-03-02 15:43:44.318533
1804	99	2025-12-19	2025-12-19 09:49:16.934391	2025-12-19 17:46:33.036621	present	2026-03-02 15:43:44.318533
1805	100	2025-12-19	2025-12-19 09:45:49.101333	2025-12-19 17:18:33.045671	present	2026-03-02 15:43:44.318533
1806	3	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1807	4	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1808	5	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1809	6	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1810	10	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1811	11	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1812	27	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1813	33	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1814	35	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1815	37	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1816	43	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1817	45	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1818	46	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1819	47	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1820	48	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1821	50	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1822	52	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1823	59	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1824	60	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1825	62	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1826	63	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1827	64	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1828	65	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1829	66	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1830	70	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1831	71	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1832	73	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1833	74	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1834	78	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1835	79	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1836	82	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1837	83	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1838	84	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1839	85	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1840	88	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1841	89	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1842	96	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1843	97	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1844	1	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1845	2	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1846	7	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1847	8	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1848	9	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1849	12	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1850	13	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1851	14	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1852	15	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1853	16	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1854	17	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1855	18	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1856	19	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1857	20	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1858	21	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1859	22	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1860	23	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1861	24	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1862	25	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1863	26	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1864	28	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1865	29	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1866	30	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1867	31	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1868	32	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1869	34	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1870	36	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1871	38	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1872	39	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1873	40	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1874	41	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1875	42	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1876	44	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1877	49	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1878	51	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1879	53	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1880	54	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1881	55	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1882	56	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1883	57	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1884	58	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1885	61	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1886	67	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1887	68	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1888	69	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1889	72	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1890	75	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1891	76	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1892	77	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1893	80	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1894	81	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1895	86	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1896	87	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1897	90	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1898	91	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1899	92	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1900	93	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1901	94	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1902	95	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1903	98	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1904	99	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1905	100	2025-12-20	\N	\N	absent	2026-03-02 15:43:44.318533
1906	3	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1907	4	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1908	5	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1909	6	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1910	10	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1911	11	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1912	27	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1913	33	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1914	35	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1915	37	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1916	43	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1917	45	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1918	46	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1919	47	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1920	48	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1921	50	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1922	52	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1923	59	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1924	60	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1925	62	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1926	63	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1927	64	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1928	65	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1929	66	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1930	70	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1931	71	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1932	73	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1933	74	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1934	78	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1935	79	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1936	82	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1937	83	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1938	84	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1939	85	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1940	88	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1941	89	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1942	96	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1943	97	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1944	1	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1945	2	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1946	7	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1947	8	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1948	9	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1949	12	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1950	13	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1951	14	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1952	15	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1953	16	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1954	17	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1955	18	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1956	19	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1957	20	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1958	21	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1959	22	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1960	23	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1961	24	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1962	25	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1963	26	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1964	28	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1965	29	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1966	30	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1967	31	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1968	32	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1969	34	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1970	36	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1971	38	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1972	39	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1973	40	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1974	41	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1975	42	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1976	44	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1977	49	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1978	51	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1979	53	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1980	54	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1981	55	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1982	56	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1983	57	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1984	58	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1985	61	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1986	67	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1987	68	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1988	69	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1989	72	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1990	75	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1991	76	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1992	77	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1993	80	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1994	81	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1995	86	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1996	87	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1997	90	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1998	91	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
1999	92	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2000	93	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2001	94	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2002	95	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2003	98	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2004	99	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2005	100	2025-12-21	\N	\N	absent	2026-03-02 15:43:44.318533
2006	3	2025-12-22	2025-12-22 09:18:23.307776	2025-12-22 17:19:30.620316	present	2026-03-02 15:43:44.318533
2007	4	2025-12-22	2025-12-22 09:37:15.529595	2025-12-22 17:20:32.291772	present	2026-03-02 15:43:44.318533
2008	5	2025-12-22	2025-12-22 09:28:49.630618	2025-12-22 17:40:25.611349	present	2026-03-02 15:43:44.318533
2009	6	2025-12-22	2025-12-22 09:14:41.832754	2025-12-22 17:36:33.763705	present	2026-03-02 15:43:44.318533
2010	10	2025-12-22	2025-12-22 09:32:05.860545	2025-12-22 17:57:04.391163	present	2026-03-02 15:43:44.318533
2011	11	2025-12-22	2025-12-22 09:58:08.375449	2025-12-22 17:56:18.742747	present	2026-03-02 15:43:44.318533
2012	27	2025-12-22	2025-12-22 09:53:36.183162	2025-12-22 17:42:49.929978	present	2026-03-02 15:43:44.318533
2013	33	2025-12-22	2025-12-22 09:32:33.462159	2025-12-22 17:48:05.123805	present	2026-03-02 15:43:44.318533
2014	35	2025-12-22	2025-12-22 09:39:08.98487	2025-12-22 17:46:30.231877	present	2026-03-02 15:43:44.318533
2015	37	2025-12-22	2025-12-22 09:05:46.103006	2025-12-22 17:45:06.682827	present	2026-03-02 15:43:44.318533
2016	43	2025-12-22	2025-12-22 09:39:00.594813	2025-12-22 17:21:54.680457	present	2026-03-02 15:43:44.318533
2017	45	2025-12-22	2025-12-22 09:07:43.602083	2025-12-22 17:21:42.496878	present	2026-03-02 15:43:44.318533
2018	46	2025-12-22	2025-12-22 09:39:04.19528	2025-12-22 17:16:54.401292	present	2026-03-02 15:43:44.318533
2019	47	2025-12-22	2025-12-22 09:09:06.185227	2025-12-22 17:32:40.189034	present	2026-03-02 15:43:44.318533
2020	48	2025-12-22	2025-12-22 09:54:25.548595	2025-12-22 17:33:09.549134	present	2026-03-02 15:43:44.318533
2021	50	2025-12-22	2025-12-22 09:05:38.937752	2025-12-22 17:55:42.508731	present	2026-03-02 15:43:44.318533
2022	52	2025-12-22	2025-12-22 09:11:51.049602	2025-12-22 17:34:53.472395	present	2026-03-02 15:43:44.318533
2023	59	2025-12-22	2025-12-22 09:40:45.864591	2025-12-22 17:09:44.571078	present	2026-03-02 15:43:44.318533
2024	60	2025-12-22	2025-12-22 09:35:17.314143	2025-12-22 17:53:53.567951	present	2026-03-02 15:43:44.318533
2025	62	2025-12-22	2025-12-22 09:19:25.860083	2025-12-22 17:00:41.831199	present	2026-03-02 15:43:44.318533
2026	63	2025-12-22	2025-12-22 09:52:21.581566	2025-12-22 17:43:35.269722	present	2026-03-02 15:43:44.318533
2027	64	2025-12-22	2025-12-22 09:21:41.321273	2025-12-22 17:35:01.928475	present	2026-03-02 15:43:44.318533
2028	65	2025-12-22	2025-12-22 09:24:41.473809	2025-12-22 17:55:27.978616	present	2026-03-02 15:43:44.318533
2029	66	2025-12-22	2025-12-22 09:37:18.306804	2025-12-22 17:03:31.613587	present	2026-03-02 15:43:44.318533
2030	70	2025-12-22	2025-12-22 09:02:29.794434	2025-12-22 17:29:36.732213	present	2026-03-02 15:43:44.318533
2031	71	2025-12-22	2025-12-22 09:00:28.257063	2025-12-22 17:15:58.147289	present	2026-03-02 15:43:44.318533
2032	73	2025-12-22	2025-12-22 09:47:41.593024	2025-12-22 17:17:41.202915	present	2026-03-02 15:43:44.318533
2033	74	2025-12-22	2025-12-22 09:50:11.885726	2025-12-22 17:56:40.28444	present	2026-03-02 15:43:44.318533
2034	78	2025-12-22	2025-12-22 09:00:39.267653	2025-12-22 17:26:15.463956	present	2026-03-02 15:43:44.318533
2035	79	2025-12-22	2025-12-22 09:16:48.435503	2025-12-22 17:23:04.002799	present	2026-03-02 15:43:44.318533
2036	82	2025-12-22	2025-12-22 09:03:58.586811	2025-12-22 17:20:45.174401	present	2026-03-02 15:43:44.318533
2037	83	2025-12-22	2025-12-22 09:14:25.898764	2025-12-22 17:13:10.620143	present	2026-03-02 15:43:44.318533
2038	84	2025-12-22	2025-12-22 09:24:13.789317	2025-12-22 17:49:28.698477	present	2026-03-02 15:43:44.318533
2039	85	2025-12-22	2025-12-22 09:05:42.555481	2025-12-22 17:49:59.960635	present	2026-03-02 15:43:44.318533
2040	88	2025-12-22	2025-12-22 09:53:21.096322	2025-12-22 17:57:04.977294	present	2026-03-02 15:43:44.318533
2041	89	2025-12-22	2025-12-22 09:37:23.146619	2025-12-22 17:57:23.001852	present	2026-03-02 15:43:44.318533
2042	96	2025-12-22	2025-12-22 09:39:48.7681	2025-12-22 17:53:18.795949	present	2026-03-02 15:43:44.318533
2043	97	2025-12-22	2025-12-22 09:39:36.624485	2025-12-22 17:55:43.469044	present	2026-03-02 15:43:44.318533
2044	1	2025-12-22	2025-12-22 09:00:44.143952	2025-12-22 17:26:54.217739	present	2026-03-02 15:43:44.318533
2045	2	2025-12-22	2025-12-22 09:21:39.429163	2025-12-22 17:15:27.563074	present	2026-03-02 15:43:44.318533
2046	7	2025-12-22	2025-12-22 09:52:05.78223	2025-12-22 17:21:32.014271	present	2026-03-02 15:43:44.318533
2047	8	2025-12-22	2025-12-22 09:23:06.057856	2025-12-22 17:56:31.898588	present	2026-03-02 15:43:44.318533
2048	9	2025-12-22	2025-12-22 09:26:01.739666	2025-12-22 17:05:57.494144	present	2026-03-02 15:43:44.318533
2049	12	2025-12-22	2025-12-22 09:45:28.056467	2025-12-22 17:28:17.560487	present	2026-03-02 15:43:44.318533
2050	13	2025-12-22	2025-12-22 09:39:36.17493	2025-12-22 17:55:30.074133	present	2026-03-02 15:43:44.318533
2051	14	2025-12-22	2025-12-22 09:24:38.899355	2025-12-22 17:58:22.002758	present	2026-03-02 15:43:44.318533
2052	15	2025-12-22	2025-12-22 09:55:40.459122	2025-12-22 17:24:07.458243	present	2026-03-02 15:43:44.318533
2053	16	2025-12-22	2025-12-22 09:35:43.584183	2025-12-22 17:25:50.031766	present	2026-03-02 15:43:44.318533
2054	17	2025-12-22	2025-12-22 09:44:48.292398	2025-12-22 17:11:42.882715	present	2026-03-02 15:43:44.318533
2055	18	2025-12-22	2025-12-22 09:04:11.733463	2025-12-22 17:21:24.701247	present	2026-03-02 15:43:44.318533
2056	19	2025-12-22	2025-12-22 09:03:55.757028	2025-12-22 17:27:10.255885	present	2026-03-02 15:43:44.318533
2057	20	2025-12-22	2025-12-22 09:18:33.539574	2025-12-22 17:16:12.406773	present	2026-03-02 15:43:44.318533
2058	21	2025-12-22	2025-12-22 09:37:56.548622	2025-12-22 17:28:11.578284	present	2026-03-02 15:43:44.318533
2059	22	2025-12-22	2025-12-22 09:50:54.445538	2025-12-22 17:55:41.165248	present	2026-03-02 15:43:44.318533
2060	23	2025-12-22	2025-12-22 09:59:50.785755	2025-12-22 17:24:05.421189	present	2026-03-02 15:43:44.318533
2061	24	2025-12-22	2025-12-22 09:07:53.226996	2025-12-22 17:07:11.578761	present	2026-03-02 15:43:44.318533
2062	25	2025-12-22	2025-12-22 09:12:08.184032	2025-12-22 17:56:40.191205	present	2026-03-02 15:43:44.318533
2063	26	2025-12-22	2025-12-22 09:18:01.295265	2025-12-22 17:06:04.610555	present	2026-03-02 15:43:44.318533
2064	28	2025-12-22	2025-12-22 09:00:32.307895	2025-12-22 17:52:13.658414	present	2026-03-02 15:43:44.318533
2065	29	2025-12-22	2025-12-22 09:22:35.752975	2025-12-22 17:49:19.398044	present	2026-03-02 15:43:44.318533
2066	30	2025-12-22	2025-12-22 09:54:52.603285	2025-12-22 17:32:18.764576	present	2026-03-02 15:43:44.318533
2067	31	2025-12-22	2025-12-22 09:31:45.592208	2025-12-22 17:36:36.044768	present	2026-03-02 15:43:44.318533
2068	32	2025-12-22	2025-12-22 09:55:49.128126	2025-12-22 17:13:45.069377	present	2026-03-02 15:43:44.318533
2069	34	2025-12-22	2025-12-22 09:32:58.821041	2025-12-22 17:31:17.348731	present	2026-03-02 15:43:44.318533
2070	36	2025-12-22	2025-12-22 09:37:17.439786	2025-12-22 17:58:12.361875	present	2026-03-02 15:43:44.318533
2071	38	2025-12-22	2025-12-22 09:29:08.110033	2025-12-22 17:20:10.706965	present	2026-03-02 15:43:44.318533
2072	39	2025-12-22	2025-12-22 09:29:13.881677	2025-12-22 17:17:16.742729	present	2026-03-02 15:43:44.318533
2073	40	2025-12-22	2025-12-22 09:26:33.55806	2025-12-22 17:42:34.396071	present	2026-03-02 15:43:44.318533
2074	41	2025-12-22	2025-12-22 09:13:32.313371	2025-12-22 17:19:17.962891	present	2026-03-02 15:43:44.318533
2075	42	2025-12-22	2025-12-22 09:16:20.436538	2025-12-22 17:19:40.950752	present	2026-03-02 15:43:44.318533
2076	44	2025-12-22	2025-12-22 09:38:02.265228	2025-12-22 17:28:09.612228	present	2026-03-02 15:43:44.318533
2640	88	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2077	49	2025-12-22	2025-12-22 09:20:34.109782	2025-12-22 17:44:20.138112	present	2026-03-02 15:43:44.318533
2078	51	2025-12-22	2025-12-22 09:18:55.053435	2025-12-22 17:05:29.782188	present	2026-03-02 15:43:44.318533
2079	53	2025-12-22	2025-12-22 09:42:00.681085	2025-12-22 17:54:43.219174	present	2026-03-02 15:43:44.318533
2080	54	2025-12-22	2025-12-22 09:53:59.915443	2025-12-22 17:28:22.663736	present	2026-03-02 15:43:44.318533
2081	55	2025-12-22	2025-12-22 09:49:39.659576	2025-12-22 17:54:09.416804	present	2026-03-02 15:43:44.318533
2082	56	2025-12-22	2025-12-22 09:18:38.126798	2025-12-22 17:16:35.688527	present	2026-03-02 15:43:44.318533
2083	57	2025-12-22	2025-12-22 09:46:55.562502	2025-12-22 17:17:33.632475	present	2026-03-02 15:43:44.318533
2084	58	2025-12-22	2025-12-22 09:46:07.902182	2025-12-22 17:34:43.345679	present	2026-03-02 15:43:44.318533
2085	61	2025-12-22	2025-12-22 09:01:42.720291	2025-12-22 17:14:54.051917	present	2026-03-02 15:43:44.318533
2086	67	2025-12-22	2025-12-22 09:48:12.406792	2025-12-22 17:58:38.4378	present	2026-03-02 15:43:44.318533
2087	68	2025-12-22	2025-12-22 09:29:17.569015	2025-12-22 17:56:30.836205	present	2026-03-02 15:43:44.318533
2088	69	2025-12-22	2025-12-22 09:12:26.841816	2025-12-22 17:14:10.309025	present	2026-03-02 15:43:44.318533
2089	72	2025-12-22	2025-12-22 09:19:42.774354	2025-12-22 17:02:18.179682	present	2026-03-02 15:43:44.318533
2090	75	2025-12-22	2025-12-22 09:27:52.251052	2025-12-22 17:34:16.881912	present	2026-03-02 15:43:44.318533
2091	76	2025-12-22	2025-12-22 09:15:14.540899	2025-12-22 17:35:39.136211	present	2026-03-02 15:43:44.318533
2092	77	2025-12-22	2025-12-22 09:17:58.210666	2025-12-22 17:46:02.127738	present	2026-03-02 15:43:44.318533
2093	80	2025-12-22	2025-12-22 09:50:33.366044	2025-12-22 17:20:52.740158	present	2026-03-02 15:43:44.318533
2094	81	2025-12-22	2025-12-22 09:13:46.330944	2025-12-22 17:15:43.633185	present	2026-03-02 15:43:44.318533
2095	86	2025-12-22	2025-12-22 09:59:44.704123	2025-12-22 17:43:24.547232	present	2026-03-02 15:43:44.318533
2096	87	2025-12-22	2025-12-22 09:21:57.532118	2025-12-22 17:09:29.161161	present	2026-03-02 15:43:44.318533
2097	90	2025-12-22	2025-12-22 09:19:40.961382	2025-12-22 17:46:47.46432	present	2026-03-02 15:43:44.318533
2098	91	2025-12-22	2025-12-22 09:03:53.939307	2025-12-22 17:59:35.734999	present	2026-03-02 15:43:44.318533
2099	92	2025-12-22	2025-12-22 09:29:53.898346	2025-12-22 17:29:29.993403	present	2026-03-02 15:43:44.318533
2100	93	2025-12-22	2025-12-22 09:47:45.540673	2025-12-22 17:34:06.16746	present	2026-03-02 15:43:44.318533
2101	94	2025-12-22	2025-12-22 09:47:22.503255	2025-12-22 17:26:18.383219	present	2026-03-02 15:43:44.318533
2102	95	2025-12-22	2025-12-22 09:51:51.120929	2025-12-22 17:54:40.871968	present	2026-03-02 15:43:44.318533
2103	98	2025-12-22	2025-12-22 09:30:11.864954	2025-12-22 17:02:24.177686	present	2026-03-02 15:43:44.318533
2104	99	2025-12-22	2025-12-22 09:12:15.507008	2025-12-22 17:48:55.623318	present	2026-03-02 15:43:44.318533
2105	100	2025-12-22	2025-12-22 09:08:05.815002	2025-12-22 17:12:50.101113	present	2026-03-02 15:43:44.318533
2106	3	2025-12-23	2025-12-23 09:17:51.981394	2025-12-23 17:13:20.340608	present	2026-03-02 15:43:44.318533
2107	4	2025-12-23	2025-12-23 09:36:41.672662	2025-12-23 17:35:20.475063	present	2026-03-02 15:43:44.318533
2108	5	2025-12-23	2025-12-23 09:09:17.640404	2025-12-23 17:28:29.278451	present	2026-03-02 15:43:44.318533
2109	6	2025-12-23	2025-12-23 09:54:11.088996	2025-12-23 17:30:42.339481	present	2026-03-02 15:43:44.318533
2110	10	2025-12-23	2025-12-23 09:48:57.662471	2025-12-23 17:25:41.881191	present	2026-03-02 15:43:44.318533
2111	11	2025-12-23	2025-12-23 09:58:07.436699	2025-12-23 17:47:34.713742	present	2026-03-02 15:43:44.318533
2112	27	2025-12-23	2025-12-23 09:49:20.070361	2025-12-23 17:55:28.77656	present	2026-03-02 15:43:44.318533
2113	33	2025-12-23	2025-12-23 09:42:08.048377	2025-12-23 17:18:26.924361	present	2026-03-02 15:43:44.318533
2114	35	2025-12-23	2025-12-23 09:18:28.888001	2025-12-23 17:53:28.463466	present	2026-03-02 15:43:44.318533
2115	37	2025-12-23	2025-12-23 09:50:45.763403	2025-12-23 17:55:48.584661	present	2026-03-02 15:43:44.318533
2116	43	2025-12-23	2025-12-23 09:40:54.065846	2025-12-23 17:35:47.799307	present	2026-03-02 15:43:44.318533
2117	45	2025-12-23	2025-12-23 09:29:25.355173	2025-12-23 17:56:59.141094	present	2026-03-02 15:43:44.318533
2118	46	2025-12-23	2025-12-23 09:55:23.159043	2025-12-23 17:53:43.979788	present	2026-03-02 15:43:44.318533
2119	47	2025-12-23	2025-12-23 09:28:27.403101	2025-12-23 17:38:51.247326	present	2026-03-02 15:43:44.318533
2120	48	2025-12-23	2025-12-23 09:30:23.545569	2025-12-23 17:10:44.559854	present	2026-03-02 15:43:44.318533
2121	50	2025-12-23	2025-12-23 09:27:15.908555	2025-12-23 17:29:33.604274	present	2026-03-02 15:43:44.318533
2122	52	2025-12-23	2025-12-23 09:51:35.148787	2025-12-23 17:45:45.624194	present	2026-03-02 15:43:44.318533
2123	59	2025-12-23	2025-12-23 09:30:28.84443	2025-12-23 17:14:33.172694	present	2026-03-02 15:43:44.318533
2124	60	2025-12-23	2025-12-23 09:06:51.83675	2025-12-23 17:32:44.627145	present	2026-03-02 15:43:44.318533
2125	62	2025-12-23	2025-12-23 09:12:39.383047	2025-12-23 17:24:05.438101	present	2026-03-02 15:43:44.318533
2126	63	2025-12-23	2025-12-23 09:25:25.876997	2025-12-23 17:20:55.80044	present	2026-03-02 15:43:44.318533
2127	64	2025-12-23	2025-12-23 09:48:22.756288	2025-12-23 17:34:56.921281	present	2026-03-02 15:43:44.318533
2128	65	2025-12-23	2025-12-23 09:58:55.238686	2025-12-23 17:38:18.431071	present	2026-03-02 15:43:44.318533
2129	66	2025-12-23	2025-12-23 09:15:42.091774	2025-12-23 17:48:19.626036	present	2026-03-02 15:43:44.318533
2130	70	2025-12-23	2025-12-23 09:15:06.214386	2025-12-23 17:17:55.291461	present	2026-03-02 15:43:44.318533
2131	71	2025-12-23	2025-12-23 09:02:42.369961	2025-12-23 17:36:15.355672	present	2026-03-02 15:43:44.318533
2132	73	2025-12-23	2025-12-23 09:39:49.159656	2025-12-23 17:30:29.149091	present	2026-03-02 15:43:44.318533
2133	74	2025-12-23	2025-12-23 09:53:11.979257	2025-12-23 17:09:37.597276	present	2026-03-02 15:43:44.318533
2134	78	2025-12-23	2025-12-23 09:06:03.917837	2025-12-23 17:35:26.142728	present	2026-03-02 15:43:44.318533
2135	79	2025-12-23	2025-12-23 09:17:36.224305	2025-12-23 17:18:36.675991	present	2026-03-02 15:43:44.318533
2136	82	2025-12-23	2025-12-23 09:10:29.989227	2025-12-23 17:18:41.821576	present	2026-03-02 15:43:44.318533
2137	83	2025-12-23	2025-12-23 09:46:14.909965	2025-12-23 17:43:01.821439	present	2026-03-02 15:43:44.318533
2138	84	2025-12-23	2025-12-23 09:01:54.766528	2025-12-23 17:35:42.199057	present	2026-03-02 15:43:44.318533
2139	85	2025-12-23	2025-12-23 09:31:48.298043	2025-12-23 17:37:43.136327	present	2026-03-02 15:43:44.318533
2140	88	2025-12-23	2025-12-23 09:38:47.497187	2025-12-23 17:27:37.518576	present	2026-03-02 15:43:44.318533
2141	89	2025-12-23	2025-12-23 09:08:05.240937	2025-12-23 17:35:51.818627	present	2026-03-02 15:43:44.318533
2142	96	2025-12-23	2025-12-23 09:42:28.491192	2025-12-23 17:26:57.906563	present	2026-03-02 15:43:44.318533
2143	97	2025-12-23	2025-12-23 09:11:13.393328	2025-12-23 17:42:06.262461	present	2026-03-02 15:43:44.318533
2144	1	2025-12-23	2025-12-23 09:36:49.203597	2025-12-23 17:50:05.409344	present	2026-03-02 15:43:44.318533
2145	2	2025-12-23	2025-12-23 09:19:49.453828	2025-12-23 17:48:00.380368	present	2026-03-02 15:43:44.318533
2146	7	2025-12-23	2025-12-23 09:06:19.350011	2025-12-23 17:07:26.903837	present	2026-03-02 15:43:44.318533
2147	8	2025-12-23	2025-12-23 09:46:14.474496	2025-12-23 17:57:55.092178	present	2026-03-02 15:43:44.318533
2148	9	2025-12-23	2025-12-23 09:11:02.413499	2025-12-23 17:42:16.096259	present	2026-03-02 15:43:44.318533
2149	12	2025-12-23	2025-12-23 09:53:41.00898	2025-12-23 17:50:44.750085	present	2026-03-02 15:43:44.318533
2150	13	2025-12-23	2025-12-23 09:44:24.22859	2025-12-23 17:49:58.794478	present	2026-03-02 15:43:44.318533
2151	14	2025-12-23	2025-12-23 09:15:19.609864	2025-12-23 17:00:24.216453	present	2026-03-02 15:43:44.318533
2152	15	2025-12-23	2025-12-23 09:36:42.963713	2025-12-23 17:33:14.436539	present	2026-03-02 15:43:44.318533
2153	16	2025-12-23	2025-12-23 09:30:31.178899	2025-12-23 17:30:29.713902	present	2026-03-02 15:43:44.318533
2154	17	2025-12-23	2025-12-23 09:48:13.635235	2025-12-23 17:58:25.002238	present	2026-03-02 15:43:44.318533
2155	18	2025-12-23	2025-12-23 09:04:04.40834	2025-12-23 17:55:35.87713	present	2026-03-02 15:43:44.318533
2156	19	2025-12-23	2025-12-23 09:32:53.243296	2025-12-23 17:49:15.144626	present	2026-03-02 15:43:44.318533
2157	20	2025-12-23	2025-12-23 09:11:35.614838	2025-12-23 17:28:48.382014	present	2026-03-02 15:43:44.318533
2158	21	2025-12-23	2025-12-23 09:26:06.389312	2025-12-23 17:22:32.904376	present	2026-03-02 15:43:44.318533
2159	22	2025-12-23	2025-12-23 09:23:53.008991	2025-12-23 17:07:48.395125	present	2026-03-02 15:43:44.318533
2160	23	2025-12-23	2025-12-23 09:31:33.830319	2025-12-23 17:57:08.065471	present	2026-03-02 15:43:44.318533
2161	24	2025-12-23	2025-12-23 09:48:46.656993	2025-12-23 17:27:23.130066	present	2026-03-02 15:43:44.318533
2162	25	2025-12-23	2025-12-23 09:07:33.825204	2025-12-23 17:55:06.793083	present	2026-03-02 15:43:44.318533
2163	26	2025-12-23	2025-12-23 09:48:39.64548	2025-12-23 17:52:48.446341	present	2026-03-02 15:43:44.318533
2164	28	2025-12-23	2025-12-23 09:18:17.837888	2025-12-23 17:45:44.605129	present	2026-03-02 15:43:44.318533
2165	29	2025-12-23	2025-12-23 09:20:08.120059	2025-12-23 17:39:30.800006	present	2026-03-02 15:43:44.318533
2166	30	2025-12-23	2025-12-23 09:09:48.41621	2025-12-23 17:57:00.232409	present	2026-03-02 15:43:44.318533
2167	31	2025-12-23	2025-12-23 09:51:58.057132	2025-12-23 17:07:00.367591	present	2026-03-02 15:43:44.318533
2168	32	2025-12-23	2025-12-23 09:08:32.811691	2025-12-23 17:09:23.781714	present	2026-03-02 15:43:44.318533
2169	34	2025-12-23	2025-12-23 09:46:24.609622	2025-12-23 17:14:56.337034	present	2026-03-02 15:43:44.318533
2170	36	2025-12-23	2025-12-23 09:06:19.424804	2025-12-23 17:02:27.713509	present	2026-03-02 15:43:44.318533
2171	38	2025-12-23	2025-12-23 09:10:21.179129	2025-12-23 17:49:08.490164	present	2026-03-02 15:43:44.318533
2172	39	2025-12-23	2025-12-23 09:16:24.274309	2025-12-23 17:28:42.339444	present	2026-03-02 15:43:44.318533
2173	40	2025-12-23	2025-12-23 09:49:29.507662	2025-12-23 17:29:22.252442	present	2026-03-02 15:43:44.318533
2174	41	2025-12-23	2025-12-23 09:13:23.415169	2025-12-23 17:10:10.874494	present	2026-03-02 15:43:44.318533
2175	42	2025-12-23	2025-12-23 09:47:02.193242	2025-12-23 17:50:25.020428	present	2026-03-02 15:43:44.318533
2176	44	2025-12-23	2025-12-23 09:49:04.843464	2025-12-23 17:47:26.246574	present	2026-03-02 15:43:44.318533
2177	49	2025-12-23	2025-12-23 09:01:53.323475	2025-12-23 17:53:36.335907	present	2026-03-02 15:43:44.318533
2178	51	2025-12-23	2025-12-23 09:05:28.5717	2025-12-23 17:56:55.152945	present	2026-03-02 15:43:44.318533
2179	53	2025-12-23	2025-12-23 09:41:50.151325	2025-12-23 17:53:08.461404	present	2026-03-02 15:43:44.318533
2180	54	2025-12-23	2025-12-23 09:15:20.396132	2025-12-23 17:01:01.111448	present	2026-03-02 15:43:44.318533
2181	55	2025-12-23	2025-12-23 09:46:33.360142	2025-12-23 17:42:02.411101	present	2026-03-02 15:43:44.318533
2182	56	2025-12-23	2025-12-23 09:49:34.789512	2025-12-23 17:34:34.364777	present	2026-03-02 15:43:44.318533
2183	57	2025-12-23	2025-12-23 09:41:21.51767	2025-12-23 17:12:37.737399	present	2026-03-02 15:43:44.318533
2184	58	2025-12-23	2025-12-23 09:12:43.201623	2025-12-23 17:59:01.302247	present	2026-03-02 15:43:44.318533
2185	61	2025-12-23	2025-12-23 09:43:03.441648	2025-12-23 17:49:36.525933	present	2026-03-02 15:43:44.318533
2186	67	2025-12-23	2025-12-23 09:43:41.298932	2025-12-23 17:01:00.576566	present	2026-03-02 15:43:44.318533
2187	68	2025-12-23	2025-12-23 09:02:27.084632	2025-12-23 17:49:08.129208	present	2026-03-02 15:43:44.318533
2188	69	2025-12-23	2025-12-23 09:10:50.344017	2025-12-23 17:24:04.908536	present	2026-03-02 15:43:44.318533
2189	72	2025-12-23	2025-12-23 09:35:56.037116	2025-12-23 17:17:55.43018	present	2026-03-02 15:43:44.318533
2190	75	2025-12-23	2025-12-23 09:32:29.889531	2025-12-23 17:33:36.4172	present	2026-03-02 15:43:44.318533
2191	76	2025-12-23	2025-12-23 09:11:34.936327	2025-12-23 17:28:11.970711	present	2026-03-02 15:43:44.318533
2192	77	2025-12-23	2025-12-23 09:32:15.304353	2025-12-23 17:06:43.27784	present	2026-03-02 15:43:44.318533
2193	80	2025-12-23	2025-12-23 09:16:15.336509	2025-12-23 17:18:07.701084	present	2026-03-02 15:43:44.318533
2194	81	2025-12-23	2025-12-23 09:10:02.41052	2025-12-23 17:58:01.359317	present	2026-03-02 15:43:44.318533
2195	86	2025-12-23	2025-12-23 09:15:50.667474	2025-12-23 17:59:35.290411	present	2026-03-02 15:43:44.318533
2196	87	2025-12-23	2025-12-23 09:23:29.04259	2025-12-23 17:20:28.68172	present	2026-03-02 15:43:44.318533
2197	90	2025-12-23	2025-12-23 09:54:39.756214	2025-12-23 17:14:34.116606	present	2026-03-02 15:43:44.318533
2198	91	2025-12-23	2025-12-23 09:13:28.231131	2025-12-23 17:01:50.170732	present	2026-03-02 15:43:44.318533
2199	92	2025-12-23	2025-12-23 09:06:31.180394	2025-12-23 17:27:48.047033	present	2026-03-02 15:43:44.318533
2200	93	2025-12-23	2025-12-23 09:01:53.669369	2025-12-23 17:13:15.747814	present	2026-03-02 15:43:44.318533
2201	94	2025-12-23	2025-12-23 09:50:24.100434	2025-12-23 17:25:14.04161	present	2026-03-02 15:43:44.318533
2202	95	2025-12-23	2025-12-23 09:02:23.239456	2025-12-23 17:37:17.512983	present	2026-03-02 15:43:44.318533
2203	98	2025-12-23	2025-12-23 09:18:57.629772	2025-12-23 17:55:18.614383	present	2026-03-02 15:43:44.318533
2204	99	2025-12-23	2025-12-23 09:42:15.67046	2025-12-23 17:40:12.274149	present	2026-03-02 15:43:44.318533
2205	100	2025-12-23	2025-12-23 09:14:46.661907	2025-12-23 17:24:34.038184	present	2026-03-02 15:43:44.318533
2206	3	2025-12-24	2025-12-24 09:33:18.041816	2025-12-24 17:55:00.996882	present	2026-03-02 15:43:44.318533
2207	4	2025-12-24	2025-12-24 09:01:05.230041	2025-12-24 17:51:14.490718	present	2026-03-02 15:43:44.318533
2208	5	2025-12-24	2025-12-24 09:36:09.445706	2025-12-24 17:09:25.827451	present	2026-03-02 15:43:44.318533
2209	6	2025-12-24	2025-12-24 09:19:16.766268	2025-12-24 17:27:11.631251	present	2026-03-02 15:43:44.318533
2210	10	2025-12-24	2025-12-24 09:06:12.022627	2025-12-24 17:29:22.306491	present	2026-03-02 15:43:44.318533
2211	11	2025-12-24	2025-12-24 09:25:12.590781	2025-12-24 17:23:19.203899	present	2026-03-02 15:43:44.318533
2212	27	2025-12-24	2025-12-24 09:59:15.732371	2025-12-24 17:44:27.311397	present	2026-03-02 15:43:44.318533
2213	33	2025-12-24	2025-12-24 09:06:49.480337	2025-12-24 17:54:49.169554	present	2026-03-02 15:43:44.318533
2214	35	2025-12-24	2025-12-24 09:12:21.954466	2025-12-24 17:32:32.22461	present	2026-03-02 15:43:44.318533
2215	37	2025-12-24	2025-12-24 09:12:35.504768	2025-12-24 17:10:50.457013	present	2026-03-02 15:43:44.318533
2216	43	2025-12-24	2025-12-24 09:39:59.763964	2025-12-24 17:40:53.505751	present	2026-03-02 15:43:44.318533
2217	45	2025-12-24	2025-12-24 09:39:57.557903	2025-12-24 17:21:46.755125	present	2026-03-02 15:43:44.318533
2218	46	2025-12-24	2025-12-24 09:59:34.007916	2025-12-24 17:06:55.372255	present	2026-03-02 15:43:44.318533
2219	47	2025-12-24	2025-12-24 09:01:32.380327	2025-12-24 17:33:22.252572	present	2026-03-02 15:43:44.318533
2220	48	2025-12-24	2025-12-24 09:09:38.683051	2025-12-24 17:04:13.115924	present	2026-03-02 15:43:44.318533
2221	50	2025-12-24	2025-12-24 09:23:42.98063	2025-12-24 17:53:48.365308	present	2026-03-02 15:43:44.318533
2222	52	2025-12-24	2025-12-24 09:34:57.947456	2025-12-24 17:10:17.015687	present	2026-03-02 15:43:44.318533
2223	59	2025-12-24	2025-12-24 09:14:20.387714	2025-12-24 17:46:23.801142	present	2026-03-02 15:43:44.318533
2224	60	2025-12-24	2025-12-24 09:08:19.948978	2025-12-24 17:59:37.871019	present	2026-03-02 15:43:44.318533
2225	62	2025-12-24	2025-12-24 09:03:38.344856	2025-12-24 17:42:57.598871	present	2026-03-02 15:43:44.318533
2226	63	2025-12-24	2025-12-24 09:37:43.590208	2025-12-24 17:33:21.362319	present	2026-03-02 15:43:44.318533
2227	64	2025-12-24	2025-12-24 09:41:41.821099	2025-12-24 17:01:33.231697	present	2026-03-02 15:43:44.318533
2228	65	2025-12-24	2025-12-24 09:21:11.9377	2025-12-24 17:21:43.660048	present	2026-03-02 15:43:44.318533
2229	66	2025-12-24	2025-12-24 09:27:34.319894	2025-12-24 17:58:30.806679	present	2026-03-02 15:43:44.318533
2230	70	2025-12-24	2025-12-24 09:15:10.006015	2025-12-24 17:31:09.91136	present	2026-03-02 15:43:44.318533
2231	71	2025-12-24	2025-12-24 09:56:24.029429	2025-12-24 17:36:45.907439	present	2026-03-02 15:43:44.318533
2232	73	2025-12-24	2025-12-24 09:38:15.491962	2025-12-24 17:37:55.58419	present	2026-03-02 15:43:44.318533
2233	74	2025-12-24	2025-12-24 09:17:45.878313	2025-12-24 17:10:07.720333	present	2026-03-02 15:43:44.318533
2234	78	2025-12-24	2025-12-24 09:43:33.919717	2025-12-24 17:36:21.522812	present	2026-03-02 15:43:44.318533
2235	79	2025-12-24	2025-12-24 09:44:11.564843	2025-12-24 17:36:59.564144	present	2026-03-02 15:43:44.318533
2236	82	2025-12-24	2025-12-24 09:30:25.06543	2025-12-24 17:51:04.254698	present	2026-03-02 15:43:44.318533
2237	83	2025-12-24	2025-12-24 09:07:42.945713	2025-12-24 17:39:00.530905	present	2026-03-02 15:43:44.318533
2238	84	2025-12-24	2025-12-24 09:10:21.900308	2025-12-24 17:54:12.968845	present	2026-03-02 15:43:44.318533
2239	85	2025-12-24	2025-12-24 09:02:47.39747	2025-12-24 17:34:48.891484	present	2026-03-02 15:43:44.318533
2240	88	2025-12-24	2025-12-24 09:08:02.368006	2025-12-24 17:59:09.149166	present	2026-03-02 15:43:44.318533
2241	89	2025-12-24	2025-12-24 09:23:32.730564	2025-12-24 17:36:42.72719	present	2026-03-02 15:43:44.318533
2242	96	2025-12-24	2025-12-24 09:37:43.357653	2025-12-24 17:13:52.634264	present	2026-03-02 15:43:44.318533
2243	97	2025-12-24	2025-12-24 09:56:04.51468	2025-12-24 17:13:15.844798	present	2026-03-02 15:43:44.318533
2244	1	2025-12-24	2025-12-24 09:20:50.634735	2025-12-24 17:51:07.206904	present	2026-03-02 15:43:44.318533
2245	2	2025-12-24	2025-12-24 09:41:41.778248	2025-12-24 17:01:05.083666	present	2026-03-02 15:43:44.318533
2246	7	2025-12-24	2025-12-24 09:34:57.716806	2025-12-24 17:34:36.19132	present	2026-03-02 15:43:44.318533
2247	8	2025-12-24	2025-12-24 09:22:16.38237	2025-12-24 17:32:21.058557	present	2026-03-02 15:43:44.318533
2248	9	2025-12-24	2025-12-24 09:47:34.297132	2025-12-24 17:18:01.981674	present	2026-03-02 15:43:44.318533
2249	12	2025-12-24	2025-12-24 09:58:46.100899	2025-12-24 17:35:19.756519	present	2026-03-02 15:43:44.318533
2250	13	2025-12-24	2025-12-24 09:13:32.995539	2025-12-24 17:26:11.044073	present	2026-03-02 15:43:44.318533
2251	14	2025-12-24	2025-12-24 09:33:22.813153	2025-12-24 17:32:10.509298	present	2026-03-02 15:43:44.318533
2252	15	2025-12-24	2025-12-24 09:49:21.747883	2025-12-24 17:43:47.988832	present	2026-03-02 15:43:44.318533
2253	16	2025-12-24	2025-12-24 09:40:35.817917	2025-12-24 17:59:43.480886	present	2026-03-02 15:43:44.318533
2254	17	2025-12-24	2025-12-24 09:48:03.659311	2025-12-24 17:43:12.468691	present	2026-03-02 15:43:44.318533
2255	18	2025-12-24	2025-12-24 09:24:58.37295	2025-12-24 17:50:11.793029	present	2026-03-02 15:43:44.318533
2256	19	2025-12-24	2025-12-24 09:23:38.829717	2025-12-24 17:20:23.313184	present	2026-03-02 15:43:44.318533
2257	20	2025-12-24	2025-12-24 09:51:23.396707	2025-12-24 17:51:05.208988	present	2026-03-02 15:43:44.318533
2258	21	2025-12-24	2025-12-24 09:40:22.830016	2025-12-24 17:08:02.381727	present	2026-03-02 15:43:44.318533
2259	22	2025-12-24	2025-12-24 09:53:09.141271	2025-12-24 17:06:36.545966	present	2026-03-02 15:43:44.318533
2260	23	2025-12-24	2025-12-24 09:33:18.984645	2025-12-24 17:02:40.385574	present	2026-03-02 15:43:44.318533
2261	24	2025-12-24	2025-12-24 09:21:14.795784	2025-12-24 17:51:55.065147	present	2026-03-02 15:43:44.318533
2262	25	2025-12-24	2025-12-24 09:29:52.209689	2025-12-24 17:49:52.203832	present	2026-03-02 15:43:44.318533
2263	26	2025-12-24	2025-12-24 09:14:57.02074	2025-12-24 17:03:09.94106	present	2026-03-02 15:43:44.318533
2264	28	2025-12-24	2025-12-24 09:08:38.151296	2025-12-24 17:49:26.745997	present	2026-03-02 15:43:44.318533
2265	29	2025-12-24	2025-12-24 09:16:43.983719	2025-12-24 17:27:59.706561	present	2026-03-02 15:43:44.318533
2266	30	2025-12-24	2025-12-24 09:52:45.273962	2025-12-24 17:42:33.782804	present	2026-03-02 15:43:44.318533
2267	31	2025-12-24	2025-12-24 09:00:58.587741	2025-12-24 17:21:23.551655	present	2026-03-02 15:43:44.318533
2268	32	2025-12-24	2025-12-24 09:03:29.132984	2025-12-24 17:37:50.811463	present	2026-03-02 15:43:44.318533
2269	34	2025-12-24	2025-12-24 09:47:25.347507	2025-12-24 17:25:58.537673	present	2026-03-02 15:43:44.318533
2270	36	2025-12-24	2025-12-24 09:28:36.015878	2025-12-24 17:45:03.111105	present	2026-03-02 15:43:44.318533
2271	38	2025-12-24	2025-12-24 09:10:33.837794	2025-12-24 17:51:10.438948	present	2026-03-02 15:43:44.318533
2272	39	2025-12-24	2025-12-24 09:38:30.370803	2025-12-24 17:59:07.373826	present	2026-03-02 15:43:44.318533
2273	40	2025-12-24	2025-12-24 09:16:50.687339	2025-12-24 17:53:52.408065	present	2026-03-02 15:43:44.318533
2274	41	2025-12-24	2025-12-24 09:48:28.08991	2025-12-24 17:19:57.460988	present	2026-03-02 15:43:44.318533
2275	42	2025-12-24	2025-12-24 09:32:20.976564	2025-12-24 17:00:05.764403	present	2026-03-02 15:43:44.318533
2276	44	2025-12-24	2025-12-24 09:28:49.314162	2025-12-24 17:11:15.687503	present	2026-03-02 15:43:44.318533
2277	49	2025-12-24	2025-12-24 09:58:45.321899	2025-12-24 17:06:17.846883	present	2026-03-02 15:43:44.318533
2278	51	2025-12-24	2025-12-24 09:25:29.130481	2025-12-24 17:29:26.299309	present	2026-03-02 15:43:44.318533
2279	53	2025-12-24	2025-12-24 09:45:21.418072	2025-12-24 17:41:15.450907	present	2026-03-02 15:43:44.318533
2280	54	2025-12-24	2025-12-24 09:50:36.377832	2025-12-24 17:21:19.256715	present	2026-03-02 15:43:44.318533
2281	55	2025-12-24	2025-12-24 09:55:55.450339	2025-12-24 17:54:12.806523	present	2026-03-02 15:43:44.318533
2282	56	2025-12-24	2025-12-24 09:32:02.787802	2025-12-24 17:36:39.805702	present	2026-03-02 15:43:44.318533
2283	57	2025-12-24	2025-12-24 09:30:38.245307	2025-12-24 17:25:50.266119	present	2026-03-02 15:43:44.318533
2284	58	2025-12-24	2025-12-24 09:54:46.064906	2025-12-24 17:06:17.817419	present	2026-03-02 15:43:44.318533
2285	61	2025-12-24	2025-12-24 09:45:19.21345	2025-12-24 17:04:49.889813	present	2026-03-02 15:43:44.318533
2286	67	2025-12-24	2025-12-24 09:31:37.296755	2025-12-24 17:20:53.498475	present	2026-03-02 15:43:44.318533
2287	68	2025-12-24	2025-12-24 09:10:24.604485	2025-12-24 17:49:38.094315	present	2026-03-02 15:43:44.318533
2288	69	2025-12-24	2025-12-24 09:44:10.857125	2025-12-24 17:35:01.404601	present	2026-03-02 15:43:44.318533
2289	72	2025-12-24	2025-12-24 09:08:46.067173	2025-12-24 17:10:13.791065	present	2026-03-02 15:43:44.318533
2290	75	2025-12-24	2025-12-24 09:53:23.707459	2025-12-24 17:06:31.557624	present	2026-03-02 15:43:44.318533
2291	76	2025-12-24	2025-12-24 09:20:28.168601	2025-12-24 17:34:55.893157	present	2026-03-02 15:43:44.318533
2292	77	2025-12-24	2025-12-24 09:40:23.87091	2025-12-24 17:00:15.344127	present	2026-03-02 15:43:44.318533
2293	80	2025-12-24	2025-12-24 09:07:46.587596	2025-12-24 17:58:44.519268	present	2026-03-02 15:43:44.318533
2294	81	2025-12-24	2025-12-24 09:36:32.717568	2025-12-24 17:34:04.258092	present	2026-03-02 15:43:44.318533
2295	86	2025-12-24	2025-12-24 09:59:18.377826	2025-12-24 17:46:10.833246	present	2026-03-02 15:43:44.318533
2296	87	2025-12-24	2025-12-24 09:42:14.079639	2025-12-24 17:25:19.808699	present	2026-03-02 15:43:44.318533
2297	90	2025-12-24	2025-12-24 09:18:04.51541	2025-12-24 17:49:42.045347	present	2026-03-02 15:43:44.318533
2298	91	2025-12-24	2025-12-24 09:14:54.618833	2025-12-24 17:15:23.924488	present	2026-03-02 15:43:44.318533
2299	92	2025-12-24	2025-12-24 09:45:06.66795	2025-12-24 17:30:47.814439	present	2026-03-02 15:43:44.318533
2300	93	2025-12-24	2025-12-24 09:27:57.079342	2025-12-24 17:13:06.12997	present	2026-03-02 15:43:44.318533
2301	94	2025-12-24	2025-12-24 09:19:44.109153	2025-12-24 17:42:45.016875	present	2026-03-02 15:43:44.318533
2302	95	2025-12-24	2025-12-24 09:19:46.498139	2025-12-24 17:40:44.927669	present	2026-03-02 15:43:44.318533
2303	98	2025-12-24	2025-12-24 09:18:24.637335	2025-12-24 17:54:03.500405	present	2026-03-02 15:43:44.318533
2304	99	2025-12-24	2025-12-24 09:36:04.937895	2025-12-24 17:39:58.493793	present	2026-03-02 15:43:44.318533
2305	100	2025-12-24	2025-12-24 09:44:00.425285	2025-12-24 17:28:16.280017	present	2026-03-02 15:43:44.318533
2306	3	2025-12-25	2025-12-25 09:12:46.235126	2025-12-25 17:20:47.294138	present	2026-03-02 15:43:44.318533
2307	4	2025-12-25	2025-12-25 09:59:35.550352	2025-12-25 17:52:43.737685	present	2026-03-02 15:43:44.318533
2308	5	2025-12-25	2025-12-25 09:04:55.963131	2025-12-25 17:55:26.329848	present	2026-03-02 15:43:44.318533
2309	6	2025-12-25	2025-12-25 09:43:27.916408	2025-12-25 17:39:17.045297	present	2026-03-02 15:43:44.318533
2310	10	2025-12-25	2025-12-25 09:10:49.909186	2025-12-25 17:14:27.950545	present	2026-03-02 15:43:44.318533
2311	11	2025-12-25	2025-12-25 09:32:34.80773	2025-12-25 17:43:00.1201	present	2026-03-02 15:43:44.318533
2312	27	2025-12-25	2025-12-25 09:39:14.408739	2025-12-25 17:16:08.106254	present	2026-03-02 15:43:44.318533
2313	33	2025-12-25	2025-12-25 09:39:23.890913	2025-12-25 17:43:37.214106	present	2026-03-02 15:43:44.318533
2314	35	2025-12-25	2025-12-25 09:35:36.204574	2025-12-25 17:03:52.426826	present	2026-03-02 15:43:44.318533
2315	37	2025-12-25	2025-12-25 09:18:22.89573	2025-12-25 17:59:41.015931	present	2026-03-02 15:43:44.318533
2316	43	2025-12-25	2025-12-25 09:19:17.849964	2025-12-25 17:09:56.859817	present	2026-03-02 15:43:44.318533
2317	45	2025-12-25	2025-12-25 09:59:10.63473	2025-12-25 17:45:10.71197	present	2026-03-02 15:43:44.318533
2318	46	2025-12-25	2025-12-25 09:05:31.420808	2025-12-25 17:02:16.108815	present	2026-03-02 15:43:44.318533
2319	47	2025-12-25	2025-12-25 09:35:54.248074	2025-12-25 17:44:56.482627	present	2026-03-02 15:43:44.318533
2320	48	2025-12-25	2025-12-25 09:42:35.683459	2025-12-25 17:09:21.520776	present	2026-03-02 15:43:44.318533
2321	50	2025-12-25	2025-12-25 09:05:26.324469	2025-12-25 17:38:34.191653	present	2026-03-02 15:43:44.318533
2322	52	2025-12-25	2025-12-25 09:44:46.346455	2025-12-25 17:38:54.539627	present	2026-03-02 15:43:44.318533
2323	59	2025-12-25	2025-12-25 09:01:19.037357	2025-12-25 17:35:16.954717	present	2026-03-02 15:43:44.318533
2324	60	2025-12-25	2025-12-25 09:37:54.692815	2025-12-25 17:18:57.528716	present	2026-03-02 15:43:44.318533
2325	62	2025-12-25	2025-12-25 09:51:17.230267	2025-12-25 17:05:33.645569	present	2026-03-02 15:43:44.318533
2326	63	2025-12-25	2025-12-25 09:28:11.037126	2025-12-25 17:02:25.686961	present	2026-03-02 15:43:44.318533
2327	64	2025-12-25	2025-12-25 09:46:55.674672	2025-12-25 17:42:08.585544	present	2026-03-02 15:43:44.318533
2328	65	2025-12-25	2025-12-25 09:28:08.334444	2025-12-25 17:27:55.881035	present	2026-03-02 15:43:44.318533
2329	66	2025-12-25	2025-12-25 09:06:05.184975	2025-12-25 17:18:42.373707	present	2026-03-02 15:43:44.318533
2330	70	2025-12-25	2025-12-25 09:31:54.115837	2025-12-25 17:40:51.416073	present	2026-03-02 15:43:44.318533
2331	71	2025-12-25	2025-12-25 09:36:58.629081	2025-12-25 17:19:40.940938	present	2026-03-02 15:43:44.318533
2332	73	2025-12-25	2025-12-25 09:40:08.432221	2025-12-25 17:50:41.541121	present	2026-03-02 15:43:44.318533
2333	74	2025-12-25	2025-12-25 09:53:18.576136	2025-12-25 17:32:45.836023	present	2026-03-02 15:43:44.318533
2334	78	2025-12-25	2025-12-25 09:57:53.125158	2025-12-25 17:57:29.220466	present	2026-03-02 15:43:44.318533
2335	79	2025-12-25	2025-12-25 09:34:16.633301	2025-12-25 17:10:51.428093	present	2026-03-02 15:43:44.318533
2336	82	2025-12-25	2025-12-25 09:09:02.721261	2025-12-25 17:18:07.378534	present	2026-03-02 15:43:44.318533
2337	83	2025-12-25	2025-12-25 09:34:26.352185	2025-12-25 17:08:12.617415	present	2026-03-02 15:43:44.318533
2338	84	2025-12-25	2025-12-25 09:26:53.077028	2025-12-25 17:38:26.207649	present	2026-03-02 15:43:44.318533
2339	85	2025-12-25	2025-12-25 09:40:12.666075	2025-12-25 17:28:52.899459	present	2026-03-02 15:43:44.318533
2340	88	2025-12-25	2025-12-25 09:32:45.146071	2025-12-25 17:11:58.43852	present	2026-03-02 15:43:44.318533
2341	89	2025-12-25	2025-12-25 09:25:38.056326	2025-12-25 17:43:46.326542	present	2026-03-02 15:43:44.318533
2342	96	2025-12-25	2025-12-25 09:43:01.668419	2025-12-25 17:30:25.768998	present	2026-03-02 15:43:44.318533
2343	97	2025-12-25	2025-12-25 09:02:08.661423	2025-12-25 17:10:36.726378	present	2026-03-02 15:43:44.318533
2344	1	2025-12-25	2025-12-25 09:53:16.397752	2025-12-25 17:47:37.820534	present	2026-03-02 15:43:44.318533
2345	2	2025-12-25	2025-12-25 09:02:29.207306	2025-12-25 17:31:32.433744	present	2026-03-02 15:43:44.318533
2346	7	2025-12-25	2025-12-25 09:46:42.549683	2025-12-25 17:36:21.278668	present	2026-03-02 15:43:44.318533
2347	8	2025-12-25	2025-12-25 09:53:27.274962	2025-12-25 17:08:36.064242	present	2026-03-02 15:43:44.318533
2348	9	2025-12-25	2025-12-25 09:48:39.956028	2025-12-25 17:16:15.998266	present	2026-03-02 15:43:44.318533
2349	12	2025-12-25	2025-12-25 09:20:08.188277	2025-12-25 17:59:12.219128	present	2026-03-02 15:43:44.318533
2350	13	2025-12-25	2025-12-25 09:07:13.593447	2025-12-25 17:06:52.497786	present	2026-03-02 15:43:44.318533
2351	14	2025-12-25	2025-12-25 09:44:41.103858	2025-12-25 17:26:19.575773	present	2026-03-02 15:43:44.318533
2352	15	2025-12-25	2025-12-25 09:11:46.029104	2025-12-25 17:23:19.099388	present	2026-03-02 15:43:44.318533
2353	16	2025-12-25	2025-12-25 09:00:37.038773	2025-12-25 17:11:17.524498	present	2026-03-02 15:43:44.318533
2354	17	2025-12-25	2025-12-25 09:48:44.887836	2025-12-25 17:38:00.174457	present	2026-03-02 15:43:44.318533
2355	18	2025-12-25	2025-12-25 09:55:24.596827	2025-12-25 17:24:53.353432	present	2026-03-02 15:43:44.318533
2356	19	2025-12-25	2025-12-25 09:35:35.080036	2025-12-25 17:19:31.252926	present	2026-03-02 15:43:44.318533
2357	20	2025-12-25	2025-12-25 09:15:47.868419	2025-12-25 17:41:09.875579	present	2026-03-02 15:43:44.318533
2358	21	2025-12-25	2025-12-25 09:39:46.165243	2025-12-25 17:08:02.513448	present	2026-03-02 15:43:44.318533
2359	22	2025-12-25	2025-12-25 09:45:04.182374	2025-12-25 17:36:20.399598	present	2026-03-02 15:43:44.318533
2360	23	2025-12-25	2025-12-25 09:28:09.214839	2025-12-25 17:47:37.215663	present	2026-03-02 15:43:44.318533
2361	24	2025-12-25	2025-12-25 09:10:11.945022	2025-12-25 17:44:43.617576	present	2026-03-02 15:43:44.318533
2362	25	2025-12-25	2025-12-25 09:20:06.775379	2025-12-25 17:28:46.281238	present	2026-03-02 15:43:44.318533
2363	26	2025-12-25	2025-12-25 09:00:43.41904	2025-12-25 17:30:43.663358	present	2026-03-02 15:43:44.318533
2364	28	2025-12-25	2025-12-25 09:02:37.010486	2025-12-25 17:58:04.961142	present	2026-03-02 15:43:44.318533
2365	29	2025-12-25	2025-12-25 09:08:20.8751	2025-12-25 17:14:47.172797	present	2026-03-02 15:43:44.318533
2366	30	2025-12-25	2025-12-25 09:05:33.000069	2025-12-25 17:42:26.469465	present	2026-03-02 15:43:44.318533
2367	31	2025-12-25	2025-12-25 09:18:15.165434	2025-12-25 17:04:11.810581	present	2026-03-02 15:43:44.318533
2368	32	2025-12-25	2025-12-25 09:22:29.899335	2025-12-25 17:50:00.580189	present	2026-03-02 15:43:44.318533
2369	34	2025-12-25	2025-12-25 09:47:16.707274	2025-12-25 17:06:35.488295	present	2026-03-02 15:43:44.318533
2370	36	2025-12-25	2025-12-25 09:38:00.070915	2025-12-25 17:57:01.260496	present	2026-03-02 15:43:44.318533
2371	38	2025-12-25	2025-12-25 09:06:34.877183	2025-12-25 17:33:39.476088	present	2026-03-02 15:43:44.318533
2372	39	2025-12-25	2025-12-25 09:01:06.620588	2025-12-25 17:21:03.537503	present	2026-03-02 15:43:44.318533
2373	40	2025-12-25	2025-12-25 09:57:02.889031	2025-12-25 17:18:50.423408	present	2026-03-02 15:43:44.318533
2374	41	2025-12-25	2025-12-25 09:00:39.71642	2025-12-25 17:11:44.542105	present	2026-03-02 15:43:44.318533
2375	42	2025-12-25	2025-12-25 09:44:45.071774	2025-12-25 17:28:03.464863	present	2026-03-02 15:43:44.318533
2376	44	2025-12-25	2025-12-25 09:06:38.919109	2025-12-25 17:56:42.108362	present	2026-03-02 15:43:44.318533
2377	49	2025-12-25	2025-12-25 09:19:16.617692	2025-12-25 17:07:08.433734	present	2026-03-02 15:43:44.318533
2378	51	2025-12-25	2025-12-25 09:54:36.543316	2025-12-25 17:39:22.729511	present	2026-03-02 15:43:44.318533
2379	53	2025-12-25	2025-12-25 09:40:04.823829	2025-12-25 17:47:14.830375	present	2026-03-02 15:43:44.318533
2380	54	2025-12-25	2025-12-25 09:27:45.712086	2025-12-25 17:43:34.730319	present	2026-03-02 15:43:44.318533
2381	55	2025-12-25	2025-12-25 09:47:23.539541	2025-12-25 17:08:08.057392	present	2026-03-02 15:43:44.318533
2382	56	2025-12-25	2025-12-25 09:28:31.090062	2025-12-25 17:53:46.075486	present	2026-03-02 15:43:44.318533
2383	57	2025-12-25	2025-12-25 09:14:49.629821	2025-12-25 17:40:24.22174	present	2026-03-02 15:43:44.318533
2384	58	2025-12-25	2025-12-25 09:08:59.373991	2025-12-25 17:20:25.451188	present	2026-03-02 15:43:44.318533
2385	61	2025-12-25	2025-12-25 09:56:34.763666	2025-12-25 17:32:17.304838	present	2026-03-02 15:43:44.318533
2386	67	2025-12-25	2025-12-25 09:28:38.50921	2025-12-25 17:17:37.231932	present	2026-03-02 15:43:44.318533
2387	68	2025-12-25	2025-12-25 09:24:34.08505	2025-12-25 17:25:30.644058	present	2026-03-02 15:43:44.318533
2388	69	2025-12-25	2025-12-25 09:26:37.644132	2025-12-25 17:12:23.506631	present	2026-03-02 15:43:44.318533
2389	72	2025-12-25	2025-12-25 09:06:18.131962	2025-12-25 17:00:31.690535	present	2026-03-02 15:43:44.318533
2390	75	2025-12-25	2025-12-25 09:06:35.252526	2025-12-25 17:40:27.209805	present	2026-03-02 15:43:44.318533
2391	76	2025-12-25	2025-12-25 09:54:03.629093	2025-12-25 17:01:29.679255	present	2026-03-02 15:43:44.318533
2392	77	2025-12-25	2025-12-25 09:57:47.84204	2025-12-25 17:05:33.055303	present	2026-03-02 15:43:44.318533
2393	80	2025-12-25	2025-12-25 09:23:49.997973	2025-12-25 17:59:28.306166	present	2026-03-02 15:43:44.318533
2394	81	2025-12-25	2025-12-25 09:47:54.957902	2025-12-25 17:18:34.172957	present	2026-03-02 15:43:44.318533
2395	86	2025-12-25	2025-12-25 09:37:37.633616	2025-12-25 17:34:24.113127	present	2026-03-02 15:43:44.318533
2396	87	2025-12-25	2025-12-25 09:46:21.570108	2025-12-25 17:41:28.160822	present	2026-03-02 15:43:44.318533
2397	90	2025-12-25	2025-12-25 09:46:09.98737	2025-12-25 17:43:00.665499	present	2026-03-02 15:43:44.318533
2398	91	2025-12-25	2025-12-25 09:31:15.60331	2025-12-25 17:40:43.678069	present	2026-03-02 15:43:44.318533
2399	92	2025-12-25	2025-12-25 09:13:19.793101	2025-12-25 17:34:23.767958	present	2026-03-02 15:43:44.318533
2400	93	2025-12-25	2025-12-25 09:02:16.900516	2025-12-25 17:29:56.740153	present	2026-03-02 15:43:44.318533
2401	94	2025-12-25	2025-12-25 09:38:57.36869	2025-12-25 17:08:39.131502	present	2026-03-02 15:43:44.318533
2402	95	2025-12-25	2025-12-25 09:46:44.414318	2025-12-25 17:10:17.67385	present	2026-03-02 15:43:44.318533
2403	98	2025-12-25	2025-12-25 09:37:27.965651	2025-12-25 17:46:09.577165	present	2026-03-02 15:43:44.318533
2404	99	2025-12-25	2025-12-25 09:26:36.780465	2025-12-25 17:54:08.764417	present	2026-03-02 15:43:44.318533
2405	100	2025-12-25	2025-12-25 09:58:24.630208	2025-12-25 17:32:26.680186	present	2026-03-02 15:43:44.318533
2406	3	2025-12-26	2025-12-26 09:17:26.849475	2025-12-26 17:11:36.135929	present	2026-03-02 15:43:44.318533
2407	4	2025-12-26	2025-12-26 09:48:54.425474	2025-12-26 17:10:44.223876	present	2026-03-02 15:43:44.318533
2408	5	2025-12-26	2025-12-26 09:29:57.65872	2025-12-26 17:04:26.503915	present	2026-03-02 15:43:44.318533
2409	6	2025-12-26	2025-12-26 09:30:41.706574	2025-12-26 17:19:56.179039	present	2026-03-02 15:43:44.318533
2410	10	2025-12-26	2025-12-26 09:26:33.833692	2025-12-26 17:23:43.762466	present	2026-03-02 15:43:44.318533
2411	11	2025-12-26	2025-12-26 09:37:25.750727	2025-12-26 17:02:47.151808	present	2026-03-02 15:43:44.318533
2412	27	2025-12-26	2025-12-26 09:47:27.882655	2025-12-26 17:56:08.906884	present	2026-03-02 15:43:44.318533
2413	33	2025-12-26	2025-12-26 09:33:12.621189	2025-12-26 17:22:53.6553	present	2026-03-02 15:43:44.318533
2414	35	2025-12-26	2025-12-26 09:56:15.762352	2025-12-26 17:23:53.181397	present	2026-03-02 15:43:44.318533
2415	37	2025-12-26	2025-12-26 09:17:30.544917	2025-12-26 17:40:26.061215	present	2026-03-02 15:43:44.318533
2416	43	2025-12-26	2025-12-26 09:29:06.122184	2025-12-26 17:31:09.161408	present	2026-03-02 15:43:44.318533
2417	45	2025-12-26	2025-12-26 09:37:09.026481	2025-12-26 17:44:30.905192	present	2026-03-02 15:43:44.318533
2418	46	2025-12-26	2025-12-26 09:54:06.098032	2025-12-26 17:45:11.128226	present	2026-03-02 15:43:44.318533
2419	47	2025-12-26	2025-12-26 09:12:28.296929	2025-12-26 17:27:54.350685	present	2026-03-02 15:43:44.318533
2420	48	2025-12-26	2025-12-26 09:17:05.755117	2025-12-26 17:43:03.295386	present	2026-03-02 15:43:44.318533
2421	50	2025-12-26	2025-12-26 09:20:00.970401	2025-12-26 17:36:00.481322	present	2026-03-02 15:43:44.318533
2422	52	2025-12-26	2025-12-26 09:15:35.847181	2025-12-26 17:54:32.515974	present	2026-03-02 15:43:44.318533
2423	59	2025-12-26	2025-12-26 09:12:33.053096	2025-12-26 17:26:15.339154	present	2026-03-02 15:43:44.318533
2424	60	2025-12-26	2025-12-26 09:46:03.232581	2025-12-26 17:41:05.462284	present	2026-03-02 15:43:44.318533
2425	62	2025-12-26	2025-12-26 09:57:12.702278	2025-12-26 17:24:45.102211	present	2026-03-02 15:43:44.318533
2426	63	2025-12-26	2025-12-26 09:52:16.239278	2025-12-26 17:59:01.587717	present	2026-03-02 15:43:44.318533
2427	64	2025-12-26	2025-12-26 09:51:36.695145	2025-12-26 17:58:52.226604	present	2026-03-02 15:43:44.318533
2428	65	2025-12-26	2025-12-26 09:04:49.025635	2025-12-26 17:03:07.101839	present	2026-03-02 15:43:44.318533
2429	66	2025-12-26	2025-12-26 09:53:34.823842	2025-12-26 17:41:58.278761	present	2026-03-02 15:43:44.318533
2430	70	2025-12-26	2025-12-26 09:00:03.782006	2025-12-26 17:52:27.481542	present	2026-03-02 15:43:44.318533
2431	71	2025-12-26	2025-12-26 09:23:52.126529	2025-12-26 17:45:46.164405	present	2026-03-02 15:43:44.318533
2432	73	2025-12-26	2025-12-26 09:03:56.227455	2025-12-26 17:40:26.577802	present	2026-03-02 15:43:44.318533
2433	74	2025-12-26	2025-12-26 09:52:30.522946	2025-12-26 17:18:01.364608	present	2026-03-02 15:43:44.318533
2434	78	2025-12-26	2025-12-26 09:30:40.152035	2025-12-26 17:03:56.157303	present	2026-03-02 15:43:44.318533
2435	79	2025-12-26	2025-12-26 09:11:49.639742	2025-12-26 17:39:44.791396	present	2026-03-02 15:43:44.318533
2436	82	2025-12-26	2025-12-26 09:36:38.390518	2025-12-26 17:57:05.379013	present	2026-03-02 15:43:44.318533
2437	83	2025-12-26	2025-12-26 09:24:37.820529	2025-12-26 17:28:05.334043	present	2026-03-02 15:43:44.318533
2438	84	2025-12-26	2025-12-26 09:16:14.123062	2025-12-26 17:05:39.164655	present	2026-03-02 15:43:44.318533
2439	85	2025-12-26	2025-12-26 09:38:26.923705	2025-12-26 17:35:16.647775	present	2026-03-02 15:43:44.318533
2440	88	2025-12-26	2025-12-26 09:50:22.809043	2025-12-26 17:44:20.688797	present	2026-03-02 15:43:44.318533
2441	89	2025-12-26	2025-12-26 09:29:57.398911	2025-12-26 17:47:30.863662	present	2026-03-02 15:43:44.318533
2442	96	2025-12-26	2025-12-26 09:59:29.750363	2025-12-26 17:02:32.143023	present	2026-03-02 15:43:44.318533
2443	97	2025-12-26	2025-12-26 09:09:48.331803	2025-12-26 17:17:33.98812	present	2026-03-02 15:43:44.318533
2444	1	2025-12-26	2025-12-26 09:57:31.54013	2025-12-26 17:34:04.417097	present	2026-03-02 15:43:44.318533
2445	2	2025-12-26	2025-12-26 09:50:44.399855	2025-12-26 17:31:43.93672	present	2026-03-02 15:43:44.318533
2446	7	2025-12-26	2025-12-26 09:31:38.136097	2025-12-26 17:44:44.880784	present	2026-03-02 15:43:44.318533
2447	8	2025-12-26	2025-12-26 09:48:20.958415	2025-12-26 17:16:04.534615	present	2026-03-02 15:43:44.318533
2448	9	2025-12-26	2025-12-26 09:28:29.04813	2025-12-26 17:40:37.85602	present	2026-03-02 15:43:44.318533
2449	12	2025-12-26	2025-12-26 09:09:36.879757	2025-12-26 17:08:44.14436	present	2026-03-02 15:43:44.318533
2450	13	2025-12-26	2025-12-26 09:44:26.467778	2025-12-26 17:02:13.98819	present	2026-03-02 15:43:44.318533
2451	14	2025-12-26	2025-12-26 09:09:39.361384	2025-12-26 17:21:57.842904	present	2026-03-02 15:43:44.318533
2452	15	2025-12-26	2025-12-26 09:37:21.382496	2025-12-26 17:53:38.556224	present	2026-03-02 15:43:44.318533
2453	16	2025-12-26	2025-12-26 09:41:44.629753	2025-12-26 17:33:55.089297	present	2026-03-02 15:43:44.318533
2454	17	2025-12-26	2025-12-26 09:01:45.997718	2025-12-26 17:15:28.057258	present	2026-03-02 15:43:44.318533
2455	18	2025-12-26	2025-12-26 09:56:49.948877	2025-12-26 17:40:48.009284	present	2026-03-02 15:43:44.318533
2456	19	2025-12-26	2025-12-26 09:15:00.777257	2025-12-26 17:44:48.920678	present	2026-03-02 15:43:44.318533
2457	20	2025-12-26	2025-12-26 09:14:43.302772	2025-12-26 17:28:32.747306	present	2026-03-02 15:43:44.318533
2458	21	2025-12-26	2025-12-26 09:11:05.499149	2025-12-26 17:16:45.906105	present	2026-03-02 15:43:44.318533
2459	22	2025-12-26	2025-12-26 09:50:01.483124	2025-12-26 17:26:47.582291	present	2026-03-02 15:43:44.318533
2460	23	2025-12-26	2025-12-26 09:33:24.693748	2025-12-26 17:27:02.412383	present	2026-03-02 15:43:44.318533
2461	24	2025-12-26	2025-12-26 09:16:04.174969	2025-12-26 17:08:18.130868	present	2026-03-02 15:43:44.318533
2462	25	2025-12-26	2025-12-26 09:42:13.041158	2025-12-26 17:36:21.770265	present	2026-03-02 15:43:44.318533
2463	26	2025-12-26	2025-12-26 09:27:24.802728	2025-12-26 17:49:19.669526	present	2026-03-02 15:43:44.318533
2464	28	2025-12-26	2025-12-26 09:42:19.307632	2025-12-26 17:02:19.459081	present	2026-03-02 15:43:44.318533
2465	29	2025-12-26	2025-12-26 09:12:07.096707	2025-12-26 17:06:02.584981	present	2026-03-02 15:43:44.318533
2466	30	2025-12-26	2025-12-26 09:50:21.950859	2025-12-26 17:06:13.366281	present	2026-03-02 15:43:44.318533
2467	31	2025-12-26	2025-12-26 09:51:54.977383	2025-12-26 17:20:16.127164	present	2026-03-02 15:43:44.318533
2468	32	2025-12-26	2025-12-26 09:50:27.473402	2025-12-26 17:50:42.87766	present	2026-03-02 15:43:44.318533
2469	34	2025-12-26	2025-12-26 09:07:23.228012	2025-12-26 17:15:19.511584	present	2026-03-02 15:43:44.318533
2470	36	2025-12-26	2025-12-26 09:32:33.49476	2025-12-26 17:11:18.977304	present	2026-03-02 15:43:44.318533
2471	38	2025-12-26	2025-12-26 09:51:43.220876	2025-12-26 17:13:07.272861	present	2026-03-02 15:43:44.318533
2472	39	2025-12-26	2025-12-26 09:41:31.322653	2025-12-26 17:14:36.269468	present	2026-03-02 15:43:44.318533
2473	40	2025-12-26	2025-12-26 09:23:05.079125	2025-12-26 17:56:33.342373	present	2026-03-02 15:43:44.318533
2474	41	2025-12-26	2025-12-26 09:56:24.969958	2025-12-26 17:14:51.303649	present	2026-03-02 15:43:44.318533
2475	42	2025-12-26	2025-12-26 09:04:31.482636	2025-12-26 17:35:24.278872	present	2026-03-02 15:43:44.318533
2476	44	2025-12-26	2025-12-26 09:13:55.684055	2025-12-26 17:23:19.159625	present	2026-03-02 15:43:44.318533
2477	49	2025-12-26	2025-12-26 09:18:48.594384	2025-12-26 17:06:22.471924	present	2026-03-02 15:43:44.318533
2478	51	2025-12-26	2025-12-26 09:00:01.159098	2025-12-26 17:48:23.073923	present	2026-03-02 15:43:44.318533
2479	53	2025-12-26	2025-12-26 09:36:51.022188	2025-12-26 17:45:12.247858	present	2026-03-02 15:43:44.318533
2480	54	2025-12-26	2025-12-26 09:39:31.3056	2025-12-26 17:39:23.566625	present	2026-03-02 15:43:44.318533
2481	55	2025-12-26	2025-12-26 09:40:50.887578	2025-12-26 17:37:33.135222	present	2026-03-02 15:43:44.318533
2482	56	2025-12-26	2025-12-26 09:50:24.973232	2025-12-26 17:37:01.591129	present	2026-03-02 15:43:44.318533
2483	57	2025-12-26	2025-12-26 09:35:00.387041	2025-12-26 17:16:48.961523	present	2026-03-02 15:43:44.318533
2484	58	2025-12-26	2025-12-26 09:15:10.549605	2025-12-26 17:15:34.455822	present	2026-03-02 15:43:44.318533
2485	61	2025-12-26	2025-12-26 09:26:54.889748	2025-12-26 17:10:50.570296	present	2026-03-02 15:43:44.318533
2486	67	2025-12-26	2025-12-26 09:05:06.24207	2025-12-26 17:19:27.304633	present	2026-03-02 15:43:44.318533
2487	68	2025-12-26	2025-12-26 09:26:42.335387	2025-12-26 17:22:42.692784	present	2026-03-02 15:43:44.318533
2488	69	2025-12-26	2025-12-26 09:43:44.32717	2025-12-26 17:19:42.47965	present	2026-03-02 15:43:44.318533
2489	72	2025-12-26	2025-12-26 09:01:43.437273	2025-12-26 17:16:59.618442	present	2026-03-02 15:43:44.318533
2490	75	2025-12-26	2025-12-26 09:35:01.966539	2025-12-26 17:54:54.063154	present	2026-03-02 15:43:44.318533
2491	76	2025-12-26	2025-12-26 09:16:23.070316	2025-12-26 17:50:35.2445	present	2026-03-02 15:43:44.318533
2492	77	2025-12-26	2025-12-26 09:51:55.881475	2025-12-26 17:49:23.790169	present	2026-03-02 15:43:44.318533
2493	80	2025-12-26	2025-12-26 09:02:13.814703	2025-12-26 17:00:12.296836	present	2026-03-02 15:43:44.318533
2494	81	2025-12-26	2025-12-26 09:22:47.262913	2025-12-26 17:24:28.733394	present	2026-03-02 15:43:44.318533
2495	86	2025-12-26	2025-12-26 09:59:14.408306	2025-12-26 17:21:10.106705	present	2026-03-02 15:43:44.318533
2496	87	2025-12-26	2025-12-26 09:59:07.910949	2025-12-26 17:28:58.443948	present	2026-03-02 15:43:44.318533
2497	90	2025-12-26	2025-12-26 09:01:20.407607	2025-12-26 17:56:54.582177	present	2026-03-02 15:43:44.318533
2498	91	2025-12-26	2025-12-26 09:48:58.31975	2025-12-26 17:09:00.073827	present	2026-03-02 15:43:44.318533
2499	92	2025-12-26	2025-12-26 09:35:44.550174	2025-12-26 17:14:48.387197	present	2026-03-02 15:43:44.318533
2500	93	2025-12-26	2025-12-26 09:26:16.452827	2025-12-26 17:04:09.053168	present	2026-03-02 15:43:44.318533
2501	94	2025-12-26	2025-12-26 09:24:13.951878	2025-12-26 17:07:31.863976	present	2026-03-02 15:43:44.318533
2502	95	2025-12-26	2025-12-26 09:36:18.512686	2025-12-26 17:07:40.110585	present	2026-03-02 15:43:44.318533
2503	98	2025-12-26	2025-12-26 09:23:51.05323	2025-12-26 17:19:17.502982	present	2026-03-02 15:43:44.318533
2504	99	2025-12-26	2025-12-26 09:35:34.618797	2025-12-26 17:04:22.878638	present	2026-03-02 15:43:44.318533
2505	100	2025-12-26	2025-12-26 09:03:07.668865	2025-12-26 17:28:45.358452	present	2026-03-02 15:43:44.318533
2506	3	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2507	4	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2508	5	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2509	6	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2510	10	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2511	11	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2512	27	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2513	33	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2514	35	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2515	37	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2516	43	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2517	45	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2518	46	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2519	47	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2520	48	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2521	50	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2522	52	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2523	59	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2524	60	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2525	62	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2526	63	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2527	64	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2528	65	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2529	66	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2530	70	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2531	71	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2532	73	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2533	74	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2534	78	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2535	79	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2536	82	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2537	83	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2538	84	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2539	85	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2540	88	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2541	89	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2542	96	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2543	97	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2544	1	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2545	2	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2546	7	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2547	8	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2548	9	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2549	12	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2550	13	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2551	14	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2552	15	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2553	16	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2554	17	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2555	18	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2556	19	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2557	20	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2558	21	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2559	22	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2560	23	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2561	24	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2562	25	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2563	26	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2564	28	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2565	29	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2566	30	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2567	31	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2568	32	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2569	34	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2570	36	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2571	38	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2572	39	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2573	40	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2574	41	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2575	42	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2576	44	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2577	49	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2578	51	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2579	53	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2580	54	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2581	55	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2582	56	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2583	57	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2584	58	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2585	61	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2586	67	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2587	68	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2588	69	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2589	72	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2590	75	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2591	76	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2592	77	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2593	80	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2594	81	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2595	86	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2596	87	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2597	90	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2598	91	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2599	92	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2600	93	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2601	94	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2602	95	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2603	98	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2604	99	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2605	100	2025-12-27	\N	\N	absent	2026-03-02 15:43:44.318533
2606	3	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2607	4	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2608	5	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2609	6	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2610	10	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2611	11	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2612	27	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2613	33	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2614	35	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2615	37	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2616	43	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2617	45	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2618	46	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2619	47	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2620	48	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2621	50	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2622	52	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2623	59	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2624	60	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2625	62	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2626	63	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2627	64	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2628	65	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2629	66	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2630	70	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2631	71	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2632	73	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2633	74	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2634	78	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2635	79	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2636	82	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2637	83	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2638	84	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2639	85	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2641	89	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2642	96	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2643	97	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2644	1	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2645	2	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2646	7	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2647	8	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2648	9	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2649	12	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2650	13	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2651	14	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2652	15	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2653	16	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2654	17	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2655	18	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2656	19	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2657	20	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2658	21	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2659	22	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2660	23	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2661	24	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2662	25	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2663	26	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2664	28	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2665	29	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2666	30	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2667	31	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2668	32	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2669	34	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2670	36	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2671	38	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2672	39	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2673	40	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2674	41	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2675	42	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2676	44	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2677	49	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2678	51	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2679	53	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2680	54	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2681	55	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2682	56	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2683	57	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2684	58	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2685	61	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2686	67	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2687	68	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2688	69	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2689	72	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2690	75	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2691	76	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2692	77	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2693	80	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2694	81	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2695	86	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2696	87	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2697	90	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2698	91	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2699	92	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2700	93	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2701	94	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2702	95	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2703	98	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2704	99	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2705	100	2025-12-28	\N	\N	absent	2026-03-02 15:43:44.318533
2706	3	2025-12-29	2025-12-29 09:32:24.646113	2025-12-29 17:42:14.185681	present	2026-03-02 15:43:44.318533
2707	4	2025-12-29	2025-12-29 09:09:39.142882	2025-12-29 17:55:42.779941	present	2026-03-02 15:43:44.318533
2708	5	2025-12-29	2025-12-29 09:46:37.059163	2025-12-29 17:16:32.173016	present	2026-03-02 15:43:44.318533
2709	6	2025-12-29	2025-12-29 09:12:38.153236	2025-12-29 17:17:34.767483	present	2026-03-02 15:43:44.318533
2710	10	2025-12-29	2025-12-29 09:16:45.077718	2025-12-29 17:27:23.784689	present	2026-03-02 15:43:44.318533
2711	11	2025-12-29	2025-12-29 09:45:15.640793	2025-12-29 17:12:58.645437	present	2026-03-02 15:43:44.318533
2712	27	2025-12-29	2025-12-29 09:15:52.670609	2025-12-29 17:58:26.763761	present	2026-03-02 15:43:44.318533
2713	33	2025-12-29	2025-12-29 09:23:04.15391	2025-12-29 17:05:19.606288	present	2026-03-02 15:43:44.318533
2714	35	2025-12-29	2025-12-29 09:03:42.135545	2025-12-29 17:12:30.812088	present	2026-03-02 15:43:44.318533
2715	37	2025-12-29	2025-12-29 09:56:12.469053	2025-12-29 17:20:17.50851	present	2026-03-02 15:43:44.318533
2716	43	2025-12-29	2025-12-29 09:49:09.904697	2025-12-29 17:08:59.838345	present	2026-03-02 15:43:44.318533
2717	45	2025-12-29	2025-12-29 09:15:56.745366	2025-12-29 17:41:42.994037	present	2026-03-02 15:43:44.318533
2718	46	2025-12-29	2025-12-29 09:10:54.923812	2025-12-29 17:55:29.666643	present	2026-03-02 15:43:44.318533
2719	47	2025-12-29	2025-12-29 09:58:53.120593	2025-12-29 17:46:07.958609	present	2026-03-02 15:43:44.318533
2720	48	2025-12-29	2025-12-29 09:07:38.503441	2025-12-29 17:50:19.189287	present	2026-03-02 15:43:44.318533
2721	50	2025-12-29	2025-12-29 09:15:43.807711	2025-12-29 17:41:14.010023	present	2026-03-02 15:43:44.318533
2722	52	2025-12-29	2025-12-29 09:32:04.128978	2025-12-29 17:50:47.15569	present	2026-03-02 15:43:44.318533
2723	59	2025-12-29	2025-12-29 09:55:41.439663	2025-12-29 17:38:16.61331	present	2026-03-02 15:43:44.318533
2724	60	2025-12-29	2025-12-29 09:45:33.914722	2025-12-29 17:59:29.728337	present	2026-03-02 15:43:44.318533
2725	62	2025-12-29	2025-12-29 09:06:04.984442	2025-12-29 17:23:51.910401	present	2026-03-02 15:43:44.318533
2726	63	2025-12-29	2025-12-29 09:18:39.047462	2025-12-29 17:24:25.644474	present	2026-03-02 15:43:44.318533
2727	64	2025-12-29	2025-12-29 09:23:30.427831	2025-12-29 17:37:00.3681	present	2026-03-02 15:43:44.318533
2728	65	2025-12-29	2025-12-29 09:37:47.803068	2025-12-29 17:00:23.02584	present	2026-03-02 15:43:44.318533
2729	66	2025-12-29	2025-12-29 09:35:37.430618	2025-12-29 17:49:47.23944	present	2026-03-02 15:43:44.318533
2730	70	2025-12-29	2025-12-29 09:50:39.592641	2025-12-29 17:41:12.020912	present	2026-03-02 15:43:44.318533
2731	71	2025-12-29	2025-12-29 09:31:09.077999	2025-12-29 17:36:12.48262	present	2026-03-02 15:43:44.318533
2732	73	2025-12-29	2025-12-29 09:07:18.722048	2025-12-29 17:04:45.357065	present	2026-03-02 15:43:44.318533
2733	74	2025-12-29	2025-12-29 09:19:50.511044	2025-12-29 17:50:21.198464	present	2026-03-02 15:43:44.318533
2734	78	2025-12-29	2025-12-29 09:55:20.901884	2025-12-29 17:57:46.006347	present	2026-03-02 15:43:44.318533
2735	79	2025-12-29	2025-12-29 09:50:37.492806	2025-12-29 17:05:45.633738	present	2026-03-02 15:43:44.318533
2736	82	2025-12-29	2025-12-29 09:53:00.010206	2025-12-29 17:04:42.474212	present	2026-03-02 15:43:44.318533
2737	83	2025-12-29	2025-12-29 09:34:08.935224	2025-12-29 17:50:41.692147	present	2026-03-02 15:43:44.318533
2738	84	2025-12-29	2025-12-29 09:19:13.075783	2025-12-29 17:34:51.637984	present	2026-03-02 15:43:44.318533
2739	85	2025-12-29	2025-12-29 09:19:03.156739	2025-12-29 17:44:39.579754	present	2026-03-02 15:43:44.318533
2740	88	2025-12-29	2025-12-29 09:04:58.174903	2025-12-29 17:53:32.283262	present	2026-03-02 15:43:44.318533
2741	89	2025-12-29	2025-12-29 09:28:12.462879	2025-12-29 17:46:42.298725	present	2026-03-02 15:43:44.318533
2742	96	2025-12-29	2025-12-29 09:18:36.470138	2025-12-29 17:43:50.263927	present	2026-03-02 15:43:44.318533
2743	97	2025-12-29	2025-12-29 09:12:25.785547	2025-12-29 17:38:24.808366	present	2026-03-02 15:43:44.318533
2744	1	2025-12-29	2025-12-29 09:51:18.125728	2025-12-29 17:18:30.587788	present	2026-03-02 15:43:44.318533
2745	2	2025-12-29	2025-12-29 09:25:34.910922	2025-12-29 17:36:19.457695	present	2026-03-02 15:43:44.318533
2746	7	2025-12-29	2025-12-29 09:12:32.091683	2025-12-29 17:06:32.253384	present	2026-03-02 15:43:44.318533
2747	8	2025-12-29	2025-12-29 09:56:36.486776	2025-12-29 17:07:24.736814	present	2026-03-02 15:43:44.318533
2748	9	2025-12-29	2025-12-29 09:15:33.915309	2025-12-29 17:46:48.807302	present	2026-03-02 15:43:44.318533
2749	12	2025-12-29	2025-12-29 09:23:10.60908	2025-12-29 17:00:11.157978	present	2026-03-02 15:43:44.318533
2750	13	2025-12-29	2025-12-29 09:29:42.421739	2025-12-29 17:02:58.73818	present	2026-03-02 15:43:44.318533
2751	14	2025-12-29	2025-12-29 09:29:12.340318	2025-12-29 17:03:33.759094	present	2026-03-02 15:43:44.318533
2752	15	2025-12-29	2025-12-29 09:24:19.583644	2025-12-29 17:54:51.118861	present	2026-03-02 15:43:44.318533
2753	16	2025-12-29	2025-12-29 09:23:20.225707	2025-12-29 17:13:35.148245	present	2026-03-02 15:43:44.318533
2754	17	2025-12-29	2025-12-29 09:55:53.068438	2025-12-29 17:21:02.637657	present	2026-03-02 15:43:44.318533
2755	18	2025-12-29	2025-12-29 09:31:39.553189	2025-12-29 17:33:24.08136	present	2026-03-02 15:43:44.318533
2756	19	2025-12-29	2025-12-29 09:02:19.230346	2025-12-29 17:21:12.555248	present	2026-03-02 15:43:44.318533
2757	20	2025-12-29	2025-12-29 09:11:53.57149	2025-12-29 17:33:11.902562	present	2026-03-02 15:43:44.318533
2758	21	2025-12-29	2025-12-29 09:09:37.449404	2025-12-29 17:02:47.135708	present	2026-03-02 15:43:44.318533
2759	22	2025-12-29	2025-12-29 09:24:50.170606	2025-12-29 17:20:34.593592	present	2026-03-02 15:43:44.318533
2760	23	2025-12-29	2025-12-29 09:48:59.127865	2025-12-29 17:39:04.946701	present	2026-03-02 15:43:44.318533
2761	24	2025-12-29	2025-12-29 09:52:29.819202	2025-12-29 17:51:43.494448	present	2026-03-02 15:43:44.318533
2762	25	2025-12-29	2025-12-29 09:21:37.891352	2025-12-29 17:06:29.869259	present	2026-03-02 15:43:44.318533
2763	26	2025-12-29	2025-12-29 09:43:22.094607	2025-12-29 17:15:25.066212	present	2026-03-02 15:43:44.318533
2764	28	2025-12-29	2025-12-29 09:56:39.655655	2025-12-29 17:48:42.681416	present	2026-03-02 15:43:44.318533
2765	29	2025-12-29	2025-12-29 09:31:59.929256	2025-12-29 17:06:15.287663	present	2026-03-02 15:43:44.318533
2766	30	2025-12-29	2025-12-29 09:24:09.772078	2025-12-29 17:22:42.699379	present	2026-03-02 15:43:44.318533
2767	31	2025-12-29	2025-12-29 09:51:32.700337	2025-12-29 17:08:30.243058	present	2026-03-02 15:43:44.318533
2768	32	2025-12-29	2025-12-29 09:05:36.043541	2025-12-29 17:24:36.391479	present	2026-03-02 15:43:44.318533
2769	34	2025-12-29	2025-12-29 09:42:14.770146	2025-12-29 17:25:01.985685	present	2026-03-02 15:43:44.318533
2770	36	2025-12-29	2025-12-29 09:27:54.439883	2025-12-29 17:49:49.553796	present	2026-03-02 15:43:44.318533
2771	38	2025-12-29	2025-12-29 09:37:35.877487	2025-12-29 17:53:05.254572	present	2026-03-02 15:43:44.318533
2772	39	2025-12-29	2025-12-29 09:40:50.096172	2025-12-29 17:27:45.106302	present	2026-03-02 15:43:44.318533
2773	40	2025-12-29	2025-12-29 09:13:26.295256	2025-12-29 17:52:44.11741	present	2026-03-02 15:43:44.318533
2774	41	2025-12-29	2025-12-29 09:52:10.736141	2025-12-29 17:10:53.534616	present	2026-03-02 15:43:44.318533
2775	42	2025-12-29	2025-12-29 09:01:57.156292	2025-12-29 17:58:29.680372	present	2026-03-02 15:43:44.318533
2776	44	2025-12-29	2025-12-29 09:02:27.066059	2025-12-29 17:10:18.598482	present	2026-03-02 15:43:44.318533
2777	49	2025-12-29	2025-12-29 09:55:21.627799	2025-12-29 17:54:05.144802	present	2026-03-02 15:43:44.318533
2778	51	2025-12-29	2025-12-29 09:00:46.55679	2025-12-29 17:41:50.19077	present	2026-03-02 15:43:44.318533
2779	53	2025-12-29	2025-12-29 09:54:19.778307	2025-12-29 17:23:04.784995	present	2026-03-02 15:43:44.318533
2780	54	2025-12-29	2025-12-29 09:04:52.361311	2025-12-29 17:26:20.044058	present	2026-03-02 15:43:44.318533
2781	55	2025-12-29	2025-12-29 09:28:49.009358	2025-12-29 17:49:26.240911	present	2026-03-02 15:43:44.318533
2782	56	2025-12-29	2025-12-29 09:07:50.413747	2025-12-29 17:37:33.795316	present	2026-03-02 15:43:44.318533
2783	57	2025-12-29	2025-12-29 09:37:18.09994	2025-12-29 17:33:48.783112	present	2026-03-02 15:43:44.318533
2784	58	2025-12-29	2025-12-29 09:18:43.470855	2025-12-29 17:10:47.688128	present	2026-03-02 15:43:44.318533
2785	61	2025-12-29	2025-12-29 09:38:41.657992	2025-12-29 17:15:12.244132	present	2026-03-02 15:43:44.318533
2786	67	2025-12-29	2025-12-29 09:40:48.621819	2025-12-29 17:50:50.32335	present	2026-03-02 15:43:44.318533
2787	68	2025-12-29	2025-12-29 09:48:56.818893	2025-12-29 17:19:36.913649	present	2026-03-02 15:43:44.318533
2788	69	2025-12-29	2025-12-29 09:00:41.081963	2025-12-29 17:21:36.100666	present	2026-03-02 15:43:44.318533
2789	72	2025-12-29	2025-12-29 09:41:21.216427	2025-12-29 17:32:04.186196	present	2026-03-02 15:43:44.318533
2790	75	2025-12-29	2025-12-29 09:39:46.915805	2025-12-29 17:54:40.328658	present	2026-03-02 15:43:44.318533
2791	76	2025-12-29	2025-12-29 09:49:53.538176	2025-12-29 17:00:18.420298	present	2026-03-02 15:43:44.318533
2792	77	2025-12-29	2025-12-29 09:11:23.091865	2025-12-29 17:17:07.769327	present	2026-03-02 15:43:44.318533
2793	80	2025-12-29	2025-12-29 09:32:28.954047	2025-12-29 17:16:22.957446	present	2026-03-02 15:43:44.318533
2794	81	2025-12-29	2025-12-29 09:01:44.384649	2025-12-29 17:52:59.021639	present	2026-03-02 15:43:44.318533
2795	86	2025-12-29	2025-12-29 09:24:32.966999	2025-12-29 17:24:47.619624	present	2026-03-02 15:43:44.318533
2796	87	2025-12-29	2025-12-29 09:17:55.959327	2025-12-29 17:23:55.729012	present	2026-03-02 15:43:44.318533
2797	90	2025-12-29	2025-12-29 09:46:23.030032	2025-12-29 17:26:37.409083	present	2026-03-02 15:43:44.318533
2798	91	2025-12-29	2025-12-29 09:14:26.79184	2025-12-29 17:07:38.589982	present	2026-03-02 15:43:44.318533
2799	92	2025-12-29	2025-12-29 09:49:42.768642	2025-12-29 17:37:34.755384	present	2026-03-02 15:43:44.318533
2800	93	2025-12-29	2025-12-29 09:55:58.651905	2025-12-29 17:41:13.034905	present	2026-03-02 15:43:44.318533
2801	94	2025-12-29	2025-12-29 09:11:08.477665	2025-12-29 17:23:15.467507	present	2026-03-02 15:43:44.318533
2802	95	2025-12-29	2025-12-29 09:33:23.67184	2025-12-29 17:14:32.053375	present	2026-03-02 15:43:44.318533
2803	98	2025-12-29	2025-12-29 09:13:47.216032	2025-12-29 17:42:43.619621	present	2026-03-02 15:43:44.318533
2804	99	2025-12-29	2025-12-29 09:31:32.956011	2025-12-29 17:41:41.016082	present	2026-03-02 15:43:44.318533
2805	100	2025-12-29	2025-12-29 09:43:51.522878	2025-12-29 17:21:20.678348	present	2026-03-02 15:43:44.318533
2806	3	2025-12-30	2025-12-30 09:51:13.390387	2025-12-30 17:39:26.475787	present	2026-03-02 15:43:44.318533
2807	4	2025-12-30	2025-12-30 09:14:34.788323	2025-12-30 17:08:17.520389	present	2026-03-02 15:43:44.318533
2808	5	2025-12-30	2025-12-30 09:33:01.289641	2025-12-30 17:54:30.170699	present	2026-03-02 15:43:44.318533
2809	6	2025-12-30	2025-12-30 09:07:41.306004	2025-12-30 17:27:30.404679	present	2026-03-02 15:43:44.318533
2810	10	2025-12-30	2025-12-30 09:36:34.907187	2025-12-30 17:38:18.746577	present	2026-03-02 15:43:44.318533
2811	11	2025-12-30	2025-12-30 09:26:02.486804	2025-12-30 17:48:12.772553	present	2026-03-02 15:43:44.318533
2812	27	2025-12-30	2025-12-30 09:26:53.667133	2025-12-30 17:30:43.711959	present	2026-03-02 15:43:44.318533
2813	33	2025-12-30	2025-12-30 09:54:53.495798	2025-12-30 17:11:11.794809	present	2026-03-02 15:43:44.318533
2814	35	2025-12-30	2025-12-30 09:26:20.751708	2025-12-30 17:47:08.638882	present	2026-03-02 15:43:44.318533
2815	37	2025-12-30	2025-12-30 09:01:37.800858	2025-12-30 17:35:55.238718	present	2026-03-02 15:43:44.318533
2816	43	2025-12-30	2025-12-30 09:09:05.673069	2025-12-30 17:40:19.229178	present	2026-03-02 15:43:44.318533
2817	45	2025-12-30	2025-12-30 09:20:35.841143	2025-12-30 17:41:57.600462	present	2026-03-02 15:43:44.318533
2818	46	2025-12-30	2025-12-30 09:09:25.794762	2025-12-30 17:21:23.877947	present	2026-03-02 15:43:44.318533
2819	47	2025-12-30	2025-12-30 09:33:56.975805	2025-12-30 17:46:48.980235	present	2026-03-02 15:43:44.318533
2820	48	2025-12-30	2025-12-30 09:55:38.301072	2025-12-30 17:52:22.111706	present	2026-03-02 15:43:44.318533
2821	50	2025-12-30	2025-12-30 09:50:16.658646	2025-12-30 17:55:15.585736	present	2026-03-02 15:43:44.318533
2822	52	2025-12-30	2025-12-30 09:23:48.411964	2025-12-30 17:16:26.806041	present	2026-03-02 15:43:44.318533
2823	59	2025-12-30	2025-12-30 09:11:40.788076	2025-12-30 17:21:26.265046	present	2026-03-02 15:43:44.318533
2824	60	2025-12-30	2025-12-30 09:10:33.046671	2025-12-30 17:48:52.858145	present	2026-03-02 15:43:44.318533
2825	62	2025-12-30	2025-12-30 09:37:57.226951	2025-12-30 17:51:23.91603	present	2026-03-02 15:43:44.318533
2826	63	2025-12-30	2025-12-30 09:19:23.199563	2025-12-30 17:46:32.982052	present	2026-03-02 15:43:44.318533
2827	64	2025-12-30	2025-12-30 09:02:46.485634	2025-12-30 17:20:45.401273	present	2026-03-02 15:43:44.318533
2828	65	2025-12-30	2025-12-30 09:24:46.18916	2025-12-30 17:17:22.097864	present	2026-03-02 15:43:44.318533
2829	66	2025-12-30	2025-12-30 09:03:40.072264	2025-12-30 17:20:57.332287	present	2026-03-02 15:43:44.318533
2830	70	2025-12-30	2025-12-30 09:08:56.434863	2025-12-30 17:42:06.336439	present	2026-03-02 15:43:44.318533
2831	71	2025-12-30	2025-12-30 09:44:35.038989	2025-12-30 17:22:29.810478	present	2026-03-02 15:43:44.318533
2832	73	2025-12-30	2025-12-30 09:16:22.794996	2025-12-30 17:50:27.990929	present	2026-03-02 15:43:44.318533
2833	74	2025-12-30	2025-12-30 09:52:28.613611	2025-12-30 17:47:39.889434	present	2026-03-02 15:43:44.318533
2834	78	2025-12-30	2025-12-30 09:31:43.415932	2025-12-30 17:14:54.122159	present	2026-03-02 15:43:44.318533
2835	79	2025-12-30	2025-12-30 09:23:35.196022	2025-12-30 17:05:55.979739	present	2026-03-02 15:43:44.318533
2836	82	2025-12-30	2025-12-30 09:36:28.335225	2025-12-30 17:17:50.159439	present	2026-03-02 15:43:44.318533
2837	83	2025-12-30	2025-12-30 09:23:56.928655	2025-12-30 17:23:26.626089	present	2026-03-02 15:43:44.318533
2838	84	2025-12-30	2025-12-30 09:06:11.597566	2025-12-30 17:52:08.906152	present	2026-03-02 15:43:44.318533
2839	85	2025-12-30	2025-12-30 09:59:03.588308	2025-12-30 17:51:42.2135	present	2026-03-02 15:43:44.318533
2840	88	2025-12-30	2025-12-30 09:42:53.478266	2025-12-30 17:18:36.348063	present	2026-03-02 15:43:44.318533
2841	89	2025-12-30	2025-12-30 09:29:24.618247	2025-12-30 17:55:49.866978	present	2026-03-02 15:43:44.318533
2842	96	2025-12-30	2025-12-30 09:09:04.172055	2025-12-30 17:45:52.639588	present	2026-03-02 15:43:44.318533
2843	97	2025-12-30	2025-12-30 09:04:41.776426	2025-12-30 17:31:54.051547	present	2026-03-02 15:43:44.318533
2844	1	2025-12-30	2025-12-30 09:00:15.532202	2025-12-30 17:39:43.399932	present	2026-03-02 15:43:44.318533
2845	2	2025-12-30	2025-12-30 09:26:40.263448	2025-12-30 17:50:20.604113	present	2026-03-02 15:43:44.318533
2846	7	2025-12-30	2025-12-30 09:23:14.419495	2025-12-30 17:36:35.305838	present	2026-03-02 15:43:44.318533
2847	8	2025-12-30	2025-12-30 09:30:10.220728	2025-12-30 17:19:35.992028	present	2026-03-02 15:43:44.318533
2848	9	2025-12-30	2025-12-30 09:42:28.323168	2025-12-30 17:06:36.132383	present	2026-03-02 15:43:44.318533
2849	12	2025-12-30	2025-12-30 09:14:40.882967	2025-12-30 17:56:07.171377	present	2026-03-02 15:43:44.318533
2850	13	2025-12-30	2025-12-30 09:41:45.481975	2025-12-30 17:35:33.21979	present	2026-03-02 15:43:44.318533
2851	14	2025-12-30	2025-12-30 09:51:23.529675	2025-12-30 17:04:21.400328	present	2026-03-02 15:43:44.318533
2852	15	2025-12-30	2025-12-30 09:41:40.925565	2025-12-30 17:13:54.22385	present	2026-03-02 15:43:44.318533
2853	16	2025-12-30	2025-12-30 09:07:53.035843	2025-12-30 17:32:34.581678	present	2026-03-02 15:43:44.318533
2854	17	2025-12-30	2025-12-30 09:41:04.622029	2025-12-30 17:44:11.609175	present	2026-03-02 15:43:44.318533
2855	18	2025-12-30	2025-12-30 09:31:48.575483	2025-12-30 17:29:13.062906	present	2026-03-02 15:43:44.318533
2856	19	2025-12-30	2025-12-30 09:22:06.354245	2025-12-30 17:18:23.341105	present	2026-03-02 15:43:44.318533
2857	20	2025-12-30	2025-12-30 09:26:14.015864	2025-12-30 17:23:49.134721	present	2026-03-02 15:43:44.318533
2858	21	2025-12-30	2025-12-30 09:03:10.913681	2025-12-30 17:52:39.870457	present	2026-03-02 15:43:44.318533
2859	22	2025-12-30	2025-12-30 09:54:43.399794	2025-12-30 17:58:19.079667	present	2026-03-02 15:43:44.318533
2860	23	2025-12-30	2025-12-30 09:21:10.143432	2025-12-30 17:41:39.192349	present	2026-03-02 15:43:44.318533
2861	24	2025-12-30	2025-12-30 09:58:09.721319	2025-12-30 17:25:50.418969	present	2026-03-02 15:43:44.318533
2862	25	2025-12-30	2025-12-30 09:52:54.594574	2025-12-30 17:38:01.537426	present	2026-03-02 15:43:44.318533
2863	26	2025-12-30	2025-12-30 09:37:14.272968	2025-12-30 17:17:11.912607	present	2026-03-02 15:43:44.318533
2864	28	2025-12-30	2025-12-30 09:59:25.19084	2025-12-30 17:09:11.856506	present	2026-03-02 15:43:44.318533
2865	29	2025-12-30	2025-12-30 09:31:40.994588	2025-12-30 17:59:17.830469	present	2026-03-02 15:43:44.318533
2866	30	2025-12-30	2025-12-30 09:14:13.039009	2025-12-30 17:45:55.087814	present	2026-03-02 15:43:44.318533
2867	31	2025-12-30	2025-12-30 09:27:03.526061	2025-12-30 17:05:40.781273	present	2026-03-02 15:43:44.318533
2868	32	2025-12-30	2025-12-30 09:07:45.983143	2025-12-30 17:11:00.766087	present	2026-03-02 15:43:44.318533
2869	34	2025-12-30	2025-12-30 09:55:54.406475	2025-12-30 17:35:26.014631	present	2026-03-02 15:43:44.318533
2870	36	2025-12-30	2025-12-30 09:21:34.229132	2025-12-30 17:15:43.866889	present	2026-03-02 15:43:44.318533
2871	38	2025-12-30	2025-12-30 09:21:23.640416	2025-12-30 17:06:38.966623	present	2026-03-02 15:43:44.318533
2872	39	2025-12-30	2025-12-30 09:30:25.52281	2025-12-30 17:44:01.02629	present	2026-03-02 15:43:44.318533
2873	40	2025-12-30	2025-12-30 09:00:26.145106	2025-12-30 17:17:50.81596	present	2026-03-02 15:43:44.318533
2874	41	2025-12-30	2025-12-30 09:59:54.225635	2025-12-30 17:01:23.369839	present	2026-03-02 15:43:44.318533
2875	42	2025-12-30	2025-12-30 09:01:52.853617	2025-12-30 17:12:19.794879	present	2026-03-02 15:43:44.318533
2876	44	2025-12-30	2025-12-30 09:04:04.113843	2025-12-30 17:22:12.479073	present	2026-03-02 15:43:44.318533
2877	49	2025-12-30	2025-12-30 09:54:08.827456	2025-12-30 17:00:41.817509	present	2026-03-02 15:43:44.318533
2878	51	2025-12-30	2025-12-30 09:30:53.252716	2025-12-30 17:16:56.31236	present	2026-03-02 15:43:44.318533
2879	53	2025-12-30	2025-12-30 09:24:15.7945	2025-12-30 17:18:29.859039	present	2026-03-02 15:43:44.318533
2880	54	2025-12-30	2025-12-30 09:56:56.193968	2025-12-30 17:53:22.292057	present	2026-03-02 15:43:44.318533
2881	55	2025-12-30	2025-12-30 09:54:27.371558	2025-12-30 17:45:24.846817	present	2026-03-02 15:43:44.318533
2882	56	2025-12-30	2025-12-30 09:09:20.981285	2025-12-30 17:20:18.026061	present	2026-03-02 15:43:44.318533
2883	57	2025-12-30	2025-12-30 09:23:15.783562	2025-12-30 17:51:13.544978	present	2026-03-02 15:43:44.318533
2884	58	2025-12-30	2025-12-30 09:10:51.097122	2025-12-30 17:01:05.372331	present	2026-03-02 15:43:44.318533
2885	61	2025-12-30	2025-12-30 09:02:11.02779	2025-12-30 17:01:26.631863	present	2026-03-02 15:43:44.318533
2886	67	2025-12-30	2025-12-30 09:04:33.743687	2025-12-30 17:57:52.70695	present	2026-03-02 15:43:44.318533
2887	68	2025-12-30	2025-12-30 09:01:14.846916	2025-12-30 17:35:13.255396	present	2026-03-02 15:43:44.318533
2888	69	2025-12-30	2025-12-30 09:12:55.96993	2025-12-30 17:09:44.898716	present	2026-03-02 15:43:44.318533
2889	72	2025-12-30	2025-12-30 09:49:28.221043	2025-12-30 17:09:21.260639	present	2026-03-02 15:43:44.318533
2890	75	2025-12-30	2025-12-30 09:07:55.674798	2025-12-30 17:01:00.214089	present	2026-03-02 15:43:44.318533
2891	76	2025-12-30	2025-12-30 09:17:47.807584	2025-12-30 17:17:07.619857	present	2026-03-02 15:43:44.318533
2892	77	2025-12-30	2025-12-30 09:08:29.342077	2025-12-30 17:18:14.805465	present	2026-03-02 15:43:44.318533
2893	80	2025-12-30	2025-12-30 09:19:52.431147	2025-12-30 17:38:56.478115	present	2026-03-02 15:43:44.318533
2894	81	2025-12-30	2025-12-30 09:25:49.90198	2025-12-30 17:18:54.457961	present	2026-03-02 15:43:44.318533
2895	86	2025-12-30	2025-12-30 09:38:45.725605	2025-12-30 17:29:44.596646	present	2026-03-02 15:43:44.318533
2896	87	2025-12-30	2025-12-30 09:15:55.262335	2025-12-30 17:49:54.328642	present	2026-03-02 15:43:44.318533
2897	90	2025-12-30	2025-12-30 09:41:03.281914	2025-12-30 17:19:20.342422	present	2026-03-02 15:43:44.318533
2898	91	2025-12-30	2025-12-30 09:54:54.333309	2025-12-30 17:26:11.231014	present	2026-03-02 15:43:44.318533
2899	92	2025-12-30	2025-12-30 09:53:24.945746	2025-12-30 17:44:45.67761	present	2026-03-02 15:43:44.318533
2900	93	2025-12-30	2025-12-30 09:40:56.230673	2025-12-30 17:21:44.326068	present	2026-03-02 15:43:44.318533
2901	94	2025-12-30	2025-12-30 09:33:49.086826	2025-12-30 17:34:34.147098	present	2026-03-02 15:43:44.318533
2902	95	2025-12-30	2025-12-30 09:58:52.401883	2025-12-30 17:30:22.210309	present	2026-03-02 15:43:44.318533
2903	98	2025-12-30	2025-12-30 09:11:04.680974	2025-12-30 17:18:10.871856	present	2026-03-02 15:43:44.318533
2904	99	2025-12-30	2025-12-30 09:25:12.451524	2025-12-30 17:07:17.062694	present	2026-03-02 15:43:44.318533
2905	100	2025-12-30	2025-12-30 09:26:51.587028	2025-12-30 17:48:09.184315	present	2026-03-02 15:43:44.318533
2906	3	2025-12-31	2025-12-31 09:42:05.733744	2025-12-31 17:24:17.590629	present	2026-03-02 15:43:44.318533
2907	4	2025-12-31	2025-12-31 09:57:46.042863	2025-12-31 17:19:55.411201	present	2026-03-02 15:43:44.318533
2908	5	2025-12-31	2025-12-31 09:08:06.552327	2025-12-31 17:06:01.303127	present	2026-03-02 15:43:44.318533
2909	6	2025-12-31	2025-12-31 09:21:39.027062	2025-12-31 17:40:52.388607	present	2026-03-02 15:43:44.318533
2910	10	2025-12-31	2025-12-31 09:47:08.321746	2025-12-31 17:17:24.708834	present	2026-03-02 15:43:44.318533
2911	11	2025-12-31	2025-12-31 09:17:17.259908	2025-12-31 17:31:42.413698	present	2026-03-02 15:43:44.318533
2912	27	2025-12-31	2025-12-31 09:19:20.874321	2025-12-31 17:03:40.69675	present	2026-03-02 15:43:44.318533
2913	33	2025-12-31	2025-12-31 09:50:29.58571	2025-12-31 17:31:00.751778	present	2026-03-02 15:43:44.318533
2914	35	2025-12-31	2025-12-31 09:10:04.367587	2025-12-31 17:12:25.332791	present	2026-03-02 15:43:44.318533
2915	37	2025-12-31	2025-12-31 09:16:39.070315	2025-12-31 17:42:28.861332	present	2026-03-02 15:43:44.318533
2916	43	2025-12-31	2025-12-31 09:43:26.694557	2025-12-31 17:41:22.368484	present	2026-03-02 15:43:44.318533
2917	45	2025-12-31	2025-12-31 09:32:22.528162	2025-12-31 17:44:43.35728	present	2026-03-02 15:43:44.318533
2918	46	2025-12-31	2025-12-31 09:19:50.823033	2025-12-31 17:49:56.65244	present	2026-03-02 15:43:44.318533
2919	47	2025-12-31	2025-12-31 09:31:28.744325	2025-12-31 17:24:04.687244	present	2026-03-02 15:43:44.318533
2920	48	2025-12-31	2025-12-31 09:36:39.571549	2025-12-31 17:49:30.057328	present	2026-03-02 15:43:44.318533
2921	50	2025-12-31	2025-12-31 09:45:01.669118	2025-12-31 17:05:21.089265	present	2026-03-02 15:43:44.318533
2922	52	2025-12-31	2025-12-31 09:44:48.843618	2025-12-31 17:44:46.510312	present	2026-03-02 15:43:44.318533
2923	59	2025-12-31	2025-12-31 09:02:24.59739	2025-12-31 17:01:01.108436	present	2026-03-02 15:43:44.318533
2924	60	2025-12-31	2025-12-31 09:08:45.260274	2025-12-31 17:04:27.483611	present	2026-03-02 15:43:44.318533
2925	62	2025-12-31	2025-12-31 09:58:46.778698	2025-12-31 17:07:35.439505	present	2026-03-02 15:43:44.318533
2926	63	2025-12-31	2025-12-31 09:33:33.571534	2025-12-31 17:46:48.757745	present	2026-03-02 15:43:44.318533
2927	64	2025-12-31	2025-12-31 09:16:59.407911	2025-12-31 17:17:39.614447	present	2026-03-02 15:43:44.318533
2928	65	2025-12-31	2025-12-31 09:31:21.187266	2025-12-31 17:37:02.014415	present	2026-03-02 15:43:44.318533
2929	66	2025-12-31	2025-12-31 09:38:04.454738	2025-12-31 17:26:27.323809	present	2026-03-02 15:43:44.318533
2930	70	2025-12-31	2025-12-31 09:38:05.892512	2025-12-31 17:18:07.668768	present	2026-03-02 15:43:44.318533
2931	71	2025-12-31	2025-12-31 09:09:57.336574	2025-12-31 17:53:50.249252	present	2026-03-02 15:43:44.318533
2932	73	2025-12-31	2025-12-31 09:25:44.294606	2025-12-31 17:55:11.242892	present	2026-03-02 15:43:44.318533
2933	74	2025-12-31	2025-12-31 09:45:47.282163	2025-12-31 17:43:18.449617	present	2026-03-02 15:43:44.318533
2934	78	2025-12-31	2025-12-31 09:13:58.149043	2025-12-31 17:59:58.877538	present	2026-03-02 15:43:44.318533
2935	79	2025-12-31	2025-12-31 09:49:31.585165	2025-12-31 17:15:18.691134	present	2026-03-02 15:43:44.318533
2936	82	2025-12-31	2025-12-31 09:44:07.517063	2025-12-31 17:31:00.49752	present	2026-03-02 15:43:44.318533
2937	83	2025-12-31	2025-12-31 09:22:56.623343	2025-12-31 17:56:01.328949	present	2026-03-02 15:43:44.318533
2938	84	2025-12-31	2025-12-31 09:13:41.383387	2025-12-31 17:30:32.972953	present	2026-03-02 15:43:44.318533
2939	85	2025-12-31	2025-12-31 09:53:02.539771	2025-12-31 17:34:33.625079	present	2026-03-02 15:43:44.318533
2940	88	2025-12-31	2025-12-31 09:39:49.2869	2025-12-31 17:19:24.102266	present	2026-03-02 15:43:44.318533
2941	89	2025-12-31	2025-12-31 09:40:06.992593	2025-12-31 17:32:30.004299	present	2026-03-02 15:43:44.318533
2942	96	2025-12-31	2025-12-31 09:30:58.122811	2025-12-31 17:54:03.94538	present	2026-03-02 15:43:44.318533
2943	97	2025-12-31	2025-12-31 09:15:44.243357	2025-12-31 17:26:02.284454	present	2026-03-02 15:43:44.318533
2944	1	2025-12-31	2025-12-31 09:57:08.697441	2025-12-31 17:52:38.061643	present	2026-03-02 15:43:44.318533
2945	2	2025-12-31	2025-12-31 09:19:17.381037	2025-12-31 17:27:55.598825	present	2026-03-02 15:43:44.318533
2946	7	2025-12-31	2025-12-31 09:21:57.054705	2025-12-31 17:36:25.01875	present	2026-03-02 15:43:44.318533
2947	8	2025-12-31	2025-12-31 09:38:25.29059	2025-12-31 17:51:47.764616	present	2026-03-02 15:43:44.318533
2948	9	2025-12-31	2025-12-31 09:32:46.801001	2025-12-31 17:39:44.114944	present	2026-03-02 15:43:44.318533
2949	12	2025-12-31	2025-12-31 09:34:28.72668	2025-12-31 17:08:50.354804	present	2026-03-02 15:43:44.318533
2950	13	2025-12-31	2025-12-31 09:06:58.090377	2025-12-31 17:25:49.71633	present	2026-03-02 15:43:44.318533
2951	14	2025-12-31	2025-12-31 09:17:22.085352	2025-12-31 17:48:01.496665	present	2026-03-02 15:43:44.318533
2952	15	2025-12-31	2025-12-31 09:27:01.442591	2025-12-31 17:07:22.916811	present	2026-03-02 15:43:44.318533
2953	16	2025-12-31	2025-12-31 09:18:20.95128	2025-12-31 17:00:43.071753	present	2026-03-02 15:43:44.318533
2954	17	2025-12-31	2025-12-31 09:31:31.193335	2025-12-31 17:34:14.847732	present	2026-03-02 15:43:44.318533
2955	18	2025-12-31	2025-12-31 09:03:37.365044	2025-12-31 17:51:34.31537	present	2026-03-02 15:43:44.318533
2956	19	2025-12-31	2025-12-31 09:03:12.566376	2025-12-31 17:20:07.958873	present	2026-03-02 15:43:44.318533
2957	20	2025-12-31	2025-12-31 09:39:57.410522	2025-12-31 17:15:59.491408	present	2026-03-02 15:43:44.318533
2958	21	2025-12-31	2025-12-31 09:43:06.183341	2025-12-31 17:42:10.951148	present	2026-03-02 15:43:44.318533
2959	22	2025-12-31	2025-12-31 09:34:32.667358	2025-12-31 17:30:39.110269	present	2026-03-02 15:43:44.318533
2960	23	2025-12-31	2025-12-31 09:13:15.814932	2025-12-31 17:49:07.34374	present	2026-03-02 15:43:44.318533
2961	24	2025-12-31	2025-12-31 09:59:53.219946	2025-12-31 17:00:45.627358	present	2026-03-02 15:43:44.318533
2962	25	2025-12-31	2025-12-31 09:49:41.401052	2025-12-31 17:49:18.393622	present	2026-03-02 15:43:44.318533
2963	26	2025-12-31	2025-12-31 09:15:22.829571	2025-12-31 17:06:09.35293	present	2026-03-02 15:43:44.318533
2964	28	2025-12-31	2025-12-31 09:59:12.638867	2025-12-31 17:54:29.348579	present	2026-03-02 15:43:44.318533
2965	29	2025-12-31	2025-12-31 09:24:42.502205	2025-12-31 17:52:14.456377	present	2026-03-02 15:43:44.318533
2966	30	2025-12-31	2025-12-31 09:57:03.446967	2025-12-31 17:20:14.47185	present	2026-03-02 15:43:44.318533
2967	31	2025-12-31	2025-12-31 09:38:20.813394	2025-12-31 17:26:59.315715	present	2026-03-02 15:43:44.318533
2968	32	2025-12-31	2025-12-31 09:46:16.277438	2025-12-31 17:47:19.849705	present	2026-03-02 15:43:44.318533
2969	34	2025-12-31	2025-12-31 09:36:12.52388	2025-12-31 17:31:56.642915	present	2026-03-02 15:43:44.318533
2970	36	2025-12-31	2025-12-31 09:19:30.908647	2025-12-31 17:15:11.13141	present	2026-03-02 15:43:44.318533
2971	38	2025-12-31	2025-12-31 09:28:18.781555	2025-12-31 17:19:48.718008	present	2026-03-02 15:43:44.318533
2972	39	2025-12-31	2025-12-31 09:33:31.146079	2025-12-31 17:40:49.5693	present	2026-03-02 15:43:44.318533
2973	40	2025-12-31	2025-12-31 09:36:45.740595	2025-12-31 17:08:24.083744	present	2026-03-02 15:43:44.318533
2974	41	2025-12-31	2025-12-31 09:45:17.792409	2025-12-31 17:31:36.074712	present	2026-03-02 15:43:44.318533
2975	42	2025-12-31	2025-12-31 09:05:45.811856	2025-12-31 17:38:27.432059	present	2026-03-02 15:43:44.318533
2976	44	2025-12-31	2025-12-31 09:17:21.854388	2025-12-31 17:34:11.049936	present	2026-03-02 15:43:44.318533
2977	49	2025-12-31	2025-12-31 09:13:07.551383	2025-12-31 17:52:44.831605	present	2026-03-02 15:43:44.318533
2978	51	2025-12-31	2025-12-31 09:53:01.612948	2025-12-31 17:45:42.806694	present	2026-03-02 15:43:44.318533
2979	53	2025-12-31	2025-12-31 09:50:06.834017	2025-12-31 17:51:19.015587	present	2026-03-02 15:43:44.318533
2980	54	2025-12-31	2025-12-31 09:27:48.935601	2025-12-31 17:04:42.957112	present	2026-03-02 15:43:44.318533
2981	55	2025-12-31	2025-12-31 09:07:01.69477	2025-12-31 17:21:07.847248	present	2026-03-02 15:43:44.318533
2982	56	2025-12-31	2025-12-31 09:58:21.433542	2025-12-31 17:58:13.108049	present	2026-03-02 15:43:44.318533
2983	57	2025-12-31	2025-12-31 09:28:12.289908	2025-12-31 17:43:53.675985	present	2026-03-02 15:43:44.318533
2984	58	2025-12-31	2025-12-31 09:58:59.306515	2025-12-31 17:28:56.055606	present	2026-03-02 15:43:44.318533
2985	61	2025-12-31	2025-12-31 09:04:38.940488	2025-12-31 17:53:08.372108	present	2026-03-02 15:43:44.318533
2986	67	2025-12-31	2025-12-31 09:34:51.549744	2025-12-31 17:31:00.901369	present	2026-03-02 15:43:44.318533
2987	68	2025-12-31	2025-12-31 09:17:08.595092	2025-12-31 17:23:49.826406	present	2026-03-02 15:43:44.318533
2988	69	2025-12-31	2025-12-31 09:34:32.674826	2025-12-31 17:01:31.136799	present	2026-03-02 15:43:44.318533
2989	72	2025-12-31	2025-12-31 09:34:26.254431	2025-12-31 17:11:16.860811	present	2026-03-02 15:43:44.318533
2990	75	2025-12-31	2025-12-31 09:40:56.735628	2025-12-31 17:15:28.33545	present	2026-03-02 15:43:44.318533
2991	76	2025-12-31	2025-12-31 09:36:00.560779	2025-12-31 17:56:23.857158	present	2026-03-02 15:43:44.318533
2992	77	2025-12-31	2025-12-31 09:51:54.160099	2025-12-31 17:21:48.904496	present	2026-03-02 15:43:44.318533
2993	80	2025-12-31	2025-12-31 09:26:40.499586	2025-12-31 17:11:08.386563	present	2026-03-02 15:43:44.318533
2994	81	2025-12-31	2025-12-31 09:04:53.103373	2025-12-31 17:16:22.512903	present	2026-03-02 15:43:44.318533
2995	86	2025-12-31	2025-12-31 09:55:57.83132	2025-12-31 17:57:55.959598	present	2026-03-02 15:43:44.318533
2996	87	2025-12-31	2025-12-31 09:24:06.002344	2025-12-31 17:05:17.141908	present	2026-03-02 15:43:44.318533
2997	90	2025-12-31	2025-12-31 09:43:13.620937	2025-12-31 17:44:21.013465	present	2026-03-02 15:43:44.318533
2998	91	2025-12-31	2025-12-31 09:49:54.333429	2025-12-31 17:59:39.744142	present	2026-03-02 15:43:44.318533
2999	92	2025-12-31	2025-12-31 09:03:10.414002	2025-12-31 17:06:30.263581	present	2026-03-02 15:43:44.318533
3000	93	2025-12-31	2025-12-31 09:58:47.668226	2025-12-31 17:10:30.57857	present	2026-03-02 15:43:44.318533
3001	94	2025-12-31	2025-12-31 09:23:27.674571	2025-12-31 17:36:15.387962	present	2026-03-02 15:43:44.318533
3002	95	2025-12-31	2025-12-31 09:07:07.287812	2025-12-31 17:04:19.857685	present	2026-03-02 15:43:44.318533
3003	98	2025-12-31	2025-12-31 09:46:41.034185	2025-12-31 17:40:06.170748	present	2026-03-02 15:43:44.318533
3004	99	2025-12-31	2025-12-31 09:55:57.605888	2025-12-31 17:27:11.318272	present	2026-03-02 15:43:44.318533
3005	100	2025-12-31	2025-12-31 09:16:44.205844	2025-12-31 17:57:58.479177	present	2026-03-02 15:43:44.318533
3006	3	2026-01-01	2026-01-01 09:02:44.013881	2026-01-01 17:41:21.538232	present	2026-03-02 15:43:44.318533
3007	4	2026-01-01	2026-01-01 09:32:41.359085	2026-01-01 17:23:23.017698	present	2026-03-02 15:43:44.318533
3008	5	2026-01-01	2026-01-01 09:07:30.881551	2026-01-01 17:34:35.945237	present	2026-03-02 15:43:44.318533
3009	6	2026-01-01	2026-01-01 09:41:07.913459	2026-01-01 17:05:25.083937	present	2026-03-02 15:43:44.318533
3010	10	2026-01-01	2026-01-01 09:58:38.167152	2026-01-01 17:46:38.231592	present	2026-03-02 15:43:44.318533
3011	11	2026-01-01	2026-01-01 09:32:58.654283	2026-01-01 17:22:33.838801	present	2026-03-02 15:43:44.318533
3012	27	2026-01-01	2026-01-01 09:47:42.577604	2026-01-01 17:48:35.108422	present	2026-03-02 15:43:44.318533
3013	33	2026-01-01	2026-01-01 09:41:30.323588	2026-01-01 17:48:39.79161	present	2026-03-02 15:43:44.318533
3014	35	2026-01-01	2026-01-01 09:49:49.121844	2026-01-01 17:29:14.403818	present	2026-03-02 15:43:44.318533
3015	37	2026-01-01	2026-01-01 09:17:39.409804	2026-01-01 17:57:07.773848	present	2026-03-02 15:43:44.318533
3016	43	2026-01-01	2026-01-01 09:16:09.952953	2026-01-01 17:36:46.58492	present	2026-03-02 15:43:44.318533
3017	45	2026-01-01	2026-01-01 09:17:15.582904	2026-01-01 17:16:02.362404	present	2026-03-02 15:43:44.318533
3018	46	2026-01-01	2026-01-01 09:49:20.45977	2026-01-01 17:50:47.7956	present	2026-03-02 15:43:44.318533
3019	47	2026-01-01	2026-01-01 09:41:19.764258	2026-01-01 17:11:26.022738	present	2026-03-02 15:43:44.318533
3020	48	2026-01-01	2026-01-01 09:34:01.954574	2026-01-01 17:20:19.963926	present	2026-03-02 15:43:44.318533
3021	50	2026-01-01	2026-01-01 09:56:20.424574	2026-01-01 17:31:21.779646	present	2026-03-02 15:43:44.318533
3022	52	2026-01-01	2026-01-01 09:23:46.78324	2026-01-01 17:57:14.747433	present	2026-03-02 15:43:44.318533
3023	59	2026-01-01	2026-01-01 09:46:05.557359	2026-01-01 17:50:30.053885	present	2026-03-02 15:43:44.318533
3024	60	2026-01-01	2026-01-01 09:05:05.258109	2026-01-01 17:52:26.583625	present	2026-03-02 15:43:44.318533
3025	62	2026-01-01	2026-01-01 09:49:00.048075	2026-01-01 17:20:51.337799	present	2026-03-02 15:43:44.318533
3026	63	2026-01-01	2026-01-01 09:06:58.05818	2026-01-01 17:02:50.747725	present	2026-03-02 15:43:44.318533
3027	64	2026-01-01	2026-01-01 09:08:00.632326	2026-01-01 17:23:23.362324	present	2026-03-02 15:43:44.318533
3028	65	2026-01-01	2026-01-01 09:50:28.485397	2026-01-01 17:58:48.281799	present	2026-03-02 15:43:44.318533
3029	66	2026-01-01	2026-01-01 09:10:47.816753	2026-01-01 17:09:15.779277	present	2026-03-02 15:43:44.318533
3030	70	2026-01-01	2026-01-01 09:31:00.319088	2026-01-01 17:52:20.692416	present	2026-03-02 15:43:44.318533
3031	71	2026-01-01	2026-01-01 09:32:42.356815	2026-01-01 17:00:10.18837	present	2026-03-02 15:43:44.318533
3032	73	2026-01-01	2026-01-01 09:27:14.828428	2026-01-01 17:09:33.636596	present	2026-03-02 15:43:44.318533
3033	74	2026-01-01	2026-01-01 09:21:33.277601	2026-01-01 17:37:28.828675	present	2026-03-02 15:43:44.318533
3034	78	2026-01-01	2026-01-01 09:38:21.289339	2026-01-01 17:48:48.249959	present	2026-03-02 15:43:44.318533
3035	79	2026-01-01	2026-01-01 09:44:41.328198	2026-01-01 17:10:25.415042	present	2026-03-02 15:43:44.318533
3036	82	2026-01-01	2026-01-01 09:22:56.599785	2026-01-01 17:35:39.116398	present	2026-03-02 15:43:44.318533
3037	83	2026-01-01	2026-01-01 09:26:27.081176	2026-01-01 17:05:25.57764	present	2026-03-02 15:43:44.318533
3038	84	2026-01-01	2026-01-01 09:19:39.051291	2026-01-01 17:03:32.876252	present	2026-03-02 15:43:44.318533
3039	85	2026-01-01	2026-01-01 09:50:49.336541	2026-01-01 17:26:00.42236	present	2026-03-02 15:43:44.318533
3040	88	2026-01-01	2026-01-01 09:29:44.231313	2026-01-01 17:31:48.349551	present	2026-03-02 15:43:44.318533
3041	89	2026-01-01	2026-01-01 09:22:02.492862	2026-01-01 17:55:32.391763	present	2026-03-02 15:43:44.318533
3042	96	2026-01-01	2026-01-01 09:54:27.896522	2026-01-01 17:14:11.852717	present	2026-03-02 15:43:44.318533
3043	97	2026-01-01	2026-01-01 09:20:43.830617	2026-01-01 17:18:44.631851	present	2026-03-02 15:43:44.318533
3044	1	2026-01-01	2026-01-01 09:58:30.830174	2026-01-01 17:37:16.143839	present	2026-03-02 15:43:44.318533
3045	2	2026-01-01	2026-01-01 09:32:38.557906	2026-01-01 17:11:57.346006	present	2026-03-02 15:43:44.318533
3046	7	2026-01-01	2026-01-01 09:19:03.781888	2026-01-01 17:21:17.785605	present	2026-03-02 15:43:44.318533
3047	8	2026-01-01	2026-01-01 09:17:20.120725	2026-01-01 17:22:49.601699	present	2026-03-02 15:43:44.318533
3048	9	2026-01-01	2026-01-01 09:39:41.529146	2026-01-01 17:03:02.32939	present	2026-03-02 15:43:44.318533
3049	12	2026-01-01	2026-01-01 09:32:28.158386	2026-01-01 17:02:14.424193	present	2026-03-02 15:43:44.318533
3050	13	2026-01-01	2026-01-01 09:17:18.046661	2026-01-01 17:43:42.160617	present	2026-03-02 15:43:44.318533
3051	14	2026-01-01	2026-01-01 09:18:35.546046	2026-01-01 17:44:45.878075	present	2026-03-02 15:43:44.318533
3052	15	2026-01-01	2026-01-01 09:41:26.359786	2026-01-01 17:39:40.762093	present	2026-03-02 15:43:44.318533
3053	16	2026-01-01	2026-01-01 09:33:12.298252	2026-01-01 17:33:58.116904	present	2026-03-02 15:43:44.318533
3054	17	2026-01-01	2026-01-01 09:55:14.039007	2026-01-01 17:32:51.556885	present	2026-03-02 15:43:44.318533
3055	18	2026-01-01	2026-01-01 09:54:28.787544	2026-01-01 17:57:11.427684	present	2026-03-02 15:43:44.318533
3056	19	2026-01-01	2026-01-01 09:47:49.001094	2026-01-01 17:29:11.254156	present	2026-03-02 15:43:44.318533
3057	20	2026-01-01	2026-01-01 09:22:23.401047	2026-01-01 17:32:54.768938	present	2026-03-02 15:43:44.318533
3058	21	2026-01-01	2026-01-01 09:23:07.253734	2026-01-01 17:33:34.195579	present	2026-03-02 15:43:44.318533
3059	22	2026-01-01	2026-01-01 09:48:40.711577	2026-01-01 17:05:55.504113	present	2026-03-02 15:43:44.318533
3060	23	2026-01-01	2026-01-01 09:11:30.845995	2026-01-01 17:28:42.272313	present	2026-03-02 15:43:44.318533
3061	24	2026-01-01	2026-01-01 09:59:03.355087	2026-01-01 17:21:50.780729	present	2026-03-02 15:43:44.318533
3062	25	2026-01-01	2026-01-01 09:53:25.091947	2026-01-01 17:26:51.044471	present	2026-03-02 15:43:44.318533
3063	26	2026-01-01	2026-01-01 09:30:00.842418	2026-01-01 17:06:50.662719	present	2026-03-02 15:43:44.318533
3064	28	2026-01-01	2026-01-01 09:58:48.942848	2026-01-01 17:36:38.52859	present	2026-03-02 15:43:44.318533
3065	29	2026-01-01	2026-01-01 09:03:40.057011	2026-01-01 17:25:58.426062	present	2026-03-02 15:43:44.318533
3066	30	2026-01-01	2026-01-01 09:08:44.052716	2026-01-01 17:49:16.961616	present	2026-03-02 15:43:44.318533
3067	31	2026-01-01	2026-01-01 09:38:25.18391	2026-01-01 17:12:38.109491	present	2026-03-02 15:43:44.318533
3068	32	2026-01-01	2026-01-01 09:10:47.170652	2026-01-01 17:36:41.480033	present	2026-03-02 15:43:44.318533
3069	34	2026-01-01	2026-01-01 09:34:57.203394	2026-01-01 17:08:20.938639	present	2026-03-02 15:43:44.318533
3070	36	2026-01-01	2026-01-01 09:29:16.516459	2026-01-01 17:43:33.005846	present	2026-03-02 15:43:44.318533
3071	38	2026-01-01	2026-01-01 09:44:31.219368	2026-01-01 17:28:26.990133	present	2026-03-02 15:43:44.318533
3072	39	2026-01-01	2026-01-01 09:47:02.879606	2026-01-01 17:31:55.883625	present	2026-03-02 15:43:44.318533
3073	40	2026-01-01	2026-01-01 09:39:37.84702	2026-01-01 17:35:18.830063	present	2026-03-02 15:43:44.318533
3074	41	2026-01-01	2026-01-01 09:12:16.770746	2026-01-01 17:50:08.767549	present	2026-03-02 15:43:44.318533
3075	42	2026-01-01	2026-01-01 09:43:23.604268	2026-01-01 17:56:44.333595	present	2026-03-02 15:43:44.318533
3076	44	2026-01-01	2026-01-01 09:52:06.356473	2026-01-01 17:09:04.111477	present	2026-03-02 15:43:44.318533
3077	49	2026-01-01	2026-01-01 09:47:23.219296	2026-01-01 17:37:59.594742	present	2026-03-02 15:43:44.318533
3078	51	2026-01-01	2026-01-01 09:27:55.937592	2026-01-01 17:21:28.81331	present	2026-03-02 15:43:44.318533
3079	53	2026-01-01	2026-01-01 09:53:09.294118	2026-01-01 17:28:38.707739	present	2026-03-02 15:43:44.318533
3080	54	2026-01-01	2026-01-01 09:35:59.376644	2026-01-01 17:35:34.922237	present	2026-03-02 15:43:44.318533
3081	55	2026-01-01	2026-01-01 09:12:37.95078	2026-01-01 17:23:46.133362	present	2026-03-02 15:43:44.318533
3082	56	2026-01-01	2026-01-01 09:49:20.428666	2026-01-01 17:39:43.385679	present	2026-03-02 15:43:44.318533
3083	57	2026-01-01	2026-01-01 09:30:18.128261	2026-01-01 17:39:11.9608	present	2026-03-02 15:43:44.318533
3084	58	2026-01-01	2026-01-01 09:40:55.677051	2026-01-01 17:25:14.774799	present	2026-03-02 15:43:44.318533
3085	61	2026-01-01	2026-01-01 09:40:36.359908	2026-01-01 17:17:58.567113	present	2026-03-02 15:43:44.318533
3086	67	2026-01-01	2026-01-01 09:11:39.711959	2026-01-01 17:05:29.031425	present	2026-03-02 15:43:44.318533
3087	68	2026-01-01	2026-01-01 09:43:25.337041	2026-01-01 17:35:11.354315	present	2026-03-02 15:43:44.318533
3088	69	2026-01-01	2026-01-01 09:20:57.954148	2026-01-01 17:34:33.322423	present	2026-03-02 15:43:44.318533
3089	72	2026-01-01	2026-01-01 09:05:07.811284	2026-01-01 17:55:48.716824	present	2026-03-02 15:43:44.318533
3090	75	2026-01-01	2026-01-01 09:32:23.471889	2026-01-01 17:09:03.520525	present	2026-03-02 15:43:44.318533
3091	76	2026-01-01	2026-01-01 09:34:01.548318	2026-01-01 17:46:49.896338	present	2026-03-02 15:43:44.318533
3092	77	2026-01-01	2026-01-01 09:36:11.170854	2026-01-01 17:50:56.312564	present	2026-03-02 15:43:44.318533
3093	80	2026-01-01	2026-01-01 09:00:43.167144	2026-01-01 17:10:49.639879	present	2026-03-02 15:43:44.318533
3094	81	2026-01-01	2026-01-01 09:59:33.010662	2026-01-01 17:43:46.972216	present	2026-03-02 15:43:44.318533
3095	86	2026-01-01	2026-01-01 09:03:53.041164	2026-01-01 17:56:41.945012	present	2026-03-02 15:43:44.318533
3096	87	2026-01-01	2026-01-01 09:17:35.857734	2026-01-01 17:12:24.585965	present	2026-03-02 15:43:44.318533
3097	90	2026-01-01	2026-01-01 09:40:55.890161	2026-01-01 17:08:27.607297	present	2026-03-02 15:43:44.318533
3098	91	2026-01-01	2026-01-01 09:01:42.88431	2026-01-01 17:05:15.182004	present	2026-03-02 15:43:44.318533
3099	92	2026-01-01	2026-01-01 09:53:15.255436	2026-01-01 17:53:54.180833	present	2026-03-02 15:43:44.318533
3100	93	2026-01-01	2026-01-01 09:48:29.373803	2026-01-01 17:29:51.115277	present	2026-03-02 15:43:44.318533
3101	94	2026-01-01	2026-01-01 09:37:52.514192	2026-01-01 17:47:26.920871	present	2026-03-02 15:43:44.318533
3102	95	2026-01-01	2026-01-01 09:25:34.135255	2026-01-01 17:15:24.256908	present	2026-03-02 15:43:44.318533
3103	98	2026-01-01	2026-01-01 09:11:17.863433	2026-01-01 17:11:03.294042	present	2026-03-02 15:43:44.318533
3104	99	2026-01-01	2026-01-01 09:44:07.531856	2026-01-01 17:30:05.447372	present	2026-03-02 15:43:44.318533
3105	100	2026-01-01	2026-01-01 09:21:07.080603	2026-01-01 17:41:53.234731	present	2026-03-02 15:43:44.318533
3106	3	2026-01-02	2026-01-02 09:52:20.192527	2026-01-02 17:56:22.870065	present	2026-03-02 15:43:44.318533
3107	4	2026-01-02	2026-01-02 09:43:22.216575	2026-01-02 17:36:16.553992	present	2026-03-02 15:43:44.318533
3108	5	2026-01-02	2026-01-02 09:26:18.325609	2026-01-02 17:59:06.083222	present	2026-03-02 15:43:44.318533
3109	6	2026-01-02	2026-01-02 09:12:45.164309	2026-01-02 17:14:43.029811	present	2026-03-02 15:43:44.318533
3110	10	2026-01-02	2026-01-02 09:35:13.809108	2026-01-02 17:33:53.054816	present	2026-03-02 15:43:44.318533
3111	11	2026-01-02	2026-01-02 09:09:37.677941	2026-01-02 17:33:38.101831	present	2026-03-02 15:43:44.318533
3112	27	2026-01-02	2026-01-02 09:27:13.681933	2026-01-02 17:48:44.305479	present	2026-03-02 15:43:44.318533
3113	33	2026-01-02	2026-01-02 09:44:50.05783	2026-01-02 17:08:18.278033	present	2026-03-02 15:43:44.318533
3114	35	2026-01-02	2026-01-02 09:34:24.145801	2026-01-02 17:19:58.117951	present	2026-03-02 15:43:44.318533
3115	37	2026-01-02	2026-01-02 09:03:07.165289	2026-01-02 17:57:58.662397	present	2026-03-02 15:43:44.318533
3116	43	2026-01-02	2026-01-02 09:27:59.382439	2026-01-02 17:05:20.920203	present	2026-03-02 15:43:44.318533
3117	45	2026-01-02	2026-01-02 09:41:10.035846	2026-01-02 17:26:08.220854	present	2026-03-02 15:43:44.318533
3118	46	2026-01-02	2026-01-02 09:59:46.696019	2026-01-02 17:44:46.745472	present	2026-03-02 15:43:44.318533
3119	47	2026-01-02	2026-01-02 09:44:26.693572	2026-01-02 17:10:20.187726	present	2026-03-02 15:43:44.318533
3120	48	2026-01-02	2026-01-02 09:36:03.970914	2026-01-02 17:09:05.588187	present	2026-03-02 15:43:44.318533
3121	50	2026-01-02	2026-01-02 09:14:29.251323	2026-01-02 17:37:43.303083	present	2026-03-02 15:43:44.318533
3122	52	2026-01-02	2026-01-02 09:19:47.838724	2026-01-02 17:56:30.840213	present	2026-03-02 15:43:44.318533
3123	59	2026-01-02	2026-01-02 09:30:04.194552	2026-01-02 17:44:22.20711	present	2026-03-02 15:43:44.318533
3124	60	2026-01-02	2026-01-02 09:06:09.56197	2026-01-02 17:56:18.792592	present	2026-03-02 15:43:44.318533
3125	62	2026-01-02	2026-01-02 09:16:05.280508	2026-01-02 17:42:07.999817	present	2026-03-02 15:43:44.318533
3126	63	2026-01-02	2026-01-02 09:57:25.313006	2026-01-02 17:05:47.214141	present	2026-03-02 15:43:44.318533
3127	64	2026-01-02	2026-01-02 09:03:51.850536	2026-01-02 17:36:37.172547	present	2026-03-02 15:43:44.318533
3128	65	2026-01-02	2026-01-02 09:44:32.074471	2026-01-02 17:24:54.58769	present	2026-03-02 15:43:44.318533
3129	66	2026-01-02	2026-01-02 09:43:51.773242	2026-01-02 17:57:44.239566	present	2026-03-02 15:43:44.318533
3130	70	2026-01-02	2026-01-02 09:12:57.874193	2026-01-02 17:38:16.710655	present	2026-03-02 15:43:44.318533
3131	71	2026-01-02	2026-01-02 09:06:55.649232	2026-01-02 17:57:26.596594	present	2026-03-02 15:43:44.318533
3132	73	2026-01-02	2026-01-02 09:58:18.086207	2026-01-02 17:02:23.919846	present	2026-03-02 15:43:44.318533
3133	74	2026-01-02	2026-01-02 09:43:59.144622	2026-01-02 17:57:19.800661	present	2026-03-02 15:43:44.318533
3134	78	2026-01-02	2026-01-02 09:08:31.615001	2026-01-02 17:53:46.153857	present	2026-03-02 15:43:44.318533
3135	79	2026-01-02	2026-01-02 09:21:53.129292	2026-01-02 17:34:14.072037	present	2026-03-02 15:43:44.318533
3136	82	2026-01-02	2026-01-02 09:31:13.970817	2026-01-02 17:47:10.477189	present	2026-03-02 15:43:44.318533
3137	83	2026-01-02	2026-01-02 09:38:13.50853	2026-01-02 17:23:44.801684	present	2026-03-02 15:43:44.318533
3138	84	2026-01-02	2026-01-02 09:06:31.927663	2026-01-02 17:35:23.260834	present	2026-03-02 15:43:44.318533
3139	85	2026-01-02	2026-01-02 09:44:10.854199	2026-01-02 17:24:10.920703	present	2026-03-02 15:43:44.318533
3140	88	2026-01-02	2026-01-02 09:31:14.724431	2026-01-02 17:45:03.558094	present	2026-03-02 15:43:44.318533
3141	89	2026-01-02	2026-01-02 09:47:18.539011	2026-01-02 17:44:17.330924	present	2026-03-02 15:43:44.318533
3142	96	2026-01-02	2026-01-02 09:45:19.438183	2026-01-02 17:11:41.301488	present	2026-03-02 15:43:44.318533
3143	97	2026-01-02	2026-01-02 09:02:16.672618	2026-01-02 17:20:52.872447	present	2026-03-02 15:43:44.318533
3144	1	2026-01-02	2026-01-02 09:03:57.251966	2026-01-02 17:12:50.561779	present	2026-03-02 15:43:44.318533
3145	2	2026-01-02	2026-01-02 09:10:05.187013	2026-01-02 17:57:25.230709	present	2026-03-02 15:43:44.318533
3146	7	2026-01-02	2026-01-02 09:31:34.240443	2026-01-02 17:10:08.295971	present	2026-03-02 15:43:44.318533
3147	8	2026-01-02	2026-01-02 09:44:01.500061	2026-01-02 17:49:09.430739	present	2026-03-02 15:43:44.318533
3148	9	2026-01-02	2026-01-02 09:47:58.020646	2026-01-02 17:07:17.593355	present	2026-03-02 15:43:44.318533
3149	12	2026-01-02	2026-01-02 09:37:34.437405	2026-01-02 17:06:26.282	present	2026-03-02 15:43:44.318533
3150	13	2026-01-02	2026-01-02 09:31:43.376936	2026-01-02 17:37:50.567023	present	2026-03-02 15:43:44.318533
3151	14	2026-01-02	2026-01-02 09:21:36.109305	2026-01-02 17:04:03.942626	present	2026-03-02 15:43:44.318533
3152	15	2026-01-02	2026-01-02 09:22:15.89851	2026-01-02 17:50:12.67002	present	2026-03-02 15:43:44.318533
3153	16	2026-01-02	2026-01-02 09:06:25.363884	2026-01-02 17:40:07.277198	present	2026-03-02 15:43:44.318533
3154	17	2026-01-02	2026-01-02 09:49:42.33852	2026-01-02 17:46:31.254252	present	2026-03-02 15:43:44.318533
3155	18	2026-01-02	2026-01-02 09:10:09.832765	2026-01-02 17:32:13.115938	present	2026-03-02 15:43:44.318533
3156	19	2026-01-02	2026-01-02 09:27:56.561489	2026-01-02 17:04:26.15404	present	2026-03-02 15:43:44.318533
3157	20	2026-01-02	2026-01-02 09:17:35.705975	2026-01-02 17:48:55.522209	present	2026-03-02 15:43:44.318533
3158	21	2026-01-02	2026-01-02 09:38:23.445917	2026-01-02 17:31:09.412485	present	2026-03-02 15:43:44.318533
3159	22	2026-01-02	2026-01-02 09:35:42.477772	2026-01-02 17:33:12.673215	present	2026-03-02 15:43:44.318533
3160	23	2026-01-02	2026-01-02 09:13:20.3264	2026-01-02 17:56:33.137634	present	2026-03-02 15:43:44.318533
3161	24	2026-01-02	2026-01-02 09:26:51.394665	2026-01-02 17:32:12.132762	present	2026-03-02 15:43:44.318533
3162	25	2026-01-02	2026-01-02 09:47:03.054802	2026-01-02 17:03:57.267024	present	2026-03-02 15:43:44.318533
3163	26	2026-01-02	2026-01-02 09:57:05.160769	2026-01-02 17:05:44.726539	present	2026-03-02 15:43:44.318533
3164	28	2026-01-02	2026-01-02 09:38:12.486553	2026-01-02 17:45:05.307142	present	2026-03-02 15:43:44.318533
3165	29	2026-01-02	2026-01-02 09:07:23.5389	2026-01-02 17:13:31.939718	present	2026-03-02 15:43:44.318533
3166	30	2026-01-02	2026-01-02 09:05:31.146863	2026-01-02 17:13:37.798079	present	2026-03-02 15:43:44.318533
3167	31	2026-01-02	2026-01-02 09:29:52.121157	2026-01-02 17:24:55.605067	present	2026-03-02 15:43:44.318533
3168	32	2026-01-02	2026-01-02 09:06:43.437839	2026-01-02 17:34:08.764356	present	2026-03-02 15:43:44.318533
3169	34	2026-01-02	2026-01-02 09:30:43.084861	2026-01-02 17:22:26.949769	present	2026-03-02 15:43:44.318533
3170	36	2026-01-02	2026-01-02 09:13:13.070515	2026-01-02 17:48:50.383776	present	2026-03-02 15:43:44.318533
3171	38	2026-01-02	2026-01-02 09:06:45.382967	2026-01-02 17:04:33.482201	present	2026-03-02 15:43:44.318533
3172	39	2026-01-02	2026-01-02 09:59:59.167888	2026-01-02 17:50:51.083591	present	2026-03-02 15:43:44.318533
3173	40	2026-01-02	2026-01-02 09:44:05.365934	2026-01-02 17:42:44.634214	present	2026-03-02 15:43:44.318533
3174	41	2026-01-02	2026-01-02 09:19:58.9154	2026-01-02 17:08:56.249087	present	2026-03-02 15:43:44.318533
3175	42	2026-01-02	2026-01-02 09:42:11.838483	2026-01-02 17:01:58.702415	present	2026-03-02 15:43:44.318533
3176	44	2026-01-02	2026-01-02 09:20:02.018796	2026-01-02 17:18:12.63953	present	2026-03-02 15:43:44.318533
3177	49	2026-01-02	2026-01-02 09:25:38.282663	2026-01-02 17:27:43.271642	present	2026-03-02 15:43:44.318533
3178	51	2026-01-02	2026-01-02 09:31:53.861368	2026-01-02 17:29:16.12379	present	2026-03-02 15:43:44.318533
3179	53	2026-01-02	2026-01-02 09:54:09.871297	2026-01-02 17:58:37.627956	present	2026-03-02 15:43:44.318533
3180	54	2026-01-02	2026-01-02 09:43:28.442941	2026-01-02 17:04:14.541202	present	2026-03-02 15:43:44.318533
3181	55	2026-01-02	2026-01-02 09:58:55.906469	2026-01-02 17:26:38.84748	present	2026-03-02 15:43:44.318533
3182	56	2026-01-02	2026-01-02 09:25:29.904265	2026-01-02 17:21:20.959779	present	2026-03-02 15:43:44.318533
3183	57	2026-01-02	2026-01-02 09:21:51.810128	2026-01-02 17:50:42.998083	present	2026-03-02 15:43:44.318533
3184	58	2026-01-02	2026-01-02 09:26:51.088004	2026-01-02 17:22:22.287367	present	2026-03-02 15:43:44.318533
3185	61	2026-01-02	2026-01-02 09:36:29.928891	2026-01-02 17:46:16.701601	present	2026-03-02 15:43:44.318533
3186	67	2026-01-02	2026-01-02 09:51:34.543398	2026-01-02 17:31:54.143744	present	2026-03-02 15:43:44.318533
3187	68	2026-01-02	2026-01-02 09:13:01.960804	2026-01-02 17:28:17.546623	present	2026-03-02 15:43:44.318533
3188	69	2026-01-02	2026-01-02 09:58:56.785732	2026-01-02 17:11:45.202286	present	2026-03-02 15:43:44.318533
3189	72	2026-01-02	2026-01-02 09:05:35.523267	2026-01-02 17:56:03.289446	present	2026-03-02 15:43:44.318533
3190	75	2026-01-02	2026-01-02 09:41:30.899038	2026-01-02 17:44:21.813825	present	2026-03-02 15:43:44.318533
3191	76	2026-01-02	2026-01-02 09:40:14.980125	2026-01-02 17:57:01.741879	present	2026-03-02 15:43:44.318533
3192	77	2026-01-02	2026-01-02 09:00:05.823133	2026-01-02 17:16:04.320541	present	2026-03-02 15:43:44.318533
3193	80	2026-01-02	2026-01-02 09:30:29.974691	2026-01-02 17:18:07.70373	present	2026-03-02 15:43:44.318533
3194	81	2026-01-02	2026-01-02 09:23:47.027702	2026-01-02 17:34:26.846583	present	2026-03-02 15:43:44.318533
3195	86	2026-01-02	2026-01-02 09:41:40.598312	2026-01-02 17:34:30.940413	present	2026-03-02 15:43:44.318533
3196	87	2026-01-02	2026-01-02 09:06:56.443359	2026-01-02 17:48:33.370321	present	2026-03-02 15:43:44.318533
3197	90	2026-01-02	2026-01-02 09:49:41.974474	2026-01-02 17:24:44.628773	present	2026-03-02 15:43:44.318533
3198	91	2026-01-02	2026-01-02 09:36:18.512095	2026-01-02 17:18:27.097917	present	2026-03-02 15:43:44.318533
3199	92	2026-01-02	2026-01-02 09:43:43.015021	2026-01-02 17:45:13.565923	present	2026-03-02 15:43:44.318533
3200	93	2026-01-02	2026-01-02 09:54:48.005674	2026-01-02 17:48:02.403637	present	2026-03-02 15:43:44.318533
3201	94	2026-01-02	2026-01-02 09:14:09.268119	2026-01-02 17:44:00.349614	present	2026-03-02 15:43:44.318533
3202	95	2026-01-02	2026-01-02 09:41:04.527405	2026-01-02 17:10:26.040671	present	2026-03-02 15:43:44.318533
3203	98	2026-01-02	2026-01-02 09:11:41.832816	2026-01-02 17:33:35.473386	present	2026-03-02 15:43:44.318533
3204	99	2026-01-02	2026-01-02 09:11:39.147135	2026-01-02 17:32:46.595469	present	2026-03-02 15:43:44.318533
3205	100	2026-01-02	2026-01-02 09:02:52.962784	2026-01-02 17:18:29.796111	present	2026-03-02 15:43:44.318533
3206	3	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3207	4	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3208	5	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3209	6	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3210	10	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3211	11	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3212	27	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3213	33	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3214	35	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3215	37	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3216	43	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3217	45	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3218	46	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3219	47	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3220	48	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3221	50	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3222	52	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3223	59	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3224	60	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3225	62	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3226	63	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3227	64	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3228	65	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3229	66	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3230	70	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3231	71	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3232	73	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3233	74	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3234	78	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3235	79	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3236	82	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3237	83	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3238	84	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3239	85	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3240	88	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3241	89	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3242	96	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3243	97	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3244	1	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3245	2	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3246	7	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3247	8	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3248	9	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3249	12	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3250	13	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3251	14	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3252	15	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3253	16	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3254	17	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3255	18	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3256	19	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3257	20	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3258	21	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3259	22	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3260	23	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3261	24	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3262	25	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3263	26	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3264	28	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3265	29	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3266	30	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3267	31	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3268	32	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3269	34	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3270	36	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3271	38	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3272	39	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3273	40	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3274	41	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3275	42	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3276	44	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3277	49	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3278	51	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3279	53	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3280	54	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3281	55	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3282	56	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3283	57	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3284	58	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3285	61	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3286	67	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3287	68	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3288	69	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3289	72	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3290	75	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3291	76	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3292	77	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3293	80	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3294	81	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3295	86	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3296	87	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3297	90	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3298	91	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3299	92	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3300	93	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3301	94	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3302	95	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3303	98	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3304	99	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3305	100	2026-01-03	\N	\N	absent	2026-03-02 15:43:44.318533
3306	3	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3307	4	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3308	5	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3309	6	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3310	10	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3311	11	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3312	27	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3313	33	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3314	35	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3315	37	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3316	43	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3317	45	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3318	46	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3319	47	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3320	48	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3321	50	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3322	52	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3323	59	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3324	60	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3325	62	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3326	63	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3327	64	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3328	65	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3329	66	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3330	70	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3331	71	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3332	73	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3333	74	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3334	78	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3335	79	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3336	82	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3337	83	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3338	84	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3339	85	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3340	88	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3341	89	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3342	96	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3343	97	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3344	1	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3345	2	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3346	7	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3347	8	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3348	9	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3349	12	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3350	13	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3351	14	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3352	15	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3353	16	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3354	17	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3355	18	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3356	19	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3357	20	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3358	21	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3359	22	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3360	23	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3361	24	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3362	25	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3363	26	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3364	28	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3365	29	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3366	30	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3367	31	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3368	32	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3369	34	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3370	36	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3371	38	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3372	39	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3373	40	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3374	41	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3375	42	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3376	44	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3377	49	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3378	51	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3379	53	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3380	54	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3381	55	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3382	56	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3383	57	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3384	58	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3385	61	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3386	67	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3387	68	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3388	69	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3389	72	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3390	75	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3391	76	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3392	77	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3393	80	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3394	81	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3395	86	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3396	87	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3397	90	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3398	91	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3399	92	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3400	93	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3401	94	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3402	95	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3403	98	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3404	99	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3405	100	2026-01-04	\N	\N	absent	2026-03-02 15:43:44.318533
3406	3	2026-01-05	2026-01-05 09:39:36.097521	2026-01-05 17:40:09.884086	present	2026-03-02 15:43:44.318533
3407	4	2026-01-05	2026-01-05 09:55:03.956454	2026-01-05 17:53:32.725795	present	2026-03-02 15:43:44.318533
3408	5	2026-01-05	2026-01-05 09:44:50.182877	2026-01-05 17:07:38.480738	present	2026-03-02 15:43:44.318533
3409	6	2026-01-05	2026-01-05 09:34:45.303267	2026-01-05 17:16:39.365246	present	2026-03-02 15:43:44.318533
3410	10	2026-01-05	2026-01-05 09:57:16.006904	2026-01-05 17:46:36.742824	present	2026-03-02 15:43:44.318533
3411	11	2026-01-05	2026-01-05 09:44:21.632186	2026-01-05 17:20:44.551443	present	2026-03-02 15:43:44.318533
3412	27	2026-01-05	2026-01-05 09:57:00.049698	2026-01-05 17:47:50.833684	present	2026-03-02 15:43:44.318533
3413	33	2026-01-05	2026-01-05 09:46:46.321761	2026-01-05 17:42:24.389959	present	2026-03-02 15:43:44.318533
3414	35	2026-01-05	2026-01-05 09:01:41.797763	2026-01-05 17:13:06.023014	present	2026-03-02 15:43:44.318533
3415	37	2026-01-05	2026-01-05 09:24:05.896595	2026-01-05 17:32:35.495875	present	2026-03-02 15:43:44.318533
3416	43	2026-01-05	2026-01-05 09:37:03.352477	2026-01-05 17:22:38.710941	present	2026-03-02 15:43:44.318533
3417	45	2026-01-05	2026-01-05 09:46:13.392141	2026-01-05 17:43:26.499537	present	2026-03-02 15:43:44.318533
3418	46	2026-01-05	2026-01-05 09:40:18.282259	2026-01-05 17:29:26.347284	present	2026-03-02 15:43:44.318533
3419	47	2026-01-05	2026-01-05 09:08:35.101926	2026-01-05 17:46:46.540922	present	2026-03-02 15:43:44.318533
3420	48	2026-01-05	2026-01-05 09:43:56.292558	2026-01-05 17:27:52.932073	present	2026-03-02 15:43:44.318533
3421	50	2026-01-05	2026-01-05 09:30:13.161545	2026-01-05 17:42:03.35927	present	2026-03-02 15:43:44.318533
3422	52	2026-01-05	2026-01-05 09:53:12.547275	2026-01-05 17:36:57.369801	present	2026-03-02 15:43:44.318533
3423	59	2026-01-05	2026-01-05 09:29:23.833624	2026-01-05 17:35:31.942478	present	2026-03-02 15:43:44.318533
3424	60	2026-01-05	2026-01-05 09:06:27.327025	2026-01-05 17:24:42.686463	present	2026-03-02 15:43:44.318533
3425	62	2026-01-05	2026-01-05 09:07:18.880687	2026-01-05 17:15:14.648583	present	2026-03-02 15:43:44.318533
3426	63	2026-01-05	2026-01-05 09:39:16.605978	2026-01-05 17:33:13.704103	present	2026-03-02 15:43:44.318533
3427	64	2026-01-05	2026-01-05 09:54:51.70216	2026-01-05 17:37:52.816889	present	2026-03-02 15:43:44.318533
3428	65	2026-01-05	2026-01-05 09:32:18.252081	2026-01-05 17:16:03.527905	present	2026-03-02 15:43:44.318533
3429	66	2026-01-05	2026-01-05 09:00:45.648477	2026-01-05 17:58:10.712266	present	2026-03-02 15:43:44.318533
3430	70	2026-01-05	2026-01-05 09:15:29.802222	2026-01-05 17:57:59.770701	present	2026-03-02 15:43:44.318533
3431	71	2026-01-05	2026-01-05 09:25:32.251799	2026-01-05 17:50:18.758972	present	2026-03-02 15:43:44.318533
3432	73	2026-01-05	2026-01-05 09:04:34.044352	2026-01-05 17:51:16.685478	present	2026-03-02 15:43:44.318533
3433	74	2026-01-05	2026-01-05 09:51:31.6686	2026-01-05 17:49:12.772751	present	2026-03-02 15:43:44.318533
3434	78	2026-01-05	2026-01-05 09:30:19.001222	2026-01-05 17:50:45.716379	present	2026-03-02 15:43:44.318533
3435	79	2026-01-05	2026-01-05 09:40:11.813493	2026-01-05 17:56:00.367354	present	2026-03-02 15:43:44.318533
3436	82	2026-01-05	2026-01-05 09:04:46.655833	2026-01-05 17:49:15.807898	present	2026-03-02 15:43:44.318533
3437	83	2026-01-05	2026-01-05 09:40:28.565597	2026-01-05 17:33:11.916799	present	2026-03-02 15:43:44.318533
3438	84	2026-01-05	2026-01-05 09:06:50.649363	2026-01-05 17:01:48.62696	present	2026-03-02 15:43:44.318533
3439	85	2026-01-05	2026-01-05 09:55:08.53641	2026-01-05 17:13:16.625131	present	2026-03-02 15:43:44.318533
3440	88	2026-01-05	2026-01-05 09:52:30.257461	2026-01-05 17:59:16.121265	present	2026-03-02 15:43:44.318533
3441	89	2026-01-05	2026-01-05 09:07:04.003954	2026-01-05 17:10:07.571743	present	2026-03-02 15:43:44.318533
3442	96	2026-01-05	2026-01-05 09:11:57.893495	2026-01-05 17:50:41.780881	present	2026-03-02 15:43:44.318533
3443	97	2026-01-05	2026-01-05 09:08:02.39344	2026-01-05 17:57:26.560561	present	2026-03-02 15:43:44.318533
3444	1	2026-01-05	2026-01-05 09:38:47.770992	2026-01-05 17:34:19.498394	present	2026-03-02 15:43:44.318533
3445	2	2026-01-05	2026-01-05 09:09:26.062866	2026-01-05 17:43:26.531908	present	2026-03-02 15:43:44.318533
3446	7	2026-01-05	2026-01-05 09:12:28.821377	2026-01-05 17:19:54.864568	present	2026-03-02 15:43:44.318533
3447	8	2026-01-05	2026-01-05 09:53:41.298297	2026-01-05 17:37:37.006397	present	2026-03-02 15:43:44.318533
3448	9	2026-01-05	2026-01-05 09:32:07.392946	2026-01-05 17:12:12.920942	present	2026-03-02 15:43:44.318533
3449	12	2026-01-05	2026-01-05 09:47:07.868946	2026-01-05 17:26:54.879626	present	2026-03-02 15:43:44.318533
3450	13	2026-01-05	2026-01-05 09:30:54.347135	2026-01-05 17:33:24.439871	present	2026-03-02 15:43:44.318533
3451	14	2026-01-05	2026-01-05 09:22:59.705053	2026-01-05 17:27:56.716119	present	2026-03-02 15:43:44.318533
3452	15	2026-01-05	2026-01-05 09:07:19.161449	2026-01-05 17:36:57.152473	present	2026-03-02 15:43:44.318533
3453	16	2026-01-05	2026-01-05 09:06:25.800208	2026-01-05 17:44:07.592579	present	2026-03-02 15:43:44.318533
3454	17	2026-01-05	2026-01-05 09:12:59.091578	2026-01-05 17:07:18.154297	present	2026-03-02 15:43:44.318533
3455	18	2026-01-05	2026-01-05 09:07:34.395262	2026-01-05 17:30:15.144267	present	2026-03-02 15:43:44.318533
3456	19	2026-01-05	2026-01-05 09:10:24.779641	2026-01-05 17:23:44.927688	present	2026-03-02 15:43:44.318533
3457	20	2026-01-05	2026-01-05 09:15:33.376091	2026-01-05 17:04:39.943547	present	2026-03-02 15:43:44.318533
3458	21	2026-01-05	2026-01-05 09:49:53.444411	2026-01-05 17:36:59.514482	present	2026-03-02 15:43:44.318533
3459	22	2026-01-05	2026-01-05 09:19:17.400269	2026-01-05 17:57:23.337074	present	2026-03-02 15:43:44.318533
3460	23	2026-01-05	2026-01-05 09:59:11.74426	2026-01-05 17:53:34.999414	present	2026-03-02 15:43:44.318533
3461	24	2026-01-05	2026-01-05 09:42:40.13397	2026-01-05 17:26:19.438012	present	2026-03-02 15:43:44.318533
3462	25	2026-01-05	2026-01-05 09:04:38.120623	2026-01-05 17:11:42.160268	present	2026-03-02 15:43:44.318533
3463	26	2026-01-05	2026-01-05 09:55:39.75153	2026-01-05 17:22:17.080393	present	2026-03-02 15:43:44.318533
3464	28	2026-01-05	2026-01-05 09:06:39.845085	2026-01-05 17:12:45.171186	present	2026-03-02 15:43:44.318533
3465	29	2026-01-05	2026-01-05 09:03:21.327568	2026-01-05 17:53:12.281364	present	2026-03-02 15:43:44.318533
3466	30	2026-01-05	2026-01-05 09:13:07.124877	2026-01-05 17:41:15.765382	present	2026-03-02 15:43:44.318533
3467	31	2026-01-05	2026-01-05 09:18:38.862334	2026-01-05 17:36:44.493925	present	2026-03-02 15:43:44.318533
3468	32	2026-01-05	2026-01-05 09:58:03.283138	2026-01-05 17:32:41.773594	present	2026-03-02 15:43:44.318533
3469	34	2026-01-05	2026-01-05 09:43:22.908848	2026-01-05 17:22:37.605185	present	2026-03-02 15:43:44.318533
3470	36	2026-01-05	2026-01-05 09:22:29.427898	2026-01-05 17:04:45.803677	present	2026-03-02 15:43:44.318533
3471	38	2026-01-05	2026-01-05 09:29:23.630585	2026-01-05 17:00:27.252841	present	2026-03-02 15:43:44.318533
3472	39	2026-01-05	2026-01-05 09:55:08.863144	2026-01-05 17:31:57.75752	present	2026-03-02 15:43:44.318533
3473	40	2026-01-05	2026-01-05 09:05:28.554452	2026-01-05 17:07:51.517166	present	2026-03-02 15:43:44.318533
3474	41	2026-01-05	2026-01-05 09:17:21.884049	2026-01-05 17:40:21.545911	present	2026-03-02 15:43:44.318533
3475	42	2026-01-05	2026-01-05 09:47:35.573191	2026-01-05 17:39:09.778009	present	2026-03-02 15:43:44.318533
3476	44	2026-01-05	2026-01-05 09:19:28.112267	2026-01-05 17:50:49.966117	present	2026-03-02 15:43:44.318533
3477	49	2026-01-05	2026-01-05 09:50:21.834153	2026-01-05 17:01:04.601663	present	2026-03-02 15:43:44.318533
3478	51	2026-01-05	2026-01-05 09:30:56.043637	2026-01-05 17:15:35.158702	present	2026-03-02 15:43:44.318533
3479	53	2026-01-05	2026-01-05 09:03:40.409236	2026-01-05 17:30:54.13321	present	2026-03-02 15:43:44.318533
3480	54	2026-01-05	2026-01-05 09:55:24.981931	2026-01-05 17:58:06.301096	present	2026-03-02 15:43:44.318533
3481	55	2026-01-05	2026-01-05 09:04:17.575811	2026-01-05 17:26:32.023677	present	2026-03-02 15:43:44.318533
3482	56	2026-01-05	2026-01-05 09:38:50.340151	2026-01-05 17:26:21.902208	present	2026-03-02 15:43:44.318533
3483	57	2026-01-05	2026-01-05 09:33:29.093753	2026-01-05 17:12:59.432364	present	2026-03-02 15:43:44.318533
3484	58	2026-01-05	2026-01-05 09:39:50.443861	2026-01-05 17:45:45.652779	present	2026-03-02 15:43:44.318533
3485	61	2026-01-05	2026-01-05 09:47:38.907849	2026-01-05 17:27:15.975528	present	2026-03-02 15:43:44.318533
3486	67	2026-01-05	2026-01-05 09:20:19.051653	2026-01-05 17:20:45.211238	present	2026-03-02 15:43:44.318533
3487	68	2026-01-05	2026-01-05 09:49:46.413258	2026-01-05 17:27:28.295461	present	2026-03-02 15:43:44.318533
3488	69	2026-01-05	2026-01-05 09:44:34.930139	2026-01-05 17:50:40.348553	present	2026-03-02 15:43:44.318533
3489	72	2026-01-05	2026-01-05 09:50:10.385362	2026-01-05 17:56:50.141133	present	2026-03-02 15:43:44.318533
3490	75	2026-01-05	2026-01-05 09:22:02.53628	2026-01-05 17:14:30.946721	present	2026-03-02 15:43:44.318533
3491	76	2026-01-05	2026-01-05 09:44:44.727279	2026-01-05 17:13:04.610343	present	2026-03-02 15:43:44.318533
3492	77	2026-01-05	2026-01-05 09:46:18.726413	2026-01-05 17:45:32.64906	present	2026-03-02 15:43:44.318533
3493	80	2026-01-05	2026-01-05 09:30:01.257423	2026-01-05 17:38:25.480529	present	2026-03-02 15:43:44.318533
3494	81	2026-01-05	2026-01-05 09:08:37.870063	2026-01-05 17:46:15.224883	present	2026-03-02 15:43:44.318533
3495	86	2026-01-05	2026-01-05 09:29:16.78811	2026-01-05 17:35:38.391945	present	2026-03-02 15:43:44.318533
3496	87	2026-01-05	2026-01-05 09:24:56.642875	2026-01-05 17:23:28.797114	present	2026-03-02 15:43:44.318533
3497	90	2026-01-05	2026-01-05 09:38:42.252084	2026-01-05 17:10:30.6037	present	2026-03-02 15:43:44.318533
3498	91	2026-01-05	2026-01-05 09:46:21.998647	2026-01-05 17:01:09.384472	present	2026-03-02 15:43:44.318533
3499	92	2026-01-05	2026-01-05 09:48:29.491029	2026-01-05 17:35:20.739975	present	2026-03-02 15:43:44.318533
3500	93	2026-01-05	2026-01-05 09:11:31.426393	2026-01-05 17:58:33.564338	present	2026-03-02 15:43:44.318533
3501	94	2026-01-05	2026-01-05 09:06:20.223167	2026-01-05 17:12:44.925839	present	2026-03-02 15:43:44.318533
3502	95	2026-01-05	2026-01-05 09:52:12.821644	2026-01-05 17:10:57.176899	present	2026-03-02 15:43:44.318533
3503	98	2026-01-05	2026-01-05 09:33:37.885206	2026-01-05 17:40:20.062563	present	2026-03-02 15:43:44.318533
3504	99	2026-01-05	2026-01-05 09:22:21.672242	2026-01-05 17:33:28.551391	present	2026-03-02 15:43:44.318533
3505	100	2026-01-05	2026-01-05 09:15:46.942606	2026-01-05 17:27:31.74162	present	2026-03-02 15:43:44.318533
3506	3	2026-01-06	2026-01-06 09:17:27.499422	2026-01-06 17:01:25.659664	present	2026-03-02 15:43:44.318533
3507	4	2026-01-06	2026-01-06 09:13:31.662433	2026-01-06 17:56:13.704863	present	2026-03-02 15:43:44.318533
3508	5	2026-01-06	2026-01-06 09:20:40.094937	2026-01-06 17:29:23.446508	present	2026-03-02 15:43:44.318533
3509	6	2026-01-06	2026-01-06 09:01:31.911467	2026-01-06 17:19:45.51461	present	2026-03-02 15:43:44.318533
3510	10	2026-01-06	2026-01-06 09:10:51.071217	2026-01-06 17:19:04.055578	present	2026-03-02 15:43:44.318533
3511	11	2026-01-06	2026-01-06 09:20:26.384032	2026-01-06 17:13:45.148857	present	2026-03-02 15:43:44.318533
3512	27	2026-01-06	2026-01-06 09:37:06.883543	2026-01-06 17:30:46.641414	present	2026-03-02 15:43:44.318533
3513	33	2026-01-06	2026-01-06 09:37:33.414989	2026-01-06 17:57:31.199431	present	2026-03-02 15:43:44.318533
3514	35	2026-01-06	2026-01-06 09:15:37.669242	2026-01-06 17:04:41.177476	present	2026-03-02 15:43:44.318533
3515	37	2026-01-06	2026-01-06 09:39:36.740757	2026-01-06 17:12:16.623108	present	2026-03-02 15:43:44.318533
3516	43	2026-01-06	2026-01-06 09:20:48.074057	2026-01-06 17:58:53.110309	present	2026-03-02 15:43:44.318533
3517	45	2026-01-06	2026-01-06 09:26:09.650972	2026-01-06 17:18:55.262949	present	2026-03-02 15:43:44.318533
3518	46	2026-01-06	2026-01-06 09:35:26.188218	2026-01-06 17:28:54.091966	present	2026-03-02 15:43:44.318533
3519	47	2026-01-06	2026-01-06 09:03:23.721811	2026-01-06 17:54:01.427877	present	2026-03-02 15:43:44.318533
3520	48	2026-01-06	2026-01-06 09:31:18.809416	2026-01-06 17:30:23.068421	present	2026-03-02 15:43:44.318533
3521	50	2026-01-06	2026-01-06 09:30:38.972474	2026-01-06 17:06:38.802627	present	2026-03-02 15:43:44.318533
3522	52	2026-01-06	2026-01-06 09:13:20.972531	2026-01-06 17:35:36.492289	present	2026-03-02 15:43:44.318533
3523	59	2026-01-06	2026-01-06 09:38:27.330006	2026-01-06 17:04:56.403571	present	2026-03-02 15:43:44.318533
3524	60	2026-01-06	2026-01-06 09:43:36.888274	2026-01-06 17:06:55.253586	present	2026-03-02 15:43:44.318533
3525	62	2026-01-06	2026-01-06 09:46:09.545453	2026-01-06 17:53:00.378102	present	2026-03-02 15:43:44.318533
3526	63	2026-01-06	2026-01-06 09:56:19.363318	2026-01-06 17:15:40.740605	present	2026-03-02 15:43:44.318533
3527	64	2026-01-06	2026-01-06 09:59:30.915794	2026-01-06 17:49:21.355098	present	2026-03-02 15:43:44.318533
3528	65	2026-01-06	2026-01-06 09:04:46.346083	2026-01-06 17:41:28.90833	present	2026-03-02 15:43:44.318533
3529	66	2026-01-06	2026-01-06 09:42:56.10973	2026-01-06 17:07:39.658623	present	2026-03-02 15:43:44.318533
3530	70	2026-01-06	2026-01-06 09:54:24.826998	2026-01-06 17:43:09.815414	present	2026-03-02 15:43:44.318533
3531	71	2026-01-06	2026-01-06 09:31:57.962352	2026-01-06 17:51:35.604544	present	2026-03-02 15:43:44.318533
3532	73	2026-01-06	2026-01-06 09:13:30.786056	2026-01-06 17:53:30.951489	present	2026-03-02 15:43:44.318533
3533	74	2026-01-06	2026-01-06 09:40:49.25335	2026-01-06 17:01:03.396814	present	2026-03-02 15:43:44.318533
3534	78	2026-01-06	2026-01-06 09:26:15.751781	2026-01-06 17:50:09.391311	present	2026-03-02 15:43:44.318533
3535	79	2026-01-06	2026-01-06 09:59:15.421275	2026-01-06 17:33:41.856225	present	2026-03-02 15:43:44.318533
3536	82	2026-01-06	2026-01-06 09:27:39.685254	2026-01-06 17:10:23.722016	present	2026-03-02 15:43:44.318533
3537	83	2026-01-06	2026-01-06 09:33:08.242358	2026-01-06 17:09:15.111312	present	2026-03-02 15:43:44.318533
3538	84	2026-01-06	2026-01-06 09:28:24.126961	2026-01-06 17:01:10.515397	present	2026-03-02 15:43:44.318533
3539	85	2026-01-06	2026-01-06 09:21:22.08658	2026-01-06 17:10:29.367221	present	2026-03-02 15:43:44.318533
3540	88	2026-01-06	2026-01-06 09:33:45.066261	2026-01-06 17:12:50.371012	present	2026-03-02 15:43:44.318533
3541	89	2026-01-06	2026-01-06 09:16:15.98347	2026-01-06 17:45:55.345665	present	2026-03-02 15:43:44.318533
3542	96	2026-01-06	2026-01-06 09:41:08.824108	2026-01-06 17:55:40.204491	present	2026-03-02 15:43:44.318533
3543	97	2026-01-06	2026-01-06 09:51:27.478269	2026-01-06 17:49:20.51292	present	2026-03-02 15:43:44.318533
3544	1	2026-01-06	2026-01-06 09:49:53.027926	2026-01-06 17:14:56.944426	present	2026-03-02 15:43:44.318533
3545	2	2026-01-06	2026-01-06 09:54:33.467263	2026-01-06 17:40:51.317419	present	2026-03-02 15:43:44.318533
3546	7	2026-01-06	2026-01-06 09:42:54.029308	2026-01-06 17:08:52.519203	present	2026-03-02 15:43:44.318533
3547	8	2026-01-06	2026-01-06 09:10:28.67008	2026-01-06 17:31:42.085584	present	2026-03-02 15:43:44.318533
3548	9	2026-01-06	2026-01-06 09:14:34.288854	2026-01-06 17:40:55.636357	present	2026-03-02 15:43:44.318533
3549	12	2026-01-06	2026-01-06 09:16:13.477006	2026-01-06 17:58:15.697961	present	2026-03-02 15:43:44.318533
3550	13	2026-01-06	2026-01-06 09:41:54.731311	2026-01-06 17:56:44.767969	present	2026-03-02 15:43:44.318533
3551	14	2026-01-06	2026-01-06 09:09:51.223419	2026-01-06 17:44:29.815308	present	2026-03-02 15:43:44.318533
3552	15	2026-01-06	2026-01-06 09:18:56.920144	2026-01-06 17:51:36.698458	present	2026-03-02 15:43:44.318533
3553	16	2026-01-06	2026-01-06 09:48:56.938386	2026-01-06 17:43:30.383632	present	2026-03-02 15:43:44.318533
3554	17	2026-01-06	2026-01-06 09:49:23.817136	2026-01-06 17:26:24.635464	present	2026-03-02 15:43:44.318533
3555	18	2026-01-06	2026-01-06 09:07:48.501641	2026-01-06 17:16:31.099524	present	2026-03-02 15:43:44.318533
3556	19	2026-01-06	2026-01-06 09:48:25.341549	2026-01-06 17:32:21.470479	present	2026-03-02 15:43:44.318533
3557	20	2026-01-06	2026-01-06 09:27:14.332718	2026-01-06 17:22:50.393795	present	2026-03-02 15:43:44.318533
3558	21	2026-01-06	2026-01-06 09:29:32.963173	2026-01-06 17:37:25.630366	present	2026-03-02 15:43:44.318533
3559	22	2026-01-06	2026-01-06 09:50:37.365068	2026-01-06 17:47:02.053072	present	2026-03-02 15:43:44.318533
3560	23	2026-01-06	2026-01-06 09:23:03.010237	2026-01-06 17:26:27.051625	present	2026-03-02 15:43:44.318533
3561	24	2026-01-06	2026-01-06 09:13:37.646532	2026-01-06 17:00:33.477994	present	2026-03-02 15:43:44.318533
3562	25	2026-01-06	2026-01-06 09:30:53.312652	2026-01-06 17:32:45.312527	present	2026-03-02 15:43:44.318533
3563	26	2026-01-06	2026-01-06 09:46:07.990917	2026-01-06 17:30:46.68208	present	2026-03-02 15:43:44.318533
3564	28	2026-01-06	2026-01-06 09:29:22.501551	2026-01-06 17:43:48.12302	present	2026-03-02 15:43:44.318533
3565	29	2026-01-06	2026-01-06 09:03:31.981768	2026-01-06 17:53:46.460221	present	2026-03-02 15:43:44.318533
3566	30	2026-01-06	2026-01-06 09:22:26.932819	2026-01-06 17:47:50.589637	present	2026-03-02 15:43:44.318533
3567	31	2026-01-06	2026-01-06 09:53:56.255046	2026-01-06 17:06:16.441446	present	2026-03-02 15:43:44.318533
3568	32	2026-01-06	2026-01-06 09:18:14.004095	2026-01-06 17:02:06.30455	present	2026-03-02 15:43:44.318533
3569	34	2026-01-06	2026-01-06 09:36:21.749196	2026-01-06 17:44:57.563366	present	2026-03-02 15:43:44.318533
3570	36	2026-01-06	2026-01-06 09:01:07.103997	2026-01-06 17:50:54.001532	present	2026-03-02 15:43:44.318533
3571	38	2026-01-06	2026-01-06 09:29:17.996857	2026-01-06 17:58:39.79325	present	2026-03-02 15:43:44.318533
3572	39	2026-01-06	2026-01-06 09:07:46.499627	2026-01-06 17:43:36.749042	present	2026-03-02 15:43:44.318533
3573	40	2026-01-06	2026-01-06 09:30:55.03259	2026-01-06 17:59:26.45963	present	2026-03-02 15:43:44.318533
3574	41	2026-01-06	2026-01-06 09:33:50.727178	2026-01-06 17:40:00.735137	present	2026-03-02 15:43:44.318533
3575	42	2026-01-06	2026-01-06 09:00:53.799722	2026-01-06 17:07:57.465962	present	2026-03-02 15:43:44.318533
3576	44	2026-01-06	2026-01-06 09:01:29.233894	2026-01-06 17:31:22.379012	present	2026-03-02 15:43:44.318533
3577	49	2026-01-06	2026-01-06 09:17:08.590426	2026-01-06 17:01:26.361639	present	2026-03-02 15:43:44.318533
3578	51	2026-01-06	2026-01-06 09:55:22.984397	2026-01-06 17:24:00.528344	present	2026-03-02 15:43:44.318533
3579	53	2026-01-06	2026-01-06 09:45:30.455211	2026-01-06 17:03:49.148705	present	2026-03-02 15:43:44.318533
3580	54	2026-01-06	2026-01-06 09:11:30.499495	2026-01-06 17:07:49.910518	present	2026-03-02 15:43:44.318533
3581	55	2026-01-06	2026-01-06 09:11:29.906531	2026-01-06 17:12:39.416727	present	2026-03-02 15:43:44.318533
3582	56	2026-01-06	2026-01-06 09:40:48.069101	2026-01-06 17:07:53.571627	present	2026-03-02 15:43:44.318533
3583	57	2026-01-06	2026-01-06 09:23:50.867292	2026-01-06 17:56:38.215526	present	2026-03-02 15:43:44.318533
3584	58	2026-01-06	2026-01-06 09:02:47.276696	2026-01-06 17:55:27.717718	present	2026-03-02 15:43:44.318533
3585	61	2026-01-06	2026-01-06 09:11:30.417542	2026-01-06 17:51:15.966027	present	2026-03-02 15:43:44.318533
3586	67	2026-01-06	2026-01-06 09:45:30.525204	2026-01-06 17:21:47.27382	present	2026-03-02 15:43:44.318533
3587	68	2026-01-06	2026-01-06 09:06:35.985386	2026-01-06 17:24:45.74976	present	2026-03-02 15:43:44.318533
3588	69	2026-01-06	2026-01-06 09:00:18.481243	2026-01-06 17:07:31.427894	present	2026-03-02 15:43:44.318533
3589	72	2026-01-06	2026-01-06 09:14:50.923785	2026-01-06 17:19:42.216163	present	2026-03-02 15:43:44.318533
3590	75	2026-01-06	2026-01-06 09:52:42.307528	2026-01-06 17:56:51.365771	present	2026-03-02 15:43:44.318533
3591	76	2026-01-06	2026-01-06 09:37:18.877991	2026-01-06 17:10:46.07043	present	2026-03-02 15:43:44.318533
3592	77	2026-01-06	2026-01-06 09:47:02.650171	2026-01-06 17:00:45.59437	present	2026-03-02 15:43:44.318533
3593	80	2026-01-06	2026-01-06 09:57:35.088737	2026-01-06 17:29:16.659553	present	2026-03-02 15:43:44.318533
3594	81	2026-01-06	2026-01-06 09:01:04.359302	2026-01-06 17:39:54.172259	present	2026-03-02 15:43:44.318533
3595	86	2026-01-06	2026-01-06 09:15:49.663481	2026-01-06 17:18:16.007842	present	2026-03-02 15:43:44.318533
3596	87	2026-01-06	2026-01-06 09:28:53.114234	2026-01-06 17:25:15.907561	present	2026-03-02 15:43:44.318533
3597	90	2026-01-06	2026-01-06 09:05:32.747022	2026-01-06 17:50:32.593176	present	2026-03-02 15:43:44.318533
3598	91	2026-01-06	2026-01-06 09:17:25.435249	2026-01-06 17:25:04.972956	present	2026-03-02 15:43:44.318533
3599	92	2026-01-06	2026-01-06 09:16:21.255697	2026-01-06 17:02:25.877114	present	2026-03-02 15:43:44.318533
3600	93	2026-01-06	2026-01-06 09:01:36.252877	2026-01-06 17:49:32.045006	present	2026-03-02 15:43:44.318533
3601	94	2026-01-06	2026-01-06 09:38:31.648909	2026-01-06 17:47:58.348361	present	2026-03-02 15:43:44.318533
3602	95	2026-01-06	2026-01-06 09:03:27.574798	2026-01-06 17:28:28.422769	present	2026-03-02 15:43:44.318533
3603	98	2026-01-06	2026-01-06 09:16:35.254253	2026-01-06 17:54:11.369639	present	2026-03-02 15:43:44.318533
3604	99	2026-01-06	2026-01-06 09:01:47.399264	2026-01-06 17:09:53.088593	present	2026-03-02 15:43:44.318533
3605	100	2026-01-06	2026-01-06 09:19:39.463684	2026-01-06 17:56:52.580916	present	2026-03-02 15:43:44.318533
3606	3	2026-01-07	2026-01-07 09:43:07.71109	2026-01-07 17:38:11.481616	present	2026-03-02 15:43:44.318533
3607	4	2026-01-07	2026-01-07 09:32:01.009411	2026-01-07 17:34:30.100098	present	2026-03-02 15:43:44.318533
3608	5	2026-01-07	2026-01-07 09:12:07.238474	2026-01-07 17:11:03.070408	present	2026-03-02 15:43:44.318533
3609	6	2026-01-07	2026-01-07 09:07:10.181173	2026-01-07 17:55:58.485479	present	2026-03-02 15:43:44.318533
3610	10	2026-01-07	2026-01-07 09:18:29.313682	2026-01-07 17:19:18.32222	present	2026-03-02 15:43:44.318533
3611	11	2026-01-07	2026-01-07 09:53:25.96782	2026-01-07 17:59:29.517614	present	2026-03-02 15:43:44.318533
3612	27	2026-01-07	2026-01-07 09:50:59.185167	2026-01-07 17:33:04.964395	present	2026-03-02 15:43:44.318533
3613	33	2026-01-07	2026-01-07 09:09:06.13115	2026-01-07 17:34:52.804211	present	2026-03-02 15:43:44.318533
3614	35	2026-01-07	2026-01-07 09:53:25.675449	2026-01-07 17:48:48.959218	present	2026-03-02 15:43:44.318533
3615	37	2026-01-07	2026-01-07 09:02:20.965595	2026-01-07 17:30:45.225897	present	2026-03-02 15:43:44.318533
3616	43	2026-01-07	2026-01-07 09:42:46.825496	2026-01-07 17:33:18.90882	present	2026-03-02 15:43:44.318533
3617	45	2026-01-07	2026-01-07 09:19:17.691718	2026-01-07 17:56:29.685655	present	2026-03-02 15:43:44.318533
3618	46	2026-01-07	2026-01-07 09:11:21.002105	2026-01-07 17:25:08.861625	present	2026-03-02 15:43:44.318533
3619	47	2026-01-07	2026-01-07 09:45:57.4091	2026-01-07 17:23:58.332306	present	2026-03-02 15:43:44.318533
3620	48	2026-01-07	2026-01-07 09:04:35.278747	2026-01-07 17:44:25.718724	present	2026-03-02 15:43:44.318533
3621	50	2026-01-07	2026-01-07 09:19:40.666636	2026-01-07 17:38:07.54656	present	2026-03-02 15:43:44.318533
3622	52	2026-01-07	2026-01-07 09:02:53.126325	2026-01-07 17:52:01.610942	present	2026-03-02 15:43:44.318533
3623	59	2026-01-07	2026-01-07 09:36:02.687371	2026-01-07 17:47:29.657995	present	2026-03-02 15:43:44.318533
3624	60	2026-01-07	2026-01-07 09:33:47.454164	2026-01-07 17:09:53.777268	present	2026-03-02 15:43:44.318533
3625	62	2026-01-07	2026-01-07 09:06:06.618414	2026-01-07 17:32:06.13036	present	2026-03-02 15:43:44.318533
3626	63	2026-01-07	2026-01-07 09:40:17.514966	2026-01-07 17:04:52.578853	present	2026-03-02 15:43:44.318533
3627	64	2026-01-07	2026-01-07 09:18:28.642072	2026-01-07 17:16:43.726068	present	2026-03-02 15:43:44.318533
3628	65	2026-01-07	2026-01-07 09:49:02.733977	2026-01-07 17:14:16.097135	present	2026-03-02 15:43:44.318533
3629	66	2026-01-07	2026-01-07 09:19:17.398494	2026-01-07 17:36:50.28789	present	2026-03-02 15:43:44.318533
3630	70	2026-01-07	2026-01-07 09:45:49.798755	2026-01-07 17:11:29.202731	present	2026-03-02 15:43:44.318533
3631	71	2026-01-07	2026-01-07 09:15:48.54531	2026-01-07 17:51:33.599176	present	2026-03-02 15:43:44.318533
3632	73	2026-01-07	2026-01-07 09:53:54.177908	2026-01-07 17:41:52.077504	present	2026-03-02 15:43:44.318533
3633	74	2026-01-07	2026-01-07 09:34:48.153926	2026-01-07 17:34:34.069554	present	2026-03-02 15:43:44.318533
3634	78	2026-01-07	2026-01-07 09:11:44.72874	2026-01-07 17:16:30.714946	present	2026-03-02 15:43:44.318533
3635	79	2026-01-07	2026-01-07 09:06:36.025415	2026-01-07 17:14:17.663967	present	2026-03-02 15:43:44.318533
3636	82	2026-01-07	2026-01-07 09:49:48.590061	2026-01-07 17:38:07.335264	present	2026-03-02 15:43:44.318533
3637	83	2026-01-07	2026-01-07 09:40:17.921434	2026-01-07 17:01:34.302871	present	2026-03-02 15:43:44.318533
3638	84	2026-01-07	2026-01-07 09:49:18.996608	2026-01-07 17:04:53.801958	present	2026-03-02 15:43:44.318533
3639	85	2026-01-07	2026-01-07 09:09:48.999537	2026-01-07 17:40:50.619211	present	2026-03-02 15:43:44.318533
3640	88	2026-01-07	2026-01-07 09:11:42.953117	2026-01-07 17:02:52.758267	present	2026-03-02 15:43:44.318533
3641	89	2026-01-07	2026-01-07 09:34:54.250988	2026-01-07 17:28:19.570314	present	2026-03-02 15:43:44.318533
3642	96	2026-01-07	2026-01-07 09:34:03.667699	2026-01-07 17:09:54.340778	present	2026-03-02 15:43:44.318533
3643	97	2026-01-07	2026-01-07 09:30:42.423386	2026-01-07 17:37:11.254335	present	2026-03-02 15:43:44.318533
3644	1	2026-01-07	2026-01-07 09:26:41.65216	2026-01-07 17:10:54.179631	present	2026-03-02 15:43:44.318533
3645	2	2026-01-07	2026-01-07 09:31:19.251414	2026-01-07 17:40:31.003745	present	2026-03-02 15:43:44.318533
3646	7	2026-01-07	2026-01-07 09:49:06.394691	2026-01-07 17:37:54.383638	present	2026-03-02 15:43:44.318533
3647	8	2026-01-07	2026-01-07 09:58:05.723727	2026-01-07 17:45:52.890188	present	2026-03-02 15:43:44.318533
3648	9	2026-01-07	2026-01-07 09:07:05.838776	2026-01-07 17:48:04.876583	present	2026-03-02 15:43:44.318533
3649	12	2026-01-07	2026-01-07 09:16:26.800937	2026-01-07 17:03:53.19115	present	2026-03-02 15:43:44.318533
3650	13	2026-01-07	2026-01-07 09:44:53.18963	2026-01-07 17:58:12.841674	present	2026-03-02 15:43:44.318533
3651	14	2026-01-07	2026-01-07 09:08:22.663717	2026-01-07 17:12:13.536967	present	2026-03-02 15:43:44.318533
3652	15	2026-01-07	2026-01-07 09:19:20.070654	2026-01-07 17:20:31.220288	present	2026-03-02 15:43:44.318533
3653	16	2026-01-07	2026-01-07 09:37:25.593566	2026-01-07 17:11:39.524961	present	2026-03-02 15:43:44.318533
3654	17	2026-01-07	2026-01-07 09:45:28.029351	2026-01-07 17:02:14.380274	present	2026-03-02 15:43:44.318533
3655	18	2026-01-07	2026-01-07 09:37:57.06248	2026-01-07 17:04:41.467243	present	2026-03-02 15:43:44.318533
3656	19	2026-01-07	2026-01-07 09:48:59.245022	2026-01-07 17:00:27.342857	present	2026-03-02 15:43:44.318533
3657	20	2026-01-07	2026-01-07 09:32:33.64704	2026-01-07 17:19:30.155303	present	2026-03-02 15:43:44.318533
3658	21	2026-01-07	2026-01-07 09:49:31.167489	2026-01-07 17:22:50.886585	present	2026-03-02 15:43:44.318533
3659	22	2026-01-07	2026-01-07 09:50:31.830761	2026-01-07 17:04:02.500417	present	2026-03-02 15:43:44.318533
3660	23	2026-01-07	2026-01-07 09:17:28.210268	2026-01-07 17:29:07.504187	present	2026-03-02 15:43:44.318533
3661	24	2026-01-07	2026-01-07 09:42:54.635738	2026-01-07 17:12:43.201611	present	2026-03-02 15:43:44.318533
3662	25	2026-01-07	2026-01-07 09:08:30.901168	2026-01-07 17:28:08.891166	present	2026-03-02 15:43:44.318533
3663	26	2026-01-07	2026-01-07 09:18:51.342577	2026-01-07 17:10:23.815507	present	2026-03-02 15:43:44.318533
3664	28	2026-01-07	2026-01-07 09:54:40.371777	2026-01-07 17:43:11.557167	present	2026-03-02 15:43:44.318533
3665	29	2026-01-07	2026-01-07 09:06:21.787836	2026-01-07 17:18:52.076665	present	2026-03-02 15:43:44.318533
3666	30	2026-01-07	2026-01-07 09:54:15.794341	2026-01-07 17:56:40.582926	present	2026-03-02 15:43:44.318533
3667	31	2026-01-07	2026-01-07 09:56:33.344277	2026-01-07 17:47:35.778446	present	2026-03-02 15:43:44.318533
3668	32	2026-01-07	2026-01-07 09:08:12.543629	2026-01-07 17:44:35.001259	present	2026-03-02 15:43:44.318533
3669	34	2026-01-07	2026-01-07 09:13:25.470868	2026-01-07 17:28:26.668661	present	2026-03-02 15:43:44.318533
3670	36	2026-01-07	2026-01-07 09:04:19.971026	2026-01-07 17:26:55.822852	present	2026-03-02 15:43:44.318533
3671	38	2026-01-07	2026-01-07 09:53:49.051832	2026-01-07 17:20:29.989756	present	2026-03-02 15:43:44.318533
3672	39	2026-01-07	2026-01-07 09:33:14.145158	2026-01-07 17:19:46.48218	present	2026-03-02 15:43:44.318533
3673	40	2026-01-07	2026-01-07 09:07:44.269501	2026-01-07 17:20:06.686334	present	2026-03-02 15:43:44.318533
3674	41	2026-01-07	2026-01-07 09:48:38.029372	2026-01-07 17:57:15.41437	present	2026-03-02 15:43:44.318533
3675	42	2026-01-07	2026-01-07 09:17:37.81639	2026-01-07 17:57:09.8327	present	2026-03-02 15:43:44.318533
3676	44	2026-01-07	2026-01-07 09:28:44.179006	2026-01-07 17:56:51.441767	present	2026-03-02 15:43:44.318533
3677	49	2026-01-07	2026-01-07 09:56:19.00752	2026-01-07 17:45:16.044988	present	2026-03-02 15:43:44.318533
3678	51	2026-01-07	2026-01-07 09:19:48.134642	2026-01-07 17:38:49.704978	present	2026-03-02 15:43:44.318533
3679	53	2026-01-07	2026-01-07 09:43:31.303221	2026-01-07 17:12:52.471517	present	2026-03-02 15:43:44.318533
3680	54	2026-01-07	2026-01-07 09:42:47.897845	2026-01-07 17:07:37.765444	present	2026-03-02 15:43:44.318533
3681	55	2026-01-07	2026-01-07 09:32:57.645649	2026-01-07 17:12:00.857592	present	2026-03-02 15:43:44.318533
3682	56	2026-01-07	2026-01-07 09:58:35.216526	2026-01-07 17:21:13.27995	present	2026-03-02 15:43:44.318533
3683	57	2026-01-07	2026-01-07 09:02:40.74518	2026-01-07 17:01:38.056038	present	2026-03-02 15:43:44.318533
3684	58	2026-01-07	2026-01-07 09:45:29.68508	2026-01-07 17:01:19.769318	present	2026-03-02 15:43:44.318533
3685	61	2026-01-07	2026-01-07 09:57:20.290109	2026-01-07 17:13:30.973402	present	2026-03-02 15:43:44.318533
3686	67	2026-01-07	2026-01-07 09:02:27.598404	2026-01-07 17:37:07.219059	present	2026-03-02 15:43:44.318533
3687	68	2026-01-07	2026-01-07 09:07:50.329278	2026-01-07 17:17:38.20595	present	2026-03-02 15:43:44.318533
3688	69	2026-01-07	2026-01-07 09:02:21.026337	2026-01-07 17:36:17.602257	present	2026-03-02 15:43:44.318533
3689	72	2026-01-07	2026-01-07 09:52:08.552719	2026-01-07 17:07:59.289007	present	2026-03-02 15:43:44.318533
3690	75	2026-01-07	2026-01-07 09:57:11.019952	2026-01-07 17:38:39.982532	present	2026-03-02 15:43:44.318533
3691	76	2026-01-07	2026-01-07 09:06:12.738778	2026-01-07 17:16:34.073288	present	2026-03-02 15:43:44.318533
3692	77	2026-01-07	2026-01-07 09:42:17.054204	2026-01-07 17:19:33.489946	present	2026-03-02 15:43:44.318533
3693	80	2026-01-07	2026-01-07 09:37:40.403603	2026-01-07 17:08:47.195543	present	2026-03-02 15:43:44.318533
3694	81	2026-01-07	2026-01-07 09:11:26.013586	2026-01-07 17:12:03.895261	present	2026-03-02 15:43:44.318533
3695	86	2026-01-07	2026-01-07 09:35:28.111287	2026-01-07 17:26:26.382382	present	2026-03-02 15:43:44.318533
3696	87	2026-01-07	2026-01-07 09:27:33.600977	2026-01-07 17:48:42.255141	present	2026-03-02 15:43:44.318533
3697	90	2026-01-07	2026-01-07 09:10:56.845206	2026-01-07 17:57:27.02679	present	2026-03-02 15:43:44.318533
3698	91	2026-01-07	2026-01-07 09:58:57.044233	2026-01-07 17:48:47.55953	present	2026-03-02 15:43:44.318533
3699	92	2026-01-07	2026-01-07 09:11:06.682463	2026-01-07 17:53:23.334021	present	2026-03-02 15:43:44.318533
3700	93	2026-01-07	2026-01-07 09:33:37.171131	2026-01-07 17:45:57.336269	present	2026-03-02 15:43:44.318533
3701	94	2026-01-07	2026-01-07 09:56:10.870301	2026-01-07 17:14:50.130599	present	2026-03-02 15:43:44.318533
3702	95	2026-01-07	2026-01-07 09:54:43.03603	2026-01-07 17:36:53.206907	present	2026-03-02 15:43:44.318533
3703	98	2026-01-07	2026-01-07 09:04:56.924842	2026-01-07 17:44:09.201257	present	2026-03-02 15:43:44.318533
3704	99	2026-01-07	2026-01-07 09:56:58.485818	2026-01-07 17:37:17.76003	present	2026-03-02 15:43:44.318533
3705	100	2026-01-07	2026-01-07 09:31:30.821386	2026-01-07 17:24:03.684886	present	2026-03-02 15:43:44.318533
3706	3	2026-01-08	2026-01-08 09:08:22.25023	2026-01-08 17:34:24.13488	present	2026-03-02 15:43:44.318533
3707	4	2026-01-08	2026-01-08 09:17:59.181053	2026-01-08 17:13:39.982376	present	2026-03-02 15:43:44.318533
3708	5	2026-01-08	2026-01-08 09:07:27.279951	2026-01-08 17:02:05.919629	present	2026-03-02 15:43:44.318533
3709	6	2026-01-08	2026-01-08 09:37:35.669251	2026-01-08 17:12:25.402492	present	2026-03-02 15:43:44.318533
3710	10	2026-01-08	2026-01-08 09:35:33.508081	2026-01-08 17:38:10.151848	present	2026-03-02 15:43:44.318533
3711	11	2026-01-08	2026-01-08 09:29:38.019924	2026-01-08 17:47:48.544045	present	2026-03-02 15:43:44.318533
3712	27	2026-01-08	2026-01-08 09:04:45.589725	2026-01-08 17:35:55.455601	present	2026-03-02 15:43:44.318533
3713	33	2026-01-08	2026-01-08 09:29:03.709285	2026-01-08 17:48:13.420061	present	2026-03-02 15:43:44.318533
3714	35	2026-01-08	2026-01-08 09:43:22.368319	2026-01-08 17:48:45.292761	present	2026-03-02 15:43:44.318533
3715	37	2026-01-08	2026-01-08 09:50:10.090547	2026-01-08 17:36:43.187404	present	2026-03-02 15:43:44.318533
3716	43	2026-01-08	2026-01-08 09:24:09.188367	2026-01-08 17:47:18.876243	present	2026-03-02 15:43:44.318533
3717	45	2026-01-08	2026-01-08 09:30:40.68039	2026-01-08 17:21:00.158149	present	2026-03-02 15:43:44.318533
3718	46	2026-01-08	2026-01-08 09:16:58.040788	2026-01-08 17:12:44.168163	present	2026-03-02 15:43:44.318533
3719	47	2026-01-08	2026-01-08 09:13:44.683301	2026-01-08 17:37:52.166289	present	2026-03-02 15:43:44.318533
3720	48	2026-01-08	2026-01-08 09:44:08.981231	2026-01-08 17:18:45.841361	present	2026-03-02 15:43:44.318533
3721	50	2026-01-08	2026-01-08 09:40:43.191559	2026-01-08 17:54:13.404639	present	2026-03-02 15:43:44.318533
3722	52	2026-01-08	2026-01-08 09:43:06.871179	2026-01-08 17:07:00.425436	present	2026-03-02 15:43:44.318533
3723	59	2026-01-08	2026-01-08 09:18:30.782004	2026-01-08 17:07:43.790445	present	2026-03-02 15:43:44.318533
3724	60	2026-01-08	2026-01-08 09:35:15.348559	2026-01-08 17:33:04.750053	present	2026-03-02 15:43:44.318533
3725	62	2026-01-08	2026-01-08 09:52:58.015216	2026-01-08 17:31:45.00021	present	2026-03-02 15:43:44.318533
3726	63	2026-01-08	2026-01-08 09:10:43.974571	2026-01-08 17:45:06.232909	present	2026-03-02 15:43:44.318533
3727	64	2026-01-08	2026-01-08 09:03:58.115986	2026-01-08 17:33:32.671919	present	2026-03-02 15:43:44.318533
3728	65	2026-01-08	2026-01-08 09:56:28.519561	2026-01-08 17:00:43.885287	present	2026-03-02 15:43:44.318533
3729	66	2026-01-08	2026-01-08 09:40:20.399191	2026-01-08 17:33:26.14886	present	2026-03-02 15:43:44.318533
3730	70	2026-01-08	2026-01-08 09:21:11.462067	2026-01-08 17:18:01.470256	present	2026-03-02 15:43:44.318533
3731	71	2026-01-08	2026-01-08 09:28:10.856175	2026-01-08 17:53:45.683339	present	2026-03-02 15:43:44.318533
3732	73	2026-01-08	2026-01-08 09:45:44.699119	2026-01-08 17:41:51.609425	present	2026-03-02 15:43:44.318533
3733	74	2026-01-08	2026-01-08 09:43:45.496361	2026-01-08 17:09:18.902494	present	2026-03-02 15:43:44.318533
3734	78	2026-01-08	2026-01-08 09:43:48.963471	2026-01-08 17:11:48.607381	present	2026-03-02 15:43:44.318533
3735	79	2026-01-08	2026-01-08 09:15:43.783615	2026-01-08 17:47:15.152076	present	2026-03-02 15:43:44.318533
3736	82	2026-01-08	2026-01-08 09:08:36.192492	2026-01-08 17:30:35.495317	present	2026-03-02 15:43:44.318533
3737	83	2026-01-08	2026-01-08 09:23:56.358457	2026-01-08 17:32:33.765419	present	2026-03-02 15:43:44.318533
3738	84	2026-01-08	2026-01-08 09:12:46.993193	2026-01-08 17:52:45.174716	present	2026-03-02 15:43:44.318533
3739	85	2026-01-08	2026-01-08 09:08:47.922052	2026-01-08 17:44:10.334688	present	2026-03-02 15:43:44.318533
3740	88	2026-01-08	2026-01-08 09:34:34.6092	2026-01-08 17:39:59.40296	present	2026-03-02 15:43:44.318533
3741	89	2026-01-08	2026-01-08 09:38:47.257563	2026-01-08 17:21:03.129684	present	2026-03-02 15:43:44.318533
3742	96	2026-01-08	2026-01-08 09:48:15.480947	2026-01-08 17:37:19.457544	present	2026-03-02 15:43:44.318533
3743	97	2026-01-08	2026-01-08 09:57:26.709745	2026-01-08 17:37:34.455461	present	2026-03-02 15:43:44.318533
3744	1	2026-01-08	2026-01-08 09:26:56.220646	2026-01-08 17:16:56.68834	present	2026-03-02 15:43:44.318533
3745	2	2026-01-08	2026-01-08 09:26:52.240683	2026-01-08 17:33:37.969348	present	2026-03-02 15:43:44.318533
3746	7	2026-01-08	2026-01-08 09:43:32.331849	2026-01-08 17:04:39.535868	present	2026-03-02 15:43:44.318533
3747	8	2026-01-08	2026-01-08 09:46:17.324757	2026-01-08 17:10:32.123789	present	2026-03-02 15:43:44.318533
3748	9	2026-01-08	2026-01-08 09:40:26.995784	2026-01-08 17:58:44.420687	present	2026-03-02 15:43:44.318533
3749	12	2026-01-08	2026-01-08 09:39:17.399636	2026-01-08 17:39:23.728412	present	2026-03-02 15:43:44.318533
3750	13	2026-01-08	2026-01-08 09:32:40.123973	2026-01-08 17:10:40.433595	present	2026-03-02 15:43:44.318533
3751	14	2026-01-08	2026-01-08 09:46:21.381523	2026-01-08 17:27:50.645156	present	2026-03-02 15:43:44.318533
3752	15	2026-01-08	2026-01-08 09:53:10.030992	2026-01-08 17:11:54.434701	present	2026-03-02 15:43:44.318533
3753	16	2026-01-08	2026-01-08 09:39:12.155787	2026-01-08 17:21:29.914322	present	2026-03-02 15:43:44.318533
3754	17	2026-01-08	2026-01-08 09:37:40.801132	2026-01-08 17:12:15.123945	present	2026-03-02 15:43:44.318533
3755	18	2026-01-08	2026-01-08 09:48:08.569588	2026-01-08 17:27:04.039038	present	2026-03-02 15:43:44.318533
3756	19	2026-01-08	2026-01-08 09:56:53.610761	2026-01-08 17:56:27.598705	present	2026-03-02 15:43:44.318533
3757	20	2026-01-08	2026-01-08 09:12:54.218649	2026-01-08 17:00:43.080186	present	2026-03-02 15:43:44.318533
3758	21	2026-01-08	2026-01-08 09:44:00.641255	2026-01-08 17:08:30.740835	present	2026-03-02 15:43:44.318533
3759	22	2026-01-08	2026-01-08 09:51:46.976397	2026-01-08 17:42:57.56049	present	2026-03-02 15:43:44.318533
3760	23	2026-01-08	2026-01-08 09:07:37.743995	2026-01-08 17:27:25.530232	present	2026-03-02 15:43:44.318533
3761	24	2026-01-08	2026-01-08 09:07:26.119407	2026-01-08 17:32:53.344712	present	2026-03-02 15:43:44.318533
3762	25	2026-01-08	2026-01-08 09:04:10.93684	2026-01-08 17:08:18.749565	present	2026-03-02 15:43:44.318533
3763	26	2026-01-08	2026-01-08 09:13:27.249985	2026-01-08 17:29:14.45791	present	2026-03-02 15:43:44.318533
3764	28	2026-01-08	2026-01-08 09:11:24.795141	2026-01-08 17:56:24.388279	present	2026-03-02 15:43:44.318533
3765	29	2026-01-08	2026-01-08 09:29:23.644576	2026-01-08 17:37:35.253996	present	2026-03-02 15:43:44.318533
3766	30	2026-01-08	2026-01-08 09:25:42.236692	2026-01-08 17:51:52.040138	present	2026-03-02 15:43:44.318533
3767	31	2026-01-08	2026-01-08 09:09:08.243325	2026-01-08 17:21:59.309985	present	2026-03-02 15:43:44.318533
3768	32	2026-01-08	2026-01-08 09:22:05.355915	2026-01-08 17:57:05.914498	present	2026-03-02 15:43:44.318533
3769	34	2026-01-08	2026-01-08 09:32:04.610994	2026-01-08 17:50:27.911686	present	2026-03-02 15:43:44.318533
3770	36	2026-01-08	2026-01-08 09:07:19.76442	2026-01-08 17:47:47.810604	present	2026-03-02 15:43:44.318533
3771	38	2026-01-08	2026-01-08 09:56:24.388947	2026-01-08 17:44:24.409506	present	2026-03-02 15:43:44.318533
3772	39	2026-01-08	2026-01-08 09:30:36.459528	2026-01-08 17:55:05.002916	present	2026-03-02 15:43:44.318533
3773	40	2026-01-08	2026-01-08 09:58:22.869855	2026-01-08 17:51:45.35132	present	2026-03-02 15:43:44.318533
3774	41	2026-01-08	2026-01-08 09:47:15.473997	2026-01-08 17:06:39.786059	present	2026-03-02 15:43:44.318533
3775	42	2026-01-08	2026-01-08 09:13:34.831216	2026-01-08 17:21:51.995086	present	2026-03-02 15:43:44.318533
3776	44	2026-01-08	2026-01-08 09:14:37.83291	2026-01-08 17:51:56.947425	present	2026-03-02 15:43:44.318533
3777	49	2026-01-08	2026-01-08 09:16:31.995533	2026-01-08 17:06:40.758307	present	2026-03-02 15:43:44.318533
3778	51	2026-01-08	2026-01-08 09:44:00.485333	2026-01-08 17:57:41.617783	present	2026-03-02 15:43:44.318533
3779	53	2026-01-08	2026-01-08 09:54:27.85056	2026-01-08 17:20:28.880627	present	2026-03-02 15:43:44.318533
3780	54	2026-01-08	2026-01-08 09:19:47.512393	2026-01-08 17:38:52.070501	present	2026-03-02 15:43:44.318533
3781	55	2026-01-08	2026-01-08 09:54:58.635745	2026-01-08 17:08:23.972826	present	2026-03-02 15:43:44.318533
3782	56	2026-01-08	2026-01-08 09:01:00.335067	2026-01-08 17:09:26.119641	present	2026-03-02 15:43:44.318533
3783	57	2026-01-08	2026-01-08 09:51:02.511519	2026-01-08 17:22:18.38959	present	2026-03-02 15:43:44.318533
3784	58	2026-01-08	2026-01-08 09:16:31.57436	2026-01-08 17:56:13.761793	present	2026-03-02 15:43:44.318533
3785	61	2026-01-08	2026-01-08 09:07:46.874578	2026-01-08 17:52:39.373546	present	2026-03-02 15:43:44.318533
3786	67	2026-01-08	2026-01-08 09:25:58.438877	2026-01-08 17:27:47.388703	present	2026-03-02 15:43:44.318533
3787	68	2026-01-08	2026-01-08 09:11:26.798349	2026-01-08 17:56:40.523724	present	2026-03-02 15:43:44.318533
3788	69	2026-01-08	2026-01-08 09:55:48.166911	2026-01-08 17:28:49.578156	present	2026-03-02 15:43:44.318533
3789	72	2026-01-08	2026-01-08 09:10:06.601457	2026-01-08 17:03:12.856759	present	2026-03-02 15:43:44.318533
3790	75	2026-01-08	2026-01-08 09:12:22.492002	2026-01-08 17:05:01.51872	present	2026-03-02 15:43:44.318533
3791	76	2026-01-08	2026-01-08 09:13:32.497143	2026-01-08 17:27:45.326657	present	2026-03-02 15:43:44.318533
3792	77	2026-01-08	2026-01-08 09:53:14.586437	2026-01-08 17:12:11.807533	present	2026-03-02 15:43:44.318533
3793	80	2026-01-08	2026-01-08 09:38:37.752802	2026-01-08 17:36:16.371558	present	2026-03-02 15:43:44.318533
3794	81	2026-01-08	2026-01-08 09:29:06.23619	2026-01-08 17:54:05.274362	present	2026-03-02 15:43:44.318533
3795	86	2026-01-08	2026-01-08 09:42:46.501343	2026-01-08 17:11:52.931503	present	2026-03-02 15:43:44.318533
3796	87	2026-01-08	2026-01-08 09:35:08.940001	2026-01-08 17:33:19.832226	present	2026-03-02 15:43:44.318533
3797	90	2026-01-08	2026-01-08 09:09:17.994522	2026-01-08 17:58:37.859008	present	2026-03-02 15:43:44.318533
3798	91	2026-01-08	2026-01-08 09:55:05.491827	2026-01-08 17:21:39.463727	present	2026-03-02 15:43:44.318533
3799	92	2026-01-08	2026-01-08 09:32:45.1851	2026-01-08 17:42:09.699539	present	2026-03-02 15:43:44.318533
3800	93	2026-01-08	2026-01-08 09:34:18.605671	2026-01-08 17:18:28.214252	present	2026-03-02 15:43:44.318533
3801	94	2026-01-08	2026-01-08 09:41:16.510083	2026-01-08 17:03:05.79254	present	2026-03-02 15:43:44.318533
3802	95	2026-01-08	2026-01-08 09:43:21.330512	2026-01-08 17:47:22.870682	present	2026-03-02 15:43:44.318533
3803	98	2026-01-08	2026-01-08 09:15:41.827379	2026-01-08 17:39:10.685619	present	2026-03-02 15:43:44.318533
3804	99	2026-01-08	2026-01-08 09:17:12.604683	2026-01-08 17:12:57.20146	present	2026-03-02 15:43:44.318533
3805	100	2026-01-08	2026-01-08 09:07:53.397155	2026-01-08 17:13:59.623508	present	2026-03-02 15:43:44.318533
3806	3	2026-01-09	2026-01-09 09:35:08.386971	2026-01-09 17:13:06.954173	present	2026-03-02 15:43:44.318533
3807	4	2026-01-09	2026-01-09 09:43:25.482702	2026-01-09 17:15:00.137888	present	2026-03-02 15:43:44.318533
3808	5	2026-01-09	2026-01-09 09:20:02.322539	2026-01-09 17:29:41.810582	present	2026-03-02 15:43:44.318533
3809	6	2026-01-09	2026-01-09 09:25:26.416824	2026-01-09 17:00:24.671636	present	2026-03-02 15:43:44.318533
3810	10	2026-01-09	2026-01-09 09:00:06.581034	2026-01-09 17:19:32.476704	present	2026-03-02 15:43:44.318533
3811	11	2026-01-09	2026-01-09 09:34:37.756295	2026-01-09 17:32:18.101776	present	2026-03-02 15:43:44.318533
3812	27	2026-01-09	2026-01-09 09:36:32.980514	2026-01-09 17:04:44.777746	present	2026-03-02 15:43:44.318533
3813	33	2026-01-09	2026-01-09 09:04:32.244274	2026-01-09 17:44:25.679016	present	2026-03-02 15:43:44.318533
3814	35	2026-01-09	2026-01-09 09:44:49.022445	2026-01-09 17:30:42.865204	present	2026-03-02 15:43:44.318533
3815	37	2026-01-09	2026-01-09 09:41:17.960968	2026-01-09 17:31:50.040699	present	2026-03-02 15:43:44.318533
3816	43	2026-01-09	2026-01-09 09:10:58.157447	2026-01-09 17:32:11.652041	present	2026-03-02 15:43:44.318533
3817	45	2026-01-09	2026-01-09 09:20:27.507504	2026-01-09 17:02:23.006816	present	2026-03-02 15:43:44.318533
3818	46	2026-01-09	2026-01-09 09:02:53.626541	2026-01-09 17:46:25.301715	present	2026-03-02 15:43:44.318533
3819	47	2026-01-09	2026-01-09 09:11:11.051224	2026-01-09 17:48:16.055399	present	2026-03-02 15:43:44.318533
3820	48	2026-01-09	2026-01-09 09:03:13.840654	2026-01-09 17:28:47.725828	present	2026-03-02 15:43:44.318533
3821	50	2026-01-09	2026-01-09 09:17:43.25346	2026-01-09 17:06:06.887232	present	2026-03-02 15:43:44.318533
3822	52	2026-01-09	2026-01-09 09:43:59.409665	2026-01-09 17:56:33.313213	present	2026-03-02 15:43:44.318533
3823	59	2026-01-09	2026-01-09 09:25:27.669759	2026-01-09 17:04:11.734488	present	2026-03-02 15:43:44.318533
3824	60	2026-01-09	2026-01-09 09:04:58.537136	2026-01-09 17:52:06.524984	present	2026-03-02 15:43:44.318533
3825	62	2026-01-09	2026-01-09 09:03:54.179033	2026-01-09 17:35:13.008148	present	2026-03-02 15:43:44.318533
3826	63	2026-01-09	2026-01-09 09:20:19.099118	2026-01-09 17:27:59.283053	present	2026-03-02 15:43:44.318533
3827	64	2026-01-09	2026-01-09 09:26:51.894311	2026-01-09 17:09:39.016857	present	2026-03-02 15:43:44.318533
3828	65	2026-01-09	2026-01-09 09:28:21.15722	2026-01-09 17:34:07.703119	present	2026-03-02 15:43:44.318533
3829	66	2026-01-09	2026-01-09 09:38:13.604376	2026-01-09 17:56:43.638183	present	2026-03-02 15:43:44.318533
3830	70	2026-01-09	2026-01-09 09:46:37.112988	2026-01-09 17:21:58.525023	present	2026-03-02 15:43:44.318533
3831	71	2026-01-09	2026-01-09 09:42:54.483631	2026-01-09 17:36:12.981397	present	2026-03-02 15:43:44.318533
3832	73	2026-01-09	2026-01-09 09:00:47.01522	2026-01-09 17:03:47.063893	present	2026-03-02 15:43:44.318533
3833	74	2026-01-09	2026-01-09 09:21:36.214062	2026-01-09 17:59:44.814309	present	2026-03-02 15:43:44.318533
3834	78	2026-01-09	2026-01-09 09:20:25.456281	2026-01-09 17:25:28.555325	present	2026-03-02 15:43:44.318533
3835	79	2026-01-09	2026-01-09 09:13:16.226058	2026-01-09 17:43:23.279686	present	2026-03-02 15:43:44.318533
3836	82	2026-01-09	2026-01-09 09:32:01.611549	2026-01-09 17:18:37.232969	present	2026-03-02 15:43:44.318533
3837	83	2026-01-09	2026-01-09 09:11:35.665098	2026-01-09 17:34:24.717447	present	2026-03-02 15:43:44.318533
3838	84	2026-01-09	2026-01-09 09:38:26.298584	2026-01-09 17:47:10.891152	present	2026-03-02 15:43:44.318533
3839	85	2026-01-09	2026-01-09 09:53:17.471194	2026-01-09 17:10:45.304381	present	2026-03-02 15:43:44.318533
3840	88	2026-01-09	2026-01-09 09:22:22.64922	2026-01-09 17:58:16.07604	present	2026-03-02 15:43:44.318533
3841	89	2026-01-09	2026-01-09 09:31:23.489682	2026-01-09 17:42:29.627303	present	2026-03-02 15:43:44.318533
3842	96	2026-01-09	2026-01-09 09:49:46.536039	2026-01-09 17:43:00.856956	present	2026-03-02 15:43:44.318533
3843	97	2026-01-09	2026-01-09 09:17:26.112868	2026-01-09 17:58:12.658731	present	2026-03-02 15:43:44.318533
3844	1	2026-01-09	2026-01-09 09:51:22.953818	2026-01-09 17:33:20.267572	present	2026-03-02 15:43:44.318533
3845	2	2026-01-09	2026-01-09 09:35:16.160055	2026-01-09 17:32:50.331681	present	2026-03-02 15:43:44.318533
3846	7	2026-01-09	2026-01-09 09:00:25.222671	2026-01-09 17:01:30.255263	present	2026-03-02 15:43:44.318533
3847	8	2026-01-09	2026-01-09 09:47:39.294182	2026-01-09 17:03:48.665719	present	2026-03-02 15:43:44.318533
3848	9	2026-01-09	2026-01-09 09:28:04.443372	2026-01-09 17:46:00.10729	present	2026-03-02 15:43:44.318533
3849	12	2026-01-09	2026-01-09 09:26:48.326055	2026-01-09 17:05:51.772902	present	2026-03-02 15:43:44.318533
3850	13	2026-01-09	2026-01-09 09:23:11.005467	2026-01-09 17:15:41.434055	present	2026-03-02 15:43:44.318533
3851	14	2026-01-09	2026-01-09 09:48:52.327392	2026-01-09 17:48:12.613684	present	2026-03-02 15:43:44.318533
3852	15	2026-01-09	2026-01-09 09:10:48.536032	2026-01-09 17:02:10.770147	present	2026-03-02 15:43:44.318533
3853	16	2026-01-09	2026-01-09 09:18:31.300602	2026-01-09 17:07:10.060993	present	2026-03-02 15:43:44.318533
3854	17	2026-01-09	2026-01-09 09:25:18.349729	2026-01-09 17:56:21.297158	present	2026-03-02 15:43:44.318533
3855	18	2026-01-09	2026-01-09 09:23:53.702096	2026-01-09 17:09:49.264254	present	2026-03-02 15:43:44.318533
3856	19	2026-01-09	2026-01-09 09:38:11.534523	2026-01-09 17:00:09.391798	present	2026-03-02 15:43:44.318533
3857	20	2026-01-09	2026-01-09 09:07:06.315905	2026-01-09 17:24:21.594431	present	2026-03-02 15:43:44.318533
3858	21	2026-01-09	2026-01-09 09:46:49.863479	2026-01-09 17:20:38.015738	present	2026-03-02 15:43:44.318533
3859	22	2026-01-09	2026-01-09 09:27:59.16136	2026-01-09 17:39:06.047016	present	2026-03-02 15:43:44.318533
3860	23	2026-01-09	2026-01-09 09:47:50.13019	2026-01-09 17:07:03.657557	present	2026-03-02 15:43:44.318533
3861	24	2026-01-09	2026-01-09 09:37:26.24133	2026-01-09 17:13:24.622742	present	2026-03-02 15:43:44.318533
3862	25	2026-01-09	2026-01-09 09:15:58.637113	2026-01-09 17:27:10.565039	present	2026-03-02 15:43:44.318533
3863	26	2026-01-09	2026-01-09 09:54:21.703838	2026-01-09 17:21:26.890397	present	2026-03-02 15:43:44.318533
3864	28	2026-01-09	2026-01-09 09:16:59.038156	2026-01-09 17:31:46.739439	present	2026-03-02 15:43:44.318533
3865	29	2026-01-09	2026-01-09 09:11:27.085338	2026-01-09 17:26:51.772427	present	2026-03-02 15:43:44.318533
3866	30	2026-01-09	2026-01-09 09:50:13.238547	2026-01-09 17:47:09.744479	present	2026-03-02 15:43:44.318533
3867	31	2026-01-09	2026-01-09 09:49:27.373205	2026-01-09 17:34:14.087768	present	2026-03-02 15:43:44.318533
3868	32	2026-01-09	2026-01-09 09:45:46.403696	2026-01-09 17:12:33.388454	present	2026-03-02 15:43:44.318533
3869	34	2026-01-09	2026-01-09 09:48:18.290847	2026-01-09 17:25:12.000373	present	2026-03-02 15:43:44.318533
3870	36	2026-01-09	2026-01-09 09:18:35.292837	2026-01-09 17:37:55.608527	present	2026-03-02 15:43:44.318533
3871	38	2026-01-09	2026-01-09 09:21:55.126311	2026-01-09 17:24:45.150066	present	2026-03-02 15:43:44.318533
3872	39	2026-01-09	2026-01-09 09:59:42.775379	2026-01-09 17:25:31.080176	present	2026-03-02 15:43:44.318533
3873	40	2026-01-09	2026-01-09 09:55:29.830986	2026-01-09 17:54:04.678976	present	2026-03-02 15:43:44.318533
3874	41	2026-01-09	2026-01-09 09:37:27.838431	2026-01-09 17:38:46.947416	present	2026-03-02 15:43:44.318533
3875	42	2026-01-09	2026-01-09 09:22:01.521984	2026-01-09 17:54:13.669174	present	2026-03-02 15:43:44.318533
3876	44	2026-01-09	2026-01-09 09:35:48.626108	2026-01-09 17:34:17.228329	present	2026-03-02 15:43:44.318533
3877	49	2026-01-09	2026-01-09 09:29:44.624729	2026-01-09 17:10:43.224962	present	2026-03-02 15:43:44.318533
3878	51	2026-01-09	2026-01-09 09:38:22.111423	2026-01-09 17:27:50.74653	present	2026-03-02 15:43:44.318533
3879	53	2026-01-09	2026-01-09 09:33:20.79935	2026-01-09 17:29:36.692596	present	2026-03-02 15:43:44.318533
3880	54	2026-01-09	2026-01-09 09:02:33.451672	2026-01-09 17:18:01.075021	present	2026-03-02 15:43:44.318533
3881	55	2026-01-09	2026-01-09 09:05:41.851621	2026-01-09 17:34:14.174586	present	2026-03-02 15:43:44.318533
3882	56	2026-01-09	2026-01-09 09:03:21.736855	2026-01-09 17:14:05.746278	present	2026-03-02 15:43:44.318533
3883	57	2026-01-09	2026-01-09 09:04:06.252121	2026-01-09 17:39:40.737927	present	2026-03-02 15:43:44.318533
3884	58	2026-01-09	2026-01-09 09:05:59.273974	2026-01-09 17:56:12.919501	present	2026-03-02 15:43:44.318533
3885	61	2026-01-09	2026-01-09 09:17:55.423495	2026-01-09 17:09:39.624592	present	2026-03-02 15:43:44.318533
3886	67	2026-01-09	2026-01-09 09:02:08.827837	2026-01-09 17:55:29.851156	present	2026-03-02 15:43:44.318533
3887	68	2026-01-09	2026-01-09 09:29:14.895663	2026-01-09 17:29:18.718573	present	2026-03-02 15:43:44.318533
3888	69	2026-01-09	2026-01-09 09:07:21.910797	2026-01-09 17:48:22.047182	present	2026-03-02 15:43:44.318533
3889	72	2026-01-09	2026-01-09 09:59:03.274643	2026-01-09 17:15:16.177619	present	2026-03-02 15:43:44.318533
3890	75	2026-01-09	2026-01-09 09:28:44.304008	2026-01-09 17:15:06.376085	present	2026-03-02 15:43:44.318533
3891	76	2026-01-09	2026-01-09 09:54:50.207335	2026-01-09 17:19:24.415749	present	2026-03-02 15:43:44.318533
3892	77	2026-01-09	2026-01-09 09:08:24.023925	2026-01-09 17:34:46.416734	present	2026-03-02 15:43:44.318533
3893	80	2026-01-09	2026-01-09 09:33:58.083931	2026-01-09 17:22:25.030255	present	2026-03-02 15:43:44.318533
3894	81	2026-01-09	2026-01-09 09:23:48.620106	2026-01-09 17:16:46.703993	present	2026-03-02 15:43:44.318533
3895	86	2026-01-09	2026-01-09 09:59:50.374924	2026-01-09 17:02:21.531211	present	2026-03-02 15:43:44.318533
3896	87	2026-01-09	2026-01-09 09:55:55.195116	2026-01-09 17:35:04.328484	present	2026-03-02 15:43:44.318533
3897	90	2026-01-09	2026-01-09 09:56:47.552168	2026-01-09 17:37:28.660136	present	2026-03-02 15:43:44.318533
3898	91	2026-01-09	2026-01-09 09:03:21.050809	2026-01-09 17:03:46.177106	present	2026-03-02 15:43:44.318533
3899	92	2026-01-09	2026-01-09 09:00:18.955148	2026-01-09 17:56:43.433484	present	2026-03-02 15:43:44.318533
3900	93	2026-01-09	2026-01-09 09:21:03.611198	2026-01-09 17:20:53.422903	present	2026-03-02 15:43:44.318533
3901	94	2026-01-09	2026-01-09 09:41:47.677832	2026-01-09 17:02:02.975297	present	2026-03-02 15:43:44.318533
3902	95	2026-01-09	2026-01-09 09:13:39.164953	2026-01-09 17:08:24.727951	present	2026-03-02 15:43:44.318533
3903	98	2026-01-09	2026-01-09 09:37:10.113158	2026-01-09 17:32:42.535644	present	2026-03-02 15:43:44.318533
3904	99	2026-01-09	2026-01-09 09:27:17.874399	2026-01-09 17:05:22.180476	present	2026-03-02 15:43:44.318533
3905	100	2026-01-09	2026-01-09 09:35:24.738444	2026-01-09 17:33:49.247659	present	2026-03-02 15:43:44.318533
3906	3	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3907	4	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3908	5	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3909	6	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3910	10	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3911	11	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3912	27	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3913	33	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3914	35	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3915	37	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3916	43	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3917	45	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3918	46	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3919	47	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3920	48	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3921	50	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3922	52	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3923	59	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3924	60	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3925	62	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3926	63	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3927	64	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3928	65	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3929	66	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3930	70	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3931	71	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3932	73	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3933	74	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3934	78	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3935	79	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3936	82	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3937	83	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3938	84	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3939	85	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3940	88	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3941	89	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3942	96	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3943	97	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3944	1	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3945	2	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3946	7	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3947	8	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3948	9	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3949	12	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3950	13	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3951	14	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3952	15	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3953	16	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3954	17	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3955	18	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3956	19	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3957	20	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3958	21	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3959	22	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3960	23	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3961	24	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3962	25	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3963	26	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3964	28	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3965	29	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3966	30	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3967	31	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3968	32	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3969	34	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3970	36	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3971	38	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3972	39	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3973	40	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3974	41	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3975	42	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3976	44	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3977	49	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3978	51	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3979	53	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3980	54	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3981	55	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3982	56	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3983	57	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3984	58	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3985	61	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3986	67	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3987	68	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3988	69	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3989	72	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3990	75	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3991	76	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3992	77	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3993	80	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3994	81	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3995	86	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3996	87	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3997	90	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3998	91	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
3999	92	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4000	93	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4001	94	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4002	95	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4003	98	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4004	99	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4005	100	2026-01-10	\N	\N	absent	2026-03-02 15:43:44.318533
4006	3	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4007	4	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4008	5	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4009	6	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4010	10	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4011	11	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4012	27	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4013	33	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4014	35	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4015	37	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4016	43	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4017	45	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4018	46	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4019	47	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4020	48	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4021	50	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4022	52	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4023	59	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4024	60	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4025	62	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4026	63	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4027	64	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4028	65	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4029	66	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4030	70	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4031	71	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4032	73	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4033	74	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4034	78	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4035	79	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4036	82	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4037	83	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4038	84	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4039	85	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4040	88	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4041	89	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4042	96	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4043	97	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4044	1	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4045	2	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4046	7	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4047	8	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4048	9	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4049	12	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4050	13	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4051	14	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4052	15	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4053	16	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4054	17	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4055	18	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4056	19	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4057	20	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4058	21	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4059	22	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4060	23	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4061	24	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4062	25	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4063	26	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4064	28	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4065	29	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4066	30	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4067	31	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4068	32	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4069	34	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4070	36	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4071	38	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4072	39	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4073	40	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4074	41	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4075	42	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4076	44	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4077	49	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4078	51	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4079	53	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4080	54	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4081	55	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4082	56	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4083	57	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4084	58	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4085	61	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4086	67	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4087	68	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4088	69	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4089	72	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4090	75	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4091	76	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4092	77	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4093	80	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4094	81	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4095	86	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4096	87	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4097	90	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4098	91	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4099	92	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4100	93	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4101	94	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4102	95	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4103	98	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4104	99	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4105	100	2026-01-11	\N	\N	absent	2026-03-02 15:43:44.318533
4106	3	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4107	4	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4108	5	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4109	6	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4110	10	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4111	11	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4112	27	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4113	33	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4114	35	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4115	37	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4116	43	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4117	45	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4118	46	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4119	47	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4120	48	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4121	50	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4122	52	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4123	59	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4124	60	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4125	62	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4126	63	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4127	64	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4128	65	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4129	66	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4130	70	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4131	71	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4132	73	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4133	74	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4134	78	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4135	79	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4136	82	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4137	83	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4138	84	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4139	85	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4140	88	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4141	89	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4142	96	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4143	97	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4144	1	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4145	2	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4146	7	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4147	8	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4148	9	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4149	12	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4150	13	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4151	14	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4152	15	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4153	16	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4154	17	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4155	18	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4156	19	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4157	20	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4158	21	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4159	22	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4160	23	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4161	24	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4162	25	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4163	26	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4164	28	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4165	29	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4166	30	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4167	31	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4168	32	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4169	34	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4170	36	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4171	38	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4172	39	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4173	40	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4174	41	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4175	42	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4176	44	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4177	49	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4178	51	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4179	53	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4180	54	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4181	55	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4182	56	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4183	57	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4184	58	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4185	61	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4186	67	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4187	68	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4188	69	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4189	72	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4190	75	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4191	76	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4192	77	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4193	80	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4194	81	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4195	86	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4196	87	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4197	90	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4198	91	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4199	92	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4200	93	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4201	94	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4202	95	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4203	98	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4204	99	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4205	100	2026-01-12	\N	\N	absent	2026-03-02 15:43:44.318533
4206	3	2026-01-13	2026-01-13 09:52:58.8829	2026-01-13 17:39:25.451769	present	2026-03-02 15:43:44.318533
4207	4	2026-01-13	2026-01-13 09:50:24.18572	2026-01-13 17:10:23.054496	present	2026-03-02 15:43:44.318533
4208	5	2026-01-13	2026-01-13 09:08:40.524034	2026-01-13 17:00:43.774069	present	2026-03-02 15:43:44.318533
4209	6	2026-01-13	2026-01-13 09:54:56.793392	2026-01-13 17:48:25.240579	present	2026-03-02 15:43:44.318533
4210	10	2026-01-13	2026-01-13 09:20:31.184589	2026-01-13 17:21:23.849407	present	2026-03-02 15:43:44.318533
4211	11	2026-01-13	2026-01-13 09:05:07.725479	2026-01-13 17:24:22.906824	present	2026-03-02 15:43:44.318533
4212	27	2026-01-13	2026-01-13 09:57:14.731663	2026-01-13 17:40:09.151121	present	2026-03-02 15:43:44.318533
4213	33	2026-01-13	2026-01-13 09:29:27.599701	2026-01-13 17:58:13.521515	present	2026-03-02 15:43:44.318533
4214	35	2026-01-13	2026-01-13 09:29:32.494083	2026-01-13 17:35:18.026941	present	2026-03-02 15:43:44.318533
4215	37	2026-01-13	2026-01-13 09:11:26.843028	2026-01-13 17:31:30.895204	present	2026-03-02 15:43:44.318533
4216	43	2026-01-13	2026-01-13 09:07:35.822376	2026-01-13 17:06:01.597594	present	2026-03-02 15:43:44.318533
4217	45	2026-01-13	2026-01-13 09:11:14.128269	2026-01-13 17:14:04.14173	present	2026-03-02 15:43:44.318533
4218	46	2026-01-13	2026-01-13 09:36:48.981786	2026-01-13 17:03:23.343287	present	2026-03-02 15:43:44.318533
4219	47	2026-01-13	2026-01-13 09:43:52.109664	2026-01-13 17:23:09.77926	present	2026-03-02 15:43:44.318533
4220	48	2026-01-13	2026-01-13 09:33:14.536563	2026-01-13 17:04:50.372224	present	2026-03-02 15:43:44.318533
4221	50	2026-01-13	2026-01-13 09:38:50.310113	2026-01-13 17:26:51.315328	present	2026-03-02 15:43:44.318533
4222	52	2026-01-13	2026-01-13 09:59:44.433997	2026-01-13 17:57:40.095537	present	2026-03-02 15:43:44.318533
4223	59	2026-01-13	2026-01-13 09:35:50.279892	2026-01-13 17:05:12.822571	present	2026-03-02 15:43:44.318533
4224	60	2026-01-13	2026-01-13 09:20:43.282362	2026-01-13 17:36:30.46679	present	2026-03-02 15:43:44.318533
4225	62	2026-01-13	2026-01-13 09:19:58.572819	2026-01-13 17:18:45.271487	present	2026-03-02 15:43:44.318533
4226	63	2026-01-13	2026-01-13 09:58:15.214927	2026-01-13 17:17:01.03726	present	2026-03-02 15:43:44.318533
4227	64	2026-01-13	2026-01-13 09:11:01.170979	2026-01-13 17:34:16.536985	present	2026-03-02 15:43:44.318533
4228	65	2026-01-13	2026-01-13 09:40:33.39031	2026-01-13 17:17:09.602034	present	2026-03-02 15:43:44.318533
4229	66	2026-01-13	2026-01-13 09:32:34.490847	2026-01-13 17:41:12.050244	present	2026-03-02 15:43:44.318533
4230	70	2026-01-13	2026-01-13 09:47:33.311077	2026-01-13 17:50:56.272839	present	2026-03-02 15:43:44.318533
4231	71	2026-01-13	2026-01-13 09:51:15.975068	2026-01-13 17:58:51.981205	present	2026-03-02 15:43:44.318533
4232	73	2026-01-13	2026-01-13 09:11:19.092317	2026-01-13 17:56:28.749542	present	2026-03-02 15:43:44.318533
4233	74	2026-01-13	2026-01-13 09:08:34.650567	2026-01-13 17:32:29.735908	present	2026-03-02 15:43:44.318533
4234	78	2026-01-13	2026-01-13 09:46:12.676646	2026-01-13 17:04:37.276345	present	2026-03-02 15:43:44.318533
4235	79	2026-01-13	2026-01-13 09:11:29.27015	2026-01-13 17:32:52.340893	present	2026-03-02 15:43:44.318533
4236	82	2026-01-13	2026-01-13 09:00:37.619174	2026-01-13 17:13:27.407391	present	2026-03-02 15:43:44.318533
4237	83	2026-01-13	2026-01-13 09:04:38.290181	2026-01-13 17:26:09.636292	present	2026-03-02 15:43:44.318533
4238	84	2026-01-13	2026-01-13 09:18:38.59154	2026-01-13 17:05:36.959765	present	2026-03-02 15:43:44.318533
4239	85	2026-01-13	2026-01-13 09:39:23.72924	2026-01-13 17:12:37.654551	present	2026-03-02 15:43:44.318533
4240	88	2026-01-13	2026-01-13 09:37:44.075322	2026-01-13 17:35:36.440848	present	2026-03-02 15:43:44.318533
4241	89	2026-01-13	2026-01-13 09:26:43.296665	2026-01-13 17:41:48.674954	present	2026-03-02 15:43:44.318533
4242	96	2026-01-13	2026-01-13 09:00:58.363615	2026-01-13 17:51:13.019664	present	2026-03-02 15:43:44.318533
4243	97	2026-01-13	2026-01-13 09:51:31.808813	2026-01-13 17:51:50.906754	present	2026-03-02 15:43:44.318533
4244	1	2026-01-13	2026-01-13 09:23:22.45401	2026-01-13 17:25:16.903875	present	2026-03-02 15:43:44.318533
4245	2	2026-01-13	2026-01-13 09:31:42.60378	2026-01-13 17:10:33.538038	present	2026-03-02 15:43:44.318533
4246	7	2026-01-13	2026-01-13 09:47:01.08881	2026-01-13 17:40:59.75801	present	2026-03-02 15:43:44.318533
4247	8	2026-01-13	2026-01-13 09:30:45.271803	2026-01-13 17:13:06.103127	present	2026-03-02 15:43:44.318533
4248	9	2026-01-13	2026-01-13 09:38:36.706519	2026-01-13 17:45:06.239775	present	2026-03-02 15:43:44.318533
4249	12	2026-01-13	2026-01-13 09:52:49.610134	2026-01-13 17:32:55.748819	present	2026-03-02 15:43:44.318533
4250	13	2026-01-13	2026-01-13 09:23:21.712753	2026-01-13 17:21:47.935009	present	2026-03-02 15:43:44.318533
4251	14	2026-01-13	2026-01-13 09:03:47.372827	2026-01-13 17:59:46.755122	present	2026-03-02 15:43:44.318533
4252	15	2026-01-13	2026-01-13 09:54:58.153438	2026-01-13 17:28:45.436357	present	2026-03-02 15:43:44.318533
4253	16	2026-01-13	2026-01-13 09:40:11.726247	2026-01-13 17:14:52.310625	present	2026-03-02 15:43:44.318533
4254	17	2026-01-13	2026-01-13 09:04:09.276013	2026-01-13 17:52:48.314044	present	2026-03-02 15:43:44.318533
4255	18	2026-01-13	2026-01-13 09:15:50.882432	2026-01-13 17:19:41.204688	present	2026-03-02 15:43:44.318533
4256	19	2026-01-13	2026-01-13 09:59:54.05366	2026-01-13 17:36:44.113625	present	2026-03-02 15:43:44.318533
4257	20	2026-01-13	2026-01-13 09:49:34.415605	2026-01-13 17:03:44.57347	present	2026-03-02 15:43:44.318533
4258	21	2026-01-13	2026-01-13 09:30:44.341047	2026-01-13 17:12:44.088538	present	2026-03-02 15:43:44.318533
4259	22	2026-01-13	2026-01-13 09:22:07.389808	2026-01-13 17:22:51.249767	present	2026-03-02 15:43:44.318533
4260	23	2026-01-13	2026-01-13 09:52:09.191329	2026-01-13 17:30:18.968979	present	2026-03-02 15:43:44.318533
4261	24	2026-01-13	2026-01-13 09:30:38.998055	2026-01-13 17:06:56.442167	present	2026-03-02 15:43:44.318533
4262	25	2026-01-13	2026-01-13 09:55:34.202797	2026-01-13 17:04:37.202336	present	2026-03-02 15:43:44.318533
4263	26	2026-01-13	2026-01-13 09:31:28.287535	2026-01-13 17:51:32.476552	present	2026-03-02 15:43:44.318533
4264	28	2026-01-13	2026-01-13 09:46:48.637883	2026-01-13 17:37:07.58616	present	2026-03-02 15:43:44.318533
4265	29	2026-01-13	2026-01-13 09:51:17.529356	2026-01-13 17:13:19.221527	present	2026-03-02 15:43:44.318533
4266	30	2026-01-13	2026-01-13 09:41:45.935325	2026-01-13 17:00:06.685751	present	2026-03-02 15:43:44.318533
4267	31	2026-01-13	2026-01-13 09:42:44.459125	2026-01-13 17:13:37.169054	present	2026-03-02 15:43:44.318533
4268	32	2026-01-13	2026-01-13 09:18:12.401039	2026-01-13 17:10:42.788748	present	2026-03-02 15:43:44.318533
4269	34	2026-01-13	2026-01-13 09:56:57.040607	2026-01-13 17:49:54.620532	present	2026-03-02 15:43:44.318533
4270	36	2026-01-13	2026-01-13 09:22:38.783702	2026-01-13 17:40:28.274178	present	2026-03-02 15:43:44.318533
4271	38	2026-01-13	2026-01-13 09:18:21.068119	2026-01-13 17:05:03.114058	present	2026-03-02 15:43:44.318533
4272	39	2026-01-13	2026-01-13 09:27:19.480876	2026-01-13 17:55:46.110787	present	2026-03-02 15:43:44.318533
4273	40	2026-01-13	2026-01-13 09:54:14.582424	2026-01-13 17:20:50.82806	present	2026-03-02 15:43:44.318533
4274	41	2026-01-13	2026-01-13 09:30:17.529117	2026-01-13 17:42:00.235802	present	2026-03-02 15:43:44.318533
4275	42	2026-01-13	2026-01-13 09:26:37.514833	2026-01-13 17:32:56.945574	present	2026-03-02 15:43:44.318533
4276	44	2026-01-13	2026-01-13 09:27:09.485271	2026-01-13 17:11:23.48976	present	2026-03-02 15:43:44.318533
4277	49	2026-01-13	2026-01-13 09:56:04.122198	2026-01-13 17:57:59.039324	present	2026-03-02 15:43:44.318533
4278	51	2026-01-13	2026-01-13 09:26:16.91267	2026-01-13 17:57:49.641818	present	2026-03-02 15:43:44.318533
4279	53	2026-01-13	2026-01-13 09:50:14.8749	2026-01-13 17:20:54.246284	present	2026-03-02 15:43:44.318533
4280	54	2026-01-13	2026-01-13 09:38:08.274552	2026-01-13 17:03:19.056323	present	2026-03-02 15:43:44.318533
4281	55	2026-01-13	2026-01-13 09:58:23.105574	2026-01-13 17:36:33.297685	present	2026-03-02 15:43:44.318533
4282	56	2026-01-13	2026-01-13 09:30:03.262458	2026-01-13 17:18:12.729768	present	2026-03-02 15:43:44.318533
4283	57	2026-01-13	2026-01-13 09:16:45.049421	2026-01-13 17:00:11.092853	present	2026-03-02 15:43:44.318533
4284	58	2026-01-13	2026-01-13 09:14:12.538598	2026-01-13 17:02:24.673616	present	2026-03-02 15:43:44.318533
4285	61	2026-01-13	2026-01-13 09:17:10.413291	2026-01-13 17:29:56.926398	present	2026-03-02 15:43:44.318533
4286	67	2026-01-13	2026-01-13 09:33:23.722471	2026-01-13 17:36:12.148411	present	2026-03-02 15:43:44.318533
4287	68	2026-01-13	2026-01-13 09:04:43.558624	2026-01-13 17:53:42.887165	present	2026-03-02 15:43:44.318533
4288	69	2026-01-13	2026-01-13 09:14:53.593724	2026-01-13 17:48:51.41446	present	2026-03-02 15:43:44.318533
4289	72	2026-01-13	2026-01-13 09:55:02.756057	2026-01-13 17:40:36.288833	present	2026-03-02 15:43:44.318533
4290	75	2026-01-13	2026-01-13 09:39:29.007419	2026-01-13 17:32:14.164135	present	2026-03-02 15:43:44.318533
4291	76	2026-01-13	2026-01-13 09:58:46.194489	2026-01-13 17:38:26.409331	present	2026-03-02 15:43:44.318533
4292	77	2026-01-13	2026-01-13 09:56:33.355381	2026-01-13 17:21:01.699909	present	2026-03-02 15:43:44.318533
4293	80	2026-01-13	2026-01-13 09:37:48.110507	2026-01-13 17:08:05.62238	present	2026-03-02 15:43:44.318533
4294	81	2026-01-13	2026-01-13 09:04:45.917754	2026-01-13 17:36:59.706995	present	2026-03-02 15:43:44.318533
4295	86	2026-01-13	2026-01-13 09:40:52.361811	2026-01-13 17:38:07.512206	present	2026-03-02 15:43:44.318533
4296	87	2026-01-13	2026-01-13 09:26:08.147321	2026-01-13 17:22:57.134632	present	2026-03-02 15:43:44.318533
4297	90	2026-01-13	2026-01-13 09:23:39.269348	2026-01-13 17:28:08.609615	present	2026-03-02 15:43:44.318533
4298	91	2026-01-13	2026-01-13 09:34:09.193283	2026-01-13 17:45:42.099148	present	2026-03-02 15:43:44.318533
4299	92	2026-01-13	2026-01-13 09:25:24.690942	2026-01-13 17:56:44.573217	present	2026-03-02 15:43:44.318533
4300	93	2026-01-13	2026-01-13 09:38:40.879065	2026-01-13 17:52:29.617659	present	2026-03-02 15:43:44.318533
4301	94	2026-01-13	2026-01-13 09:17:27.975845	2026-01-13 17:45:19.260974	present	2026-03-02 15:43:44.318533
4302	95	2026-01-13	2026-01-13 09:54:57.555523	2026-01-13 17:39:51.529481	present	2026-03-02 15:43:44.318533
4303	98	2026-01-13	2026-01-13 09:25:59.908293	2026-01-13 17:49:49.563512	present	2026-03-02 15:43:44.318533
4304	99	2026-01-13	2026-01-13 09:57:18.485813	2026-01-13 17:09:56.037729	present	2026-03-02 15:43:44.318533
4305	100	2026-01-13	2026-01-13 09:43:51.014768	2026-01-13 17:56:23.121413	present	2026-03-02 15:43:44.318533
4306	3	2026-01-14	2026-01-14 09:04:28.542263	2026-01-14 17:02:35.621531	present	2026-03-02 15:43:44.318533
4307	4	2026-01-14	2026-01-14 09:07:12.133035	2026-01-14 17:26:43.720836	present	2026-03-02 15:43:44.318533
4308	5	2026-01-14	2026-01-14 09:56:05.843464	2026-01-14 17:49:09.630971	present	2026-03-02 15:43:44.318533
4309	6	2026-01-14	2026-01-14 09:28:22.214672	2026-01-14 17:50:18.346997	present	2026-03-02 15:43:44.318533
4310	10	2026-01-14	2026-01-14 09:39:46.484678	2026-01-14 17:31:45.022273	present	2026-03-02 15:43:44.318533
4311	11	2026-01-14	2026-01-14 09:59:45.809866	2026-01-14 17:58:20.5304	present	2026-03-02 15:43:44.318533
4312	27	2026-01-14	2026-01-14 09:34:29.386271	2026-01-14 17:36:18.333852	present	2026-03-02 15:43:44.318533
4313	33	2026-01-14	2026-01-14 09:57:02.881312	2026-01-14 17:12:54.075177	present	2026-03-02 15:43:44.318533
4314	35	2026-01-14	2026-01-14 09:48:37.794545	2026-01-14 17:49:56.974994	present	2026-03-02 15:43:44.318533
4315	37	2026-01-14	2026-01-14 09:03:26.443672	2026-01-14 17:41:41.666169	present	2026-03-02 15:43:44.318533
4316	43	2026-01-14	2026-01-14 09:28:16.082913	2026-01-14 17:12:50.578303	present	2026-03-02 15:43:44.318533
4317	45	2026-01-14	2026-01-14 09:37:35.819411	2026-01-14 17:28:42.666096	present	2026-03-02 15:43:44.318533
4318	46	2026-01-14	2026-01-14 09:17:34.473687	2026-01-14 17:20:01.207351	present	2026-03-02 15:43:44.318533
4319	47	2026-01-14	2026-01-14 09:00:52.058782	2026-01-14 17:26:35.916977	present	2026-03-02 15:43:44.318533
4320	48	2026-01-14	2026-01-14 09:59:13.62911	2026-01-14 17:50:05.87166	present	2026-03-02 15:43:44.318533
4321	50	2026-01-14	2026-01-14 09:52:41.702522	2026-01-14 17:15:25.41247	present	2026-03-02 15:43:44.318533
4322	52	2026-01-14	2026-01-14 09:58:03.896133	2026-01-14 17:39:43.791206	present	2026-03-02 15:43:44.318533
4323	59	2026-01-14	2026-01-14 09:16:10.242863	2026-01-14 17:01:27.730714	present	2026-03-02 15:43:44.318533
4324	60	2026-01-14	2026-01-14 09:32:17.727777	2026-01-14 17:17:31.984967	present	2026-03-02 15:43:44.318533
4325	62	2026-01-14	2026-01-14 09:34:59.305556	2026-01-14 17:10:27.269144	present	2026-03-02 15:43:44.318533
4326	63	2026-01-14	2026-01-14 09:14:24.588675	2026-01-14 17:56:13.276895	present	2026-03-02 15:43:44.318533
4327	64	2026-01-14	2026-01-14 09:46:08.859322	2026-01-14 17:26:27.331572	present	2026-03-02 15:43:44.318533
4328	65	2026-01-14	2026-01-14 09:24:53.238937	2026-01-14 17:04:59.014716	present	2026-03-02 15:43:44.318533
4329	66	2026-01-14	2026-01-14 09:12:13.576011	2026-01-14 17:11:33.337506	present	2026-03-02 15:43:44.318533
4330	70	2026-01-14	2026-01-14 09:52:15.445019	2026-01-14 17:13:24.76827	present	2026-03-02 15:43:44.318533
4331	71	2026-01-14	2026-01-14 09:14:21.769641	2026-01-14 17:51:19.248654	present	2026-03-02 15:43:44.318533
4332	73	2026-01-14	2026-01-14 09:11:37.469975	2026-01-14 17:49:39.628972	present	2026-03-02 15:43:44.318533
4333	74	2026-01-14	2026-01-14 09:38:32.176419	2026-01-14 17:09:19.690744	present	2026-03-02 15:43:44.318533
4334	78	2026-01-14	2026-01-14 09:52:55.377014	2026-01-14 17:02:47.506683	present	2026-03-02 15:43:44.318533
4335	79	2026-01-14	2026-01-14 09:13:09.011013	2026-01-14 17:59:03.067492	present	2026-03-02 15:43:44.318533
4336	82	2026-01-14	2026-01-14 09:33:30.813925	2026-01-14 17:50:33.131496	present	2026-03-02 15:43:44.318533
4337	83	2026-01-14	2026-01-14 09:04:48.551098	2026-01-14 17:28:45.687601	present	2026-03-02 15:43:44.318533
4338	84	2026-01-14	2026-01-14 09:03:10.539294	2026-01-14 17:14:07.618703	present	2026-03-02 15:43:44.318533
4339	85	2026-01-14	2026-01-14 09:50:54.053478	2026-01-14 17:53:38.771891	present	2026-03-02 15:43:44.318533
4340	88	2026-01-14	2026-01-14 09:12:26.069008	2026-01-14 17:57:16.963713	present	2026-03-02 15:43:44.318533
4341	89	2026-01-14	2026-01-14 09:50:36.659027	2026-01-14 17:45:20.287182	present	2026-03-02 15:43:44.318533
4342	96	2026-01-14	2026-01-14 09:58:56.650442	2026-01-14 17:19:24.225808	present	2026-03-02 15:43:44.318533
4343	97	2026-01-14	2026-01-14 09:44:36.034269	2026-01-14 17:31:51.445255	present	2026-03-02 15:43:44.318533
4344	1	2026-01-14	2026-01-14 09:11:03.166996	2026-01-14 17:22:53.371921	present	2026-03-02 15:43:44.318533
4345	2	2026-01-14	2026-01-14 09:06:04.04617	2026-01-14 17:43:09.366314	present	2026-03-02 15:43:44.318533
4346	7	2026-01-14	2026-01-14 09:36:29.539043	2026-01-14 17:35:59.297681	present	2026-03-02 15:43:44.318533
4347	8	2026-01-14	2026-01-14 09:50:11.644883	2026-01-14 17:09:20.742323	present	2026-03-02 15:43:44.318533
4348	9	2026-01-14	2026-01-14 09:07:11.34323	2026-01-14 17:58:44.39174	present	2026-03-02 15:43:44.318533
4349	12	2026-01-14	2026-01-14 09:17:45.154592	2026-01-14 17:36:09.162528	present	2026-03-02 15:43:44.318533
4350	13	2026-01-14	2026-01-14 09:45:39.162477	2026-01-14 17:50:03.801271	present	2026-03-02 15:43:44.318533
4351	14	2026-01-14	2026-01-14 09:59:21.473368	2026-01-14 17:10:12.330058	present	2026-03-02 15:43:44.318533
4352	15	2026-01-14	2026-01-14 09:46:20.010752	2026-01-14 17:59:23.39371	present	2026-03-02 15:43:44.318533
4353	16	2026-01-14	2026-01-14 09:58:14.291997	2026-01-14 17:16:23.252689	present	2026-03-02 15:43:44.318533
4354	17	2026-01-14	2026-01-14 09:01:50.566769	2026-01-14 17:07:35.90211	present	2026-03-02 15:43:44.318533
4355	18	2026-01-14	2026-01-14 09:28:57.424407	2026-01-14 17:58:15.609926	present	2026-03-02 15:43:44.318533
4356	19	2026-01-14	2026-01-14 09:33:38.676495	2026-01-14 17:45:26.411324	present	2026-03-02 15:43:44.318533
4357	20	2026-01-14	2026-01-14 09:17:15.251118	2026-01-14 17:47:29.36747	present	2026-03-02 15:43:44.318533
4358	21	2026-01-14	2026-01-14 09:13:16.581072	2026-01-14 17:32:58.954367	present	2026-03-02 15:43:44.318533
4359	22	2026-01-14	2026-01-14 09:25:24.531807	2026-01-14 17:53:27.820646	present	2026-03-02 15:43:44.318533
4360	23	2026-01-14	2026-01-14 09:47:12.501813	2026-01-14 17:41:14.903538	present	2026-03-02 15:43:44.318533
4361	24	2026-01-14	2026-01-14 09:59:38.294388	2026-01-14 17:55:29.057592	present	2026-03-02 15:43:44.318533
4362	25	2026-01-14	2026-01-14 09:03:06.196235	2026-01-14 17:11:26.12084	present	2026-03-02 15:43:44.318533
4363	26	2026-01-14	2026-01-14 09:45:26.24271	2026-01-14 17:28:54.791561	present	2026-03-02 15:43:44.318533
4364	28	2026-01-14	2026-01-14 09:03:07.601488	2026-01-14 17:26:57.198134	present	2026-03-02 15:43:44.318533
4365	29	2026-01-14	2026-01-14 09:40:55.877809	2026-01-14 17:49:43.559605	present	2026-03-02 15:43:44.318533
4366	30	2026-01-14	2026-01-14 09:51:33.905482	2026-01-14 17:18:44.141496	present	2026-03-02 15:43:44.318533
4367	31	2026-01-14	2026-01-14 09:02:31.500268	2026-01-14 17:25:55.058113	present	2026-03-02 15:43:44.318533
4368	32	2026-01-14	2026-01-14 09:03:40.472686	2026-01-14 17:04:17.127623	present	2026-03-02 15:43:44.318533
4369	34	2026-01-14	2026-01-14 09:42:40.7546	2026-01-14 17:37:02.16317	present	2026-03-02 15:43:44.318533
4370	36	2026-01-14	2026-01-14 09:23:02.324742	2026-01-14 17:05:46.425076	present	2026-03-02 15:43:44.318533
4371	38	2026-01-14	2026-01-14 09:36:46.367738	2026-01-14 17:45:28.40596	present	2026-03-02 15:43:44.318533
4372	39	2026-01-14	2026-01-14 09:59:56.50246	2026-01-14 17:59:14.667572	present	2026-03-02 15:43:44.318533
4373	40	2026-01-14	2026-01-14 09:11:34.671731	2026-01-14 17:54:23.176519	present	2026-03-02 15:43:44.318533
4374	41	2026-01-14	2026-01-14 09:57:38.817489	2026-01-14 17:45:37.656484	present	2026-03-02 15:43:44.318533
4375	42	2026-01-14	2026-01-14 09:32:23.154814	2026-01-14 17:37:44.424411	present	2026-03-02 15:43:44.318533
4376	44	2026-01-14	2026-01-14 09:50:54.263834	2026-01-14 17:22:19.819158	present	2026-03-02 15:43:44.318533
4377	49	2026-01-14	2026-01-14 09:58:20.107748	2026-01-14 17:30:04.240831	present	2026-03-02 15:43:44.318533
4378	51	2026-01-14	2026-01-14 09:33:48.331588	2026-01-14 17:08:36.228087	present	2026-03-02 15:43:44.318533
4379	53	2026-01-14	2026-01-14 09:34:02.498578	2026-01-14 17:28:35.579297	present	2026-03-02 15:43:44.318533
4380	54	2026-01-14	2026-01-14 09:03:19.259251	2026-01-14 17:29:47.02853	present	2026-03-02 15:43:44.318533
4381	55	2026-01-14	2026-01-14 09:05:54.31109	2026-01-14 17:07:55.702326	present	2026-03-02 15:43:44.318533
4382	56	2026-01-14	2026-01-14 09:11:57.773861	2026-01-14 17:36:22.036611	present	2026-03-02 15:43:44.318533
4383	57	2026-01-14	2026-01-14 09:52:06.782455	2026-01-14 17:24:02.838698	present	2026-03-02 15:43:44.318533
4384	58	2026-01-14	2026-01-14 09:45:37.086212	2026-01-14 17:43:42.268783	present	2026-03-02 15:43:44.318533
4385	61	2026-01-14	2026-01-14 09:23:36.942233	2026-01-14 17:21:54.217053	present	2026-03-02 15:43:44.318533
4386	67	2026-01-14	2026-01-14 09:20:48.395761	2026-01-14 17:58:35.740946	present	2026-03-02 15:43:44.318533
4387	68	2026-01-14	2026-01-14 09:02:23.926113	2026-01-14 17:44:15.686498	present	2026-03-02 15:43:44.318533
4388	69	2026-01-14	2026-01-14 09:20:04.165961	2026-01-14 17:23:37.79905	present	2026-03-02 15:43:44.318533
4389	72	2026-01-14	2026-01-14 09:02:16.083463	2026-01-14 17:49:24.220534	present	2026-03-02 15:43:44.318533
4390	75	2026-01-14	2026-01-14 09:53:10.373747	2026-01-14 17:00:16.622873	present	2026-03-02 15:43:44.318533
4391	76	2026-01-14	2026-01-14 09:44:34.794642	2026-01-14 17:56:27.941701	present	2026-03-02 15:43:44.318533
4392	77	2026-01-14	2026-01-14 09:48:29.845923	2026-01-14 17:30:41.281131	present	2026-03-02 15:43:44.318533
4393	80	2026-01-14	2026-01-14 09:03:57.414925	2026-01-14 17:40:55.016401	present	2026-03-02 15:43:44.318533
4394	81	2026-01-14	2026-01-14 09:22:42.202694	2026-01-14 17:32:45.348379	present	2026-03-02 15:43:44.318533
4395	86	2026-01-14	2026-01-14 09:29:27.951306	2026-01-14 17:43:52.129728	present	2026-03-02 15:43:44.318533
4396	87	2026-01-14	2026-01-14 09:13:01.175021	2026-01-14 17:51:14.253583	present	2026-03-02 15:43:44.318533
4397	90	2026-01-14	2026-01-14 09:25:52.743788	2026-01-14 17:40:46.935193	present	2026-03-02 15:43:44.318533
4398	91	2026-01-14	2026-01-14 09:18:14.842847	2026-01-14 17:42:27.722421	present	2026-03-02 15:43:44.318533
4399	92	2026-01-14	2026-01-14 09:09:18.625511	2026-01-14 17:04:40.957874	present	2026-03-02 15:43:44.318533
4400	93	2026-01-14	2026-01-14 09:00:08.721188	2026-01-14 17:51:47.833999	present	2026-03-02 15:43:44.318533
4401	94	2026-01-14	2026-01-14 09:38:54.948128	2026-01-14 17:37:42.341849	present	2026-03-02 15:43:44.318533
4402	95	2026-01-14	2026-01-14 09:12:57.384448	2026-01-14 17:34:32.138423	present	2026-03-02 15:43:44.318533
4403	98	2026-01-14	2026-01-14 09:07:31.112584	2026-01-14 17:42:56.223317	present	2026-03-02 15:43:44.318533
4404	99	2026-01-14	2026-01-14 09:01:24.319084	2026-01-14 17:12:25.76556	present	2026-03-02 15:43:44.318533
4405	100	2026-01-14	2026-01-14 09:39:50.146469	2026-01-14 17:29:10.74283	present	2026-03-02 15:43:44.318533
4406	3	2026-01-15	2026-01-15 09:33:27.173929	2026-01-15 17:44:23.884734	present	2026-03-02 15:43:44.318533
4407	4	2026-01-15	2026-01-15 09:23:28.534447	2026-01-15 17:37:10.295363	present	2026-03-02 15:43:44.318533
4408	5	2026-01-15	2026-01-15 09:56:07.032689	2026-01-15 17:38:07.196258	present	2026-03-02 15:43:44.318533
4409	6	2026-01-15	2026-01-15 09:22:55.109728	2026-01-15 17:35:04.236252	present	2026-03-02 15:43:44.318533
4410	10	2026-01-15	2026-01-15 09:39:19.579959	2026-01-15 17:48:08.501312	present	2026-03-02 15:43:44.318533
4411	11	2026-01-15	2026-01-15 09:07:26.902358	2026-01-15 17:08:22.77798	present	2026-03-02 15:43:44.318533
4412	27	2026-01-15	2026-01-15 09:46:32.782448	2026-01-15 17:05:54.592931	present	2026-03-02 15:43:44.318533
4413	33	2026-01-15	2026-01-15 09:02:55.371382	2026-01-15 17:09:46.575208	present	2026-03-02 15:43:44.318533
4414	35	2026-01-15	2026-01-15 09:11:08.054032	2026-01-15 17:17:21.610702	present	2026-03-02 15:43:44.318533
4415	37	2026-01-15	2026-01-15 09:19:20.431288	2026-01-15 17:14:36.963717	present	2026-03-02 15:43:44.318533
4416	43	2026-01-15	2026-01-15 09:32:15.086771	2026-01-15 17:20:38.074878	present	2026-03-02 15:43:44.318533
4417	45	2026-01-15	2026-01-15 09:27:28.857408	2026-01-15 17:16:58.641876	present	2026-03-02 15:43:44.318533
4418	46	2026-01-15	2026-01-15 09:17:11.999029	2026-01-15 17:25:37.576247	present	2026-03-02 15:43:44.318533
4419	47	2026-01-15	2026-01-15 09:55:32.538088	2026-01-15 17:13:51.327532	present	2026-03-02 15:43:44.318533
4420	48	2026-01-15	2026-01-15 09:10:08.878602	2026-01-15 17:24:09.461348	present	2026-03-02 15:43:44.318533
4421	50	2026-01-15	2026-01-15 09:19:58.082544	2026-01-15 17:34:23.521876	present	2026-03-02 15:43:44.318533
4422	52	2026-01-15	2026-01-15 09:49:32.974388	2026-01-15 17:40:58.797544	present	2026-03-02 15:43:44.318533
4423	59	2026-01-15	2026-01-15 09:39:35.907891	2026-01-15 17:49:52.029325	present	2026-03-02 15:43:44.318533
4424	60	2026-01-15	2026-01-15 09:50:27.174005	2026-01-15 17:48:46.863474	present	2026-03-02 15:43:44.318533
4425	62	2026-01-15	2026-01-15 09:29:13.035133	2026-01-15 17:50:46.543714	present	2026-03-02 15:43:44.318533
4426	63	2026-01-15	2026-01-15 09:34:33.08175	2026-01-15 17:44:57.177207	present	2026-03-02 15:43:44.318533
4427	64	2026-01-15	2026-01-15 09:28:40.096568	2026-01-15 17:15:29.124151	present	2026-03-02 15:43:44.318533
4428	65	2026-01-15	2026-01-15 09:51:45.064179	2026-01-15 17:41:18.797579	present	2026-03-02 15:43:44.318533
4429	66	2026-01-15	2026-01-15 09:10:42.301342	2026-01-15 17:58:57.242986	present	2026-03-02 15:43:44.318533
4430	70	2026-01-15	2026-01-15 09:57:00.054652	2026-01-15 17:11:07.786495	present	2026-03-02 15:43:44.318533
4431	71	2026-01-15	2026-01-15 09:51:53.408549	2026-01-15 17:27:49.915843	present	2026-03-02 15:43:44.318533
4432	73	2026-01-15	2026-01-15 09:23:10.612292	2026-01-15 17:13:55.049371	present	2026-03-02 15:43:44.318533
4433	74	2026-01-15	2026-01-15 09:24:59.16034	2026-01-15 17:04:43.924185	present	2026-03-02 15:43:44.318533
4434	78	2026-01-15	2026-01-15 09:05:50.673526	2026-01-15 17:04:44.754144	present	2026-03-02 15:43:44.318533
4435	79	2026-01-15	2026-01-15 09:19:03.116008	2026-01-15 17:59:20.881827	present	2026-03-02 15:43:44.318533
4436	82	2026-01-15	2026-01-15 09:18:19.348125	2026-01-15 17:25:02.061066	present	2026-03-02 15:43:44.318533
4437	83	2026-01-15	2026-01-15 09:52:04.012667	2026-01-15 17:30:40.72003	present	2026-03-02 15:43:44.318533
4438	84	2026-01-15	2026-01-15 09:38:17.039916	2026-01-15 17:40:40.083581	present	2026-03-02 15:43:44.318533
4439	85	2026-01-15	2026-01-15 09:13:43.38741	2026-01-15 17:12:03.327361	present	2026-03-02 15:43:44.318533
4440	88	2026-01-15	2026-01-15 09:50:48.697306	2026-01-15 17:55:10.159913	present	2026-03-02 15:43:44.318533
4441	89	2026-01-15	2026-01-15 09:01:35.792915	2026-01-15 17:44:29.544979	present	2026-03-02 15:43:44.318533
4442	96	2026-01-15	2026-01-15 09:33:33.875345	2026-01-15 17:38:28.643934	present	2026-03-02 15:43:44.318533
4443	97	2026-01-15	2026-01-15 09:46:26.277382	2026-01-15 17:38:55.037673	present	2026-03-02 15:43:44.318533
4444	1	2026-01-15	2026-01-15 09:22:46.9008	2026-01-15 17:38:04.879909	present	2026-03-02 15:43:44.318533
4445	2	2026-01-15	2026-01-15 09:27:55.093771	2026-01-15 17:02:55.650749	present	2026-03-02 15:43:44.318533
4446	7	2026-01-15	2026-01-15 09:52:17.077324	2026-01-15 17:13:51.679501	present	2026-03-02 15:43:44.318533
4447	8	2026-01-15	2026-01-15 09:01:56.99044	2026-01-15 17:43:03.956019	present	2026-03-02 15:43:44.318533
4448	9	2026-01-15	2026-01-15 09:19:46.127292	2026-01-15 17:18:47.335571	present	2026-03-02 15:43:44.318533
4449	12	2026-01-15	2026-01-15 09:22:30.153433	2026-01-15 17:29:57.329095	present	2026-03-02 15:43:44.318533
4450	13	2026-01-15	2026-01-15 09:52:59.049102	2026-01-15 17:27:52.31309	present	2026-03-02 15:43:44.318533
4451	14	2026-01-15	2026-01-15 09:20:56.660005	2026-01-15 17:01:38.903361	present	2026-03-02 15:43:44.318533
4452	15	2026-01-15	2026-01-15 09:18:13.374513	2026-01-15 17:03:27.333726	present	2026-03-02 15:43:44.318533
4453	16	2026-01-15	2026-01-15 09:21:43.884763	2026-01-15 17:07:06.483209	present	2026-03-02 15:43:44.318533
4454	17	2026-01-15	2026-01-15 09:34:58.915821	2026-01-15 17:28:32.76825	present	2026-03-02 15:43:44.318533
4455	18	2026-01-15	2026-01-15 09:53:14.302175	2026-01-15 17:33:09.448893	present	2026-03-02 15:43:44.318533
4456	19	2026-01-15	2026-01-15 09:36:24.008742	2026-01-15 17:28:01.58255	present	2026-03-02 15:43:44.318533
4457	20	2026-01-15	2026-01-15 09:26:14.465696	2026-01-15 17:45:54.006263	present	2026-03-02 15:43:44.318533
4458	21	2026-01-15	2026-01-15 09:40:29.584699	2026-01-15 17:40:29.015473	present	2026-03-02 15:43:44.318533
4459	22	2026-01-15	2026-01-15 09:52:24.740378	2026-01-15 17:40:29.52512	present	2026-03-02 15:43:44.318533
4460	23	2026-01-15	2026-01-15 09:59:25.771276	2026-01-15 17:01:07.868089	present	2026-03-02 15:43:44.318533
4461	24	2026-01-15	2026-01-15 09:12:01.44149	2026-01-15 17:31:19.459839	present	2026-03-02 15:43:44.318533
4462	25	2026-01-15	2026-01-15 09:46:02.787224	2026-01-15 17:31:51.479119	present	2026-03-02 15:43:44.318533
4463	26	2026-01-15	2026-01-15 09:10:42.139873	2026-01-15 17:08:53.216224	present	2026-03-02 15:43:44.318533
4464	28	2026-01-15	2026-01-15 09:21:52.893027	2026-01-15 17:13:33.842843	present	2026-03-02 15:43:44.318533
4465	29	2026-01-15	2026-01-15 09:01:30.807625	2026-01-15 17:20:31.789863	present	2026-03-02 15:43:44.318533
4466	30	2026-01-15	2026-01-15 09:18:22.812664	2026-01-15 17:24:09.998113	present	2026-03-02 15:43:44.318533
4467	31	2026-01-15	2026-01-15 09:03:45.690507	2026-01-15 17:48:07.632981	present	2026-03-02 15:43:44.318533
4468	32	2026-01-15	2026-01-15 09:31:52.845066	2026-01-15 17:52:36.435369	present	2026-03-02 15:43:44.318533
4469	34	2026-01-15	2026-01-15 09:25:47.073117	2026-01-15 17:08:20.881757	present	2026-03-02 15:43:44.318533
4470	36	2026-01-15	2026-01-15 09:02:37.465703	2026-01-15 17:57:56.806928	present	2026-03-02 15:43:44.318533
4471	38	2026-01-15	2026-01-15 09:01:07.230285	2026-01-15 17:39:40.299297	present	2026-03-02 15:43:44.318533
4472	39	2026-01-15	2026-01-15 09:02:41.581946	2026-01-15 17:03:07.821796	present	2026-03-02 15:43:44.318533
4473	40	2026-01-15	2026-01-15 09:35:21.234808	2026-01-15 17:19:37.058687	present	2026-03-02 15:43:44.318533
4474	41	2026-01-15	2026-01-15 09:48:24.657818	2026-01-15 17:47:15.236918	present	2026-03-02 15:43:44.318533
4475	42	2026-01-15	2026-01-15 09:49:11.962701	2026-01-15 17:30:16.60879	present	2026-03-02 15:43:44.318533
4476	44	2026-01-15	2026-01-15 09:49:41.020993	2026-01-15 17:08:25.159777	present	2026-03-02 15:43:44.318533
4477	49	2026-01-15	2026-01-15 09:06:09.778757	2026-01-15 17:22:30.856819	present	2026-03-02 15:43:44.318533
4478	51	2026-01-15	2026-01-15 09:13:14.164471	2026-01-15 17:32:54.488861	present	2026-03-02 15:43:44.318533
4479	53	2026-01-15	2026-01-15 09:45:00.365847	2026-01-15 17:45:51.5745	present	2026-03-02 15:43:44.318533
4480	54	2026-01-15	2026-01-15 09:18:14.6131	2026-01-15 17:31:09.213926	present	2026-03-02 15:43:44.318533
4481	55	2026-01-15	2026-01-15 09:46:44.03439	2026-01-15 17:57:35.093474	present	2026-03-02 15:43:44.318533
4482	56	2026-01-15	2026-01-15 09:18:42.771049	2026-01-15 17:37:30.181079	present	2026-03-02 15:43:44.318533
4483	57	2026-01-15	2026-01-15 09:08:23.177963	2026-01-15 17:09:16.393361	present	2026-03-02 15:43:44.318533
4484	58	2026-01-15	2026-01-15 09:09:19.292204	2026-01-15 17:10:25.048404	present	2026-03-02 15:43:44.318533
4485	61	2026-01-15	2026-01-15 09:02:51.214446	2026-01-15 17:28:32.769585	present	2026-03-02 15:43:44.318533
4486	67	2026-01-15	2026-01-15 09:10:58.991517	2026-01-15 17:48:49.525114	present	2026-03-02 15:43:44.318533
4487	68	2026-01-15	2026-01-15 09:30:52.974045	2026-01-15 17:15:12.661545	present	2026-03-02 15:43:44.318533
4488	69	2026-01-15	2026-01-15 09:18:54.466877	2026-01-15 17:47:35.085867	present	2026-03-02 15:43:44.318533
4489	72	2026-01-15	2026-01-15 09:26:28.13379	2026-01-15 17:31:35.478825	present	2026-03-02 15:43:44.318533
4490	75	2026-01-15	2026-01-15 09:33:52.388336	2026-01-15 17:12:02.246332	present	2026-03-02 15:43:44.318533
4491	76	2026-01-15	2026-01-15 09:49:30.387244	2026-01-15 17:42:41.546443	present	2026-03-02 15:43:44.318533
4492	77	2026-01-15	2026-01-15 09:44:14.944756	2026-01-15 17:02:55.911034	present	2026-03-02 15:43:44.318533
4493	80	2026-01-15	2026-01-15 09:29:38.156173	2026-01-15 17:25:29.511267	present	2026-03-02 15:43:44.318533
4494	81	2026-01-15	2026-01-15 09:42:39.705462	2026-01-15 17:33:57.144589	present	2026-03-02 15:43:44.318533
4495	86	2026-01-15	2026-01-15 09:06:34.359221	2026-01-15 17:37:07.499415	present	2026-03-02 15:43:44.318533
4496	87	2026-01-15	2026-01-15 09:32:08.288057	2026-01-15 17:40:32.204604	present	2026-03-02 15:43:44.318533
4497	90	2026-01-15	2026-01-15 09:37:52.833173	2026-01-15 17:54:24.947023	present	2026-03-02 15:43:44.318533
4498	91	2026-01-15	2026-01-15 09:28:49.683308	2026-01-15 17:01:28.389592	present	2026-03-02 15:43:44.318533
4499	92	2026-01-15	2026-01-15 09:10:34.704813	2026-01-15 17:10:09.054717	present	2026-03-02 15:43:44.318533
4500	93	2026-01-15	2026-01-15 09:52:51.521136	2026-01-15 17:57:15.470475	present	2026-03-02 15:43:44.318533
4501	94	2026-01-15	2026-01-15 09:05:12.692537	2026-01-15 17:19:55.22856	present	2026-03-02 15:43:44.318533
4502	95	2026-01-15	2026-01-15 09:03:10.346048	2026-01-15 17:33:56.888683	present	2026-03-02 15:43:44.318533
4503	98	2026-01-15	2026-01-15 09:08:34.799219	2026-01-15 17:20:47.12992	present	2026-03-02 15:43:44.318533
4504	99	2026-01-15	2026-01-15 09:07:44.088142	2026-01-15 17:40:05.917792	present	2026-03-02 15:43:44.318533
4505	100	2026-01-15	2026-01-15 09:54:49.209546	2026-01-15 17:05:44.308969	present	2026-03-02 15:43:44.318533
4506	3	2026-01-16	2026-01-16 09:36:25.576103	2026-01-16 17:15:36.493664	present	2026-03-02 15:43:44.318533
4507	4	2026-01-16	2026-01-16 09:38:58.850217	2026-01-16 17:05:12.130229	present	2026-03-02 15:43:44.318533
4508	5	2026-01-16	2026-01-16 09:38:53.274305	2026-01-16 17:19:01.144247	present	2026-03-02 15:43:44.318533
4509	6	2026-01-16	2026-01-16 09:32:07.516674	2026-01-16 17:46:26.042933	present	2026-03-02 15:43:44.318533
4510	10	2026-01-16	2026-01-16 09:40:50.943848	2026-01-16 17:20:52.408461	present	2026-03-02 15:43:44.318533
4511	11	2026-01-16	2026-01-16 09:00:05.117088	2026-01-16 17:25:32.179512	present	2026-03-02 15:43:44.318533
4512	27	2026-01-16	2026-01-16 09:16:24.849983	2026-01-16 17:15:20.304265	present	2026-03-02 15:43:44.318533
4513	33	2026-01-16	2026-01-16 09:27:07.009455	2026-01-16 17:12:03.779838	present	2026-03-02 15:43:44.318533
4514	35	2026-01-16	2026-01-16 09:57:22.70109	2026-01-16 17:23:26.336341	present	2026-03-02 15:43:44.318533
4515	37	2026-01-16	2026-01-16 09:46:32.653661	2026-01-16 17:25:02.387875	present	2026-03-02 15:43:44.318533
4516	43	2026-01-16	2026-01-16 09:48:45.109793	2026-01-16 17:34:02.999224	present	2026-03-02 15:43:44.318533
4517	45	2026-01-16	2026-01-16 09:51:58.004986	2026-01-16 17:17:08.967069	present	2026-03-02 15:43:44.318533
4518	46	2026-01-16	2026-01-16 09:22:00.470446	2026-01-16 17:02:33.484869	present	2026-03-02 15:43:44.318533
4519	47	2026-01-16	2026-01-16 09:27:21.85837	2026-01-16 17:34:20.926129	present	2026-03-02 15:43:44.318533
4520	48	2026-01-16	2026-01-16 09:43:14.863426	2026-01-16 17:36:01.611667	present	2026-03-02 15:43:44.318533
4521	50	2026-01-16	2026-01-16 09:18:00.77936	2026-01-16 17:44:20.185411	present	2026-03-02 15:43:44.318533
4522	52	2026-01-16	2026-01-16 09:43:33.620236	2026-01-16 17:22:14.653437	present	2026-03-02 15:43:44.318533
4523	59	2026-01-16	2026-01-16 09:17:43.162275	2026-01-16 17:05:13.328363	present	2026-03-02 15:43:44.318533
4524	60	2026-01-16	2026-01-16 09:10:30.267827	2026-01-16 17:16:54.011558	present	2026-03-02 15:43:44.318533
4525	62	2026-01-16	2026-01-16 09:38:10.825576	2026-01-16 17:31:40.100965	present	2026-03-02 15:43:44.318533
4526	63	2026-01-16	2026-01-16 09:50:55.26832	2026-01-16 17:20:53.384536	present	2026-03-02 15:43:44.318533
4527	64	2026-01-16	2026-01-16 09:46:01.16324	2026-01-16 17:24:07.197467	present	2026-03-02 15:43:44.318533
4528	65	2026-01-16	2026-01-16 09:48:44.162544	2026-01-16 17:02:34.327321	present	2026-03-02 15:43:44.318533
4529	66	2026-01-16	2026-01-16 09:41:11.952449	2026-01-16 17:48:33.250338	present	2026-03-02 15:43:44.318533
4530	70	2026-01-16	2026-01-16 09:14:04.300479	2026-01-16 17:57:35.628315	present	2026-03-02 15:43:44.318533
4531	71	2026-01-16	2026-01-16 09:04:27.358783	2026-01-16 17:30:45.792985	present	2026-03-02 15:43:44.318533
4532	73	2026-01-16	2026-01-16 09:59:06.877469	2026-01-16 17:17:33.210176	present	2026-03-02 15:43:44.318533
4533	74	2026-01-16	2026-01-16 09:39:28.015493	2026-01-16 17:16:52.835119	present	2026-03-02 15:43:44.318533
4534	78	2026-01-16	2026-01-16 09:31:47.92798	2026-01-16 17:56:13.316085	present	2026-03-02 15:43:44.318533
4535	79	2026-01-16	2026-01-16 09:40:51.10693	2026-01-16 17:36:49.502685	present	2026-03-02 15:43:44.318533
4536	82	2026-01-16	2026-01-16 09:01:44.67874	2026-01-16 17:56:26.527457	present	2026-03-02 15:43:44.318533
4537	83	2026-01-16	2026-01-16 09:03:48.770956	2026-01-16 17:20:14.933131	present	2026-03-02 15:43:44.318533
4538	84	2026-01-16	2026-01-16 09:40:40.566042	2026-01-16 17:22:05.851248	present	2026-03-02 15:43:44.318533
4539	85	2026-01-16	2026-01-16 09:54:44.585116	2026-01-16 17:17:47.733934	present	2026-03-02 15:43:44.318533
4540	88	2026-01-16	2026-01-16 09:30:20.197418	2026-01-16 17:00:27.132212	present	2026-03-02 15:43:44.318533
4541	89	2026-01-16	2026-01-16 09:44:32.857152	2026-01-16 17:01:39.780135	present	2026-03-02 15:43:44.318533
4542	96	2026-01-16	2026-01-16 09:12:58.816196	2026-01-16 17:27:36.807892	present	2026-03-02 15:43:44.318533
4543	97	2026-01-16	2026-01-16 09:03:09.199493	2026-01-16 17:39:22.311336	present	2026-03-02 15:43:44.318533
4544	1	2026-01-16	2026-01-16 09:19:59.054803	2026-01-16 17:52:07.441534	present	2026-03-02 15:43:44.318533
4545	2	2026-01-16	2026-01-16 09:39:06.076624	2026-01-16 17:27:30.312158	present	2026-03-02 15:43:44.318533
4546	7	2026-01-16	2026-01-16 09:50:41.271451	2026-01-16 17:39:03.767934	present	2026-03-02 15:43:44.318533
4547	8	2026-01-16	2026-01-16 09:03:22.935308	2026-01-16 17:25:54.941017	present	2026-03-02 15:43:44.318533
4548	9	2026-01-16	2026-01-16 09:46:29.751486	2026-01-16 17:43:56.962722	present	2026-03-02 15:43:44.318533
4549	12	2026-01-16	2026-01-16 09:21:49.714881	2026-01-16 17:19:55.977755	present	2026-03-02 15:43:44.318533
4550	13	2026-01-16	2026-01-16 09:12:30.97299	2026-01-16 17:00:49.218521	present	2026-03-02 15:43:44.318533
4551	14	2026-01-16	2026-01-16 09:56:54.823556	2026-01-16 17:00:00.950227	present	2026-03-02 15:43:44.318533
4552	15	2026-01-16	2026-01-16 09:50:11.979067	2026-01-16 17:54:08.228024	present	2026-03-02 15:43:44.318533
4553	16	2026-01-16	2026-01-16 09:55:17.932577	2026-01-16 17:40:00.554081	present	2026-03-02 15:43:44.318533
4554	17	2026-01-16	2026-01-16 09:17:01.729617	2026-01-16 17:11:15.577542	present	2026-03-02 15:43:44.318533
4555	18	2026-01-16	2026-01-16 09:57:41.116001	2026-01-16 17:44:06.071577	present	2026-03-02 15:43:44.318533
4556	19	2026-01-16	2026-01-16 09:51:49.803783	2026-01-16 17:38:04.158878	present	2026-03-02 15:43:44.318533
4557	20	2026-01-16	2026-01-16 09:15:27.985328	2026-01-16 17:45:02.164529	present	2026-03-02 15:43:44.318533
4558	21	2026-01-16	2026-01-16 09:09:18.164917	2026-01-16 17:32:22.374603	present	2026-03-02 15:43:44.318533
4559	22	2026-01-16	2026-01-16 09:52:49.774949	2026-01-16 17:36:28.542215	present	2026-03-02 15:43:44.318533
4560	23	2026-01-16	2026-01-16 09:45:41.589176	2026-01-16 17:48:54.314069	present	2026-03-02 15:43:44.318533
4561	24	2026-01-16	2026-01-16 09:59:18.09622	2026-01-16 17:09:08.196528	present	2026-03-02 15:43:44.318533
4562	25	2026-01-16	2026-01-16 09:08:06.20282	2026-01-16 17:13:06.258801	present	2026-03-02 15:43:44.318533
4563	26	2026-01-16	2026-01-16 09:43:25.500236	2026-01-16 17:18:18.382616	present	2026-03-02 15:43:44.318533
4564	28	2026-01-16	2026-01-16 09:14:17.038118	2026-01-16 17:32:17.707799	present	2026-03-02 15:43:44.318533
4565	29	2026-01-16	2026-01-16 09:48:14.443581	2026-01-16 17:50:46.60693	present	2026-03-02 15:43:44.318533
4566	30	2026-01-16	2026-01-16 09:31:55.379499	2026-01-16 17:01:26.638536	present	2026-03-02 15:43:44.318533
4567	31	2026-01-16	2026-01-16 09:36:02.202588	2026-01-16 17:21:01.901444	present	2026-03-02 15:43:44.318533
4568	32	2026-01-16	2026-01-16 09:24:29.926229	2026-01-16 17:53:32.250126	present	2026-03-02 15:43:44.318533
4569	34	2026-01-16	2026-01-16 09:16:55.702475	2026-01-16 17:42:31.647061	present	2026-03-02 15:43:44.318533
4570	36	2026-01-16	2026-01-16 09:22:06.084973	2026-01-16 17:59:34.532941	present	2026-03-02 15:43:44.318533
4571	38	2026-01-16	2026-01-16 09:49:07.022315	2026-01-16 17:04:36.683209	present	2026-03-02 15:43:44.318533
4572	39	2026-01-16	2026-01-16 09:05:30.591994	2026-01-16 17:43:44.09236	present	2026-03-02 15:43:44.318533
4573	40	2026-01-16	2026-01-16 09:00:11.928393	2026-01-16 17:01:06.789375	present	2026-03-02 15:43:44.318533
4574	41	2026-01-16	2026-01-16 09:24:58.268602	2026-01-16 17:10:18.547889	present	2026-03-02 15:43:44.318533
4575	42	2026-01-16	2026-01-16 09:19:51.789285	2026-01-16 17:13:55.436011	present	2026-03-02 15:43:44.318533
4576	44	2026-01-16	2026-01-16 09:43:22.958885	2026-01-16 17:42:27.160975	present	2026-03-02 15:43:44.318533
4577	49	2026-01-16	2026-01-16 09:28:14.509113	2026-01-16 17:41:00.882012	present	2026-03-02 15:43:44.318533
4578	51	2026-01-16	2026-01-16 09:22:19.613217	2026-01-16 17:37:02.446944	present	2026-03-02 15:43:44.318533
4579	53	2026-01-16	2026-01-16 09:18:32.786725	2026-01-16 17:26:45.453453	present	2026-03-02 15:43:44.318533
4580	54	2026-01-16	2026-01-16 09:12:57.425727	2026-01-16 17:12:21.500267	present	2026-03-02 15:43:44.318533
4581	55	2026-01-16	2026-01-16 09:12:47.122384	2026-01-16 17:17:11.018857	present	2026-03-02 15:43:44.318533
4582	56	2026-01-16	2026-01-16 09:49:19.055187	2026-01-16 17:14:52.291252	present	2026-03-02 15:43:44.318533
4583	57	2026-01-16	2026-01-16 09:49:21.773633	2026-01-16 17:23:56.458327	present	2026-03-02 15:43:44.318533
4584	58	2026-01-16	2026-01-16 09:59:40.670448	2026-01-16 17:53:21.613885	present	2026-03-02 15:43:44.318533
4585	61	2026-01-16	2026-01-16 09:37:59.079597	2026-01-16 17:36:55.385082	present	2026-03-02 15:43:44.318533
4586	67	2026-01-16	2026-01-16 09:57:43.126004	2026-01-16 17:18:44.266039	present	2026-03-02 15:43:44.318533
4587	68	2026-01-16	2026-01-16 09:55:45.745206	2026-01-16 17:58:15.080741	present	2026-03-02 15:43:44.318533
4588	69	2026-01-16	2026-01-16 09:00:12.649343	2026-01-16 17:05:20.479665	present	2026-03-02 15:43:44.318533
4589	72	2026-01-16	2026-01-16 09:49:17.247048	2026-01-16 17:19:30.91197	present	2026-03-02 15:43:44.318533
4590	75	2026-01-16	2026-01-16 09:25:25.521476	2026-01-16 17:39:02.886854	present	2026-03-02 15:43:44.318533
4591	76	2026-01-16	2026-01-16 09:05:22.438188	2026-01-16 17:21:24.30891	present	2026-03-02 15:43:44.318533
4592	77	2026-01-16	2026-01-16 09:55:26.277255	2026-01-16 17:02:21.954436	present	2026-03-02 15:43:44.318533
4593	80	2026-01-16	2026-01-16 09:19:34.6227	2026-01-16 17:01:36.991343	present	2026-03-02 15:43:44.318533
4594	81	2026-01-16	2026-01-16 09:43:19.858196	2026-01-16 17:12:13.445394	present	2026-03-02 15:43:44.318533
4595	86	2026-01-16	2026-01-16 09:30:16.05372	2026-01-16 17:40:26.436223	present	2026-03-02 15:43:44.318533
4596	87	2026-01-16	2026-01-16 09:53:54.713499	2026-01-16 17:23:30.329307	present	2026-03-02 15:43:44.318533
4597	90	2026-01-16	2026-01-16 09:35:23.37182	2026-01-16 17:33:12.876652	present	2026-03-02 15:43:44.318533
4598	91	2026-01-16	2026-01-16 09:27:34.106689	2026-01-16 17:31:20.393749	present	2026-03-02 15:43:44.318533
4599	92	2026-01-16	2026-01-16 09:04:25.820931	2026-01-16 17:08:11.078503	present	2026-03-02 15:43:44.318533
4600	93	2026-01-16	2026-01-16 09:05:16.203421	2026-01-16 17:02:56.899167	present	2026-03-02 15:43:44.318533
4601	94	2026-01-16	2026-01-16 09:45:52.842554	2026-01-16 17:22:20.630705	present	2026-03-02 15:43:44.318533
4602	95	2026-01-16	2026-01-16 09:08:46.731657	2026-01-16 17:48:42.259212	present	2026-03-02 15:43:44.318533
4603	98	2026-01-16	2026-01-16 09:53:10.894967	2026-01-16 17:06:38.332721	present	2026-03-02 15:43:44.318533
4604	99	2026-01-16	2026-01-16 09:36:02.326526	2026-01-16 17:14:51.663997	present	2026-03-02 15:43:44.318533
4605	100	2026-01-16	2026-01-16 09:40:08.599506	2026-01-16 17:03:15.916208	present	2026-03-02 15:43:44.318533
4606	3	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4607	4	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4608	5	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4609	6	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4610	10	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4611	11	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4612	27	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4613	33	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4614	35	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4615	37	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4616	43	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4617	45	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4618	46	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4619	47	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4620	48	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4621	50	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4622	52	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4623	59	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4624	60	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4625	62	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4626	63	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4627	64	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4628	65	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4629	66	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4630	70	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4631	71	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4632	73	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4633	74	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4634	78	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4635	79	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4636	82	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4637	83	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4638	84	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4639	85	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4640	88	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4641	89	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4642	96	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4643	97	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4644	1	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4645	2	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4646	7	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4647	8	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4648	9	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4649	12	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4650	13	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4651	14	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4652	15	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4653	16	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4654	17	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4655	18	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4656	19	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4657	20	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4658	21	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4659	22	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4660	23	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4661	24	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4662	25	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4663	26	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4664	28	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4665	29	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4666	30	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4667	31	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4668	32	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4669	34	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4670	36	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4671	38	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4672	39	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4673	40	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4674	41	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4675	42	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4676	44	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4677	49	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4678	51	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4679	53	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4680	54	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4681	55	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4682	56	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4683	57	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4684	58	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4685	61	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4686	67	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4687	68	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4688	69	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4689	72	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4690	75	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4691	76	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4692	77	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4693	80	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4694	81	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4695	86	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4696	87	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4697	90	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4698	91	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4699	92	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4700	93	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4701	94	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4702	95	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4703	98	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4704	99	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4705	100	2026-01-17	\N	\N	absent	2026-03-02 15:43:44.318533
4706	3	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4707	4	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4708	5	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4709	6	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4710	10	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4711	11	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4712	27	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4713	33	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4714	35	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4715	37	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4716	43	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4717	45	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4718	46	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4719	47	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4720	48	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4721	50	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4722	52	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4723	59	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4724	60	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4725	62	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4726	63	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4727	64	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4728	65	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4729	66	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4730	70	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4731	71	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4732	73	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4733	74	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4734	78	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4735	79	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4736	82	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4737	83	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4738	84	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4739	85	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4740	88	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4741	89	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4742	96	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4743	97	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4744	1	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4745	2	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4746	7	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4747	8	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4748	9	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4749	12	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4750	13	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4751	14	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4752	15	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4753	16	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4754	17	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4755	18	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4756	19	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4757	20	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4758	21	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4759	22	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4760	23	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4761	24	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4762	25	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4763	26	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4764	28	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4765	29	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4766	30	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4767	31	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4768	32	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4769	34	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4770	36	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4771	38	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4772	39	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4773	40	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4774	41	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4775	42	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4776	44	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4777	49	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4778	51	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4779	53	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4780	54	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4781	55	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4782	56	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4783	57	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4784	58	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4785	61	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4786	67	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4787	68	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4788	69	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4789	72	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4790	75	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4791	76	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4792	77	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4793	80	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4794	81	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4795	86	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4796	87	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4797	90	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4798	91	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4799	92	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4800	93	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4801	94	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4802	95	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4803	98	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4804	99	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4805	100	2026-01-18	\N	\N	absent	2026-03-02 15:43:44.318533
4806	3	2026-01-19	2026-01-19 09:18:16.162388	2026-01-19 17:02:14.128825	present	2026-03-02 15:43:44.318533
4807	4	2026-01-19	2026-01-19 09:10:33.266813	2026-01-19 17:21:38.41645	present	2026-03-02 15:43:44.318533
4808	5	2026-01-19	2026-01-19 09:47:59.564379	2026-01-19 17:38:33.730184	present	2026-03-02 15:43:44.318533
4809	6	2026-01-19	2026-01-19 09:25:13.773391	2026-01-19 17:52:19.351738	present	2026-03-02 15:43:44.318533
4810	10	2026-01-19	2026-01-19 09:07:41.900961	2026-01-19 17:43:26.272368	present	2026-03-02 15:43:44.318533
4811	11	2026-01-19	2026-01-19 09:03:48.031613	2026-01-19 17:39:10.763351	present	2026-03-02 15:43:44.318533
4812	27	2026-01-19	2026-01-19 09:19:02.92741	2026-01-19 17:12:50.080485	present	2026-03-02 15:43:44.318533
4813	33	2026-01-19	2026-01-19 09:22:28.907653	2026-01-19 17:14:24.307284	present	2026-03-02 15:43:44.318533
4814	35	2026-01-19	2026-01-19 09:57:19.079541	2026-01-19 17:59:50.718464	present	2026-03-02 15:43:44.318533
4815	37	2026-01-19	2026-01-19 09:11:26.846264	2026-01-19 17:09:51.765107	present	2026-03-02 15:43:44.318533
4816	43	2026-01-19	2026-01-19 09:13:29.459041	2026-01-19 17:01:58.995794	present	2026-03-02 15:43:44.318533
4817	45	2026-01-19	2026-01-19 09:38:08.829855	2026-01-19 17:16:51.326122	present	2026-03-02 15:43:44.318533
4818	46	2026-01-19	2026-01-19 09:16:05.020436	2026-01-19 17:43:28.911894	present	2026-03-02 15:43:44.318533
4819	47	2026-01-19	2026-01-19 09:05:36.300008	2026-01-19 17:13:47.372379	present	2026-03-02 15:43:44.318533
4820	48	2026-01-19	2026-01-19 09:10:52.697004	2026-01-19 17:30:39.34755	present	2026-03-02 15:43:44.318533
4821	50	2026-01-19	2026-01-19 09:20:34.048691	2026-01-19 17:04:46.598038	present	2026-03-02 15:43:44.318533
4822	52	2026-01-19	2026-01-19 09:09:32.604235	2026-01-19 17:57:19.109325	present	2026-03-02 15:43:44.318533
4823	59	2026-01-19	2026-01-19 09:26:34.843404	2026-01-19 17:24:26.799153	present	2026-03-02 15:43:44.318533
4824	60	2026-01-19	2026-01-19 09:13:49.873094	2026-01-19 17:07:54.281031	present	2026-03-02 15:43:44.318533
4825	62	2026-01-19	2026-01-19 09:08:07.769514	2026-01-19 17:32:21.213867	present	2026-03-02 15:43:44.318533
4826	63	2026-01-19	2026-01-19 09:50:15.026323	2026-01-19 17:22:31.269268	present	2026-03-02 15:43:44.318533
4827	64	2026-01-19	2026-01-19 09:57:04.921617	2026-01-19 17:35:45.860273	present	2026-03-02 15:43:44.318533
4828	65	2026-01-19	2026-01-19 09:11:15.917218	2026-01-19 17:02:10.708805	present	2026-03-02 15:43:44.318533
4829	66	2026-01-19	2026-01-19 09:02:53.530703	2026-01-19 17:53:01.891893	present	2026-03-02 15:43:44.318533
4830	70	2026-01-19	2026-01-19 09:14:35.723721	2026-01-19 17:02:23.35319	present	2026-03-02 15:43:44.318533
4831	71	2026-01-19	2026-01-19 09:04:34.75749	2026-01-19 17:00:49.944274	present	2026-03-02 15:43:44.318533
4832	73	2026-01-19	2026-01-19 09:28:12.791359	2026-01-19 17:34:04.596533	present	2026-03-02 15:43:44.318533
4833	74	2026-01-19	2026-01-19 09:54:39.330203	2026-01-19 17:15:10.743066	present	2026-03-02 15:43:44.318533
4834	78	2026-01-19	2026-01-19 09:10:26.744765	2026-01-19 17:38:59.882888	present	2026-03-02 15:43:44.318533
4835	79	2026-01-19	2026-01-19 09:14:06.797887	2026-01-19 17:43:18.515962	present	2026-03-02 15:43:44.318533
5062	25	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
4836	82	2026-01-19	2026-01-19 09:02:38.140318	2026-01-19 17:06:54.647754	present	2026-03-02 15:43:44.318533
4837	83	2026-01-19	2026-01-19 09:05:02.02553	2026-01-19 17:54:49.230935	present	2026-03-02 15:43:44.318533
4838	84	2026-01-19	2026-01-19 09:34:21.945208	2026-01-19 17:39:31.90117	present	2026-03-02 15:43:44.318533
4839	85	2026-01-19	2026-01-19 09:56:46.887704	2026-01-19 17:28:20.810505	present	2026-03-02 15:43:44.318533
4840	88	2026-01-19	2026-01-19 09:30:01.531534	2026-01-19 17:03:10.17027	present	2026-03-02 15:43:44.318533
4841	89	2026-01-19	2026-01-19 09:10:04.65829	2026-01-19 17:42:21.616018	present	2026-03-02 15:43:44.318533
4842	96	2026-01-19	2026-01-19 09:57:04.990083	2026-01-19 17:12:34.671595	present	2026-03-02 15:43:44.318533
4843	97	2026-01-19	2026-01-19 09:14:52.126424	2026-01-19 17:06:25.899048	present	2026-03-02 15:43:44.318533
4844	1	2026-01-19	2026-01-19 09:45:20.382255	2026-01-19 17:40:10.775093	present	2026-03-02 15:43:44.318533
4845	2	2026-01-19	2026-01-19 09:29:23.898205	2026-01-19 17:12:31.299317	present	2026-03-02 15:43:44.318533
4846	7	2026-01-19	2026-01-19 09:43:16.673661	2026-01-19 17:44:33.988891	present	2026-03-02 15:43:44.318533
4847	8	2026-01-19	2026-01-19 09:48:15.251704	2026-01-19 17:10:26.605034	present	2026-03-02 15:43:44.318533
4848	9	2026-01-19	2026-01-19 09:05:11.721395	2026-01-19 17:06:25.945495	present	2026-03-02 15:43:44.318533
4849	12	2026-01-19	2026-01-19 09:45:24.044245	2026-01-19 17:55:56.156546	present	2026-03-02 15:43:44.318533
4850	13	2026-01-19	2026-01-19 09:23:51.542043	2026-01-19 17:45:14.102203	present	2026-03-02 15:43:44.318533
4851	14	2026-01-19	2026-01-19 09:39:49.627356	2026-01-19 17:02:44.175853	present	2026-03-02 15:43:44.318533
4852	15	2026-01-19	2026-01-19 09:14:00.354775	2026-01-19 17:05:01.802181	present	2026-03-02 15:43:44.318533
4853	16	2026-01-19	2026-01-19 09:40:03.724427	2026-01-19 17:54:16.871627	present	2026-03-02 15:43:44.318533
4854	17	2026-01-19	2026-01-19 09:50:38.537281	2026-01-19 17:17:17.044409	present	2026-03-02 15:43:44.318533
4855	18	2026-01-19	2026-01-19 09:24:41.873262	2026-01-19 17:36:29.230444	present	2026-03-02 15:43:44.318533
4856	19	2026-01-19	2026-01-19 09:37:15.26116	2026-01-19 17:12:09.312248	present	2026-03-02 15:43:44.318533
4857	20	2026-01-19	2026-01-19 09:05:57.117959	2026-01-19 17:48:09.992649	present	2026-03-02 15:43:44.318533
4858	21	2026-01-19	2026-01-19 09:45:44.721418	2026-01-19 17:33:03.264608	present	2026-03-02 15:43:44.318533
4859	22	2026-01-19	2026-01-19 09:02:07.757994	2026-01-19 17:16:40.317261	present	2026-03-02 15:43:44.318533
4860	23	2026-01-19	2026-01-19 09:29:47.820611	2026-01-19 17:59:03.393303	present	2026-03-02 15:43:44.318533
4861	24	2026-01-19	2026-01-19 09:03:46.434164	2026-01-19 17:02:01.672616	present	2026-03-02 15:43:44.318533
4862	25	2026-01-19	2026-01-19 09:40:51.681384	2026-01-19 17:02:43.693974	present	2026-03-02 15:43:44.318533
4863	26	2026-01-19	2026-01-19 09:58:12.579908	2026-01-19 17:48:14.318147	present	2026-03-02 15:43:44.318533
4864	28	2026-01-19	2026-01-19 09:57:44.36998	2026-01-19 17:24:28.843552	present	2026-03-02 15:43:44.318533
4865	29	2026-01-19	2026-01-19 09:45:38.963912	2026-01-19 17:47:00.190882	present	2026-03-02 15:43:44.318533
4866	30	2026-01-19	2026-01-19 09:41:44.124317	2026-01-19 17:22:37.010435	present	2026-03-02 15:43:44.318533
4867	31	2026-01-19	2026-01-19 09:28:57.393541	2026-01-19 17:26:49.491113	present	2026-03-02 15:43:44.318533
4868	32	2026-01-19	2026-01-19 09:20:30.113553	2026-01-19 17:41:25.149555	present	2026-03-02 15:43:44.318533
4869	34	2026-01-19	2026-01-19 09:37:46.161851	2026-01-19 17:14:40.558376	present	2026-03-02 15:43:44.318533
4870	36	2026-01-19	2026-01-19 09:13:26.117221	2026-01-19 17:00:31.831901	present	2026-03-02 15:43:44.318533
4871	38	2026-01-19	2026-01-19 09:24:11.289667	2026-01-19 17:08:21.771074	present	2026-03-02 15:43:44.318533
4872	39	2026-01-19	2026-01-19 09:14:08.472368	2026-01-19 17:32:16.423271	present	2026-03-02 15:43:44.318533
4873	40	2026-01-19	2026-01-19 09:49:52.591248	2026-01-19 17:24:39.186829	present	2026-03-02 15:43:44.318533
4874	41	2026-01-19	2026-01-19 09:39:44.810846	2026-01-19 17:46:13.599653	present	2026-03-02 15:43:44.318533
4875	42	2026-01-19	2026-01-19 09:29:33.122111	2026-01-19 17:47:52.472919	present	2026-03-02 15:43:44.318533
4876	44	2026-01-19	2026-01-19 09:20:11.46861	2026-01-19 17:42:53.308078	present	2026-03-02 15:43:44.318533
4877	49	2026-01-19	2026-01-19 09:23:02.686586	2026-01-19 17:08:02.817646	present	2026-03-02 15:43:44.318533
4878	51	2026-01-19	2026-01-19 09:08:53.312003	2026-01-19 17:37:40.38473	present	2026-03-02 15:43:44.318533
4879	53	2026-01-19	2026-01-19 09:21:26.225879	2026-01-19 17:10:36.284417	present	2026-03-02 15:43:44.318533
4880	54	2026-01-19	2026-01-19 09:45:31.546021	2026-01-19 17:23:05.880605	present	2026-03-02 15:43:44.318533
4881	55	2026-01-19	2026-01-19 09:22:10.015385	2026-01-19 17:32:05.185212	present	2026-03-02 15:43:44.318533
4882	56	2026-01-19	2026-01-19 09:11:04.2962	2026-01-19 17:51:42.754314	present	2026-03-02 15:43:44.318533
4883	57	2026-01-19	2026-01-19 09:28:48.229568	2026-01-19 17:11:55.440983	present	2026-03-02 15:43:44.318533
4884	58	2026-01-19	2026-01-19 09:02:54.341602	2026-01-19 17:51:22.968903	present	2026-03-02 15:43:44.318533
4885	61	2026-01-19	2026-01-19 09:17:52.298609	2026-01-19 17:49:25.630825	present	2026-03-02 15:43:44.318533
4886	67	2026-01-19	2026-01-19 09:01:45.244927	2026-01-19 17:54:32.043681	present	2026-03-02 15:43:44.318533
4887	68	2026-01-19	2026-01-19 09:53:25.689305	2026-01-19 17:45:10.141854	present	2026-03-02 15:43:44.318533
4888	69	2026-01-19	2026-01-19 09:36:45.063257	2026-01-19 17:32:43.940848	present	2026-03-02 15:43:44.318533
4889	72	2026-01-19	2026-01-19 09:01:01.553827	2026-01-19 17:19:03.075224	present	2026-03-02 15:43:44.318533
4890	75	2026-01-19	2026-01-19 09:31:03.943245	2026-01-19 17:12:52.116627	present	2026-03-02 15:43:44.318533
4891	76	2026-01-19	2026-01-19 09:36:37.923907	2026-01-19 17:34:57.244021	present	2026-03-02 15:43:44.318533
4892	77	2026-01-19	2026-01-19 09:28:59.292659	2026-01-19 17:24:52.703774	present	2026-03-02 15:43:44.318533
4893	80	2026-01-19	2026-01-19 09:17:31.938927	2026-01-19 17:12:36.436633	present	2026-03-02 15:43:44.318533
4894	81	2026-01-19	2026-01-19 09:22:32.779544	2026-01-19 17:27:51.048065	present	2026-03-02 15:43:44.318533
4895	86	2026-01-19	2026-01-19 09:52:59.3006	2026-01-19 17:00:48.38353	present	2026-03-02 15:43:44.318533
4896	87	2026-01-19	2026-01-19 09:03:36.729223	2026-01-19 17:35:45.900497	present	2026-03-02 15:43:44.318533
4897	90	2026-01-19	2026-01-19 09:32:58.149787	2026-01-19 17:08:04.658322	present	2026-03-02 15:43:44.318533
4898	91	2026-01-19	2026-01-19 09:06:28.074956	2026-01-19 17:55:28.265963	present	2026-03-02 15:43:44.318533
4899	92	2026-01-19	2026-01-19 09:24:13.268725	2026-01-19 17:46:34.217915	present	2026-03-02 15:43:44.318533
4900	93	2026-01-19	2026-01-19 09:14:49.332001	2026-01-19 17:49:50.179938	present	2026-03-02 15:43:44.318533
4901	94	2026-01-19	2026-01-19 09:48:21.324417	2026-01-19 17:20:52.574374	present	2026-03-02 15:43:44.318533
4902	95	2026-01-19	2026-01-19 09:55:18.557668	2026-01-19 17:36:08.021212	present	2026-03-02 15:43:44.318533
4903	98	2026-01-19	2026-01-19 09:57:29.768498	2026-01-19 17:46:19.59092	present	2026-03-02 15:43:44.318533
4904	99	2026-01-19	2026-01-19 09:47:00.835103	2026-01-19 17:52:52.851538	present	2026-03-02 15:43:44.318533
4905	100	2026-01-19	2026-01-19 09:00:59.726834	2026-01-19 17:08:52.745592	present	2026-03-02 15:43:44.318533
4906	3	2026-01-20	2026-01-20 09:06:12.122781	2026-01-20 17:09:04.828364	present	2026-03-02 15:43:44.318533
4907	4	2026-01-20	2026-01-20 09:16:50.015441	2026-01-20 17:07:34.219825	present	2026-03-02 15:43:44.318533
4908	5	2026-01-20	2026-01-20 09:11:23.974069	2026-01-20 17:32:14.645801	present	2026-03-02 15:43:44.318533
4909	6	2026-01-20	2026-01-20 09:44:29.59214	2026-01-20 17:04:19.653427	present	2026-03-02 15:43:44.318533
4910	10	2026-01-20	2026-01-20 09:08:05.604452	2026-01-20 17:43:31.955776	present	2026-03-02 15:43:44.318533
4911	11	2026-01-20	2026-01-20 09:03:37.725929	2026-01-20 17:41:01.858956	present	2026-03-02 15:43:44.318533
4912	27	2026-01-20	2026-01-20 09:54:08.761696	2026-01-20 17:01:10.683938	present	2026-03-02 15:43:44.318533
4913	33	2026-01-20	2026-01-20 09:56:13.368008	2026-01-20 17:17:20.793801	present	2026-03-02 15:43:44.318533
4914	35	2026-01-20	2026-01-20 09:23:46.659253	2026-01-20 17:17:55.825403	present	2026-03-02 15:43:44.318533
4915	37	2026-01-20	2026-01-20 09:29:44.429611	2026-01-20 17:07:37.296025	present	2026-03-02 15:43:44.318533
4916	43	2026-01-20	2026-01-20 09:19:11.762494	2026-01-20 17:02:57.225952	present	2026-03-02 15:43:44.318533
4917	45	2026-01-20	2026-01-20 09:57:47.177074	2026-01-20 17:11:02.085292	present	2026-03-02 15:43:44.318533
4918	46	2026-01-20	2026-01-20 09:06:49.691396	2026-01-20 17:15:33.272762	present	2026-03-02 15:43:44.318533
4919	47	2026-01-20	2026-01-20 09:54:20.726949	2026-01-20 17:20:33.313463	present	2026-03-02 15:43:44.318533
4920	48	2026-01-20	2026-01-20 09:04:14.635925	2026-01-20 17:56:18.616695	present	2026-03-02 15:43:44.318533
4921	50	2026-01-20	2026-01-20 09:41:40.307054	2026-01-20 17:32:14.115186	present	2026-03-02 15:43:44.318533
4922	52	2026-01-20	2026-01-20 09:12:21.367964	2026-01-20 17:35:04.597982	present	2026-03-02 15:43:44.318533
4923	59	2026-01-20	2026-01-20 09:50:26.784072	2026-01-20 17:08:45.043618	present	2026-03-02 15:43:44.318533
4924	60	2026-01-20	2026-01-20 09:24:34.553829	2026-01-20 17:24:40.968638	present	2026-03-02 15:43:44.318533
4925	62	2026-01-20	2026-01-20 09:47:39.812287	2026-01-20 17:57:26.457965	present	2026-03-02 15:43:44.318533
4926	63	2026-01-20	2026-01-20 09:10:10.809368	2026-01-20 17:29:49.982297	present	2026-03-02 15:43:44.318533
4927	64	2026-01-20	2026-01-20 09:15:13.883769	2026-01-20 17:00:40.55525	present	2026-03-02 15:43:44.318533
4928	65	2026-01-20	2026-01-20 09:16:14.934039	2026-01-20 17:06:52.975444	present	2026-03-02 15:43:44.318533
4929	66	2026-01-20	2026-01-20 09:46:28.144967	2026-01-20 17:22:58.343249	present	2026-03-02 15:43:44.318533
4930	70	2026-01-20	2026-01-20 09:23:27.864056	2026-01-20 17:04:48.89582	present	2026-03-02 15:43:44.318533
4931	71	2026-01-20	2026-01-20 09:17:21.498784	2026-01-20 17:03:26.443079	present	2026-03-02 15:43:44.318533
4932	73	2026-01-20	2026-01-20 09:02:18.436754	2026-01-20 17:51:07.759345	present	2026-03-02 15:43:44.318533
4933	74	2026-01-20	2026-01-20 09:44:41.516679	2026-01-20 17:23:02.542026	present	2026-03-02 15:43:44.318533
4934	78	2026-01-20	2026-01-20 09:24:09.642158	2026-01-20 17:35:54.604476	present	2026-03-02 15:43:44.318533
4935	79	2026-01-20	2026-01-20 09:27:14.734885	2026-01-20 17:18:34.779371	present	2026-03-02 15:43:44.318533
4936	82	2026-01-20	2026-01-20 09:48:47.791155	2026-01-20 17:15:43.734954	present	2026-03-02 15:43:44.318533
4937	83	2026-01-20	2026-01-20 09:27:10.825138	2026-01-20 17:50:26.771793	present	2026-03-02 15:43:44.318533
4938	84	2026-01-20	2026-01-20 09:26:11.091316	2026-01-20 17:53:32.857887	present	2026-03-02 15:43:44.318533
4939	85	2026-01-20	2026-01-20 09:48:37.545203	2026-01-20 17:44:44.16628	present	2026-03-02 15:43:44.318533
4940	88	2026-01-20	2026-01-20 09:17:17.152187	2026-01-20 17:49:04.545402	present	2026-03-02 15:43:44.318533
4941	89	2026-01-20	2026-01-20 09:29:32.093017	2026-01-20 17:53:20.432138	present	2026-03-02 15:43:44.318533
4942	96	2026-01-20	2026-01-20 09:36:37.648084	2026-01-20 17:20:01.110473	present	2026-03-02 15:43:44.318533
4943	97	2026-01-20	2026-01-20 09:47:13.913627	2026-01-20 17:00:36.483047	present	2026-03-02 15:43:44.318533
4944	1	2026-01-20	2026-01-20 09:18:34.182221	2026-01-20 17:57:02.53602	present	2026-03-02 15:43:44.318533
4945	2	2026-01-20	2026-01-20 09:35:01.755493	2026-01-20 17:21:22.148349	present	2026-03-02 15:43:44.318533
4946	7	2026-01-20	2026-01-20 09:13:06.305682	2026-01-20 17:43:14.731158	present	2026-03-02 15:43:44.318533
4947	8	2026-01-20	2026-01-20 09:39:06.809909	2026-01-20 17:30:09.594413	present	2026-03-02 15:43:44.318533
4948	9	2026-01-20	2026-01-20 09:00:55.004442	2026-01-20 17:18:51.679561	present	2026-03-02 15:43:44.318533
4949	12	2026-01-20	2026-01-20 09:03:45.344368	2026-01-20 17:26:25.906375	present	2026-03-02 15:43:44.318533
4950	13	2026-01-20	2026-01-20 09:44:16.002973	2026-01-20 17:11:54.155565	present	2026-03-02 15:43:44.318533
4951	14	2026-01-20	2026-01-20 09:35:54.838496	2026-01-20 17:30:06.755693	present	2026-03-02 15:43:44.318533
4952	15	2026-01-20	2026-01-20 09:43:26.225212	2026-01-20 17:25:06.465563	present	2026-03-02 15:43:44.318533
4953	16	2026-01-20	2026-01-20 09:32:26.959653	2026-01-20 17:48:13.806021	present	2026-03-02 15:43:44.318533
4954	17	2026-01-20	2026-01-20 09:12:59.561991	2026-01-20 17:24:47.139142	present	2026-03-02 15:43:44.318533
4955	18	2026-01-20	2026-01-20 09:31:19.345863	2026-01-20 17:32:16.925557	present	2026-03-02 15:43:44.318533
4956	19	2026-01-20	2026-01-20 09:58:56.100119	2026-01-20 17:50:41.640217	present	2026-03-02 15:43:44.318533
4957	20	2026-01-20	2026-01-20 09:06:18.843678	2026-01-20 17:41:39.083867	present	2026-03-02 15:43:44.318533
4958	21	2026-01-20	2026-01-20 09:18:57.564359	2026-01-20 17:51:20.005052	present	2026-03-02 15:43:44.318533
4959	22	2026-01-20	2026-01-20 09:40:01.980381	2026-01-20 17:43:40.404546	present	2026-03-02 15:43:44.318533
4960	23	2026-01-20	2026-01-20 09:18:02.891051	2026-01-20 17:57:43.030381	present	2026-03-02 15:43:44.318533
4961	24	2026-01-20	2026-01-20 09:09:40.982841	2026-01-20 17:07:18.766012	present	2026-03-02 15:43:44.318533
4962	25	2026-01-20	2026-01-20 09:07:47.727645	2026-01-20 17:08:24.733927	present	2026-03-02 15:43:44.318533
4963	26	2026-01-20	2026-01-20 09:16:48.944854	2026-01-20 17:35:18.633515	present	2026-03-02 15:43:44.318533
4964	28	2026-01-20	2026-01-20 09:57:38.776369	2026-01-20 17:16:15.370914	present	2026-03-02 15:43:44.318533
4965	29	2026-01-20	2026-01-20 09:22:59.859118	2026-01-20 17:54:49.197372	present	2026-03-02 15:43:44.318533
4966	30	2026-01-20	2026-01-20 09:46:24.052761	2026-01-20 17:52:39.926002	present	2026-03-02 15:43:44.318533
4967	31	2026-01-20	2026-01-20 09:33:09.628539	2026-01-20 17:57:03.693822	present	2026-03-02 15:43:44.318533
4968	32	2026-01-20	2026-01-20 09:24:44.775889	2026-01-20 17:26:08.972193	present	2026-03-02 15:43:44.318533
4969	34	2026-01-20	2026-01-20 09:52:05.8173	2026-01-20 17:19:32.144103	present	2026-03-02 15:43:44.318533
4970	36	2026-01-20	2026-01-20 09:28:44.84557	2026-01-20 17:04:31.080107	present	2026-03-02 15:43:44.318533
4971	38	2026-01-20	2026-01-20 09:23:40.074299	2026-01-20 17:16:39.722064	present	2026-03-02 15:43:44.318533
4972	39	2026-01-20	2026-01-20 09:30:44.407298	2026-01-20 17:35:44.708567	present	2026-03-02 15:43:44.318533
4973	40	2026-01-20	2026-01-20 09:29:59.758011	2026-01-20 17:44:26.441311	present	2026-03-02 15:43:44.318533
4974	41	2026-01-20	2026-01-20 09:14:50.23115	2026-01-20 17:58:31.713996	present	2026-03-02 15:43:44.318533
4975	42	2026-01-20	2026-01-20 09:06:10.090117	2026-01-20 17:08:43.478538	present	2026-03-02 15:43:44.318533
4976	44	2026-01-20	2026-01-20 09:36:30.556443	2026-01-20 17:50:34.256938	present	2026-03-02 15:43:44.318533
4977	49	2026-01-20	2026-01-20 09:10:58.488839	2026-01-20 17:01:42.401973	present	2026-03-02 15:43:44.318533
4978	51	2026-01-20	2026-01-20 09:12:19.783837	2026-01-20 17:57:04.666084	present	2026-03-02 15:43:44.318533
4979	53	2026-01-20	2026-01-20 09:21:52.481834	2026-01-20 17:54:10.134987	present	2026-03-02 15:43:44.318533
4980	54	2026-01-20	2026-01-20 09:42:38.682463	2026-01-20 17:20:56.685416	present	2026-03-02 15:43:44.318533
4981	55	2026-01-20	2026-01-20 09:27:28.319612	2026-01-20 17:37:44.278891	present	2026-03-02 15:43:44.318533
4982	56	2026-01-20	2026-01-20 09:17:21.468054	2026-01-20 17:15:41.371127	present	2026-03-02 15:43:44.318533
4983	57	2026-01-20	2026-01-20 09:55:33.81096	2026-01-20 17:16:10.307548	present	2026-03-02 15:43:44.318533
4984	58	2026-01-20	2026-01-20 09:09:29.519616	2026-01-20 17:01:49.948872	present	2026-03-02 15:43:44.318533
4985	61	2026-01-20	2026-01-20 09:29:41.474637	2026-01-20 17:08:20.881283	present	2026-03-02 15:43:44.318533
4986	67	2026-01-20	2026-01-20 09:45:58.723451	2026-01-20 17:54:40.182313	present	2026-03-02 15:43:44.318533
4987	68	2026-01-20	2026-01-20 09:50:33.368323	2026-01-20 17:53:17.711374	present	2026-03-02 15:43:44.318533
4988	69	2026-01-20	2026-01-20 09:23:57.858806	2026-01-20 17:21:17.565955	present	2026-03-02 15:43:44.318533
4989	72	2026-01-20	2026-01-20 09:49:34.837009	2026-01-20 17:42:29.201477	present	2026-03-02 15:43:44.318533
4990	75	2026-01-20	2026-01-20 09:53:40.351313	2026-01-20 17:19:58.570648	present	2026-03-02 15:43:44.318533
4991	76	2026-01-20	2026-01-20 09:37:34.631496	2026-01-20 17:17:08.221291	present	2026-03-02 15:43:44.318533
4992	77	2026-01-20	2026-01-20 09:01:23.740066	2026-01-20 17:31:22.778626	present	2026-03-02 15:43:44.318533
4993	80	2026-01-20	2026-01-20 09:16:44.990357	2026-01-20 17:33:54.685654	present	2026-03-02 15:43:44.318533
4994	81	2026-01-20	2026-01-20 09:47:09.007377	2026-01-20 17:00:55.265101	present	2026-03-02 15:43:44.318533
4995	86	2026-01-20	2026-01-20 09:50:31.18289	2026-01-20 17:49:01.018508	present	2026-03-02 15:43:44.318533
4996	87	2026-01-20	2026-01-20 09:28:22.506389	2026-01-20 17:09:39.494825	present	2026-03-02 15:43:44.318533
4997	90	2026-01-20	2026-01-20 09:29:16.680391	2026-01-20 17:06:49.929559	present	2026-03-02 15:43:44.318533
4998	91	2026-01-20	2026-01-20 09:20:10.252907	2026-01-20 17:40:17.645426	present	2026-03-02 15:43:44.318533
4999	92	2026-01-20	2026-01-20 09:53:50.966722	2026-01-20 17:05:48.732066	present	2026-03-02 15:43:44.318533
5000	93	2026-01-20	2026-01-20 09:51:50.862835	2026-01-20 17:49:22.49627	present	2026-03-02 15:43:44.318533
5001	94	2026-01-20	2026-01-20 09:13:44.450075	2026-01-20 17:43:23.420302	present	2026-03-02 15:43:44.318533
5002	95	2026-01-20	2026-01-20 09:10:54.816311	2026-01-20 17:40:42.293995	present	2026-03-02 15:43:44.318533
5003	98	2026-01-20	2026-01-20 09:06:45.747029	2026-01-20 17:58:04.380575	present	2026-03-02 15:43:44.318533
5004	99	2026-01-20	2026-01-20 09:25:19.021762	2026-01-20 17:13:56.724669	present	2026-03-02 15:43:44.318533
5005	100	2026-01-20	2026-01-20 09:35:27.020901	2026-01-20 17:04:29.969649	present	2026-03-02 15:43:44.318533
5006	3	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5007	4	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5008	5	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5009	6	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5010	10	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5011	11	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5012	27	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5013	33	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5014	35	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5015	37	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5016	43	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5017	45	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5018	46	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5019	47	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5020	48	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5021	50	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5022	52	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5023	59	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5024	60	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5025	62	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5026	63	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5027	64	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5028	65	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5029	66	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5030	70	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5031	71	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5032	73	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5033	74	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5034	78	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5035	79	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5036	82	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5037	83	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5038	84	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5039	85	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5040	88	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5041	89	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5042	96	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5043	97	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5044	1	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5045	2	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5046	7	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5047	8	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5048	9	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5049	12	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5050	13	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5051	14	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5052	15	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5053	16	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5054	17	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5055	18	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5056	19	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5057	20	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5058	21	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5059	22	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5060	23	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5061	24	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5063	26	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5064	28	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5065	29	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5066	30	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5067	31	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5068	32	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5069	34	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5070	36	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5071	38	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5072	39	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5073	40	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5074	41	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5075	42	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5076	44	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5077	49	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5078	51	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5079	53	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5080	54	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5081	55	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5082	56	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5083	57	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5084	58	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5085	61	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5086	67	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5087	68	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5088	69	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5089	72	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5090	75	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5091	76	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5092	77	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5093	80	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5094	81	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5095	86	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5096	87	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5097	90	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5098	91	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5099	92	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5100	93	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5101	94	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5102	95	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5103	98	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5104	99	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5105	100	2026-01-21	\N	\N	absent	2026-03-02 15:43:44.318533
5106	3	2026-01-22	2026-01-22 09:33:52.042419	2026-01-22 17:59:04.513919	present	2026-03-02 15:43:44.318533
5107	4	2026-01-22	2026-01-22 09:51:10.095518	2026-01-22 17:50:12.745953	present	2026-03-02 15:43:44.318533
5108	5	2026-01-22	2026-01-22 09:28:08.062066	2026-01-22 17:00:03.200696	present	2026-03-02 15:43:44.318533
5109	6	2026-01-22	2026-01-22 09:27:02.540934	2026-01-22 17:26:53.757281	present	2026-03-02 15:43:44.318533
5110	10	2026-01-22	2026-01-22 09:15:58.075608	2026-01-22 17:55:25.273801	present	2026-03-02 15:43:44.318533
5111	11	2026-01-22	2026-01-22 09:05:41.328685	2026-01-22 17:54:17.668269	present	2026-03-02 15:43:44.318533
5112	27	2026-01-22	2026-01-22 09:25:12.02046	2026-01-22 17:27:59.268931	present	2026-03-02 15:43:44.318533
5113	33	2026-01-22	2026-01-22 09:15:10.37237	2026-01-22 17:27:30.664822	present	2026-03-02 15:43:44.318533
5114	35	2026-01-22	2026-01-22 09:07:39.619827	2026-01-22 17:59:19.026478	present	2026-03-02 15:43:44.318533
5115	37	2026-01-22	2026-01-22 09:25:41.113907	2026-01-22 17:52:21.054411	present	2026-03-02 15:43:44.318533
5116	43	2026-01-22	2026-01-22 09:23:31.534867	2026-01-22 17:09:45.374079	present	2026-03-02 15:43:44.318533
5117	45	2026-01-22	2026-01-22 09:44:20.508504	2026-01-22 17:40:43.820961	present	2026-03-02 15:43:44.318533
5118	46	2026-01-22	2026-01-22 09:36:21.282967	2026-01-22 17:48:26.319717	present	2026-03-02 15:43:44.318533
5119	47	2026-01-22	2026-01-22 09:35:00.152311	2026-01-22 17:51:37.969907	present	2026-03-02 15:43:44.318533
5120	48	2026-01-22	2026-01-22 09:15:34.774177	2026-01-22 17:34:17.128476	present	2026-03-02 15:43:44.318533
5121	50	2026-01-22	2026-01-22 09:50:52.805236	2026-01-22 17:57:18.363494	present	2026-03-02 15:43:44.318533
5122	52	2026-01-22	2026-01-22 09:10:35.593562	2026-01-22 17:39:10.047184	present	2026-03-02 15:43:44.318533
5123	59	2026-01-22	2026-01-22 09:28:05.896621	2026-01-22 17:16:09.805518	present	2026-03-02 15:43:44.318533
5124	60	2026-01-22	2026-01-22 09:14:42.748711	2026-01-22 17:02:30.387953	present	2026-03-02 15:43:44.318533
5125	62	2026-01-22	2026-01-22 09:13:36.022267	2026-01-22 17:26:25.666172	present	2026-03-02 15:43:44.318533
5126	63	2026-01-22	2026-01-22 09:41:56.496908	2026-01-22 17:22:51.364645	present	2026-03-02 15:43:44.318533
5127	64	2026-01-22	2026-01-22 09:43:01.121874	2026-01-22 17:01:46.7292	present	2026-03-02 15:43:44.318533
5128	65	2026-01-22	2026-01-22 09:26:27.892921	2026-01-22 17:31:31.438956	present	2026-03-02 15:43:44.318533
5129	66	2026-01-22	2026-01-22 09:38:53.393528	2026-01-22 17:40:16.257642	present	2026-03-02 15:43:44.318533
5130	70	2026-01-22	2026-01-22 09:32:33.472196	2026-01-22 17:19:14.93432	present	2026-03-02 15:43:44.318533
5131	71	2026-01-22	2026-01-22 09:04:18.75187	2026-01-22 17:30:38.435155	present	2026-03-02 15:43:44.318533
5132	73	2026-01-22	2026-01-22 09:06:25.395758	2026-01-22 17:38:12.742967	present	2026-03-02 15:43:44.318533
5133	74	2026-01-22	2026-01-22 09:53:08.501067	2026-01-22 17:33:53.289717	present	2026-03-02 15:43:44.318533
5134	78	2026-01-22	2026-01-22 09:49:55.890147	2026-01-22 17:18:47.24469	present	2026-03-02 15:43:44.318533
5135	79	2026-01-22	2026-01-22 09:59:42.443637	2026-01-22 17:25:10.903103	present	2026-03-02 15:43:44.318533
5136	82	2026-01-22	2026-01-22 09:50:02.242675	2026-01-22 17:24:22.252807	present	2026-03-02 15:43:44.318533
5137	83	2026-01-22	2026-01-22 09:01:55.143516	2026-01-22 17:26:56.529116	present	2026-03-02 15:43:44.318533
5138	84	2026-01-22	2026-01-22 09:55:04.357924	2026-01-22 17:06:51.16012	present	2026-03-02 15:43:44.318533
5139	85	2026-01-22	2026-01-22 09:31:40.338063	2026-01-22 17:53:00.995771	present	2026-03-02 15:43:44.318533
5140	88	2026-01-22	2026-01-22 09:13:48.090922	2026-01-22 17:06:58.816966	present	2026-03-02 15:43:44.318533
5141	89	2026-01-22	2026-01-22 09:43:47.582719	2026-01-22 17:10:29.111997	present	2026-03-02 15:43:44.318533
5142	96	2026-01-22	2026-01-22 09:46:14.112684	2026-01-22 17:20:21.612613	present	2026-03-02 15:43:44.318533
5143	97	2026-01-22	2026-01-22 09:17:50.179666	2026-01-22 17:33:41.732601	present	2026-03-02 15:43:44.318533
5144	1	2026-01-22	2026-01-22 09:02:25.081626	2026-01-22 17:05:34.487878	present	2026-03-02 15:43:44.318533
5145	2	2026-01-22	2026-01-22 09:20:28.358621	2026-01-22 17:52:29.226313	present	2026-03-02 15:43:44.318533
5146	7	2026-01-22	2026-01-22 09:53:00.34023	2026-01-22 17:09:48.907025	present	2026-03-02 15:43:44.318533
5147	8	2026-01-22	2026-01-22 09:43:18.741406	2026-01-22 17:16:56.27273	present	2026-03-02 15:43:44.318533
5148	9	2026-01-22	2026-01-22 09:56:04.152443	2026-01-22 17:32:40.700908	present	2026-03-02 15:43:44.318533
5149	12	2026-01-22	2026-01-22 09:55:41.653013	2026-01-22 17:15:54.439224	present	2026-03-02 15:43:44.318533
5150	13	2026-01-22	2026-01-22 09:24:31.054514	2026-01-22 17:07:59.093763	present	2026-03-02 15:43:44.318533
5151	14	2026-01-22	2026-01-22 09:31:13.700596	2026-01-22 17:10:50.528044	present	2026-03-02 15:43:44.318533
5152	15	2026-01-22	2026-01-22 09:43:37.081709	2026-01-22 17:34:32.833555	present	2026-03-02 15:43:44.318533
5153	16	2026-01-22	2026-01-22 09:21:42.086001	2026-01-22 17:25:58.879327	present	2026-03-02 15:43:44.318533
5154	17	2026-01-22	2026-01-22 09:45:57.416196	2026-01-22 17:12:49.121478	present	2026-03-02 15:43:44.318533
5155	18	2026-01-22	2026-01-22 09:11:56.188324	2026-01-22 17:34:29.158419	present	2026-03-02 15:43:44.318533
5156	19	2026-01-22	2026-01-22 09:21:47.806393	2026-01-22 17:56:05.526565	present	2026-03-02 15:43:44.318533
5157	20	2026-01-22	2026-01-22 09:00:46.62936	2026-01-22 17:06:05.452113	present	2026-03-02 15:43:44.318533
5158	21	2026-01-22	2026-01-22 09:18:15.419462	2026-01-22 17:11:40.797888	present	2026-03-02 15:43:44.318533
5159	22	2026-01-22	2026-01-22 09:31:15.388239	2026-01-22 17:22:47.261089	present	2026-03-02 15:43:44.318533
5160	23	2026-01-22	2026-01-22 09:22:22.310298	2026-01-22 17:37:47.376573	present	2026-03-02 15:43:44.318533
5161	24	2026-01-22	2026-01-22 09:45:53.258204	2026-01-22 17:49:57.361239	present	2026-03-02 15:43:44.318533
5162	25	2026-01-22	2026-01-22 09:59:14.313793	2026-01-22 17:20:34.788824	present	2026-03-02 15:43:44.318533
5163	26	2026-01-22	2026-01-22 09:10:56.392192	2026-01-22 17:47:23.776383	present	2026-03-02 15:43:44.318533
5164	28	2026-01-22	2026-01-22 09:57:17.735972	2026-01-22 17:34:09.642732	present	2026-03-02 15:43:44.318533
5165	29	2026-01-22	2026-01-22 09:04:44.750929	2026-01-22 17:38:33.611271	present	2026-03-02 15:43:44.318533
5166	30	2026-01-22	2026-01-22 09:59:28.470842	2026-01-22 17:32:12.419152	present	2026-03-02 15:43:44.318533
5167	31	2026-01-22	2026-01-22 09:29:05.95658	2026-01-22 17:10:07.13379	present	2026-03-02 15:43:44.318533
5168	32	2026-01-22	2026-01-22 09:20:37.888396	2026-01-22 17:05:48.624726	present	2026-03-02 15:43:44.318533
5169	34	2026-01-22	2026-01-22 09:52:48.226743	2026-01-22 17:43:07.939816	present	2026-03-02 15:43:44.318533
5170	36	2026-01-22	2026-01-22 09:49:23.096252	2026-01-22 17:06:53.140166	present	2026-03-02 15:43:44.318533
5171	38	2026-01-22	2026-01-22 09:53:03.864613	2026-01-22 17:49:15.090678	present	2026-03-02 15:43:44.318533
5172	39	2026-01-22	2026-01-22 09:01:48.785785	2026-01-22 17:19:15.976412	present	2026-03-02 15:43:44.318533
5173	40	2026-01-22	2026-01-22 09:45:13.053907	2026-01-22 17:14:14.380177	present	2026-03-02 15:43:44.318533
5174	41	2026-01-22	2026-01-22 09:29:57.805282	2026-01-22 17:56:59.17652	present	2026-03-02 15:43:44.318533
5175	42	2026-01-22	2026-01-22 09:16:09.741106	2026-01-22 17:29:30.435441	present	2026-03-02 15:43:44.318533
5176	44	2026-01-22	2026-01-22 09:36:23.271648	2026-01-22 17:07:29.67648	present	2026-03-02 15:43:44.318533
5177	49	2026-01-22	2026-01-22 09:10:35.308912	2026-01-22 17:38:11.09597	present	2026-03-02 15:43:44.318533
5178	51	2026-01-22	2026-01-22 09:04:17.839622	2026-01-22 17:02:09.010051	present	2026-03-02 15:43:44.318533
5179	53	2026-01-22	2026-01-22 09:20:54.815598	2026-01-22 17:30:25.615431	present	2026-03-02 15:43:44.318533
5180	54	2026-01-22	2026-01-22 09:27:08.303732	2026-01-22 17:25:45.805863	present	2026-03-02 15:43:44.318533
5181	55	2026-01-22	2026-01-22 09:27:43.554074	2026-01-22 17:55:52.795638	present	2026-03-02 15:43:44.318533
5182	56	2026-01-22	2026-01-22 09:18:18.189474	2026-01-22 17:23:10.280132	present	2026-03-02 15:43:44.318533
5183	57	2026-01-22	2026-01-22 09:02:02.811006	2026-01-22 17:38:20.343052	present	2026-03-02 15:43:44.318533
5184	58	2026-01-22	2026-01-22 09:13:16.218998	2026-01-22 17:08:34.973613	present	2026-03-02 15:43:44.318533
5185	61	2026-01-22	2026-01-22 09:45:54.62775	2026-01-22 17:08:38.001369	present	2026-03-02 15:43:44.318533
5186	67	2026-01-22	2026-01-22 09:37:24.087426	2026-01-22 17:29:16.924436	present	2026-03-02 15:43:44.318533
5187	68	2026-01-22	2026-01-22 09:42:36.460773	2026-01-22 17:19:17.410878	present	2026-03-02 15:43:44.318533
5188	69	2026-01-22	2026-01-22 09:08:14.735889	2026-01-22 17:54:26.016569	present	2026-03-02 15:43:44.318533
5189	72	2026-01-22	2026-01-22 09:48:38.602048	2026-01-22 17:49:48.346598	present	2026-03-02 15:43:44.318533
5190	75	2026-01-22	2026-01-22 09:14:38.408312	2026-01-22 17:31:08.593143	present	2026-03-02 15:43:44.318533
5191	76	2026-01-22	2026-01-22 09:55:15.378852	2026-01-22 17:05:55.829693	present	2026-03-02 15:43:44.318533
5192	77	2026-01-22	2026-01-22 09:55:53.59151	2026-01-22 17:29:57.667301	present	2026-03-02 15:43:44.318533
5193	80	2026-01-22	2026-01-22 09:14:30.841413	2026-01-22 17:42:29.202569	present	2026-03-02 15:43:44.318533
5194	81	2026-01-22	2026-01-22 09:10:32.210723	2026-01-22 17:16:00.780322	present	2026-03-02 15:43:44.318533
5195	86	2026-01-22	2026-01-22 09:50:56.035222	2026-01-22 17:28:40.016061	present	2026-03-02 15:43:44.318533
5196	87	2026-01-22	2026-01-22 09:30:32.02311	2026-01-22 17:32:06.977609	present	2026-03-02 15:43:44.318533
5197	90	2026-01-22	2026-01-22 09:01:07.014291	2026-01-22 17:19:23.834493	present	2026-03-02 15:43:44.318533
5198	91	2026-01-22	2026-01-22 09:01:15.446838	2026-01-22 17:52:21.487024	present	2026-03-02 15:43:44.318533
5199	92	2026-01-22	2026-01-22 09:33:31.358801	2026-01-22 17:32:42.184551	present	2026-03-02 15:43:44.318533
5200	93	2026-01-22	2026-01-22 09:32:13.868791	2026-01-22 17:57:32.865968	present	2026-03-02 15:43:44.318533
5201	94	2026-01-22	2026-01-22 09:47:25.486509	2026-01-22 17:46:35.116129	present	2026-03-02 15:43:44.318533
5202	95	2026-01-22	2026-01-22 09:56:03.857976	2026-01-22 17:00:09.402278	present	2026-03-02 15:43:44.318533
5203	98	2026-01-22	2026-01-22 09:36:04.405919	2026-01-22 17:34:37.26576	present	2026-03-02 15:43:44.318533
5204	99	2026-01-22	2026-01-22 09:57:53.403352	2026-01-22 17:32:54.138022	present	2026-03-02 15:43:44.318533
5205	100	2026-01-22	2026-01-22 09:24:31.157117	2026-01-22 17:06:39.373569	present	2026-03-02 15:43:44.318533
5206	3	2026-01-23	2026-01-23 09:58:29.393777	2026-01-23 17:26:45.169205	present	2026-03-02 15:43:44.318533
5207	4	2026-01-23	2026-01-23 09:58:28.126717	2026-01-23 17:52:56.775895	present	2026-03-02 15:43:44.318533
5208	5	2026-01-23	2026-01-23 09:02:27.570013	2026-01-23 17:09:53.068291	present	2026-03-02 15:43:44.318533
5209	6	2026-01-23	2026-01-23 09:44:59.875456	2026-01-23 17:02:49.537507	present	2026-03-02 15:43:44.318533
5210	10	2026-01-23	2026-01-23 09:02:20.463671	2026-01-23 17:25:24.727593	present	2026-03-02 15:43:44.318533
5211	11	2026-01-23	2026-01-23 09:22:48.422801	2026-01-23 17:02:20.147862	present	2026-03-02 15:43:44.318533
5212	27	2026-01-23	2026-01-23 09:15:18.574284	2026-01-23 17:04:27.875377	present	2026-03-02 15:43:44.318533
5213	33	2026-01-23	2026-01-23 09:26:21.174867	2026-01-23 17:37:02.110644	present	2026-03-02 15:43:44.318533
5214	35	2026-01-23	2026-01-23 09:12:06.817618	2026-01-23 17:40:15.859678	present	2026-03-02 15:43:44.318533
5215	37	2026-01-23	2026-01-23 09:04:12.959582	2026-01-23 17:56:22.208407	present	2026-03-02 15:43:44.318533
5216	43	2026-01-23	2026-01-23 09:40:15.544905	2026-01-23 17:00:01.458183	present	2026-03-02 15:43:44.318533
5217	45	2026-01-23	2026-01-23 09:26:25.55971	2026-01-23 17:23:10.841091	present	2026-03-02 15:43:44.318533
5218	46	2026-01-23	2026-01-23 09:16:22.218309	2026-01-23 17:38:08.139559	present	2026-03-02 15:43:44.318533
5219	47	2026-01-23	2026-01-23 09:59:33.548315	2026-01-23 17:58:59.726819	present	2026-03-02 15:43:44.318533
5220	48	2026-01-23	2026-01-23 09:24:47.195814	2026-01-23 17:39:44.563539	present	2026-03-02 15:43:44.318533
5221	50	2026-01-23	2026-01-23 09:33:59.242392	2026-01-23 17:09:12.174604	present	2026-03-02 15:43:44.318533
5222	52	2026-01-23	2026-01-23 09:07:52.861552	2026-01-23 17:12:38.514536	present	2026-03-02 15:43:44.318533
5223	59	2026-01-23	2026-01-23 09:23:13.241707	2026-01-23 17:34:51.219872	present	2026-03-02 15:43:44.318533
5224	60	2026-01-23	2026-01-23 09:25:52.575579	2026-01-23 17:39:55.230787	present	2026-03-02 15:43:44.318533
5225	62	2026-01-23	2026-01-23 09:01:28.859275	2026-01-23 17:15:01.277444	present	2026-03-02 15:43:44.318533
5226	63	2026-01-23	2026-01-23 09:03:09.471807	2026-01-23 17:31:34.300748	present	2026-03-02 15:43:44.318533
5227	64	2026-01-23	2026-01-23 09:02:57.381977	2026-01-23 17:53:30.6529	present	2026-03-02 15:43:44.318533
5228	65	2026-01-23	2026-01-23 09:43:40.800522	2026-01-23 17:27:55.967507	present	2026-03-02 15:43:44.318533
5229	66	2026-01-23	2026-01-23 09:27:56.535718	2026-01-23 17:01:09.579935	present	2026-03-02 15:43:44.318533
5230	70	2026-01-23	2026-01-23 09:22:49.821665	2026-01-23 17:03:25.160365	present	2026-03-02 15:43:44.318533
5231	71	2026-01-23	2026-01-23 09:14:45.427085	2026-01-23 17:43:05.621522	present	2026-03-02 15:43:44.318533
5232	73	2026-01-23	2026-01-23 09:10:33.382339	2026-01-23 17:16:15.422143	present	2026-03-02 15:43:44.318533
5233	74	2026-01-23	2026-01-23 09:42:50.51848	2026-01-23 17:33:11.5254	present	2026-03-02 15:43:44.318533
5234	78	2026-01-23	2026-01-23 09:54:31.56645	2026-01-23 17:41:16.120322	present	2026-03-02 15:43:44.318533
5235	79	2026-01-23	2026-01-23 09:17:23.977089	2026-01-23 17:02:29.907935	present	2026-03-02 15:43:44.318533
5236	82	2026-01-23	2026-01-23 09:01:38.028953	2026-01-23 17:11:51.177873	present	2026-03-02 15:43:44.318533
5237	83	2026-01-23	2026-01-23 09:21:17.000037	2026-01-23 17:58:00.097664	present	2026-03-02 15:43:44.318533
5238	84	2026-01-23	2026-01-23 09:21:05.114816	2026-01-23 17:28:11.055133	present	2026-03-02 15:43:44.318533
5239	85	2026-01-23	2026-01-23 09:50:12.67935	2026-01-23 17:43:25.557084	present	2026-03-02 15:43:44.318533
5240	88	2026-01-23	2026-01-23 09:47:31.338984	2026-01-23 17:33:47.513926	present	2026-03-02 15:43:44.318533
5241	89	2026-01-23	2026-01-23 09:45:41.759912	2026-01-23 17:32:08.677228	present	2026-03-02 15:43:44.318533
5242	96	2026-01-23	2026-01-23 09:23:42.077246	2026-01-23 17:16:50.213923	present	2026-03-02 15:43:44.318533
5243	97	2026-01-23	2026-01-23 09:01:05.976115	2026-01-23 17:07:51.922651	present	2026-03-02 15:43:44.318533
5244	1	2026-01-23	2026-01-23 09:44:15.580152	2026-01-23 17:58:44.852268	present	2026-03-02 15:43:44.318533
5245	2	2026-01-23	2026-01-23 09:47:11.068009	2026-01-23 17:28:06.447093	present	2026-03-02 15:43:44.318533
5246	7	2026-01-23	2026-01-23 09:35:16.15294	2026-01-23 17:01:26.62125	present	2026-03-02 15:43:44.318533
5247	8	2026-01-23	2026-01-23 09:29:18.97999	2026-01-23 17:01:07.659899	present	2026-03-02 15:43:44.318533
5248	9	2026-01-23	2026-01-23 09:50:33.727457	2026-01-23 17:22:33.75755	present	2026-03-02 15:43:44.318533
5249	12	2026-01-23	2026-01-23 09:13:15.618391	2026-01-23 17:41:07.085732	present	2026-03-02 15:43:44.318533
5250	13	2026-01-23	2026-01-23 09:08:31.540553	2026-01-23 17:45:26.700368	present	2026-03-02 15:43:44.318533
5251	14	2026-01-23	2026-01-23 09:15:09.326335	2026-01-23 17:25:18.909731	present	2026-03-02 15:43:44.318533
5252	15	2026-01-23	2026-01-23 09:30:20.215077	2026-01-23 17:11:20.462459	present	2026-03-02 15:43:44.318533
5253	16	2026-01-23	2026-01-23 09:51:03.778975	2026-01-23 17:48:37.374444	present	2026-03-02 15:43:44.318533
5254	17	2026-01-23	2026-01-23 09:36:08.807276	2026-01-23 17:53:29.263967	present	2026-03-02 15:43:44.318533
5255	18	2026-01-23	2026-01-23 09:46:04.334646	2026-01-23 17:46:43.641712	present	2026-03-02 15:43:44.318533
5256	19	2026-01-23	2026-01-23 09:39:09.910332	2026-01-23 17:21:24.542798	present	2026-03-02 15:43:44.318533
5257	20	2026-01-23	2026-01-23 09:34:05.482085	2026-01-23 17:13:39.701118	present	2026-03-02 15:43:44.318533
5258	21	2026-01-23	2026-01-23 09:36:44.11501	2026-01-23 17:35:38.11952	present	2026-03-02 15:43:44.318533
5259	22	2026-01-23	2026-01-23 09:52:40.334172	2026-01-23 17:51:21.049104	present	2026-03-02 15:43:44.318533
5260	23	2026-01-23	2026-01-23 09:51:13.178129	2026-01-23 17:26:17.015032	present	2026-03-02 15:43:44.318533
5261	24	2026-01-23	2026-01-23 09:54:41.323406	2026-01-23 17:34:14.146992	present	2026-03-02 15:43:44.318533
5262	25	2026-01-23	2026-01-23 09:23:55.358908	2026-01-23 17:15:29.394084	present	2026-03-02 15:43:44.318533
5263	26	2026-01-23	2026-01-23 09:59:26.671877	2026-01-23 17:53:06.674067	present	2026-03-02 15:43:44.318533
5264	28	2026-01-23	2026-01-23 09:22:23.659307	2026-01-23 17:53:52.136336	present	2026-03-02 15:43:44.318533
5265	29	2026-01-23	2026-01-23 09:33:02.924591	2026-01-23 17:13:45.558255	present	2026-03-02 15:43:44.318533
5266	30	2026-01-23	2026-01-23 09:23:53.703996	2026-01-23 17:42:32.099099	present	2026-03-02 15:43:44.318533
5267	31	2026-01-23	2026-01-23 09:15:14.109416	2026-01-23 17:58:55.535773	present	2026-03-02 15:43:44.318533
5268	32	2026-01-23	2026-01-23 09:26:48.585921	2026-01-23 17:33:23.71926	present	2026-03-02 15:43:44.318533
5269	34	2026-01-23	2026-01-23 09:54:02.231417	2026-01-23 17:28:26.824102	present	2026-03-02 15:43:44.318533
5270	36	2026-01-23	2026-01-23 09:01:35.835082	2026-01-23 17:54:38.207739	present	2026-03-02 15:43:44.318533
5271	38	2026-01-23	2026-01-23 09:23:41.59793	2026-01-23 17:54:37.441843	present	2026-03-02 15:43:44.318533
5272	39	2026-01-23	2026-01-23 09:43:15.020068	2026-01-23 17:50:56.449555	present	2026-03-02 15:43:44.318533
5273	40	2026-01-23	2026-01-23 09:21:37.434366	2026-01-23 17:34:38.454198	present	2026-03-02 15:43:44.318533
5274	41	2026-01-23	2026-01-23 09:02:41.587585	2026-01-23 17:32:01.676364	present	2026-03-02 15:43:44.318533
5275	42	2026-01-23	2026-01-23 09:33:33.729912	2026-01-23 17:56:13.435978	present	2026-03-02 15:43:44.318533
5276	44	2026-01-23	2026-01-23 09:40:54.884826	2026-01-23 17:07:51.561211	present	2026-03-02 15:43:44.318533
5277	49	2026-01-23	2026-01-23 09:06:48.843629	2026-01-23 17:49:03.321956	present	2026-03-02 15:43:44.318533
5278	51	2026-01-23	2026-01-23 09:16:47.036246	2026-01-23 17:49:09.207449	present	2026-03-02 15:43:44.318533
5279	53	2026-01-23	2026-01-23 09:11:14.896532	2026-01-23 17:36:44.514523	present	2026-03-02 15:43:44.318533
5280	54	2026-01-23	2026-01-23 09:20:12.799153	2026-01-23 17:46:06.704689	present	2026-03-02 15:43:44.318533
5281	55	2026-01-23	2026-01-23 09:46:20.437147	2026-01-23 17:05:02.802034	present	2026-03-02 15:43:44.318533
5282	56	2026-01-23	2026-01-23 09:29:52.707524	2026-01-23 17:03:27.558823	present	2026-03-02 15:43:44.318533
5283	57	2026-01-23	2026-01-23 09:54:37.176862	2026-01-23 17:47:03.346564	present	2026-03-02 15:43:44.318533
5284	58	2026-01-23	2026-01-23 09:04:40.726352	2026-01-23 17:22:45.327867	present	2026-03-02 15:43:44.318533
5285	61	2026-01-23	2026-01-23 09:30:46.327385	2026-01-23 17:23:16.31523	present	2026-03-02 15:43:44.318533
5286	67	2026-01-23	2026-01-23 09:38:57.033279	2026-01-23 17:41:34.634483	present	2026-03-02 15:43:44.318533
5287	68	2026-01-23	2026-01-23 09:33:11.743029	2026-01-23 17:14:19.601283	present	2026-03-02 15:43:44.318533
5288	69	2026-01-23	2026-01-23 09:05:52.111836	2026-01-23 17:50:21.018649	present	2026-03-02 15:43:44.318533
5289	72	2026-01-23	2026-01-23 09:22:22.708653	2026-01-23 17:03:30.477614	present	2026-03-02 15:43:44.318533
5290	75	2026-01-23	2026-01-23 09:51:07.29602	2026-01-23 17:09:56.00515	present	2026-03-02 15:43:44.318533
5291	76	2026-01-23	2026-01-23 09:07:29.756791	2026-01-23 17:01:05.249499	present	2026-03-02 15:43:44.318533
5292	77	2026-01-23	2026-01-23 09:43:18.58387	2026-01-23 17:09:56.797172	present	2026-03-02 15:43:44.318533
5293	80	2026-01-23	2026-01-23 09:07:14.212587	2026-01-23 17:20:04.535118	present	2026-03-02 15:43:44.318533
5294	81	2026-01-23	2026-01-23 09:08:58.215017	2026-01-23 17:13:48.329408	present	2026-03-02 15:43:44.318533
5295	86	2026-01-23	2026-01-23 09:38:42.128127	2026-01-23 17:16:34.356511	present	2026-03-02 15:43:44.318533
5296	87	2026-01-23	2026-01-23 09:15:26.758942	2026-01-23 17:47:37.783264	present	2026-03-02 15:43:44.318533
5297	90	2026-01-23	2026-01-23 09:49:21.763889	2026-01-23 17:15:31.093889	present	2026-03-02 15:43:44.318533
5298	91	2026-01-23	2026-01-23 09:27:57.462515	2026-01-23 17:17:28.814934	present	2026-03-02 15:43:44.318533
5299	92	2026-01-23	2026-01-23 09:30:22.73161	2026-01-23 17:15:52.982422	present	2026-03-02 15:43:44.318533
5300	93	2026-01-23	2026-01-23 09:43:20.806081	2026-01-23 17:16:39.92753	present	2026-03-02 15:43:44.318533
5301	94	2026-01-23	2026-01-23 09:21:16.883993	2026-01-23 17:03:58.018126	present	2026-03-02 15:43:44.318533
5302	95	2026-01-23	2026-01-23 09:00:10.967342	2026-01-23 17:25:41.822477	present	2026-03-02 15:43:44.318533
5303	98	2026-01-23	2026-01-23 09:35:35.789038	2026-01-23 17:35:19.462542	present	2026-03-02 15:43:44.318533
5304	99	2026-01-23	2026-01-23 09:45:38.873679	2026-01-23 17:52:18.542274	present	2026-03-02 15:43:44.318533
5305	100	2026-01-23	2026-01-23 09:29:02.06958	2026-01-23 17:21:20.537412	present	2026-03-02 15:43:44.318533
5306	3	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5307	4	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5308	5	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5309	6	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5310	10	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5311	11	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5312	27	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5313	33	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5314	35	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5315	37	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5316	43	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5317	45	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5318	46	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5319	47	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5320	48	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5321	50	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5322	52	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5323	59	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5324	60	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5325	62	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5326	63	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5327	64	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5328	65	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5329	66	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5330	70	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5331	71	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5332	73	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5333	74	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5334	78	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5335	79	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5336	82	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5337	83	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5338	84	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5339	85	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5340	88	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5341	89	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5342	96	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5343	97	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5344	1	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5345	2	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5346	7	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5347	8	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5348	9	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5349	12	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5350	13	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5351	14	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5352	15	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5353	16	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5354	17	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5355	18	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5356	19	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5357	20	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5358	21	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5359	22	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5360	23	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5361	24	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5362	25	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5363	26	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5364	28	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5365	29	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5366	30	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5367	31	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5368	32	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5369	34	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5370	36	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5371	38	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5372	39	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5373	40	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5374	41	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5375	42	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5376	44	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5377	49	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5378	51	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5379	53	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5380	54	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5381	55	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5382	56	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5383	57	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5384	58	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5385	61	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5386	67	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5387	68	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5388	69	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5389	72	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5390	75	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5391	76	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5392	77	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5393	80	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5394	81	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5395	86	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5396	87	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5397	90	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5398	91	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5399	92	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5400	93	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5401	94	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5402	95	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5403	98	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5404	99	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5405	100	2026-01-24	\N	\N	absent	2026-03-02 15:43:44.318533
5406	3	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5407	4	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5408	5	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5409	6	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5410	10	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5411	11	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5412	27	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5413	33	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5414	35	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5415	37	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5416	43	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5417	45	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5418	46	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5419	47	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5420	48	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5421	50	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5422	52	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5423	59	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5424	60	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5425	62	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5426	63	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5427	64	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5428	65	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5429	66	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5430	70	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5431	71	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5432	73	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5433	74	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5434	78	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5435	79	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5436	82	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5437	83	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5438	84	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5439	85	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5440	88	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5441	89	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5442	96	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5443	97	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5444	1	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5445	2	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5446	7	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5447	8	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5448	9	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5449	12	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5450	13	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5451	14	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5452	15	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5453	16	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5454	17	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5455	18	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5456	19	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5457	20	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5458	21	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5459	22	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5460	23	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5461	24	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5462	25	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5463	26	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5464	28	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5465	29	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5466	30	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5467	31	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5468	32	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5469	34	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5470	36	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5471	38	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5472	39	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5473	40	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5474	41	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5475	42	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5476	44	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5477	49	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5478	51	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5479	53	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5480	54	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5481	55	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5482	56	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5483	57	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5484	58	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5485	61	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5486	67	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5487	68	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5488	69	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5489	72	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5490	75	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5491	76	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5492	77	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5493	80	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5494	81	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5495	86	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5496	87	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5497	90	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5498	91	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5499	92	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5500	93	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5501	94	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5502	95	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5503	98	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5504	99	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5505	100	2026-01-25	\N	\N	absent	2026-03-02 15:43:44.318533
5506	3	2026-01-26	2026-01-26 09:09:19.528661	2026-01-26 17:32:07.200258	present	2026-03-02 15:43:44.318533
5507	4	2026-01-26	2026-01-26 09:24:33.798233	2026-01-26 17:19:56.078505	present	2026-03-02 15:43:44.318533
5508	5	2026-01-26	2026-01-26 09:40:12.284989	2026-01-26 17:26:44.46681	present	2026-03-02 15:43:44.318533
5509	6	2026-01-26	2026-01-26 09:45:56.591924	2026-01-26 17:12:29.468702	present	2026-03-02 15:43:44.318533
5510	10	2026-01-26	2026-01-26 09:07:22.017048	2026-01-26 17:09:48.40537	present	2026-03-02 15:43:44.318533
5511	11	2026-01-26	2026-01-26 09:23:46.072859	2026-01-26 17:15:59.411264	present	2026-03-02 15:43:44.318533
5512	27	2026-01-26	2026-01-26 09:35:15.126411	2026-01-26 17:09:43.025192	present	2026-03-02 15:43:44.318533
5513	33	2026-01-26	2026-01-26 09:40:03.788926	2026-01-26 17:06:34.737058	present	2026-03-02 15:43:44.318533
5514	35	2026-01-26	2026-01-26 09:27:37.351073	2026-01-26 17:56:42.473232	present	2026-03-02 15:43:44.318533
5515	37	2026-01-26	2026-01-26 09:47:02.080003	2026-01-26 17:37:28.96233	present	2026-03-02 15:43:44.318533
5516	43	2026-01-26	2026-01-26 09:19:48.744323	2026-01-26 17:25:09.815355	present	2026-03-02 15:43:44.318533
5517	45	2026-01-26	2026-01-26 09:21:07.871703	2026-01-26 17:53:31.540663	present	2026-03-02 15:43:44.318533
5518	46	2026-01-26	2026-01-26 09:30:42.671135	2026-01-26 17:44:29.573384	present	2026-03-02 15:43:44.318533
5519	47	2026-01-26	2026-01-26 09:04:55.700588	2026-01-26 17:05:01.663483	present	2026-03-02 15:43:44.318533
5520	48	2026-01-26	2026-01-26 09:03:37.919202	2026-01-26 17:40:10.710428	present	2026-03-02 15:43:44.318533
5521	50	2026-01-26	2026-01-26 09:07:21.911978	2026-01-26 17:46:32.246627	present	2026-03-02 15:43:44.318533
5522	52	2026-01-26	2026-01-26 09:43:12.295012	2026-01-26 17:39:59.027331	present	2026-03-02 15:43:44.318533
5523	59	2026-01-26	2026-01-26 09:24:31.786766	2026-01-26 17:11:22.627756	present	2026-03-02 15:43:44.318533
5524	60	2026-01-26	2026-01-26 09:22:51.408198	2026-01-26 17:00:44.586674	present	2026-03-02 15:43:44.318533
5525	62	2026-01-26	2026-01-26 09:42:26.384161	2026-01-26 17:41:06.638288	present	2026-03-02 15:43:44.318533
5526	63	2026-01-26	2026-01-26 09:34:33.085192	2026-01-26 17:12:47.216816	present	2026-03-02 15:43:44.318533
5527	64	2026-01-26	2026-01-26 09:50:40.591309	2026-01-26 17:43:55.77299	present	2026-03-02 15:43:44.318533
5528	65	2026-01-26	2026-01-26 09:46:06.40187	2026-01-26 17:35:51.030953	present	2026-03-02 15:43:44.318533
5529	66	2026-01-26	2026-01-26 09:59:06.589755	2026-01-26 17:04:16.25425	present	2026-03-02 15:43:44.318533
5530	70	2026-01-26	2026-01-26 09:23:09.803021	2026-01-26 17:40:17.992971	present	2026-03-02 15:43:44.318533
5531	71	2026-01-26	2026-01-26 09:03:25.380336	2026-01-26 17:13:49.246715	present	2026-03-02 15:43:44.318533
5532	73	2026-01-26	2026-01-26 09:56:01.554579	2026-01-26 17:43:01.342652	present	2026-03-02 15:43:44.318533
5533	74	2026-01-26	2026-01-26 09:26:21.738693	2026-01-26 17:35:24.873138	present	2026-03-02 15:43:44.318533
5534	78	2026-01-26	2026-01-26 09:21:44.598987	2026-01-26 17:06:35.483049	present	2026-03-02 15:43:44.318533
5535	79	2026-01-26	2026-01-26 09:28:53.464533	2026-01-26 17:38:27.992821	present	2026-03-02 15:43:44.318533
5536	82	2026-01-26	2026-01-26 09:02:41.282322	2026-01-26 17:24:22.102092	present	2026-03-02 15:43:44.318533
5537	83	2026-01-26	2026-01-26 09:03:28.141222	2026-01-26 17:36:20.580533	present	2026-03-02 15:43:44.318533
5538	84	2026-01-26	2026-01-26 09:26:34.559463	2026-01-26 17:22:01.80998	present	2026-03-02 15:43:44.318533
5539	85	2026-01-26	2026-01-26 09:10:11.605805	2026-01-26 17:36:12.549277	present	2026-03-02 15:43:44.318533
5540	88	2026-01-26	2026-01-26 09:12:50.455611	2026-01-26 17:08:38.185053	present	2026-03-02 15:43:44.318533
5541	89	2026-01-26	2026-01-26 09:09:26.895376	2026-01-26 17:49:21.644999	present	2026-03-02 15:43:44.318533
5542	96	2026-01-26	2026-01-26 09:13:36.511161	2026-01-26 17:14:42.01772	present	2026-03-02 15:43:44.318533
5543	97	2026-01-26	2026-01-26 09:57:40.896114	2026-01-26 17:44:14.004191	present	2026-03-02 15:43:44.318533
5544	1	2026-01-26	2026-01-26 09:28:21.843932	2026-01-26 17:20:33.551507	present	2026-03-02 15:43:44.318533
5545	2	2026-01-26	2026-01-26 09:30:29.094253	2026-01-26 17:54:41.825117	present	2026-03-02 15:43:44.318533
5546	7	2026-01-26	2026-01-26 09:17:48.878253	2026-01-26 17:55:44.05519	present	2026-03-02 15:43:44.318533
5547	8	2026-01-26	2026-01-26 09:27:34.167259	2026-01-26 17:34:07.546927	present	2026-03-02 15:43:44.318533
5548	9	2026-01-26	2026-01-26 09:28:59.737466	2026-01-26 17:27:40.950042	present	2026-03-02 15:43:44.318533
5549	12	2026-01-26	2026-01-26 09:06:51.113706	2026-01-26 17:21:36.949762	present	2026-03-02 15:43:44.318533
5550	13	2026-01-26	2026-01-26 09:24:07.810738	2026-01-26 17:31:51.243142	present	2026-03-02 15:43:44.318533
5551	14	2026-01-26	2026-01-26 09:25:10.74927	2026-01-26 17:50:04.805442	present	2026-03-02 15:43:44.318533
5552	15	2026-01-26	2026-01-26 09:14:27.408299	2026-01-26 17:05:02.847177	present	2026-03-02 15:43:44.318533
5553	16	2026-01-26	2026-01-26 09:24:18.633025	2026-01-26 17:04:49.068677	present	2026-03-02 15:43:44.318533
5554	17	2026-01-26	2026-01-26 09:53:29.43205	2026-01-26 17:08:11.492287	present	2026-03-02 15:43:44.318533
5555	18	2026-01-26	2026-01-26 09:14:40.15919	2026-01-26 17:30:30.720699	present	2026-03-02 15:43:44.318533
5556	19	2026-01-26	2026-01-26 09:13:41.69516	2026-01-26 17:48:49.199142	present	2026-03-02 15:43:44.318533
5557	20	2026-01-26	2026-01-26 09:44:49.128497	2026-01-26 17:21:36.844629	present	2026-03-02 15:43:44.318533
5558	21	2026-01-26	2026-01-26 09:07:00.508824	2026-01-26 17:37:11.252816	present	2026-03-02 15:43:44.318533
5559	22	2026-01-26	2026-01-26 09:16:27.483811	2026-01-26 17:20:54.928	present	2026-03-02 15:43:44.318533
5560	23	2026-01-26	2026-01-26 09:03:38.476774	2026-01-26 17:33:19.175372	present	2026-03-02 15:43:44.318533
5561	24	2026-01-26	2026-01-26 09:50:40.97711	2026-01-26 17:57:28.208848	present	2026-03-02 15:43:44.318533
5562	25	2026-01-26	2026-01-26 09:46:51.939878	2026-01-26 17:44:40.15066	present	2026-03-02 15:43:44.318533
5563	26	2026-01-26	2026-01-26 09:29:37.537075	2026-01-26 17:46:28.861493	present	2026-03-02 15:43:44.318533
5564	28	2026-01-26	2026-01-26 09:03:37.725602	2026-01-26 17:20:23.801796	present	2026-03-02 15:43:44.318533
5565	29	2026-01-26	2026-01-26 09:56:25.926964	2026-01-26 17:32:09.908853	present	2026-03-02 15:43:44.318533
5566	30	2026-01-26	2026-01-26 09:06:44.796459	2026-01-26 17:18:40.569104	present	2026-03-02 15:43:44.318533
5567	31	2026-01-26	2026-01-26 09:22:34.935826	2026-01-26 17:38:51.277752	present	2026-03-02 15:43:44.318533
5568	32	2026-01-26	2026-01-26 09:33:16.794884	2026-01-26 17:31:17.711927	present	2026-03-02 15:43:44.318533
5569	34	2026-01-26	2026-01-26 09:21:54.268993	2026-01-26 17:47:18.618714	present	2026-03-02 15:43:44.318533
5570	36	2026-01-26	2026-01-26 09:54:04.972027	2026-01-26 17:20:59.787049	present	2026-03-02 15:43:44.318533
5571	38	2026-01-26	2026-01-26 09:01:39.183198	2026-01-26 17:20:09.898167	present	2026-03-02 15:43:44.318533
5572	39	2026-01-26	2026-01-26 09:07:17.85259	2026-01-26 17:08:41.547104	present	2026-03-02 15:43:44.318533
5573	40	2026-01-26	2026-01-26 09:01:13.598653	2026-01-26 17:01:07.630766	present	2026-03-02 15:43:44.318533
5574	41	2026-01-26	2026-01-26 09:54:05.727105	2026-01-26 17:41:15.787262	present	2026-03-02 15:43:44.318533
5575	42	2026-01-26	2026-01-26 09:22:39.455642	2026-01-26 17:50:42.848865	present	2026-03-02 15:43:44.318533
5576	44	2026-01-26	2026-01-26 09:02:05.632229	2026-01-26 17:08:08.850469	present	2026-03-02 15:43:44.318533
5577	49	2026-01-26	2026-01-26 09:47:15.262947	2026-01-26 17:20:49.887511	present	2026-03-02 15:43:44.318533
5578	51	2026-01-26	2026-01-26 09:44:39.871665	2026-01-26 17:31:11.441523	present	2026-03-02 15:43:44.318533
5579	53	2026-01-26	2026-01-26 09:23:22.992223	2026-01-26 17:03:53.492195	present	2026-03-02 15:43:44.318533
5580	54	2026-01-26	2026-01-26 09:31:38.926428	2026-01-26 17:34:46.585535	present	2026-03-02 15:43:44.318533
5581	55	2026-01-26	2026-01-26 09:36:49.982735	2026-01-26 17:32:25.130407	present	2026-03-02 15:43:44.318533
5582	56	2026-01-26	2026-01-26 09:40:09.368862	2026-01-26 17:13:34.97477	present	2026-03-02 15:43:44.318533
5583	57	2026-01-26	2026-01-26 09:56:37.835412	2026-01-26 17:56:23.992591	present	2026-03-02 15:43:44.318533
5584	58	2026-01-26	2026-01-26 09:16:33.733981	2026-01-26 17:05:14.624146	present	2026-03-02 15:43:44.318533
5585	61	2026-01-26	2026-01-26 09:51:25.393971	2026-01-26 17:26:29.536756	present	2026-03-02 15:43:44.318533
5586	67	2026-01-26	2026-01-26 09:47:41.115325	2026-01-26 17:35:19.01215	present	2026-03-02 15:43:44.318533
5587	68	2026-01-26	2026-01-26 09:47:08.695176	2026-01-26 17:40:00.420795	present	2026-03-02 15:43:44.318533
5588	69	2026-01-26	2026-01-26 09:34:14.233823	2026-01-26 17:16:00.596733	present	2026-03-02 15:43:44.318533
5589	72	2026-01-26	2026-01-26 09:20:00.56822	2026-01-26 17:08:29.253849	present	2026-03-02 15:43:44.318533
5590	75	2026-01-26	2026-01-26 09:39:24.670819	2026-01-26 17:39:14.612786	present	2026-03-02 15:43:44.318533
5591	76	2026-01-26	2026-01-26 09:43:44.983396	2026-01-26 17:41:34.927438	present	2026-03-02 15:43:44.318533
5592	77	2026-01-26	2026-01-26 09:59:04.621707	2026-01-26 17:26:28.863833	present	2026-03-02 15:43:44.318533
5593	80	2026-01-26	2026-01-26 09:53:45.048606	2026-01-26 17:51:18.971735	present	2026-03-02 15:43:44.318533
5594	81	2026-01-26	2026-01-26 09:04:23.077173	2026-01-26 17:49:52.145496	present	2026-03-02 15:43:44.318533
5595	86	2026-01-26	2026-01-26 09:05:22.539971	2026-01-26 17:44:42.06265	present	2026-03-02 15:43:44.318533
5596	87	2026-01-26	2026-01-26 09:57:51.25134	2026-01-26 17:30:41.901692	present	2026-03-02 15:43:44.318533
5597	90	2026-01-26	2026-01-26 09:30:19.430014	2026-01-26 17:04:06.899254	present	2026-03-02 15:43:44.318533
5598	91	2026-01-26	2026-01-26 09:03:27.661064	2026-01-26 17:41:48.683796	present	2026-03-02 15:43:44.318533
5599	92	2026-01-26	2026-01-26 09:01:15.068998	2026-01-26 17:12:20.905166	present	2026-03-02 15:43:44.318533
5600	93	2026-01-26	2026-01-26 09:24:58.184562	2026-01-26 17:50:49.002166	present	2026-03-02 15:43:44.318533
5601	94	2026-01-26	2026-01-26 09:12:06.642178	2026-01-26 17:22:28.731565	present	2026-03-02 15:43:44.318533
5602	95	2026-01-26	2026-01-26 09:49:42.76192	2026-01-26 17:26:20.772682	present	2026-03-02 15:43:44.318533
5603	98	2026-01-26	2026-01-26 09:22:36.71698	2026-01-26 17:30:23.274362	present	2026-03-02 15:43:44.318533
5604	99	2026-01-26	2026-01-26 09:03:55.641783	2026-01-26 17:13:44.614831	present	2026-03-02 15:43:44.318533
5605	100	2026-01-26	2026-01-26 09:37:43.713158	2026-01-26 17:31:38.958289	present	2026-03-02 15:43:44.318533
5606	3	2026-01-27	2026-01-27 09:50:12.224083	2026-01-27 17:05:56.420629	present	2026-03-02 15:43:44.318533
5607	4	2026-01-27	2026-01-27 09:05:30.907418	2026-01-27 17:05:12.875292	present	2026-03-02 15:43:44.318533
5608	5	2026-01-27	2026-01-27 09:36:27.782216	2026-01-27 17:15:38.885964	present	2026-03-02 15:43:44.318533
5609	6	2026-01-27	2026-01-27 09:08:39.563997	2026-01-27 17:48:12.325748	present	2026-03-02 15:43:44.318533
5610	10	2026-01-27	2026-01-27 09:50:21.028529	2026-01-27 17:17:01.007833	present	2026-03-02 15:43:44.318533
5611	11	2026-01-27	2026-01-27 09:34:28.068237	2026-01-27 17:00:54.454533	present	2026-03-02 15:43:44.318533
5612	27	2026-01-27	2026-01-27 09:39:11.464803	2026-01-27 17:17:21.204545	present	2026-03-02 15:43:44.318533
5613	33	2026-01-27	2026-01-27 09:15:00.408991	2026-01-27 17:59:20.520802	present	2026-03-02 15:43:44.318533
5614	35	2026-01-27	2026-01-27 09:57:38.366881	2026-01-27 17:01:35.704005	present	2026-03-02 15:43:44.318533
5615	37	2026-01-27	2026-01-27 09:14:01.374554	2026-01-27 17:06:13.087484	present	2026-03-02 15:43:44.318533
5616	43	2026-01-27	2026-01-27 09:43:36.469594	2026-01-27 17:21:17.124727	present	2026-03-02 15:43:44.318533
5617	45	2026-01-27	2026-01-27 09:46:46.662174	2026-01-27 17:59:34.251099	present	2026-03-02 15:43:44.318533
5618	46	2026-01-27	2026-01-27 09:24:42.453944	2026-01-27 17:01:16.146921	present	2026-03-02 15:43:44.318533
5619	47	2026-01-27	2026-01-27 09:14:09.131099	2026-01-27 17:06:10.876852	present	2026-03-02 15:43:44.318533
5620	48	2026-01-27	2026-01-27 09:21:03.413847	2026-01-27 17:42:43.944794	present	2026-03-02 15:43:44.318533
5621	50	2026-01-27	2026-01-27 09:34:01.616098	2026-01-27 17:21:33.4313	present	2026-03-02 15:43:44.318533
5622	52	2026-01-27	2026-01-27 09:08:50.288728	2026-01-27 17:47:12.442265	present	2026-03-02 15:43:44.318533
5623	59	2026-01-27	2026-01-27 09:37:59.605772	2026-01-27 17:38:46.587999	present	2026-03-02 15:43:44.318533
5624	60	2026-01-27	2026-01-27 09:56:10.181238	2026-01-27 17:53:48.566266	present	2026-03-02 15:43:44.318533
5625	62	2026-01-27	2026-01-27 09:52:37.455754	2026-01-27 17:10:00.48121	present	2026-03-02 15:43:44.318533
5626	63	2026-01-27	2026-01-27 09:33:54.928162	2026-01-27 17:46:01.497328	present	2026-03-02 15:43:44.318533
5627	64	2026-01-27	2026-01-27 09:39:29.729674	2026-01-27 17:28:23.228421	present	2026-03-02 15:43:44.318533
5628	65	2026-01-27	2026-01-27 09:38:07.249634	2026-01-27 17:56:53.236507	present	2026-03-02 15:43:44.318533
5629	66	2026-01-27	2026-01-27 09:18:11.105125	2026-01-27 17:50:16.562069	present	2026-03-02 15:43:44.318533
5630	70	2026-01-27	2026-01-27 09:17:24.909907	2026-01-27 17:48:11.369763	present	2026-03-02 15:43:44.318533
5631	71	2026-01-27	2026-01-27 09:44:41.903661	2026-01-27 17:00:06.717888	present	2026-03-02 15:43:44.318533
5632	73	2026-01-27	2026-01-27 09:11:20.251498	2026-01-27 17:53:53.786679	present	2026-03-02 15:43:44.318533
5633	74	2026-01-27	2026-01-27 09:28:17.748041	2026-01-27 17:35:30.782225	present	2026-03-02 15:43:44.318533
5634	78	2026-01-27	2026-01-27 09:24:44.055997	2026-01-27 17:19:37.909562	present	2026-03-02 15:43:44.318533
5635	79	2026-01-27	2026-01-27 09:34:38.894954	2026-01-27 17:54:27.088045	present	2026-03-02 15:43:44.318533
5636	82	2026-01-27	2026-01-27 09:19:25.710206	2026-01-27 17:14:19.141016	present	2026-03-02 15:43:44.318533
5637	83	2026-01-27	2026-01-27 09:47:26.738847	2026-01-27 17:27:46.91415	present	2026-03-02 15:43:44.318533
5638	84	2026-01-27	2026-01-27 09:58:24.227321	2026-01-27 17:39:25.732357	present	2026-03-02 15:43:44.318533
5639	85	2026-01-27	2026-01-27 09:42:48.349142	2026-01-27 17:09:00.755619	present	2026-03-02 15:43:44.318533
5640	88	2026-01-27	2026-01-27 09:05:02.49834	2026-01-27 17:41:53.241986	present	2026-03-02 15:43:44.318533
5641	89	2026-01-27	2026-01-27 09:36:27.7494	2026-01-27 17:02:46.909351	present	2026-03-02 15:43:44.318533
5642	96	2026-01-27	2026-01-27 09:37:15.007611	2026-01-27 17:57:29.128689	present	2026-03-02 15:43:44.318533
5643	97	2026-01-27	2026-01-27 09:55:55.296093	2026-01-27 17:54:53.765915	present	2026-03-02 15:43:44.318533
5644	1	2026-01-27	2026-01-27 09:32:45.996481	2026-01-27 17:16:19.054493	present	2026-03-02 15:43:44.318533
5645	2	2026-01-27	2026-01-27 09:03:32.340893	2026-01-27 17:01:14.577791	present	2026-03-02 15:43:44.318533
5646	7	2026-01-27	2026-01-27 09:49:14.164602	2026-01-27 17:59:25.870053	present	2026-03-02 15:43:44.318533
5647	8	2026-01-27	2026-01-27 09:58:37.764352	2026-01-27 17:26:18.372494	present	2026-03-02 15:43:44.318533
5648	9	2026-01-27	2026-01-27 09:27:53.101133	2026-01-27 17:19:57.917718	present	2026-03-02 15:43:44.318533
5649	12	2026-01-27	2026-01-27 09:05:37.481819	2026-01-27 17:55:42.13361	present	2026-03-02 15:43:44.318533
5650	13	2026-01-27	2026-01-27 09:26:06.416148	2026-01-27 17:00:07.883675	present	2026-03-02 15:43:44.318533
5651	14	2026-01-27	2026-01-27 09:15:58.124544	2026-01-27 17:11:52.809506	present	2026-03-02 15:43:44.318533
5652	15	2026-01-27	2026-01-27 09:39:36.521695	2026-01-27 17:53:46.521987	present	2026-03-02 15:43:44.318533
5653	16	2026-01-27	2026-01-27 09:38:17.127024	2026-01-27 17:36:22.396247	present	2026-03-02 15:43:44.318533
5654	17	2026-01-27	2026-01-27 09:21:12.311991	2026-01-27 17:59:58.75056	present	2026-03-02 15:43:44.318533
5655	18	2026-01-27	2026-01-27 09:48:37.437084	2026-01-27 17:41:21.45034	present	2026-03-02 15:43:44.318533
5656	19	2026-01-27	2026-01-27 09:05:59.130709	2026-01-27 17:25:02.469546	present	2026-03-02 15:43:44.318533
5657	20	2026-01-27	2026-01-27 09:00:49.030489	2026-01-27 17:06:04.011809	present	2026-03-02 15:43:44.318533
5658	21	2026-01-27	2026-01-27 09:22:53.851371	2026-01-27 17:35:14.908985	present	2026-03-02 15:43:44.318533
5659	22	2026-01-27	2026-01-27 09:51:00.566563	2026-01-27 17:35:11.768257	present	2026-03-02 15:43:44.318533
5660	23	2026-01-27	2026-01-27 09:09:03.224185	2026-01-27 17:00:45.049703	present	2026-03-02 15:43:44.318533
5661	24	2026-01-27	2026-01-27 09:53:00.896142	2026-01-27 17:42:07.712244	present	2026-03-02 15:43:44.318533
5662	25	2026-01-27	2026-01-27 09:12:29.092402	2026-01-27 17:20:33.916562	present	2026-03-02 15:43:44.318533
5663	26	2026-01-27	2026-01-27 09:20:11.261511	2026-01-27 17:45:49.546771	present	2026-03-02 15:43:44.318533
5664	28	2026-01-27	2026-01-27 09:05:41.461206	2026-01-27 17:58:54.149549	present	2026-03-02 15:43:44.318533
5665	29	2026-01-27	2026-01-27 09:46:06.22803	2026-01-27 17:57:25.04833	present	2026-03-02 15:43:44.318533
5666	30	2026-01-27	2026-01-27 09:20:06.967999	2026-01-27 17:44:50.794694	present	2026-03-02 15:43:44.318533
5667	31	2026-01-27	2026-01-27 09:12:11.899456	2026-01-27 17:11:45.41404	present	2026-03-02 15:43:44.318533
5668	32	2026-01-27	2026-01-27 09:42:27.571154	2026-01-27 17:20:34.289658	present	2026-03-02 15:43:44.318533
5669	34	2026-01-27	2026-01-27 09:33:21.41574	2026-01-27 17:42:10.684932	present	2026-03-02 15:43:44.318533
5670	36	2026-01-27	2026-01-27 09:18:30.904056	2026-01-27 17:13:25.605484	present	2026-03-02 15:43:44.318533
5671	38	2026-01-27	2026-01-27 09:15:11.613814	2026-01-27 17:10:11.457462	present	2026-03-02 15:43:44.318533
5672	39	2026-01-27	2026-01-27 09:12:27.925069	2026-01-27 17:21:01.265184	present	2026-03-02 15:43:44.318533
5673	40	2026-01-27	2026-01-27 09:07:42.148786	2026-01-27 17:55:05.607549	present	2026-03-02 15:43:44.318533
5674	41	2026-01-27	2026-01-27 09:34:48.858569	2026-01-27 17:50:10.157961	present	2026-03-02 15:43:44.318533
5675	42	2026-01-27	2026-01-27 09:17:24.967944	2026-01-27 17:35:05.06013	present	2026-03-02 15:43:44.318533
5676	44	2026-01-27	2026-01-27 09:37:45.520276	2026-01-27 17:27:14.529157	present	2026-03-02 15:43:44.318533
5677	49	2026-01-27	2026-01-27 09:50:00.865124	2026-01-27 17:51:16.213098	present	2026-03-02 15:43:44.318533
5678	51	2026-01-27	2026-01-27 09:14:39.787918	2026-01-27 17:16:20.170302	present	2026-03-02 15:43:44.318533
5679	53	2026-01-27	2026-01-27 09:02:22.445138	2026-01-27 17:06:19.621608	present	2026-03-02 15:43:44.318533
5680	54	2026-01-27	2026-01-27 09:09:36.74875	2026-01-27 17:03:22.743044	present	2026-03-02 15:43:44.318533
5681	55	2026-01-27	2026-01-27 09:40:00.256455	2026-01-27 17:38:54.877477	present	2026-03-02 15:43:44.318533
5682	56	2026-01-27	2026-01-27 09:09:20.944156	2026-01-27 17:14:09.193949	present	2026-03-02 15:43:44.318533
5683	57	2026-01-27	2026-01-27 09:55:14.152406	2026-01-27 17:40:42.165513	present	2026-03-02 15:43:44.318533
5684	58	2026-01-27	2026-01-27 09:35:36.00636	2026-01-27 17:02:29.709572	present	2026-03-02 15:43:44.318533
5685	61	2026-01-27	2026-01-27 09:48:05.969507	2026-01-27 17:55:15.476758	present	2026-03-02 15:43:44.318533
5686	67	2026-01-27	2026-01-27 09:00:03.668246	2026-01-27 17:10:15.235973	present	2026-03-02 15:43:44.318533
5687	68	2026-01-27	2026-01-27 09:08:34.85337	2026-01-27 17:23:33.226464	present	2026-03-02 15:43:44.318533
5688	69	2026-01-27	2026-01-27 09:44:49.496241	2026-01-27 17:46:23.992724	present	2026-03-02 15:43:44.318533
5689	72	2026-01-27	2026-01-27 09:43:48.235442	2026-01-27 17:36:00.394905	present	2026-03-02 15:43:44.318533
5690	75	2026-01-27	2026-01-27 09:37:49.853615	2026-01-27 17:40:15.068968	present	2026-03-02 15:43:44.318533
5691	76	2026-01-27	2026-01-27 09:10:10.022927	2026-01-27 17:51:19.376262	present	2026-03-02 15:43:44.318533
5692	77	2026-01-27	2026-01-27 09:51:31.530807	2026-01-27 17:45:05.989273	present	2026-03-02 15:43:44.318533
5693	80	2026-01-27	2026-01-27 09:22:57.673282	2026-01-27 17:53:07.536099	present	2026-03-02 15:43:44.318533
5694	81	2026-01-27	2026-01-27 09:57:36.094357	2026-01-27 17:07:49.815502	present	2026-03-02 15:43:44.318533
5695	86	2026-01-27	2026-01-27 09:13:12.816091	2026-01-27 17:08:52.435489	present	2026-03-02 15:43:44.318533
5696	87	2026-01-27	2026-01-27 09:01:28.706083	2026-01-27 17:37:20.429307	present	2026-03-02 15:43:44.318533
5697	90	2026-01-27	2026-01-27 09:34:38.599243	2026-01-27 17:14:23.245478	present	2026-03-02 15:43:44.318533
5698	91	2026-01-27	2026-01-27 09:00:21.674781	2026-01-27 17:45:12.964678	present	2026-03-02 15:43:44.318533
5699	92	2026-01-27	2026-01-27 09:09:16.718791	2026-01-27 17:15:30.830569	present	2026-03-02 15:43:44.318533
5700	93	2026-01-27	2026-01-27 09:05:03.684691	2026-01-27 17:58:25.530371	present	2026-03-02 15:43:44.318533
5701	94	2026-01-27	2026-01-27 09:40:55.656411	2026-01-27 17:45:27.235858	present	2026-03-02 15:43:44.318533
5702	95	2026-01-27	2026-01-27 09:15:28.425475	2026-01-27 17:57:49.412381	present	2026-03-02 15:43:44.318533
5703	98	2026-01-27	2026-01-27 09:49:56.430408	2026-01-27 17:27:09.6124	present	2026-03-02 15:43:44.318533
5704	99	2026-01-27	2026-01-27 09:34:21.893946	2026-01-27 17:27:35.105752	present	2026-03-02 15:43:44.318533
5705	100	2026-01-27	2026-01-27 09:53:32.722782	2026-01-27 17:00:37.156115	present	2026-03-02 15:43:44.318533
5706	3	2026-01-28	2026-01-28 09:54:27.210325	2026-01-28 17:55:21.66877	present	2026-03-02 15:43:44.318533
5707	4	2026-01-28	2026-01-28 09:25:11.562342	2026-01-28 17:14:28.630543	present	2026-03-02 15:43:44.318533
5708	5	2026-01-28	2026-01-28 09:54:44.992046	2026-01-28 17:52:05.094697	present	2026-03-02 15:43:44.318533
5709	6	2026-01-28	2026-01-28 09:31:17.699572	2026-01-28 17:45:24.04777	present	2026-03-02 15:43:44.318533
5710	10	2026-01-28	2026-01-28 09:56:50.34478	2026-01-28 17:44:31.936092	present	2026-03-02 15:43:44.318533
5711	11	2026-01-28	2026-01-28 09:35:21.349689	2026-01-28 17:41:35.814782	present	2026-03-02 15:43:44.318533
5712	27	2026-01-28	2026-01-28 09:18:32.12337	2026-01-28 17:47:53.533915	present	2026-03-02 15:43:44.318533
5713	33	2026-01-28	2026-01-28 09:24:38.064184	2026-01-28 17:35:02.546556	present	2026-03-02 15:43:44.318533
5714	35	2026-01-28	2026-01-28 09:44:03.437445	2026-01-28 17:04:24.857243	present	2026-03-02 15:43:44.318533
5715	37	2026-01-28	2026-01-28 09:53:01.868015	2026-01-28 17:57:13.522316	present	2026-03-02 15:43:44.318533
5716	43	2026-01-28	2026-01-28 09:18:21.675728	2026-01-28 17:50:34.56692	present	2026-03-02 15:43:44.318533
5717	45	2026-01-28	2026-01-28 09:11:55.478379	2026-01-28 17:16:49.707842	present	2026-03-02 15:43:44.318533
5718	46	2026-01-28	2026-01-28 09:32:29.922825	2026-01-28 17:18:29.768905	present	2026-03-02 15:43:44.318533
5719	47	2026-01-28	2026-01-28 09:53:42.448714	2026-01-28 17:00:42.811152	present	2026-03-02 15:43:44.318533
5720	48	2026-01-28	2026-01-28 09:16:40.589131	2026-01-28 17:10:37.083646	present	2026-03-02 15:43:44.318533
5721	50	2026-01-28	2026-01-28 09:46:32.786833	2026-01-28 17:15:36.609322	present	2026-03-02 15:43:44.318533
5722	52	2026-01-28	2026-01-28 09:52:02.436578	2026-01-28 17:00:51.702238	present	2026-03-02 15:43:44.318533
5723	59	2026-01-28	2026-01-28 09:37:56.098541	2026-01-28 17:07:02.318806	present	2026-03-02 15:43:44.318533
5724	60	2026-01-28	2026-01-28 09:12:49.485194	2026-01-28 17:30:26.822355	present	2026-03-02 15:43:44.318533
5725	62	2026-01-28	2026-01-28 09:45:45.810909	2026-01-28 17:44:28.804406	present	2026-03-02 15:43:44.318533
5726	63	2026-01-28	2026-01-28 09:28:14.674674	2026-01-28 17:02:16.296366	present	2026-03-02 15:43:44.318533
5727	64	2026-01-28	2026-01-28 09:35:38.674533	2026-01-28 17:15:50.955574	present	2026-03-02 15:43:44.318533
5728	65	2026-01-28	2026-01-28 09:19:15.657627	2026-01-28 17:29:30.245585	present	2026-03-02 15:43:44.318533
5729	66	2026-01-28	2026-01-28 09:20:07.316785	2026-01-28 17:48:54.031368	present	2026-03-02 15:43:44.318533
5730	70	2026-01-28	2026-01-28 09:02:57.092213	2026-01-28 17:20:47.570392	present	2026-03-02 15:43:44.318533
5731	71	2026-01-28	2026-01-28 09:23:54.820347	2026-01-28 17:52:57.231861	present	2026-03-02 15:43:44.318533
5732	73	2026-01-28	2026-01-28 09:10:25.775861	2026-01-28 17:05:37.447867	present	2026-03-02 15:43:44.318533
5733	74	2026-01-28	2026-01-28 09:35:09.560777	2026-01-28 17:23:45.60322	present	2026-03-02 15:43:44.318533
5734	78	2026-01-28	2026-01-28 09:00:11.335074	2026-01-28 17:47:14.667902	present	2026-03-02 15:43:44.318533
5735	79	2026-01-28	2026-01-28 09:26:54.944642	2026-01-28 17:35:53.976389	present	2026-03-02 15:43:44.318533
5736	82	2026-01-28	2026-01-28 09:31:46.746605	2026-01-28 17:37:53.99221	present	2026-03-02 15:43:44.318533
5737	83	2026-01-28	2026-01-28 09:14:04.297708	2026-01-28 17:48:10.589346	present	2026-03-02 15:43:44.318533
5738	84	2026-01-28	2026-01-28 09:57:55.555152	2026-01-28 17:12:50.309978	present	2026-03-02 15:43:44.318533
5739	85	2026-01-28	2026-01-28 09:03:39.861266	2026-01-28 17:22:20.986589	present	2026-03-02 15:43:44.318533
5740	88	2026-01-28	2026-01-28 09:12:34.422068	2026-01-28 17:35:13.609155	present	2026-03-02 15:43:44.318533
5741	89	2026-01-28	2026-01-28 09:39:09.291248	2026-01-28 17:44:23.796638	present	2026-03-02 15:43:44.318533
5742	96	2026-01-28	2026-01-28 09:39:16.631938	2026-01-28 17:50:18.562544	present	2026-03-02 15:43:44.318533
5743	97	2026-01-28	2026-01-28 09:46:53.048642	2026-01-28 17:01:45.002619	present	2026-03-02 15:43:44.318533
5744	1	2026-01-28	2026-01-28 09:20:45.166829	2026-01-28 17:11:02.098473	present	2026-03-02 15:43:44.318533
5745	2	2026-01-28	2026-01-28 09:52:44.591026	2026-01-28 17:30:20.939974	present	2026-03-02 15:43:44.318533
5746	7	2026-01-28	2026-01-28 09:22:40.27374	2026-01-28 17:54:58.622674	present	2026-03-02 15:43:44.318533
5747	8	2026-01-28	2026-01-28 09:04:50.589933	2026-01-28 17:14:01.401087	present	2026-03-02 15:43:44.318533
5748	9	2026-01-28	2026-01-28 09:32:48.947113	2026-01-28 17:16:08.496965	present	2026-03-02 15:43:44.318533
5749	12	2026-01-28	2026-01-28 09:24:25.575794	2026-01-28 17:04:02.013684	present	2026-03-02 15:43:44.318533
5750	13	2026-01-28	2026-01-28 09:33:01.6293	2026-01-28 17:52:12.829874	present	2026-03-02 15:43:44.318533
5751	14	2026-01-28	2026-01-28 09:50:02.292792	2026-01-28 17:59:54.894817	present	2026-03-02 15:43:44.318533
5752	15	2026-01-28	2026-01-28 09:11:16.469149	2026-01-28 17:54:26.147656	present	2026-03-02 15:43:44.318533
5753	16	2026-01-28	2026-01-28 09:17:25.547185	2026-01-28 17:11:18.17787	present	2026-03-02 15:43:44.318533
5754	17	2026-01-28	2026-01-28 09:47:19.615639	2026-01-28 17:04:57.782232	present	2026-03-02 15:43:44.318533
5755	18	2026-01-28	2026-01-28 09:50:56.971146	2026-01-28 17:53:28.344706	present	2026-03-02 15:43:44.318533
5756	19	2026-01-28	2026-01-28 09:09:47.093477	2026-01-28 17:33:33.751162	present	2026-03-02 15:43:44.318533
5757	20	2026-01-28	2026-01-28 09:28:21.427182	2026-01-28 17:17:40.35298	present	2026-03-02 15:43:44.318533
5758	21	2026-01-28	2026-01-28 09:45:01.244412	2026-01-28 17:36:32.533628	present	2026-03-02 15:43:44.318533
5759	22	2026-01-28	2026-01-28 09:05:03.793804	2026-01-28 17:38:33.423663	present	2026-03-02 15:43:44.318533
5760	23	2026-01-28	2026-01-28 09:55:45.819198	2026-01-28 17:50:44.91908	present	2026-03-02 15:43:44.318533
5761	24	2026-01-28	2026-01-28 09:40:41.21105	2026-01-28 17:10:45.60533	present	2026-03-02 15:43:44.318533
5762	25	2026-01-28	2026-01-28 09:40:55.434193	2026-01-28 17:58:59.543504	present	2026-03-02 15:43:44.318533
5763	26	2026-01-28	2026-01-28 09:11:43.660796	2026-01-28 17:24:50.783474	present	2026-03-02 15:43:44.318533
5764	28	2026-01-28	2026-01-28 09:37:46.761401	2026-01-28 17:52:53.985192	present	2026-03-02 15:43:44.318533
5765	29	2026-01-28	2026-01-28 09:38:45.905475	2026-01-28 17:28:33.153728	present	2026-03-02 15:43:44.318533
5766	30	2026-01-28	2026-01-28 09:56:16.972735	2026-01-28 17:04:56.550844	present	2026-03-02 15:43:44.318533
5767	31	2026-01-28	2026-01-28 09:45:59.645183	2026-01-28 17:46:17.343221	present	2026-03-02 15:43:44.318533
5768	32	2026-01-28	2026-01-28 09:15:48.482488	2026-01-28 17:33:35.113231	present	2026-03-02 15:43:44.318533
5769	34	2026-01-28	2026-01-28 09:25:17.547494	2026-01-28 17:12:30.3637	present	2026-03-02 15:43:44.318533
5770	36	2026-01-28	2026-01-28 09:34:39.847854	2026-01-28 17:56:37.364229	present	2026-03-02 15:43:44.318533
5771	38	2026-01-28	2026-01-28 09:23:49.907922	2026-01-28 17:50:24.392742	present	2026-03-02 15:43:44.318533
5772	39	2026-01-28	2026-01-28 09:03:50.139802	2026-01-28 17:08:06.250122	present	2026-03-02 15:43:44.318533
5773	40	2026-01-28	2026-01-28 09:26:56.334736	2026-01-28 17:13:49.860865	present	2026-03-02 15:43:44.318533
5774	41	2026-01-28	2026-01-28 09:34:30.801851	2026-01-28 17:38:52.433901	present	2026-03-02 15:43:44.318533
5775	42	2026-01-28	2026-01-28 09:36:50.818276	2026-01-28 17:15:28.772127	present	2026-03-02 15:43:44.318533
5776	44	2026-01-28	2026-01-28 09:51:21.827441	2026-01-28 17:22:10.161567	present	2026-03-02 15:43:44.318533
5777	49	2026-01-28	2026-01-28 09:21:57.417164	2026-01-28 17:11:35.130607	present	2026-03-02 15:43:44.318533
5778	51	2026-01-28	2026-01-28 09:45:07.889628	2026-01-28 17:37:03.229897	present	2026-03-02 15:43:44.318533
5779	53	2026-01-28	2026-01-28 09:36:24.534794	2026-01-28 17:25:23.683304	present	2026-03-02 15:43:44.318533
5780	54	2026-01-28	2026-01-28 09:45:17.612345	2026-01-28 17:33:23.580781	present	2026-03-02 15:43:44.318533
5781	55	2026-01-28	2026-01-28 09:00:20.442425	2026-01-28 17:07:28.226209	present	2026-03-02 15:43:44.318533
5782	56	2026-01-28	2026-01-28 09:29:27.074964	2026-01-28 17:47:59.597011	present	2026-03-02 15:43:44.318533
5783	57	2026-01-28	2026-01-28 09:58:42.407818	2026-01-28 17:21:12.656573	present	2026-03-02 15:43:44.318533
5784	58	2026-01-28	2026-01-28 09:24:38.054397	2026-01-28 17:45:14.893572	present	2026-03-02 15:43:44.318533
5785	61	2026-01-28	2026-01-28 09:35:33.956383	2026-01-28 17:48:16.151842	present	2026-03-02 15:43:44.318533
5786	67	2026-01-28	2026-01-28 09:12:49.280866	2026-01-28 17:48:58.815251	present	2026-03-02 15:43:44.318533
5787	68	2026-01-28	2026-01-28 09:56:16.686881	2026-01-28 17:32:44.046726	present	2026-03-02 15:43:44.318533
5788	69	2026-01-28	2026-01-28 09:33:37.577498	2026-01-28 17:06:12.40536	present	2026-03-02 15:43:44.318533
5789	72	2026-01-28	2026-01-28 09:12:44.139464	2026-01-28 17:55:36.630669	present	2026-03-02 15:43:44.318533
5790	75	2026-01-28	2026-01-28 09:06:29.621762	2026-01-28 17:47:20.58502	present	2026-03-02 15:43:44.318533
5791	76	2026-01-28	2026-01-28 09:40:02.369592	2026-01-28 17:53:49.294313	present	2026-03-02 15:43:44.318533
5792	77	2026-01-28	2026-01-28 09:36:29.921649	2026-01-28 17:19:00.283732	present	2026-03-02 15:43:44.318533
5793	80	2026-01-28	2026-01-28 09:50:24.92682	2026-01-28 17:20:34.532576	present	2026-03-02 15:43:44.318533
5794	81	2026-01-28	2026-01-28 09:22:39.47823	2026-01-28 17:26:54.991196	present	2026-03-02 15:43:44.318533
5795	86	2026-01-28	2026-01-28 09:13:09.521484	2026-01-28 17:59:10.968743	present	2026-03-02 15:43:44.318533
5796	87	2026-01-28	2026-01-28 09:48:25.927448	2026-01-28 17:40:52.849369	present	2026-03-02 15:43:44.318533
5797	90	2026-01-28	2026-01-28 09:26:24.179488	2026-01-28 17:16:52.831645	present	2026-03-02 15:43:44.318533
5798	91	2026-01-28	2026-01-28 09:23:14.271786	2026-01-28 17:00:04.223108	present	2026-03-02 15:43:44.318533
5799	92	2026-01-28	2026-01-28 09:15:49.829304	2026-01-28 17:15:13.663159	present	2026-03-02 15:43:44.318533
5800	93	2026-01-28	2026-01-28 09:01:42.188551	2026-01-28 17:13:54.119126	present	2026-03-02 15:43:44.318533
5801	94	2026-01-28	2026-01-28 09:27:00.331601	2026-01-28 17:04:43.838589	present	2026-03-02 15:43:44.318533
5802	95	2026-01-28	2026-01-28 09:42:47.795509	2026-01-28 17:05:28.303493	present	2026-03-02 15:43:44.318533
5803	98	2026-01-28	2026-01-28 09:16:48.677061	2026-01-28 17:00:19.296761	present	2026-03-02 15:43:44.318533
5804	99	2026-01-28	2026-01-28 09:14:01.54507	2026-01-28 17:21:53.514427	present	2026-03-02 15:43:44.318533
5805	100	2026-01-28	2026-01-28 09:21:03.905113	2026-01-28 17:59:03.859487	present	2026-03-02 15:43:44.318533
5806	3	2026-01-29	2026-01-29 09:44:02.884647	2026-01-29 17:29:07.280983	present	2026-03-02 15:43:44.318533
5807	4	2026-01-29	2026-01-29 09:38:42.687578	2026-01-29 17:13:41.973733	present	2026-03-02 15:43:44.318533
5808	5	2026-01-29	2026-01-29 09:43:47.782999	2026-01-29 17:23:31.559004	present	2026-03-02 15:43:44.318533
5809	6	2026-01-29	2026-01-29 09:00:19.556594	2026-01-29 17:55:35.331483	present	2026-03-02 15:43:44.318533
5810	10	2026-01-29	2026-01-29 09:30:08.265799	2026-01-29 17:37:44.534111	present	2026-03-02 15:43:44.318533
5811	11	2026-01-29	2026-01-29 09:23:02.063391	2026-01-29 17:57:42.17246	present	2026-03-02 15:43:44.318533
5812	27	2026-01-29	2026-01-29 09:36:32.175661	2026-01-29 17:47:44.288689	present	2026-03-02 15:43:44.318533
5813	33	2026-01-29	2026-01-29 09:56:07.084973	2026-01-29 17:16:28.078701	present	2026-03-02 15:43:44.318533
5814	35	2026-01-29	2026-01-29 09:19:50.916821	2026-01-29 17:43:52.005923	present	2026-03-02 15:43:44.318533
5815	37	2026-01-29	2026-01-29 09:29:47.85104	2026-01-29 17:37:13.877317	present	2026-03-02 15:43:44.318533
5816	43	2026-01-29	2026-01-29 09:22:06.771466	2026-01-29 17:48:43.77756	present	2026-03-02 15:43:44.318533
5817	45	2026-01-29	2026-01-29 09:45:41.610201	2026-01-29 17:01:20.854147	present	2026-03-02 15:43:44.318533
5818	46	2026-01-29	2026-01-29 09:29:49.46175	2026-01-29 17:57:19.266088	present	2026-03-02 15:43:44.318533
5819	47	2026-01-29	2026-01-29 09:05:28.718126	2026-01-29 17:28:45.891856	present	2026-03-02 15:43:44.318533
5820	48	2026-01-29	2026-01-29 09:46:25.76291	2026-01-29 17:14:48.509088	present	2026-03-02 15:43:44.318533
5821	50	2026-01-29	2026-01-29 09:58:22.323836	2026-01-29 17:33:18.673505	present	2026-03-02 15:43:44.318533
5822	52	2026-01-29	2026-01-29 09:43:04.176332	2026-01-29 17:10:59.224906	present	2026-03-02 15:43:44.318533
5823	59	2026-01-29	2026-01-29 09:15:32.725145	2026-01-29 17:31:08.845432	present	2026-03-02 15:43:44.318533
5824	60	2026-01-29	2026-01-29 09:59:41.275414	2026-01-29 17:13:16.126242	present	2026-03-02 15:43:44.318533
5825	62	2026-01-29	2026-01-29 09:53:07.832295	2026-01-29 17:45:50.526665	present	2026-03-02 15:43:44.318533
5826	63	2026-01-29	2026-01-29 09:39:46.384868	2026-01-29 17:11:08.149841	present	2026-03-02 15:43:44.318533
5827	64	2026-01-29	2026-01-29 09:41:23.917689	2026-01-29 17:57:10.306789	present	2026-03-02 15:43:44.318533
5828	65	2026-01-29	2026-01-29 09:00:17.639662	2026-01-29 17:42:35.492964	present	2026-03-02 15:43:44.318533
5829	66	2026-01-29	2026-01-29 09:37:19.233198	2026-01-29 17:39:39.410303	present	2026-03-02 15:43:44.318533
5830	70	2026-01-29	2026-01-29 09:44:10.966027	2026-01-29 17:57:09.660816	present	2026-03-02 15:43:44.318533
5831	71	2026-01-29	2026-01-29 09:57:43.479154	2026-01-29 17:41:30.209785	present	2026-03-02 15:43:44.318533
5832	73	2026-01-29	2026-01-29 09:51:30.776723	2026-01-29 17:39:15.943248	present	2026-03-02 15:43:44.318533
5833	74	2026-01-29	2026-01-29 09:05:47.804846	2026-01-29 17:30:08.27627	present	2026-03-02 15:43:44.318533
5834	78	2026-01-29	2026-01-29 09:17:03.678368	2026-01-29 17:50:45.641609	present	2026-03-02 15:43:44.318533
5835	79	2026-01-29	2026-01-29 09:23:15.307653	2026-01-29 17:01:31.149974	present	2026-03-02 15:43:44.318533
5836	82	2026-01-29	2026-01-29 09:34:45.185559	2026-01-29 17:26:34.708598	present	2026-03-02 15:43:44.318533
5837	83	2026-01-29	2026-01-29 09:37:53.852921	2026-01-29 17:40:19.754797	present	2026-03-02 15:43:44.318533
5838	84	2026-01-29	2026-01-29 09:12:57.265239	2026-01-29 17:36:04.919128	present	2026-03-02 15:43:44.318533
5839	85	2026-01-29	2026-01-29 09:03:38.218219	2026-01-29 17:44:30.42528	present	2026-03-02 15:43:44.318533
5840	88	2026-01-29	2026-01-29 09:19:03.968386	2026-01-29 17:36:12.958689	present	2026-03-02 15:43:44.318533
5841	89	2026-01-29	2026-01-29 09:15:30.654435	2026-01-29 17:09:16.653051	present	2026-03-02 15:43:44.318533
5842	96	2026-01-29	2026-01-29 09:47:41.132649	2026-01-29 17:33:20.124179	present	2026-03-02 15:43:44.318533
5843	97	2026-01-29	2026-01-29 09:36:12.422431	2026-01-29 17:54:00.395195	present	2026-03-02 15:43:44.318533
5844	1	2026-01-29	2026-01-29 09:41:26.66128	2026-01-29 17:57:26.875814	present	2026-03-02 15:43:44.318533
5845	2	2026-01-29	2026-01-29 09:28:58.122449	2026-01-29 17:09:16.21416	present	2026-03-02 15:43:44.318533
5846	7	2026-01-29	2026-01-29 09:27:39.017357	2026-01-29 17:46:16.57466	present	2026-03-02 15:43:44.318533
5847	8	2026-01-29	2026-01-29 09:05:50.574931	2026-01-29 17:35:40.921649	present	2026-03-02 15:43:44.318533
5848	9	2026-01-29	2026-01-29 09:13:24.631471	2026-01-29 17:21:17.96975	present	2026-03-02 15:43:44.318533
5849	12	2026-01-29	2026-01-29 09:13:32.878907	2026-01-29 17:58:49.982906	present	2026-03-02 15:43:44.318533
5850	13	2026-01-29	2026-01-29 09:27:47.968869	2026-01-29 17:11:34.937934	present	2026-03-02 15:43:44.318533
5851	14	2026-01-29	2026-01-29 09:42:16.361623	2026-01-29 17:16:47.041921	present	2026-03-02 15:43:44.318533
5852	15	2026-01-29	2026-01-29 09:48:06.657537	2026-01-29 17:33:46.808392	present	2026-03-02 15:43:44.318533
5853	16	2026-01-29	2026-01-29 09:47:14.127081	2026-01-29 17:05:03.36084	present	2026-03-02 15:43:44.318533
5854	17	2026-01-29	2026-01-29 09:02:53.877738	2026-01-29 17:26:50.336467	present	2026-03-02 15:43:44.318533
5855	18	2026-01-29	2026-01-29 09:46:29.232408	2026-01-29 17:10:28.57049	present	2026-03-02 15:43:44.318533
5856	19	2026-01-29	2026-01-29 09:45:57.202814	2026-01-29 17:33:34.806255	present	2026-03-02 15:43:44.318533
5857	20	2026-01-29	2026-01-29 09:09:29.202382	2026-01-29 17:37:14.396974	present	2026-03-02 15:43:44.318533
5858	21	2026-01-29	2026-01-29 09:34:20.621347	2026-01-29 17:35:32.348172	present	2026-03-02 15:43:44.318533
5859	22	2026-01-29	2026-01-29 09:34:37.925024	2026-01-29 17:27:32.801308	present	2026-03-02 15:43:44.318533
5860	23	2026-01-29	2026-01-29 09:11:01.885136	2026-01-29 17:56:14.003193	present	2026-03-02 15:43:44.318533
5861	24	2026-01-29	2026-01-29 09:39:16.293063	2026-01-29 17:59:05.934934	present	2026-03-02 15:43:44.318533
5862	25	2026-01-29	2026-01-29 09:41:16.754078	2026-01-29 17:25:47.000595	present	2026-03-02 15:43:44.318533
5863	26	2026-01-29	2026-01-29 09:54:04.972294	2026-01-29 17:09:15.959403	present	2026-03-02 15:43:44.318533
5864	28	2026-01-29	2026-01-29 09:53:36.221588	2026-01-29 17:34:15.246479	present	2026-03-02 15:43:44.318533
5865	29	2026-01-29	2026-01-29 09:05:51.320384	2026-01-29 17:19:48.649271	present	2026-03-02 15:43:44.318533
5866	30	2026-01-29	2026-01-29 09:10:30.110086	2026-01-29 17:34:26.359574	present	2026-03-02 15:43:44.318533
5867	31	2026-01-29	2026-01-29 09:53:04.249875	2026-01-29 17:59:57.101375	present	2026-03-02 15:43:44.318533
5868	32	2026-01-29	2026-01-29 09:07:15.88578	2026-01-29 17:37:54.405457	present	2026-03-02 15:43:44.318533
5869	34	2026-01-29	2026-01-29 09:12:07.193061	2026-01-29 17:10:33.261546	present	2026-03-02 15:43:44.318533
5870	36	2026-01-29	2026-01-29 09:14:06.102211	2026-01-29 17:07:43.734616	present	2026-03-02 15:43:44.318533
5871	38	2026-01-29	2026-01-29 09:48:48.694307	2026-01-29 17:53:29.288039	present	2026-03-02 15:43:44.318533
5872	39	2026-01-29	2026-01-29 09:26:52.103557	2026-01-29 17:23:32.23771	present	2026-03-02 15:43:44.318533
5873	40	2026-01-29	2026-01-29 09:54:04.161871	2026-01-29 17:38:15.105293	present	2026-03-02 15:43:44.318533
5874	41	2026-01-29	2026-01-29 09:46:18.961723	2026-01-29 17:38:00.735926	present	2026-03-02 15:43:44.318533
5875	42	2026-01-29	2026-01-29 09:02:07.551428	2026-01-29 17:12:07.483901	present	2026-03-02 15:43:44.318533
5876	44	2026-01-29	2026-01-29 09:07:59.12845	2026-01-29 17:09:08.94321	present	2026-03-02 15:43:44.318533
5877	49	2026-01-29	2026-01-29 09:55:07.273908	2026-01-29 17:55:18.709157	present	2026-03-02 15:43:44.318533
5878	51	2026-01-29	2026-01-29 09:40:16.812997	2026-01-29 17:43:01.292891	present	2026-03-02 15:43:44.318533
5879	53	2026-01-29	2026-01-29 09:44:50.625264	2026-01-29 17:08:04.098652	present	2026-03-02 15:43:44.318533
5880	54	2026-01-29	2026-01-29 09:54:29.232185	2026-01-29 17:39:51.919221	present	2026-03-02 15:43:44.318533
5881	55	2026-01-29	2026-01-29 09:01:53.637913	2026-01-29 17:00:04.867128	present	2026-03-02 15:43:44.318533
5882	56	2026-01-29	2026-01-29 09:48:23.777255	2026-01-29 17:03:41.705368	present	2026-03-02 15:43:44.318533
5883	57	2026-01-29	2026-01-29 09:33:07.051387	2026-01-29 17:45:59.209293	present	2026-03-02 15:43:44.318533
5884	58	2026-01-29	2026-01-29 09:34:41.650243	2026-01-29 17:58:38.634971	present	2026-03-02 15:43:44.318533
5885	61	2026-01-29	2026-01-29 09:31:17.527358	2026-01-29 17:58:07.692305	present	2026-03-02 15:43:44.318533
5886	67	2026-01-29	2026-01-29 09:56:58.022079	2026-01-29 17:12:22.561623	present	2026-03-02 15:43:44.318533
5887	68	2026-01-29	2026-01-29 09:13:34.144512	2026-01-29 17:00:46.824913	present	2026-03-02 15:43:44.318533
5888	69	2026-01-29	2026-01-29 09:53:32.5465	2026-01-29 17:35:32.938548	present	2026-03-02 15:43:44.318533
5889	72	2026-01-29	2026-01-29 09:32:49.502672	2026-01-29 17:45:08.189822	present	2026-03-02 15:43:44.318533
5890	75	2026-01-29	2026-01-29 09:40:48.411238	2026-01-29 17:46:16.053633	present	2026-03-02 15:43:44.318533
5891	76	2026-01-29	2026-01-29 09:15:16.146819	2026-01-29 17:02:01.095794	present	2026-03-02 15:43:44.318533
5892	77	2026-01-29	2026-01-29 09:27:24.835539	2026-01-29 17:16:42.712909	present	2026-03-02 15:43:44.318533
5893	80	2026-01-29	2026-01-29 09:43:02.901398	2026-01-29 17:14:08.012924	present	2026-03-02 15:43:44.318533
5894	81	2026-01-29	2026-01-29 09:16:59.358459	2026-01-29 17:33:08.976849	present	2026-03-02 15:43:44.318533
5895	86	2026-01-29	2026-01-29 09:03:42.548147	2026-01-29 17:46:03.000596	present	2026-03-02 15:43:44.318533
5896	87	2026-01-29	2026-01-29 09:35:09.243228	2026-01-29 17:25:13.167116	present	2026-03-02 15:43:44.318533
5897	90	2026-01-29	2026-01-29 09:49:15.128127	2026-01-29 17:14:42.489109	present	2026-03-02 15:43:44.318533
5898	91	2026-01-29	2026-01-29 09:10:03.900316	2026-01-29 17:48:25.040567	present	2026-03-02 15:43:44.318533
5899	92	2026-01-29	2026-01-29 09:21:48.981562	2026-01-29 17:57:08.290319	present	2026-03-02 15:43:44.318533
5900	93	2026-01-29	2026-01-29 09:43:50.088464	2026-01-29 17:15:29.994947	present	2026-03-02 15:43:44.318533
5901	94	2026-01-29	2026-01-29 09:50:43.294994	2026-01-29 17:06:31.931147	present	2026-03-02 15:43:44.318533
5902	95	2026-01-29	2026-01-29 09:03:31.500318	2026-01-29 17:26:15.075562	present	2026-03-02 15:43:44.318533
5903	98	2026-01-29	2026-01-29 09:54:03.195164	2026-01-29 17:32:53.086465	present	2026-03-02 15:43:44.318533
5904	99	2026-01-29	2026-01-29 09:53:09.366259	2026-01-29 17:13:31.637645	present	2026-03-02 15:43:44.318533
5905	100	2026-01-29	2026-01-29 09:12:38.490409	2026-01-29 17:51:02.647006	present	2026-03-02 15:43:44.318533
5906	3	2026-01-30	2026-01-30 09:35:35.483594	2026-01-30 17:17:43.684611	present	2026-03-02 15:43:44.318533
5907	4	2026-01-30	2026-01-30 09:14:09.612277	2026-01-30 17:03:14.26564	present	2026-03-02 15:43:44.318533
5908	5	2026-01-30	2026-01-30 09:22:09.305274	2026-01-30 17:44:01.829096	present	2026-03-02 15:43:44.318533
5909	6	2026-01-30	2026-01-30 09:02:20.448978	2026-01-30 17:09:55.587952	present	2026-03-02 15:43:44.318533
5910	10	2026-01-30	2026-01-30 09:02:44.529347	2026-01-30 17:24:31.419585	present	2026-03-02 15:43:44.318533
5911	11	2026-01-30	2026-01-30 09:23:09.985405	2026-01-30 17:42:42.463115	present	2026-03-02 15:43:44.318533
5912	27	2026-01-30	2026-01-30 09:26:20.417907	2026-01-30 17:24:06.976011	present	2026-03-02 15:43:44.318533
5913	33	2026-01-30	2026-01-30 09:08:57.454982	2026-01-30 17:09:27.613797	present	2026-03-02 15:43:44.318533
5914	35	2026-01-30	2026-01-30 09:38:02.856316	2026-01-30 17:48:05.673837	present	2026-03-02 15:43:44.318533
5915	37	2026-01-30	2026-01-30 09:46:11.171486	2026-01-30 17:44:57.853244	present	2026-03-02 15:43:44.318533
5916	43	2026-01-30	2026-01-30 09:05:32.222829	2026-01-30 17:26:21.00307	present	2026-03-02 15:43:44.318533
5917	45	2026-01-30	2026-01-30 09:40:45.744188	2026-01-30 17:16:13.146059	present	2026-03-02 15:43:44.318533
5918	46	2026-01-30	2026-01-30 09:38:55.044899	2026-01-30 17:00:01.205254	present	2026-03-02 15:43:44.318533
5919	47	2026-01-30	2026-01-30 09:21:29.68706	2026-01-30 17:03:01.352687	present	2026-03-02 15:43:44.318533
5920	48	2026-01-30	2026-01-30 09:44:34.960546	2026-01-30 17:04:08.907101	present	2026-03-02 15:43:44.318533
5921	50	2026-01-30	2026-01-30 09:36:47.149046	2026-01-30 17:59:43.987037	present	2026-03-02 15:43:44.318533
5922	52	2026-01-30	2026-01-30 09:42:30.239603	2026-01-30 17:42:59.721715	present	2026-03-02 15:43:44.318533
5923	59	2026-01-30	2026-01-30 09:01:02.140369	2026-01-30 17:02:02.354275	present	2026-03-02 15:43:44.318533
5924	60	2026-01-30	2026-01-30 09:57:35.71762	2026-01-30 17:30:41.769529	present	2026-03-02 15:43:44.318533
5925	62	2026-01-30	2026-01-30 09:16:18.153348	2026-01-30 17:56:10.997798	present	2026-03-02 15:43:44.318533
5926	63	2026-01-30	2026-01-30 09:50:04.168096	2026-01-30 17:10:43.633921	present	2026-03-02 15:43:44.318533
5927	64	2026-01-30	2026-01-30 09:28:26.483929	2026-01-30 17:12:01.656749	present	2026-03-02 15:43:44.318533
5928	65	2026-01-30	2026-01-30 09:00:32.859945	2026-01-30 17:55:29.137097	present	2026-03-02 15:43:44.318533
5929	66	2026-01-30	2026-01-30 09:48:41.197763	2026-01-30 17:54:48.036594	present	2026-03-02 15:43:44.318533
5930	70	2026-01-30	2026-01-30 09:31:08.495597	2026-01-30 17:02:07.131744	present	2026-03-02 15:43:44.318533
5931	71	2026-01-30	2026-01-30 09:29:34.512162	2026-01-30 17:50:30.061616	present	2026-03-02 15:43:44.318533
5932	73	2026-01-30	2026-01-30 09:27:35.206667	2026-01-30 17:25:38.94678	present	2026-03-02 15:43:44.318533
5933	74	2026-01-30	2026-01-30 09:14:18.199222	2026-01-30 17:11:51.056517	present	2026-03-02 15:43:44.318533
5934	78	2026-01-30	2026-01-30 09:20:31.388235	2026-01-30 17:22:59.934484	present	2026-03-02 15:43:44.318533
5935	79	2026-01-30	2026-01-30 09:27:45.095555	2026-01-30 17:31:48.93051	present	2026-03-02 15:43:44.318533
5936	82	2026-01-30	2026-01-30 09:38:25.949265	2026-01-30 17:05:31.231845	present	2026-03-02 15:43:44.318533
5937	83	2026-01-30	2026-01-30 09:47:17.007634	2026-01-30 17:26:01.359292	present	2026-03-02 15:43:44.318533
5938	84	2026-01-30	2026-01-30 09:46:22.51675	2026-01-30 17:24:33.116299	present	2026-03-02 15:43:44.318533
5939	85	2026-01-30	2026-01-30 09:05:51.975656	2026-01-30 17:01:37.984669	present	2026-03-02 15:43:44.318533
5940	88	2026-01-30	2026-01-30 09:58:58.457538	2026-01-30 17:59:42.577358	present	2026-03-02 15:43:44.318533
5941	89	2026-01-30	2026-01-30 09:27:13.053673	2026-01-30 17:02:45.563958	present	2026-03-02 15:43:44.318533
5942	96	2026-01-30	2026-01-30 09:39:52.688101	2026-01-30 17:26:14.66534	present	2026-03-02 15:43:44.318533
5943	97	2026-01-30	2026-01-30 09:14:02.723344	2026-01-30 17:53:39.326083	present	2026-03-02 15:43:44.318533
5944	1	2026-01-30	2026-01-30 09:30:00.146547	2026-01-30 17:11:30.895044	present	2026-03-02 15:43:44.318533
5945	2	2026-01-30	2026-01-30 09:54:29.021486	2026-01-30 17:31:08.906487	present	2026-03-02 15:43:44.318533
5946	7	2026-01-30	2026-01-30 09:45:52.762705	2026-01-30 17:35:32.623937	present	2026-03-02 15:43:44.318533
5947	8	2026-01-30	2026-01-30 09:54:22.478996	2026-01-30 17:38:04.011336	present	2026-03-02 15:43:44.318533
5948	9	2026-01-30	2026-01-30 09:28:25.662432	2026-01-30 17:29:12.125162	present	2026-03-02 15:43:44.318533
5949	12	2026-01-30	2026-01-30 09:31:06.386104	2026-01-30 17:49:16.257188	present	2026-03-02 15:43:44.318533
5950	13	2026-01-30	2026-01-30 09:51:12.910959	2026-01-30 17:05:18.559348	present	2026-03-02 15:43:44.318533
5951	14	2026-01-30	2026-01-30 09:11:42.744555	2026-01-30 17:34:43.113794	present	2026-03-02 15:43:44.318533
5952	15	2026-01-30	2026-01-30 09:49:01.535652	2026-01-30 17:25:15.77999	present	2026-03-02 15:43:44.318533
5953	16	2026-01-30	2026-01-30 09:43:24.593426	2026-01-30 17:55:24.220666	present	2026-03-02 15:43:44.318533
5954	17	2026-01-30	2026-01-30 09:20:26.12081	2026-01-30 17:56:07.585916	present	2026-03-02 15:43:44.318533
5955	18	2026-01-30	2026-01-30 09:49:56.146758	2026-01-30 17:03:15.344526	present	2026-03-02 15:43:44.318533
5956	19	2026-01-30	2026-01-30 09:16:23.178844	2026-01-30 17:26:53.335278	present	2026-03-02 15:43:44.318533
5957	20	2026-01-30	2026-01-30 09:56:04.182723	2026-01-30 17:45:09.080693	present	2026-03-02 15:43:44.318533
5958	21	2026-01-30	2026-01-30 09:34:37.31901	2026-01-30 17:16:08.624756	present	2026-03-02 15:43:44.318533
5959	22	2026-01-30	2026-01-30 09:21:15.896003	2026-01-30 17:22:26.965639	present	2026-03-02 15:43:44.318533
5960	23	2026-01-30	2026-01-30 09:56:25.629129	2026-01-30 17:08:43.074041	present	2026-03-02 15:43:44.318533
5961	24	2026-01-30	2026-01-30 09:17:40.775308	2026-01-30 17:37:08.753398	present	2026-03-02 15:43:44.318533
5962	25	2026-01-30	2026-01-30 09:26:42.656804	2026-01-30 17:51:29.538027	present	2026-03-02 15:43:44.318533
5963	26	2026-01-30	2026-01-30 09:36:47.667478	2026-01-30 17:45:30.24431	present	2026-03-02 15:43:44.318533
5964	28	2026-01-30	2026-01-30 09:48:16.010453	2026-01-30 17:41:27.122069	present	2026-03-02 15:43:44.318533
5965	29	2026-01-30	2026-01-30 09:04:34.129788	2026-01-30 17:12:18.547971	present	2026-03-02 15:43:44.318533
5966	30	2026-01-30	2026-01-30 09:55:19.018906	2026-01-30 17:17:50.464049	present	2026-03-02 15:43:44.318533
5967	31	2026-01-30	2026-01-30 09:23:38.979923	2026-01-30 17:46:19.909915	present	2026-03-02 15:43:44.318533
5968	32	2026-01-30	2026-01-30 09:07:39.29355	2026-01-30 17:30:36.273751	present	2026-03-02 15:43:44.318533
5969	34	2026-01-30	2026-01-30 09:24:31.795329	2026-01-30 17:46:25.24436	present	2026-03-02 15:43:44.318533
5970	36	2026-01-30	2026-01-30 09:20:14.89052	2026-01-30 17:31:56.895143	present	2026-03-02 15:43:44.318533
5971	38	2026-01-30	2026-01-30 09:22:02.936902	2026-01-30 17:46:44.599486	present	2026-03-02 15:43:44.318533
5972	39	2026-01-30	2026-01-30 09:58:44.190465	2026-01-30 17:22:26.883942	present	2026-03-02 15:43:44.318533
5973	40	2026-01-30	2026-01-30 09:40:45.8371	2026-01-30 17:54:32.960033	present	2026-03-02 15:43:44.318533
5974	41	2026-01-30	2026-01-30 09:48:14.267798	2026-01-30 17:53:49.341528	present	2026-03-02 15:43:44.318533
5975	42	2026-01-30	2026-01-30 09:40:00.813109	2026-01-30 17:11:14.237459	present	2026-03-02 15:43:44.318533
5976	44	2026-01-30	2026-01-30 09:19:15.629064	2026-01-30 17:40:43.13246	present	2026-03-02 15:43:44.318533
5977	49	2026-01-30	2026-01-30 09:29:02.175929	2026-01-30 17:56:16.510332	present	2026-03-02 15:43:44.318533
5978	51	2026-01-30	2026-01-30 09:23:08.961629	2026-01-30 17:48:36.518021	present	2026-03-02 15:43:44.318533
5979	53	2026-01-30	2026-01-30 09:43:28.398528	2026-01-30 17:53:56.729001	present	2026-03-02 15:43:44.318533
5980	54	2026-01-30	2026-01-30 09:40:40.118878	2026-01-30 17:22:04.75086	present	2026-03-02 15:43:44.318533
5981	55	2026-01-30	2026-01-30 09:10:39.724165	2026-01-30 17:32:43.466375	present	2026-03-02 15:43:44.318533
5982	56	2026-01-30	2026-01-30 09:05:43.521143	2026-01-30 17:08:18.042325	present	2026-03-02 15:43:44.318533
5983	57	2026-01-30	2026-01-30 09:07:58.072094	2026-01-30 17:08:22.480406	present	2026-03-02 15:43:44.318533
5984	58	2026-01-30	2026-01-30 09:07:18.48054	2026-01-30 17:45:21.206766	present	2026-03-02 15:43:44.318533
5985	61	2026-01-30	2026-01-30 09:21:23.975871	2026-01-30 17:58:55.004945	present	2026-03-02 15:43:44.318533
5986	67	2026-01-30	2026-01-30 09:43:45.840787	2026-01-30 17:45:39.97583	present	2026-03-02 15:43:44.318533
5987	68	2026-01-30	2026-01-30 09:49:24.912744	2026-01-30 17:50:16.967478	present	2026-03-02 15:43:44.318533
5988	69	2026-01-30	2026-01-30 09:39:35.68426	2026-01-30 17:19:38.079715	present	2026-03-02 15:43:44.318533
5989	72	2026-01-30	2026-01-30 09:26:08.861742	2026-01-30 17:01:56.253829	present	2026-03-02 15:43:44.318533
5990	75	2026-01-30	2026-01-30 09:07:45.74767	2026-01-30 17:12:17.449199	present	2026-03-02 15:43:44.318533
5991	76	2026-01-30	2026-01-30 09:25:27.575575	2026-01-30 17:02:26.349047	present	2026-03-02 15:43:44.318533
5992	77	2026-01-30	2026-01-30 09:08:00.599242	2026-01-30 17:50:38.209019	present	2026-03-02 15:43:44.318533
5993	80	2026-01-30	2026-01-30 09:46:55.063354	2026-01-30 17:58:14.90511	present	2026-03-02 15:43:44.318533
5994	81	2026-01-30	2026-01-30 09:11:28.691228	2026-01-30 17:53:06.613013	present	2026-03-02 15:43:44.318533
5995	86	2026-01-30	2026-01-30 09:32:31.648944	2026-01-30 17:12:35.270931	present	2026-03-02 15:43:44.318533
5996	87	2026-01-30	2026-01-30 09:23:24.301436	2026-01-30 17:40:41.578601	present	2026-03-02 15:43:44.318533
5997	90	2026-01-30	2026-01-30 09:27:58.634259	2026-01-30 17:14:00.579946	present	2026-03-02 15:43:44.318533
5998	91	2026-01-30	2026-01-30 09:47:20.429237	2026-01-30 17:12:55.14936	present	2026-03-02 15:43:44.318533
5999	92	2026-01-30	2026-01-30 09:38:48.861667	2026-01-30 17:20:07.329554	present	2026-03-02 15:43:44.318533
6000	93	2026-01-30	2026-01-30 09:17:10.380197	2026-01-30 17:53:52.015569	present	2026-03-02 15:43:44.318533
6001	94	2026-01-30	2026-01-30 09:06:10.816512	2026-01-30 17:26:32.880512	present	2026-03-02 15:43:44.318533
6002	95	2026-01-30	2026-01-30 09:45:52.291685	2026-01-30 17:02:41.121828	present	2026-03-02 15:43:44.318533
6003	98	2026-01-30	2026-01-30 09:07:05.27202	2026-01-30 17:49:33.911615	present	2026-03-02 15:43:44.318533
6004	99	2026-01-30	2026-01-30 09:26:30.125966	2026-01-30 17:08:03.482863	present	2026-03-02 15:43:44.318533
6005	100	2026-01-30	2026-01-30 09:25:20.422813	2026-01-30 17:28:42.698069	present	2026-03-02 15:43:44.318533
6006	3	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6007	4	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6008	5	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6009	6	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6010	10	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6011	11	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6012	27	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6013	33	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6014	35	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6015	37	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6016	43	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6017	45	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6018	46	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6019	47	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6020	48	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6021	50	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6022	52	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6023	59	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6024	60	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6025	62	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6026	63	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6027	64	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6028	65	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6029	66	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6030	70	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6031	71	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6032	73	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6033	74	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6034	78	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6035	79	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6036	82	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6037	83	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6038	84	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6039	85	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6040	88	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6041	89	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6042	96	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6043	97	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6044	1	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6045	2	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6046	7	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6047	8	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6048	9	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6049	12	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6050	13	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6051	14	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6052	15	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6053	16	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6054	17	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6055	18	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6056	19	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6057	20	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6058	21	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6059	22	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6060	23	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6061	24	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6062	25	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6063	26	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6064	28	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6065	29	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6066	30	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6067	31	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6068	32	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6069	34	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6070	36	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6071	38	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6072	39	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6073	40	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6074	41	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6075	42	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6076	44	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6077	49	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6078	51	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6079	53	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6080	54	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6081	55	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6082	56	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6083	57	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6084	58	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6085	61	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6086	67	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6087	68	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6088	69	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6089	72	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6090	75	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6091	76	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6092	77	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6093	80	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6094	81	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6095	86	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6096	87	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6097	90	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6098	91	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6099	92	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6100	93	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6101	94	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6102	95	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6103	98	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6104	99	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6105	100	2026-01-31	\N	\N	absent	2026-03-02 15:43:44.318533
6106	3	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6107	4	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6108	5	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6109	6	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6110	10	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6111	11	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6112	27	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6113	33	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6114	35	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6115	37	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6116	43	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6117	45	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6118	46	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6119	47	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6120	48	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6121	50	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6122	52	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6123	59	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6124	60	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6125	62	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6126	63	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6127	64	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6128	65	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6129	66	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6130	70	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6131	71	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6132	73	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6133	74	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6134	78	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6135	79	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6136	82	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6137	83	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6138	84	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6139	85	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6140	88	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6141	89	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6142	96	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6143	97	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6144	1	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6145	2	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6146	7	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6147	8	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6148	9	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6149	12	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6150	13	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6151	14	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6152	15	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6153	16	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6154	17	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6155	18	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6156	19	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6157	20	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6158	21	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6159	22	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6160	23	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6161	24	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6162	25	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6163	26	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6164	28	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6165	29	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6166	30	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6167	31	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6168	32	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6169	34	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6170	36	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6171	38	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6172	39	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6173	40	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6174	41	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6175	42	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6176	44	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6177	49	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6178	51	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6179	53	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6180	54	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6181	55	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6182	56	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6183	57	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6184	58	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6185	61	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6186	67	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6187	68	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6188	69	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6189	72	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6190	75	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6191	76	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6192	77	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6193	80	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6194	81	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6195	86	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6196	87	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6197	90	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6198	91	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6199	92	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6200	93	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6201	94	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6202	95	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6203	98	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6204	99	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6205	100	2026-02-01	\N	\N	absent	2026-03-02 15:43:44.318533
6206	3	2026-02-02	2026-02-02 09:12:55.936031	2026-02-02 17:49:27.273264	present	2026-03-02 15:43:44.318533
6207	4	2026-02-02	2026-02-02 09:14:50.218505	2026-02-02 17:45:57.64261	present	2026-03-02 15:43:44.318533
6208	5	2026-02-02	2026-02-02 09:11:36.226694	2026-02-02 17:51:59.878001	present	2026-03-02 15:43:44.318533
6209	6	2026-02-02	2026-02-02 09:27:26.930189	2026-02-02 17:22:06.419225	present	2026-03-02 15:43:44.318533
6210	10	2026-02-02	2026-02-02 09:42:57.472532	2026-02-02 17:27:28.020485	present	2026-03-02 15:43:44.318533
6211	11	2026-02-02	2026-02-02 09:00:38.468153	2026-02-02 17:23:06.278343	present	2026-03-02 15:43:44.318533
6212	27	2026-02-02	2026-02-02 09:05:28.72049	2026-02-02 17:29:47.565084	present	2026-03-02 15:43:44.318533
6213	33	2026-02-02	2026-02-02 09:50:02.689959	2026-02-02 17:56:42.268773	present	2026-03-02 15:43:44.318533
6214	35	2026-02-02	2026-02-02 09:30:59.5492	2026-02-02 17:53:39.207963	present	2026-03-02 15:43:44.318533
6215	37	2026-02-02	2026-02-02 09:41:22.050311	2026-02-02 17:40:47.78941	present	2026-03-02 15:43:44.318533
6216	43	2026-02-02	2026-02-02 09:16:22.67114	2026-02-02 17:32:56.378749	present	2026-03-02 15:43:44.318533
6217	45	2026-02-02	2026-02-02 09:43:06.140207	2026-02-02 17:20:37.507325	present	2026-03-02 15:43:44.318533
6218	46	2026-02-02	2026-02-02 09:50:44.842387	2026-02-02 17:14:46.849564	present	2026-03-02 15:43:44.318533
6219	47	2026-02-02	2026-02-02 09:57:35.173495	2026-02-02 17:18:19.460513	present	2026-03-02 15:43:44.318533
6220	48	2026-02-02	2026-02-02 09:35:24.376768	2026-02-02 17:26:02.53615	present	2026-03-02 15:43:44.318533
6221	50	2026-02-02	2026-02-02 09:33:49.351586	2026-02-02 17:35:58.118385	present	2026-03-02 15:43:44.318533
6222	52	2026-02-02	2026-02-02 09:16:37.64849	2026-02-02 17:04:05.539397	present	2026-03-02 15:43:44.318533
6223	59	2026-02-02	2026-02-02 09:56:18.657028	2026-02-02 17:01:52.376066	present	2026-03-02 15:43:44.318533
6224	60	2026-02-02	2026-02-02 09:23:27.463411	2026-02-02 17:14:23.126581	present	2026-03-02 15:43:44.318533
6225	62	2026-02-02	2026-02-02 09:16:31.270082	2026-02-02 17:45:21.295173	present	2026-03-02 15:43:44.318533
6226	63	2026-02-02	2026-02-02 09:47:24.705466	2026-02-02 17:31:34.596501	present	2026-03-02 15:43:44.318533
6227	64	2026-02-02	2026-02-02 09:04:46.162898	2026-02-02 17:05:56.954911	present	2026-03-02 15:43:44.318533
6228	65	2026-02-02	2026-02-02 09:35:21.212652	2026-02-02 17:17:57.61556	present	2026-03-02 15:43:44.318533
6229	66	2026-02-02	2026-02-02 09:57:09.034098	2026-02-02 17:39:00.442781	present	2026-03-02 15:43:44.318533
6230	70	2026-02-02	2026-02-02 09:14:43.813731	2026-02-02 17:37:12.478236	present	2026-03-02 15:43:44.318533
6231	71	2026-02-02	2026-02-02 09:36:01.580482	2026-02-02 17:13:14.837061	present	2026-03-02 15:43:44.318533
6232	73	2026-02-02	2026-02-02 09:52:46.044124	2026-02-02 17:01:36.811182	present	2026-03-02 15:43:44.318533
6233	74	2026-02-02	2026-02-02 09:29:55.045407	2026-02-02 17:52:59.951699	present	2026-03-02 15:43:44.318533
6234	78	2026-02-02	2026-02-02 09:06:02.612931	2026-02-02 17:28:10.062486	present	2026-03-02 15:43:44.318533
6235	79	2026-02-02	2026-02-02 09:15:25.917224	2026-02-02 17:05:43.64592	present	2026-03-02 15:43:44.318533
6236	82	2026-02-02	2026-02-02 09:27:46.583507	2026-02-02 17:23:42.128109	present	2026-03-02 15:43:44.318533
6237	83	2026-02-02	2026-02-02 09:59:10.232722	2026-02-02 17:54:47.201929	present	2026-03-02 15:43:44.318533
6238	84	2026-02-02	2026-02-02 09:07:11.818405	2026-02-02 17:03:41.901206	present	2026-03-02 15:43:44.318533
6239	85	2026-02-02	2026-02-02 09:59:56.359902	2026-02-02 17:32:56.873385	present	2026-03-02 15:43:44.318533
6240	88	2026-02-02	2026-02-02 09:28:10.539087	2026-02-02 17:05:16.157006	present	2026-03-02 15:43:44.318533
6241	89	2026-02-02	2026-02-02 09:26:02.113128	2026-02-02 17:14:56.849329	present	2026-03-02 15:43:44.318533
6242	96	2026-02-02	2026-02-02 09:48:16.459407	2026-02-02 17:49:08.004389	present	2026-03-02 15:43:44.318533
6243	97	2026-02-02	2026-02-02 09:29:17.443593	2026-02-02 17:56:18.545602	present	2026-03-02 15:43:44.318533
6244	1	2026-02-02	2026-02-02 09:44:05.555222	2026-02-02 17:25:13.901368	present	2026-03-02 15:43:44.318533
6245	2	2026-02-02	2026-02-02 09:45:38.931261	2026-02-02 17:36:19.794804	present	2026-03-02 15:43:44.318533
6246	7	2026-02-02	2026-02-02 09:59:22.274376	2026-02-02 17:00:22.543515	present	2026-03-02 15:43:44.318533
6247	8	2026-02-02	2026-02-02 09:13:58.367726	2026-02-02 17:02:40.842168	present	2026-03-02 15:43:44.318533
6248	9	2026-02-02	2026-02-02 09:28:24.816609	2026-02-02 17:29:00.173918	present	2026-03-02 15:43:44.318533
6249	12	2026-02-02	2026-02-02 09:09:55.444526	2026-02-02 17:36:33.739267	present	2026-03-02 15:43:44.318533
6250	13	2026-02-02	2026-02-02 09:56:12.226168	2026-02-02 17:34:51.954174	present	2026-03-02 15:43:44.318533
6251	14	2026-02-02	2026-02-02 09:41:12.581743	2026-02-02 17:26:42.987207	present	2026-03-02 15:43:44.318533
6252	15	2026-02-02	2026-02-02 09:01:44.67024	2026-02-02 17:46:27.289984	present	2026-03-02 15:43:44.318533
6253	16	2026-02-02	2026-02-02 09:06:16.688844	2026-02-02 17:53:09.488658	present	2026-03-02 15:43:44.318533
6254	17	2026-02-02	2026-02-02 09:31:57.330816	2026-02-02 17:45:19.043705	present	2026-03-02 15:43:44.318533
6255	18	2026-02-02	2026-02-02 09:41:27.359218	2026-02-02 17:55:12.952551	present	2026-03-02 15:43:44.318533
6256	19	2026-02-02	2026-02-02 09:21:27.603756	2026-02-02 17:52:44.848489	present	2026-03-02 15:43:44.318533
6257	20	2026-02-02	2026-02-02 09:44:09.385606	2026-02-02 17:31:53.404649	present	2026-03-02 15:43:44.318533
6258	21	2026-02-02	2026-02-02 09:20:07.430183	2026-02-02 17:29:00.137578	present	2026-03-02 15:43:44.318533
6259	22	2026-02-02	2026-02-02 09:33:02.661925	2026-02-02 17:29:35.138579	present	2026-03-02 15:43:44.318533
6260	23	2026-02-02	2026-02-02 09:58:18.746369	2026-02-02 17:28:15.433077	present	2026-03-02 15:43:44.318533
6261	24	2026-02-02	2026-02-02 09:29:13.648965	2026-02-02 17:17:22.029843	present	2026-03-02 15:43:44.318533
6262	25	2026-02-02	2026-02-02 09:57:27.434009	2026-02-02 17:06:48.604228	present	2026-03-02 15:43:44.318533
6263	26	2026-02-02	2026-02-02 09:16:33.630566	2026-02-02 17:21:41.760565	present	2026-03-02 15:43:44.318533
6264	28	2026-02-02	2026-02-02 09:35:55.916552	2026-02-02 17:48:51.201552	present	2026-03-02 15:43:44.318533
6265	29	2026-02-02	2026-02-02 09:56:16.803947	2026-02-02 17:13:44.303137	present	2026-03-02 15:43:44.318533
6266	30	2026-02-02	2026-02-02 09:49:06.824564	2026-02-02 17:50:10.442641	present	2026-03-02 15:43:44.318533
6267	31	2026-02-02	2026-02-02 09:04:22.727708	2026-02-02 17:01:47.265717	present	2026-03-02 15:43:44.318533
6268	32	2026-02-02	2026-02-02 09:18:50.642983	2026-02-02 17:06:24.055374	present	2026-03-02 15:43:44.318533
6269	34	2026-02-02	2026-02-02 09:04:25.301892	2026-02-02 17:13:26.440567	present	2026-03-02 15:43:44.318533
6270	36	2026-02-02	2026-02-02 09:04:27.404322	2026-02-02 17:21:13.46651	present	2026-03-02 15:43:44.318533
6271	38	2026-02-02	2026-02-02 09:27:07.268245	2026-02-02 17:49:18.460548	present	2026-03-02 15:43:44.318533
6272	39	2026-02-02	2026-02-02 09:35:51.886477	2026-02-02 17:06:58.632187	present	2026-03-02 15:43:44.318533
6273	40	2026-02-02	2026-02-02 09:54:50.525527	2026-02-02 17:58:11.129783	present	2026-03-02 15:43:44.318533
6274	41	2026-02-02	2026-02-02 09:43:05.095526	2026-02-02 17:13:51.916419	present	2026-03-02 15:43:44.318533
6275	42	2026-02-02	2026-02-02 09:45:18.349493	2026-02-02 17:13:17.171971	present	2026-03-02 15:43:44.318533
6276	44	2026-02-02	2026-02-02 09:41:00.829514	2026-02-02 17:30:46.24954	present	2026-03-02 15:43:44.318533
6277	49	2026-02-02	2026-02-02 09:19:50.676563	2026-02-02 17:55:09.496226	present	2026-03-02 15:43:44.318533
6278	51	2026-02-02	2026-02-02 09:52:27.610801	2026-02-02 17:16:46.490329	present	2026-03-02 15:43:44.318533
6279	53	2026-02-02	2026-02-02 09:44:18.763731	2026-02-02 17:31:33.359361	present	2026-03-02 15:43:44.318533
6280	54	2026-02-02	2026-02-02 09:48:16.204436	2026-02-02 17:17:34.334743	present	2026-03-02 15:43:44.318533
6281	55	2026-02-02	2026-02-02 09:03:12.697998	2026-02-02 17:27:16.720122	present	2026-03-02 15:43:44.318533
6282	56	2026-02-02	2026-02-02 09:56:51.313209	2026-02-02 17:14:28.553538	present	2026-03-02 15:43:44.318533
6283	57	2026-02-02	2026-02-02 09:27:55.183766	2026-02-02 17:48:41.501222	present	2026-03-02 15:43:44.318533
6284	58	2026-02-02	2026-02-02 09:47:02.078746	2026-02-02 17:35:30.005247	present	2026-03-02 15:43:44.318533
6285	61	2026-02-02	2026-02-02 09:38:01.36757	2026-02-02 17:59:25.242036	present	2026-03-02 15:43:44.318533
6286	67	2026-02-02	2026-02-02 09:58:25.216929	2026-02-02 17:53:12.755695	present	2026-03-02 15:43:44.318533
6287	68	2026-02-02	2026-02-02 09:07:47.697209	2026-02-02 17:58:35.50833	present	2026-03-02 15:43:44.318533
6288	69	2026-02-02	2026-02-02 09:24:30.920829	2026-02-02 17:50:33.765256	present	2026-03-02 15:43:44.318533
6289	72	2026-02-02	2026-02-02 09:11:20.255835	2026-02-02 17:12:32.427084	present	2026-03-02 15:43:44.318533
6290	75	2026-02-02	2026-02-02 09:46:06.493961	2026-02-02 17:58:52.472226	present	2026-03-02 15:43:44.318533
6291	76	2026-02-02	2026-02-02 09:54:55.715521	2026-02-02 17:02:45.071401	present	2026-03-02 15:43:44.318533
6292	77	2026-02-02	2026-02-02 09:55:43.305009	2026-02-02 17:54:06.07007	present	2026-03-02 15:43:44.318533
6293	80	2026-02-02	2026-02-02 09:58:36.15991	2026-02-02 17:46:33.31036	present	2026-03-02 15:43:44.318533
6294	81	2026-02-02	2026-02-02 09:25:49.992675	2026-02-02 17:19:20.543129	present	2026-03-02 15:43:44.318533
6295	86	2026-02-02	2026-02-02 09:05:37.587533	2026-02-02 17:52:49.509553	present	2026-03-02 15:43:44.318533
6296	87	2026-02-02	2026-02-02 09:21:37.766183	2026-02-02 17:35:10.442146	present	2026-03-02 15:43:44.318533
6297	90	2026-02-02	2026-02-02 09:46:49.673498	2026-02-02 17:32:15.66599	present	2026-03-02 15:43:44.318533
6298	91	2026-02-02	2026-02-02 09:20:16.80367	2026-02-02 17:21:09.774569	present	2026-03-02 15:43:44.318533
6299	92	2026-02-02	2026-02-02 09:54:07.318946	2026-02-02 17:41:07.540804	present	2026-03-02 15:43:44.318533
6300	93	2026-02-02	2026-02-02 09:52:51.81729	2026-02-02 17:01:50.866314	present	2026-03-02 15:43:44.318533
6301	94	2026-02-02	2026-02-02 09:12:18.113792	2026-02-02 17:45:30.809695	present	2026-03-02 15:43:44.318533
6302	95	2026-02-02	2026-02-02 09:42:38.24961	2026-02-02 17:55:35.960183	present	2026-03-02 15:43:44.318533
6303	98	2026-02-02	2026-02-02 09:33:04.891024	2026-02-02 17:32:49.186397	present	2026-03-02 15:43:44.318533
6304	99	2026-02-02	2026-02-02 09:08:18.045737	2026-02-02 17:01:43.970889	present	2026-03-02 15:43:44.318533
6305	100	2026-02-02	2026-02-02 09:55:09.907918	2026-02-02 17:36:55.435498	present	2026-03-02 15:43:44.318533
6306	3	2026-02-03	2026-02-03 09:20:45.157402	2026-02-03 17:56:46.45268	present	2026-03-02 15:43:44.318533
6307	4	2026-02-03	2026-02-03 09:02:50.762566	2026-02-03 17:52:33.436784	present	2026-03-02 15:43:44.318533
6308	5	2026-02-03	2026-02-03 09:06:04.667052	2026-02-03 17:36:34.089363	present	2026-03-02 15:43:44.318533
6309	6	2026-02-03	2026-02-03 09:15:39.385852	2026-02-03 17:51:22.796347	present	2026-03-02 15:43:44.318533
6310	10	2026-02-03	2026-02-03 09:36:04.393642	2026-02-03 17:08:25.420069	present	2026-03-02 15:43:44.318533
6311	11	2026-02-03	2026-02-03 09:48:26.892947	2026-02-03 17:22:01.669977	present	2026-03-02 15:43:44.318533
6312	27	2026-02-03	2026-02-03 09:53:31.177813	2026-02-03 17:22:21.873806	present	2026-03-02 15:43:44.318533
6313	33	2026-02-03	2026-02-03 09:27:44.511508	2026-02-03 17:18:43.94782	present	2026-03-02 15:43:44.318533
6314	35	2026-02-03	2026-02-03 09:08:35.342118	2026-02-03 17:31:41.410227	present	2026-03-02 15:43:44.318533
6315	37	2026-02-03	2026-02-03 09:10:29.036558	2026-02-03 17:38:15.920598	present	2026-03-02 15:43:44.318533
6316	43	2026-02-03	2026-02-03 09:15:09.320446	2026-02-03 17:32:24.962033	present	2026-03-02 15:43:44.318533
6317	45	2026-02-03	2026-02-03 09:49:41.149477	2026-02-03 17:08:53.558232	present	2026-03-02 15:43:44.318533
6318	46	2026-02-03	2026-02-03 09:13:58.657526	2026-02-03 17:55:37.138902	present	2026-03-02 15:43:44.318533
6319	47	2026-02-03	2026-02-03 09:09:30.895246	2026-02-03 17:58:19.658551	present	2026-03-02 15:43:44.318533
6320	48	2026-02-03	2026-02-03 09:33:45.542228	2026-02-03 17:10:57.156723	present	2026-03-02 15:43:44.318533
6321	50	2026-02-03	2026-02-03 09:30:28.645812	2026-02-03 17:25:18.896697	present	2026-03-02 15:43:44.318533
6322	52	2026-02-03	2026-02-03 09:55:47.912572	2026-02-03 17:33:43.658762	present	2026-03-02 15:43:44.318533
6323	59	2026-02-03	2026-02-03 09:37:07.820461	2026-02-03 17:17:44.209144	present	2026-03-02 15:43:44.318533
6324	60	2026-02-03	2026-02-03 09:43:12.747702	2026-02-03 17:05:39.385674	present	2026-03-02 15:43:44.318533
6325	62	2026-02-03	2026-02-03 09:25:12.63257	2026-02-03 17:19:42.624715	present	2026-03-02 15:43:44.318533
6326	63	2026-02-03	2026-02-03 09:10:41.28447	2026-02-03 17:14:37.137077	present	2026-03-02 15:43:44.318533
6327	64	2026-02-03	2026-02-03 09:58:59.361267	2026-02-03 17:43:43.397664	present	2026-03-02 15:43:44.318533
6328	65	2026-02-03	2026-02-03 09:29:55.464754	2026-02-03 17:24:02.755434	present	2026-03-02 15:43:44.318533
6329	66	2026-02-03	2026-02-03 09:23:32.996515	2026-02-03 17:32:57.410836	present	2026-03-02 15:43:44.318533
6330	70	2026-02-03	2026-02-03 09:42:01.485653	2026-02-03 17:43:19.123749	present	2026-03-02 15:43:44.318533
6331	71	2026-02-03	2026-02-03 09:34:09.060645	2026-02-03 17:40:23.297969	present	2026-03-02 15:43:44.318533
6332	73	2026-02-03	2026-02-03 09:32:48.571767	2026-02-03 17:04:25.367119	present	2026-03-02 15:43:44.318533
6333	74	2026-02-03	2026-02-03 09:52:04.831787	2026-02-03 17:50:49.764108	present	2026-03-02 15:43:44.318533
6334	78	2026-02-03	2026-02-03 09:32:32.178666	2026-02-03 17:31:49.309655	present	2026-03-02 15:43:44.318533
6335	79	2026-02-03	2026-02-03 09:05:28.453561	2026-02-03 17:00:35.04318	present	2026-03-02 15:43:44.318533
6336	82	2026-02-03	2026-02-03 09:38:14.704563	2026-02-03 17:16:09.349833	present	2026-03-02 15:43:44.318533
6337	83	2026-02-03	2026-02-03 09:20:44.200339	2026-02-03 17:58:49.686255	present	2026-03-02 15:43:44.318533
6338	84	2026-02-03	2026-02-03 09:24:40.603932	2026-02-03 17:30:37.508967	present	2026-03-02 15:43:44.318533
6339	85	2026-02-03	2026-02-03 09:31:22.873359	2026-02-03 17:01:24.736852	present	2026-03-02 15:43:44.318533
6340	88	2026-02-03	2026-02-03 09:02:02.596643	2026-02-03 17:19:19.801065	present	2026-03-02 15:43:44.318533
6341	89	2026-02-03	2026-02-03 09:54:26.969243	2026-02-03 17:26:31.015688	present	2026-03-02 15:43:44.318533
6342	96	2026-02-03	2026-02-03 09:27:59.970781	2026-02-03 17:15:16.442748	present	2026-03-02 15:43:44.318533
6343	97	2026-02-03	2026-02-03 09:17:03.888136	2026-02-03 17:43:34.879567	present	2026-03-02 15:43:44.318533
6344	1	2026-02-03	2026-02-03 09:27:45.865862	2026-02-03 17:02:01.873394	present	2026-03-02 15:43:44.318533
6345	2	2026-02-03	2026-02-03 09:19:26.490101	2026-02-03 17:08:02.514211	present	2026-03-02 15:43:44.318533
6346	7	2026-02-03	2026-02-03 09:15:12.166988	2026-02-03 17:31:54.63003	present	2026-03-02 15:43:44.318533
6347	8	2026-02-03	2026-02-03 09:04:19.823321	2026-02-03 17:13:55.626227	present	2026-03-02 15:43:44.318533
6348	9	2026-02-03	2026-02-03 09:35:42.498986	2026-02-03 17:02:59.037439	present	2026-03-02 15:43:44.318533
6349	12	2026-02-03	2026-02-03 09:55:34.463756	2026-02-03 17:05:44.422807	present	2026-03-02 15:43:44.318533
6350	13	2026-02-03	2026-02-03 09:45:12.61399	2026-02-03 17:15:15.913504	present	2026-03-02 15:43:44.318533
6351	14	2026-02-03	2026-02-03 09:05:11.955518	2026-02-03 17:46:11.444257	present	2026-03-02 15:43:44.318533
6352	15	2026-02-03	2026-02-03 09:04:47.428609	2026-02-03 17:49:26.08987	present	2026-03-02 15:43:44.318533
6353	16	2026-02-03	2026-02-03 09:38:19.232589	2026-02-03 17:52:52.984313	present	2026-03-02 15:43:44.318533
6354	17	2026-02-03	2026-02-03 09:38:01.210886	2026-02-03 17:55:05.479168	present	2026-03-02 15:43:44.318533
6355	18	2026-02-03	2026-02-03 09:10:18.837569	2026-02-03 17:47:56.958152	present	2026-03-02 15:43:44.318533
6356	19	2026-02-03	2026-02-03 09:45:23.251743	2026-02-03 17:46:12.960605	present	2026-03-02 15:43:44.318533
6357	20	2026-02-03	2026-02-03 09:14:56.44046	2026-02-03 17:02:03.798373	present	2026-03-02 15:43:44.318533
6358	21	2026-02-03	2026-02-03 09:02:21.53865	2026-02-03 17:58:29.638543	present	2026-03-02 15:43:44.318533
6359	22	2026-02-03	2026-02-03 09:42:36.600597	2026-02-03 17:57:39.287192	present	2026-03-02 15:43:44.318533
6360	23	2026-02-03	2026-02-03 09:26:20.002667	2026-02-03 17:06:30.985971	present	2026-03-02 15:43:44.318533
6361	24	2026-02-03	2026-02-03 09:25:59.297434	2026-02-03 17:04:59.761024	present	2026-03-02 15:43:44.318533
6362	25	2026-02-03	2026-02-03 09:53:31.640776	2026-02-03 17:02:45.343853	present	2026-03-02 15:43:44.318533
6363	26	2026-02-03	2026-02-03 09:11:45.389086	2026-02-03 17:55:52.277495	present	2026-03-02 15:43:44.318533
6364	28	2026-02-03	2026-02-03 09:30:43.620276	2026-02-03 17:17:16.132916	present	2026-03-02 15:43:44.318533
6365	29	2026-02-03	2026-02-03 09:29:09.980549	2026-02-03 17:44:53.357777	present	2026-03-02 15:43:44.318533
6366	30	2026-02-03	2026-02-03 09:03:21.498825	2026-02-03 17:37:03.38747	present	2026-03-02 15:43:44.318533
6367	31	2026-02-03	2026-02-03 09:35:20.802997	2026-02-03 17:15:21.027613	present	2026-03-02 15:43:44.318533
6368	32	2026-02-03	2026-02-03 09:10:11.5796	2026-02-03 17:06:49.42671	present	2026-03-02 15:43:44.318533
6369	34	2026-02-03	2026-02-03 09:22:51.478203	2026-02-03 17:05:48.135763	present	2026-03-02 15:43:44.318533
6370	36	2026-02-03	2026-02-03 09:37:41.632686	2026-02-03 17:48:14.607454	present	2026-03-02 15:43:44.318533
6371	38	2026-02-03	2026-02-03 09:46:25.323637	2026-02-03 17:03:27.486905	present	2026-03-02 15:43:44.318533
6372	39	2026-02-03	2026-02-03 09:50:21.891963	2026-02-03 17:30:39.610284	present	2026-03-02 15:43:44.318533
6373	40	2026-02-03	2026-02-03 09:13:36.845926	2026-02-03 17:45:58.402514	present	2026-03-02 15:43:44.318533
6374	41	2026-02-03	2026-02-03 09:20:31.097927	2026-02-03 17:30:06.671876	present	2026-03-02 15:43:44.318533
6375	42	2026-02-03	2026-02-03 09:31:27.418311	2026-02-03 17:33:43.688079	present	2026-03-02 15:43:44.318533
6376	44	2026-02-03	2026-02-03 09:57:40.490206	2026-02-03 17:49:47.202454	present	2026-03-02 15:43:44.318533
6377	49	2026-02-03	2026-02-03 09:31:44.207556	2026-02-03 17:37:44.905848	present	2026-03-02 15:43:44.318533
6378	51	2026-02-03	2026-02-03 09:42:42.497219	2026-02-03 17:10:06.06018	present	2026-03-02 15:43:44.318533
6379	53	2026-02-03	2026-02-03 09:37:08.607937	2026-02-03 17:23:38.503219	present	2026-03-02 15:43:44.318533
6380	54	2026-02-03	2026-02-03 09:07:10.381379	2026-02-03 17:19:05.752088	present	2026-03-02 15:43:44.318533
6381	55	2026-02-03	2026-02-03 09:15:44.538086	2026-02-03 17:41:08.482497	present	2026-03-02 15:43:44.318533
6382	56	2026-02-03	2026-02-03 09:30:03.28245	2026-02-03 17:36:37.320703	present	2026-03-02 15:43:44.318533
6383	57	2026-02-03	2026-02-03 09:41:07.01224	2026-02-03 17:23:21.074201	present	2026-03-02 15:43:44.318533
6384	58	2026-02-03	2026-02-03 09:08:55.373217	2026-02-03 17:08:36.284449	present	2026-03-02 15:43:44.318533
6385	61	2026-02-03	2026-02-03 09:38:08.877143	2026-02-03 17:23:37.886028	present	2026-03-02 15:43:44.318533
6386	67	2026-02-03	2026-02-03 09:18:17.954518	2026-02-03 17:28:40.806627	present	2026-03-02 15:43:44.318533
6387	68	2026-02-03	2026-02-03 09:26:49.586178	2026-02-03 17:44:30.803483	present	2026-03-02 15:43:44.318533
6388	69	2026-02-03	2026-02-03 09:11:37.397743	2026-02-03 17:31:28.614875	present	2026-03-02 15:43:44.318533
6389	72	2026-02-03	2026-02-03 09:11:14.906948	2026-02-03 17:08:40.511098	present	2026-03-02 15:43:44.318533
6390	75	2026-02-03	2026-02-03 09:16:08.26975	2026-02-03 17:19:34.948438	present	2026-03-02 15:43:44.318533
6391	76	2026-02-03	2026-02-03 09:31:56.443154	2026-02-03 17:39:39.192261	present	2026-03-02 15:43:44.318533
6392	77	2026-02-03	2026-02-03 09:49:00.138744	2026-02-03 17:23:19.635016	present	2026-03-02 15:43:44.318533
6393	80	2026-02-03	2026-02-03 09:15:43.539546	2026-02-03 17:30:17.678429	present	2026-03-02 15:43:44.318533
6394	81	2026-02-03	2026-02-03 09:50:23.815541	2026-02-03 17:58:51.57375	present	2026-03-02 15:43:44.318533
6395	86	2026-02-03	2026-02-03 09:55:29.906695	2026-02-03 17:11:21.853737	present	2026-03-02 15:43:44.318533
6396	87	2026-02-03	2026-02-03 09:55:19.723396	2026-02-03 17:25:17.752244	present	2026-03-02 15:43:44.318533
6397	90	2026-02-03	2026-02-03 09:33:28.364565	2026-02-03 17:17:23.535356	present	2026-03-02 15:43:44.318533
6398	91	2026-02-03	2026-02-03 09:02:26.703102	2026-02-03 17:08:51.441437	present	2026-03-02 15:43:44.318533
6399	92	2026-02-03	2026-02-03 09:47:46.767817	2026-02-03 17:24:19.664515	present	2026-03-02 15:43:44.318533
6400	93	2026-02-03	2026-02-03 09:09:39.775801	2026-02-03 17:39:37.087424	present	2026-03-02 15:43:44.318533
6401	94	2026-02-03	2026-02-03 09:13:30.400574	2026-02-03 17:15:10.714412	present	2026-03-02 15:43:44.318533
6402	95	2026-02-03	2026-02-03 09:49:55.369413	2026-02-03 17:47:04.99434	present	2026-03-02 15:43:44.318533
6403	98	2026-02-03	2026-02-03 09:30:48.536121	2026-02-03 17:38:18.522842	present	2026-03-02 15:43:44.318533
6404	99	2026-02-03	2026-02-03 09:40:23.383667	2026-02-03 17:20:53.029531	present	2026-03-02 15:43:44.318533
6405	100	2026-02-03	2026-02-03 09:00:27.80296	2026-02-03 17:22:39.362708	present	2026-03-02 15:43:44.318533
6406	3	2026-02-04	2026-02-04 09:27:42.69223	2026-02-04 17:19:46.702763	present	2026-03-02 15:43:44.318533
6407	4	2026-02-04	2026-02-04 09:02:45.422393	2026-02-04 17:27:55.98789	present	2026-03-02 15:43:44.318533
6408	5	2026-02-04	2026-02-04 09:23:16.714129	2026-02-04 17:15:22.331135	present	2026-03-02 15:43:44.318533
6409	6	2026-02-04	2026-02-04 09:08:17.13723	2026-02-04 17:33:59.522284	present	2026-03-02 15:43:44.318533
6410	10	2026-02-04	2026-02-04 09:53:50.020245	2026-02-04 17:03:04.069126	present	2026-03-02 15:43:44.318533
6411	11	2026-02-04	2026-02-04 09:50:58.835943	2026-02-04 17:48:13.835363	present	2026-03-02 15:43:44.318533
6412	27	2026-02-04	2026-02-04 09:04:54.63333	2026-02-04 17:54:24.186194	present	2026-03-02 15:43:44.318533
6413	33	2026-02-04	2026-02-04 09:45:33.006617	2026-02-04 17:15:41.005479	present	2026-03-02 15:43:44.318533
6414	35	2026-02-04	2026-02-04 09:02:49.576595	2026-02-04 17:00:04.052985	present	2026-03-02 15:43:44.318533
6415	37	2026-02-04	2026-02-04 09:06:50.780654	2026-02-04 17:00:56.624834	present	2026-03-02 15:43:44.318533
6416	43	2026-02-04	2026-02-04 09:24:08.513788	2026-02-04 17:24:54.441605	present	2026-03-02 15:43:44.318533
6417	45	2026-02-04	2026-02-04 09:50:04.086604	2026-02-04 17:05:51.467009	present	2026-03-02 15:43:44.318533
6418	46	2026-02-04	2026-02-04 09:24:07.919906	2026-02-04 17:04:49.535805	present	2026-03-02 15:43:44.318533
6419	47	2026-02-04	2026-02-04 09:10:54.751186	2026-02-04 17:47:47.554052	present	2026-03-02 15:43:44.318533
6420	48	2026-02-04	2026-02-04 09:44:45.386359	2026-02-04 17:49:27.575958	present	2026-03-02 15:43:44.318533
6421	50	2026-02-04	2026-02-04 09:39:57.87603	2026-02-04 17:56:15.378142	present	2026-03-02 15:43:44.318533
6422	52	2026-02-04	2026-02-04 09:26:49.161197	2026-02-04 17:40:31.703799	present	2026-03-02 15:43:44.318533
6423	59	2026-02-04	2026-02-04 09:09:23.952207	2026-02-04 17:19:07.506331	present	2026-03-02 15:43:44.318533
6424	60	2026-02-04	2026-02-04 09:41:59.82434	2026-02-04 17:14:32.03263	present	2026-03-02 15:43:44.318533
6425	62	2026-02-04	2026-02-04 09:57:42.84075	2026-02-04 17:25:57.652353	present	2026-03-02 15:43:44.318533
6426	63	2026-02-04	2026-02-04 09:35:49.249698	2026-02-04 17:14:49.415231	present	2026-03-02 15:43:44.318533
6427	64	2026-02-04	2026-02-04 09:14:15.749012	2026-02-04 17:06:17.291148	present	2026-03-02 15:43:44.318533
6428	65	2026-02-04	2026-02-04 09:13:12.055761	2026-02-04 17:07:38.261946	present	2026-03-02 15:43:44.318533
6429	66	2026-02-04	2026-02-04 09:51:02.785246	2026-02-04 17:33:22.047306	present	2026-03-02 15:43:44.318533
6430	70	2026-02-04	2026-02-04 09:17:33.680725	2026-02-04 17:20:17.387048	present	2026-03-02 15:43:44.318533
6431	71	2026-02-04	2026-02-04 09:52:45.136039	2026-02-04 17:05:55.55371	present	2026-03-02 15:43:44.318533
6432	73	2026-02-04	2026-02-04 09:03:42.067493	2026-02-04 17:34:21.0475	present	2026-03-02 15:43:44.318533
6433	74	2026-02-04	2026-02-04 09:25:15.43546	2026-02-04 17:07:03.501948	present	2026-03-02 15:43:44.318533
6434	78	2026-02-04	2026-02-04 09:33:14.867684	2026-02-04 17:41:56.88083	present	2026-03-02 15:43:44.318533
6435	79	2026-02-04	2026-02-04 09:57:13.587443	2026-02-04 17:57:00.606157	present	2026-03-02 15:43:44.318533
6436	82	2026-02-04	2026-02-04 09:29:08.435453	2026-02-04 17:39:09.752378	present	2026-03-02 15:43:44.318533
6437	83	2026-02-04	2026-02-04 09:51:14.399257	2026-02-04 17:20:25.857281	present	2026-03-02 15:43:44.318533
6438	84	2026-02-04	2026-02-04 09:43:52.315394	2026-02-04 17:47:44.020558	present	2026-03-02 15:43:44.318533
6439	85	2026-02-04	2026-02-04 09:33:12.07126	2026-02-04 17:17:48.542553	present	2026-03-02 15:43:44.318533
6440	88	2026-02-04	2026-02-04 09:01:37.478332	2026-02-04 17:13:38.734272	present	2026-03-02 15:43:44.318533
6441	89	2026-02-04	2026-02-04 09:42:28.122394	2026-02-04 17:22:08.19601	present	2026-03-02 15:43:44.318533
6442	96	2026-02-04	2026-02-04 09:30:40.333462	2026-02-04 17:05:11.538249	present	2026-03-02 15:43:44.318533
6443	97	2026-02-04	2026-02-04 09:30:38.972067	2026-02-04 17:37:20.039081	present	2026-03-02 15:43:44.318533
6444	1	2026-02-04	2026-02-04 09:37:48.169301	2026-02-04 17:25:00.944701	present	2026-03-02 15:43:44.318533
6445	2	2026-02-04	2026-02-04 09:12:53.695678	2026-02-04 17:25:07.865584	present	2026-03-02 15:43:44.318533
6446	7	2026-02-04	2026-02-04 09:05:41.125787	2026-02-04 17:09:05.936975	present	2026-03-02 15:43:44.318533
6447	8	2026-02-04	2026-02-04 09:36:45.877798	2026-02-04 17:04:31.520398	present	2026-03-02 15:43:44.318533
6448	9	2026-02-04	2026-02-04 09:57:12.549164	2026-02-04 17:16:19.537003	present	2026-03-02 15:43:44.318533
6449	12	2026-02-04	2026-02-04 09:40:16.651989	2026-02-04 17:17:37.46289	present	2026-03-02 15:43:44.318533
6450	13	2026-02-04	2026-02-04 09:49:31.399594	2026-02-04 17:55:23.203752	present	2026-03-02 15:43:44.318533
6451	14	2026-02-04	2026-02-04 09:28:53.730794	2026-02-04 17:22:17.45377	present	2026-03-02 15:43:44.318533
6452	15	2026-02-04	2026-02-04 09:24:08.548475	2026-02-04 17:41:58.941937	present	2026-03-02 15:43:44.318533
6453	16	2026-02-04	2026-02-04 09:17:33.116815	2026-02-04 17:09:07.701085	present	2026-03-02 15:43:44.318533
6454	17	2026-02-04	2026-02-04 09:14:16.229875	2026-02-04 17:36:59.269773	present	2026-03-02 15:43:44.318533
6455	18	2026-02-04	2026-02-04 09:04:39.075833	2026-02-04 17:25:41.560388	present	2026-03-02 15:43:44.318533
6456	19	2026-02-04	2026-02-04 09:01:38.212945	2026-02-04 17:16:17.932028	present	2026-03-02 15:43:44.318533
6457	20	2026-02-04	2026-02-04 09:22:25.542955	2026-02-04 17:13:03.176281	present	2026-03-02 15:43:44.318533
6458	21	2026-02-04	2026-02-04 09:04:10.235641	2026-02-04 17:25:42.1084	present	2026-03-02 15:43:44.318533
6459	22	2026-02-04	2026-02-04 09:47:39.146418	2026-02-04 17:33:15.780842	present	2026-03-02 15:43:44.318533
6460	23	2026-02-04	2026-02-04 09:55:07.197858	2026-02-04 17:53:34.601252	present	2026-03-02 15:43:44.318533
6461	24	2026-02-04	2026-02-04 09:47:17.600441	2026-02-04 17:28:50.094921	present	2026-03-02 15:43:44.318533
6462	25	2026-02-04	2026-02-04 09:48:09.785747	2026-02-04 17:14:45.544187	present	2026-03-02 15:43:44.318533
6463	26	2026-02-04	2026-02-04 09:15:33.407844	2026-02-04 17:21:23.383982	present	2026-03-02 15:43:44.318533
6464	28	2026-02-04	2026-02-04 09:34:14.091601	2026-02-04 17:06:37.717047	present	2026-03-02 15:43:44.318533
6465	29	2026-02-04	2026-02-04 09:02:33.907557	2026-02-04 17:33:20.898788	present	2026-03-02 15:43:44.318533
6466	30	2026-02-04	2026-02-04 09:30:51.17501	2026-02-04 17:55:56.998295	present	2026-03-02 15:43:44.318533
6467	31	2026-02-04	2026-02-04 09:22:39.937312	2026-02-04 17:39:40.735811	present	2026-03-02 15:43:44.318533
6468	32	2026-02-04	2026-02-04 09:02:04.285907	2026-02-04 17:12:00.420875	present	2026-03-02 15:43:44.318533
6469	34	2026-02-04	2026-02-04 09:27:12.478432	2026-02-04 17:16:09.416054	present	2026-03-02 15:43:44.318533
6470	36	2026-02-04	2026-02-04 09:00:35.235936	2026-02-04 17:26:18.412947	present	2026-03-02 15:43:44.318533
6471	38	2026-02-04	2026-02-04 09:30:58.426421	2026-02-04 17:46:32.989443	present	2026-03-02 15:43:44.318533
6472	39	2026-02-04	2026-02-04 09:11:20.249726	2026-02-04 17:35:39.821184	present	2026-03-02 15:43:44.318533
6473	40	2026-02-04	2026-02-04 09:44:21.497911	2026-02-04 17:11:29.112233	present	2026-03-02 15:43:44.318533
6474	41	2026-02-04	2026-02-04 09:32:10.453437	2026-02-04 17:30:59.505571	present	2026-03-02 15:43:44.318533
6475	42	2026-02-04	2026-02-04 09:15:38.69186	2026-02-04 17:20:21.12587	present	2026-03-02 15:43:44.318533
6476	44	2026-02-04	2026-02-04 09:22:09.104346	2026-02-04 17:07:56.984717	present	2026-03-02 15:43:44.318533
6477	49	2026-02-04	2026-02-04 09:53:52.217363	2026-02-04 17:37:41.294851	present	2026-03-02 15:43:44.318533
6478	51	2026-02-04	2026-02-04 09:46:14.767198	2026-02-04 17:59:36.164913	present	2026-03-02 15:43:44.318533
6479	53	2026-02-04	2026-02-04 09:00:29.405246	2026-02-04 17:46:37.558448	present	2026-03-02 15:43:44.318533
6480	54	2026-02-04	2026-02-04 09:18:43.846917	2026-02-04 17:29:00.053761	present	2026-03-02 15:43:44.318533
6481	55	2026-02-04	2026-02-04 09:26:07.900143	2026-02-04 17:13:42.888833	present	2026-03-02 15:43:44.318533
6482	56	2026-02-04	2026-02-04 09:05:31.495306	2026-02-04 17:20:35.241556	present	2026-03-02 15:43:44.318533
6483	57	2026-02-04	2026-02-04 09:12:36.937273	2026-02-04 17:46:50.596101	present	2026-03-02 15:43:44.318533
6484	58	2026-02-04	2026-02-04 09:04:41.706721	2026-02-04 17:47:18.596153	present	2026-03-02 15:43:44.318533
6485	61	2026-02-04	2026-02-04 09:23:06.461083	2026-02-04 17:51:02.557646	present	2026-03-02 15:43:44.318533
6486	67	2026-02-04	2026-02-04 09:19:08.487923	2026-02-04 17:59:00.280647	present	2026-03-02 15:43:44.318533
6487	68	2026-02-04	2026-02-04 09:47:02.727456	2026-02-04 17:24:33.501528	present	2026-03-02 15:43:44.318533
6488	69	2026-02-04	2026-02-04 09:56:25.154902	2026-02-04 17:51:25.580341	present	2026-03-02 15:43:44.318533
6489	72	2026-02-04	2026-02-04 09:12:31.952814	2026-02-04 17:30:02.517025	present	2026-03-02 15:43:44.318533
6490	75	2026-02-04	2026-02-04 09:06:25.747281	2026-02-04 17:11:12.19574	present	2026-03-02 15:43:44.318533
6491	76	2026-02-04	2026-02-04 09:04:35.783332	2026-02-04 17:52:09.385477	present	2026-03-02 15:43:44.318533
6492	77	2026-02-04	2026-02-04 09:54:03.032788	2026-02-04 17:04:10.928128	present	2026-03-02 15:43:44.318533
6493	80	2026-02-04	2026-02-04 09:58:08.380979	2026-02-04 17:24:44.450193	present	2026-03-02 15:43:44.318533
6494	81	2026-02-04	2026-02-04 09:10:17.842515	2026-02-04 17:33:58.023847	present	2026-03-02 15:43:44.318533
6495	86	2026-02-04	2026-02-04 09:38:00.526992	2026-02-04 17:30:59.807471	present	2026-03-02 15:43:44.318533
6496	87	2026-02-04	2026-02-04 09:19:24.953389	2026-02-04 17:39:45.879342	present	2026-03-02 15:43:44.318533
6497	90	2026-02-04	2026-02-04 09:40:28.108552	2026-02-04 17:22:45.961477	present	2026-03-02 15:43:44.318533
6498	91	2026-02-04	2026-02-04 09:23:02.93398	2026-02-04 17:18:34.496727	present	2026-03-02 15:43:44.318533
6499	92	2026-02-04	2026-02-04 09:15:11.679099	2026-02-04 17:57:11.099817	present	2026-03-02 15:43:44.318533
6500	93	2026-02-04	2026-02-04 09:21:45.292744	2026-02-04 17:18:32.936217	present	2026-03-02 15:43:44.318533
6501	94	2026-02-04	2026-02-04 09:39:23.359933	2026-02-04 17:07:24.15237	present	2026-03-02 15:43:44.318533
6502	95	2026-02-04	2026-02-04 09:48:31.597048	2026-02-04 17:07:20.081898	present	2026-03-02 15:43:44.318533
6503	98	2026-02-04	2026-02-04 09:48:31.958602	2026-02-04 17:55:51.438035	present	2026-03-02 15:43:44.318533
6504	99	2026-02-04	2026-02-04 09:24:11.985935	2026-02-04 17:57:14.065444	present	2026-03-02 15:43:44.318533
6505	100	2026-02-04	2026-02-04 09:45:26.939159	2026-02-04 17:24:21.582776	present	2026-03-02 15:43:44.318533
6506	3	2026-02-05	2026-02-05 09:54:59.589976	2026-02-05 17:52:21.811364	present	2026-03-02 15:43:44.318533
6507	4	2026-02-05	2026-02-05 09:32:00.90982	2026-02-05 17:34:57.736093	present	2026-03-02 15:43:44.318533
6508	5	2026-02-05	2026-02-05 09:58:42.09556	2026-02-05 17:44:08.734185	present	2026-03-02 15:43:44.318533
6509	6	2026-02-05	2026-02-05 09:28:44.563191	2026-02-05 17:15:31.933754	present	2026-03-02 15:43:44.318533
6510	10	2026-02-05	2026-02-05 09:21:20.048185	2026-02-05 17:32:14.536536	present	2026-03-02 15:43:44.318533
6511	11	2026-02-05	2026-02-05 09:50:31.303551	2026-02-05 17:47:22.304097	present	2026-03-02 15:43:44.318533
6512	27	2026-02-05	2026-02-05 09:02:09.87301	2026-02-05 17:02:49.012068	present	2026-03-02 15:43:44.318533
6513	33	2026-02-05	2026-02-05 09:45:38.530898	2026-02-05 17:47:29.540075	present	2026-03-02 15:43:44.318533
6514	35	2026-02-05	2026-02-05 09:06:40.992302	2026-02-05 17:07:38.210088	present	2026-03-02 15:43:44.318533
6515	37	2026-02-05	2026-02-05 09:02:24.871091	2026-02-05 17:07:11.678388	present	2026-03-02 15:43:44.318533
6516	43	2026-02-05	2026-02-05 09:16:50.625239	2026-02-05 17:12:57.964329	present	2026-03-02 15:43:44.318533
6517	45	2026-02-05	2026-02-05 09:23:21.572775	2026-02-05 17:37:28.064387	present	2026-03-02 15:43:44.318533
6518	46	2026-02-05	2026-02-05 09:44:16.362245	2026-02-05 17:47:31.745445	present	2026-03-02 15:43:44.318533
6519	47	2026-02-05	2026-02-05 09:49:14.290352	2026-02-05 17:45:12.568459	present	2026-03-02 15:43:44.318533
6520	48	2026-02-05	2026-02-05 09:27:48.898452	2026-02-05 17:14:26.335992	present	2026-03-02 15:43:44.318533
6521	50	2026-02-05	2026-02-05 09:38:19.274711	2026-02-05 17:48:46.732796	present	2026-03-02 15:43:44.318533
6522	52	2026-02-05	2026-02-05 09:24:05.59903	2026-02-05 17:08:36.643256	present	2026-03-02 15:43:44.318533
6523	59	2026-02-05	2026-02-05 09:39:42.750266	2026-02-05 17:14:12.860961	present	2026-03-02 15:43:44.318533
6524	60	2026-02-05	2026-02-05 09:06:46.955366	2026-02-05 17:18:49.485404	present	2026-03-02 15:43:44.318533
6525	62	2026-02-05	2026-02-05 09:25:14.685228	2026-02-05 17:56:49.725597	present	2026-03-02 15:43:44.318533
6526	63	2026-02-05	2026-02-05 09:05:32.929615	2026-02-05 17:01:49.37105	present	2026-03-02 15:43:44.318533
6527	64	2026-02-05	2026-02-05 09:58:36.606704	2026-02-05 17:26:48.307917	present	2026-03-02 15:43:44.318533
6528	65	2026-02-05	2026-02-05 09:00:32.803653	2026-02-05 17:15:25.935882	present	2026-03-02 15:43:44.318533
6529	66	2026-02-05	2026-02-05 09:44:13.684029	2026-02-05 17:21:02.433598	present	2026-03-02 15:43:44.318533
6530	70	2026-02-05	2026-02-05 09:27:03.082854	2026-02-05 17:12:00.943283	present	2026-03-02 15:43:44.318533
6531	71	2026-02-05	2026-02-05 09:38:23.976092	2026-02-05 17:21:41.485565	present	2026-03-02 15:43:44.318533
6532	73	2026-02-05	2026-02-05 09:41:33.288738	2026-02-05 17:39:05.248505	present	2026-03-02 15:43:44.318533
6533	74	2026-02-05	2026-02-05 09:12:13.32465	2026-02-05 17:10:42.607381	present	2026-03-02 15:43:44.318533
6534	78	2026-02-05	2026-02-05 09:01:38.460999	2026-02-05 17:24:29.766913	present	2026-03-02 15:43:44.318533
6535	79	2026-02-05	2026-02-05 09:41:35.317947	2026-02-05 17:32:04.177337	present	2026-03-02 15:43:44.318533
6536	82	2026-02-05	2026-02-05 09:11:09.12805	2026-02-05 17:50:00.199869	present	2026-03-02 15:43:44.318533
6537	83	2026-02-05	2026-02-05 09:20:24.854888	2026-02-05 17:27:44.195058	present	2026-03-02 15:43:44.318533
6538	84	2026-02-05	2026-02-05 09:10:11.403132	2026-02-05 17:19:21.828944	present	2026-03-02 15:43:44.318533
6539	85	2026-02-05	2026-02-05 09:36:49.237211	2026-02-05 17:40:32.260546	present	2026-03-02 15:43:44.318533
6540	88	2026-02-05	2026-02-05 09:53:05.46201	2026-02-05 17:46:18.604049	present	2026-03-02 15:43:44.318533
6541	89	2026-02-05	2026-02-05 09:07:23.585817	2026-02-05 17:27:34.1985	present	2026-03-02 15:43:44.318533
6542	96	2026-02-05	2026-02-05 09:13:57.833588	2026-02-05 17:46:38.546018	present	2026-03-02 15:43:44.318533
6543	97	2026-02-05	2026-02-05 09:34:21.91927	2026-02-05 17:25:27.353097	present	2026-03-02 15:43:44.318533
6544	1	2026-02-05	2026-02-05 09:10:00.550377	2026-02-05 17:47:43.117501	present	2026-03-02 15:43:44.318533
6545	2	2026-02-05	2026-02-05 09:10:38.776794	2026-02-05 17:09:47.044273	present	2026-03-02 15:43:44.318533
6546	7	2026-02-05	2026-02-05 09:16:02.864991	2026-02-05 17:47:37.367576	present	2026-03-02 15:43:44.318533
6547	8	2026-02-05	2026-02-05 09:27:32.029699	2026-02-05 17:18:30.933377	present	2026-03-02 15:43:44.318533
6548	9	2026-02-05	2026-02-05 09:28:02.918766	2026-02-05 17:45:56.873839	present	2026-03-02 15:43:44.318533
6549	12	2026-02-05	2026-02-05 09:22:44.160553	2026-02-05 17:46:00.460679	present	2026-03-02 15:43:44.318533
6550	13	2026-02-05	2026-02-05 09:16:33.591656	2026-02-05 17:14:00.501412	present	2026-03-02 15:43:44.318533
6551	14	2026-02-05	2026-02-05 09:56:29.975724	2026-02-05 17:12:39.630255	present	2026-03-02 15:43:44.318533
6552	15	2026-02-05	2026-02-05 09:25:43.961007	2026-02-05 17:52:17.322891	present	2026-03-02 15:43:44.318533
6553	16	2026-02-05	2026-02-05 09:10:59.642251	2026-02-05 17:39:00.902379	present	2026-03-02 15:43:44.318533
6554	17	2026-02-05	2026-02-05 09:43:45.89825	2026-02-05 17:44:48.504488	present	2026-03-02 15:43:44.318533
6555	18	2026-02-05	2026-02-05 09:16:03.205844	2026-02-05 17:03:53.35613	present	2026-03-02 15:43:44.318533
6556	19	2026-02-05	2026-02-05 09:42:09.621046	2026-02-05 17:10:05.269259	present	2026-03-02 15:43:44.318533
6557	20	2026-02-05	2026-02-05 09:10:20.131348	2026-02-05 17:02:34.543023	present	2026-03-02 15:43:44.318533
6558	21	2026-02-05	2026-02-05 09:38:06.85475	2026-02-05 17:20:49.408251	present	2026-03-02 15:43:44.318533
6559	22	2026-02-05	2026-02-05 09:41:29.262759	2026-02-05 17:55:54.304437	present	2026-03-02 15:43:44.318533
6560	23	2026-02-05	2026-02-05 09:32:13.186363	2026-02-05 17:40:15.93413	present	2026-03-02 15:43:44.318533
6561	24	2026-02-05	2026-02-05 09:45:13.691804	2026-02-05 17:34:18.24819	present	2026-03-02 15:43:44.318533
6562	25	2026-02-05	2026-02-05 09:50:09.995638	2026-02-05 17:53:02.500162	present	2026-03-02 15:43:44.318533
6563	26	2026-02-05	2026-02-05 09:40:05.361159	2026-02-05 17:39:45.385725	present	2026-03-02 15:43:44.318533
6564	28	2026-02-05	2026-02-05 09:51:23.948022	2026-02-05 17:47:33.878103	present	2026-03-02 15:43:44.318533
6565	29	2026-02-05	2026-02-05 09:35:18.52138	2026-02-05 17:35:13.970939	present	2026-03-02 15:43:44.318533
6566	30	2026-02-05	2026-02-05 09:04:48.644974	2026-02-05 17:56:12.590656	present	2026-03-02 15:43:44.318533
6567	31	2026-02-05	2026-02-05 09:00:40.548305	2026-02-05 17:46:16.063624	present	2026-03-02 15:43:44.318533
6568	32	2026-02-05	2026-02-05 09:30:51.164827	2026-02-05 17:57:30.856081	present	2026-03-02 15:43:44.318533
6569	34	2026-02-05	2026-02-05 09:51:12.836297	2026-02-05 17:32:54.194358	present	2026-03-02 15:43:44.318533
6570	36	2026-02-05	2026-02-05 09:26:01.701117	2026-02-05 17:10:27.974799	present	2026-03-02 15:43:44.318533
6571	38	2026-02-05	2026-02-05 09:02:29.261087	2026-02-05 17:02:15.978806	present	2026-03-02 15:43:44.318533
6572	39	2026-02-05	2026-02-05 09:06:33.414573	2026-02-05 17:07:19.321842	present	2026-03-02 15:43:44.318533
6573	40	2026-02-05	2026-02-05 09:33:39.241793	2026-02-05 17:26:27.914814	present	2026-03-02 15:43:44.318533
6574	41	2026-02-05	2026-02-05 09:11:04.079466	2026-02-05 17:16:19.359466	present	2026-03-02 15:43:44.318533
6575	42	2026-02-05	2026-02-05 09:45:05.148605	2026-02-05 17:27:57.231317	present	2026-03-02 15:43:44.318533
6576	44	2026-02-05	2026-02-05 09:06:42.577419	2026-02-05 17:43:42.318606	present	2026-03-02 15:43:44.318533
6577	49	2026-02-05	2026-02-05 09:40:22.807335	2026-02-05 17:20:42.018795	present	2026-03-02 15:43:44.318533
6578	51	2026-02-05	2026-02-05 09:41:48.329936	2026-02-05 17:09:35.698661	present	2026-03-02 15:43:44.318533
6579	53	2026-02-05	2026-02-05 09:22:46.377028	2026-02-05 17:33:33.743141	present	2026-03-02 15:43:44.318533
6580	54	2026-02-05	2026-02-05 09:05:29.155408	2026-02-05 17:22:21.369726	present	2026-03-02 15:43:44.318533
6581	55	2026-02-05	2026-02-05 09:09:32.595978	2026-02-05 17:43:25.629128	present	2026-03-02 15:43:44.318533
6582	56	2026-02-05	2026-02-05 09:30:52.673166	2026-02-05 17:35:45.620218	present	2026-03-02 15:43:44.318533
6583	57	2026-02-05	2026-02-05 09:44:22.668562	2026-02-05 17:00:08.748969	present	2026-03-02 15:43:44.318533
6584	58	2026-02-05	2026-02-05 09:06:42.786425	2026-02-05 17:59:11.878193	present	2026-03-02 15:43:44.318533
6585	61	2026-02-05	2026-02-05 09:44:49.485914	2026-02-05 17:28:23.554981	present	2026-03-02 15:43:44.318533
6586	67	2026-02-05	2026-02-05 09:40:29.620621	2026-02-05 17:59:05.428829	present	2026-03-02 15:43:44.318533
6587	68	2026-02-05	2026-02-05 09:08:49.482914	2026-02-05 17:47:52.089894	present	2026-03-02 15:43:44.318533
6588	69	2026-02-05	2026-02-05 09:03:31.662412	2026-02-05 17:42:58.991508	present	2026-03-02 15:43:44.318533
6589	72	2026-02-05	2026-02-05 09:57:46.061139	2026-02-05 17:58:17.793738	present	2026-03-02 15:43:44.318533
6590	75	2026-02-05	2026-02-05 09:05:20.333569	2026-02-05 17:49:35.775581	present	2026-03-02 15:43:44.318533
6591	76	2026-02-05	2026-02-05 09:10:27.662532	2026-02-05 17:14:03.802703	present	2026-03-02 15:43:44.318533
6592	77	2026-02-05	2026-02-05 09:00:49.783585	2026-02-05 17:48:27.22238	present	2026-03-02 15:43:44.318533
6593	80	2026-02-05	2026-02-05 09:02:04.049226	2026-02-05 17:38:14.863493	present	2026-03-02 15:43:44.318533
6594	81	2026-02-05	2026-02-05 09:29:04.586045	2026-02-05 17:32:56.493723	present	2026-03-02 15:43:44.318533
6595	86	2026-02-05	2026-02-05 09:58:35.630136	2026-02-05 17:34:45.04744	present	2026-03-02 15:43:44.318533
6596	87	2026-02-05	2026-02-05 09:09:19.139614	2026-02-05 17:07:51.939264	present	2026-03-02 15:43:44.318533
6597	90	2026-02-05	2026-02-05 09:59:43.876964	2026-02-05 17:27:58.995027	present	2026-03-02 15:43:44.318533
6598	91	2026-02-05	2026-02-05 09:01:51.926939	2026-02-05 17:51:14.843785	present	2026-03-02 15:43:44.318533
6599	92	2026-02-05	2026-02-05 09:41:35.08171	2026-02-05 17:39:49.641015	present	2026-03-02 15:43:44.318533
6600	93	2026-02-05	2026-02-05 09:41:47.292964	2026-02-05 17:12:12.734843	present	2026-03-02 15:43:44.318533
6601	94	2026-02-05	2026-02-05 09:18:07.129703	2026-02-05 17:14:12.902206	present	2026-03-02 15:43:44.318533
6602	95	2026-02-05	2026-02-05 09:01:56.230416	2026-02-05 17:16:18.247909	present	2026-03-02 15:43:44.318533
6603	98	2026-02-05	2026-02-05 09:48:44.57045	2026-02-05 17:41:11.682775	present	2026-03-02 15:43:44.318533
6604	99	2026-02-05	2026-02-05 09:39:59.468657	2026-02-05 17:29:28.767974	present	2026-03-02 15:43:44.318533
6605	100	2026-02-05	2026-02-05 09:51:42.882996	2026-02-05 17:13:11.006278	present	2026-03-02 15:43:44.318533
6606	3	2026-02-06	2026-02-06 09:03:44.253203	2026-02-06 17:36:50.195508	present	2026-03-02 15:43:44.318533
6607	4	2026-02-06	2026-02-06 09:17:05.476195	2026-02-06 17:20:24.395998	present	2026-03-02 15:43:44.318533
6608	5	2026-02-06	2026-02-06 09:59:21.269337	2026-02-06 17:48:07.154973	present	2026-03-02 15:43:44.318533
6609	6	2026-02-06	2026-02-06 09:19:14.785767	2026-02-06 17:44:06.83693	present	2026-03-02 15:43:44.318533
6610	10	2026-02-06	2026-02-06 09:55:13.450726	2026-02-06 17:24:06.602955	present	2026-03-02 15:43:44.318533
6611	11	2026-02-06	2026-02-06 09:58:09.043046	2026-02-06 17:05:11.027959	present	2026-03-02 15:43:44.318533
6612	27	2026-02-06	2026-02-06 09:05:32.382278	2026-02-06 17:34:47.398405	present	2026-03-02 15:43:44.318533
6613	33	2026-02-06	2026-02-06 09:03:03.559489	2026-02-06 17:25:55.52348	present	2026-03-02 15:43:44.318533
6614	35	2026-02-06	2026-02-06 09:34:08.335053	2026-02-06 17:21:52.3484	present	2026-03-02 15:43:44.318533
6615	37	2026-02-06	2026-02-06 09:41:31.10088	2026-02-06 17:51:16.681324	present	2026-03-02 15:43:44.318533
6616	43	2026-02-06	2026-02-06 09:29:17.048431	2026-02-06 17:39:02.839255	present	2026-03-02 15:43:44.318533
6617	45	2026-02-06	2026-02-06 09:48:29.36086	2026-02-06 17:39:47.628356	present	2026-03-02 15:43:44.318533
6618	46	2026-02-06	2026-02-06 09:16:31.315831	2026-02-06 17:46:51.368852	present	2026-03-02 15:43:44.318533
6619	47	2026-02-06	2026-02-06 09:42:36.924585	2026-02-06 17:33:32.37235	present	2026-03-02 15:43:44.318533
6620	48	2026-02-06	2026-02-06 09:45:59.920757	2026-02-06 17:35:22.112244	present	2026-03-02 15:43:44.318533
6621	50	2026-02-06	2026-02-06 09:23:30.9848	2026-02-06 17:08:36.348642	present	2026-03-02 15:43:44.318533
6622	52	2026-02-06	2026-02-06 09:55:42.101273	2026-02-06 17:45:12.369067	present	2026-03-02 15:43:44.318533
6623	59	2026-02-06	2026-02-06 09:00:12.738339	2026-02-06 17:50:12.669482	present	2026-03-02 15:43:44.318533
6624	60	2026-02-06	2026-02-06 09:16:05.121974	2026-02-06 17:49:51.485999	present	2026-03-02 15:43:44.318533
6625	62	2026-02-06	2026-02-06 09:45:00.483322	2026-02-06 17:25:23.557835	present	2026-03-02 15:43:44.318533
6626	63	2026-02-06	2026-02-06 09:29:00.270921	2026-02-06 17:48:54.836721	present	2026-03-02 15:43:44.318533
6627	64	2026-02-06	2026-02-06 09:40:41.260321	2026-02-06 17:32:39.162801	present	2026-03-02 15:43:44.318533
6628	65	2026-02-06	2026-02-06 09:43:11.719495	2026-02-06 17:33:05.491416	present	2026-03-02 15:43:44.318533
6629	66	2026-02-06	2026-02-06 09:47:32.509981	2026-02-06 17:59:29.770373	present	2026-03-02 15:43:44.318533
6630	70	2026-02-06	2026-02-06 09:56:37.779225	2026-02-06 17:04:46.583196	present	2026-03-02 15:43:44.318533
6631	71	2026-02-06	2026-02-06 09:51:38.540998	2026-02-06 17:22:06.683314	present	2026-03-02 15:43:44.318533
6632	73	2026-02-06	2026-02-06 09:34:16.054877	2026-02-06 17:08:01.037586	present	2026-03-02 15:43:44.318533
6633	74	2026-02-06	2026-02-06 09:05:31.040977	2026-02-06 17:03:25.07195	present	2026-03-02 15:43:44.318533
6634	78	2026-02-06	2026-02-06 09:22:11.520651	2026-02-06 17:46:45.937199	present	2026-03-02 15:43:44.318533
6635	79	2026-02-06	2026-02-06 09:36:35.242357	2026-02-06 17:15:35.802653	present	2026-03-02 15:43:44.318533
6636	82	2026-02-06	2026-02-06 09:15:55.927618	2026-02-06 17:42:34.537486	present	2026-03-02 15:43:44.318533
6637	83	2026-02-06	2026-02-06 09:32:13.927136	2026-02-06 17:58:37.734349	present	2026-03-02 15:43:44.318533
6638	84	2026-02-06	2026-02-06 09:27:01.391821	2026-02-06 17:32:21.207928	present	2026-03-02 15:43:44.318533
6639	85	2026-02-06	2026-02-06 09:02:47.564718	2026-02-06 17:21:46.957847	present	2026-03-02 15:43:44.318533
6640	88	2026-02-06	2026-02-06 09:34:15.393908	2026-02-06 17:00:06.773431	present	2026-03-02 15:43:44.318533
6641	89	2026-02-06	2026-02-06 09:44:12.390882	2026-02-06 17:14:47.713796	present	2026-03-02 15:43:44.318533
6642	96	2026-02-06	2026-02-06 09:38:32.774333	2026-02-06 17:27:05.160825	present	2026-03-02 15:43:44.318533
6643	97	2026-02-06	2026-02-06 09:25:11.577819	2026-02-06 17:57:20.667995	present	2026-03-02 15:43:44.318533
6644	1	2026-02-06	2026-02-06 09:59:54.390255	2026-02-06 17:10:02.756881	present	2026-03-02 15:43:44.318533
6645	2	2026-02-06	2026-02-06 09:40:19.448153	2026-02-06 17:00:09.63693	present	2026-03-02 15:43:44.318533
6646	7	2026-02-06	2026-02-06 09:19:26.048085	2026-02-06 17:02:35.926882	present	2026-03-02 15:43:44.318533
6647	8	2026-02-06	2026-02-06 09:23:18.840049	2026-02-06 17:21:01.859428	present	2026-03-02 15:43:44.318533
6648	9	2026-02-06	2026-02-06 09:33:05.452436	2026-02-06 17:43:43.916356	present	2026-03-02 15:43:44.318533
6649	12	2026-02-06	2026-02-06 09:51:19.278208	2026-02-06 17:27:49.715736	present	2026-03-02 15:43:44.318533
6650	13	2026-02-06	2026-02-06 09:09:12.320385	2026-02-06 17:08:43.230682	present	2026-03-02 15:43:44.318533
6651	14	2026-02-06	2026-02-06 09:02:13.062382	2026-02-06 17:51:20.187528	present	2026-03-02 15:43:44.318533
6652	15	2026-02-06	2026-02-06 09:32:13.675761	2026-02-06 17:01:35.874061	present	2026-03-02 15:43:44.318533
6653	16	2026-02-06	2026-02-06 09:07:09.584599	2026-02-06 17:57:12.974621	present	2026-03-02 15:43:44.318533
6654	17	2026-02-06	2026-02-06 09:40:18.95568	2026-02-06 17:22:49.831552	present	2026-03-02 15:43:44.318533
6655	18	2026-02-06	2026-02-06 09:27:36.314792	2026-02-06 17:47:28.713356	present	2026-03-02 15:43:44.318533
6656	19	2026-02-06	2026-02-06 09:24:46.507707	2026-02-06 17:00:27.924938	present	2026-03-02 15:43:44.318533
6657	20	2026-02-06	2026-02-06 09:31:30.858049	2026-02-06 17:15:15.14746	present	2026-03-02 15:43:44.318533
6658	21	2026-02-06	2026-02-06 09:01:51.330949	2026-02-06 17:26:28.834586	present	2026-03-02 15:43:44.318533
6659	22	2026-02-06	2026-02-06 09:54:08.223666	2026-02-06 17:33:44.858935	present	2026-03-02 15:43:44.318533
6660	23	2026-02-06	2026-02-06 09:27:38.666696	2026-02-06 17:49:53.64356	present	2026-03-02 15:43:44.318533
6661	24	2026-02-06	2026-02-06 09:57:01.628159	2026-02-06 17:26:05.716212	present	2026-03-02 15:43:44.318533
6662	25	2026-02-06	2026-02-06 09:35:31.019206	2026-02-06 17:57:38.491205	present	2026-03-02 15:43:44.318533
6663	26	2026-02-06	2026-02-06 09:20:18.63029	2026-02-06 17:53:57.905414	present	2026-03-02 15:43:44.318533
6664	28	2026-02-06	2026-02-06 09:35:45.556866	2026-02-06 17:31:29.164925	present	2026-03-02 15:43:44.318533
6665	29	2026-02-06	2026-02-06 09:43:45.483189	2026-02-06 17:35:15.365479	present	2026-03-02 15:43:44.318533
6666	30	2026-02-06	2026-02-06 09:43:47.468803	2026-02-06 17:04:13.851229	present	2026-03-02 15:43:44.318533
6667	31	2026-02-06	2026-02-06 09:37:03.351307	2026-02-06 17:10:40.490767	present	2026-03-02 15:43:44.318533
6668	32	2026-02-06	2026-02-06 09:30:19.197006	2026-02-06 17:30:05.333251	present	2026-03-02 15:43:44.318533
6669	34	2026-02-06	2026-02-06 09:14:49.109951	2026-02-06 17:52:43.559114	present	2026-03-02 15:43:44.318533
6670	36	2026-02-06	2026-02-06 09:48:13.900448	2026-02-06 17:40:48.371652	present	2026-03-02 15:43:44.318533
6671	38	2026-02-06	2026-02-06 09:27:08.051091	2026-02-06 17:49:40.869386	present	2026-03-02 15:43:44.318533
6672	39	2026-02-06	2026-02-06 09:06:43.359947	2026-02-06 17:50:24.635537	present	2026-03-02 15:43:44.318533
6673	40	2026-02-06	2026-02-06 09:49:38.41388	2026-02-06 17:23:45.568296	present	2026-03-02 15:43:44.318533
6674	41	2026-02-06	2026-02-06 09:17:10.821026	2026-02-06 17:29:30.040624	present	2026-03-02 15:43:44.318533
6675	42	2026-02-06	2026-02-06 09:44:55.258283	2026-02-06 17:37:30.228669	present	2026-03-02 15:43:44.318533
6676	44	2026-02-06	2026-02-06 09:00:28.855224	2026-02-06 17:01:33.926595	present	2026-03-02 15:43:44.318533
6677	49	2026-02-06	2026-02-06 09:50:47.051713	2026-02-06 17:56:09.950026	present	2026-03-02 15:43:44.318533
6678	51	2026-02-06	2026-02-06 09:05:34.019134	2026-02-06 17:21:53.598141	present	2026-03-02 15:43:44.318533
6679	53	2026-02-06	2026-02-06 09:30:28.134176	2026-02-06 17:03:14.357783	present	2026-03-02 15:43:44.318533
6680	54	2026-02-06	2026-02-06 09:54:19.434844	2026-02-06 17:47:56.137976	present	2026-03-02 15:43:44.318533
6681	55	2026-02-06	2026-02-06 09:42:12.438304	2026-02-06 17:20:29.874479	present	2026-03-02 15:43:44.318533
6682	56	2026-02-06	2026-02-06 09:48:19.884949	2026-02-06 17:43:23.947928	present	2026-03-02 15:43:44.318533
6683	57	2026-02-06	2026-02-06 09:16:16.402262	2026-02-06 17:45:51.959383	present	2026-03-02 15:43:44.318533
6684	58	2026-02-06	2026-02-06 09:35:31.914134	2026-02-06 17:41:43.189207	present	2026-03-02 15:43:44.318533
6685	61	2026-02-06	2026-02-06 09:46:03.879659	2026-02-06 17:16:18.53364	present	2026-03-02 15:43:44.318533
6686	67	2026-02-06	2026-02-06 09:21:40.857445	2026-02-06 17:38:21.572583	present	2026-03-02 15:43:44.318533
6687	68	2026-02-06	2026-02-06 09:02:40.424839	2026-02-06 17:50:32.05875	present	2026-03-02 15:43:44.318533
6688	69	2026-02-06	2026-02-06 09:26:41.208171	2026-02-06 17:02:17.461725	present	2026-03-02 15:43:44.318533
6689	72	2026-02-06	2026-02-06 09:30:20.575496	2026-02-06 17:41:24.845182	present	2026-03-02 15:43:44.318533
6690	75	2026-02-06	2026-02-06 09:55:11.787909	2026-02-06 17:40:05.857509	present	2026-03-02 15:43:44.318533
6691	76	2026-02-06	2026-02-06 09:37:29.254366	2026-02-06 17:24:46.608342	present	2026-03-02 15:43:44.318533
6692	77	2026-02-06	2026-02-06 09:10:33.93451	2026-02-06 17:14:25.051679	present	2026-03-02 15:43:44.318533
6693	80	2026-02-06	2026-02-06 09:23:31.240376	2026-02-06 17:34:12.420211	present	2026-03-02 15:43:44.318533
6694	81	2026-02-06	2026-02-06 09:04:59.794452	2026-02-06 17:44:26.960673	present	2026-03-02 15:43:44.318533
6695	86	2026-02-06	2026-02-06 09:14:38.41157	2026-02-06 17:32:25.867846	present	2026-03-02 15:43:44.318533
6696	87	2026-02-06	2026-02-06 09:02:47.315294	2026-02-06 17:58:32.289143	present	2026-03-02 15:43:44.318533
6697	90	2026-02-06	2026-02-06 09:29:55.694986	2026-02-06 17:26:11.521414	present	2026-03-02 15:43:44.318533
6698	91	2026-02-06	2026-02-06 09:37:21.588182	2026-02-06 17:43:54.005866	present	2026-03-02 15:43:44.318533
6699	92	2026-02-06	2026-02-06 09:12:10.940842	2026-02-06 17:01:30.464015	present	2026-03-02 15:43:44.318533
6700	93	2026-02-06	2026-02-06 09:24:28.784675	2026-02-06 17:48:10.659203	present	2026-03-02 15:43:44.318533
6701	94	2026-02-06	2026-02-06 09:03:57.504204	2026-02-06 17:24:32.287292	present	2026-03-02 15:43:44.318533
6702	95	2026-02-06	2026-02-06 09:25:27.155125	2026-02-06 17:03:18.555629	present	2026-03-02 15:43:44.318533
6703	98	2026-02-06	2026-02-06 09:56:27.860304	2026-02-06 17:50:35.34242	present	2026-03-02 15:43:44.318533
6704	99	2026-02-06	2026-02-06 09:48:43.719448	2026-02-06 17:14:47.644539	present	2026-03-02 15:43:44.318533
6705	100	2026-02-06	2026-02-06 09:01:25.737057	2026-02-06 17:29:24.35994	present	2026-03-02 15:43:44.318533
6706	3	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6707	4	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6708	5	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6709	6	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6710	10	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6711	11	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6712	27	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6713	33	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6714	35	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6715	37	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6716	43	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6717	45	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6718	46	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6719	47	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6720	48	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6721	50	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6722	52	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6723	59	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6724	60	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6725	62	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6726	63	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6727	64	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6728	65	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6729	66	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6730	70	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6731	71	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6732	73	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6733	74	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6734	78	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6735	79	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6736	82	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6737	83	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6738	84	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6739	85	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6740	88	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6741	89	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6742	96	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6743	97	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6744	1	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6745	2	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6746	7	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6747	8	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6748	9	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6749	12	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6750	13	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6751	14	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6752	15	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6753	16	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6754	17	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6755	18	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6756	19	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6757	20	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6758	21	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6759	22	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6760	23	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6761	24	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6762	25	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6763	26	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6764	28	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6765	29	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6766	30	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6767	31	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6768	32	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6769	34	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6770	36	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6771	38	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6772	39	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6773	40	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6774	41	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6775	42	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6776	44	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6777	49	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6778	51	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6779	53	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6780	54	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6781	55	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6782	56	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6783	57	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6784	58	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6785	61	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6786	67	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6787	68	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6788	69	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6789	72	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6790	75	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6791	76	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6792	77	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6793	80	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6794	81	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6795	86	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6796	87	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6797	90	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6798	91	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6799	92	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6800	93	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6801	94	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6802	95	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6803	98	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6804	99	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6805	100	2026-02-07	\N	\N	absent	2026-03-02 15:43:44.318533
6806	3	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6807	4	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6808	5	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6809	6	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6810	10	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6811	11	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6812	27	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6813	33	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6814	35	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6815	37	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6816	43	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6817	45	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6818	46	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6819	47	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6820	48	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6821	50	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6822	52	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6823	59	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6824	60	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6825	62	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6826	63	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6827	64	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6828	65	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6829	66	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6830	70	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6831	71	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6832	73	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6833	74	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6834	78	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6835	79	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6836	82	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6837	83	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6838	84	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6839	85	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6840	88	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6841	89	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6842	96	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6843	97	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6844	1	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6845	2	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6846	7	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6847	8	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6848	9	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6849	12	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6850	13	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6851	14	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6852	15	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6853	16	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6854	17	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6855	18	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6856	19	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6857	20	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6858	21	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6859	22	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6860	23	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6861	24	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6862	25	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6863	26	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6864	28	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6865	29	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6866	30	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6867	31	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6868	32	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6869	34	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6870	36	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6871	38	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6872	39	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6873	40	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6874	41	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6875	42	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6876	44	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6877	49	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6878	51	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6879	53	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6880	54	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6881	55	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6882	56	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6883	57	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6884	58	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6885	61	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6886	67	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6887	68	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6888	69	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6889	72	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6890	75	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6891	76	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6892	77	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6893	80	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6894	81	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6895	86	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6896	87	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6897	90	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6898	91	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6899	92	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6900	93	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6901	94	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6902	95	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6903	98	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6904	99	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6905	100	2026-02-08	\N	\N	absent	2026-03-02 15:43:44.318533
6906	3	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6907	4	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6908	5	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6909	6	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6910	10	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6911	11	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6912	27	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6913	33	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6914	35	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6915	37	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6916	43	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6917	45	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6918	46	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6919	47	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6920	48	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6921	50	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6922	52	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6923	59	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6924	60	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6925	62	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6926	63	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6927	64	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6928	65	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6929	66	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6930	70	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6931	71	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6932	73	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6933	74	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6934	78	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6935	79	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6936	82	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6937	83	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6938	84	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6939	85	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6940	88	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6941	89	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6942	96	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6943	97	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6944	1	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6945	2	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6946	7	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6947	8	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6948	9	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6949	12	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6950	13	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6951	14	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6952	15	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6953	16	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6954	17	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6955	18	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6956	19	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6957	20	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6958	21	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6959	22	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6960	23	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6961	24	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6962	25	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6963	26	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6964	28	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6965	29	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6966	30	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6967	31	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6968	32	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6969	34	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6970	36	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6971	38	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6972	39	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6973	40	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6974	41	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6975	42	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6976	44	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6977	49	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6978	51	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6979	53	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6980	54	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6981	55	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6982	56	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6983	57	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6984	58	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6985	61	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6986	67	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6987	68	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6988	69	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6989	72	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6990	75	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6991	76	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6992	77	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6993	80	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6994	81	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6995	86	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6996	87	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6997	90	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6998	91	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
6999	92	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7000	93	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7001	94	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7002	95	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7003	98	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7004	99	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7005	100	2026-02-09	\N	\N	absent	2026-03-02 15:43:44.318533
7006	3	2026-02-10	2026-02-10 09:02:01.037984	2026-02-10 17:01:19.046291	present	2026-03-02 15:43:44.318533
7007	4	2026-02-10	2026-02-10 09:21:49.931201	2026-02-10 17:32:58.665828	present	2026-03-02 15:43:44.318533
7008	5	2026-02-10	2026-02-10 09:37:47.747655	2026-02-10 17:37:03.288017	present	2026-03-02 15:43:44.318533
7009	6	2026-02-10	2026-02-10 09:07:02.96143	2026-02-10 17:05:35.043593	present	2026-03-02 15:43:44.318533
7010	10	2026-02-10	2026-02-10 09:49:37.320802	2026-02-10 17:18:34.082372	present	2026-03-02 15:43:44.318533
7011	11	2026-02-10	2026-02-10 09:29:22.746119	2026-02-10 17:02:13.202373	present	2026-03-02 15:43:44.318533
7012	27	2026-02-10	2026-02-10 09:33:15.789761	2026-02-10 17:50:20.963478	present	2026-03-02 15:43:44.318533
7013	33	2026-02-10	2026-02-10 09:14:05.899224	2026-02-10 17:39:21.913524	present	2026-03-02 15:43:44.318533
7014	35	2026-02-10	2026-02-10 09:59:59.615913	2026-02-10 17:31:04.813993	present	2026-03-02 15:43:44.318533
7015	37	2026-02-10	2026-02-10 09:35:40.8729	2026-02-10 17:24:11.812763	present	2026-03-02 15:43:44.318533
7016	43	2026-02-10	2026-02-10 09:38:46.42782	2026-02-10 17:13:44.474833	present	2026-03-02 15:43:44.318533
7017	45	2026-02-10	2026-02-10 09:26:21.971255	2026-02-10 17:06:13.736586	present	2026-03-02 15:43:44.318533
7018	46	2026-02-10	2026-02-10 09:27:38.221496	2026-02-10 17:54:56.463248	present	2026-03-02 15:43:44.318533
7019	47	2026-02-10	2026-02-10 09:33:23.078229	2026-02-10 17:12:34.81885	present	2026-03-02 15:43:44.318533
7020	48	2026-02-10	2026-02-10 09:24:28.819397	2026-02-10 17:12:25.630357	present	2026-03-02 15:43:44.318533
7021	50	2026-02-10	2026-02-10 09:22:33.194827	2026-02-10 17:12:26.406561	present	2026-03-02 15:43:44.318533
7022	52	2026-02-10	2026-02-10 09:11:39.974737	2026-02-10 17:47:48.813064	present	2026-03-02 15:43:44.318533
7023	59	2026-02-10	2026-02-10 09:38:41.016192	2026-02-10 17:44:00.697135	present	2026-03-02 15:43:44.318533
7024	60	2026-02-10	2026-02-10 09:36:32.430734	2026-02-10 17:55:44.941242	present	2026-03-02 15:43:44.318533
7025	62	2026-02-10	2026-02-10 09:26:53.626917	2026-02-10 17:00:16.006072	present	2026-03-02 15:43:44.318533
7026	63	2026-02-10	2026-02-10 09:45:15.121326	2026-02-10 17:33:22.377223	present	2026-03-02 15:43:44.318533
7027	64	2026-02-10	2026-02-10 09:09:19.020231	2026-02-10 17:31:02.942046	present	2026-03-02 15:43:44.318533
7028	65	2026-02-10	2026-02-10 09:43:09.284037	2026-02-10 17:49:34.67322	present	2026-03-02 15:43:44.318533
7029	66	2026-02-10	2026-02-10 09:28:15.44124	2026-02-10 17:56:32.654306	present	2026-03-02 15:43:44.318533
7030	70	2026-02-10	2026-02-10 09:57:10.862576	2026-02-10 17:11:47.39281	present	2026-03-02 15:43:44.318533
7031	71	2026-02-10	2026-02-10 09:30:25.131535	2026-02-10 17:15:04.969491	present	2026-03-02 15:43:44.318533
7032	73	2026-02-10	2026-02-10 09:22:32.01063	2026-02-10 17:17:51.562977	present	2026-03-02 15:43:44.318533
7033	74	2026-02-10	2026-02-10 09:39:20.370456	2026-02-10 17:53:32.3333	present	2026-03-02 15:43:44.318533
7034	78	2026-02-10	2026-02-10 09:44:37.980758	2026-02-10 17:57:17.550284	present	2026-03-02 15:43:44.318533
7035	79	2026-02-10	2026-02-10 09:37:03.280303	2026-02-10 17:46:22.409348	present	2026-03-02 15:43:44.318533
7036	82	2026-02-10	2026-02-10 09:00:04.500703	2026-02-10 17:56:38.804773	present	2026-03-02 15:43:44.318533
7037	83	2026-02-10	2026-02-10 09:56:47.894498	2026-02-10 17:32:32.665034	present	2026-03-02 15:43:44.318533
7038	84	2026-02-10	2026-02-10 09:20:41.011009	2026-02-10 17:31:17.718235	present	2026-03-02 15:43:44.318533
7039	85	2026-02-10	2026-02-10 09:54:23.084432	2026-02-10 17:59:20.719542	present	2026-03-02 15:43:44.318533
7040	88	2026-02-10	2026-02-10 09:15:01.639485	2026-02-10 17:58:20.369594	present	2026-03-02 15:43:44.318533
7041	89	2026-02-10	2026-02-10 09:29:27.407155	2026-02-10 17:19:36.66306	present	2026-03-02 15:43:44.318533
7042	96	2026-02-10	2026-02-10 09:00:47.670995	2026-02-10 17:58:34.864845	present	2026-03-02 15:43:44.318533
7043	97	2026-02-10	2026-02-10 09:15:42.43808	2026-02-10 17:01:05.838394	present	2026-03-02 15:43:44.318533
7044	1	2026-02-10	2026-02-10 09:49:47.095627	2026-02-10 17:39:58.405192	present	2026-03-02 15:43:44.318533
7045	2	2026-02-10	2026-02-10 09:19:55.104215	2026-02-10 17:02:01.518953	present	2026-03-02 15:43:44.318533
7046	7	2026-02-10	2026-02-10 09:09:55.191163	2026-02-10 17:34:39.8212	present	2026-03-02 15:43:44.318533
7047	8	2026-02-10	2026-02-10 09:41:12.691828	2026-02-10 17:20:45.191857	present	2026-03-02 15:43:44.318533
7048	9	2026-02-10	2026-02-10 09:33:59.002188	2026-02-10 17:19:15.006167	present	2026-03-02 15:43:44.318533
7049	12	2026-02-10	2026-02-10 09:10:54.307441	2026-02-10 17:32:08.419914	present	2026-03-02 15:43:44.318533
7050	13	2026-02-10	2026-02-10 09:23:21.763689	2026-02-10 17:24:58.355132	present	2026-03-02 15:43:44.318533
7051	14	2026-02-10	2026-02-10 09:06:15.63675	2026-02-10 17:07:27.198655	present	2026-03-02 15:43:44.318533
7052	15	2026-02-10	2026-02-10 09:33:37.208953	2026-02-10 17:55:15.540925	present	2026-03-02 15:43:44.318533
7053	16	2026-02-10	2026-02-10 09:47:02.520997	2026-02-10 17:21:02.299406	present	2026-03-02 15:43:44.318533
7054	17	2026-02-10	2026-02-10 09:28:31.526549	2026-02-10 17:21:44.103509	present	2026-03-02 15:43:44.318533
7055	18	2026-02-10	2026-02-10 09:53:51.63867	2026-02-10 17:48:25.877633	present	2026-03-02 15:43:44.318533
7056	19	2026-02-10	2026-02-10 09:16:19.763603	2026-02-10 17:43:06.267574	present	2026-03-02 15:43:44.318533
7057	20	2026-02-10	2026-02-10 09:47:02.119496	2026-02-10 17:32:04.672334	present	2026-03-02 15:43:44.318533
7058	21	2026-02-10	2026-02-10 09:46:05.611162	2026-02-10 17:20:36.80302	present	2026-03-02 15:43:44.318533
7059	22	2026-02-10	2026-02-10 09:58:24.24796	2026-02-10 17:43:19.412275	present	2026-03-02 15:43:44.318533
7060	23	2026-02-10	2026-02-10 09:57:36.994827	2026-02-10 17:08:23.637448	present	2026-03-02 15:43:44.318533
7061	24	2026-02-10	2026-02-10 09:07:27.814385	2026-02-10 17:25:44.248113	present	2026-03-02 15:43:44.318533
7062	25	2026-02-10	2026-02-10 09:50:53.762988	2026-02-10 17:04:54.604839	present	2026-03-02 15:43:44.318533
7063	26	2026-02-10	2026-02-10 09:10:16.471795	2026-02-10 17:33:30.64129	present	2026-03-02 15:43:44.318533
7064	28	2026-02-10	2026-02-10 09:36:19.893577	2026-02-10 17:53:00.614762	present	2026-03-02 15:43:44.318533
7065	29	2026-02-10	2026-02-10 09:17:56.295441	2026-02-10 17:49:50.778227	present	2026-03-02 15:43:44.318533
7066	30	2026-02-10	2026-02-10 09:55:59.047854	2026-02-10 17:26:31.109201	present	2026-03-02 15:43:44.318533
7067	31	2026-02-10	2026-02-10 09:33:35.922739	2026-02-10 17:43:26.945627	present	2026-03-02 15:43:44.318533
7068	32	2026-02-10	2026-02-10 09:29:35.633325	2026-02-10 17:19:25.103425	present	2026-03-02 15:43:44.318533
7069	34	2026-02-10	2026-02-10 09:07:19.085151	2026-02-10 17:24:58.908785	present	2026-03-02 15:43:44.318533
7070	36	2026-02-10	2026-02-10 09:52:15.062923	2026-02-10 17:01:33.7081	present	2026-03-02 15:43:44.318533
7071	38	2026-02-10	2026-02-10 09:29:20.095683	2026-02-10 17:56:06.867026	present	2026-03-02 15:43:44.318533
7072	39	2026-02-10	2026-02-10 09:51:49.298222	2026-02-10 17:51:27.967247	present	2026-03-02 15:43:44.318533
7073	40	2026-02-10	2026-02-10 09:38:07.475475	2026-02-10 17:39:17.504697	present	2026-03-02 15:43:44.318533
7074	41	2026-02-10	2026-02-10 09:22:41.80881	2026-02-10 17:53:36.094333	present	2026-03-02 15:43:44.318533
7075	42	2026-02-10	2026-02-10 09:01:25.631122	2026-02-10 17:07:31.0286	present	2026-03-02 15:43:44.318533
7076	44	2026-02-10	2026-02-10 09:54:22.72623	2026-02-10 17:35:00.082212	present	2026-03-02 15:43:44.318533
7077	49	2026-02-10	2026-02-10 09:33:24.100658	2026-02-10 17:05:09.891107	present	2026-03-02 15:43:44.318533
7078	51	2026-02-10	2026-02-10 09:21:30.00031	2026-02-10 17:54:39.998965	present	2026-03-02 15:43:44.318533
7079	53	2026-02-10	2026-02-10 09:57:04.922774	2026-02-10 17:22:14.273934	present	2026-03-02 15:43:44.318533
7080	54	2026-02-10	2026-02-10 09:09:06.056397	2026-02-10 17:43:37.040827	present	2026-03-02 15:43:44.318533
7081	55	2026-02-10	2026-02-10 09:55:08.173164	2026-02-10 17:40:10.658024	present	2026-03-02 15:43:44.318533
7082	56	2026-02-10	2026-02-10 09:45:03.630886	2026-02-10 17:57:35.936946	present	2026-03-02 15:43:44.318533
7083	57	2026-02-10	2026-02-10 09:12:07.304642	2026-02-10 17:05:07.325835	present	2026-03-02 15:43:44.318533
7084	58	2026-02-10	2026-02-10 09:15:02.935005	2026-02-10 17:41:54.065855	present	2026-03-02 15:43:44.318533
7085	61	2026-02-10	2026-02-10 09:44:11.088051	2026-02-10 17:54:12.689878	present	2026-03-02 15:43:44.318533
7086	67	2026-02-10	2026-02-10 09:07:43.118174	2026-02-10 17:44:58.982861	present	2026-03-02 15:43:44.318533
7087	68	2026-02-10	2026-02-10 09:49:30.439299	2026-02-10 17:28:40.113197	present	2026-03-02 15:43:44.318533
7088	69	2026-02-10	2026-02-10 09:37:07.810919	2026-02-10 17:17:38.558198	present	2026-03-02 15:43:44.318533
7089	72	2026-02-10	2026-02-10 09:06:16.290103	2026-02-10 17:50:05.979045	present	2026-03-02 15:43:44.318533
7090	75	2026-02-10	2026-02-10 09:41:57.109286	2026-02-10 17:09:45.046542	present	2026-03-02 15:43:44.318533
7091	76	2026-02-10	2026-02-10 09:19:45.67337	2026-02-10 17:32:53.788893	present	2026-03-02 15:43:44.318533
7092	77	2026-02-10	2026-02-10 09:26:28.295252	2026-02-10 17:00:27.533765	present	2026-03-02 15:43:44.318533
7093	80	2026-02-10	2026-02-10 09:42:15.193883	2026-02-10 17:12:43.414481	present	2026-03-02 15:43:44.318533
7094	81	2026-02-10	2026-02-10 09:49:47.670683	2026-02-10 17:05:33.578048	present	2026-03-02 15:43:44.318533
7095	86	2026-02-10	2026-02-10 09:42:02.475625	2026-02-10 17:58:43.197556	present	2026-03-02 15:43:44.318533
7096	87	2026-02-10	2026-02-10 09:01:08.953673	2026-02-10 17:47:26.849267	present	2026-03-02 15:43:44.318533
7097	90	2026-02-10	2026-02-10 09:27:10.107993	2026-02-10 17:21:03.873787	present	2026-03-02 15:43:44.318533
7098	91	2026-02-10	2026-02-10 09:39:56.795824	2026-02-10 17:36:50.198039	present	2026-03-02 15:43:44.318533
7099	92	2026-02-10	2026-02-10 09:34:23.736773	2026-02-10 17:33:07.939212	present	2026-03-02 15:43:44.318533
7100	93	2026-02-10	2026-02-10 09:01:05.124694	2026-02-10 17:29:51.735128	present	2026-03-02 15:43:44.318533
7101	94	2026-02-10	2026-02-10 09:28:35.15984	2026-02-10 17:41:00.424309	present	2026-03-02 15:43:44.318533
7102	95	2026-02-10	2026-02-10 09:53:41.051664	2026-02-10 17:32:55.183854	present	2026-03-02 15:43:44.318533
7103	98	2026-02-10	2026-02-10 09:09:50.183462	2026-02-10 17:27:13.185178	present	2026-03-02 15:43:44.318533
7104	99	2026-02-10	2026-02-10 09:42:40.904134	2026-02-10 17:46:35.025699	present	2026-03-02 15:43:44.318533
7105	100	2026-02-10	2026-02-10 09:40:42.745821	2026-02-10 17:21:14.822157	present	2026-03-02 15:43:44.318533
7106	3	2026-02-11	2026-02-11 09:43:34.223763	2026-02-11 17:21:57.002817	present	2026-03-02 15:43:44.318533
7107	4	2026-02-11	2026-02-11 09:07:23.071238	2026-02-11 17:37:56.553433	present	2026-03-02 15:43:44.318533
7108	5	2026-02-11	2026-02-11 09:57:35.272413	2026-02-11 17:50:32.274239	present	2026-03-02 15:43:44.318533
7109	6	2026-02-11	2026-02-11 09:34:43.290987	2026-02-11 17:16:25.824254	present	2026-03-02 15:43:44.318533
7110	10	2026-02-11	2026-02-11 09:14:24.433877	2026-02-11 17:26:46.507908	present	2026-03-02 15:43:44.318533
7111	11	2026-02-11	2026-02-11 09:39:06.549	2026-02-11 17:13:26.994004	present	2026-03-02 15:43:44.318533
7112	27	2026-02-11	2026-02-11 09:15:16.773276	2026-02-11 17:34:33.020836	present	2026-03-02 15:43:44.318533
7113	33	2026-02-11	2026-02-11 09:11:22.318491	2026-02-11 17:04:35.386844	present	2026-03-02 15:43:44.318533
7114	35	2026-02-11	2026-02-11 09:57:17.252532	2026-02-11 17:19:29.678567	present	2026-03-02 15:43:44.318533
7115	37	2026-02-11	2026-02-11 09:27:39.181232	2026-02-11 17:15:20.601687	present	2026-03-02 15:43:44.318533
7116	43	2026-02-11	2026-02-11 09:03:22.03367	2026-02-11 17:12:18.436358	present	2026-03-02 15:43:44.318533
7117	45	2026-02-11	2026-02-11 09:54:02.449437	2026-02-11 17:31:13.742552	present	2026-03-02 15:43:44.318533
7118	46	2026-02-11	2026-02-11 09:33:26.484953	2026-02-11 17:12:44.542853	present	2026-03-02 15:43:44.318533
7119	47	2026-02-11	2026-02-11 09:26:10.634539	2026-02-11 17:52:07.928238	present	2026-03-02 15:43:44.318533
7120	48	2026-02-11	2026-02-11 09:59:37.069384	2026-02-11 17:12:26.523675	present	2026-03-02 15:43:44.318533
7121	50	2026-02-11	2026-02-11 09:00:09.470312	2026-02-11 17:34:02.637845	present	2026-03-02 15:43:44.318533
7122	52	2026-02-11	2026-02-11 09:53:20.497689	2026-02-11 17:53:26.385018	present	2026-03-02 15:43:44.318533
7123	59	2026-02-11	2026-02-11 09:15:49.304517	2026-02-11 17:53:00.659207	present	2026-03-02 15:43:44.318533
7124	60	2026-02-11	2026-02-11 09:42:35.528063	2026-02-11 17:40:57.501562	present	2026-03-02 15:43:44.318533
7125	62	2026-02-11	2026-02-11 09:08:37.311883	2026-02-11 17:27:29.114106	present	2026-03-02 15:43:44.318533
7126	63	2026-02-11	2026-02-11 09:48:36.196004	2026-02-11 17:24:45.696578	present	2026-03-02 15:43:44.318533
7127	64	2026-02-11	2026-02-11 09:39:53.96271	2026-02-11 17:20:40.748296	present	2026-03-02 15:43:44.318533
7128	65	2026-02-11	2026-02-11 09:03:53.501309	2026-02-11 17:30:31.318725	present	2026-03-02 15:43:44.318533
7129	66	2026-02-11	2026-02-11 09:56:13.596691	2026-02-11 17:16:03.033285	present	2026-03-02 15:43:44.318533
7130	70	2026-02-11	2026-02-11 09:01:07.997793	2026-02-11 17:42:21.174138	present	2026-03-02 15:43:44.318533
7131	71	2026-02-11	2026-02-11 09:25:29.778104	2026-02-11 17:07:35.065249	present	2026-03-02 15:43:44.318533
7132	73	2026-02-11	2026-02-11 09:54:56.995915	2026-02-11 17:50:17.997252	present	2026-03-02 15:43:44.318533
7133	74	2026-02-11	2026-02-11 09:22:06.051841	2026-02-11 17:21:25.144512	present	2026-03-02 15:43:44.318533
7134	78	2026-02-11	2026-02-11 09:10:10.455584	2026-02-11 17:28:59.99599	present	2026-03-02 15:43:44.318533
7135	79	2026-02-11	2026-02-11 09:50:52.235905	2026-02-11 17:49:29.575775	present	2026-03-02 15:43:44.318533
7136	82	2026-02-11	2026-02-11 09:35:14.027387	2026-02-11 17:46:33.284219	present	2026-03-02 15:43:44.318533
7137	83	2026-02-11	2026-02-11 09:45:03.865977	2026-02-11 17:06:28.166661	present	2026-03-02 15:43:44.318533
7138	84	2026-02-11	2026-02-11 09:14:35.059755	2026-02-11 17:43:40.214249	present	2026-03-02 15:43:44.318533
7139	85	2026-02-11	2026-02-11 09:32:04.879012	2026-02-11 17:33:08.12315	present	2026-03-02 15:43:44.318533
7140	88	2026-02-11	2026-02-11 09:11:47.462682	2026-02-11 17:07:17.844442	present	2026-03-02 15:43:44.318533
7141	89	2026-02-11	2026-02-11 09:48:01.61293	2026-02-11 17:14:33.848153	present	2026-03-02 15:43:44.318533
7142	96	2026-02-11	2026-02-11 09:37:40.459187	2026-02-11 17:20:55.764679	present	2026-03-02 15:43:44.318533
7143	97	2026-02-11	2026-02-11 09:35:12.703627	2026-02-11 17:42:50.001582	present	2026-03-02 15:43:44.318533
7144	1	2026-02-11	2026-02-11 09:27:51.192127	2026-02-11 17:51:04.57948	present	2026-03-02 15:43:44.318533
7145	2	2026-02-11	2026-02-11 09:14:32.895933	2026-02-11 17:03:09.894587	present	2026-03-02 15:43:44.318533
7146	7	2026-02-11	2026-02-11 09:24:24.90465	2026-02-11 17:44:53.912657	present	2026-03-02 15:43:44.318533
7147	8	2026-02-11	2026-02-11 09:03:32.256386	2026-02-11 17:29:47.350938	present	2026-03-02 15:43:44.318533
7148	9	2026-02-11	2026-02-11 09:46:40.026309	2026-02-11 17:54:22.157435	present	2026-03-02 15:43:44.318533
7149	12	2026-02-11	2026-02-11 09:45:27.644356	2026-02-11 17:02:36.276404	present	2026-03-02 15:43:44.318533
7150	13	2026-02-11	2026-02-11 09:18:49.274084	2026-02-11 17:05:05.487686	present	2026-03-02 15:43:44.318533
7151	14	2026-02-11	2026-02-11 09:33:35.693018	2026-02-11 17:55:23.348887	present	2026-03-02 15:43:44.318533
7152	15	2026-02-11	2026-02-11 09:42:49.342102	2026-02-11 17:30:11.064217	present	2026-03-02 15:43:44.318533
7153	16	2026-02-11	2026-02-11 09:17:36.367006	2026-02-11 17:38:54.599883	present	2026-03-02 15:43:44.318533
7154	17	2026-02-11	2026-02-11 09:22:28.325471	2026-02-11 17:53:02.015984	present	2026-03-02 15:43:44.318533
7155	18	2026-02-11	2026-02-11 09:47:20.947474	2026-02-11 17:28:23.338831	present	2026-03-02 15:43:44.318533
7156	19	2026-02-11	2026-02-11 09:57:26.473471	2026-02-11 17:48:32.858607	present	2026-03-02 15:43:44.318533
7157	20	2026-02-11	2026-02-11 09:00:21.775524	2026-02-11 17:15:19.282371	present	2026-03-02 15:43:44.318533
7158	21	2026-02-11	2026-02-11 09:10:50.862851	2026-02-11 17:24:34.635555	present	2026-03-02 15:43:44.318533
7159	22	2026-02-11	2026-02-11 09:36:29.060825	2026-02-11 17:35:40.829062	present	2026-03-02 15:43:44.318533
7160	23	2026-02-11	2026-02-11 09:06:21.730421	2026-02-11 17:29:39.701441	present	2026-03-02 15:43:44.318533
7161	24	2026-02-11	2026-02-11 09:44:45.648994	2026-02-11 17:00:32.739825	present	2026-03-02 15:43:44.318533
7162	25	2026-02-11	2026-02-11 09:31:39.514759	2026-02-11 17:48:28.484425	present	2026-03-02 15:43:44.318533
7163	26	2026-02-11	2026-02-11 09:55:57.160185	2026-02-11 17:36:03.310439	present	2026-03-02 15:43:44.318533
7164	28	2026-02-11	2026-02-11 09:55:38.417568	2026-02-11 17:50:38.513896	present	2026-03-02 15:43:44.318533
7165	29	2026-02-11	2026-02-11 09:09:16.675029	2026-02-11 17:45:54.267086	present	2026-03-02 15:43:44.318533
7166	30	2026-02-11	2026-02-11 09:10:54.810004	2026-02-11 17:57:12.106837	present	2026-03-02 15:43:44.318533
7167	31	2026-02-11	2026-02-11 09:28:44.505292	2026-02-11 17:50:55.012112	present	2026-03-02 15:43:44.318533
7168	32	2026-02-11	2026-02-11 09:51:06.185106	2026-02-11 17:58:05.846528	present	2026-03-02 15:43:44.318533
7169	34	2026-02-11	2026-02-11 09:25:22.095151	2026-02-11 17:22:43.871098	present	2026-03-02 15:43:44.318533
7170	36	2026-02-11	2026-02-11 09:18:45.421842	2026-02-11 17:27:43.927563	present	2026-03-02 15:43:44.318533
7171	38	2026-02-11	2026-02-11 09:00:32.310133	2026-02-11 17:43:47.114066	present	2026-03-02 15:43:44.318533
7172	39	2026-02-11	2026-02-11 09:33:03.55312	2026-02-11 17:41:32.099754	present	2026-03-02 15:43:44.318533
7173	40	2026-02-11	2026-02-11 09:01:26.803647	2026-02-11 17:07:22.056753	present	2026-03-02 15:43:44.318533
7174	41	2026-02-11	2026-02-11 09:15:15.367794	2026-02-11 17:13:15.861397	present	2026-03-02 15:43:44.318533
7175	42	2026-02-11	2026-02-11 09:41:35.228125	2026-02-11 17:38:42.944877	present	2026-03-02 15:43:44.318533
7176	44	2026-02-11	2026-02-11 09:11:57.420488	2026-02-11 17:10:03.527867	present	2026-03-02 15:43:44.318533
7177	49	2026-02-11	2026-02-11 09:03:04.737159	2026-02-11 17:54:50.773726	present	2026-03-02 15:43:44.318533
7178	51	2026-02-11	2026-02-11 09:15:17.066661	2026-02-11 17:59:44.424979	present	2026-03-02 15:43:44.318533
7179	53	2026-02-11	2026-02-11 09:39:57.664991	2026-02-11 17:12:57.378012	present	2026-03-02 15:43:44.318533
7180	54	2026-02-11	2026-02-11 09:36:24.214997	2026-02-11 17:18:29.166182	present	2026-03-02 15:43:44.318533
7181	55	2026-02-11	2026-02-11 09:50:29.323562	2026-02-11 17:30:01.604715	present	2026-03-02 15:43:44.318533
7182	56	2026-02-11	2026-02-11 09:30:36.790386	2026-02-11 17:47:56.114782	present	2026-03-02 15:43:44.318533
7183	57	2026-02-11	2026-02-11 09:15:15.898361	2026-02-11 17:37:16.217107	present	2026-03-02 15:43:44.318533
7184	58	2026-02-11	2026-02-11 09:15:03.132909	2026-02-11 17:14:10.059324	present	2026-03-02 15:43:44.318533
7185	61	2026-02-11	2026-02-11 09:22:07.607942	2026-02-11 17:02:14.425211	present	2026-03-02 15:43:44.318533
7186	67	2026-02-11	2026-02-11 09:59:01.445371	2026-02-11 17:36:51.187492	present	2026-03-02 15:43:44.318533
7187	68	2026-02-11	2026-02-11 09:55:42.885699	2026-02-11 17:21:49.356574	present	2026-03-02 15:43:44.318533
7188	69	2026-02-11	2026-02-11 09:23:49.426305	2026-02-11 17:50:25.299256	present	2026-03-02 15:43:44.318533
7189	72	2026-02-11	2026-02-11 09:06:29.133138	2026-02-11 17:29:51.034421	present	2026-03-02 15:43:44.318533
7190	75	2026-02-11	2026-02-11 09:12:40.711317	2026-02-11 17:36:06.590905	present	2026-03-02 15:43:44.318533
7191	76	2026-02-11	2026-02-11 09:58:25.923855	2026-02-11 17:44:20.232756	present	2026-03-02 15:43:44.318533
7192	77	2026-02-11	2026-02-11 09:32:55.645606	2026-02-11 17:55:18.198282	present	2026-03-02 15:43:44.318533
7193	80	2026-02-11	2026-02-11 09:22:37.897905	2026-02-11 17:15:41.134974	present	2026-03-02 15:43:44.318533
7194	81	2026-02-11	2026-02-11 09:29:03.707307	2026-02-11 17:20:49.97539	present	2026-03-02 15:43:44.318533
7195	86	2026-02-11	2026-02-11 09:23:50.831984	2026-02-11 17:59:14.319591	present	2026-03-02 15:43:44.318533
7196	87	2026-02-11	2026-02-11 09:29:33.462765	2026-02-11 17:15:25.609265	present	2026-03-02 15:43:44.318533
7197	90	2026-02-11	2026-02-11 09:20:51.142529	2026-02-11 17:51:28.957153	present	2026-03-02 15:43:44.318533
7198	91	2026-02-11	2026-02-11 09:04:58.368262	2026-02-11 17:01:24.990856	present	2026-03-02 15:43:44.318533
7199	92	2026-02-11	2026-02-11 09:38:33.632415	2026-02-11 17:18:06.099918	present	2026-03-02 15:43:44.318533
7200	93	2026-02-11	2026-02-11 09:48:17.201939	2026-02-11 17:53:18.326288	present	2026-03-02 15:43:44.318533
7201	94	2026-02-11	2026-02-11 09:25:29.123283	2026-02-11 17:57:58.68847	present	2026-03-02 15:43:44.318533
7202	95	2026-02-11	2026-02-11 09:09:02.02406	2026-02-11 17:26:48.439513	present	2026-03-02 15:43:44.318533
7203	98	2026-02-11	2026-02-11 09:21:56.057976	2026-02-11 17:48:16.863519	present	2026-03-02 15:43:44.318533
7204	99	2026-02-11	2026-02-11 09:51:17.152702	2026-02-11 17:14:01.344735	present	2026-03-02 15:43:44.318533
7205	100	2026-02-11	2026-02-11 09:14:25.570383	2026-02-11 17:38:57.73405	present	2026-03-02 15:43:44.318533
7206	3	2026-02-12	2026-02-12 09:26:33.055062	2026-02-12 17:25:36.752659	present	2026-03-02 15:43:44.318533
7207	4	2026-02-12	2026-02-12 09:36:21.374515	2026-02-12 17:27:00.390335	present	2026-03-02 15:43:44.318533
7208	5	2026-02-12	2026-02-12 09:31:30.812463	2026-02-12 17:52:24.817684	present	2026-03-02 15:43:44.318533
7209	6	2026-02-12	2026-02-12 09:50:02.546209	2026-02-12 17:45:10.626379	present	2026-03-02 15:43:44.318533
7210	10	2026-02-12	2026-02-12 09:54:40.116551	2026-02-12 17:00:34.037611	present	2026-03-02 15:43:44.318533
7211	11	2026-02-12	2026-02-12 09:22:52.009937	2026-02-12 17:31:24.789649	present	2026-03-02 15:43:44.318533
7212	27	2026-02-12	2026-02-12 09:43:32.434852	2026-02-12 17:07:17.603805	present	2026-03-02 15:43:44.318533
7213	33	2026-02-12	2026-02-12 09:17:58.663076	2026-02-12 17:21:18.966705	present	2026-03-02 15:43:44.318533
7214	35	2026-02-12	2026-02-12 09:14:52.343017	2026-02-12 17:31:22.682607	present	2026-03-02 15:43:44.318533
7215	37	2026-02-12	2026-02-12 09:59:32.076778	2026-02-12 17:36:46.212433	present	2026-03-02 15:43:44.318533
7216	43	2026-02-12	2026-02-12 09:48:21.834263	2026-02-12 17:35:32.193367	present	2026-03-02 15:43:44.318533
7217	45	2026-02-12	2026-02-12 09:01:42.673749	2026-02-12 17:57:17.512547	present	2026-03-02 15:43:44.318533
7218	46	2026-02-12	2026-02-12 09:38:09.753079	2026-02-12 17:07:28.10279	present	2026-03-02 15:43:44.318533
7219	47	2026-02-12	2026-02-12 09:04:05.334298	2026-02-12 17:50:09.854491	present	2026-03-02 15:43:44.318533
7220	48	2026-02-12	2026-02-12 09:59:14.518632	2026-02-12 17:02:58.093858	present	2026-03-02 15:43:44.318533
7221	50	2026-02-12	2026-02-12 09:05:08.303712	2026-02-12 17:28:52.250224	present	2026-03-02 15:43:44.318533
7222	52	2026-02-12	2026-02-12 09:56:39.401391	2026-02-12 17:48:58.200695	present	2026-03-02 15:43:44.318533
7223	59	2026-02-12	2026-02-12 09:40:37.891401	2026-02-12 17:33:12.526255	present	2026-03-02 15:43:44.318533
7224	60	2026-02-12	2026-02-12 09:39:07.402702	2026-02-12 17:58:16.144455	present	2026-03-02 15:43:44.318533
7225	62	2026-02-12	2026-02-12 09:31:56.124545	2026-02-12 17:38:21.071192	present	2026-03-02 15:43:44.318533
7226	63	2026-02-12	2026-02-12 09:36:23.196511	2026-02-12 17:42:39.450097	present	2026-03-02 15:43:44.318533
7227	64	2026-02-12	2026-02-12 09:41:00.101915	2026-02-12 17:44:11.370328	present	2026-03-02 15:43:44.318533
7228	65	2026-02-12	2026-02-12 09:56:02.218304	2026-02-12 17:43:27.717617	present	2026-03-02 15:43:44.318533
7229	66	2026-02-12	2026-02-12 09:47:28.832055	2026-02-12 17:05:47.754163	present	2026-03-02 15:43:44.318533
7230	70	2026-02-12	2026-02-12 09:34:03.939405	2026-02-12 17:30:56.473476	present	2026-03-02 15:43:44.318533
7231	71	2026-02-12	2026-02-12 09:06:24.186364	2026-02-12 17:20:25.464227	present	2026-03-02 15:43:44.318533
7232	73	2026-02-12	2026-02-12 09:08:25.754626	2026-02-12 17:27:26.297451	present	2026-03-02 15:43:44.318533
7233	74	2026-02-12	2026-02-12 09:29:45.297598	2026-02-12 17:27:18.252343	present	2026-03-02 15:43:44.318533
7234	78	2026-02-12	2026-02-12 09:53:08.008356	2026-02-12 17:04:04.785471	present	2026-03-02 15:43:44.318533
7235	79	2026-02-12	2026-02-12 09:06:10.654369	2026-02-12 17:57:54.707481	present	2026-03-02 15:43:44.318533
7236	82	2026-02-12	2026-02-12 09:17:00.537556	2026-02-12 17:55:00.27471	present	2026-03-02 15:43:44.318533
7237	83	2026-02-12	2026-02-12 09:42:14.398715	2026-02-12 17:20:01.74443	present	2026-03-02 15:43:44.318533
7238	84	2026-02-12	2026-02-12 09:55:14.866513	2026-02-12 17:30:36.560458	present	2026-03-02 15:43:44.318533
7239	85	2026-02-12	2026-02-12 09:32:20.143456	2026-02-12 17:33:08.16582	present	2026-03-02 15:43:44.318533
7240	88	2026-02-12	2026-02-12 09:48:05.99758	2026-02-12 17:46:32.775602	present	2026-03-02 15:43:44.318533
7241	89	2026-02-12	2026-02-12 09:59:38.965557	2026-02-12 17:18:35.599472	present	2026-03-02 15:43:44.318533
7242	96	2026-02-12	2026-02-12 09:08:39.01523	2026-02-12 17:39:07.853917	present	2026-03-02 15:43:44.318533
7243	97	2026-02-12	2026-02-12 09:44:45.059509	2026-02-12 17:04:30.728943	present	2026-03-02 15:43:44.318533
7244	1	2026-02-12	2026-02-12 09:15:52.110553	2026-02-12 17:27:57.345451	present	2026-03-02 15:43:44.318533
7245	2	2026-02-12	2026-02-12 09:36:16.896034	2026-02-12 17:19:27.636644	present	2026-03-02 15:43:44.318533
7246	7	2026-02-12	2026-02-12 09:23:46.058812	2026-02-12 17:30:42.525101	present	2026-03-02 15:43:44.318533
7247	8	2026-02-12	2026-02-12 09:19:11.526929	2026-02-12 17:16:32.351997	present	2026-03-02 15:43:44.318533
7248	9	2026-02-12	2026-02-12 09:49:35.276489	2026-02-12 17:00:33.233372	present	2026-03-02 15:43:44.318533
7249	12	2026-02-12	2026-02-12 09:10:25.374997	2026-02-12 17:55:45.269245	present	2026-03-02 15:43:44.318533
7250	13	2026-02-12	2026-02-12 09:34:41.284878	2026-02-12 17:19:00.00143	present	2026-03-02 15:43:44.318533
7251	14	2026-02-12	2026-02-12 09:35:53.791768	2026-02-12 17:55:44.716081	present	2026-03-02 15:43:44.318533
7252	15	2026-02-12	2026-02-12 09:45:34.24128	2026-02-12 17:49:33.406684	present	2026-03-02 15:43:44.318533
7253	16	2026-02-12	2026-02-12 09:16:32.999058	2026-02-12 17:21:13.188006	present	2026-03-02 15:43:44.318533
7254	17	2026-02-12	2026-02-12 09:22:53.155023	2026-02-12 17:37:08.303075	present	2026-03-02 15:43:44.318533
7255	18	2026-02-12	2026-02-12 09:03:19.003259	2026-02-12 17:24:52.291312	present	2026-03-02 15:43:44.318533
7256	19	2026-02-12	2026-02-12 09:09:39.261679	2026-02-12 17:25:47.041714	present	2026-03-02 15:43:44.318533
7257	20	2026-02-12	2026-02-12 09:23:23.436959	2026-02-12 17:26:49.282707	present	2026-03-02 15:43:44.318533
7258	21	2026-02-12	2026-02-12 09:16:53.583458	2026-02-12 17:59:22.666467	present	2026-03-02 15:43:44.318533
7259	22	2026-02-12	2026-02-12 09:24:53.527862	2026-02-12 17:55:40.229389	present	2026-03-02 15:43:44.318533
7260	23	2026-02-12	2026-02-12 09:34:44.400876	2026-02-12 17:59:22.697792	present	2026-03-02 15:43:44.318533
7261	24	2026-02-12	2026-02-12 09:48:05.551254	2026-02-12 17:04:57.272855	present	2026-03-02 15:43:44.318533
7262	25	2026-02-12	2026-02-12 09:30:12.545665	2026-02-12 17:50:06.175263	present	2026-03-02 15:43:44.318533
7263	26	2026-02-12	2026-02-12 09:58:22.85011	2026-02-12 17:22:26.666651	present	2026-03-02 15:43:44.318533
7264	28	2026-02-12	2026-02-12 09:16:52.298476	2026-02-12 17:49:01.334433	present	2026-03-02 15:43:44.318533
7265	29	2026-02-12	2026-02-12 09:47:10.014373	2026-02-12 17:17:34.831964	present	2026-03-02 15:43:44.318533
7266	30	2026-02-12	2026-02-12 09:12:04.884069	2026-02-12 17:21:52.770043	present	2026-03-02 15:43:44.318533
7267	31	2026-02-12	2026-02-12 09:00:28.05961	2026-02-12 17:35:09.088854	present	2026-03-02 15:43:44.318533
7268	32	2026-02-12	2026-02-12 09:31:51.529403	2026-02-12 17:22:26.310028	present	2026-03-02 15:43:44.318533
7269	34	2026-02-12	2026-02-12 09:40:06.861493	2026-02-12 17:51:27.401611	present	2026-03-02 15:43:44.318533
7270	36	2026-02-12	2026-02-12 09:08:00.858272	2026-02-12 17:17:31.720206	present	2026-03-02 15:43:44.318533
7271	38	2026-02-12	2026-02-12 09:45:52.782482	2026-02-12 17:44:48.221219	present	2026-03-02 15:43:44.318533
7272	39	2026-02-12	2026-02-12 09:14:22.78442	2026-02-12 17:31:20.336787	present	2026-03-02 15:43:44.318533
7273	40	2026-02-12	2026-02-12 09:14:37.148512	2026-02-12 17:53:12.946241	present	2026-03-02 15:43:44.318533
7274	41	2026-02-12	2026-02-12 09:38:16.336737	2026-02-12 17:01:52.157671	present	2026-03-02 15:43:44.318533
7275	42	2026-02-12	2026-02-12 09:21:57.959083	2026-02-12 17:48:04.299978	present	2026-03-02 15:43:44.318533
7276	44	2026-02-12	2026-02-12 09:41:26.129748	2026-02-12 17:55:56.466434	present	2026-03-02 15:43:44.318533
7277	49	2026-02-12	2026-02-12 09:00:28.186378	2026-02-12 17:21:07.642403	present	2026-03-02 15:43:44.318533
7278	51	2026-02-12	2026-02-12 09:25:53.262194	2026-02-12 17:00:51.609864	present	2026-03-02 15:43:44.318533
7279	53	2026-02-12	2026-02-12 09:09:40.872145	2026-02-12 17:24:51.852077	present	2026-03-02 15:43:44.318533
7280	54	2026-02-12	2026-02-12 09:02:42.245421	2026-02-12 17:39:26.800937	present	2026-03-02 15:43:44.318533
7281	55	2026-02-12	2026-02-12 09:32:24.674389	2026-02-12 17:03:20.755053	present	2026-03-02 15:43:44.318533
7282	56	2026-02-12	2026-02-12 09:42:12.997461	2026-02-12 17:20:01.325019	present	2026-03-02 15:43:44.318533
7283	57	2026-02-12	2026-02-12 09:26:10.739032	2026-02-12 17:33:36.999547	present	2026-03-02 15:43:44.318533
7284	58	2026-02-12	2026-02-12 09:03:16.64189	2026-02-12 17:46:12.697922	present	2026-03-02 15:43:44.318533
7285	61	2026-02-12	2026-02-12 09:45:55.467739	2026-02-12 17:48:32.538011	present	2026-03-02 15:43:44.318533
7286	67	2026-02-12	2026-02-12 09:30:05.805286	2026-02-12 17:39:21.959904	present	2026-03-02 15:43:44.318533
7287	68	2026-02-12	2026-02-12 09:04:26.884239	2026-02-12 17:37:52.476963	present	2026-03-02 15:43:44.318533
7288	69	2026-02-12	2026-02-12 09:52:55.198089	2026-02-12 17:02:04.036182	present	2026-03-02 15:43:44.318533
7289	72	2026-02-12	2026-02-12 09:25:33.428186	2026-02-12 17:09:08.387043	present	2026-03-02 15:43:44.318533
7290	75	2026-02-12	2026-02-12 09:57:01.029305	2026-02-12 17:37:24.116221	present	2026-03-02 15:43:44.318533
7291	76	2026-02-12	2026-02-12 09:33:29.521371	2026-02-12 17:45:35.845269	present	2026-03-02 15:43:44.318533
7292	77	2026-02-12	2026-02-12 09:16:22.781569	2026-02-12 17:47:49.919191	present	2026-03-02 15:43:44.318533
7293	80	2026-02-12	2026-02-12 09:49:29.607825	2026-02-12 17:11:27.565198	present	2026-03-02 15:43:44.318533
7294	81	2026-02-12	2026-02-12 09:02:43.11384	2026-02-12 17:12:02.105229	present	2026-03-02 15:43:44.318533
7295	86	2026-02-12	2026-02-12 09:56:04.041329	2026-02-12 17:20:59.525799	present	2026-03-02 15:43:44.318533
7296	87	2026-02-12	2026-02-12 09:07:02.868635	2026-02-12 17:39:02.202833	present	2026-03-02 15:43:44.318533
7297	90	2026-02-12	2026-02-12 09:41:33.106534	2026-02-12 17:32:28.923185	present	2026-03-02 15:43:44.318533
7298	91	2026-02-12	2026-02-12 09:47:04.889327	2026-02-12 17:26:19.273074	present	2026-03-02 15:43:44.318533
7299	92	2026-02-12	2026-02-12 09:56:10.136078	2026-02-12 17:08:23.576524	present	2026-03-02 15:43:44.318533
7300	93	2026-02-12	2026-02-12 09:40:39.509869	2026-02-12 17:58:27.11651	present	2026-03-02 15:43:44.318533
7301	94	2026-02-12	2026-02-12 09:11:01.159024	2026-02-12 17:39:23.210895	present	2026-03-02 15:43:44.318533
7302	95	2026-02-12	2026-02-12 09:15:33.603249	2026-02-12 17:47:39.796724	present	2026-03-02 15:43:44.318533
7303	98	2026-02-12	2026-02-12 09:34:24.009679	2026-02-12 17:23:59.47275	present	2026-03-02 15:43:44.318533
7304	99	2026-02-12	2026-02-12 09:36:36.557507	2026-02-12 17:49:14.863865	present	2026-03-02 15:43:44.318533
7305	100	2026-02-12	2026-02-12 09:42:24.684095	2026-02-12 17:50:24.677066	present	2026-03-02 15:43:44.318533
7306	3	2026-02-13	2026-02-13 09:56:58.714613	2026-02-13 17:01:18.716738	present	2026-03-02 15:43:44.318533
7307	4	2026-02-13	2026-02-13 09:26:00.275927	2026-02-13 17:02:54.292426	present	2026-03-02 15:43:44.318533
7308	5	2026-02-13	2026-02-13 09:17:19.207043	2026-02-13 17:15:31.50429	present	2026-03-02 15:43:44.318533
7309	6	2026-02-13	2026-02-13 09:57:04.761929	2026-02-13 17:20:00.242968	present	2026-03-02 15:43:44.318533
7310	10	2026-02-13	2026-02-13 09:34:07.165148	2026-02-13 17:59:26.456702	present	2026-03-02 15:43:44.318533
7311	11	2026-02-13	2026-02-13 09:01:19.890248	2026-02-13 17:29:04.316667	present	2026-03-02 15:43:44.318533
7312	27	2026-02-13	2026-02-13 09:22:06.825087	2026-02-13 17:45:42.255041	present	2026-03-02 15:43:44.318533
7313	33	2026-02-13	2026-02-13 09:23:49.886039	2026-02-13 17:47:39.320518	present	2026-03-02 15:43:44.318533
7314	35	2026-02-13	2026-02-13 09:57:04.586234	2026-02-13 17:20:45.773554	present	2026-03-02 15:43:44.318533
7315	37	2026-02-13	2026-02-13 09:12:13.717876	2026-02-13 17:40:59.212732	present	2026-03-02 15:43:44.318533
7316	43	2026-02-13	2026-02-13 09:57:02.106976	2026-02-13 17:49:49.132294	present	2026-03-02 15:43:44.318533
7317	45	2026-02-13	2026-02-13 09:32:46.328209	2026-02-13 17:38:13.319412	present	2026-03-02 15:43:44.318533
7318	46	2026-02-13	2026-02-13 09:48:18.052948	2026-02-13 17:50:51.606069	present	2026-03-02 15:43:44.318533
7319	47	2026-02-13	2026-02-13 09:02:59.870903	2026-02-13 17:52:36.245981	present	2026-03-02 15:43:44.318533
7320	48	2026-02-13	2026-02-13 09:05:29.946638	2026-02-13 17:54:05.700084	present	2026-03-02 15:43:44.318533
7321	50	2026-02-13	2026-02-13 09:59:32.063841	2026-02-13 17:05:54.546093	present	2026-03-02 15:43:44.318533
7322	52	2026-02-13	2026-02-13 09:47:14.448396	2026-02-13 17:07:57.212421	present	2026-03-02 15:43:44.318533
7323	59	2026-02-13	2026-02-13 09:59:40.546579	2026-02-13 17:08:36.251267	present	2026-03-02 15:43:44.318533
7324	60	2026-02-13	2026-02-13 09:20:53.005713	2026-02-13 17:47:26.417722	present	2026-03-02 15:43:44.318533
7325	62	2026-02-13	2026-02-13 09:38:37.508701	2026-02-13 17:54:36.457524	present	2026-03-02 15:43:44.318533
7326	63	2026-02-13	2026-02-13 09:41:38.528029	2026-02-13 17:40:48.015345	present	2026-03-02 15:43:44.318533
7327	64	2026-02-13	2026-02-13 09:54:10.419336	2026-02-13 17:35:19.30557	present	2026-03-02 15:43:44.318533
7328	65	2026-02-13	2026-02-13 09:01:49.872721	2026-02-13 17:13:42.870386	present	2026-03-02 15:43:44.318533
7329	66	2026-02-13	2026-02-13 09:21:50.915209	2026-02-13 17:33:17.462913	present	2026-03-02 15:43:44.318533
7330	70	2026-02-13	2026-02-13 09:05:05.605005	2026-02-13 17:06:34.296449	present	2026-03-02 15:43:44.318533
7331	71	2026-02-13	2026-02-13 09:07:14.89181	2026-02-13 17:40:46.579788	present	2026-03-02 15:43:44.318533
7332	73	2026-02-13	2026-02-13 09:09:14.412957	2026-02-13 17:16:56.48288	present	2026-03-02 15:43:44.318533
7333	74	2026-02-13	2026-02-13 09:48:30.028197	2026-02-13 17:50:54.759951	present	2026-03-02 15:43:44.318533
7334	78	2026-02-13	2026-02-13 09:32:37.404351	2026-02-13 17:02:53.747387	present	2026-03-02 15:43:44.318533
7335	79	2026-02-13	2026-02-13 09:13:21.383772	2026-02-13 17:34:50.27245	present	2026-03-02 15:43:44.318533
7336	82	2026-02-13	2026-02-13 09:17:55.60672	2026-02-13 17:53:46.058005	present	2026-03-02 15:43:44.318533
7337	83	2026-02-13	2026-02-13 09:23:11.734657	2026-02-13 17:45:20.082948	present	2026-03-02 15:43:44.318533
7338	84	2026-02-13	2026-02-13 09:30:20.168703	2026-02-13 17:22:22.773152	present	2026-03-02 15:43:44.318533
7339	85	2026-02-13	2026-02-13 09:54:06.182137	2026-02-13 17:31:09.778031	present	2026-03-02 15:43:44.318533
7340	88	2026-02-13	2026-02-13 09:26:34.738801	2026-02-13 17:13:29.367281	present	2026-03-02 15:43:44.318533
7341	89	2026-02-13	2026-02-13 09:29:47.875195	2026-02-13 17:41:04.35265	present	2026-03-02 15:43:44.318533
7342	96	2026-02-13	2026-02-13 09:05:02.938581	2026-02-13 17:33:23.902576	present	2026-03-02 15:43:44.318533
7343	97	2026-02-13	2026-02-13 09:48:26.64012	2026-02-13 17:52:12.515863	present	2026-03-02 15:43:44.318533
7344	1	2026-02-13	2026-02-13 09:28:29.306417	2026-02-13 17:51:22.99837	present	2026-03-02 15:43:44.318533
7345	2	2026-02-13	2026-02-13 09:51:18.878217	2026-02-13 17:08:36.971532	present	2026-03-02 15:43:44.318533
7346	7	2026-02-13	2026-02-13 09:33:04.83598	2026-02-13 17:36:50.759132	present	2026-03-02 15:43:44.318533
7347	8	2026-02-13	2026-02-13 09:04:07.200532	2026-02-13 17:31:03.930854	present	2026-03-02 15:43:44.318533
7348	9	2026-02-13	2026-02-13 09:18:44.5751	2026-02-13 17:15:33.662433	present	2026-03-02 15:43:44.318533
7349	12	2026-02-13	2026-02-13 09:57:37.142467	2026-02-13 17:42:33.313974	present	2026-03-02 15:43:44.318533
7350	13	2026-02-13	2026-02-13 09:41:06.81361	2026-02-13 17:55:36.953934	present	2026-03-02 15:43:44.318533
7351	14	2026-02-13	2026-02-13 09:09:24.086302	2026-02-13 17:50:16.349353	present	2026-03-02 15:43:44.318533
7352	15	2026-02-13	2026-02-13 09:11:46.658605	2026-02-13 17:48:24.308695	present	2026-03-02 15:43:44.318533
7353	16	2026-02-13	2026-02-13 09:49:38.677577	2026-02-13 17:55:39.850215	present	2026-03-02 15:43:44.318533
7354	17	2026-02-13	2026-02-13 09:50:45.796082	2026-02-13 17:49:42.830924	present	2026-03-02 15:43:44.318533
7355	18	2026-02-13	2026-02-13 09:17:22.561414	2026-02-13 17:30:42.070449	present	2026-03-02 15:43:44.318533
7356	19	2026-02-13	2026-02-13 09:39:12.48139	2026-02-13 17:42:56.676731	present	2026-03-02 15:43:44.318533
7357	20	2026-02-13	2026-02-13 09:50:28.79045	2026-02-13 17:31:10.14755	present	2026-03-02 15:43:44.318533
7358	21	2026-02-13	2026-02-13 09:44:02.351372	2026-02-13 17:59:40.565154	present	2026-03-02 15:43:44.318533
7359	22	2026-02-13	2026-02-13 09:42:07.45733	2026-02-13 17:00:41.30159	present	2026-03-02 15:43:44.318533
7360	23	2026-02-13	2026-02-13 09:10:54.336519	2026-02-13 17:20:29.483817	present	2026-03-02 15:43:44.318533
7361	24	2026-02-13	2026-02-13 09:31:05.207704	2026-02-13 17:38:04.790416	present	2026-03-02 15:43:44.318533
7362	25	2026-02-13	2026-02-13 09:58:57.337769	2026-02-13 17:15:29.511174	present	2026-03-02 15:43:44.318533
7363	26	2026-02-13	2026-02-13 09:48:07.100912	2026-02-13 17:00:23.236365	present	2026-03-02 15:43:44.318533
7364	28	2026-02-13	2026-02-13 09:19:24.140471	2026-02-13 17:49:41.246885	present	2026-03-02 15:43:44.318533
7365	29	2026-02-13	2026-02-13 09:49:19.293704	2026-02-13 17:58:55.023984	present	2026-03-02 15:43:44.318533
7366	30	2026-02-13	2026-02-13 09:41:20.713127	2026-02-13 17:23:08.752182	present	2026-03-02 15:43:44.318533
7367	31	2026-02-13	2026-02-13 09:03:00.596209	2026-02-13 17:26:37.335777	present	2026-03-02 15:43:44.318533
7368	32	2026-02-13	2026-02-13 09:33:03.703856	2026-02-13 17:40:43.801539	present	2026-03-02 15:43:44.318533
7369	34	2026-02-13	2026-02-13 09:55:17.748297	2026-02-13 17:45:39.403083	present	2026-03-02 15:43:44.318533
7370	36	2026-02-13	2026-02-13 09:22:54.510831	2026-02-13 17:34:35.297041	present	2026-03-02 15:43:44.318533
7371	38	2026-02-13	2026-02-13 09:32:14.980267	2026-02-13 17:36:28.092962	present	2026-03-02 15:43:44.318533
7372	39	2026-02-13	2026-02-13 09:40:32.304209	2026-02-13 17:25:28.22746	present	2026-03-02 15:43:44.318533
7373	40	2026-02-13	2026-02-13 09:17:25.437	2026-02-13 17:08:32.902421	present	2026-03-02 15:43:44.318533
7374	41	2026-02-13	2026-02-13 09:04:24.823179	2026-02-13 17:59:51.66107	present	2026-03-02 15:43:44.318533
7375	42	2026-02-13	2026-02-13 09:20:54.673515	2026-02-13 17:34:11.946571	present	2026-03-02 15:43:44.318533
7376	44	2026-02-13	2026-02-13 09:46:23.972092	2026-02-13 17:02:20.738459	present	2026-03-02 15:43:44.318533
7377	49	2026-02-13	2026-02-13 09:25:50.945971	2026-02-13 17:47:28.697483	present	2026-03-02 15:43:44.318533
7378	51	2026-02-13	2026-02-13 09:25:20.78364	2026-02-13 17:36:01.128785	present	2026-03-02 15:43:44.318533
7379	53	2026-02-13	2026-02-13 09:09:13.593308	2026-02-13 17:49:33.532696	present	2026-03-02 15:43:44.318533
7380	54	2026-02-13	2026-02-13 09:11:39.334865	2026-02-13 17:15:05.089573	present	2026-03-02 15:43:44.318533
7381	55	2026-02-13	2026-02-13 09:52:44.682486	2026-02-13 17:23:27.272955	present	2026-03-02 15:43:44.318533
7382	56	2026-02-13	2026-02-13 09:03:18.8534	2026-02-13 17:12:39.965781	present	2026-03-02 15:43:44.318533
7383	57	2026-02-13	2026-02-13 09:14:53.507054	2026-02-13 17:03:35.265062	present	2026-03-02 15:43:44.318533
7384	58	2026-02-13	2026-02-13 09:19:11.003449	2026-02-13 17:54:20.612125	present	2026-03-02 15:43:44.318533
7385	61	2026-02-13	2026-02-13 09:43:20.83379	2026-02-13 17:01:23.375765	present	2026-03-02 15:43:44.318533
7386	67	2026-02-13	2026-02-13 09:50:58.940392	2026-02-13 17:35:32.116263	present	2026-03-02 15:43:44.318533
7387	68	2026-02-13	2026-02-13 09:22:19.103206	2026-02-13 17:33:24.269972	present	2026-03-02 15:43:44.318533
7388	69	2026-02-13	2026-02-13 09:32:58.686025	2026-02-13 17:49:33.235409	present	2026-03-02 15:43:44.318533
7389	72	2026-02-13	2026-02-13 09:41:00.919522	2026-02-13 17:49:44.446642	present	2026-03-02 15:43:44.318533
7390	75	2026-02-13	2026-02-13 09:27:50.141375	2026-02-13 17:24:55.217511	present	2026-03-02 15:43:44.318533
7391	76	2026-02-13	2026-02-13 09:30:05.763461	2026-02-13 17:12:09.959946	present	2026-03-02 15:43:44.318533
7392	77	2026-02-13	2026-02-13 09:54:33.33943	2026-02-13 17:15:49.207384	present	2026-03-02 15:43:44.318533
7393	80	2026-02-13	2026-02-13 09:55:05.766025	2026-02-13 17:00:18.12339	present	2026-03-02 15:43:44.318533
7394	81	2026-02-13	2026-02-13 09:31:17.457789	2026-02-13 17:28:53.821081	present	2026-03-02 15:43:44.318533
7395	86	2026-02-13	2026-02-13 09:20:42.252582	2026-02-13 17:29:52.60868	present	2026-03-02 15:43:44.318533
7396	87	2026-02-13	2026-02-13 09:33:52.259376	2026-02-13 17:25:53.670819	present	2026-03-02 15:43:44.318533
7397	90	2026-02-13	2026-02-13 09:35:53.880072	2026-02-13 17:50:51.64149	present	2026-03-02 15:43:44.318533
7398	91	2026-02-13	2026-02-13 09:45:41.696922	2026-02-13 17:42:59.005743	present	2026-03-02 15:43:44.318533
7399	92	2026-02-13	2026-02-13 09:18:08.111905	2026-02-13 17:22:19.209459	present	2026-03-02 15:43:44.318533
7400	93	2026-02-13	2026-02-13 09:11:22.757645	2026-02-13 17:37:44.218537	present	2026-03-02 15:43:44.318533
7401	94	2026-02-13	2026-02-13 09:05:28.575421	2026-02-13 17:18:07.613374	present	2026-03-02 15:43:44.318533
7402	95	2026-02-13	2026-02-13 09:21:47.134534	2026-02-13 17:22:34.084404	present	2026-03-02 15:43:44.318533
7403	98	2026-02-13	2026-02-13 09:50:26.669094	2026-02-13 17:08:25.699728	present	2026-03-02 15:43:44.318533
7404	99	2026-02-13	2026-02-13 09:36:02.77651	2026-02-13 17:39:10.291073	present	2026-03-02 15:43:44.318533
7405	100	2026-02-13	2026-02-13 09:08:20.295955	2026-02-13 17:19:08.408072	present	2026-03-02 15:43:44.318533
7406	3	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7407	4	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7408	5	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7409	6	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7410	10	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7411	11	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7412	27	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7413	33	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7414	35	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7415	37	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7416	43	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7417	45	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7418	46	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7419	47	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7420	48	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7421	50	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7422	52	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7423	59	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7424	60	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7425	62	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7426	63	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7427	64	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7428	65	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7429	66	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7430	70	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7431	71	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7432	73	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7433	74	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7434	78	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7435	79	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7436	82	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7437	83	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7438	84	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7439	85	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7440	88	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7441	89	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7442	96	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7443	97	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7444	1	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7445	2	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7446	7	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7447	8	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7448	9	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7449	12	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7450	13	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7451	14	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7452	15	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7453	16	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7454	17	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7455	18	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7456	19	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7457	20	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7458	21	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7459	22	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7460	23	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7461	24	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7462	25	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7463	26	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7464	28	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7465	29	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7466	30	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7467	31	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7468	32	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7469	34	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7470	36	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7471	38	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7472	39	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7473	40	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7474	41	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7475	42	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7476	44	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7477	49	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7478	51	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7479	53	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7480	54	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7481	55	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7482	56	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7483	57	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7484	58	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7485	61	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7486	67	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7487	68	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7488	69	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7489	72	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7490	75	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7491	76	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7492	77	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7493	80	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7494	81	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7495	86	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7496	87	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7497	90	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7498	91	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7499	92	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7500	93	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7501	94	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7502	95	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7503	98	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7504	99	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7505	100	2026-02-14	\N	\N	absent	2026-03-02 15:43:44.318533
7506	3	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7507	4	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7508	5	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7509	6	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7510	10	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7511	11	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7512	27	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7513	33	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7514	35	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7515	37	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7516	43	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7517	45	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7518	46	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7519	47	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7520	48	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7521	50	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7522	52	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7523	59	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7524	60	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7525	62	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7526	63	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7527	64	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7528	65	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7529	66	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7530	70	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7531	71	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7532	73	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7533	74	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7534	78	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7535	79	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7536	82	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7537	83	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7538	84	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7539	85	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7540	88	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7541	89	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7542	96	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7543	97	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7544	1	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7545	2	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7546	7	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7547	8	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7548	9	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7549	12	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7550	13	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7551	14	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7552	15	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7553	16	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7554	17	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7555	18	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7556	19	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7557	20	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7558	21	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7559	22	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7560	23	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7561	24	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7562	25	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7563	26	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7564	28	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7565	29	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7566	30	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7567	31	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7568	32	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7569	34	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7570	36	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7571	38	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7572	39	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7573	40	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7574	41	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7575	42	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7576	44	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7577	49	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7578	51	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7579	53	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7580	54	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7581	55	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7582	56	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7583	57	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7584	58	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7585	61	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7586	67	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7587	68	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7588	69	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7589	72	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7590	75	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7591	76	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7592	77	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7593	80	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7594	81	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7595	86	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7596	87	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7597	90	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7598	91	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7599	92	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7600	93	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7601	94	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7602	95	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7603	98	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7604	99	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7605	100	2026-02-15	\N	\N	absent	2026-03-02 15:43:44.318533
7606	3	2026-02-16	2026-02-16 09:42:53.145377	2026-02-16 17:38:16.51043	present	2026-03-02 15:43:44.318533
7607	4	2026-02-16	2026-02-16 09:14:17.030913	2026-02-16 17:03:00.340223	present	2026-03-02 15:43:44.318533
7608	5	2026-02-16	2026-02-16 09:31:44.758179	2026-02-16 17:15:12.591572	present	2026-03-02 15:43:44.318533
7609	6	2026-02-16	2026-02-16 09:49:48.674622	2026-02-16 17:28:05.436201	present	2026-03-02 15:43:44.318533
7610	10	2026-02-16	2026-02-16 09:09:17.81805	2026-02-16 17:02:58.926726	present	2026-03-02 15:43:44.318533
7611	11	2026-02-16	2026-02-16 09:53:13.603451	2026-02-16 17:17:57.296303	present	2026-03-02 15:43:44.318533
7612	27	2026-02-16	2026-02-16 09:43:06.233578	2026-02-16 17:32:47.607567	present	2026-03-02 15:43:44.318533
7613	33	2026-02-16	2026-02-16 09:34:00.007483	2026-02-16 17:04:52.445637	present	2026-03-02 15:43:44.318533
7614	35	2026-02-16	2026-02-16 09:25:59.270464	2026-02-16 17:31:21.856319	present	2026-03-02 15:43:44.318533
7615	37	2026-02-16	2026-02-16 09:33:27.161109	2026-02-16 17:23:13.032006	present	2026-03-02 15:43:44.318533
7616	43	2026-02-16	2026-02-16 09:23:07.648215	2026-02-16 17:17:42.92814	present	2026-03-02 15:43:44.318533
7617	45	2026-02-16	2026-02-16 09:45:20.967622	2026-02-16 17:48:34.758284	present	2026-03-02 15:43:44.318533
7618	46	2026-02-16	2026-02-16 09:39:08.830198	2026-02-16 17:35:09.940302	present	2026-03-02 15:43:44.318533
7619	47	2026-02-16	2026-02-16 09:33:58.440368	2026-02-16 17:56:58.896736	present	2026-03-02 15:43:44.318533
7620	48	2026-02-16	2026-02-16 09:44:43.664165	2026-02-16 17:42:00.896464	present	2026-03-02 15:43:44.318533
7621	50	2026-02-16	2026-02-16 09:39:42.195245	2026-02-16 17:07:45.28063	present	2026-03-02 15:43:44.318533
7622	52	2026-02-16	2026-02-16 09:19:07.64808	2026-02-16 17:52:16.03537	present	2026-03-02 15:43:44.318533
7623	59	2026-02-16	2026-02-16 09:34:31.762961	2026-02-16 17:45:22.59243	present	2026-03-02 15:43:44.318533
7624	60	2026-02-16	2026-02-16 09:18:36.479989	2026-02-16 17:17:35.627816	present	2026-03-02 15:43:44.318533
7625	62	2026-02-16	2026-02-16 09:28:35.133893	2026-02-16 17:58:08.497328	present	2026-03-02 15:43:44.318533
7626	63	2026-02-16	2026-02-16 09:05:23.052052	2026-02-16 17:45:40.58881	present	2026-03-02 15:43:44.318533
7627	64	2026-02-16	2026-02-16 09:38:43.741767	2026-02-16 17:33:21.773548	present	2026-03-02 15:43:44.318533
7628	65	2026-02-16	2026-02-16 09:56:24.841846	2026-02-16 17:58:46.486207	present	2026-03-02 15:43:44.318533
7629	66	2026-02-16	2026-02-16 09:14:12.557637	2026-02-16 17:41:31.954531	present	2026-03-02 15:43:44.318533
7630	70	2026-02-16	2026-02-16 09:12:13.427215	2026-02-16 17:47:56.935854	present	2026-03-02 15:43:44.318533
7631	71	2026-02-16	2026-02-16 09:54:39.888525	2026-02-16 17:27:54.728776	present	2026-03-02 15:43:44.318533
7632	73	2026-02-16	2026-02-16 09:11:45.926042	2026-02-16 17:58:38.480387	present	2026-03-02 15:43:44.318533
7633	74	2026-02-16	2026-02-16 09:24:17.582	2026-02-16 17:43:02.166597	present	2026-03-02 15:43:44.318533
7634	78	2026-02-16	2026-02-16 09:27:14.126106	2026-02-16 17:43:28.374915	present	2026-03-02 15:43:44.318533
7635	79	2026-02-16	2026-02-16 09:24:54.697208	2026-02-16 17:39:42.487521	present	2026-03-02 15:43:44.318533
7636	82	2026-02-16	2026-02-16 09:03:42.178282	2026-02-16 17:13:56.202822	present	2026-03-02 15:43:44.318533
7637	83	2026-02-16	2026-02-16 09:47:15.606985	2026-02-16 17:18:28.315657	present	2026-03-02 15:43:44.318533
7638	84	2026-02-16	2026-02-16 09:54:33.996568	2026-02-16 17:28:34.365078	present	2026-03-02 15:43:44.318533
7639	85	2026-02-16	2026-02-16 09:16:56.403537	2026-02-16 17:22:12.504465	present	2026-03-02 15:43:44.318533
7640	88	2026-02-16	2026-02-16 09:25:38.408641	2026-02-16 17:04:41.672457	present	2026-03-02 15:43:44.318533
7641	89	2026-02-16	2026-02-16 09:14:59.752746	2026-02-16 17:26:00.648084	present	2026-03-02 15:43:44.318533
7642	96	2026-02-16	2026-02-16 09:54:57.036328	2026-02-16 17:40:28.16076	present	2026-03-02 15:43:44.318533
7643	97	2026-02-16	2026-02-16 09:55:50.467474	2026-02-16 17:48:31.93762	present	2026-03-02 15:43:44.318533
7644	1	2026-02-16	2026-02-16 09:14:48.512936	2026-02-16 17:17:53.569934	present	2026-03-02 15:43:44.318533
7645	2	2026-02-16	2026-02-16 09:27:18.082887	2026-02-16 17:37:13.116163	present	2026-03-02 15:43:44.318533
7646	7	2026-02-16	2026-02-16 09:57:27.60004	2026-02-16 17:15:23.557253	present	2026-03-02 15:43:44.318533
7647	8	2026-02-16	2026-02-16 09:57:05.590211	2026-02-16 17:29:58.058317	present	2026-03-02 15:43:44.318533
7648	9	2026-02-16	2026-02-16 09:44:31.61464	2026-02-16 17:47:32.661472	present	2026-03-02 15:43:44.318533
7649	12	2026-02-16	2026-02-16 09:17:58.051425	2026-02-16 17:03:49.815125	present	2026-03-02 15:43:44.318533
7650	13	2026-02-16	2026-02-16 09:16:17.727989	2026-02-16 17:02:29.256289	present	2026-03-02 15:43:44.318533
7651	14	2026-02-16	2026-02-16 09:17:41.790752	2026-02-16 17:27:57.363908	present	2026-03-02 15:43:44.318533
7652	15	2026-02-16	2026-02-16 09:30:07.511274	2026-02-16 17:45:21.326668	present	2026-03-02 15:43:44.318533
7653	16	2026-02-16	2026-02-16 09:35:09.619157	2026-02-16 17:49:52.119283	present	2026-03-02 15:43:44.318533
7654	17	2026-02-16	2026-02-16 09:25:00.144162	2026-02-16 17:34:34.270349	present	2026-03-02 15:43:44.318533
7655	18	2026-02-16	2026-02-16 09:26:10.421676	2026-02-16 17:04:03.05214	present	2026-03-02 15:43:44.318533
7656	19	2026-02-16	2026-02-16 09:16:38.718316	2026-02-16 17:22:52.869488	present	2026-03-02 15:43:44.318533
7657	20	2026-02-16	2026-02-16 09:23:00.160015	2026-02-16 17:22:58.22253	present	2026-03-02 15:43:44.318533
7658	21	2026-02-16	2026-02-16 09:46:02.339318	2026-02-16 17:13:59.436814	present	2026-03-02 15:43:44.318533
7659	22	2026-02-16	2026-02-16 09:34:58.742683	2026-02-16 17:14:58.632727	present	2026-03-02 15:43:44.318533
7660	23	2026-02-16	2026-02-16 09:27:50.425849	2026-02-16 17:07:46.856369	present	2026-03-02 15:43:44.318533
7661	24	2026-02-16	2026-02-16 09:52:52.624309	2026-02-16 17:38:50.409972	present	2026-03-02 15:43:44.318533
7662	25	2026-02-16	2026-02-16 09:25:27.671678	2026-02-16 17:01:51.063049	present	2026-03-02 15:43:44.318533
7663	26	2026-02-16	2026-02-16 09:17:00.244019	2026-02-16 17:54:01.913533	present	2026-03-02 15:43:44.318533
7664	28	2026-02-16	2026-02-16 09:48:57.690614	2026-02-16 17:40:43.458531	present	2026-03-02 15:43:44.318533
7665	29	2026-02-16	2026-02-16 09:27:39.535569	2026-02-16 17:11:51.007988	present	2026-03-02 15:43:44.318533
7666	30	2026-02-16	2026-02-16 09:53:27.404773	2026-02-16 17:48:18.704687	present	2026-03-02 15:43:44.318533
7667	31	2026-02-16	2026-02-16 09:44:40.507902	2026-02-16 17:09:08.618644	present	2026-03-02 15:43:44.318533
7668	32	2026-02-16	2026-02-16 09:12:56.83965	2026-02-16 17:23:15.701307	present	2026-03-02 15:43:44.318533
7669	34	2026-02-16	2026-02-16 09:19:30.979972	2026-02-16 17:27:56.066145	present	2026-03-02 15:43:44.318533
7670	36	2026-02-16	2026-02-16 09:27:04.631243	2026-02-16 17:25:17.907443	present	2026-03-02 15:43:44.318533
7671	38	2026-02-16	2026-02-16 09:43:29.627222	2026-02-16 17:26:00.363784	present	2026-03-02 15:43:44.318533
7672	39	2026-02-16	2026-02-16 09:22:44.266947	2026-02-16 17:47:00.179882	present	2026-03-02 15:43:44.318533
7673	40	2026-02-16	2026-02-16 09:24:56.163013	2026-02-16 17:57:51.226754	present	2026-03-02 15:43:44.318533
7674	41	2026-02-16	2026-02-16 09:06:57.993601	2026-02-16 17:47:39.85634	present	2026-03-02 15:43:44.318533
7675	42	2026-02-16	2026-02-16 09:50:55.475268	2026-02-16 17:36:05.953889	present	2026-03-02 15:43:44.318533
7676	44	2026-02-16	2026-02-16 09:29:13.137516	2026-02-16 17:35:14.182168	present	2026-03-02 15:43:44.318533
7677	49	2026-02-16	2026-02-16 09:07:38.930233	2026-02-16 17:57:57.803243	present	2026-03-02 15:43:44.318533
7678	51	2026-02-16	2026-02-16 09:44:52.849816	2026-02-16 17:19:46.91586	present	2026-03-02 15:43:44.318533
7679	53	2026-02-16	2026-02-16 09:35:38.241219	2026-02-16 17:32:53.443403	present	2026-03-02 15:43:44.318533
7680	54	2026-02-16	2026-02-16 09:03:06.502555	2026-02-16 17:32:00.874887	present	2026-03-02 15:43:44.318533
7681	55	2026-02-16	2026-02-16 09:12:35.711219	2026-02-16 17:19:09.32056	present	2026-03-02 15:43:44.318533
7682	56	2026-02-16	2026-02-16 09:10:38.001802	2026-02-16 17:14:22.247703	present	2026-03-02 15:43:44.318533
7683	57	2026-02-16	2026-02-16 09:03:08.232166	2026-02-16 17:55:27.133265	present	2026-03-02 15:43:44.318533
7684	58	2026-02-16	2026-02-16 09:33:41.709031	2026-02-16 17:20:19.367385	present	2026-03-02 15:43:44.318533
7685	61	2026-02-16	2026-02-16 09:39:59.034274	2026-02-16 17:58:12.748681	present	2026-03-02 15:43:44.318533
7686	67	2026-02-16	2026-02-16 09:29:43.40883	2026-02-16 17:11:58.384583	present	2026-03-02 15:43:44.318533
7687	68	2026-02-16	2026-02-16 09:14:08.271285	2026-02-16 17:19:27.09304	present	2026-03-02 15:43:44.318533
7688	69	2026-02-16	2026-02-16 09:57:39.454353	2026-02-16 17:01:44.234937	present	2026-03-02 15:43:44.318533
7689	72	2026-02-16	2026-02-16 09:40:48.392855	2026-02-16 17:14:48.656037	present	2026-03-02 15:43:44.318533
7690	75	2026-02-16	2026-02-16 09:50:22.537421	2026-02-16 17:31:34.017032	present	2026-03-02 15:43:44.318533
7691	76	2026-02-16	2026-02-16 09:02:29.264274	2026-02-16 17:28:00.137827	present	2026-03-02 15:43:44.318533
7692	77	2026-02-16	2026-02-16 09:27:00.582155	2026-02-16 17:31:45.937317	present	2026-03-02 15:43:44.318533
7693	80	2026-02-16	2026-02-16 09:43:22.680458	2026-02-16 17:51:40.957827	present	2026-03-02 15:43:44.318533
7694	81	2026-02-16	2026-02-16 09:28:46.953079	2026-02-16 17:14:52.245364	present	2026-03-02 15:43:44.318533
7695	86	2026-02-16	2026-02-16 09:38:38.494791	2026-02-16 17:41:58.648166	present	2026-03-02 15:43:44.318533
7696	87	2026-02-16	2026-02-16 09:17:12.955924	2026-02-16 17:44:15.170746	present	2026-03-02 15:43:44.318533
7697	90	2026-02-16	2026-02-16 09:29:52.196578	2026-02-16 17:19:20.37969	present	2026-03-02 15:43:44.318533
7698	91	2026-02-16	2026-02-16 09:36:12.564028	2026-02-16 17:54:29.369769	present	2026-03-02 15:43:44.318533
7699	92	2026-02-16	2026-02-16 09:10:51.33624	2026-02-16 17:11:59.483854	present	2026-03-02 15:43:44.318533
7700	93	2026-02-16	2026-02-16 09:50:06.315864	2026-02-16 17:40:30.712432	present	2026-03-02 15:43:44.318533
7701	94	2026-02-16	2026-02-16 09:33:30.777003	2026-02-16 17:48:50.862837	present	2026-03-02 15:43:44.318533
7702	95	2026-02-16	2026-02-16 09:51:00.670518	2026-02-16 17:16:58.294423	present	2026-03-02 15:43:44.318533
7703	98	2026-02-16	2026-02-16 09:52:36.459593	2026-02-16 17:51:28.492983	present	2026-03-02 15:43:44.318533
7704	99	2026-02-16	2026-02-16 09:41:23.866944	2026-02-16 17:31:16.587045	present	2026-03-02 15:43:44.318533
7705	100	2026-02-16	2026-02-16 09:34:27.425444	2026-02-16 17:42:12.470457	present	2026-03-02 15:43:44.318533
7706	3	2026-02-17	2026-02-17 09:58:09.5022	2026-02-17 17:19:16.268643	present	2026-03-02 15:43:44.318533
7707	4	2026-02-17	2026-02-17 09:58:43.972194	2026-02-17 17:18:54.694613	present	2026-03-02 15:43:44.318533
7708	5	2026-02-17	2026-02-17 09:39:05.74624	2026-02-17 17:17:42.472705	present	2026-03-02 15:43:44.318533
7709	6	2026-02-17	2026-02-17 09:12:32.321081	2026-02-17 17:40:48.694473	present	2026-03-02 15:43:44.318533
7710	10	2026-02-17	2026-02-17 09:38:16.966248	2026-02-17 17:00:36.294551	present	2026-03-02 15:43:44.318533
7711	11	2026-02-17	2026-02-17 09:21:38.888756	2026-02-17 17:50:16.48027	present	2026-03-02 15:43:44.318533
7712	27	2026-02-17	2026-02-17 09:05:18.779948	2026-02-17 17:49:10.897286	present	2026-03-02 15:43:44.318533
7713	33	2026-02-17	2026-02-17 09:40:48.537252	2026-02-17 17:51:33.856637	present	2026-03-02 15:43:44.318533
7714	35	2026-02-17	2026-02-17 09:08:04.735087	2026-02-17 17:49:39.752639	present	2026-03-02 15:43:44.318533
7715	37	2026-02-17	2026-02-17 09:56:13.705414	2026-02-17 17:43:04.605047	present	2026-03-02 15:43:44.318533
7716	43	2026-02-17	2026-02-17 09:27:36.148936	2026-02-17 17:18:57.885541	present	2026-03-02 15:43:44.318533
7717	45	2026-02-17	2026-02-17 09:06:06.74247	2026-02-17 17:22:59.00871	present	2026-03-02 15:43:44.318533
7718	46	2026-02-17	2026-02-17 09:01:43.031867	2026-02-17 17:07:18.48173	present	2026-03-02 15:43:44.318533
7719	47	2026-02-17	2026-02-17 09:12:00.427575	2026-02-17 17:47:02.041371	present	2026-03-02 15:43:44.318533
7720	48	2026-02-17	2026-02-17 09:21:56.836853	2026-02-17 17:49:38.790084	present	2026-03-02 15:43:44.318533
7721	50	2026-02-17	2026-02-17 09:11:06.924708	2026-02-17 17:52:11.08099	present	2026-03-02 15:43:44.318533
7722	52	2026-02-17	2026-02-17 09:32:19.748747	2026-02-17 17:32:22.235396	present	2026-03-02 15:43:44.318533
7723	59	2026-02-17	2026-02-17 09:28:02.383722	2026-02-17 17:52:41.592538	present	2026-03-02 15:43:44.318533
7724	60	2026-02-17	2026-02-17 09:35:12.708922	2026-02-17 17:24:00.275956	present	2026-03-02 15:43:44.318533
7725	62	2026-02-17	2026-02-17 09:32:02.088352	2026-02-17 17:23:49.976483	present	2026-03-02 15:43:44.318533
7726	63	2026-02-17	2026-02-17 09:57:09.420167	2026-02-17 17:50:04.469802	present	2026-03-02 15:43:44.318533
7727	64	2026-02-17	2026-02-17 09:26:34.882895	2026-02-17 17:23:48.881131	present	2026-03-02 15:43:44.318533
7728	65	2026-02-17	2026-02-17 09:06:46.706978	2026-02-17 17:30:18.021825	present	2026-03-02 15:43:44.318533
7729	66	2026-02-17	2026-02-17 09:34:53.387267	2026-02-17 17:22:47.545908	present	2026-03-02 15:43:44.318533
7730	70	2026-02-17	2026-02-17 09:53:01.345841	2026-02-17 17:15:02.47606	present	2026-03-02 15:43:44.318533
7731	71	2026-02-17	2026-02-17 09:38:11.556285	2026-02-17 17:44:58.617578	present	2026-03-02 15:43:44.318533
7732	73	2026-02-17	2026-02-17 09:24:38.515539	2026-02-17 17:58:26.463663	present	2026-03-02 15:43:44.318533
7733	74	2026-02-17	2026-02-17 09:33:02.86792	2026-02-17 17:34:40.610731	present	2026-03-02 15:43:44.318533
7734	78	2026-02-17	2026-02-17 09:41:25.764009	2026-02-17 17:40:53.011839	present	2026-03-02 15:43:44.318533
7735	79	2026-02-17	2026-02-17 09:24:38.712149	2026-02-17 17:12:30.974519	present	2026-03-02 15:43:44.318533
7736	82	2026-02-17	2026-02-17 09:10:57.735314	2026-02-17 17:27:49.051521	present	2026-03-02 15:43:44.318533
7737	83	2026-02-17	2026-02-17 09:28:38.110542	2026-02-17 17:35:13.585709	present	2026-03-02 15:43:44.318533
7738	84	2026-02-17	2026-02-17 09:17:12.943406	2026-02-17 17:48:04.002039	present	2026-03-02 15:43:44.318533
7739	85	2026-02-17	2026-02-17 09:21:03.705922	2026-02-17 17:33:15.788074	present	2026-03-02 15:43:44.318533
7740	88	2026-02-17	2026-02-17 09:42:53.592395	2026-02-17 17:49:55.559246	present	2026-03-02 15:43:44.318533
7741	89	2026-02-17	2026-02-17 09:58:57.424152	2026-02-17 17:17:25.470091	present	2026-03-02 15:43:44.318533
7742	96	2026-02-17	2026-02-17 09:58:11.939065	2026-02-17 17:55:12.425348	present	2026-03-02 15:43:44.318533
7743	97	2026-02-17	2026-02-17 09:56:04.202586	2026-02-17 17:46:51.247036	present	2026-03-02 15:43:44.318533
7744	1	2026-02-17	2026-02-17 09:56:26.591488	2026-02-17 17:59:27.907204	present	2026-03-02 15:43:44.318533
7745	2	2026-02-17	2026-02-17 09:04:05.450279	2026-02-17 17:27:55.144226	present	2026-03-02 15:43:44.318533
7746	7	2026-02-17	2026-02-17 09:47:19.772917	2026-02-17 17:04:15.899048	present	2026-03-02 15:43:44.318533
7747	8	2026-02-17	2026-02-17 09:16:11.248025	2026-02-17 17:13:33.264248	present	2026-03-02 15:43:44.318533
7748	9	2026-02-17	2026-02-17 09:19:45.27568	2026-02-17 17:26:34.762356	present	2026-03-02 15:43:44.318533
7749	12	2026-02-17	2026-02-17 09:14:29.113063	2026-02-17 17:57:23.036058	present	2026-03-02 15:43:44.318533
7750	13	2026-02-17	2026-02-17 09:39:23.515242	2026-02-17 17:10:18.177196	present	2026-03-02 15:43:44.318533
7751	14	2026-02-17	2026-02-17 09:59:50.791514	2026-02-17 17:53:02.214188	present	2026-03-02 15:43:44.318533
7752	15	2026-02-17	2026-02-17 09:56:57.596831	2026-02-17 17:21:33.826671	present	2026-03-02 15:43:44.318533
7753	16	2026-02-17	2026-02-17 09:23:30.776329	2026-02-17 17:46:08.647786	present	2026-03-02 15:43:44.318533
7754	17	2026-02-17	2026-02-17 09:02:54.726858	2026-02-17 17:21:23.230771	present	2026-03-02 15:43:44.318533
7755	18	2026-02-17	2026-02-17 09:29:30.309546	2026-02-17 17:18:02.774661	present	2026-03-02 15:43:44.318533
7756	19	2026-02-17	2026-02-17 09:56:04.017398	2026-02-17 17:32:49.288529	present	2026-03-02 15:43:44.318533
7757	20	2026-02-17	2026-02-17 09:36:08.149008	2026-02-17 17:49:38.234521	present	2026-03-02 15:43:44.318533
7758	21	2026-02-17	2026-02-17 09:57:56.761305	2026-02-17 17:43:11.057245	present	2026-03-02 15:43:44.318533
7759	22	2026-02-17	2026-02-17 09:18:22.716408	2026-02-17 17:27:08.777156	present	2026-03-02 15:43:44.318533
7760	23	2026-02-17	2026-02-17 09:32:54.272837	2026-02-17 17:40:28.541179	present	2026-03-02 15:43:44.318533
7761	24	2026-02-17	2026-02-17 09:36:56.480565	2026-02-17 17:11:37.216419	present	2026-03-02 15:43:44.318533
7762	25	2026-02-17	2026-02-17 09:58:55.288062	2026-02-17 17:22:34.955854	present	2026-03-02 15:43:44.318533
7763	26	2026-02-17	2026-02-17 09:23:23.47546	2026-02-17 17:39:02.733595	present	2026-03-02 15:43:44.318533
7764	28	2026-02-17	2026-02-17 09:15:30.81946	2026-02-17 17:56:16.02459	present	2026-03-02 15:43:44.318533
7765	29	2026-02-17	2026-02-17 09:07:12.377686	2026-02-17 17:12:46.082137	present	2026-03-02 15:43:44.318533
7766	30	2026-02-17	2026-02-17 09:01:56.751479	2026-02-17 17:23:44.370913	present	2026-03-02 15:43:44.318533
7767	31	2026-02-17	2026-02-17 09:47:18.132696	2026-02-17 17:38:27.341258	present	2026-03-02 15:43:44.318533
7768	32	2026-02-17	2026-02-17 09:23:38.13532	2026-02-17 17:03:13.614879	present	2026-03-02 15:43:44.318533
7769	34	2026-02-17	2026-02-17 09:14:13.047725	2026-02-17 17:59:31.875967	present	2026-03-02 15:43:44.318533
7770	36	2026-02-17	2026-02-17 09:36:36.883211	2026-02-17 17:09:06.966739	present	2026-03-02 15:43:44.318533
7771	38	2026-02-17	2026-02-17 09:07:46.353673	2026-02-17 17:37:28.959662	present	2026-03-02 15:43:44.318533
7772	39	2026-02-17	2026-02-17 09:31:58.483829	2026-02-17 17:33:59.631723	present	2026-03-02 15:43:44.318533
7773	40	2026-02-17	2026-02-17 09:06:10.753067	2026-02-17 17:35:39.044283	present	2026-03-02 15:43:44.318533
7774	41	2026-02-17	2026-02-17 09:53:11.591932	2026-02-17 17:03:22.56663	present	2026-03-02 15:43:44.318533
7775	42	2026-02-17	2026-02-17 09:11:49.710908	2026-02-17 17:52:11.541	present	2026-03-02 15:43:44.318533
7776	44	2026-02-17	2026-02-17 09:07:10.470656	2026-02-17 17:55:15.26466	present	2026-03-02 15:43:44.318533
7777	49	2026-02-17	2026-02-17 09:00:08.675194	2026-02-17 17:16:55.262363	present	2026-03-02 15:43:44.318533
7778	51	2026-02-17	2026-02-17 09:08:30.452693	2026-02-17 17:40:35.243513	present	2026-03-02 15:43:44.318533
7779	53	2026-02-17	2026-02-17 09:15:52.950393	2026-02-17 17:12:53.573088	present	2026-03-02 15:43:44.318533
7780	54	2026-02-17	2026-02-17 09:21:47.667401	2026-02-17 17:45:50.808034	present	2026-03-02 15:43:44.318533
7781	55	2026-02-17	2026-02-17 09:48:22.258209	2026-02-17 17:54:09.466725	present	2026-03-02 15:43:44.318533
7782	56	2026-02-17	2026-02-17 09:03:49.076889	2026-02-17 17:42:10.794974	present	2026-03-02 15:43:44.318533
7783	57	2026-02-17	2026-02-17 09:36:54.335503	2026-02-17 17:40:55.236399	present	2026-03-02 15:43:44.318533
7784	58	2026-02-17	2026-02-17 09:53:07.654707	2026-02-17 17:50:19.643184	present	2026-03-02 15:43:44.318533
7785	61	2026-02-17	2026-02-17 09:25:20.561451	2026-02-17 17:15:19.021964	present	2026-03-02 15:43:44.318533
7786	67	2026-02-17	2026-02-17 09:45:00.882825	2026-02-17 17:03:11.588885	present	2026-03-02 15:43:44.318533
7787	68	2026-02-17	2026-02-17 09:04:05.459822	2026-02-17 17:11:49.024353	present	2026-03-02 15:43:44.318533
7788	69	2026-02-17	2026-02-17 09:03:18.844709	2026-02-17 17:57:59.663263	present	2026-03-02 15:43:44.318533
7789	72	2026-02-17	2026-02-17 09:11:59.623922	2026-02-17 17:06:05.726041	present	2026-03-02 15:43:44.318533
7790	75	2026-02-17	2026-02-17 09:29:01.903515	2026-02-17 17:24:30.096375	present	2026-03-02 15:43:44.318533
7791	76	2026-02-17	2026-02-17 09:22:28.09984	2026-02-17 17:39:24.308231	present	2026-03-02 15:43:44.318533
7792	77	2026-02-17	2026-02-17 09:03:07.402567	2026-02-17 17:11:54.722363	present	2026-03-02 15:43:44.318533
7793	80	2026-02-17	2026-02-17 09:25:11.165027	2026-02-17 17:17:54.782718	present	2026-03-02 15:43:44.318533
7794	81	2026-02-17	2026-02-17 09:04:06.72653	2026-02-17 17:37:33.674544	present	2026-03-02 15:43:44.318533
7795	86	2026-02-17	2026-02-17 09:58:34.433011	2026-02-17 17:38:09.615353	present	2026-03-02 15:43:44.318533
7796	87	2026-02-17	2026-02-17 09:04:27.344805	2026-02-17 17:38:24.808167	present	2026-03-02 15:43:44.318533
7797	90	2026-02-17	2026-02-17 09:04:07.518474	2026-02-17 17:31:19.770496	present	2026-03-02 15:43:44.318533
7798	91	2026-02-17	2026-02-17 09:08:32.10744	2026-02-17 17:10:08.957542	present	2026-03-02 15:43:44.318533
7799	92	2026-02-17	2026-02-17 09:51:47.169392	2026-02-17 17:00:04.58417	present	2026-03-02 15:43:44.318533
7800	93	2026-02-17	2026-02-17 09:45:26.052875	2026-02-17 17:49:21.70941	present	2026-03-02 15:43:44.318533
7801	94	2026-02-17	2026-02-17 09:27:39.342575	2026-02-17 17:22:12.038839	present	2026-03-02 15:43:44.318533
7802	95	2026-02-17	2026-02-17 09:45:06.919724	2026-02-17 17:11:03.493456	present	2026-03-02 15:43:44.318533
7803	98	2026-02-17	2026-02-17 09:24:16.717922	2026-02-17 17:25:28.695385	present	2026-03-02 15:43:44.318533
7804	99	2026-02-17	2026-02-17 09:05:49.717865	2026-02-17 17:10:50.40858	present	2026-03-02 15:43:44.318533
7805	100	2026-02-17	2026-02-17 09:52:59.980823	2026-02-17 17:10:53.361218	present	2026-03-02 15:43:44.318533
7806	3	2026-02-18	2026-02-18 09:03:30.432898	2026-02-18 17:52:31.685187	present	2026-03-02 15:43:44.318533
7807	4	2026-02-18	2026-02-18 09:03:02.73703	2026-02-18 17:58:34.78116	present	2026-03-02 15:43:44.318533
7808	5	2026-02-18	2026-02-18 09:59:34.997709	2026-02-18 17:20:18.929136	present	2026-03-02 15:43:44.318533
7809	6	2026-02-18	2026-02-18 09:29:51.321127	2026-02-18 17:16:48.315673	present	2026-03-02 15:43:44.318533
7810	10	2026-02-18	2026-02-18 09:01:41.225894	2026-02-18 17:03:00.565978	present	2026-03-02 15:43:44.318533
7811	11	2026-02-18	2026-02-18 09:11:28.604661	2026-02-18 17:39:14.967646	present	2026-03-02 15:43:44.318533
7812	27	2026-02-18	2026-02-18 09:23:19.97597	2026-02-18 17:18:46.004667	present	2026-03-02 15:43:44.318533
7813	33	2026-02-18	2026-02-18 09:10:44.516231	2026-02-18 17:03:23.077859	present	2026-03-02 15:43:44.318533
7814	35	2026-02-18	2026-02-18 09:40:03.224581	2026-02-18 17:30:27.153386	present	2026-03-02 15:43:44.318533
7815	37	2026-02-18	2026-02-18 09:21:27.886433	2026-02-18 17:36:39.57271	present	2026-03-02 15:43:44.318533
7816	43	2026-02-18	2026-02-18 09:20:45.610158	2026-02-18 17:22:22.397709	present	2026-03-02 15:43:44.318533
7817	45	2026-02-18	2026-02-18 09:23:58.014679	2026-02-18 17:21:30.881046	present	2026-03-02 15:43:44.318533
7818	46	2026-02-18	2026-02-18 09:01:32.286097	2026-02-18 17:06:11.207734	present	2026-03-02 15:43:44.318533
7819	47	2026-02-18	2026-02-18 09:12:43.527406	2026-02-18 17:03:01.209916	present	2026-03-02 15:43:44.318533
7820	48	2026-02-18	2026-02-18 09:47:39.696328	2026-02-18 17:18:05.67226	present	2026-03-02 15:43:44.318533
7821	50	2026-02-18	2026-02-18 09:11:13.260824	2026-02-18 17:49:10.015004	present	2026-03-02 15:43:44.318533
7822	52	2026-02-18	2026-02-18 09:21:47.869577	2026-02-18 17:05:34.295794	present	2026-03-02 15:43:44.318533
7823	59	2026-02-18	2026-02-18 09:25:21.736003	2026-02-18 17:43:24.006152	present	2026-03-02 15:43:44.318533
7824	60	2026-02-18	2026-02-18 09:09:12.974668	2026-02-18 17:24:26.356035	present	2026-03-02 15:43:44.318533
7825	62	2026-02-18	2026-02-18 09:26:04.989645	2026-02-18 17:49:34.813399	present	2026-03-02 15:43:44.318533
7826	63	2026-02-18	2026-02-18 09:24:46.551979	2026-02-18 17:45:17.859831	present	2026-03-02 15:43:44.318533
7827	64	2026-02-18	2026-02-18 09:20:21.043959	2026-02-18 17:47:10.277824	present	2026-03-02 15:43:44.318533
7828	65	2026-02-18	2026-02-18 09:20:48.584093	2026-02-18 17:41:29.997586	present	2026-03-02 15:43:44.318533
7829	66	2026-02-18	2026-02-18 09:26:04.402076	2026-02-18 17:52:40.603469	present	2026-03-02 15:43:44.318533
7830	70	2026-02-18	2026-02-18 09:55:57.911281	2026-02-18 17:12:35.893827	present	2026-03-02 15:43:44.318533
7831	71	2026-02-18	2026-02-18 09:15:34.444803	2026-02-18 17:40:38.820498	present	2026-03-02 15:43:44.318533
7832	73	2026-02-18	2026-02-18 09:22:24.03226	2026-02-18 17:32:28.104788	present	2026-03-02 15:43:44.318533
7833	74	2026-02-18	2026-02-18 09:51:34.601575	2026-02-18 17:33:52.489823	present	2026-03-02 15:43:44.318533
7834	78	2026-02-18	2026-02-18 09:17:36.82771	2026-02-18 17:45:38.54268	present	2026-03-02 15:43:44.318533
7835	79	2026-02-18	2026-02-18 09:56:39.727815	2026-02-18 17:52:56.1099	present	2026-03-02 15:43:44.318533
7836	82	2026-02-18	2026-02-18 09:42:33.349907	2026-02-18 17:16:27.958176	present	2026-03-02 15:43:44.318533
7837	83	2026-02-18	2026-02-18 09:11:54.623888	2026-02-18 17:52:34.853274	present	2026-03-02 15:43:44.318533
7838	84	2026-02-18	2026-02-18 09:11:47.313428	2026-02-18 17:56:27.154962	present	2026-03-02 15:43:44.318533
7839	85	2026-02-18	2026-02-18 09:07:21.904547	2026-02-18 17:41:38.661463	present	2026-03-02 15:43:44.318533
7840	88	2026-02-18	2026-02-18 09:37:34.963538	2026-02-18 17:11:26.957708	present	2026-03-02 15:43:44.318533
7841	89	2026-02-18	2026-02-18 09:53:22.236199	2026-02-18 17:38:19.722028	present	2026-03-02 15:43:44.318533
7842	96	2026-02-18	2026-02-18 09:13:13.739755	2026-02-18 17:58:11.059082	present	2026-03-02 15:43:44.318533
7843	97	2026-02-18	2026-02-18 09:19:36.275522	2026-02-18 17:36:26.599992	present	2026-03-02 15:43:44.318533
7844	1	2026-02-18	2026-02-18 09:00:22.560711	2026-02-18 17:14:54.877038	present	2026-03-02 15:43:44.318533
7845	2	2026-02-18	2026-02-18 09:58:19.848459	2026-02-18 17:11:41.558161	present	2026-03-02 15:43:44.318533
7846	7	2026-02-18	2026-02-18 09:03:41.360032	2026-02-18 17:55:33.734314	present	2026-03-02 15:43:44.318533
7847	8	2026-02-18	2026-02-18 09:46:40.906725	2026-02-18 17:42:11.301953	present	2026-03-02 15:43:44.318533
7848	9	2026-02-18	2026-02-18 09:25:48.865457	2026-02-18 17:38:01.936552	present	2026-03-02 15:43:44.318533
7849	12	2026-02-18	2026-02-18 09:30:11.380949	2026-02-18 17:01:55.845848	present	2026-03-02 15:43:44.318533
7850	13	2026-02-18	2026-02-18 09:29:58.317575	2026-02-18 17:23:23.509708	present	2026-03-02 15:43:44.318533
7851	14	2026-02-18	2026-02-18 09:19:10.327663	2026-02-18 17:06:28.325135	present	2026-03-02 15:43:44.318533
7852	15	2026-02-18	2026-02-18 09:36:32.916237	2026-02-18 17:14:19.32183	present	2026-03-02 15:43:44.318533
7853	16	2026-02-18	2026-02-18 09:50:56.879548	2026-02-18 17:53:59.951599	present	2026-03-02 15:43:44.318533
7854	17	2026-02-18	2026-02-18 09:19:26.86291	2026-02-18 17:54:21.743492	present	2026-03-02 15:43:44.318533
7855	18	2026-02-18	2026-02-18 09:18:51.608266	2026-02-18 17:52:08.430506	present	2026-03-02 15:43:44.318533
7856	19	2026-02-18	2026-02-18 09:56:17.042517	2026-02-18 17:23:42.253308	present	2026-03-02 15:43:44.318533
7857	20	2026-02-18	2026-02-18 09:49:38.608343	2026-02-18 17:09:49.513855	present	2026-03-02 15:43:44.318533
7858	21	2026-02-18	2026-02-18 09:01:28.092966	2026-02-18 17:06:33.314899	present	2026-03-02 15:43:44.318533
7859	22	2026-02-18	2026-02-18 09:26:58.060362	2026-02-18 17:44:38.905489	present	2026-03-02 15:43:44.318533
7860	23	2026-02-18	2026-02-18 09:28:32.376461	2026-02-18 17:05:57.400437	present	2026-03-02 15:43:44.318533
7861	24	2026-02-18	2026-02-18 09:11:28.575367	2026-02-18 17:26:44.818687	present	2026-03-02 15:43:44.318533
7862	25	2026-02-18	2026-02-18 09:31:05.936459	2026-02-18 17:36:11.836586	present	2026-03-02 15:43:44.318533
7863	26	2026-02-18	2026-02-18 09:59:12.81155	2026-02-18 17:31:31.962708	present	2026-03-02 15:43:44.318533
7864	28	2026-02-18	2026-02-18 09:10:27.826593	2026-02-18 17:37:25.193148	present	2026-03-02 15:43:44.318533
7865	29	2026-02-18	2026-02-18 09:59:51.356394	2026-02-18 17:41:31.159676	present	2026-03-02 15:43:44.318533
7866	30	2026-02-18	2026-02-18 09:08:07.206918	2026-02-18 17:57:27.38388	present	2026-03-02 15:43:44.318533
7867	31	2026-02-18	2026-02-18 09:23:28.68167	2026-02-18 17:13:44.909426	present	2026-03-02 15:43:44.318533
7868	32	2026-02-18	2026-02-18 09:54:54.46137	2026-02-18 17:37:50.658329	present	2026-03-02 15:43:44.318533
7869	34	2026-02-18	2026-02-18 09:27:40.503939	2026-02-18 17:15:59.027439	present	2026-03-02 15:43:44.318533
7870	36	2026-02-18	2026-02-18 09:41:27.087935	2026-02-18 17:57:30.374353	present	2026-03-02 15:43:44.318533
7871	38	2026-02-18	2026-02-18 09:57:15.614537	2026-02-18 17:40:09.853851	present	2026-03-02 15:43:44.318533
7872	39	2026-02-18	2026-02-18 09:44:14.517715	2026-02-18 17:06:19.094844	present	2026-03-02 15:43:44.318533
7873	40	2026-02-18	2026-02-18 09:11:46.801713	2026-02-18 17:44:48.898103	present	2026-03-02 15:43:44.318533
7874	41	2026-02-18	2026-02-18 09:23:20.11831	2026-02-18 17:51:02.054317	present	2026-03-02 15:43:44.318533
7875	42	2026-02-18	2026-02-18 09:06:44.827103	2026-02-18 17:39:03.575741	present	2026-03-02 15:43:44.318533
7876	44	2026-02-18	2026-02-18 09:43:52.437798	2026-02-18 17:29:02.186152	present	2026-03-02 15:43:44.318533
7877	49	2026-02-18	2026-02-18 09:23:40.687525	2026-02-18 17:50:57.920541	present	2026-03-02 15:43:44.318533
7878	51	2026-02-18	2026-02-18 09:22:24.096506	2026-02-18 17:28:19.681374	present	2026-03-02 15:43:44.318533
7879	53	2026-02-18	2026-02-18 09:31:17.233147	2026-02-18 17:10:39.46707	present	2026-03-02 15:43:44.318533
7880	54	2026-02-18	2026-02-18 09:28:23.025144	2026-02-18 17:31:39.645606	present	2026-03-02 15:43:44.318533
7881	55	2026-02-18	2026-02-18 09:36:59.645636	2026-02-18 17:17:37.358563	present	2026-03-02 15:43:44.318533
7882	56	2026-02-18	2026-02-18 09:38:06.786989	2026-02-18 17:42:42.380137	present	2026-03-02 15:43:44.318533
7883	57	2026-02-18	2026-02-18 09:58:31.775221	2026-02-18 17:34:01.492291	present	2026-03-02 15:43:44.318533
7884	58	2026-02-18	2026-02-18 09:33:00.347139	2026-02-18 17:43:55.57753	present	2026-03-02 15:43:44.318533
7885	61	2026-02-18	2026-02-18 09:46:40.068612	2026-02-18 17:46:52.249838	present	2026-03-02 15:43:44.318533
7886	67	2026-02-18	2026-02-18 09:25:51.800982	2026-02-18 17:11:37.371982	present	2026-03-02 15:43:44.318533
7887	68	2026-02-18	2026-02-18 09:20:06.366385	2026-02-18 17:17:03.501891	present	2026-03-02 15:43:44.318533
7888	69	2026-02-18	2026-02-18 09:50:19.468556	2026-02-18 17:42:52.972718	present	2026-03-02 15:43:44.318533
7889	72	2026-02-18	2026-02-18 09:20:42.27049	2026-02-18 17:52:23.221157	present	2026-03-02 15:43:44.318533
7890	75	2026-02-18	2026-02-18 09:43:39.410066	2026-02-18 17:51:49.913074	present	2026-03-02 15:43:44.318533
7891	76	2026-02-18	2026-02-18 09:42:22.211656	2026-02-18 17:18:11.863227	present	2026-03-02 15:43:44.318533
7892	77	2026-02-18	2026-02-18 09:04:43.475729	2026-02-18 17:31:48.617292	present	2026-03-02 15:43:44.318533
7893	80	2026-02-18	2026-02-18 09:30:23.392057	2026-02-18 17:41:48.71367	present	2026-03-02 15:43:44.318533
7894	81	2026-02-18	2026-02-18 09:55:18.287401	2026-02-18 17:24:09.922138	present	2026-03-02 15:43:44.318533
7895	86	2026-02-18	2026-02-18 09:56:39.90447	2026-02-18 17:59:26.598114	present	2026-03-02 15:43:44.318533
7896	87	2026-02-18	2026-02-18 09:35:59.579374	2026-02-18 17:37:53.103892	present	2026-03-02 15:43:44.318533
7897	90	2026-02-18	2026-02-18 09:28:48.744862	2026-02-18 17:59:05.739202	present	2026-03-02 15:43:44.318533
7898	91	2026-02-18	2026-02-18 09:24:52.326991	2026-02-18 17:19:36.552999	present	2026-03-02 15:43:44.318533
7899	92	2026-02-18	2026-02-18 09:14:39.768485	2026-02-18 17:08:44.086787	present	2026-03-02 15:43:44.318533
7900	93	2026-02-18	2026-02-18 09:21:07.997911	2026-02-18 17:10:13.649011	present	2026-03-02 15:43:44.318533
7901	94	2026-02-18	2026-02-18 09:30:08.859959	2026-02-18 17:32:39.731968	present	2026-03-02 15:43:44.318533
7902	95	2026-02-18	2026-02-18 09:22:24.983446	2026-02-18 17:20:50.959754	present	2026-03-02 15:43:44.318533
7903	98	2026-02-18	2026-02-18 09:38:20.845001	2026-02-18 17:35:21.1005	present	2026-03-02 15:43:44.318533
7904	99	2026-02-18	2026-02-18 09:49:24.570753	2026-02-18 17:25:03.585944	present	2026-03-02 15:43:44.318533
7905	100	2026-02-18	2026-02-18 09:07:39.609106	2026-02-18 17:06:11.37604	present	2026-03-02 15:43:44.318533
7906	3	2026-02-19	2026-02-19 09:56:33.371498	2026-02-19 17:16:32.509157	present	2026-03-02 15:43:44.318533
7907	4	2026-02-19	2026-02-19 09:57:14.397623	2026-02-19 17:15:00.87748	present	2026-03-02 15:43:44.318533
7908	5	2026-02-19	2026-02-19 09:11:17.254799	2026-02-19 17:14:07.398063	present	2026-03-02 15:43:44.318533
7909	6	2026-02-19	2026-02-19 09:48:15.296953	2026-02-19 17:01:31.85617	present	2026-03-02 15:43:44.318533
7910	10	2026-02-19	2026-02-19 09:10:38.989313	2026-02-19 17:55:16.744415	present	2026-03-02 15:43:44.318533
7911	11	2026-02-19	2026-02-19 09:32:07.137535	2026-02-19 17:32:18.663066	present	2026-03-02 15:43:44.318533
7912	27	2026-02-19	2026-02-19 09:34:04.433936	2026-02-19 17:00:31.216871	present	2026-03-02 15:43:44.318533
7913	33	2026-02-19	2026-02-19 09:42:51.784282	2026-02-19 17:25:17.4191	present	2026-03-02 15:43:44.318533
7914	35	2026-02-19	2026-02-19 09:50:54.055904	2026-02-19 17:22:31.298443	present	2026-03-02 15:43:44.318533
7915	37	2026-02-19	2026-02-19 09:08:13.521932	2026-02-19 17:53:00.103625	present	2026-03-02 15:43:44.318533
7916	43	2026-02-19	2026-02-19 09:52:01.164308	2026-02-19 17:08:23.444059	present	2026-03-02 15:43:44.318533
7917	45	2026-02-19	2026-02-19 09:15:01.853438	2026-02-19 17:17:25.587938	present	2026-03-02 15:43:44.318533
7918	46	2026-02-19	2026-02-19 09:51:43.295923	2026-02-19 17:46:31.024529	present	2026-03-02 15:43:44.318533
7919	47	2026-02-19	2026-02-19 09:59:12.424078	2026-02-19 17:02:54.434034	present	2026-03-02 15:43:44.318533
7920	48	2026-02-19	2026-02-19 09:55:54.313663	2026-02-19 17:49:35.542961	present	2026-03-02 15:43:44.318533
7921	50	2026-02-19	2026-02-19 09:04:42.214698	2026-02-19 17:31:51.641378	present	2026-03-02 15:43:44.318533
7922	52	2026-02-19	2026-02-19 09:30:56.763041	2026-02-19 17:37:43.640589	present	2026-03-02 15:43:44.318533
7923	59	2026-02-19	2026-02-19 09:15:31.856516	2026-02-19 17:27:37.90591	present	2026-03-02 15:43:44.318533
7924	60	2026-02-19	2026-02-19 09:06:50.316126	2026-02-19 17:54:22.494005	present	2026-03-02 15:43:44.318533
7925	62	2026-02-19	2026-02-19 09:57:48.050915	2026-02-19 17:38:01.199335	present	2026-03-02 15:43:44.318533
7926	63	2026-02-19	2026-02-19 09:24:46.988376	2026-02-19 17:43:23.72716	present	2026-03-02 15:43:44.318533
7927	64	2026-02-19	2026-02-19 09:29:35.499186	2026-02-19 17:28:13.277352	present	2026-03-02 15:43:44.318533
7928	65	2026-02-19	2026-02-19 09:50:27.247712	2026-02-19 17:52:51.663708	present	2026-03-02 15:43:44.318533
7929	66	2026-02-19	2026-02-19 09:48:22.855792	2026-02-19 17:16:29.231625	present	2026-03-02 15:43:44.318533
7930	70	2026-02-19	2026-02-19 09:13:16.469186	2026-02-19 17:28:12.641149	present	2026-03-02 15:43:44.318533
7931	71	2026-02-19	2026-02-19 09:36:56.033322	2026-02-19 17:55:07.544051	present	2026-03-02 15:43:44.318533
7932	73	2026-02-19	2026-02-19 09:21:49.900815	2026-02-19 17:22:36.652529	present	2026-03-02 15:43:44.318533
7933	74	2026-02-19	2026-02-19 09:08:26.246578	2026-02-19 17:12:13.387458	present	2026-03-02 15:43:44.318533
7934	78	2026-02-19	2026-02-19 09:49:57.598512	2026-02-19 17:26:50.962376	present	2026-03-02 15:43:44.318533
7935	79	2026-02-19	2026-02-19 09:12:17.532681	2026-02-19 17:31:34.022462	present	2026-03-02 15:43:44.318533
7936	82	2026-02-19	2026-02-19 09:39:39.805147	2026-02-19 17:54:14.775144	present	2026-03-02 15:43:44.318533
7937	83	2026-02-19	2026-02-19 09:48:11.062016	2026-02-19 17:02:02.414919	present	2026-03-02 15:43:44.318533
7938	84	2026-02-19	2026-02-19 09:08:41.130449	2026-02-19 17:16:54.405003	present	2026-03-02 15:43:44.318533
7939	85	2026-02-19	2026-02-19 09:07:04.118225	2026-02-19 17:09:30.156044	present	2026-03-02 15:43:44.318533
7940	88	2026-02-19	2026-02-19 09:05:48.172362	2026-02-19 17:40:38.827404	present	2026-03-02 15:43:44.318533
7941	89	2026-02-19	2026-02-19 09:27:09.876372	2026-02-19 17:13:14.214833	present	2026-03-02 15:43:44.318533
7942	96	2026-02-19	2026-02-19 09:53:40.003302	2026-02-19 17:08:07.716315	present	2026-03-02 15:43:44.318533
7943	97	2026-02-19	2026-02-19 09:59:30.154285	2026-02-19 17:41:43.336622	present	2026-03-02 15:43:44.318533
7944	1	2026-02-19	2026-02-19 09:02:19.297785	2026-02-19 17:34:27.713065	present	2026-03-02 15:43:44.318533
7945	2	2026-02-19	2026-02-19 09:02:19.848643	2026-02-19 17:01:42.264447	present	2026-03-02 15:43:44.318533
7946	7	2026-02-19	2026-02-19 09:28:42.32254	2026-02-19 17:38:26.122454	present	2026-03-02 15:43:44.318533
7947	8	2026-02-19	2026-02-19 09:11:11.260255	2026-02-19 17:17:33.241307	present	2026-03-02 15:43:44.318533
7948	9	2026-02-19	2026-02-19 09:44:32.78198	2026-02-19 17:26:48.485422	present	2026-03-02 15:43:44.318533
7949	12	2026-02-19	2026-02-19 09:08:14.628026	2026-02-19 17:51:01.375039	present	2026-03-02 15:43:44.318533
7950	13	2026-02-19	2026-02-19 09:05:57.14748	2026-02-19 17:18:28.488186	present	2026-03-02 15:43:44.318533
7951	14	2026-02-19	2026-02-19 09:03:24.821256	2026-02-19 17:14:43.404684	present	2026-03-02 15:43:44.318533
7952	15	2026-02-19	2026-02-19 09:32:53.567966	2026-02-19 17:46:49.949778	present	2026-03-02 15:43:44.318533
7953	16	2026-02-19	2026-02-19 09:20:34.196963	2026-02-19 17:02:17.989871	present	2026-03-02 15:43:44.318533
7954	17	2026-02-19	2026-02-19 09:45:05.124448	2026-02-19 17:40:05.351462	present	2026-03-02 15:43:44.318533
7955	18	2026-02-19	2026-02-19 09:51:29.870472	2026-02-19 17:05:11.455233	present	2026-03-02 15:43:44.318533
7956	19	2026-02-19	2026-02-19 09:22:04.788178	2026-02-19 17:07:40.975744	present	2026-03-02 15:43:44.318533
7957	20	2026-02-19	2026-02-19 09:15:33.054761	2026-02-19 17:32:02.753915	present	2026-03-02 15:43:44.318533
7958	21	2026-02-19	2026-02-19 09:29:18.669329	2026-02-19 17:57:59.539857	present	2026-03-02 15:43:44.318533
7959	22	2026-02-19	2026-02-19 09:15:59.85159	2026-02-19 17:06:18.590767	present	2026-03-02 15:43:44.318533
7960	23	2026-02-19	2026-02-19 09:39:16.211312	2026-02-19 17:37:39.942703	present	2026-03-02 15:43:44.318533
7961	24	2026-02-19	2026-02-19 09:25:07.932927	2026-02-19 17:46:48.065521	present	2026-03-02 15:43:44.318533
7962	25	2026-02-19	2026-02-19 09:25:28.288265	2026-02-19 17:33:09.504369	present	2026-03-02 15:43:44.318533
7963	26	2026-02-19	2026-02-19 09:28:51.449108	2026-02-19 17:31:26.835452	present	2026-03-02 15:43:44.318533
7964	28	2026-02-19	2026-02-19 09:01:59.773273	2026-02-19 17:47:28.501586	present	2026-03-02 15:43:44.318533
7965	29	2026-02-19	2026-02-19 09:38:47.406185	2026-02-19 17:46:52.175118	present	2026-03-02 15:43:44.318533
7966	30	2026-02-19	2026-02-19 09:59:52.47113	2026-02-19 17:24:25.4872	present	2026-03-02 15:43:44.318533
7967	31	2026-02-19	2026-02-19 09:35:30.914052	2026-02-19 17:12:32.079778	present	2026-03-02 15:43:44.318533
7968	32	2026-02-19	2026-02-19 09:29:47.84885	2026-02-19 17:24:18.961349	present	2026-03-02 15:43:44.318533
7969	34	2026-02-19	2026-02-19 09:28:46.651839	2026-02-19 17:43:56.140343	present	2026-03-02 15:43:44.318533
7970	36	2026-02-19	2026-02-19 09:46:07.837396	2026-02-19 17:52:47.345867	present	2026-03-02 15:43:44.318533
7971	38	2026-02-19	2026-02-19 09:59:52.081716	2026-02-19 17:14:20.131403	present	2026-03-02 15:43:44.318533
7972	39	2026-02-19	2026-02-19 09:39:24.242468	2026-02-19 17:25:28.542115	present	2026-03-02 15:43:44.318533
7973	40	2026-02-19	2026-02-19 09:39:07.476378	2026-02-19 17:30:04.454062	present	2026-03-02 15:43:44.318533
7974	41	2026-02-19	2026-02-19 09:41:10.239392	2026-02-19 17:33:03.016259	present	2026-03-02 15:43:44.318533
7975	42	2026-02-19	2026-02-19 09:17:55.335894	2026-02-19 17:50:03.728184	present	2026-03-02 15:43:44.318533
7976	44	2026-02-19	2026-02-19 09:18:49.225336	2026-02-19 17:32:21.20288	present	2026-03-02 15:43:44.318533
7977	49	2026-02-19	2026-02-19 09:06:43.922852	2026-02-19 17:17:58.356442	present	2026-03-02 15:43:44.318533
7978	51	2026-02-19	2026-02-19 09:58:12.671459	2026-02-19 17:27:41.099152	present	2026-03-02 15:43:44.318533
7979	53	2026-02-19	2026-02-19 09:28:12.573441	2026-02-19 17:57:18.884409	present	2026-03-02 15:43:44.318533
7980	54	2026-02-19	2026-02-19 09:26:40.085802	2026-02-19 17:58:06.12486	present	2026-03-02 15:43:44.318533
7981	55	2026-02-19	2026-02-19 09:52:13.609259	2026-02-19 17:41:55.472025	present	2026-03-02 15:43:44.318533
7982	56	2026-02-19	2026-02-19 09:43:57.115527	2026-02-19 17:32:35.631534	present	2026-03-02 15:43:44.318533
7983	57	2026-02-19	2026-02-19 09:48:23.793043	2026-02-19 17:25:57.45799	present	2026-03-02 15:43:44.318533
7984	58	2026-02-19	2026-02-19 09:44:23.507666	2026-02-19 17:11:26.146415	present	2026-03-02 15:43:44.318533
7985	61	2026-02-19	2026-02-19 09:04:08.940585	2026-02-19 17:25:24.798013	present	2026-03-02 15:43:44.318533
7986	67	2026-02-19	2026-02-19 09:42:56.634874	2026-02-19 17:16:47.042236	present	2026-03-02 15:43:44.318533
7987	68	2026-02-19	2026-02-19 09:02:51.129676	2026-02-19 17:41:00.071325	present	2026-03-02 15:43:44.318533
7988	69	2026-02-19	2026-02-19 09:04:55.20551	2026-02-19 17:26:56.067388	present	2026-03-02 15:43:44.318533
7989	72	2026-02-19	2026-02-19 09:03:58.084659	2026-02-19 17:52:09.643032	present	2026-03-02 15:43:44.318533
7990	75	2026-02-19	2026-02-19 09:12:34.987835	2026-02-19 17:17:53.447261	present	2026-03-02 15:43:44.318533
7991	76	2026-02-19	2026-02-19 09:12:26.898202	2026-02-19 17:31:28.185526	present	2026-03-02 15:43:44.318533
7992	77	2026-02-19	2026-02-19 09:17:58.110773	2026-02-19 17:58:22.626431	present	2026-03-02 15:43:44.318533
7993	80	2026-02-19	2026-02-19 09:13:38.146379	2026-02-19 17:56:39.279036	present	2026-03-02 15:43:44.318533
7994	81	2026-02-19	2026-02-19 09:07:38.551714	2026-02-19 17:33:41.81202	present	2026-03-02 15:43:44.318533
7995	86	2026-02-19	2026-02-19 09:49:21.951164	2026-02-19 17:00:29.689169	present	2026-03-02 15:43:44.318533
7996	87	2026-02-19	2026-02-19 09:10:45.063866	2026-02-19 17:48:37.06877	present	2026-03-02 15:43:44.318533
7997	90	2026-02-19	2026-02-19 09:32:56.902078	2026-02-19 17:23:15.397796	present	2026-03-02 15:43:44.318533
7998	91	2026-02-19	2026-02-19 09:45:20.950887	2026-02-19 17:00:42.250765	present	2026-03-02 15:43:44.318533
7999	92	2026-02-19	2026-02-19 09:38:23.239835	2026-02-19 17:48:06.913724	present	2026-03-02 15:43:44.318533
8000	93	2026-02-19	2026-02-19 09:15:39.591955	2026-02-19 17:22:20.282653	present	2026-03-02 15:43:44.318533
8001	94	2026-02-19	2026-02-19 09:29:30.25065	2026-02-19 17:16:53.236423	present	2026-03-02 15:43:44.318533
8002	95	2026-02-19	2026-02-19 09:31:09.133586	2026-02-19 17:57:25.882201	present	2026-03-02 15:43:44.318533
8003	98	2026-02-19	2026-02-19 09:50:41.122485	2026-02-19 17:59:48.291187	present	2026-03-02 15:43:44.318533
8004	99	2026-02-19	2026-02-19 09:26:56.966385	2026-02-19 17:31:05.651601	present	2026-03-02 15:43:44.318533
8005	100	2026-02-19	2026-02-19 09:10:33.899374	2026-02-19 17:13:43.886129	present	2026-03-02 15:43:44.318533
8006	3	2026-02-20	2026-02-20 09:23:41.233141	2026-02-20 17:27:22.74191	present	2026-03-02 15:43:44.318533
8007	4	2026-02-20	2026-02-20 09:23:13.241837	2026-02-20 17:13:23.663186	present	2026-03-02 15:43:44.318533
8008	5	2026-02-20	2026-02-20 09:04:06.304129	2026-02-20 17:58:48.011353	present	2026-03-02 15:43:44.318533
8009	6	2026-02-20	2026-02-20 09:14:47.045415	2026-02-20 17:55:01.48906	present	2026-03-02 15:43:44.318533
8010	10	2026-02-20	2026-02-20 09:50:25.968327	2026-02-20 17:45:59.293056	present	2026-03-02 15:43:44.318533
8011	11	2026-02-20	2026-02-20 09:59:04.173262	2026-02-20 17:44:43.677682	present	2026-03-02 15:43:44.318533
8012	27	2026-02-20	2026-02-20 09:18:21.854131	2026-02-20 17:54:32.873654	present	2026-03-02 15:43:44.318533
8013	33	2026-02-20	2026-02-20 09:03:49.805352	2026-02-20 17:15:08.518144	present	2026-03-02 15:43:44.318533
8014	35	2026-02-20	2026-02-20 09:06:22.656142	2026-02-20 17:29:25.027006	present	2026-03-02 15:43:44.318533
8015	37	2026-02-20	2026-02-20 09:42:45.797002	2026-02-20 17:25:00.562687	present	2026-03-02 15:43:44.318533
8016	43	2026-02-20	2026-02-20 09:03:17.793032	2026-02-20 17:03:42.026629	present	2026-03-02 15:43:44.318533
8017	45	2026-02-20	2026-02-20 09:04:42.392576	2026-02-20 17:47:57.759436	present	2026-03-02 15:43:44.318533
8018	46	2026-02-20	2026-02-20 09:27:59.579254	2026-02-20 17:46:09.350176	present	2026-03-02 15:43:44.318533
8019	47	2026-02-20	2026-02-20 09:23:17.517969	2026-02-20 17:48:43.902196	present	2026-03-02 15:43:44.318533
8020	48	2026-02-20	2026-02-20 09:54:19.619627	2026-02-20 17:55:42.998536	present	2026-03-02 15:43:44.318533
8021	50	2026-02-20	2026-02-20 09:33:46.159968	2026-02-20 17:51:04.876635	present	2026-03-02 15:43:44.318533
8022	52	2026-02-20	2026-02-20 09:06:43.539092	2026-02-20 17:38:44.943404	present	2026-03-02 15:43:44.318533
8023	59	2026-02-20	2026-02-20 09:10:14.603346	2026-02-20 17:29:43.3488	present	2026-03-02 15:43:44.318533
8024	60	2026-02-20	2026-02-20 09:26:49.790975	2026-02-20 17:36:17.173018	present	2026-03-02 15:43:44.318533
8025	62	2026-02-20	2026-02-20 09:36:24.184277	2026-02-20 17:49:25.762086	present	2026-03-02 15:43:44.318533
8026	63	2026-02-20	2026-02-20 09:47:02.240274	2026-02-20 17:12:37.836974	present	2026-03-02 15:43:44.318533
8027	64	2026-02-20	2026-02-20 09:32:14.090056	2026-02-20 17:21:33.353779	present	2026-03-02 15:43:44.318533
8028	65	2026-02-20	2026-02-20 09:52:32.503722	2026-02-20 17:06:12.965461	present	2026-03-02 15:43:44.318533
8029	66	2026-02-20	2026-02-20 09:05:33.079638	2026-02-20 17:37:15.947337	present	2026-03-02 15:43:44.318533
8030	70	2026-02-20	2026-02-20 09:40:42.260484	2026-02-20 17:29:48.587822	present	2026-03-02 15:43:44.318533
8031	71	2026-02-20	2026-02-20 09:19:06.68232	2026-02-20 17:19:10.958184	present	2026-03-02 15:43:44.318533
8032	73	2026-02-20	2026-02-20 09:26:58.923266	2026-02-20 17:46:03.935415	present	2026-03-02 15:43:44.318533
8033	74	2026-02-20	2026-02-20 09:15:27.289402	2026-02-20 17:31:14.724622	present	2026-03-02 15:43:44.318533
8034	78	2026-02-20	2026-02-20 09:16:12.099038	2026-02-20 17:15:25.784975	present	2026-03-02 15:43:44.318533
8035	79	2026-02-20	2026-02-20 09:35:58.869121	2026-02-20 17:02:20.110645	present	2026-03-02 15:43:44.318533
8036	82	2026-02-20	2026-02-20 09:13:20.004901	2026-02-20 17:59:57.476258	present	2026-03-02 15:43:44.318533
8037	83	2026-02-20	2026-02-20 09:58:51.402058	2026-02-20 17:33:27.418417	present	2026-03-02 15:43:44.318533
8038	84	2026-02-20	2026-02-20 09:54:06.563795	2026-02-20 17:44:06.917459	present	2026-03-02 15:43:44.318533
8039	85	2026-02-20	2026-02-20 09:47:03.803136	2026-02-20 17:59:31.979948	present	2026-03-02 15:43:44.318533
8040	88	2026-02-20	2026-02-20 09:18:24.462469	2026-02-20 17:23:49.195314	present	2026-03-02 15:43:44.318533
8041	89	2026-02-20	2026-02-20 09:58:10.505605	2026-02-20 17:51:21.091497	present	2026-03-02 15:43:44.318533
8042	96	2026-02-20	2026-02-20 09:31:50.960033	2026-02-20 17:25:32.138733	present	2026-03-02 15:43:44.318533
8043	97	2026-02-20	2026-02-20 09:18:25.44728	2026-02-20 17:24:45.654232	present	2026-03-02 15:43:44.318533
8044	1	2026-02-20	2026-02-20 09:21:17.79322	2026-02-20 17:09:45.125465	present	2026-03-02 15:43:44.318533
8045	2	2026-02-20	2026-02-20 09:51:24.341469	2026-02-20 17:14:29.651657	present	2026-03-02 15:43:44.318533
8046	7	2026-02-20	2026-02-20 09:54:56.833199	2026-02-20 17:53:31.755005	present	2026-03-02 15:43:44.318533
8047	8	2026-02-20	2026-02-20 09:35:21.361599	2026-02-20 17:10:20.157469	present	2026-03-02 15:43:44.318533
8048	9	2026-02-20	2026-02-20 09:42:26.801977	2026-02-20 17:58:38.71251	present	2026-03-02 15:43:44.318533
8049	12	2026-02-20	2026-02-20 09:37:04.634292	2026-02-20 17:25:08.415326	present	2026-03-02 15:43:44.318533
8050	13	2026-02-20	2026-02-20 09:24:47.23668	2026-02-20 17:10:50.3124	present	2026-03-02 15:43:44.318533
8051	14	2026-02-20	2026-02-20 09:35:34.51465	2026-02-20 17:20:47.904576	present	2026-03-02 15:43:44.318533
8052	15	2026-02-20	2026-02-20 09:51:54.284333	2026-02-20 17:35:15.90483	present	2026-03-02 15:43:44.318533
8053	16	2026-02-20	2026-02-20 09:09:52.215451	2026-02-20 17:57:48.751771	present	2026-03-02 15:43:44.318533
8054	17	2026-02-20	2026-02-20 09:27:35.682847	2026-02-20 17:26:17.233216	present	2026-03-02 15:43:44.318533
8055	18	2026-02-20	2026-02-20 09:48:51.264968	2026-02-20 17:44:33.127741	present	2026-03-02 15:43:44.318533
8056	19	2026-02-20	2026-02-20 09:57:40.928043	2026-02-20 17:53:05.532242	present	2026-03-02 15:43:44.318533
8057	20	2026-02-20	2026-02-20 09:59:18.385948	2026-02-20 17:18:18.284607	present	2026-03-02 15:43:44.318533
8058	21	2026-02-20	2026-02-20 09:08:43.861288	2026-02-20 17:47:38.098361	present	2026-03-02 15:43:44.318533
8059	22	2026-02-20	2026-02-20 09:29:08.631308	2026-02-20 17:16:15.986062	present	2026-03-02 15:43:44.318533
8060	23	2026-02-20	2026-02-20 09:25:00.10166	2026-02-20 17:42:04.329452	present	2026-03-02 15:43:44.318533
8061	24	2026-02-20	2026-02-20 09:30:00.392541	2026-02-20 17:32:16.078426	present	2026-03-02 15:43:44.318533
8062	25	2026-02-20	2026-02-20 09:52:50.899802	2026-02-20 17:18:12.60874	present	2026-03-02 15:43:44.318533
8063	26	2026-02-20	2026-02-20 09:14:15.671647	2026-02-20 17:04:58.009815	present	2026-03-02 15:43:44.318533
8064	28	2026-02-20	2026-02-20 09:57:53.009153	2026-02-20 17:35:35.332933	present	2026-03-02 15:43:44.318533
8065	29	2026-02-20	2026-02-20 09:49:22.886672	2026-02-20 17:46:14.266981	present	2026-03-02 15:43:44.318533
8066	30	2026-02-20	2026-02-20 09:54:50.488926	2026-02-20 17:24:00.153835	present	2026-03-02 15:43:44.318533
8067	31	2026-02-20	2026-02-20 09:14:26.67435	2026-02-20 17:10:57.978299	present	2026-03-02 15:43:44.318533
8068	32	2026-02-20	2026-02-20 09:28:02.858212	2026-02-20 17:27:18.389841	present	2026-03-02 15:43:44.318533
8069	34	2026-02-20	2026-02-20 09:53:37.596218	2026-02-20 17:14:16.704624	present	2026-03-02 15:43:44.318533
8070	36	2026-02-20	2026-02-20 09:32:41.244361	2026-02-20 17:53:20.268847	present	2026-03-02 15:43:44.318533
8071	38	2026-02-20	2026-02-20 09:53:41.958921	2026-02-20 17:29:33.371709	present	2026-03-02 15:43:44.318533
8072	39	2026-02-20	2026-02-20 09:54:18.22269	2026-02-20 17:30:54.158782	present	2026-03-02 15:43:44.318533
8073	40	2026-02-20	2026-02-20 09:17:08.399326	2026-02-20 17:42:23.304292	present	2026-03-02 15:43:44.318533
8074	41	2026-02-20	2026-02-20 09:01:55.735778	2026-02-20 17:34:56.187845	present	2026-03-02 15:43:44.318533
8075	42	2026-02-20	2026-02-20 09:26:42.340367	2026-02-20 17:55:49.344541	present	2026-03-02 15:43:44.318533
8076	44	2026-02-20	2026-02-20 09:30:15.836058	2026-02-20 17:26:00.949109	present	2026-03-02 15:43:44.318533
8077	49	2026-02-20	2026-02-20 09:49:27.189761	2026-02-20 17:29:10.83406	present	2026-03-02 15:43:44.318533
8078	51	2026-02-20	2026-02-20 09:22:44.872665	2026-02-20 17:49:36.064031	present	2026-03-02 15:43:44.318533
8079	53	2026-02-20	2026-02-20 09:24:35.026034	2026-02-20 17:12:18.535708	present	2026-03-02 15:43:44.318533
8080	54	2026-02-20	2026-02-20 09:45:20.265041	2026-02-20 17:38:31.215351	present	2026-03-02 15:43:44.318533
8081	55	2026-02-20	2026-02-20 09:01:04.808975	2026-02-20 17:16:13.721094	present	2026-03-02 15:43:44.318533
8082	56	2026-02-20	2026-02-20 09:28:07.396248	2026-02-20 17:14:55.072265	present	2026-03-02 15:43:44.318533
8083	57	2026-02-20	2026-02-20 09:52:10.943658	2026-02-20 17:21:06.810066	present	2026-03-02 15:43:44.318533
8084	58	2026-02-20	2026-02-20 09:55:47.167356	2026-02-20 17:20:01.787978	present	2026-03-02 15:43:44.318533
8085	61	2026-02-20	2026-02-20 09:13:11.789637	2026-02-20 17:11:37.285312	present	2026-03-02 15:43:44.318533
8086	67	2026-02-20	2026-02-20 09:53:57.059768	2026-02-20 17:10:40.440013	present	2026-03-02 15:43:44.318533
8087	68	2026-02-20	2026-02-20 09:06:57.44666	2026-02-20 17:50:11.872299	present	2026-03-02 15:43:44.318533
8088	69	2026-02-20	2026-02-20 09:53:23.818	2026-02-20 17:51:36.847096	present	2026-03-02 15:43:44.318533
8089	72	2026-02-20	2026-02-20 09:18:22.411178	2026-02-20 17:41:52.706238	present	2026-03-02 15:43:44.318533
8090	75	2026-02-20	2026-02-20 09:59:47.71201	2026-02-20 17:43:05.935978	present	2026-03-02 15:43:44.318533
8091	76	2026-02-20	2026-02-20 09:44:14.279361	2026-02-20 17:53:07.090556	present	2026-03-02 15:43:44.318533
8092	77	2026-02-20	2026-02-20 09:18:04.445751	2026-02-20 17:31:27.025422	present	2026-03-02 15:43:44.318533
8093	80	2026-02-20	2026-02-20 09:14:08.925643	2026-02-20 17:42:15.198935	present	2026-03-02 15:43:44.318533
8094	81	2026-02-20	2026-02-20 09:54:16.956177	2026-02-20 17:54:03.114404	present	2026-03-02 15:43:44.318533
8095	86	2026-02-20	2026-02-20 09:37:27.58729	2026-02-20 17:03:57.634789	present	2026-03-02 15:43:44.318533
8096	87	2026-02-20	2026-02-20 09:52:33.726598	2026-02-20 17:50:17.955516	present	2026-03-02 15:43:44.318533
8097	90	2026-02-20	2026-02-20 09:10:45.682555	2026-02-20 17:04:26.415927	present	2026-03-02 15:43:44.318533
8098	91	2026-02-20	2026-02-20 09:40:08.505181	2026-02-20 17:09:09.964453	present	2026-03-02 15:43:44.318533
8099	92	2026-02-20	2026-02-20 09:26:15.421918	2026-02-20 17:10:54.18779	present	2026-03-02 15:43:44.318533
8100	93	2026-02-20	2026-02-20 09:40:47.14303	2026-02-20 17:45:40.274393	present	2026-03-02 15:43:44.318533
8101	94	2026-02-20	2026-02-20 09:24:23.849705	2026-02-20 17:46:07.07568	present	2026-03-02 15:43:44.318533
8102	95	2026-02-20	2026-02-20 09:22:58.986597	2026-02-20 17:51:20.1755	present	2026-03-02 15:43:44.318533
8103	98	2026-02-20	2026-02-20 09:10:11.72724	2026-02-20 17:12:42.474759	present	2026-03-02 15:43:44.318533
8104	99	2026-02-20	2026-02-20 09:10:47.389566	2026-02-20 17:20:10.141047	present	2026-03-02 15:43:44.318533
8105	100	2026-02-20	2026-02-20 09:02:44.663031	2026-02-20 17:06:17.227893	present	2026-03-02 15:43:44.318533
8106	3	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8107	4	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8108	5	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8109	6	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8110	10	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8111	11	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8112	27	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8113	33	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8114	35	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8115	37	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8116	43	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8117	45	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8118	46	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8119	47	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8120	48	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8121	50	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8122	52	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8123	59	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8124	60	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8125	62	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8126	63	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8127	64	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8128	65	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8129	66	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8130	70	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8131	71	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8132	73	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8133	74	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8134	78	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8135	79	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8136	82	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8137	83	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8138	84	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8139	85	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8140	88	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8141	89	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8142	96	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8143	97	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8144	1	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8145	2	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8146	7	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8147	8	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8148	9	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8149	12	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8150	13	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8151	14	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8152	15	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8153	16	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8154	17	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8155	18	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8156	19	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8157	20	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8158	21	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8159	22	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8160	23	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8161	24	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8162	25	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8163	26	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8164	28	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8165	29	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8166	30	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8167	31	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8168	32	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8169	34	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8170	36	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8171	38	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8172	39	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8173	40	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8174	41	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8175	42	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8176	44	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8177	49	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8178	51	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8179	53	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8180	54	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8181	55	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8182	56	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8183	57	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8184	58	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8185	61	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8186	67	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8187	68	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8188	69	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8189	72	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8190	75	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8191	76	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8192	77	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8193	80	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8194	81	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8195	86	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8196	87	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8197	90	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8198	91	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8199	92	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8200	93	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8201	94	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8202	95	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8203	98	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8204	99	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8205	100	2026-02-21	\N	\N	absent	2026-03-02 15:43:44.318533
8206	3	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8207	4	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8208	5	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8209	6	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8210	10	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8211	11	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8212	27	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8213	33	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8214	35	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8215	37	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8216	43	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8217	45	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8218	46	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8219	47	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8220	48	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8221	50	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8222	52	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8223	59	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8224	60	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8225	62	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8226	63	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8227	64	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8228	65	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8229	66	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8230	70	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8231	71	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8232	73	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8233	74	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8234	78	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8235	79	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8236	82	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8237	83	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8238	84	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8239	85	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8240	88	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8241	89	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8242	96	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8243	97	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8244	1	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8245	2	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8246	7	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8247	8	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8248	9	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8249	12	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8250	13	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8251	14	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8252	15	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8253	16	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8254	17	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8255	18	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8256	19	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8257	20	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8258	21	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8259	22	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8260	23	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8261	24	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8262	25	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8263	26	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8264	28	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8265	29	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8266	30	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8267	31	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8268	32	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8269	34	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8270	36	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8271	38	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8272	39	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8273	40	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8274	41	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8275	42	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8276	44	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8277	49	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8278	51	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8279	53	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8280	54	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8281	55	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8282	56	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8283	57	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8284	58	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8285	61	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8286	67	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8287	68	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8288	69	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8289	72	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8290	75	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8291	76	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8292	77	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8293	80	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8294	81	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8295	86	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8296	87	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8297	90	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8298	91	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8299	92	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8300	93	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8301	94	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8302	95	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8303	98	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8304	99	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8305	100	2026-02-22	\N	\N	absent	2026-03-02 15:43:44.318533
8306	3	2026-02-23	2026-02-23 09:33:55.370678	2026-02-23 17:03:42.674554	present	2026-03-02 15:43:44.318533
8307	4	2026-02-23	2026-02-23 09:27:05.210465	2026-02-23 17:44:33.879099	present	2026-03-02 15:43:44.318533
8308	5	2026-02-23	2026-02-23 09:47:44.358716	2026-02-23 17:22:57.143156	present	2026-03-02 15:43:44.318533
8309	6	2026-02-23	2026-02-23 09:05:03.549645	2026-02-23 17:03:49.144211	present	2026-03-02 15:43:44.318533
8310	10	2026-02-23	2026-02-23 09:09:54.056599	2026-02-23 17:16:37.053696	present	2026-03-02 15:43:44.318533
8311	11	2026-02-23	2026-02-23 09:07:00.350368	2026-02-23 17:49:00.138906	present	2026-03-02 15:43:44.318533
8312	27	2026-02-23	2026-02-23 09:38:14.363702	2026-02-23 17:14:41.570228	present	2026-03-02 15:43:44.318533
8313	33	2026-02-23	2026-02-23 09:31:03.622193	2026-02-23 17:01:01.954766	present	2026-03-02 15:43:44.318533
8314	35	2026-02-23	2026-02-23 09:06:07.017697	2026-02-23 17:16:45.872416	present	2026-03-02 15:43:44.318533
8315	37	2026-02-23	2026-02-23 09:41:24.107078	2026-02-23 17:44:56.964168	present	2026-03-02 15:43:44.318533
8316	43	2026-02-23	2026-02-23 09:11:43.250624	2026-02-23 17:28:55.610904	present	2026-03-02 15:43:44.318533
8317	45	2026-02-23	2026-02-23 09:52:31.114292	2026-02-23 17:00:39.88008	present	2026-03-02 15:43:44.318533
8318	46	2026-02-23	2026-02-23 09:35:48.939396	2026-02-23 17:33:48.147831	present	2026-03-02 15:43:44.318533
8319	47	2026-02-23	2026-02-23 09:13:42.478344	2026-02-23 17:49:05.705282	present	2026-03-02 15:43:44.318533
8320	48	2026-02-23	2026-02-23 09:22:47.515728	2026-02-23 17:14:18.947195	present	2026-03-02 15:43:44.318533
8321	50	2026-02-23	2026-02-23 09:02:26.790457	2026-02-23 17:52:22.134956	present	2026-03-02 15:43:44.318533
8322	52	2026-02-23	2026-02-23 09:36:27.060632	2026-02-23 17:06:01.50731	present	2026-03-02 15:43:44.318533
8323	59	2026-02-23	2026-02-23 09:42:46.331591	2026-02-23 17:59:41.821551	present	2026-03-02 15:43:44.318533
8324	60	2026-02-23	2026-02-23 09:47:04.485727	2026-02-23 17:38:20.343061	present	2026-03-02 15:43:44.318533
8325	62	2026-02-23	2026-02-23 09:37:00.81364	2026-02-23 17:06:26.415479	present	2026-03-02 15:43:44.318533
8326	63	2026-02-23	2026-02-23 09:18:46.351569	2026-02-23 17:04:49.171717	present	2026-03-02 15:43:44.318533
8327	64	2026-02-23	2026-02-23 09:17:01.709174	2026-02-23 17:33:53.762113	present	2026-03-02 15:43:44.318533
8328	65	2026-02-23	2026-02-23 09:50:51.603726	2026-02-23 17:09:50.775629	present	2026-03-02 15:43:44.318533
8329	66	2026-02-23	2026-02-23 09:01:28.92182	2026-02-23 17:25:40.103771	present	2026-03-02 15:43:44.318533
8330	70	2026-02-23	2026-02-23 09:57:27.198725	2026-02-23 17:35:48.370576	present	2026-03-02 15:43:44.318533
8331	71	2026-02-23	2026-02-23 09:33:56.895018	2026-02-23 17:39:22.804094	present	2026-03-02 15:43:44.318533
8332	73	2026-02-23	2026-02-23 09:32:24.370733	2026-02-23 17:46:34.24902	present	2026-03-02 15:43:44.318533
8333	74	2026-02-23	2026-02-23 09:07:05.63708	2026-02-23 17:04:37.988736	present	2026-03-02 15:43:44.318533
8334	78	2026-02-23	2026-02-23 09:13:40.085345	2026-02-23 17:33:01.099319	present	2026-03-02 15:43:44.318533
8335	79	2026-02-23	2026-02-23 09:40:23.822808	2026-02-23 17:07:09.658926	present	2026-03-02 15:43:44.318533
8336	82	2026-02-23	2026-02-23 09:56:43.003375	2026-02-23 17:37:26.77697	present	2026-03-02 15:43:44.318533
8337	83	2026-02-23	2026-02-23 09:09:30.314274	2026-02-23 17:47:01.98745	present	2026-03-02 15:43:44.318533
8338	84	2026-02-23	2026-02-23 09:12:13.065862	2026-02-23 17:39:18.866796	present	2026-03-02 15:43:44.318533
8339	85	2026-02-23	2026-02-23 09:55:54.173526	2026-02-23 17:36:49.613905	present	2026-03-02 15:43:44.318533
8340	88	2026-02-23	2026-02-23 09:58:22.777247	2026-02-23 17:13:44.976744	present	2026-03-02 15:43:44.318533
8341	89	2026-02-23	2026-02-23 09:05:16.838744	2026-02-23 17:27:04.092708	present	2026-03-02 15:43:44.318533
8342	96	2026-02-23	2026-02-23 09:29:43.435062	2026-02-23 17:40:15.80842	present	2026-03-02 15:43:44.318533
8343	97	2026-02-23	2026-02-23 09:45:47.338299	2026-02-23 17:33:06.812167	present	2026-03-02 15:43:44.318533
8344	1	2026-02-23	2026-02-23 09:54:47.66136	2026-02-23 17:25:41.223082	present	2026-03-02 15:43:44.318533
8345	2	2026-02-23	2026-02-23 09:38:57.213572	2026-02-23 17:45:55.585595	present	2026-03-02 15:43:44.318533
8346	7	2026-02-23	2026-02-23 09:01:55.871561	2026-02-23 17:00:04.092548	present	2026-03-02 15:43:44.318533
8347	8	2026-02-23	2026-02-23 09:38:12.485775	2026-02-23 17:43:41.462622	present	2026-03-02 15:43:44.318533
8348	9	2026-02-23	2026-02-23 09:12:05.511987	2026-02-23 17:30:02.761299	present	2026-03-02 15:43:44.318533
8349	12	2026-02-23	2026-02-23 09:13:41.256023	2026-02-23 17:58:17.07292	present	2026-03-02 15:43:44.318533
8350	13	2026-02-23	2026-02-23 09:46:12.591611	2026-02-23 17:20:14.227941	present	2026-03-02 15:43:44.318533
8351	14	2026-02-23	2026-02-23 09:51:48.87714	2026-02-23 17:47:59.907762	present	2026-03-02 15:43:44.318533
8352	15	2026-02-23	2026-02-23 09:14:49.512688	2026-02-23 17:21:25.560281	present	2026-03-02 15:43:44.318533
8353	16	2026-02-23	2026-02-23 09:38:30.631248	2026-02-23 17:35:51.582177	present	2026-03-02 15:43:44.318533
8354	17	2026-02-23	2026-02-23 09:46:08.665214	2026-02-23 17:37:15.103236	present	2026-03-02 15:43:44.318533
8355	18	2026-02-23	2026-02-23 09:10:30.00401	2026-02-23 17:42:47.877695	present	2026-03-02 15:43:44.318533
8356	19	2026-02-23	2026-02-23 09:47:16.04544	2026-02-23 17:55:09.891908	present	2026-03-02 15:43:44.318533
8357	20	2026-02-23	2026-02-23 09:32:07.452271	2026-02-23 17:04:04.428359	present	2026-03-02 15:43:44.318533
8358	21	2026-02-23	2026-02-23 09:41:16.146661	2026-02-23 17:45:31.754734	present	2026-03-02 15:43:44.318533
8359	22	2026-02-23	2026-02-23 09:02:58.602314	2026-02-23 17:36:45.729342	present	2026-03-02 15:43:44.318533
8360	23	2026-02-23	2026-02-23 09:06:19.336895	2026-02-23 17:55:43.431335	present	2026-03-02 15:43:44.318533
8361	24	2026-02-23	2026-02-23 09:02:09.316588	2026-02-23 17:51:29.119352	present	2026-03-02 15:43:44.318533
8362	25	2026-02-23	2026-02-23 09:16:32.154458	2026-02-23 17:51:48.540713	present	2026-03-02 15:43:44.318533
8363	26	2026-02-23	2026-02-23 09:55:33.375748	2026-02-23 17:47:32.307547	present	2026-03-02 15:43:44.318533
8364	28	2026-02-23	2026-02-23 09:26:32.942595	2026-02-23 17:59:03.939152	present	2026-03-02 15:43:44.318533
8365	29	2026-02-23	2026-02-23 09:42:23.052969	2026-02-23 17:43:40.667377	present	2026-03-02 15:43:44.318533
8366	30	2026-02-23	2026-02-23 09:00:29.163796	2026-02-23 17:49:01.657285	present	2026-03-02 15:43:44.318533
8367	31	2026-02-23	2026-02-23 09:32:38.631357	2026-02-23 17:24:57.296534	present	2026-03-02 15:43:44.318533
8368	32	2026-02-23	2026-02-23 09:51:57.696014	2026-02-23 17:08:37.533931	present	2026-03-02 15:43:44.318533
8369	34	2026-02-23	2026-02-23 09:50:50.869465	2026-02-23 17:38:47.944735	present	2026-03-02 15:43:44.318533
8370	36	2026-02-23	2026-02-23 09:54:26.070672	2026-02-23 17:57:06.736875	present	2026-03-02 15:43:44.318533
8371	38	2026-02-23	2026-02-23 09:16:30.662055	2026-02-23 17:31:58.05554	present	2026-03-02 15:43:44.318533
8372	39	2026-02-23	2026-02-23 09:10:45.856756	2026-02-23 17:27:35.029301	present	2026-03-02 15:43:44.318533
8373	40	2026-02-23	2026-02-23 09:29:48.300128	2026-02-23 17:50:38.283253	present	2026-03-02 15:43:44.318533
8374	41	2026-02-23	2026-02-23 09:07:11.963583	2026-02-23 17:27:39.281343	present	2026-03-02 15:43:44.318533
8375	42	2026-02-23	2026-02-23 09:42:35.409186	2026-02-23 17:34:59.81331	present	2026-03-02 15:43:44.318533
8376	44	2026-02-23	2026-02-23 09:36:27.869777	2026-02-23 17:16:45.427214	present	2026-03-02 15:43:44.318533
8377	49	2026-02-23	2026-02-23 09:14:30.464894	2026-02-23 17:14:18.1895	present	2026-03-02 15:43:44.318533
8378	51	2026-02-23	2026-02-23 09:41:09.937176	2026-02-23 17:27:51.336313	present	2026-03-02 15:43:44.318533
8379	53	2026-02-23	2026-02-23 09:30:32.407602	2026-02-23 17:20:53.052038	present	2026-03-02 15:43:44.318533
8380	54	2026-02-23	2026-02-23 09:46:19.78051	2026-02-23 17:55:25.526975	present	2026-03-02 15:43:44.318533
8381	55	2026-02-23	2026-02-23 09:55:54.428794	2026-02-23 17:43:43.99554	present	2026-03-02 15:43:44.318533
8382	56	2026-02-23	2026-02-23 09:26:30.158426	2026-02-23 17:57:22.181137	present	2026-03-02 15:43:44.318533
8383	57	2026-02-23	2026-02-23 09:29:18.654293	2026-02-23 17:34:31.609433	present	2026-03-02 15:43:44.318533
8384	58	2026-02-23	2026-02-23 09:11:45.489165	2026-02-23 17:36:48.684257	present	2026-03-02 15:43:44.318533
8385	61	2026-02-23	2026-02-23 09:01:33.827282	2026-02-23 17:47:51.561101	present	2026-03-02 15:43:44.318533
8386	67	2026-02-23	2026-02-23 09:28:44.959573	2026-02-23 17:39:49.259789	present	2026-03-02 15:43:44.318533
8387	68	2026-02-23	2026-02-23 09:14:05.517013	2026-02-23 17:36:15.84323	present	2026-03-02 15:43:44.318533
8388	69	2026-02-23	2026-02-23 09:01:27.752848	2026-02-23 17:48:24.555514	present	2026-03-02 15:43:44.318533
8389	72	2026-02-23	2026-02-23 09:29:25.346872	2026-02-23 17:24:38.904807	present	2026-03-02 15:43:44.318533
8390	75	2026-02-23	2026-02-23 09:21:10.584779	2026-02-23 17:40:47.612932	present	2026-03-02 15:43:44.318533
8391	76	2026-02-23	2026-02-23 09:00:18.772284	2026-02-23 17:04:54.884732	present	2026-03-02 15:43:44.318533
8392	77	2026-02-23	2026-02-23 09:44:44.971233	2026-02-23 17:24:44.496372	present	2026-03-02 15:43:44.318533
8393	80	2026-02-23	2026-02-23 09:34:45.493698	2026-02-23 17:25:32.65051	present	2026-03-02 15:43:44.318533
8394	81	2026-02-23	2026-02-23 09:07:55.612337	2026-02-23 17:53:11.772812	present	2026-03-02 15:43:44.318533
8395	86	2026-02-23	2026-02-23 09:42:48.468111	2026-02-23 17:00:28.601249	present	2026-03-02 15:43:44.318533
8396	87	2026-02-23	2026-02-23 09:07:20.690408	2026-02-23 17:41:07.726685	present	2026-03-02 15:43:44.318533
8397	90	2026-02-23	2026-02-23 09:57:42.168424	2026-02-23 17:48:49.813631	present	2026-03-02 15:43:44.318533
8398	91	2026-02-23	2026-02-23 09:57:37.413346	2026-02-23 17:36:39.688555	present	2026-03-02 15:43:44.318533
8399	92	2026-02-23	2026-02-23 09:02:53.522018	2026-02-23 17:52:53.716587	present	2026-03-02 15:43:44.318533
8400	93	2026-02-23	2026-02-23 09:00:15.752703	2026-02-23 17:23:20.400171	present	2026-03-02 15:43:44.318533
8401	94	2026-02-23	2026-02-23 09:42:03.24103	2026-02-23 17:26:53.012986	present	2026-03-02 15:43:44.318533
8402	95	2026-02-23	2026-02-23 09:18:59.520865	2026-02-23 17:26:14.419579	present	2026-03-02 15:43:44.318533
8403	98	2026-02-23	2026-02-23 09:17:32.100755	2026-02-23 17:52:17.80223	present	2026-03-02 15:43:44.318533
8404	99	2026-02-23	2026-02-23 09:44:09.596887	2026-02-23 17:17:49.104466	present	2026-03-02 15:43:44.318533
8405	100	2026-02-23	2026-02-23 09:55:31.932724	2026-02-23 17:00:44.495197	present	2026-03-02 15:43:44.318533
8406	3	2026-02-24	2026-02-24 09:51:25.60267	2026-02-24 17:15:00.247989	present	2026-03-02 15:43:44.318533
8843	97	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8407	4	2026-02-24	2026-02-24 09:33:04.767426	2026-02-24 17:58:57.011324	present	2026-03-02 15:43:44.318533
8408	5	2026-02-24	2026-02-24 09:18:06.777096	2026-02-24 17:47:56.044448	present	2026-03-02 15:43:44.318533
8409	6	2026-02-24	2026-02-24 09:25:05.187831	2026-02-24 17:16:12.387831	present	2026-03-02 15:43:44.318533
8410	10	2026-02-24	2026-02-24 09:11:31.737498	2026-02-24 17:53:51.830706	present	2026-03-02 15:43:44.318533
8411	11	2026-02-24	2026-02-24 09:59:23.228896	2026-02-24 17:59:16.303255	present	2026-03-02 15:43:44.318533
8412	27	2026-02-24	2026-02-24 09:19:39.277107	2026-02-24 17:26:06.765463	present	2026-03-02 15:43:44.318533
8413	33	2026-02-24	2026-02-24 09:17:29.759833	2026-02-24 17:39:40.42535	present	2026-03-02 15:43:44.318533
8414	35	2026-02-24	2026-02-24 09:07:15.388145	2026-02-24 17:31:15.344629	present	2026-03-02 15:43:44.318533
8415	37	2026-02-24	2026-02-24 09:25:13.04387	2026-02-24 17:33:24.551765	present	2026-03-02 15:43:44.318533
8416	43	2026-02-24	2026-02-24 09:46:55.573348	2026-02-24 17:59:15.757178	present	2026-03-02 15:43:44.318533
8417	45	2026-02-24	2026-02-24 09:18:54.74134	2026-02-24 17:43:07.521331	present	2026-03-02 15:43:44.318533
8418	46	2026-02-24	2026-02-24 09:16:52.963297	2026-02-24 17:58:22.566964	present	2026-03-02 15:43:44.318533
8419	47	2026-02-24	2026-02-24 09:10:33.27186	2026-02-24 17:04:14.712318	present	2026-03-02 15:43:44.318533
8420	48	2026-02-24	2026-02-24 09:40:59.802119	2026-02-24 17:01:09.568754	present	2026-03-02 15:43:44.318533
8421	50	2026-02-24	2026-02-24 09:40:53.850244	2026-02-24 17:44:30.050297	present	2026-03-02 15:43:44.318533
8422	52	2026-02-24	2026-02-24 09:05:07.350169	2026-02-24 17:39:52.346964	present	2026-03-02 15:43:44.318533
8423	59	2026-02-24	2026-02-24 09:37:42.172883	2026-02-24 17:40:51.864036	present	2026-03-02 15:43:44.318533
8424	60	2026-02-24	2026-02-24 09:10:30.569419	2026-02-24 17:23:01.165665	present	2026-03-02 15:43:44.318533
8425	62	2026-02-24	2026-02-24 09:41:26.889675	2026-02-24 17:20:16.45566	present	2026-03-02 15:43:44.318533
8426	63	2026-02-24	2026-02-24 09:02:43.627358	2026-02-24 17:38:21.117224	present	2026-03-02 15:43:44.318533
8427	64	2026-02-24	2026-02-24 09:40:52.26362	2026-02-24 17:47:37.478281	present	2026-03-02 15:43:44.318533
8428	65	2026-02-24	2026-02-24 09:06:39.465086	2026-02-24 17:14:38.059575	present	2026-03-02 15:43:44.318533
8429	66	2026-02-24	2026-02-24 09:16:08.34448	2026-02-24 17:52:25.059103	present	2026-03-02 15:43:44.318533
8430	70	2026-02-24	2026-02-24 09:26:27.013553	2026-02-24 17:01:39.354656	present	2026-03-02 15:43:44.318533
8431	71	2026-02-24	2026-02-24 09:18:07.342176	2026-02-24 17:29:13.995675	present	2026-03-02 15:43:44.318533
8432	73	2026-02-24	2026-02-24 09:02:50.951573	2026-02-24 17:04:34.852572	present	2026-03-02 15:43:44.318533
8433	74	2026-02-24	2026-02-24 09:16:04.390286	2026-02-24 17:09:16.275429	present	2026-03-02 15:43:44.318533
8434	78	2026-02-24	2026-02-24 09:38:29.186399	2026-02-24 17:39:40.497338	present	2026-03-02 15:43:44.318533
8435	79	2026-02-24	2026-02-24 09:44:58.692193	2026-02-24 17:56:44.980036	present	2026-03-02 15:43:44.318533
8436	82	2026-02-24	2026-02-24 09:49:33.693217	2026-02-24 17:03:08.090775	present	2026-03-02 15:43:44.318533
8437	83	2026-02-24	2026-02-24 09:34:23.025785	2026-02-24 17:21:57.180448	present	2026-03-02 15:43:44.318533
8438	84	2026-02-24	2026-02-24 09:27:54.346375	2026-02-24 17:39:12.477704	present	2026-03-02 15:43:44.318533
8439	85	2026-02-24	2026-02-24 09:43:46.738192	2026-02-24 17:54:50.238453	present	2026-03-02 15:43:44.318533
8440	88	2026-02-24	2026-02-24 09:37:29.745819	2026-02-24 17:53:44.436639	present	2026-03-02 15:43:44.318533
8441	89	2026-02-24	2026-02-24 09:08:33.502882	2026-02-24 17:03:54.926354	present	2026-03-02 15:43:44.318533
8442	96	2026-02-24	2026-02-24 09:27:17.721215	2026-02-24 17:51:20.149539	present	2026-03-02 15:43:44.318533
8443	97	2026-02-24	2026-02-24 09:48:32.726477	2026-02-24 17:29:40.689971	present	2026-03-02 15:43:44.318533
8444	1	2026-02-24	2026-02-24 09:03:59.801581	2026-02-24 17:09:58.780233	present	2026-03-02 15:43:44.318533
8445	2	2026-02-24	2026-02-24 09:42:47.09351	2026-02-24 17:11:33.850423	present	2026-03-02 15:43:44.318533
8446	7	2026-02-24	2026-02-24 09:56:52.729313	2026-02-24 17:31:19.616171	present	2026-03-02 15:43:44.318533
8447	8	2026-02-24	2026-02-24 09:04:59.705782	2026-02-24 17:12:30.049892	present	2026-03-02 15:43:44.318533
8448	9	2026-02-24	2026-02-24 09:03:10.095928	2026-02-24 17:35:08.574987	present	2026-03-02 15:43:44.318533
8449	12	2026-02-24	2026-02-24 09:16:58.483095	2026-02-24 17:56:23.738334	present	2026-03-02 15:43:44.318533
8450	13	2026-02-24	2026-02-24 09:02:34.12781	2026-02-24 17:59:27.328873	present	2026-03-02 15:43:44.318533
8451	14	2026-02-24	2026-02-24 09:45:42.968815	2026-02-24 17:52:34.433085	present	2026-03-02 15:43:44.318533
8452	15	2026-02-24	2026-02-24 09:52:31.329753	2026-02-24 17:45:16.557943	present	2026-03-02 15:43:44.318533
8453	16	2026-02-24	2026-02-24 09:41:44.308124	2026-02-24 17:37:02.880415	present	2026-03-02 15:43:44.318533
8454	17	2026-02-24	2026-02-24 09:25:09.642497	2026-02-24 17:38:06.750027	present	2026-03-02 15:43:44.318533
8455	18	2026-02-24	2026-02-24 09:06:58.072052	2026-02-24 17:00:15.691368	present	2026-03-02 15:43:44.318533
8456	19	2026-02-24	2026-02-24 09:15:34.823516	2026-02-24 17:48:44.838713	present	2026-03-02 15:43:44.318533
8457	20	2026-02-24	2026-02-24 09:47:25.476143	2026-02-24 17:24:03.624091	present	2026-03-02 15:43:44.318533
8458	21	2026-02-24	2026-02-24 09:21:04.340587	2026-02-24 17:29:30.613595	present	2026-03-02 15:43:44.318533
8459	22	2026-02-24	2026-02-24 09:32:34.417301	2026-02-24 17:38:11.013134	present	2026-03-02 15:43:44.318533
8460	23	2026-02-24	2026-02-24 09:53:55.459273	2026-02-24 17:21:21.135944	present	2026-03-02 15:43:44.318533
8461	24	2026-02-24	2026-02-24 09:31:11.22419	2026-02-24 17:37:27.543472	present	2026-03-02 15:43:44.318533
8462	25	2026-02-24	2026-02-24 09:51:36.887219	2026-02-24 17:42:20.290175	present	2026-03-02 15:43:44.318533
8463	26	2026-02-24	2026-02-24 09:01:49.537792	2026-02-24 17:07:59.985109	present	2026-03-02 15:43:44.318533
8464	28	2026-02-24	2026-02-24 09:06:59.468417	2026-02-24 17:12:32.803923	present	2026-03-02 15:43:44.318533
8465	29	2026-02-24	2026-02-24 09:56:38.938935	2026-02-24 17:17:55.593471	present	2026-03-02 15:43:44.318533
8466	30	2026-02-24	2026-02-24 09:35:38.870801	2026-02-24 17:42:56.238894	present	2026-03-02 15:43:44.318533
8467	31	2026-02-24	2026-02-24 09:14:10.236548	2026-02-24 17:29:05.202463	present	2026-03-02 15:43:44.318533
8468	32	2026-02-24	2026-02-24 09:59:01.992946	2026-02-24 17:52:56.9233	present	2026-03-02 15:43:44.318533
8469	34	2026-02-24	2026-02-24 09:40:07.923014	2026-02-24 17:33:18.533978	present	2026-03-02 15:43:44.318533
8470	36	2026-02-24	2026-02-24 09:07:27.647735	2026-02-24 17:49:55.021606	present	2026-03-02 15:43:44.318533
8471	38	2026-02-24	2026-02-24 09:42:06.639345	2026-02-24 17:51:14.474113	present	2026-03-02 15:43:44.318533
8472	39	2026-02-24	2026-02-24 09:26:43.736099	2026-02-24 17:30:34.551181	present	2026-03-02 15:43:44.318533
8473	40	2026-02-24	2026-02-24 09:23:45.165861	2026-02-24 17:26:21.862072	present	2026-03-02 15:43:44.318533
8474	41	2026-02-24	2026-02-24 09:27:20.166907	2026-02-24 17:49:44.434206	present	2026-03-02 15:43:44.318533
8475	42	2026-02-24	2026-02-24 09:47:54.432926	2026-02-24 17:51:55.856501	present	2026-03-02 15:43:44.318533
8476	44	2026-02-24	2026-02-24 09:35:35.853989	2026-02-24 17:54:45.051522	present	2026-03-02 15:43:44.318533
8477	49	2026-02-24	2026-02-24 09:34:08.60533	2026-02-24 17:55:38.644609	present	2026-03-02 15:43:44.318533
8478	51	2026-02-24	2026-02-24 09:52:34.532821	2026-02-24 17:38:54.750061	present	2026-03-02 15:43:44.318533
8479	53	2026-02-24	2026-02-24 09:53:24.30594	2026-02-24 17:21:42.63709	present	2026-03-02 15:43:44.318533
8480	54	2026-02-24	2026-02-24 09:51:57.052409	2026-02-24 17:41:58.912489	present	2026-03-02 15:43:44.318533
8481	55	2026-02-24	2026-02-24 09:33:35.026251	2026-02-24 17:16:09.487592	present	2026-03-02 15:43:44.318533
8482	56	2026-02-24	2026-02-24 09:20:29.403293	2026-02-24 17:50:56.852724	present	2026-03-02 15:43:44.318533
8483	57	2026-02-24	2026-02-24 09:59:35.469895	2026-02-24 17:03:32.3494	present	2026-03-02 15:43:44.318533
8484	58	2026-02-24	2026-02-24 09:22:21.081938	2026-02-24 17:47:48.041154	present	2026-03-02 15:43:44.318533
8485	61	2026-02-24	2026-02-24 09:16:36.122169	2026-02-24 17:25:14.841178	present	2026-03-02 15:43:44.318533
8486	67	2026-02-24	2026-02-24 09:20:36.307955	2026-02-24 17:56:39.467028	present	2026-03-02 15:43:44.318533
8487	68	2026-02-24	2026-02-24 09:50:17.616263	2026-02-24 17:22:55.903765	present	2026-03-02 15:43:44.318533
8488	69	2026-02-24	2026-02-24 09:53:57.562447	2026-02-24 17:25:19.999997	present	2026-03-02 15:43:44.318533
8489	72	2026-02-24	2026-02-24 09:47:49.690793	2026-02-24 17:59:28.938944	present	2026-03-02 15:43:44.318533
8490	75	2026-02-24	2026-02-24 09:25:48.949775	2026-02-24 17:51:11.92057	present	2026-03-02 15:43:44.318533
8491	76	2026-02-24	2026-02-24 09:12:11.8596	2026-02-24 17:42:02.852722	present	2026-03-02 15:43:44.318533
8492	77	2026-02-24	2026-02-24 09:52:59.168176	2026-02-24 17:35:52.86155	present	2026-03-02 15:43:44.318533
8493	80	2026-02-24	2026-02-24 09:31:52.773487	2026-02-24 17:37:01.3438	present	2026-03-02 15:43:44.318533
8494	81	2026-02-24	2026-02-24 09:51:23.84622	2026-02-24 17:32:03.661711	present	2026-03-02 15:43:44.318533
8495	86	2026-02-24	2026-02-24 09:01:01.784271	2026-02-24 17:15:13.21446	present	2026-03-02 15:43:44.318533
8496	87	2026-02-24	2026-02-24 09:05:41.97484	2026-02-24 17:58:05.852466	present	2026-03-02 15:43:44.318533
8497	90	2026-02-24	2026-02-24 09:46:52.425428	2026-02-24 17:39:20.832514	present	2026-03-02 15:43:44.318533
8498	91	2026-02-24	2026-02-24 09:16:43.289633	2026-02-24 17:06:47.017481	present	2026-03-02 15:43:44.318533
8499	92	2026-02-24	2026-02-24 09:52:08.293297	2026-02-24 17:39:22.961002	present	2026-03-02 15:43:44.318533
8500	93	2026-02-24	2026-02-24 09:18:18.181044	2026-02-24 17:10:29.252338	present	2026-03-02 15:43:44.318533
8501	94	2026-02-24	2026-02-24 09:18:09.142765	2026-02-24 17:58:21.534718	present	2026-03-02 15:43:44.318533
8502	95	2026-02-24	2026-02-24 09:03:18.579601	2026-02-24 17:30:12.835246	present	2026-03-02 15:43:44.318533
8503	98	2026-02-24	2026-02-24 09:49:59.780601	2026-02-24 17:51:38.804474	present	2026-03-02 15:43:44.318533
8504	99	2026-02-24	2026-02-24 09:02:27.264336	2026-02-24 17:15:11.175512	present	2026-03-02 15:43:44.318533
8505	100	2026-02-24	2026-02-24 09:45:15.32142	2026-02-24 17:34:50.27568	present	2026-03-02 15:43:44.318533
8506	3	2026-02-25	2026-02-25 09:57:30.806934	2026-02-25 17:29:12.747517	present	2026-03-02 15:43:44.318533
8507	4	2026-02-25	2026-02-25 09:37:55.26419	2026-02-25 17:55:18.270425	present	2026-03-02 15:43:44.318533
8508	5	2026-02-25	2026-02-25 09:07:02.886116	2026-02-25 17:10:09.65434	present	2026-03-02 15:43:44.318533
8509	6	2026-02-25	2026-02-25 09:31:43.973684	2026-02-25 17:53:21.766494	present	2026-03-02 15:43:44.318533
8510	10	2026-02-25	2026-02-25 09:57:08.099564	2026-02-25 17:21:30.529061	present	2026-03-02 15:43:44.318533
8511	11	2026-02-25	2026-02-25 09:36:30.023208	2026-02-25 17:56:21.07216	present	2026-03-02 15:43:44.318533
8512	27	2026-02-25	2026-02-25 09:31:48.55119	2026-02-25 17:09:11.20594	present	2026-03-02 15:43:44.318533
8513	33	2026-02-25	2026-02-25 09:55:20.370452	2026-02-25 17:29:24.595548	present	2026-03-02 15:43:44.318533
8514	35	2026-02-25	2026-02-25 09:44:39.192757	2026-02-25 17:47:47.11195	present	2026-03-02 15:43:44.318533
8515	37	2026-02-25	2026-02-25 09:59:15.529252	2026-02-25 17:18:28.402189	present	2026-03-02 15:43:44.318533
8516	43	2026-02-25	2026-02-25 09:32:48.325791	2026-02-25 17:07:22.761788	present	2026-03-02 15:43:44.318533
8517	45	2026-02-25	2026-02-25 09:02:11.305489	2026-02-25 17:10:40.602788	present	2026-03-02 15:43:44.318533
8518	46	2026-02-25	2026-02-25 09:28:18.834406	2026-02-25 17:55:18.124056	present	2026-03-02 15:43:44.318533
8519	47	2026-02-25	2026-02-25 09:43:52.402485	2026-02-25 17:22:23.281469	present	2026-03-02 15:43:44.318533
8520	48	2026-02-25	2026-02-25 09:49:12.839886	2026-02-25 17:20:08.420209	present	2026-03-02 15:43:44.318533
8521	50	2026-02-25	2026-02-25 09:12:01.740554	2026-02-25 17:30:36.004982	present	2026-03-02 15:43:44.318533
8522	52	2026-02-25	2026-02-25 09:35:01.027404	2026-02-25 17:36:22.412296	present	2026-03-02 15:43:44.318533
8523	59	2026-02-25	2026-02-25 09:01:40.221796	2026-02-25 17:03:01.078025	present	2026-03-02 15:43:44.318533
8524	60	2026-02-25	2026-02-25 09:38:15.676416	2026-02-25 17:24:45.029772	present	2026-03-02 15:43:44.318533
8525	62	2026-02-25	2026-02-25 09:04:22.97937	2026-02-25 17:29:46.066702	present	2026-03-02 15:43:44.318533
8526	63	2026-02-25	2026-02-25 09:25:14.453815	2026-02-25 17:50:56.712522	present	2026-03-02 15:43:44.318533
8527	64	2026-02-25	2026-02-25 09:56:45.036427	2026-02-25 17:26:16.967102	present	2026-03-02 15:43:44.318533
8528	65	2026-02-25	2026-02-25 09:34:24.238713	2026-02-25 17:22:19.525247	present	2026-03-02 15:43:44.318533
8529	66	2026-02-25	2026-02-25 09:07:21.636826	2026-02-25 17:43:11.825305	present	2026-03-02 15:43:44.318533
8530	70	2026-02-25	2026-02-25 09:43:43.494207	2026-02-25 17:54:59.576408	present	2026-03-02 15:43:44.318533
8531	71	2026-02-25	2026-02-25 09:17:07.618755	2026-02-25 17:31:46.99257	present	2026-03-02 15:43:44.318533
8532	73	2026-02-25	2026-02-25 09:09:48.293204	2026-02-25 17:49:34.623386	present	2026-03-02 15:43:44.318533
8533	74	2026-02-25	2026-02-25 09:49:41.016947	2026-02-25 17:45:15.383191	present	2026-03-02 15:43:44.318533
8534	78	2026-02-25	2026-02-25 09:01:06.888404	2026-02-25 17:21:36.196331	present	2026-03-02 15:43:44.318533
8535	79	2026-02-25	2026-02-25 09:53:08.601064	2026-02-25 17:54:19.701197	present	2026-03-02 15:43:44.318533
8536	82	2026-02-25	2026-02-25 09:29:46.147911	2026-02-25 17:16:53.82091	present	2026-03-02 15:43:44.318533
8537	83	2026-02-25	2026-02-25 09:42:16.241329	2026-02-25 17:58:35.143304	present	2026-03-02 15:43:44.318533
8538	84	2026-02-25	2026-02-25 09:08:41.040232	2026-02-25 17:55:15.378518	present	2026-03-02 15:43:44.318533
8539	85	2026-02-25	2026-02-25 09:01:01.124977	2026-02-25 17:19:44.805779	present	2026-03-02 15:43:44.318533
8540	88	2026-02-25	2026-02-25 09:46:57.439398	2026-02-25 17:46:12.349472	present	2026-03-02 15:43:44.318533
8541	89	2026-02-25	2026-02-25 09:07:01.049723	2026-02-25 17:06:21.296153	present	2026-03-02 15:43:44.318533
8542	96	2026-02-25	2026-02-25 09:50:08.760898	2026-02-25 17:24:55.635833	present	2026-03-02 15:43:44.318533
8543	97	2026-02-25	2026-02-25 09:09:43.069008	2026-02-25 17:17:46.704037	present	2026-03-02 15:43:44.318533
8544	1	2026-02-25	2026-02-25 09:07:20.971718	2026-02-25 17:35:27.328365	present	2026-03-02 15:43:44.318533
8545	2	2026-02-25	2026-02-25 09:42:42.685418	2026-02-25 17:47:45.450199	present	2026-03-02 15:43:44.318533
8546	7	2026-02-25	2026-02-25 09:02:50.216947	2026-02-25 17:33:07.441774	present	2026-03-02 15:43:44.318533
8547	8	2026-02-25	2026-02-25 09:48:14.402962	2026-02-25 17:19:55.178194	present	2026-03-02 15:43:44.318533
8548	9	2026-02-25	2026-02-25 09:35:10.790232	2026-02-25 17:28:11.172505	present	2026-03-02 15:43:44.318533
8549	12	2026-02-25	2026-02-25 09:02:30.091488	2026-02-25 17:16:07.302784	present	2026-03-02 15:43:44.318533
8550	13	2026-02-25	2026-02-25 09:12:10.191205	2026-02-25 17:44:11.728805	present	2026-03-02 15:43:44.318533
8551	14	2026-02-25	2026-02-25 09:50:31.105259	2026-02-25 17:30:34.698889	present	2026-03-02 15:43:44.318533
8552	15	2026-02-25	2026-02-25 09:31:54.339035	2026-02-25 17:11:17.925043	present	2026-03-02 15:43:44.318533
8553	16	2026-02-25	2026-02-25 09:53:10.210631	2026-02-25 17:41:51.444188	present	2026-03-02 15:43:44.318533
8554	17	2026-02-25	2026-02-25 09:49:15.018961	2026-02-25 17:34:39.057607	present	2026-03-02 15:43:44.318533
8555	18	2026-02-25	2026-02-25 09:13:16.560008	2026-02-25 17:53:42.212765	present	2026-03-02 15:43:44.318533
8556	19	2026-02-25	2026-02-25 09:21:21.407997	2026-02-25 17:52:54.84358	present	2026-03-02 15:43:44.318533
8557	20	2026-02-25	2026-02-25 09:36:41.20122	2026-02-25 17:10:38.231629	present	2026-03-02 15:43:44.318533
8558	21	2026-02-25	2026-02-25 09:31:39.722157	2026-02-25 17:29:53.283827	present	2026-03-02 15:43:44.318533
8559	22	2026-02-25	2026-02-25 09:09:49.379574	2026-02-25 17:12:37.74916	present	2026-03-02 15:43:44.318533
8560	23	2026-02-25	2026-02-25 09:11:00.266724	2026-02-25 17:45:33.965657	present	2026-03-02 15:43:44.318533
8561	24	2026-02-25	2026-02-25 09:09:47.304707	2026-02-25 17:47:51.920792	present	2026-03-02 15:43:44.318533
8562	25	2026-02-25	2026-02-25 09:05:34.79966	2026-02-25 17:11:28.886725	present	2026-03-02 15:43:44.318533
8563	26	2026-02-25	2026-02-25 09:19:26.107249	2026-02-25 17:33:08.649614	present	2026-03-02 15:43:44.318533
8564	28	2026-02-25	2026-02-25 09:49:03.626179	2026-02-25 17:29:13.41989	present	2026-03-02 15:43:44.318533
8565	29	2026-02-25	2026-02-25 09:31:44.920159	2026-02-25 17:09:35.174155	present	2026-03-02 15:43:44.318533
8566	30	2026-02-25	2026-02-25 09:36:48.89985	2026-02-25 17:49:07.725425	present	2026-03-02 15:43:44.318533
8567	31	2026-02-25	2026-02-25 09:32:45.932123	2026-02-25 17:32:16.451462	present	2026-03-02 15:43:44.318533
8568	32	2026-02-25	2026-02-25 09:49:45.945754	2026-02-25 17:08:52.68333	present	2026-03-02 15:43:44.318533
8569	34	2026-02-25	2026-02-25 09:31:33.058863	2026-02-25 17:41:13.517118	present	2026-03-02 15:43:44.318533
8570	36	2026-02-25	2026-02-25 09:36:19.850552	2026-02-25 17:27:10.352312	present	2026-03-02 15:43:44.318533
8571	38	2026-02-25	2026-02-25 09:57:19.561941	2026-02-25 17:18:21.734429	present	2026-03-02 15:43:44.318533
8572	39	2026-02-25	2026-02-25 09:24:42.671692	2026-02-25 17:40:58.466617	present	2026-03-02 15:43:44.318533
8573	40	2026-02-25	2026-02-25 09:55:07.960174	2026-02-25 17:38:54.304574	present	2026-03-02 15:43:44.318533
8574	41	2026-02-25	2026-02-25 09:07:05.107572	2026-02-25 17:16:56.7431	present	2026-03-02 15:43:44.318533
8575	42	2026-02-25	2026-02-25 09:49:09.986538	2026-02-25 17:28:07.564504	present	2026-03-02 15:43:44.318533
8576	44	2026-02-25	2026-02-25 09:19:11.96127	2026-02-25 17:53:08.825161	present	2026-03-02 15:43:44.318533
8577	49	2026-02-25	2026-02-25 09:34:57.601458	2026-02-25 17:50:14.949135	present	2026-03-02 15:43:44.318533
8578	51	2026-02-25	2026-02-25 09:03:29.507859	2026-02-25 17:29:30.611116	present	2026-03-02 15:43:44.318533
8579	53	2026-02-25	2026-02-25 09:52:04.576801	2026-02-25 17:38:39.661521	present	2026-03-02 15:43:44.318533
8580	54	2026-02-25	2026-02-25 09:13:31.790443	2026-02-25 17:26:16.278178	present	2026-03-02 15:43:44.318533
8581	55	2026-02-25	2026-02-25 09:03:31.435516	2026-02-25 17:50:36.986482	present	2026-03-02 15:43:44.318533
8582	56	2026-02-25	2026-02-25 09:25:42.538857	2026-02-25 17:47:23.73187	present	2026-03-02 15:43:44.318533
8583	57	2026-02-25	2026-02-25 09:37:54.815928	2026-02-25 17:28:21.940714	present	2026-03-02 15:43:44.318533
8584	58	2026-02-25	2026-02-25 09:30:26.974	2026-02-25 17:30:12.386412	present	2026-03-02 15:43:44.318533
8585	61	2026-02-25	2026-02-25 09:45:43.965368	2026-02-25 17:17:49.334408	present	2026-03-02 15:43:44.318533
8586	67	2026-02-25	2026-02-25 09:20:43.510439	2026-02-25 17:43:31.457244	present	2026-03-02 15:43:44.318533
8587	68	2026-02-25	2026-02-25 09:33:40.965118	2026-02-25 17:23:42.133298	present	2026-03-02 15:43:44.318533
8588	69	2026-02-25	2026-02-25 09:35:00.061788	2026-02-25 17:27:55.192336	present	2026-03-02 15:43:44.318533
8589	72	2026-02-25	2026-02-25 09:57:55.222823	2026-02-25 17:59:26.958443	present	2026-03-02 15:43:44.318533
8590	75	2026-02-25	2026-02-25 09:41:10.751758	2026-02-25 17:50:22.70471	present	2026-03-02 15:43:44.318533
8591	76	2026-02-25	2026-02-25 09:18:59.835897	2026-02-25 17:56:22.601178	present	2026-03-02 15:43:44.318533
8592	77	2026-02-25	2026-02-25 09:41:42.156644	2026-02-25 17:42:07.097466	present	2026-03-02 15:43:44.318533
8593	80	2026-02-25	2026-02-25 09:51:02.091372	2026-02-25 17:40:25.871327	present	2026-03-02 15:43:44.318533
8594	81	2026-02-25	2026-02-25 09:36:20.497808	2026-02-25 17:46:39.15588	present	2026-03-02 15:43:44.318533
8595	86	2026-02-25	2026-02-25 09:41:37.96769	2026-02-25 17:46:24.598142	present	2026-03-02 15:43:44.318533
8596	87	2026-02-25	2026-02-25 09:51:59.162501	2026-02-25 17:45:53.215433	present	2026-03-02 15:43:44.318533
8597	90	2026-02-25	2026-02-25 09:24:05.303641	2026-02-25 17:48:12.792332	present	2026-03-02 15:43:44.318533
8598	91	2026-02-25	2026-02-25 09:01:23.689649	2026-02-25 17:21:00.058907	present	2026-03-02 15:43:44.318533
8599	92	2026-02-25	2026-02-25 09:58:33.524914	2026-02-25 17:50:21.688255	present	2026-03-02 15:43:44.318533
8600	93	2026-02-25	2026-02-25 09:51:46.869935	2026-02-25 17:00:21.440522	present	2026-03-02 15:43:44.318533
8601	94	2026-02-25	2026-02-25 09:07:48.654799	2026-02-25 17:14:55.331092	present	2026-03-02 15:43:44.318533
8602	95	2026-02-25	2026-02-25 09:59:15.605278	2026-02-25 17:16:48.735356	present	2026-03-02 15:43:44.318533
8603	98	2026-02-25	2026-02-25 09:22:34.477449	2026-02-25 17:46:54.958275	present	2026-03-02 15:43:44.318533
8604	99	2026-02-25	2026-02-25 09:29:03.894087	2026-02-25 17:34:07.604275	present	2026-03-02 15:43:44.318533
8605	100	2026-02-25	2026-02-25 09:39:20.571245	2026-02-25 17:54:40.933293	present	2026-03-02 15:43:44.318533
8606	3	2026-02-26	2026-02-26 09:42:25.103389	2026-02-26 17:21:33.755387	present	2026-03-02 15:43:44.318533
8607	4	2026-02-26	2026-02-26 09:58:30.244703	2026-02-26 17:52:49.069038	present	2026-03-02 15:43:44.318533
8608	5	2026-02-26	2026-02-26 09:58:34.888953	2026-02-26 17:22:50.297195	present	2026-03-02 15:43:44.318533
8609	6	2026-02-26	2026-02-26 09:18:07.777275	2026-02-26 17:56:07.009271	present	2026-03-02 15:43:44.318533
8610	10	2026-02-26	2026-02-26 09:55:33.871981	2026-02-26 17:47:15.073337	present	2026-03-02 15:43:44.318533
8611	11	2026-02-26	2026-02-26 09:07:46.016983	2026-02-26 17:38:52.906061	present	2026-03-02 15:43:44.318533
8612	27	2026-02-26	2026-02-26 09:14:19.345706	2026-02-26 17:57:21.909223	present	2026-03-02 15:43:44.318533
8613	33	2026-02-26	2026-02-26 09:51:50.021608	2026-02-26 17:05:33.36667	present	2026-03-02 15:43:44.318533
8614	35	2026-02-26	2026-02-26 09:47:07.490985	2026-02-26 17:42:53.332533	present	2026-03-02 15:43:44.318533
8615	37	2026-02-26	2026-02-26 09:56:12.564815	2026-02-26 17:06:07.288715	present	2026-03-02 15:43:44.318533
8616	43	2026-02-26	2026-02-26 09:42:20.565745	2026-02-26 17:58:47.346641	present	2026-03-02 15:43:44.318533
8617	45	2026-02-26	2026-02-26 09:38:48.888183	2026-02-26 17:17:20.48475	present	2026-03-02 15:43:44.318533
8618	46	2026-02-26	2026-02-26 09:47:41.61014	2026-02-26 17:47:39.497897	present	2026-03-02 15:43:44.318533
8619	47	2026-02-26	2026-02-26 09:50:54.397599	2026-02-26 17:38:05.521887	present	2026-03-02 15:43:44.318533
8620	48	2026-02-26	2026-02-26 09:37:37.540439	2026-02-26 17:05:35.526457	present	2026-03-02 15:43:44.318533
8621	50	2026-02-26	2026-02-26 09:27:02.663777	2026-02-26 17:05:50.092388	present	2026-03-02 15:43:44.318533
8622	52	2026-02-26	2026-02-26 09:29:21.945876	2026-02-26 17:50:57.352783	present	2026-03-02 15:43:44.318533
8623	59	2026-02-26	2026-02-26 09:47:48.075722	2026-02-26 17:06:17.559363	present	2026-03-02 15:43:44.318533
8624	60	2026-02-26	2026-02-26 09:32:39.860833	2026-02-26 17:45:33.080825	present	2026-03-02 15:43:44.318533
8625	62	2026-02-26	2026-02-26 09:36:44.997322	2026-02-26 17:02:45.34771	present	2026-03-02 15:43:44.318533
8626	63	2026-02-26	2026-02-26 09:56:50.496256	2026-02-26 17:00:17.056898	present	2026-03-02 15:43:44.318533
8627	64	2026-02-26	2026-02-26 09:13:54.82089	2026-02-26 17:08:17.019517	present	2026-03-02 15:43:44.318533
8628	65	2026-02-26	2026-02-26 09:51:59.663492	2026-02-26 17:34:46.943664	present	2026-03-02 15:43:44.318533
8629	66	2026-02-26	2026-02-26 09:01:30.135747	2026-02-26 17:56:36.196834	present	2026-03-02 15:43:44.318533
8630	70	2026-02-26	2026-02-26 09:55:10.885519	2026-02-26 17:28:55.180304	present	2026-03-02 15:43:44.318533
8631	71	2026-02-26	2026-02-26 09:05:14.223909	2026-02-26 17:57:42.61037	present	2026-03-02 15:43:44.318533
8632	73	2026-02-26	2026-02-26 09:23:37.260758	2026-02-26 17:56:28.093687	present	2026-03-02 15:43:44.318533
8633	74	2026-02-26	2026-02-26 09:43:43.125675	2026-02-26 17:03:01.118415	present	2026-03-02 15:43:44.318533
8634	78	2026-02-26	2026-02-26 09:16:32.85765	2026-02-26 17:55:25.404691	present	2026-03-02 15:43:44.318533
8635	79	2026-02-26	2026-02-26 09:20:38.959369	2026-02-26 17:44:09.173852	present	2026-03-02 15:43:44.318533
8636	82	2026-02-26	2026-02-26 09:26:34.537622	2026-02-26 17:58:15.079724	present	2026-03-02 15:43:44.318533
8637	83	2026-02-26	2026-02-26 09:25:32.763712	2026-02-26 17:59:24.252272	present	2026-03-02 15:43:44.318533
8638	84	2026-02-26	2026-02-26 09:47:15.618552	2026-02-26 17:15:46.666313	present	2026-03-02 15:43:44.318533
8639	85	2026-02-26	2026-02-26 09:13:29.580209	2026-02-26 17:54:12.614183	present	2026-03-02 15:43:44.318533
8640	88	2026-02-26	2026-02-26 09:33:08.434344	2026-02-26 17:09:10.24015	present	2026-03-02 15:43:44.318533
8641	89	2026-02-26	2026-02-26 09:09:59.465726	2026-02-26 17:53:44.830219	present	2026-03-02 15:43:44.318533
8642	96	2026-02-26	2026-02-26 09:21:39.116826	2026-02-26 17:31:44.066527	present	2026-03-02 15:43:44.318533
8643	97	2026-02-26	2026-02-26 09:18:47.048967	2026-02-26 17:04:41.20139	present	2026-03-02 15:43:44.318533
8644	1	2026-02-26	2026-02-26 09:06:34.367184	2026-02-26 17:46:43.690119	present	2026-03-02 15:43:44.318533
8645	2	2026-02-26	2026-02-26 09:22:35.147051	2026-02-26 17:12:00.015044	present	2026-03-02 15:43:44.318533
8646	7	2026-02-26	2026-02-26 09:12:45.02805	2026-02-26 17:31:34.666255	present	2026-03-02 15:43:44.318533
8647	8	2026-02-26	2026-02-26 09:52:18.157939	2026-02-26 17:35:30.023178	present	2026-03-02 15:43:44.318533
8648	9	2026-02-26	2026-02-26 09:16:09.141265	2026-02-26 17:59:00.37899	present	2026-03-02 15:43:44.318533
8649	12	2026-02-26	2026-02-26 09:12:40.567206	2026-02-26 17:38:31.833281	present	2026-03-02 15:43:44.318533
8650	13	2026-02-26	2026-02-26 09:30:33.554892	2026-02-26 17:45:54.314867	present	2026-03-02 15:43:44.318533
8651	14	2026-02-26	2026-02-26 09:05:41.222784	2026-02-26 17:42:23.069431	present	2026-03-02 15:43:44.318533
8652	15	2026-02-26	2026-02-26 09:24:59.406684	2026-02-26 17:52:01.348462	present	2026-03-02 15:43:44.318533
8653	16	2026-02-26	2026-02-26 09:09:57.553937	2026-02-26 17:13:26.62238	present	2026-03-02 15:43:44.318533
8654	17	2026-02-26	2026-02-26 09:33:54.25362	2026-02-26 17:39:10.006586	present	2026-03-02 15:43:44.318533
8655	18	2026-02-26	2026-02-26 09:28:02.274782	2026-02-26 17:34:58.556817	present	2026-03-02 15:43:44.318533
8656	19	2026-02-26	2026-02-26 09:10:35.483255	2026-02-26 17:16:50.461232	present	2026-03-02 15:43:44.318533
8657	20	2026-02-26	2026-02-26 09:42:40.012341	2026-02-26 17:58:28.484743	present	2026-03-02 15:43:44.318533
8658	21	2026-02-26	2026-02-26 09:36:43.657991	2026-02-26 17:45:08.692559	present	2026-03-02 15:43:44.318533
8659	22	2026-02-26	2026-02-26 09:23:16.260833	2026-02-26 17:39:57.527022	present	2026-03-02 15:43:44.318533
8660	23	2026-02-26	2026-02-26 09:29:47.450472	2026-02-26 17:17:53.992286	present	2026-03-02 15:43:44.318533
8661	24	2026-02-26	2026-02-26 09:59:35.406067	2026-02-26 17:53:05.460833	present	2026-03-02 15:43:44.318533
8662	25	2026-02-26	2026-02-26 09:00:34.341647	2026-02-26 17:06:32.328293	present	2026-03-02 15:43:44.318533
8663	26	2026-02-26	2026-02-26 09:07:16.876793	2026-02-26 17:44:50.585441	present	2026-03-02 15:43:44.318533
8664	28	2026-02-26	2026-02-26 09:42:14.101592	2026-02-26 17:46:19.140111	present	2026-03-02 15:43:44.318533
8665	29	2026-02-26	2026-02-26 09:27:32.695626	2026-02-26 17:32:35.335164	present	2026-03-02 15:43:44.318533
8666	30	2026-02-26	2026-02-26 09:43:06.375026	2026-02-26 17:26:47.008789	present	2026-03-02 15:43:44.318533
8667	31	2026-02-26	2026-02-26 09:50:37.666659	2026-02-26 17:43:21.769026	present	2026-03-02 15:43:44.318533
8668	32	2026-02-26	2026-02-26 09:59:13.263601	2026-02-26 17:16:48.909814	present	2026-03-02 15:43:44.318533
8669	34	2026-02-26	2026-02-26 09:27:24.794033	2026-02-26 17:32:18.885848	present	2026-03-02 15:43:44.318533
8670	36	2026-02-26	2026-02-26 09:09:29.007449	2026-02-26 17:23:43.683745	present	2026-03-02 15:43:44.318533
8671	38	2026-02-26	2026-02-26 09:23:45.409354	2026-02-26 17:07:56.433214	present	2026-03-02 15:43:44.318533
8672	39	2026-02-26	2026-02-26 09:41:35.833197	2026-02-26 17:45:01.490084	present	2026-03-02 15:43:44.318533
8673	40	2026-02-26	2026-02-26 09:55:31.67419	2026-02-26 17:51:09.439739	present	2026-03-02 15:43:44.318533
8674	41	2026-02-26	2026-02-26 09:06:27.456404	2026-02-26 17:33:43.226277	present	2026-03-02 15:43:44.318533
8675	42	2026-02-26	2026-02-26 09:47:00.439498	2026-02-26 17:23:32.424325	present	2026-03-02 15:43:44.318533
8676	44	2026-02-26	2026-02-26 09:49:31.066209	2026-02-26 17:58:29.431628	present	2026-03-02 15:43:44.318533
8677	49	2026-02-26	2026-02-26 09:23:08.079808	2026-02-26 17:52:07.91868	present	2026-03-02 15:43:44.318533
8678	51	2026-02-26	2026-02-26 09:06:37.364236	2026-02-26 17:59:46.607386	present	2026-03-02 15:43:44.318533
8679	53	2026-02-26	2026-02-26 09:24:19.694451	2026-02-26 17:02:57.556965	present	2026-03-02 15:43:44.318533
8680	54	2026-02-26	2026-02-26 09:07:18.817371	2026-02-26 17:46:09.177519	present	2026-03-02 15:43:44.318533
8681	55	2026-02-26	2026-02-26 09:53:37.190169	2026-02-26 17:15:46.254533	present	2026-03-02 15:43:44.318533
8682	56	2026-02-26	2026-02-26 09:26:21.527646	2026-02-26 17:06:12.627915	present	2026-03-02 15:43:44.318533
8683	57	2026-02-26	2026-02-26 09:53:29.038156	2026-02-26 17:02:47.153229	present	2026-03-02 15:43:44.318533
8684	58	2026-02-26	2026-02-26 09:21:03.340715	2026-02-26 17:47:40.979534	present	2026-03-02 15:43:44.318533
8685	61	2026-02-26	2026-02-26 09:48:17.117746	2026-02-26 17:41:00.4354	present	2026-03-02 15:43:44.318533
8686	67	2026-02-26	2026-02-26 09:08:23.262856	2026-02-26 17:55:42.449372	present	2026-03-02 15:43:44.318533
8687	68	2026-02-26	2026-02-26 09:08:05.411913	2026-02-26 17:22:03.029157	present	2026-03-02 15:43:44.318533
8688	69	2026-02-26	2026-02-26 09:28:43.798516	2026-02-26 17:46:59.121044	present	2026-03-02 15:43:44.318533
8689	72	2026-02-26	2026-02-26 09:18:15.592296	2026-02-26 17:26:59.469948	present	2026-03-02 15:43:44.318533
8690	75	2026-02-26	2026-02-26 09:23:08.91357	2026-02-26 17:10:49.362663	present	2026-03-02 15:43:44.318533
8691	76	2026-02-26	2026-02-26 09:54:59.230494	2026-02-26 17:41:31.282063	present	2026-03-02 15:43:44.318533
8692	77	2026-02-26	2026-02-26 09:34:55.40571	2026-02-26 17:34:49.94176	present	2026-03-02 15:43:44.318533
8693	80	2026-02-26	2026-02-26 09:17:16.053068	2026-02-26 17:06:47.408741	present	2026-03-02 15:43:44.318533
8694	81	2026-02-26	2026-02-26 09:25:34.846621	2026-02-26 17:29:12.481441	present	2026-03-02 15:43:44.318533
8695	86	2026-02-26	2026-02-26 09:08:02.301902	2026-02-26 17:38:52.716684	present	2026-03-02 15:43:44.318533
8696	87	2026-02-26	2026-02-26 09:54:35.574439	2026-02-26 17:50:57.664898	present	2026-03-02 15:43:44.318533
8697	90	2026-02-26	2026-02-26 09:13:55.652364	2026-02-26 17:00:29.090446	present	2026-03-02 15:43:44.318533
8698	91	2026-02-26	2026-02-26 09:52:14.289551	2026-02-26 17:47:57.352778	present	2026-03-02 15:43:44.318533
8699	92	2026-02-26	2026-02-26 09:40:21.495056	2026-02-26 17:59:18.800693	present	2026-03-02 15:43:44.318533
8700	93	2026-02-26	2026-02-26 09:41:00.051914	2026-02-26 17:56:14.555636	present	2026-03-02 15:43:44.318533
8701	94	2026-02-26	2026-02-26 09:24:25.796891	2026-02-26 17:15:19.277255	present	2026-03-02 15:43:44.318533
8702	95	2026-02-26	2026-02-26 09:08:17.364441	2026-02-26 17:56:49.965668	present	2026-03-02 15:43:44.318533
8703	98	2026-02-26	2026-02-26 09:02:16.57529	2026-02-26 17:22:34.636628	present	2026-03-02 15:43:44.318533
8704	99	2026-02-26	2026-02-26 09:07:51.218912	2026-02-26 17:23:07.077128	present	2026-03-02 15:43:44.318533
8705	100	2026-02-26	2026-02-26 09:45:21.333113	2026-02-26 17:47:53.569512	present	2026-03-02 15:43:44.318533
8706	3	2026-02-27	2026-02-27 09:57:54.829451	2026-02-27 17:21:09.230401	present	2026-03-02 15:43:44.318533
8707	4	2026-02-27	2026-02-27 09:24:17.718129	2026-02-27 17:39:56.759254	present	2026-03-02 15:43:44.318533
8708	5	2026-02-27	2026-02-27 09:54:47.401898	2026-02-27 17:48:52.562033	present	2026-03-02 15:43:44.318533
8709	6	2026-02-27	2026-02-27 09:25:27.368793	2026-02-27 17:43:22.76073	present	2026-03-02 15:43:44.318533
8710	10	2026-02-27	2026-02-27 09:15:02.6073	2026-02-27 17:28:10.654137	present	2026-03-02 15:43:44.318533
8711	11	2026-02-27	2026-02-27 09:37:10.180184	2026-02-27 17:11:58.523684	present	2026-03-02 15:43:44.318533
8712	27	2026-02-27	2026-02-27 09:32:58.380632	2026-02-27 17:44:38.34409	present	2026-03-02 15:43:44.318533
8713	33	2026-02-27	2026-02-27 09:36:08.797297	2026-02-27 17:32:22.180732	present	2026-03-02 15:43:44.318533
8714	35	2026-02-27	2026-02-27 09:38:19.304806	2026-02-27 17:12:54.245084	present	2026-03-02 15:43:44.318533
8715	37	2026-02-27	2026-02-27 09:04:57.903056	2026-02-27 17:07:42.423119	present	2026-03-02 15:43:44.318533
8716	43	2026-02-27	2026-02-27 09:29:25.686343	2026-02-27 17:37:09.084657	present	2026-03-02 15:43:44.318533
8717	45	2026-02-27	2026-02-27 09:25:36.293803	2026-02-27 17:33:59.663958	present	2026-03-02 15:43:44.318533
8718	46	2026-02-27	2026-02-27 09:07:09.065441	2026-02-27 17:24:37.538604	present	2026-03-02 15:43:44.318533
8719	47	2026-02-27	2026-02-27 09:17:32.342884	2026-02-27 17:59:23.226409	present	2026-03-02 15:43:44.318533
8720	48	2026-02-27	2026-02-27 09:21:29.465612	2026-02-27 17:53:52.567996	present	2026-03-02 15:43:44.318533
8721	50	2026-02-27	2026-02-27 09:37:20.741231	2026-02-27 17:08:09.589299	present	2026-03-02 15:43:44.318533
8722	52	2026-02-27	2026-02-27 09:13:18.602869	2026-02-27 17:07:21.151628	present	2026-03-02 15:43:44.318533
8723	59	2026-02-27	2026-02-27 09:53:07.218214	2026-02-27 17:48:17.984915	present	2026-03-02 15:43:44.318533
8724	60	2026-02-27	2026-02-27 09:17:45.812664	2026-02-27 17:10:02.574824	present	2026-03-02 15:43:44.318533
8725	62	2026-02-27	2026-02-27 09:25:38.267837	2026-02-27 17:36:43.913596	present	2026-03-02 15:43:44.318533
8726	63	2026-02-27	2026-02-27 09:35:20.868972	2026-02-27 17:30:42.551325	present	2026-03-02 15:43:44.318533
8727	64	2026-02-27	2026-02-27 09:25:16.941517	2026-02-27 17:30:51.271337	present	2026-03-02 15:43:44.318533
8728	65	2026-02-27	2026-02-27 09:09:48.808971	2026-02-27 17:02:11.073144	present	2026-03-02 15:43:44.318533
8729	66	2026-02-27	2026-02-27 09:50:53.536657	2026-02-27 17:07:24.416608	present	2026-03-02 15:43:44.318533
8730	70	2026-02-27	2026-02-27 09:30:35.432822	2026-02-27 17:01:27.589086	present	2026-03-02 15:43:44.318533
8731	71	2026-02-27	2026-02-27 09:28:21.071676	2026-02-27 17:47:12.781673	present	2026-03-02 15:43:44.318533
8732	73	2026-02-27	2026-02-27 09:12:50.91649	2026-02-27 17:02:07.022837	present	2026-03-02 15:43:44.318533
8733	74	2026-02-27	2026-02-27 09:20:04.476413	2026-02-27 17:09:40.045061	present	2026-03-02 15:43:44.318533
8734	78	2026-02-27	2026-02-27 09:56:00.648067	2026-02-27 17:37:37.232169	present	2026-03-02 15:43:44.318533
8735	79	2026-02-27	2026-02-27 09:37:15.630506	2026-02-27 17:35:47.076662	present	2026-03-02 15:43:44.318533
8736	82	2026-02-27	2026-02-27 09:40:59.115616	2026-02-27 17:40:23.421949	present	2026-03-02 15:43:44.318533
8737	83	2026-02-27	2026-02-27 09:35:44.074652	2026-02-27 17:36:34.701022	present	2026-03-02 15:43:44.318533
8738	84	2026-02-27	2026-02-27 09:57:49.109724	2026-02-27 17:29:46.944415	present	2026-03-02 15:43:44.318533
8739	85	2026-02-27	2026-02-27 09:00:08.933395	2026-02-27 17:11:38.435893	present	2026-03-02 15:43:44.318533
8740	88	2026-02-27	2026-02-27 09:35:53.782283	2026-02-27 17:59:18.315422	present	2026-03-02 15:43:44.318533
8741	89	2026-02-27	2026-02-27 09:06:41.299524	2026-02-27 17:47:08.047611	present	2026-03-02 15:43:44.318533
8742	96	2026-02-27	2026-02-27 09:14:25.83635	2026-02-27 17:10:16.754673	present	2026-03-02 15:43:44.318533
8743	97	2026-02-27	2026-02-27 09:37:36.191981	2026-02-27 17:10:23.545433	present	2026-03-02 15:43:44.318533
8744	1	2026-02-27	2026-02-27 09:26:49.815505	2026-02-27 17:37:04.452716	present	2026-03-02 15:43:44.318533
8745	2	2026-02-27	2026-02-27 09:59:18.891557	2026-02-27 17:34:11.170728	present	2026-03-02 15:43:44.318533
8746	7	2026-02-27	2026-02-27 09:57:06.386012	2026-02-27 17:15:49.580379	present	2026-03-02 15:43:44.318533
8747	8	2026-02-27	2026-02-27 09:01:55.330746	2026-02-27 17:39:19.81232	present	2026-03-02 15:43:44.318533
8748	9	2026-02-27	2026-02-27 09:05:20.636063	2026-02-27 17:36:44.004915	present	2026-03-02 15:43:44.318533
8749	12	2026-02-27	2026-02-27 09:14:51.107601	2026-02-27 17:39:13.220102	present	2026-03-02 15:43:44.318533
8750	13	2026-02-27	2026-02-27 09:32:07.139138	2026-02-27 17:10:31.855763	present	2026-03-02 15:43:44.318533
8751	14	2026-02-27	2026-02-27 09:16:58.693357	2026-02-27 17:23:38.922226	present	2026-03-02 15:43:44.318533
8752	15	2026-02-27	2026-02-27 09:23:08.761269	2026-02-27 17:08:12.186212	present	2026-03-02 15:43:44.318533
8753	16	2026-02-27	2026-02-27 09:40:41.366891	2026-02-27 17:49:14.531261	present	2026-03-02 15:43:44.318533
8754	17	2026-02-27	2026-02-27 09:58:26.572525	2026-02-27 17:58:55.27859	present	2026-03-02 15:43:44.318533
8755	18	2026-02-27	2026-02-27 09:13:24.278184	2026-02-27 17:46:28.708954	present	2026-03-02 15:43:44.318533
8756	19	2026-02-27	2026-02-27 09:47:22.848693	2026-02-27 17:12:40.961583	present	2026-03-02 15:43:44.318533
8757	20	2026-02-27	2026-02-27 09:42:25.660374	2026-02-27 17:18:23.738406	present	2026-03-02 15:43:44.318533
8758	21	2026-02-27	2026-02-27 09:16:51.876181	2026-02-27 17:52:01.170484	present	2026-03-02 15:43:44.318533
8759	22	2026-02-27	2026-02-27 09:48:11.616089	2026-02-27 17:24:56.513628	present	2026-03-02 15:43:44.318533
8760	23	2026-02-27	2026-02-27 09:54:58.803118	2026-02-27 17:20:24.783304	present	2026-03-02 15:43:44.318533
8761	24	2026-02-27	2026-02-27 09:57:21.95895	2026-02-27 17:21:15.770867	present	2026-03-02 15:43:44.318533
8762	25	2026-02-27	2026-02-27 09:42:12.808762	2026-02-27 17:35:36.554611	present	2026-03-02 15:43:44.318533
8763	26	2026-02-27	2026-02-27 09:37:15.38795	2026-02-27 17:23:03.956261	present	2026-03-02 15:43:44.318533
8764	28	2026-02-27	2026-02-27 09:59:46.935327	2026-02-27 17:43:49.970436	present	2026-03-02 15:43:44.318533
8765	29	2026-02-27	2026-02-27 09:45:31.530325	2026-02-27 17:10:13.739791	present	2026-03-02 15:43:44.318533
8766	30	2026-02-27	2026-02-27 09:37:53.245044	2026-02-27 17:15:49.492842	present	2026-03-02 15:43:44.318533
8767	31	2026-02-27	2026-02-27 09:27:07.219328	2026-02-27 17:40:07.802851	present	2026-03-02 15:43:44.318533
8768	32	2026-02-27	2026-02-27 09:42:54.758018	2026-02-27 17:59:36.426882	present	2026-03-02 15:43:44.318533
8769	34	2026-02-27	2026-02-27 09:37:49.714441	2026-02-27 17:13:22.737636	present	2026-03-02 15:43:44.318533
8770	36	2026-02-27	2026-02-27 09:33:48.337183	2026-02-27 17:52:41.693374	present	2026-03-02 15:43:44.318533
8771	38	2026-02-27	2026-02-27 09:06:51.367025	2026-02-27 17:34:21.566492	present	2026-03-02 15:43:44.318533
8772	39	2026-02-27	2026-02-27 09:20:59.443559	2026-02-27 17:50:22.297952	present	2026-03-02 15:43:44.318533
8773	40	2026-02-27	2026-02-27 09:21:41.440629	2026-02-27 17:55:13.869233	present	2026-03-02 15:43:44.318533
8774	41	2026-02-27	2026-02-27 09:51:09.654836	2026-02-27 17:54:58.966794	present	2026-03-02 15:43:44.318533
8775	42	2026-02-27	2026-02-27 09:50:54.35372	2026-02-27 17:32:19.435326	present	2026-03-02 15:43:44.318533
8776	44	2026-02-27	2026-02-27 09:47:45.515955	2026-02-27 17:35:47.174659	present	2026-03-02 15:43:44.318533
8777	49	2026-02-27	2026-02-27 09:23:05.221299	2026-02-27 17:14:11.400495	present	2026-03-02 15:43:44.318533
8778	51	2026-02-27	2026-02-27 09:42:30.082022	2026-02-27 17:34:07.718462	present	2026-03-02 15:43:44.318533
8779	53	2026-02-27	2026-02-27 09:48:11.308141	2026-02-27 17:12:15.819606	present	2026-03-02 15:43:44.318533
8780	54	2026-02-27	2026-02-27 09:26:41.907444	2026-02-27 17:15:01.131945	present	2026-03-02 15:43:44.318533
8781	55	2026-02-27	2026-02-27 09:13:58.713504	2026-02-27 17:16:59.210156	present	2026-03-02 15:43:44.318533
8782	56	2026-02-27	2026-02-27 09:52:34.516783	2026-02-27 17:13:35.517645	present	2026-03-02 15:43:44.318533
8783	57	2026-02-27	2026-02-27 09:49:00.620449	2026-02-27 17:47:00.888242	present	2026-03-02 15:43:44.318533
8784	58	2026-02-27	2026-02-27 09:21:21.999292	2026-02-27 17:14:10.975402	present	2026-03-02 15:43:44.318533
8785	61	2026-02-27	2026-02-27 09:33:51.029453	2026-02-27 17:07:29.31509	present	2026-03-02 15:43:44.318533
8786	67	2026-02-27	2026-02-27 09:18:59.195637	2026-02-27 17:42:58.889666	present	2026-03-02 15:43:44.318533
8787	68	2026-02-27	2026-02-27 09:37:42.738296	2026-02-27 17:23:05.013773	present	2026-03-02 15:43:44.318533
8788	69	2026-02-27	2026-02-27 09:26:30.77782	2026-02-27 17:42:53.43161	present	2026-03-02 15:43:44.318533
8789	72	2026-02-27	2026-02-27 09:57:20.687671	2026-02-27 17:44:04.842618	present	2026-03-02 15:43:44.318533
8790	75	2026-02-27	2026-02-27 09:43:52.34598	2026-02-27 17:38:56.468775	present	2026-03-02 15:43:44.318533
8791	76	2026-02-27	2026-02-27 09:55:08.465	2026-02-27 17:04:36.055482	present	2026-03-02 15:43:44.318533
8792	77	2026-02-27	2026-02-27 09:30:29.030631	2026-02-27 17:30:09.793086	present	2026-03-02 15:43:44.318533
8793	80	2026-02-27	2026-02-27 09:44:37.714446	2026-02-27 17:26:24.900378	present	2026-03-02 15:43:44.318533
8794	81	2026-02-27	2026-02-27 09:45:19.00292	2026-02-27 17:38:08.739055	present	2026-03-02 15:43:44.318533
8795	86	2026-02-27	2026-02-27 09:58:01.243423	2026-02-27 17:51:43.810318	present	2026-03-02 15:43:44.318533
8796	87	2026-02-27	2026-02-27 09:36:47.822405	2026-02-27 17:13:35.680916	present	2026-03-02 15:43:44.318533
8797	90	2026-02-27	2026-02-27 09:50:26.659051	2026-02-27 17:24:08.104631	present	2026-03-02 15:43:44.318533
8798	91	2026-02-27	2026-02-27 09:20:29.895854	2026-02-27 17:25:17.106674	present	2026-03-02 15:43:44.318533
8799	92	2026-02-27	2026-02-27 09:34:12.576972	2026-02-27 17:38:53.616423	present	2026-03-02 15:43:44.318533
8800	93	2026-02-27	2026-02-27 09:41:39.608004	2026-02-27 17:15:36.777343	present	2026-03-02 15:43:44.318533
8801	94	2026-02-27	2026-02-27 09:25:40.235936	2026-02-27 17:03:55.809935	present	2026-03-02 15:43:44.318533
8802	95	2026-02-27	2026-02-27 09:01:19.182046	2026-02-27 17:45:22.857974	present	2026-03-02 15:43:44.318533
8803	98	2026-02-27	2026-02-27 09:21:19.081017	2026-02-27 17:41:55.746311	present	2026-03-02 15:43:44.318533
8804	99	2026-02-27	2026-02-27 09:12:42.873607	2026-02-27 17:06:00.673809	present	2026-03-02 15:43:44.318533
8805	100	2026-02-27	2026-02-27 09:34:28.316041	2026-02-27 17:18:00.671579	present	2026-03-02 15:43:44.318533
8806	3	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8807	4	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8808	5	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8809	6	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8810	10	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8811	11	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8812	27	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8813	33	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8814	35	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8815	37	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8816	43	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8817	45	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8818	46	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8819	47	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8820	48	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8821	50	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8822	52	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8823	59	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8824	60	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8825	62	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8826	63	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8827	64	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8828	65	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8829	66	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8830	70	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8831	71	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8832	73	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8833	74	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8834	78	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8835	79	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8836	82	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8837	83	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8838	84	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8839	85	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8840	88	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8841	89	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8842	96	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8844	1	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8845	2	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8846	7	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8847	8	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8848	9	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8849	12	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8850	13	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8851	14	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8852	15	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8853	16	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8854	17	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8855	18	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8856	19	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8857	20	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8858	21	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8859	22	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8860	23	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8861	24	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8862	25	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8863	26	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8864	28	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8865	29	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8866	30	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8867	31	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8868	32	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8869	34	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8870	36	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8871	38	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8872	39	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8873	40	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8874	41	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8875	42	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8876	44	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8877	49	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8878	51	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8879	53	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8880	54	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8881	55	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8882	56	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8883	57	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8884	58	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8885	61	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8886	67	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8887	68	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8888	69	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8889	72	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8890	75	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8891	76	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8892	77	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8893	80	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8894	81	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8895	86	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8896	87	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8897	90	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8898	91	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8899	92	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8900	93	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8901	94	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8902	95	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8903	98	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8904	99	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8905	100	2026-02-28	\N	\N	absent	2026-03-02 15:43:44.318533
8906	3	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8907	4	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8908	5	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8909	6	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8910	10	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8911	11	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8912	27	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8913	33	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8914	35	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8915	37	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8916	43	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8917	45	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8918	46	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8919	47	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8920	48	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8921	50	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8922	52	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8923	59	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8924	60	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8925	62	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8926	63	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8927	64	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8928	65	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8929	66	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8930	70	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8931	71	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8932	73	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8933	74	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8934	78	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8935	79	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8936	82	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8937	83	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8938	84	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8939	85	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8940	88	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8941	89	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8942	96	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8943	97	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8944	1	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8945	2	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8946	7	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8947	8	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8948	9	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8949	12	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8950	13	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8951	14	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8952	15	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8953	16	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8954	17	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8955	18	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8956	19	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8957	20	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8958	21	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8959	22	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8960	23	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8961	24	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8962	25	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8963	26	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8964	28	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8965	29	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8966	30	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8967	31	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8968	32	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8969	34	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8970	36	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8971	38	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8972	39	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8973	40	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8974	41	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8975	42	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8976	44	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8977	49	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8978	51	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8979	53	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8980	54	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8981	55	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8982	56	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8983	57	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8984	58	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8985	61	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8986	67	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8987	68	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8988	69	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8989	72	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8990	75	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8991	76	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8992	77	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8993	80	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8994	81	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8995	86	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8996	87	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8997	90	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8998	91	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
8999	92	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
9000	93	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
9001	94	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
9002	95	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
9003	98	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
9004	99	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
9005	100	2026-03-01	\N	\N	absent	2026-03-02 15:43:44.318533
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.departments (department_id, department_name, created_at, is_active) FROM stdin;
1	Human Resources	2026-03-02 15:37:35.589886	t
2	Engineering	2026-03-02 15:37:35.589886	t
3	Sales	2026-03-02 15:37:35.589886	t
4	Finance	2026-03-02 15:37:35.589886	t
5	Operations	2026-03-02 15:37:35.589886	t
6	Marketing	2026-03-02 15:37:35.589886	t
\.


--
-- Data for Name: employee_projects; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.employee_projects (assignment_id, employee_id, project_id, project_role, assigned_date, created_at) FROM stdin;
1	4	4	lead	2026-01-21	2026-03-03 11:36:19.544861
2	6	9	backend	2026-01-12	2026-03-03 11:36:19.544861
3	10	8	fullstack	2026-03-02	2026-03-03 11:36:19.544861
4	11	8	backend	2025-11-08	2026-03-03 11:36:19.544861
5	35	2	lead	2025-11-13	2026-03-03 11:36:19.544861
6	37	3	backend	2025-12-12	2026-03-03 11:36:19.544861
7	37	4	lead	2026-01-06	2026-03-03 11:36:19.544861
8	43	11	backend	2026-03-02	2026-03-03 11:36:19.544861
9	43	12	lead	2025-12-04	2026-03-03 11:36:19.544861
10	45	2	backend	2026-02-20	2026-03-03 11:36:19.544861
11	47	12	frontend	2026-02-05	2026-03-03 11:36:19.544861
12	48	3	lead	2026-02-14	2026-03-03 11:36:19.544861
13	48	4	fullstack	2025-12-15	2026-03-03 11:36:19.544861
14	50	9	fullstack	2026-01-11	2026-03-03 11:36:19.544861
15	59	7	lead	2026-01-22	2026-03-03 11:36:19.544861
16	59	8	backend	2025-11-28	2026-03-03 11:36:19.544861
17	62	5	tester	2026-01-31	2026-03-03 11:36:19.544861
18	64	9	fullstack	2026-02-08	2026-03-03 11:36:19.544861
19	65	3	frontend	2026-02-07	2026-03-03 11:36:19.544861
20	66	5	lead	2026-01-17	2026-03-03 11:36:19.544861
21	70	6	lead	2026-02-16	2026-03-03 11:36:19.544861
22	70	5	frontend	2025-12-22	2026-03-03 11:36:19.544861
23	71	1	tester	2026-02-06	2026-03-03 11:36:19.544861
24	73	7	lead	2026-01-22	2026-03-03 11:36:19.544861
25	74	6	lead	2026-01-06	2026-03-03 11:36:19.544861
26	78	2	lead	2026-02-08	2026-03-03 11:36:19.544861
27	79	3	fullstack	2025-11-30	2026-03-03 11:36:19.544861
28	82	12	frontend	2025-12-21	2026-03-03 11:36:19.544861
29	83	5	fullstack	2025-12-12	2026-03-03 11:36:19.544861
30	88	1	backend	2025-12-07	2026-03-03 11:36:19.544861
31	88	2	backend	2025-11-30	2026-03-03 11:36:19.544861
32	96	4	backend	2026-01-24	2026-03-03 11:36:19.544861
33	97	2	tester	2025-11-21	2026-03-03 11:36:19.544861
34	1	1	frontend	2026-01-30	2026-03-03 11:36:19.544861
35	7	5	backend	2025-12-01	2026-03-03 11:36:19.544861
36	9	7	fullstack	2025-11-09	2026-03-03 11:36:19.544861
37	9	8	frontend	2026-01-11	2026-03-03 11:36:19.544861
38	12	3	tester	2026-02-16	2026-03-03 11:36:19.544861
39	13	6	backend	2025-12-14	2026-03-03 11:36:19.544861
40	15	11	backend	2026-01-01	2026-03-03 11:36:19.544861
41	15	12	backend	2026-02-20	2026-03-03 11:36:19.544861
42	16	1	frontend	2026-02-07	2026-03-03 11:36:19.544861
43	16	2	tester	2026-01-08	2026-03-03 11:36:19.544861
44	18	7	backend	2026-01-14	2026-03-03 11:36:19.544861
45	19	9	frontend	2026-02-25	2026-03-03 11:36:19.544861
46	19	10	fullstack	2026-02-07	2026-03-03 11:36:19.544861
47	20	4	fullstack	2025-11-23	2026-03-03 11:36:19.544861
48	25	10	fullstack	2025-11-12	2026-03-03 11:36:19.544861
49	28	12	fullstack	2026-02-27	2026-03-03 11:36:19.544861
50	29	6	lead	2025-11-21	2026-03-03 11:36:19.544861
51	29	5	lead	2026-01-09	2026-03-03 11:36:19.544861
52	31	7	frontend	2025-12-24	2026-03-03 11:36:19.544861
53	39	10	backend	2025-11-26	2026-03-03 11:36:19.544861
54	42	4	fullstack	2025-11-09	2026-03-03 11:36:19.544861
55	49	11	backend	2025-12-09	2026-03-03 11:36:19.544861
56	51	10	backend	2026-02-09	2026-03-03 11:36:19.544861
57	53	8	fullstack	2025-12-06	2026-03-03 11:36:19.544861
58	54	9	fullstack	2025-12-31	2026-03-03 11:36:19.544861
59	55	6	backend	2025-12-23	2026-03-03 11:36:19.544861
60	58	1	fullstack	2025-12-31	2026-03-03 11:36:19.544861
61	67	2	tester	2026-02-27	2026-03-03 11:36:19.544861
62	68	12	backend	2026-01-31	2026-03-03 11:36:19.544861
63	69	9	frontend	2025-11-18	2026-03-03 11:36:19.544861
64	69	10	fullstack	2026-02-02	2026-03-03 11:36:19.544861
65	72	5	backend	2026-02-06	2026-03-03 11:36:19.544861
66	75	3	fullstack	2025-12-12	2026-03-03 11:36:19.544861
67	76	9	fullstack	2026-02-09	2026-03-03 11:36:19.544861
68	77	8	frontend	2025-11-07	2026-03-03 11:36:19.544861
69	80	2	backend	2026-01-02	2026-03-03 11:36:19.544861
70	81	3	fullstack	2025-11-30	2026-03-03 11:36:19.544861
71	81	4	lead	2025-12-01	2026-03-03 11:36:19.544861
72	87	6	fullstack	2026-02-24	2026-03-03 11:36:19.544861
73	90	8	fullstack	2025-11-12	2026-03-03 11:36:19.544861
74	92	3	tester	2025-12-09	2026-03-03 11:36:19.544861
75	92	4	tester	2026-01-05	2026-03-03 11:36:19.544861
76	94	10	frontend	2025-12-19	2026-03-03 11:36:19.544861
77	99	10	frontend	2026-02-03	2026-03-03 11:36:19.544861
78	100	9	tester	2025-12-26	2026-03-03 11:36:19.544861
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.employees (employee_id, employee_name, role, salary, date_of_join, department_id, manager_id, created_at, is_active) FROM stdin;
3	James Wilson	manager	91853.21	2025-11-05	6	\N	2026-03-02 15:37:49.844416	t
4	Sarah Brown	manager	41865.83	2025-04-13	2	\N	2026-03-02 15:37:49.844416	t
5	Olivia Miller	manager	31188.18	2025-09-21	1	\N	2026-03-02 15:37:49.844416	t
6	David Miller	manager	74589.74	2022-06-24	5	\N	2026-03-02 15:37:49.844416	t
10	Olivia Taylor	manager	81307.08	2025-02-01	4	\N	2026-03-02 15:37:49.844416	t
11	Linda Brown	admin	84565.31	2025-04-02	4	\N	2026-03-02 15:37:49.844416	t
27	James Johnson	admin	95392.08	2022-02-24	2	\N	2026-03-02 15:37:49.844416	t
33	Sarah Miller	manager	73229.08	2022-02-10	3	\N	2026-03-02 15:37:49.844416	t
35	Robert Brown	admin	96119.14	2025-06-04	1	\N	2026-03-02 15:37:49.844416	t
37	James Jones	manager	53205.29	2023-08-18	2	\N	2026-03-02 15:37:49.844416	t
43	David Williams	manager	71537.21	2026-01-18	6	\N	2026-03-02 15:37:49.844416	t
45	David Garcia	admin	90229.84	2022-04-05	1	\N	2026-03-02 15:37:49.844416	t
46	Robert Taylor	manager	34220.81	2023-10-24	6	\N	2026-03-02 15:37:49.844416	t
47	Emma Smith	manager	45791.54	2025-02-20	6	\N	2026-03-02 15:37:49.844416	t
48	Daniel Williams	manager	40122.75	2022-12-26	2	\N	2026-03-02 15:37:49.844416	t
50	Linda Johnson	manager	81304.24	2024-11-12	5	\N	2026-03-02 15:37:49.844416	t
52	David Wilson	manager	57085.83	2023-05-26	5	\N	2026-03-02 15:37:49.844416	t
59	Robert Taylor	manager	49046.40	2025-12-09	4	\N	2026-03-02 15:37:49.844416	t
60	Robert Johnson	manager	57409.49	2024-01-20	4	\N	2026-03-02 15:37:49.844416	t
62	Sarah Brown	manager	67364.13	2024-12-12	3	\N	2026-03-02 15:37:49.844416	t
63	John Taylor	manager	81233.36	2023-09-27	5	\N	2026-03-02 15:37:49.844416	t
64	David Smith	manager	86163.17	2024-06-02	5	\N	2026-03-02 15:37:49.844416	t
65	David Jones	admin	31086.73	2024-08-23	2	\N	2026-03-02 15:37:49.844416	t
66	Emma Smith	manager	43411.20	2022-07-27	3	\N	2026-03-02 15:37:49.844416	t
70	Robert Williams	admin	86136.49	2023-07-25	3	\N	2026-03-02 15:37:49.844416	t
71	Olivia Brown	manager	37649.44	2025-10-26	1	\N	2026-03-02 15:37:49.844416	t
73	Robert Davis	admin	61341.24	2023-07-04	4	\N	2026-03-02 15:37:49.844416	t
74	John Taylor	manager	87398.29	2024-07-11	3	\N	2026-03-02 15:37:49.844416	t
78	Sarah Johnson	admin	92164.34	2025-12-13	1	\N	2026-03-02 15:37:49.844416	t
79	John Wilson	admin	40097.90	2023-12-31	2	\N	2026-03-02 15:37:49.844416	t
82	Linda Jones	manager	47241.70	2025-12-27	6	\N	2026-03-02 15:37:49.844416	t
83	Robert Garcia	admin	45389.53	2024-01-25	3	\N	2026-03-02 15:37:49.844416	t
84	Michael Williams	manager	33320.49	2022-03-15	5	\N	2026-03-02 15:37:49.844416	t
85	Michael Davis	manager	79465.34	2023-10-04	2	\N	2026-03-02 15:37:49.844416	t
88	Linda Davis	manager	75868.71	2023-03-24	1	\N	2026-03-02 15:37:49.844416	t
89	Michael Johnson	admin	65027.76	2025-03-22	6	\N	2026-03-02 15:37:49.844416	t
96	Robert Miller	admin	87916.74	2024-03-30	2	\N	2026-03-02 15:37:49.844416	t
97	Olivia Taylor	admin	44329.22	2025-04-13	1	\N	2026-03-02 15:37:49.844416	t
1	Daniel Johnson	employee	70949.07	2025-10-06	1	84	2026-03-02 15:37:49.844416	t
2	Emma Miller	employee	53449.41	2024-11-01	2	84	2026-03-02 15:37:49.844416	t
7	Michael Jones	employee	66732.64	2025-06-09	3	84	2026-03-02 15:37:49.844416	t
8	Michael Jones	employee	88620.08	2025-07-01	3	84	2026-03-02 15:37:49.844416	t
9	Olivia Brown	employee	33690.72	2025-05-21	4	84	2026-03-02 15:37:49.844416	t
12	David Williams	employee	39982.96	2024-08-19	2	84	2026-03-02 15:37:49.844416	t
13	Emma Jones	employee	46434.16	2024-02-13	3	84	2026-03-02 15:37:49.844416	t
14	Linda Taylor	employee	64511.22	2025-04-10	4	84	2026-03-02 15:37:49.844416	t
15	David Davis	employee	43629.57	2023-02-05	6	84	2026-03-02 15:37:49.844416	t
16	Robert Smith	employee	67886.02	2024-05-12	1	84	2026-03-02 15:37:49.844416	t
17	John Jones	employee	91403.88	2022-09-15	6	84	2026-03-02 15:37:49.844416	t
18	Daniel Davis	employee	97913.36	2023-08-12	4	84	2026-03-02 15:37:49.844416	t
19	Robert Smith	employee	37987.24	2023-02-19	5	84	2026-03-02 15:37:49.844416	t
20	James Brown	employee	56648.00	2022-08-18	2	84	2026-03-02 15:37:49.844416	t
21	Linda Taylor	employee	85616.80	2025-05-18	1	84	2026-03-02 15:37:49.844416	t
22	John Johnson	employee	49631.74	2023-12-07	3	84	2026-03-02 15:37:49.844416	t
23	James Garcia	employee	55381.55	2024-01-02	3	84	2026-03-02 15:37:49.844416	t
24	Robert Garcia	employee	81230.31	2025-03-06	1	84	2026-03-02 15:37:49.844416	t
25	Linda Williams	employee	59923.52	2025-04-04	5	84	2026-03-02 15:37:49.844416	t
26	Robert Williams	employee	36352.33	2025-07-06	2	84	2026-03-02 15:37:49.844416	t
28	Linda Wilson	employee	53503.45	2025-05-31	6	84	2026-03-02 15:37:49.844416	t
29	Olivia Miller	employee	31059.34	2022-02-09	3	84	2026-03-02 15:37:49.844416	t
30	Robert Johnson	employee	49819.60	2024-05-14	4	84	2026-03-02 15:37:49.844416	t
31	Michael Johnson	employee	56449.16	2023-10-24	4	84	2026-03-02 15:37:49.844416	t
32	Olivia Garcia	employee	60386.64	2025-08-18	3	84	2026-03-02 15:37:49.844416	t
34	David Miller	employee	86724.84	2025-03-18	3	84	2026-03-02 15:37:49.844416	t
36	James Taylor	employee	46949.04	2024-11-23	2	84	2026-03-02 15:37:49.844416	t
38	Michael Miller	employee	49409.57	2022-04-17	1	84	2026-03-02 15:37:49.844416	t
39	Olivia Williams	employee	38484.18	2022-02-25	5	84	2026-03-02 15:37:49.844416	t
40	Olivia Jones	employee	40483.98	2023-02-26	1	84	2026-03-02 15:37:49.844416	t
41	Robert Jones	employee	46600.04	2025-01-19	2	84	2026-03-02 15:37:49.844416	t
42	Robert Garcia	employee	66726.39	2023-05-27	2	84	2026-03-02 15:37:49.844416	t
44	James Jones	employee	52663.97	2023-09-23	2	84	2026-03-02 15:37:49.844416	t
49	Linda Miller	employee	96371.32	2023-03-09	6	84	2026-03-02 15:37:49.844416	t
51	Linda Brown	employee	90304.33	2022-08-10	5	84	2026-03-02 15:37:49.844416	t
53	David Williams	employee	86266.47	2024-01-11	4	84	2026-03-02 15:37:49.844416	t
54	Robert Williams	employee	74027.91	2026-02-24	5	84	2026-03-02 15:37:49.844416	t
55	Sarah Johnson	employee	79250.40	2023-11-21	3	84	2026-03-02 15:37:49.844416	t
56	Michael Wilson	employee	66401.89	2024-12-25	6	84	2026-03-02 15:37:49.844416	t
57	Olivia Brown	employee	34274.17	2024-09-19	2	84	2026-03-02 15:37:49.844416	t
58	Emma Jones	employee	44373.26	2023-12-17	1	84	2026-03-02 15:37:49.844416	t
61	Daniel Wilson	employee	72395.75	2025-11-25	2	84	2026-03-02 15:37:49.844416	t
67	James Jones	employee	61368.69	2025-07-04	1	84	2026-03-02 15:37:49.844416	t
68	James Davis	employee	99396.64	2022-03-13	6	84	2026-03-02 15:37:49.844416	t
69	Sarah Wilson	employee	75156.23	2024-05-20	5	84	2026-03-02 15:37:49.844416	t
72	Robert Smith	employee	99868.08	2025-02-04	3	84	2026-03-02 15:37:49.844416	t
75	James Miller	employee	30442.08	2022-08-26	2	84	2026-03-02 15:37:49.844416	t
76	Daniel Miller	employee	53344.28	2023-12-15	5	84	2026-03-02 15:37:49.844416	t
77	Sarah Miller	employee	46843.77	2025-07-15	4	84	2026-03-02 15:37:49.844416	t
80	Robert Garcia	employee	58359.01	2024-07-30	1	84	2026-03-02 15:37:49.844416	t
81	David Johnson	employee	38906.11	2025-05-10	2	84	2026-03-02 15:37:49.844416	t
86	David Davis	employee	45591.25	2023-08-22	4	84	2026-03-02 15:37:49.844416	t
87	Emma Johnson	employee	82672.67	2022-09-01	3	84	2026-03-02 15:37:49.844416	t
90	Daniel Johnson	employee	84611.71	2022-06-17	4	84	2026-03-02 15:37:49.844416	t
91	Linda Jones	employee	38900.47	2026-01-30	1	84	2026-03-02 15:37:49.844416	t
92	Michael Wilson	employee	74897.56	2024-05-18	2	84	2026-03-02 15:37:49.844416	t
93	Michael Taylor	employee	52573.26	2024-01-19	2	84	2026-03-02 15:37:49.844416	t
94	Daniel Wilson	employee	58462.16	2023-05-30	5	84	2026-03-02 15:37:49.844416	t
95	James Taylor	employee	81265.48	2022-10-10	2	84	2026-03-02 15:37:49.844416	t
98	Linda Johnson	employee	41620.58	2024-02-26	4	84	2026-03-02 15:37:49.844416	t
99	Sarah Brown	employee	55661.56	2022-07-26	5	84	2026-03-02 15:37:49.844416	t
100	Michael Miller	employee	67348.35	2025-04-17	5	84	2026-03-02 15:37:49.844416	t
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.projects (project_id, project_name, department_id, project_budget, start_date, end_date, created_at, is_active) FROM stdin;
1	Employee Wellness Program	1	50000.00	2024-01-01	2024-06-30	2026-03-03 11:36:03.618353	t
2	Recruitment Automation	1	75000.00	2024-03-01	\N	2026-03-03 11:36:03.618353	t
3	ERP System Upgrade	2	250000.00	2023-07-01	\N	2026-03-03 11:36:03.618353	t
4	Mobile App Revamp	2	180000.00	2024-02-01	\N	2026-03-03 11:36:03.618353	t
5	Market Expansion Q1	3	120000.00	2024-01-15	2024-04-30	2026-03-03 11:36:03.618353	t
6	CRM Optimization	3	90000.00	2024-03-01	\N	2026-03-03 11:36:03.618353	t
7	Annual Audit 2024	4	60000.00	2024-01-01	2024-03-31	2026-03-03 11:36:03.618353	t
8	Budget Forecasting Tool	4	110000.00	2024-02-15	\N	2026-03-03 11:36:03.618353	t
9	Supply Chain Optimization	5	200000.00	2023-09-01	\N	2026-03-03 11:36:03.618353	t
10	Warehouse Automation	5	150000.00	2024-01-10	\N	2026-03-03 11:36:03.618353	t
11	Brand Refresh Campaign	6	95000.00	2024-01-01	2024-05-31	2026-03-03 11:36:03.618353	t
12	Digital Growth Strategy	6	130000.00	2024-03-01	\N	2026-03-03 11:36:03.618353	t
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.categories (id, name) FROM stdin;
1	Electronics
2	Clothing
3	Home
4	Sports
5	Books
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.inventory (id, product_id, stock, warehouse_location, last_updated) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.order_items (id, order_id, product_id, quantity, price) FROM stdin;
1	1	1	1	80000.00
2	1	3	2	1200.00
3	2	2	1	4500.00
4	3	7	3	500.00
5	4	5	1	90000.00
6	5	6	2	900.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.orders (id, user_id, order_date, status) FROM stdin;
1	1	2023-06-01 00:00:00	completed
2	2	2023-06-03 00:00:00	completed
3	3	2023-06-04 00:00:00	cancelled
4	1	2023-06-10 00:00:00	completed
5	4	2023-06-12 00:00:00	shipped
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.payments (id, order_id, payment_method, payment_date, amount, status) FROM stdin;
1	1	UPI	2023-06-01 00:00:00	82400.00	paid
2	2	Credit Card	2023-06-03 00:00:00	4500.00	paid
3	4	UPI	2023-06-10 00:00:00	90000.00	paid
4	5	Debit Card	2023-06-12 00:00:00	1800.00	pending
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.products (id, name, category_id, price, created_at) FROM stdin;
1	iPhone 14	1	80000.00	2023-01-01 00:00:00
2	Running Shoes	4	4500.00	2023-02-10 00:00:00
3	T-Shirt	2	1200.00	2023-03-12 00:00:00
4	Microwave Oven	3	15000.00	2023-02-20 00:00:00
5	Laptop	1	90000.00	2023-04-05 00:00:00
6	Football	4	900.00	2023-01-15 00:00:00
7	Novel Book	5	500.00	2023-03-22 00:00:00
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.reviews (id, user_id, product_id, rating, comment, review_date) FROM stdin;
1	1	1	5	Excellent phone	2023-06-06 00:00:00
2	2	2	4	Good shoes	2023-06-10 00:00:00
3	3	7	3	Average book	2023-06-11 00:00:00
4	4	5	5	Amazing laptop	2023-06-15 00:00:00
\.


--
-- Data for Name: shipments; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.shipments (id, order_id, shipped_date, delivery_date, carrier, tracking_number) FROM stdin;
1	1	2023-06-02 00:00:00	2023-06-05 00:00:00	BlueDart	TRK123
2	2	2023-06-04 00:00:00	2023-06-07 00:00:00	Delhivery	TRK124
3	4	2023-06-11 00:00:00	2023-06-14 00:00:00	DTDC	TRK125
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: ecommerce; Owner: postgres
--

COPY ecommerce.users (id, name, email, city, signup_date) FROM stdin;
1	Amit Sharma	amit@email.com	Mumbai	2023-01-10
2	Neha Gupta	neha@email.com	Delhi	2023-02-12
3	Rahul Verma	rahul@email.com	Pune	2023-03-05
4	Priya Singh	priya@email.com	Bangalore	2023-04-01
5	Karan Mehta	karan@email.com	Mumbai	2023-05-15
\.


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.attendance_attendance_id_seq', 9005, true);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.departments_department_id_seq', 6, true);


--
-- Name: employee_projects_assignment_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.employee_projects_assignment_id_seq', 78, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.employees_employee_id_seq', 100, true);


--
-- Name: projects_project_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.projects_project_id_seq', 12, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.categories_id_seq', 5, true);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.inventory_id_seq', 1, false);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.order_items_id_seq', 6, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.orders_id_seq', 5, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.payments_id_seq', 4, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.products_id_seq', 7, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.reviews_id_seq', 4, true);


--
-- Name: shipments_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.shipments_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: ecommerce; Owner: postgres
--

SELECT pg_catalog.setval('ecommerce.users_id_seq', 5, true);


--
-- Name: aircraft aircraft_pkey; Type: CONSTRAINT; Schema: airline; Owner: postgres
--

ALTER TABLE ONLY airline.aircraft
    ADD CONSTRAINT aircraft_pkey PRIMARY KEY (aid);


--
-- Name: certified certified_pkey; Type: CONSTRAINT; Schema: airline; Owner: postgres
--

ALTER TABLE ONLY airline.certified
    ADD CONSTRAINT certified_pkey PRIMARY KEY (eid, aid);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: airline; Owner: postgres
--

ALTER TABLE ONLY airline.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (eid);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: airline; Owner: postgres
--

ALTER TABLE ONLY airline.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flno);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: employee_projects employee_projects_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employee_projects
    ADD CONSTRAINT employee_projects_pkey PRIMARY KEY (assignment_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- Name: attendance uq_employee_date; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attendance
    ADD CONSTRAINT uq_employee_date UNIQUE (employee_id, attendance_date);


--
-- Name: employee_projects uq_employee_project; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employee_projects
    ADD CONSTRAINT uq_employee_project UNIQUE (employee_id, project_id);


--
-- Name: projects uq_project_per_department; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT uq_project_per_department UNIQUE (project_name, department_id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: certified certified_aid_fkey; Type: FK CONSTRAINT; Schema: airline; Owner: postgres
--

ALTER TABLE ONLY airline.certified
    ADD CONSTRAINT certified_aid_fkey FOREIGN KEY (aid) REFERENCES airline.aircraft(aid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: certified certified_eid_fkey; Type: FK CONSTRAINT; Schema: airline; Owner: postgres
--

ALTER TABLE ONLY airline.certified
    ADD CONSTRAINT certified_eid_fkey FOREIGN KEY (eid) REFERENCES airline.employees(eid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance fk_attendance_employee; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attendance
    ADD CONSTRAINT fk_attendance_employee FOREIGN KEY (employee_id) REFERENCES core.employees(employee_id) ON DELETE CASCADE;


--
-- Name: employees fk_employees_department_id; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employees
    ADD CONSTRAINT fk_employees_department_id FOREIGN KEY (department_id) REFERENCES core.departments(department_id);


--
-- Name: employees fk_employees_manager; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employees
    ADD CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES core.employees(employee_id);


--
-- Name: employee_projects fk_ep_employee; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employee_projects
    ADD CONSTRAINT fk_ep_employee FOREIGN KEY (employee_id) REFERENCES core.employees(employee_id) ON DELETE CASCADE;


--
-- Name: employee_projects fk_ep_project; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.employee_projects
    ADD CONSTRAINT fk_ep_project FOREIGN KEY (project_id) REFERENCES core.projects(project_id) ON DELETE CASCADE;


--
-- Name: projects fk_projects_departments; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.projects
    ADD CONSTRAINT fk_projects_departments FOREIGN KEY (department_id) REFERENCES core.departments(department_id) ON DELETE RESTRICT;


--
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES ecommerce.products(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES ecommerce.orders(id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES ecommerce.products(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES ecommerce.users(id);


--
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES ecommerce.orders(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES ecommerce.categories(id);


--
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES ecommerce.products(id);


--
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES ecommerce.users(id);


--
-- Name: shipments shipments_order_id_fkey; Type: FK CONSTRAINT; Schema: ecommerce; Owner: postgres
--

ALTER TABLE ONLY ecommerce.shipments
    ADD CONSTRAINT shipments_order_id_fkey FOREIGN KEY (order_id) REFERENCES ecommerce.orders(id);


--
-- PostgreSQL database dump complete
--

\unrestrict WzQlqmjTxSNj50rbxMRYN6jxNQbzggL03fbDmPYGazvYuHn0tVpbYGk4jGFX2Yh

