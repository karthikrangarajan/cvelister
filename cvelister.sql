--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: affected_software; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE affected_software (
    id integer NOT NULL,
    cve_id integer,
    cpe_id integer
);


--
-- Name: affected_software_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE affected_software_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: affected_software_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE affected_software_id_seq OWNED BY affected_software.id;


--
-- Name: cpe_list; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cpe_list (
    id integer NOT NULL,
    cpe_id text,
    cpe_name text
);


--
-- Name: cpe_list_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cpe_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cpe_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cpe_list_id_seq OWNED BY cpe_list.id;


--
-- Name: cve_list; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cve_list (
    id integer NOT NULL,
    cve_id character varying(20),
    summary text,
    cvss_score numeric
);


--
-- Name: cve_list_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cve_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cve_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cve_list_id_seq OWNED BY cve_list.id;


--
-- Name: cve_references; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cve_references (
    id integer NOT NULL,
    cve_id integer,
    reference_source text,
    reference_link text
);


--
-- Name: cve_references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cve_references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cve_references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cve_references_id_seq OWNED BY cve_references.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY affected_software ALTER COLUMN id SET DEFAULT nextval('affected_software_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cpe_list ALTER COLUMN id SET DEFAULT nextval('cpe_list_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cve_list ALTER COLUMN id SET DEFAULT nextval('cve_list_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cve_references ALTER COLUMN id SET DEFAULT nextval('cve_references_id_seq'::regclass);


--
-- Name: affected_software_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY affected_software
    ADD CONSTRAINT affected_software_pkey PRIMARY KEY (id);


--
-- Name: cpe_list_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cpe_list
    ADD CONSTRAINT cpe_list_pkey PRIMARY KEY (id);


--
-- Name: cve_list_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cve_list
    ADD CONSTRAINT cve_list_pkey PRIMARY KEY (id);


--
-- Name: cve_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cve_references
    ADD CONSTRAINT cve_references_pkey PRIMARY KEY (id);


--
-- Name: cve_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cve_list
    ADD CONSTRAINT cve_unique UNIQUE (cve_id);


--
-- Name: cpe_list_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cpe_list_index ON cpe_list USING btree (cpe_name);


--
-- Name: cpe_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY affected_software
    ADD CONSTRAINT cpe_foreign_key FOREIGN KEY (cpe_id) REFERENCES cpe_list(id);


--
-- Name: cve_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY affected_software
    ADD CONSTRAINT cve_foreign_key FOREIGN KEY (cve_id) REFERENCES cve_list(id);


--
-- Name: reference_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cve_references
    ADD CONSTRAINT reference_foreign_key FOREIGN KEY (cve_id) REFERENCES cve_list(id);


--
-- PostgreSQL database dump complete
--

