toc.dat                                                                                             0000600 0004000 0002000 00000037373 14634431135 0014460 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP                       |            dbmag    16.2    16.2 .    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                     0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                    1262    32816    dbmag    DATABASE     {   CREATE DATABASE dbmag WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';
    DROP DATABASE dbmag;
                postgres    false         �            1255    98415    cliente_trigger()    FUNCTION     �  CREATE FUNCTION public.cliente_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        RAISE NOTICE 'Se ha insertado un nuevo cliente. Detalles: %', NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        RAISE NOTICE 'Se ha actualizado un cliente. Detalles del nuevo registro: %, Detalles del antiguo registro: %', NEW, OLD;
    ELSIF TG_OP = 'DELETE' THEN
        RAISE NOTICE 'Se ha eliminado un cliente. Detalles: %', OLD;
    END IF;
    RETURN NULL;
END;
$$;
 (   DROP FUNCTION public.cliente_trigger();
       public          postgres    false         �            1255    81976 h   insertar_usuario_condicional(character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.insertar_usuario_condicional(nombre_param character varying, correo_param character varying, usuario_param character varying, contrasena_param character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    id_usuario INTEGER;
BEGIN
    -- Verificar restricciones de longitud para nombre y correo
    IF (char_length(nombre_param) >= 3 AND
        char_length(correo_param) >= 5 AND
        char_length(usuario_param) >= 3 AND
        char_length(contrasena_param) >= 3) THEN
        -- Iniciar transacción
        BEGIN
            -- Insertar el registro
            INSERT INTO usuarios (nombre, correo, usuario, contrasena) VALUES (nombre_param, correo_param, usuario_param, contrasena_param) RETURNING id INTO id_usuario;
            -- Confirmar la transacción
            COMMIT;
            -- Devolver verdadero indicando éxito
            RETURN TRUE;
        EXCEPTION WHEN others THEN
            -- Revertir la transacción si ocurre un error
            ROLLBACK;
            -- Devolver falso indicando fallo
            RETURN FALSE;
        END;
    ELSE
        -- Devolver falso si las restricciones no se cumplen
        RETURN FALSE;
    END IF;
END;
$$;
 �   DROP FUNCTION public.insertar_usuario_condicional(nombre_param character varying, correo_param character varying, usuario_param character varying, contrasena_param character varying);
       public          postgres    false         �            1259    123047    clientes    TABLE     �  CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(50),
    apellidos character varying(50),
    cedula character varying(20),
    nit character varying(15),
    email character varying(100),
    telefono character varying(15),
    direccion character varying(100),
    estado character varying(10),
    CONSTRAINT ck_estado CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying])::text[]))),
    CONSTRAINT nn_apellidos CHECK ((apellidos IS NOT NULL)),
    CONSTRAINT nn_cedula CHECK ((cedula IS NOT NULL)),
    CONSTRAINT nn_direccion CHECK ((direccion IS NOT NULL)),
    CONSTRAINT nn_email CHECK ((email IS NOT NULL)),
    CONSTRAINT nn_estado CHECK ((estado IS NOT NULL)),
    CONSTRAINT nn_nit CHECK ((nit IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL)),
    CONSTRAINT nn_telefono CHECK ((telefono IS NOT NULL))
);
    DROP TABLE public.clientes;
       public         heap    postgres    false         �            1259    123046    clientes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.clientes_id_seq;
       public          postgres    false    220                    0    0    clientes_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;
          public          postgres    false    219         �            1259    123068    profesionales    TABLE     g  CREATE TABLE public.profesionales (
    id integer NOT NULL,
    nombre character varying(50),
    apellidos character varying(50),
    especializacion character varying(50),
    email character varying(100),
    telefono character varying(15),
    direccion character varying(100),
    estado character varying(10),
    CONSTRAINT ck_estado CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying])::text[]))),
    CONSTRAINT nn_apellidos CHECK ((apellidos IS NOT NULL)),
    CONSTRAINT nn_direccion CHECK ((direccion IS NOT NULL)),
    CONSTRAINT nn_email CHECK ((email IS NOT NULL)),
    CONSTRAINT nn_especializacion CHECK ((especializacion IS NOT NULL)),
    CONSTRAINT nn_estado CHECK ((estado IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL)),
    CONSTRAINT nn_telefono CHECK ((telefono IS NOT NULL))
);
 !   DROP TABLE public.profesionales;
       public         heap    postgres    false         �            1259    123067    profesionales_id_seq    SEQUENCE     �   CREATE SEQUENCE public.profesionales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.profesionales_id_seq;
       public          postgres    false    222                    0    0    profesionales_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.profesionales_id_seq OWNED BY public.profesionales.id;
          public          postgres    false    221         �            1259    131073 	   servicios    TABLE     �   CREATE TABLE public.servicios (
    id integer NOT NULL,
    nombre character varying(100),
    descripcion character varying(200),
    CONSTRAINT nn_descripcion CHECK ((descripcion IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL))
);
    DROP TABLE public.servicios;
       public         heap    postgres    false         �            1259    131072    servicios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.servicios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.servicios_id_seq;
       public          postgres    false    224                    0    0    servicios_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.servicios_id_seq OWNED BY public.servicios.id;
          public          postgres    false    223         �            1259    123021    tareas    TABLE     �   CREATE TABLE public.tareas (
    id integer NOT NULL,
    nombre_tarea character varying(255) NOT NULL,
    fecha_tarea date NOT NULL
);
    DROP TABLE public.tareas;
       public         heap    postgres    false         �            1259    123020    tareas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tareas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tareas_id_seq;
       public          postgres    false    216                    0    0    tareas_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.tareas_id_seq OWNED BY public.tareas.id;
          public          postgres    false    215         �            1259    123029    usuarios    TABLE     �  CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(50),
    correo character varying(50),
    usuario character varying(20),
    contrasena character varying(20),
    CONSTRAINT ck_contrasena CHECK ((char_length((contrasena)::text) >= 3)),
    CONSTRAINT ck_correo CHECK ((char_length((correo)::text) >= 5)),
    CONSTRAINT ck_nombre CHECK ((char_length((nombre)::text) >= 3)),
    CONSTRAINT ck_usuario CHECK ((char_length((usuario)::text) >= 3)),
    CONSTRAINT nn_contrasena CHECK ((contrasena IS NOT NULL)),
    CONSTRAINT nn_correo CHECK ((correo IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL))
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false         �            1259    123028    usuarios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.usuarios_id_seq;
       public          postgres    false    218                    0    0    usuarios_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;
          public          postgres    false    217         2           2604    123050    clientes id    DEFAULT     j   ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);
 :   ALTER TABLE public.clientes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219    220         3           2604    123071    profesionales id    DEFAULT     t   ALTER TABLE ONLY public.profesionales ALTER COLUMN id SET DEFAULT nextval('public.profesionales_id_seq'::regclass);
 ?   ALTER TABLE public.profesionales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221    222         4           2604    131076    servicios id    DEFAULT     l   ALTER TABLE ONLY public.servicios ALTER COLUMN id SET DEFAULT nextval('public.servicios_id_seq'::regclass);
 ;   ALTER TABLE public.servicios ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223    224         0           2604    123024 	   tareas id    DEFAULT     f   ALTER TABLE ONLY public.tareas ALTER COLUMN id SET DEFAULT nextval('public.tareas_id_seq'::regclass);
 8   ALTER TABLE public.tareas ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216         1           2604    123032    usuarios id    DEFAULT     j   ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);
 :   ALTER TABLE public.usuarios ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    218    218         �          0    123047    clientes 
   TABLE DATA           j   COPY public.clientes (id, nombre, apellidos, cedula, nit, email, telefono, direccion, estado) FROM stdin;
    public          postgres    false    220       4855.dat �          0    123068    profesionales 
   TABLE DATA           s   COPY public.profesionales (id, nombre, apellidos, especializacion, email, telefono, direccion, estado) FROM stdin;
    public          postgres    false    222       4857.dat �          0    131073 	   servicios 
   TABLE DATA           <   COPY public.servicios (id, nombre, descripcion) FROM stdin;
    public          postgres    false    224       4859.dat �          0    123021    tareas 
   TABLE DATA           ?   COPY public.tareas (id, nombre_tarea, fecha_tarea) FROM stdin;
    public          postgres    false    216       4851.dat �          0    123029    usuarios 
   TABLE DATA           K   COPY public.usuarios (id, nombre, correo, usuario, contrasena) FROM stdin;
    public          postgres    false    218       4853.dat            0    0    clientes_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.clientes_id_seq', 1, true);
          public          postgres    false    219                    0    0    profesionales_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.profesionales_id_seq', 2, true);
          public          postgres    false    221         	           0    0    servicios_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.servicios_id_seq', 2, true);
          public          postgres    false    223         
           0    0    tareas_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.tareas_id_seq', 1, false);
          public          postgres    false    215                    0    0    usuarios_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.usuarios_id_seq', 1, true);
          public          postgres    false    217         X           2606    123061    clientes pk_cli_id 
   CONSTRAINT     P   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT pk_cli_id PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.clientes DROP CONSTRAINT pk_cli_id;
       public            postgres    false    220         R           2606    123041    usuarios pk_id 
   CONSTRAINT     L   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_id PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT pk_id;
       public            postgres    false    218         ^           2606    123081    profesionales pk_profe_id 
   CONSTRAINT     W   ALTER TABLE ONLY public.profesionales
    ADD CONSTRAINT pk_profe_id PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.profesionales DROP CONSTRAINT pk_profe_id;
       public            postgres    false    222         b           2606    131080    servicios pk_servi_id 
   CONSTRAINT     S   ALTER TABLE ONLY public.servicios
    ADD CONSTRAINT pk_servi_id PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.servicios DROP CONSTRAINT pk_servi_id;
       public            postgres    false    224         P           2606    123026    tareas tareas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.tareas DROP CONSTRAINT tareas_pkey;
       public            postgres    false    216         Z           2606    123063    clientes uc_cedula 
   CONSTRAINT     O   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT uc_cedula UNIQUE (cedula);
 <   ALTER TABLE ONLY public.clientes DROP CONSTRAINT uc_cedula;
       public            postgres    false    220         T           2606    123043    usuarios uc_correo 
   CONSTRAINT     O   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT uc_correo UNIQUE (correo);
 <   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT uc_correo;
       public            postgres    false    218         `           2606    123083    profesionales uc_email 
   CONSTRAINT     R   ALTER TABLE ONLY public.profesionales
    ADD CONSTRAINT uc_email UNIQUE (email);
 @   ALTER TABLE ONLY public.profesionales DROP CONSTRAINT uc_email;
       public            postgres    false    222         \           2606    123065    clientes uc_nit 
   CONSTRAINT     I   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT uc_nit UNIQUE (nit);
 9   ALTER TABLE ONLY public.clientes DROP CONSTRAINT uc_nit;
       public            postgres    false    220         V           2606    123045    usuarios uc_usuario 
   CONSTRAINT     Q   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT uc_usuario UNIQUE (usuario);
 =   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT uc_usuario;
       public            postgres    false    218                                                                                                                                                                                                                                                                             4855.dat                                                                                            0000600 0004000 0002000 00000000130 14634431135 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Laura	Martinez	1005678925	17882824	lauran@gmail.com	3278453124	Carrera 19	activo
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                        4857.dat                                                                                            0000600 0004000 0002000 00000000231 14634431135 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Laura	Martinez	Contadora	laura@gmail.com	23456756	Carrera 15	activo
2	Julian	Hernandéz	Contadoror	julianh@gmail.com	3091735257	Carrera 14	activo
\.


                                                                                                                                                                                                                                                                                                                                                                       4859.dat                                                                                            0000600 0004000 0002000 00000000101 14634431135 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Contables	Facturación electrónica
2	Tributario	Impuesto
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                               4851.dat                                                                                            0000600 0004000 0002000 00000000005 14634431135 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4853.dat                                                                                            0000600 0004000 0002000 00000000102 14634431135 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Mag Asesorías Consultorías SAS	mag@gmail.com	MAG	Mag1234
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                              restore.sql                                                                                         0000600 0004000 0002000 00000033163 14634431135 0015376 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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

DROP DATABASE dbmag;
--
-- Name: dbmag; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE dbmag WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Colombia.1252';


ALTER DATABASE dbmag OWNER TO postgres;

\connect dbmag

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
-- Name: cliente_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cliente_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        RAISE NOTICE 'Se ha insertado un nuevo cliente. Detalles: %', NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        RAISE NOTICE 'Se ha actualizado un cliente. Detalles del nuevo registro: %, Detalles del antiguo registro: %', NEW, OLD;
    ELSIF TG_OP = 'DELETE' THEN
        RAISE NOTICE 'Se ha eliminado un cliente. Detalles: %', OLD;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.cliente_trigger() OWNER TO postgres;

--
-- Name: insertar_usuario_condicional(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_usuario_condicional(nombre_param character varying, correo_param character varying, usuario_param character varying, contrasena_param character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    id_usuario INTEGER;
BEGIN
    -- Verificar restricciones de longitud para nombre y correo
    IF (char_length(nombre_param) >= 3 AND
        char_length(correo_param) >= 5 AND
        char_length(usuario_param) >= 3 AND
        char_length(contrasena_param) >= 3) THEN
        -- Iniciar transacción
        BEGIN
            -- Insertar el registro
            INSERT INTO usuarios (nombre, correo, usuario, contrasena) VALUES (nombre_param, correo_param, usuario_param, contrasena_param) RETURNING id INTO id_usuario;
            -- Confirmar la transacción
            COMMIT;
            -- Devolver verdadero indicando éxito
            RETURN TRUE;
        EXCEPTION WHEN others THEN
            -- Revertir la transacción si ocurre un error
            ROLLBACK;
            -- Devolver falso indicando fallo
            RETURN FALSE;
        END;
    ELSE
        -- Devolver falso si las restricciones no se cumplen
        RETURN FALSE;
    END IF;
END;
$$;


ALTER FUNCTION public.insertar_usuario_condicional(nombre_param character varying, correo_param character varying, usuario_param character varying, contrasena_param character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(50),
    apellidos character varying(50),
    cedula character varying(20),
    nit character varying(15),
    email character varying(100),
    telefono character varying(15),
    direccion character varying(100),
    estado character varying(10),
    CONSTRAINT ck_estado CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying])::text[]))),
    CONSTRAINT nn_apellidos CHECK ((apellidos IS NOT NULL)),
    CONSTRAINT nn_cedula CHECK ((cedula IS NOT NULL)),
    CONSTRAINT nn_direccion CHECK ((direccion IS NOT NULL)),
    CONSTRAINT nn_email CHECK ((email IS NOT NULL)),
    CONSTRAINT nn_estado CHECK ((estado IS NOT NULL)),
    CONSTRAINT nn_nit CHECK ((nit IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL)),
    CONSTRAINT nn_telefono CHECK ((telefono IS NOT NULL))
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: profesionales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profesionales (
    id integer NOT NULL,
    nombre character varying(50),
    apellidos character varying(50),
    especializacion character varying(50),
    email character varying(100),
    telefono character varying(15),
    direccion character varying(100),
    estado character varying(10),
    CONSTRAINT ck_estado CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying])::text[]))),
    CONSTRAINT nn_apellidos CHECK ((apellidos IS NOT NULL)),
    CONSTRAINT nn_direccion CHECK ((direccion IS NOT NULL)),
    CONSTRAINT nn_email CHECK ((email IS NOT NULL)),
    CONSTRAINT nn_especializacion CHECK ((especializacion IS NOT NULL)),
    CONSTRAINT nn_estado CHECK ((estado IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL)),
    CONSTRAINT nn_telefono CHECK ((telefono IS NOT NULL))
);


ALTER TABLE public.profesionales OWNER TO postgres;

--
-- Name: profesionales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profesionales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profesionales_id_seq OWNER TO postgres;

--
-- Name: profesionales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profesionales_id_seq OWNED BY public.profesionales.id;


--
-- Name: servicios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicios (
    id integer NOT NULL,
    nombre character varying(100),
    descripcion character varying(200),
    CONSTRAINT nn_descripcion CHECK ((descripcion IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL))
);


ALTER TABLE public.servicios OWNER TO postgres;

--
-- Name: servicios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicios_id_seq OWNER TO postgres;

--
-- Name: servicios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servicios_id_seq OWNED BY public.servicios.id;


--
-- Name: tareas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tareas (
    id integer NOT NULL,
    nombre_tarea character varying(255) NOT NULL,
    fecha_tarea date NOT NULL
);


ALTER TABLE public.tareas OWNER TO postgres;

--
-- Name: tareas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tareas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tareas_id_seq OWNER TO postgres;

--
-- Name: tareas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tareas_id_seq OWNED BY public.tareas.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(50),
    correo character varying(50),
    usuario character varying(20),
    contrasena character varying(20),
    CONSTRAINT ck_contrasena CHECK ((char_length((contrasena)::text) >= 3)),
    CONSTRAINT ck_correo CHECK ((char_length((correo)::text) >= 5)),
    CONSTRAINT ck_nombre CHECK ((char_length((nombre)::text) >= 3)),
    CONSTRAINT ck_usuario CHECK ((char_length((usuario)::text) >= 3)),
    CONSTRAINT nn_contrasena CHECK ((contrasena IS NOT NULL)),
    CONSTRAINT nn_correo CHECK ((correo IS NOT NULL)),
    CONSTRAINT nn_nombre CHECK ((nombre IS NOT NULL))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: profesionales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profesionales ALTER COLUMN id SET DEFAULT nextval('public.profesionales_id_seq'::regclass);


--
-- Name: servicios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicios ALTER COLUMN id SET DEFAULT nextval('public.servicios_id_seq'::regclass);


--
-- Name: tareas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas ALTER COLUMN id SET DEFAULT nextval('public.tareas_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nombre, apellidos, cedula, nit, email, telefono, direccion, estado) FROM stdin;
\.
COPY public.clientes (id, nombre, apellidos, cedula, nit, email, telefono, direccion, estado) FROM '$$PATH$$/4855.dat';

--
-- Data for Name: profesionales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profesionales (id, nombre, apellidos, especializacion, email, telefono, direccion, estado) FROM stdin;
\.
COPY public.profesionales (id, nombre, apellidos, especializacion, email, telefono, direccion, estado) FROM '$$PATH$$/4857.dat';

--
-- Data for Name: servicios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicios (id, nombre, descripcion) FROM stdin;
\.
COPY public.servicios (id, nombre, descripcion) FROM '$$PATH$$/4859.dat';

--
-- Data for Name: tareas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tareas (id, nombre_tarea, fecha_tarea) FROM stdin;
\.
COPY public.tareas (id, nombre_tarea, fecha_tarea) FROM '$$PATH$$/4851.dat';

--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, correo, usuario, contrasena) FROM stdin;
\.
COPY public.usuarios (id, nombre, correo, usuario, contrasena) FROM '$$PATH$$/4853.dat';

--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 1, true);


--
-- Name: profesionales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profesionales_id_seq', 2, true);


--
-- Name: servicios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicios_id_seq', 2, true);


--
-- Name: tareas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tareas_id_seq', 1, false);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, true);


--
-- Name: clientes pk_cli_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT pk_cli_id PRIMARY KEY (id);


--
-- Name: usuarios pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_id PRIMARY KEY (id);


--
-- Name: profesionales pk_profe_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profesionales
    ADD CONSTRAINT pk_profe_id PRIMARY KEY (id);


--
-- Name: servicios pk_servi_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicios
    ADD CONSTRAINT pk_servi_id PRIMARY KEY (id);


--
-- Name: tareas tareas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_pkey PRIMARY KEY (id);


--
-- Name: clientes uc_cedula; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT uc_cedula UNIQUE (cedula);


--
-- Name: usuarios uc_correo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT uc_correo UNIQUE (correo);


--
-- Name: profesionales uc_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profesionales
    ADD CONSTRAINT uc_email UNIQUE (email);


--
-- Name: clientes uc_nit; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT uc_nit UNIQUE (nit);


--
-- Name: usuarios uc_usuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT uc_usuario UNIQUE (usuario);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             