--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: lnk_composite1; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lnk_composite1 (
    lnkidbasic numeric(18,0) NOT NULL,
    lnkidcomposite character varying(200) NOT NULL
);


ALTER TABLE public.lnk_composite1 OWNER TO postgres;

--
-- Name: lnk_manytomany2uuid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lnk_manytomany2uuid (
    lnkidmanytomany character varying(200) NOT NULL,
    lnkidbasic character varying(200) NOT NULL
);


ALTER TABLE public.lnk_manytomany2uuid OWNER TO postgres;

--
-- Name: lnk_manytomanyuuid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lnk_manytomanyuuid (
    lnkidmanytomany character varying(200) DEFAULT ''::character varying NOT NULL,
    lnkidbasic character varying(200) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.lnk_manytomanyuuid OWNER TO postgres;

--
-- Name: tbl_a; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_a (
    a_id character varying(200) NOT NULL,
    lnkid character varying(200),
    lnkid2 character varying(200),
    a_value character varying(200)
);


ALTER TABLE public.tbl_a OWNER TO postgres;

--
-- Name: tbl_ap; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_ap (
    ap_id character varying(200) NOT NULL,
    a_id character varying(200),
    stringvalue character varying(200)
);


ALTER TABLE public.tbl_ap OWNER TO postgres;

--
-- Name: tbl_b; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_b (
    b_id character varying(200) NOT NULL,
    lnkid character varying(200),
    lnkid2 character varying(200),
    b_value character varying(200)
);


ALTER TABLE public.tbl_b OWNER TO postgres;

--
-- Name: tbl_basic; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_basic (
    idbasic numeric DEFAULT (0)::numeric NOT NULL,
    basic_date timestamp without time zone,
    basic_numeric numeric DEFAULT (0)::numeric,
    basic_string character varying(200) DEFAULT ''::character varying,
    basic_uuid character varying(200) DEFAULT ''::character varying,
    basic_boolean boolean DEFAULT false,
    basic_decimal double precision
);


ALTER TABLE public.tbl_basic OWNER TO postgres;

--
-- Name: tbl_basicguid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_basicguid (
    idbasic character varying(200) DEFAULT ''::character varying NOT NULL,
    basic_date timestamp without time zone NOT NULL,
    basic_numeric numeric DEFAULT (0)::numeric NOT NULL,
    basic_string character varying(200) DEFAULT ''::character varying NOT NULL,
    basic_uuid character varying(200)
);


ALTER TABLE public.tbl_basicguid OWNER TO postgres;

--
-- Name: tbl_basicuuid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_basicuuid (
    idbasic character varying(200) DEFAULT ''::character varying NOT NULL,
    basic_date timestamp without time zone NOT NULL,
    basic_numeric numeric DEFAULT (0)::numeric,
    basic_string character varying(200) DEFAULT 'gandalf'::character varying NOT NULL,
    basic_uuid character varying(200) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tbl_basicuuid OWNER TO postgres;

--
-- Name: tbl_bigstuff; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_bigstuff (
    bigstuffid character varying(36) NOT NULL,
    bigstuff_clob text,
    bigstuff_blob bytea
);


ALTER TABLE public.tbl_bigstuff OWNER TO postgres;

--
-- Name: tbl_c; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_c (
    c_id character varying(200) NOT NULL,
    lnkid character varying(200),
    lnkid2 character varying(200),
    c_value character varying(200)
);


ALTER TABLE public.tbl_c OWNER TO postgres;

--
-- Name: tbl_childmanytooneuuid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_childmanytooneuuid (
    idchild character varying(200) DEFAULT ''::character varying NOT NULL,
    manytoonechild_string character varying(200) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tbl_childmanytooneuuid OWNER TO postgres;

--
-- Name: tbl_composite; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_composite (
    idcomposite character varying(200) NOT NULL,
    composite_string character varying(200),
    lnkidbasic numeric(18,0)
);


ALTER TABLE public.tbl_composite OWNER TO postgres;

--
-- Name: tbl_d; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_d (
    d_id character varying(200) NOT NULL,
    lnkid character varying(200),
    lnkid2 character varying(200),
    d_value character varying(200)
);


ALTER TABLE public.tbl_d OWNER TO postgres;

--
-- Name: tbl_generate; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_generate (
    idgenerate numeric NOT NULL,
    generate_value character varying(50)
);


ALTER TABLE public.tbl_generate OWNER TO postgres;

--
-- Name: tbl_generate_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_generate_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_generate_seq OWNER TO postgres;

--
-- Name: tbl_manytomanyuuid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_manytomanyuuid (
    idsimple character varying(200) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tbl_manytomanyuuid OWNER TO postgres;

--
-- Name: tbl_manytooneuuid; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_manytooneuuid (
    idsimple character varying(200) DEFAULT ''::character varying NOT NULL,
    manytoone_string character varying(200) DEFAULT ''::character varying NOT NULL,
    lnkidchild character varying(200) DEFAULT ''::character varying
);


ALTER TABLE public.tbl_manytooneuuid OWNER TO postgres;

--
-- Name: tbl_none; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_none (
    idbasic numeric(18,0) NOT NULL,
    basic_string character varying(200)
);


ALTER TABLE public.tbl_none OWNER TO postgres;

--
-- Name: tbl_none_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_none_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_none_seq OWNER TO postgres;

--
-- Name: tbl_nonechild; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_nonechild (
    idchild numeric(18,0) NOT NULL,
    child_name character varying(200) NOT NULL,
    lnkbasicid numeric(18,0) NOT NULL
);


ALTER TABLE public.tbl_nonechild OWNER TO postgres;

--
-- Name: tbl_nonechild_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_nonechild_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_nonechild_seq OWNER TO postgres;

--
-- Name: tbl_onetomany; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_onetomany (
    idbasic numeric NOT NULL,
    basic_string character varying(50)
);


ALTER TABLE public.tbl_onetomany OWNER TO postgres;

--
-- Name: tbl_onetomany_seq2; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_onetomany_seq2
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_onetomany_seq2 OWNER TO postgres;

--
-- Name: tbl_onetomanychild; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_onetomanychild (
    idchild numeric NOT NULL,
    child_name character varying(50),
    lnkbasicid numeric(18,0) DEFAULT (0)::numeric
);


ALTER TABLE public.tbl_onetomanychild OWNER TO postgres;

--
-- Name: tbl_onetomanychild_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_onetomanychild_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_onetomanychild_seq OWNER TO postgres;

--
-- Name: tbl_propchild; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_propchild (
    idpropchild numeric NOT NULL,
    thing character varying(50) DEFAULT ''::character varying NOT NULL,
    lnkidpropparent numeric DEFAULT (0)::numeric NOT NULL
);


ALTER TABLE public.tbl_propchild OWNER TO postgres;

--
-- Name: tbl_propchild_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_propchild_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_propchild_seq OWNER TO postgres;

--
-- Name: tbl_propparent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_propparent (
    idpropparent numeric NOT NULL,
    name character varying(50),
    thing character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tbl_propparent OWNER TO postgres;

--
-- Name: tbl_propparent_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_propparent_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_propparent_seq OWNER TO postgres;

--
-- Name: tbl_transaction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_transaction (
    idtransaction numeric NOT NULL,
    string character varying(250) NOT NULL
);


ALTER TABLE public.tbl_transaction OWNER TO postgres;

--
-- Name: tbl_transaction_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_transaction_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_transaction_seq OWNER TO postgres;

--
-- Name: tbl_tree; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tbl_tree (
    idtree numeric(18,0) NOT NULL,
    tree_value character varying(200),
    lnkidtree numeric(18,0)
);


ALTER TABLE public.tbl_tree OWNER TO postgres;

--
-- Name: tbl_tree_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tbl_tree_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tbl_tree_seq OWNER TO postgres;

--
-- Name: transfer_sequence; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE transfer_sequence (
    sequence_name character varying(250) NOT NULL,
    sequence_value numeric(20,0) NOT NULL
);


ALTER TABLE public.transfer_sequence OWNER TO postgres;

--
-- Name: tbl_a_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_a
    ADD CONSTRAINT tbl_a_pkey PRIMARY KEY (a_id);


--
-- Name: tbl_ap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_ap
    ADD CONSTRAINT tbl_ap_pkey PRIMARY KEY (ap_id);


--
-- Name: tbl_b_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_b
    ADD CONSTRAINT tbl_b_pkey PRIMARY KEY (b_id);


--
-- Name: tbl_basic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_basic
    ADD CONSTRAINT tbl_basic_pkey PRIMARY KEY (idbasic);


--
-- Name: tbl_basicguid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_basicguid
    ADD CONSTRAINT tbl_basicguid_pkey PRIMARY KEY (idbasic);


--
-- Name: tbl_basicuuid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_basicuuid
    ADD CONSTRAINT tbl_basicuuid_pkey PRIMARY KEY (idbasic);


--
-- Name: tbl_bigstuff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_bigstuff
    ADD CONSTRAINT tbl_bigstuff_pkey PRIMARY KEY (bigstuffid);


--
-- Name: tbl_c_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_c
    ADD CONSTRAINT tbl_c_pkey PRIMARY KEY (c_id);


--
-- Name: tbl_childmanytooneuuid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_childmanytooneuuid
    ADD CONSTRAINT tbl_childmanytooneuuid_pkey PRIMARY KEY (idchild);


--
-- Name: tbl_composite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_composite
    ADD CONSTRAINT tbl_composite_pkey PRIMARY KEY (idcomposite);


--
-- Name: tbl_d_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_d
    ADD CONSTRAINT tbl_d_pkey PRIMARY KEY (d_id);


--
-- Name: tbl_generate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_generate
    ADD CONSTRAINT tbl_generate_pkey PRIMARY KEY (idgenerate);


--
-- Name: tbl_manytomanyuuid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_manytomanyuuid
    ADD CONSTRAINT tbl_manytomanyuuid_pkey PRIMARY KEY (idsimple);


--
-- Name: tbl_manytooneuuid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_manytooneuuid
    ADD CONSTRAINT tbl_manytooneuuid_pkey PRIMARY KEY (idsimple);


--
-- Name: tbl_none_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_none
    ADD CONSTRAINT tbl_none_pkey PRIMARY KEY (idbasic);


--
-- Name: tbl_nonechild_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_nonechild
    ADD CONSTRAINT tbl_nonechild_pkey PRIMARY KEY (idchild);


--
-- Name: tbl_onetomany_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_onetomany
    ADD CONSTRAINT tbl_onetomany_pkey PRIMARY KEY (idbasic);


--
-- Name: tbl_onetomanychild_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_onetomanychild
    ADD CONSTRAINT tbl_onetomanychild_pkey PRIMARY KEY (idchild);


--
-- Name: tbl_propchild_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_propchild
    ADD CONSTRAINT tbl_propchild_pkey PRIMARY KEY (idpropchild);


--
-- Name: tbl_propparent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_propparent
    ADD CONSTRAINT tbl_propparent_pkey PRIMARY KEY (idpropparent);


--
-- Name: tbl_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_transaction
    ADD CONSTRAINT tbl_transaction_pkey PRIMARY KEY (idtransaction);


--
-- Name: tbl_tree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tbl_tree
    ADD CONSTRAINT tbl_tree_pkey PRIMARY KEY (idtree);


--
-- Name: transfer_sequence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transfer_sequence
    ADD CONSTRAINT transfer_sequence_pkey PRIMARY KEY (sequence_name);


--
-- Name: fk_lnk_manytomanyuuid_tbl_basicuuid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lnk_manytomanyuuid
    ADD CONSTRAINT fk_lnk_manytomanyuuid_tbl_basicuuid FOREIGN KEY (lnkidbasic) REFERENCES tbl_basicuuid(idbasic);


--
-- Name: fk_lnk_manytomanyuuid_tbl_manytomanyuuid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lnk_manytomanyuuid
    ADD CONSTRAINT fk_lnk_manytomanyuuid_tbl_manytomanyuuid FOREIGN KEY (lnkidmanytomany) REFERENCES tbl_manytomanyuuid(idsimple);


--
-- Name: fk_tbl_manytooneuuid_tbl_childmanytooneuuid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_manytooneuuid
    ADD CONSTRAINT fk_tbl_manytooneuuid_tbl_childmanytooneuuid FOREIGN KEY (lnkidchild) REFERENCES tbl_childmanytooneuuid(idchild);


--
-- Name: lnk_composite1_lnkidbasic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lnk_composite1
    ADD CONSTRAINT lnk_composite1_lnkidbasic_fkey FOREIGN KEY (lnkidbasic) REFERENCES tbl_onetomany(idbasic);


--
-- Name: lnk_composite1_lnkidcomposite_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY lnk_composite1
    ADD CONSTRAINT lnk_composite1_lnkidcomposite_fkey FOREIGN KEY (lnkidcomposite) REFERENCES tbl_composite(idcomposite);


--
-- Name: tbl_composite_lnkidbasic_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_composite
    ADD CONSTRAINT tbl_composite_lnkidbasic_fkey FOREIGN KEY (lnkidbasic) REFERENCES tbl_onetomany(idbasic) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: tbl_nonechild_lnkbasicid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_nonechild
    ADD CONSTRAINT tbl_nonechild_lnkbasicid_fkey FOREIGN KEY (lnkbasicid) REFERENCES tbl_none(idbasic);


--
-- Name: tbl_tree_lnkidtree_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_tree
    ADD CONSTRAINT tbl_tree_lnkidtree_fkey FOREIGN KEY (lnkidtree) REFERENCES tbl_tree(idtree);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

