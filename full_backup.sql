--
-- PostgreSQL database dump
--

\restrict OAyocukWtg5JkyVrI7HuYZNWE5xSlYLgfAtMkea5v1MkUrCeAyghZcNmhaNJ7D7

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    bio text,
    image_url character varying(255),
    twitter_url character varying(255),
    instagram_url character varying(255),
    facebook_url character varying(255),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artists_id_seq OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: band_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.band_members (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    role character varying(100),
    bio text,
    image_url character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.band_members OWNER TO postgres;

--
-- Name: band_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.band_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.band_members_id_seq OWNER TO postgres;

--
-- Name: band_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.band_members_id_seq OWNED BY public.band_members.id;


--
-- Name: songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    artist_id integer,
    genre character varying(100),
    video_url character varying(255),
    duration_seconds integer NOT NULL,
    play_count integer DEFAULT 0,
    download_count integer DEFAULT 0,
    like_count integer DEFAULT 0,
    artwork_url character varying(255) NOT NULL,
    audio_url character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.songs OWNER TO postgres;

--
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.songs_id_seq OWNER TO postgres;

--
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_id_seq OWNED BY public.songs.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submissions (
    id integer NOT NULL,
    form_type character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    details jsonb,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.submissions OWNER TO postgres;

--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.submissions_id_seq OWNER TO postgres;

--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_admin boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.videos (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    youtube_url text,
    video_url character varying(255),
    duration_seconds integer DEFAULT 0,
    view_count integer DEFAULT 0,
    featured_on_band_page boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.videos OWNER TO postgres;

--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.videos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.videos_id_seq OWNER TO postgres;

--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: band_members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band_members ALTER COLUMN id SET DEFAULT nextval('public.band_members_id_seq'::regclass);


--
-- Name: songs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs ALTER COLUMN id SET DEFAULT nextval('public.songs_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists (id, name, bio, image_url, twitter_url, instagram_url, facebook_url, created_at) FROM stdin;
1	22Ligther		/uploads/1768930228875-istockphoto-1332100919-612x612.jpg				2025-08-23 21:40:08.239337+03
\.


--
-- Data for Name: band_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.band_members (id, name, role, bio, image_url, created_at) FROM stdin;
5	Mufasa	rummer		/uploads/1768929953349-istockphoto-1332100919-612x612.jpg	2026-01-20 20:25:53.479471+03
6	Simba	Singer		/uploads/1768930016810-monkey-d-luffy-red-3840x2160-24473.png	2026-01-20 20:26:57.038003+03
7	Panda	Dragon Warrior		/uploads/1768930070007-photo_2025-08-12_14-12-54.jpg	2026-01-20 20:27:50.123452+03
8	Ninja	Guard		/uploads/1768930125517-sasuke-uchiha-dark-3840x2160-19881.jpg	2026-01-20 20:28:45.633962+03
9	Steph	Nothing		/uploads/1768930202697-istockphoto-1332100919-612x612.jpg	2026-01-20 20:30:03.016774+03
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs (id, title, artist_id, genre, video_url, duration_seconds, play_count, download_count, like_count, artwork_url, audio_url, created_at) FROM stdin;
3	Trial Song	1			245	0	0	0	/uploads/1768930620345-lion-crown-dark-7680x4320-13129.jpg	/uploads/1768930620389-Feffe_Bussi_Ft_Winnie_Nwagi,_Spice_Diana,_Dax_Vibez,_Kapeke_-_Nzalina.mp3	2026-01-20 20:37:00.664454+03
\.


--
-- Data for Name: submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.submissions (id, form_type, name, email, details, is_read, created_at) FROM stdin;
1	Band Booking	Wamala	wamala@gmail.com	{"eventDate": "2025-08-24", "eventType": "Birthday"}	t	2025-08-23 22:10:53.985071+03
3	Contact Inquiry	Iankwagala	ian@gmail.com	{"phone": "234567899", "message": "trial", "serviceType": "Audio Production"}	t	2026-01-20 20:44:30.993103+03
2	Band Booking	MUFASA	ian@gmail.com	{"eventDate": "2026-01-29", "eventType": "Sex party"}	t	2026-01-20 20:41:22.685302+03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, is_admin, created_at) FROM stdin;
1	Admin	admin@tingina.com	$2b$10$c1w4LVNMZG2oOLi9cQRVI.za2fNodnIPq7Wj6pFsGnk69ZcySfPuK	t	2025-08-23 21:39:25.020076+03
2	Ian	ian@gmail.com	$2b$10$mJsMFLJNIrAWGirnC51mdOXom5uEte.axhRxBnhh3o8q/yGf630y6	f	2026-01-20 20:37:56.540408+03
\.


--
-- Data for Name: videos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.videos (id, title, youtube_url, video_url, duration_seconds, view_count, featured_on_band_page, created_at) FROM stdin;
\.


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artists_id_seq', 3, true);


--
-- Name: band_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.band_members_id_seq', 9, true);


--
-- Name: songs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_id_seq', 3, true);


--
-- Name: submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.submissions_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.videos_id_seq', 1, false);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: band_members band_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band_members
    ADD CONSTRAINT band_members_pkey PRIMARY KEY (id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: songs songs_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict OAyocukWtg5JkyVrI7HuYZNWE5xSlYLgfAtMkea5v1MkUrCeAyghZcNmhaNJ7D7

