-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2025-08-18 21:22:21 BRT
--   site:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE t_cp (
    tb_patio_id_patio     NUMBER NOT NULL,
    tb_patio_status       CHAR(1) NOT NULL,
    tb_contato_id_contato NUMBER NOT NULL
);

ALTER TABLE t_cp
    ADD CONSTRAINT t_cp_pk PRIMARY KEY ( tb_patio_id_patio,
                                         tb_patio_status,
                                         tb_contato_id_contato );

CREATE TABLE t_ep (
    tb_endereco_id_endereco NUMBER NOT NULL,
    tb_patio_id_patio       NUMBER NOT NULL,
    tb_patio_status         CHAR(1) NOT NULL
);

ALTER TABLE t_ep
    ADD CONSTRAINT t_ep_pk PRIMARY KEY ( tb_endereco_id_endereco,
                                         tb_patio_id_patio,
                                         tb_patio_status );

CREATE TABLE tb_box (
    id_box       NUMBER NOT NULL,
    nome         VARCHAR2(50) NOT NULL,
    status       CHAR(1) NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida   DATE NOT NULL,
    observacao   VARCHAR2(100)
);

ALTER TABLE tb_box ADD CONSTRAINT tb_box_pk PRIMARY KEY ( id_box );

CREATE TABLE tb_cliente (
    id_cliente              NUMBER NOT NULL,
    data_cadastro           DATE NOT NULL,
    sexo                    CHAR(2) NOT NULL,
    nome                    VARCHAR2(50) NOT NULL,
    sobrenome               VARCHAR2(50) NOT NULL,
    data_nascimento         DATE NOT NULL,
    cpf                     CHAR(11) NOT NULL,
    profissao               VARCHAR2(50) NOT NULL,
    estado_civil            VARCHAR2(50) NOT NULL,
    tb_endereco_id_endereco NUMBER NOT NULL,
    tb_contato_id_contato   NUMBER NOT NULL,
    status                  CHAR(1) NOT NULL
);

ALTER TABLE tb_cliente
    ADD CONSTRAINT tb_cliente_pk PRIMARY KEY ( id_cliente,
                                               tb_endereco_id_endereco,
                                               tb_contato_id_contato );

CREATE TABLE tb_contato (
    id_contato NUMBER NOT NULL,
    email      VARCHAR2(100) NOT NULL,
    telefone1  VARCHAR2(20) NOT NULL,
    telefone2  VARCHAR2(20),
    telefone3  VARCHAR2(20),
    celular    VARCHAR2(20) NOT NULL,
    outro      VARCHAR2(100) NOT NULL,
    observacao VARCHAR2(200)
);

ALTER TABLE tb_contato ADD CONSTRAINT tb_contato_pk PRIMARY KEY ( id_contato );

CREATE TABLE tb_cv (
    tb_cliente_id_cliente              NUMBER NOT NULL,
    tb_cliente_tb_endereco_id_endereco NUMBER NOT NULL,
    tb_cliente_tb_contato_id_contato   NUMBER NOT NULL,
    tb_veiculo_id_veiculo              NUMBER NOT NULL
);

ALTER TABLE tb_cv
    ADD CONSTRAINT tb_cv_pk PRIMARY KEY ( tb_cliente_id_cliente,
                                          tb_cliente_tb_endereco_id_endereco,
                                          tb_cliente_tb_contato_id_contato,
                                          tb_veiculo_id_veiculo );

CREATE TABLE tb_endereco (
    id_endereco NUMBER NOT NULL,
    cep         CHAR(9) NOT NULL,
    numero      NUMBER(5) NOT NULL,
    logradouro  VARCHAR2(50) NOT NULL,
    bairro      VARCHAR2(50) NOT NULL,
    cidade      VARCHAR2(50) NOT NULL,
    estado      CHAR(2) NOT NULL,
    pais        VARCHAR2(20) NOT NULL,
    complemento VARCHAR2(60),
    observacao  VARCHAR2(200)
);

ALTER TABLE tb_endereco ADD CONSTRAINT tb_endereco_pk PRIMARY KEY ( id_endereco );

CREATE TABLE tb_patio (
    id_patio     NUMBER NOT NULL,
    nome_patio   VARCHAR2(50) NOT NULL,
    status       CHAR(1) NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida   DATE NOT NULL,
    observacao   VARCHAR2(100)
);

ALTER TABLE tb_patio ADD CONSTRAINT tb_patio_pk PRIMARY KEY ( id_patio,
                                                              status );

CREATE TABLE tb_pb (
    tb_patio_id_patio NUMBER NOT NULL,
    tb_patio_status   CHAR(1) NOT NULL,
    tb_box_id_box     NUMBER NOT NULL
);

ALTER TABLE tb_pb
    ADD CONSTRAINT tb_pb_pk PRIMARY KEY ( tb_patio_id_patio,
                                          tb_patio_status,
                                          tb_box_id_box );

CREATE TABLE tb_rastreamento (
    id_rastreamento NUMBER NOT NULL,
    status          CHAR(1) NOT NULL,
    ips_latitude    NUMBER(10, 8) NOT NULL,
    gprs_latitude   NUMBER(10, 8) NOT NULL,
    ips_longitude   NUMBER(11, 8) NOT NULL,
    gprs_longitude  NUMBER(11, 8) NOT NULL
);

ALTER TABLE tb_rastreamento ADD CONSTRAINT tb_rastreamento_pk PRIMARY KEY ( id_rastreamento );

CREATE TABLE tb_vb (
    tb_veiculo_id_veiculo NUMBER NOT NULL,
    tb_box_id_box         NUMBER NOT NULL
);

ALTER TABLE tb_vb ADD CONSTRAINT tb_vb_pk PRIMARY KEY ( tb_veiculo_id_veiculo,
                                                        tb_box_id_box );

CREATE TABLE tb_veiculo (
    id_veiculo  NUMBER NOT NULL,
    placa       VARCHAR2(10) NOT NULL,
    renavam     CHAR(11) NOT NULL,
    chassi      CHAR(17) NOT NULL,
    fabricante  VARCHAR2(50) NOT NULL,
    moldelo     VARCHAR2(60) NOT NULL,
    motor       VARCHAR2(30),
    ano         NUMBER NOT NULL,
    combustivel VARCHAR2(20) NOT NULL,
    status      VARCHAR2(20) NOT NULL
);

ALTER TABLE tb_veiculo ADD CONSTRAINT tb_veiculo_pk PRIMARY KEY ( id_veiculo );

CREATE TABLE tb_vp (
    tb_veiculo_id_veiculo NUMBER NOT NULL,
    tb_patio_id_patio     NUMBER NOT NULL,
    tb_patio_status       CHAR(1) NOT NULL
);

ALTER TABLE tb_vp
    ADD CONSTRAINT tb_vp_pk PRIMARY KEY ( tb_veiculo_id_veiculo,
                                          tb_patio_id_patio,
                                          tb_patio_status );

CREATE TABLE tb_vr (
    tb_veiculo_id_veiculo           NUMBER NOT NULL,
    tb_rastreamento_id_rastreamento NUMBER NOT NULL
);

ALTER TABLE tb_vr ADD CONSTRAINT tb_vr_pk PRIMARY KEY ( tb_veiculo_id_veiculo,
                                                        tb_rastreamento_id_rastreamento );

CREATE TABLE tb_vz (
    tb_veiculo_id_veiculo NUMBER NOT NULL,
    tb_zona_id_zona       NUMBER NOT NULL
);

ALTER TABLE tb_vz ADD CONSTRAINT tb_vz_pk PRIMARY KEY ( tb_veiculo_id_veiculo,
                                                        tb_zona_id_zona );

CREATE TABLE tb_zb (
    tb_zona_id_zona NUMBER NOT NULL,
    tb_box_id_box   NUMBER NOT NULL
);

ALTER TABLE tb_zb ADD CONSTRAINT tb_zb_pk PRIMARY KEY ( tb_zona_id_zona,
                                                        tb_box_id_box );

CREATE TABLE tb_zona (
    id_zona      NUMBER NOT NULL,
    nome         VARCHAR2(50) NOT NULL,
    status       CHAR(1) NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida   DATE NOT NULL,
    observacao   VARCHAR2(100)
);

ALTER TABLE tb_zona ADD CONSTRAINT tb_zona_pk PRIMARY KEY ( id_zona );

CREATE TABLE tb_zp (
    tb_patio_id_patio NUMBER NOT NULL,
    tb_zona_id_zona   NUMBER NOT NULL,
    tb_patio_status   CHAR(1) NOT NULL
);

ALTER TABLE tb_zp
    ADD CONSTRAINT tb_zp_pk PRIMARY KEY ( tb_patio_id_patio,
                                          tb_patio_status,
                                          tb_zona_id_zona );

ALTER TABLE t_cp
    ADD CONSTRAINT t_cp_tb_contato_fk FOREIGN KEY ( tb_contato_id_contato )
        REFERENCES tb_contato ( id_contato );

ALTER TABLE t_cp
    ADD CONSTRAINT t_cp_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                  tb_patio_status )
        REFERENCES tb_patio ( id_patio,
                              status );

ALTER TABLE t_ep
    ADD CONSTRAINT t_ep_tb_endereco_fk FOREIGN KEY ( tb_endereco_id_endereco )
        REFERENCES tb_endereco ( id_endereco );

ALTER TABLE t_ep
    ADD CONSTRAINT t_ep_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                  tb_patio_status )
        REFERENCES tb_patio ( id_patio,
                              status );

ALTER TABLE tb_cliente
    ADD CONSTRAINT tb_cliente_tb_contato_fk FOREIGN KEY ( tb_contato_id_contato )
        REFERENCES tb_contato ( id_contato );

ALTER TABLE tb_cliente
    ADD CONSTRAINT tb_cliente_tb_endereco_fk FOREIGN KEY ( tb_endereco_id_endereco )
        REFERENCES tb_endereco ( id_endereco );

ALTER TABLE tb_cv
    ADD CONSTRAINT tb_cv_tb_cliente_fk FOREIGN KEY ( tb_cliente_id_cliente,
                                                     tb_cliente_tb_endereco_id_endereco,
                                                     tb_cliente_tb_contato_id_contato )
        REFERENCES tb_cliente ( id_cliente,
                                tb_endereco_id_endereco,
                                tb_contato_id_contato );

ALTER TABLE tb_cv
    ADD CONSTRAINT tb_cv_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_pb
    ADD CONSTRAINT tb_pb_tb_box_fk FOREIGN KEY ( tb_box_id_box )
        REFERENCES tb_box ( id_box );

ALTER TABLE tb_pb
    ADD CONSTRAINT tb_pb_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                   tb_patio_status )
        REFERENCES tb_patio ( id_patio,
                              status );

ALTER TABLE tb_vb
    ADD CONSTRAINT tb_vb_tb_box_fk FOREIGN KEY ( tb_box_id_box )
        REFERENCES tb_box ( id_box );

ALTER TABLE tb_vb
    ADD CONSTRAINT tb_vb_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_vp
    ADD CONSTRAINT tb_vp_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                   tb_patio_status )
        REFERENCES tb_patio ( id_patio,
                              status );

ALTER TABLE tb_vp
    ADD CONSTRAINT tb_vp_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_vr
    ADD CONSTRAINT tb_vr_tb_rastreamento_fk FOREIGN KEY ( tb_rastreamento_id_rastreamento )
        REFERENCES tb_rastreamento ( id_rastreamento );

ALTER TABLE tb_vr
    ADD CONSTRAINT tb_vr_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_vz
    ADD CONSTRAINT tb_vz_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_vz
    ADD CONSTRAINT tb_vz_tb_zona_fk FOREIGN KEY ( tb_zona_id_zona )
        REFERENCES tb_zona ( id_zona );

ALTER TABLE tb_zb
    ADD CONSTRAINT tb_zb_tb_box_fk FOREIGN KEY ( tb_box_id_box )
        REFERENCES tb_box ( id_box );

ALTER TABLE tb_zb
    ADD CONSTRAINT tb_zb_tb_zona_fk FOREIGN KEY ( tb_zona_id_zona )
        REFERENCES tb_zona ( id_zona );

ALTER TABLE tb_zp
    ADD CONSTRAINT tb_zp_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                   tb_patio_status )
        REFERENCES tb_patio ( id_patio,
                              status );

ALTER TABLE tb_zp
    ADD CONSTRAINT tb_zp_tb_zona_fk FOREIGN KEY ( tb_zona_id_zona )
        REFERENCES tb_zona ( id_zona );



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            18
-- CREATE INDEX                             0
-- ALTER TABLE                             40
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
