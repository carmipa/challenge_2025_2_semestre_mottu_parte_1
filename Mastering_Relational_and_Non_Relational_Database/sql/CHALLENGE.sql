-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2025-05-03 14:32:17 BRT -- (Data original, DDL modificado agora)
--   site:      Oracle Database 21c
--   tipo:      Oracle Database 21c


-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

-- =============================================
-- TABELAS PRINCIPAIS (com IDs automaticos onde possivel)
-- =============================================

CREATE TABLE tb_box (
    id_box       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    nome         VARCHAR2(50) NOT NULL,
    status       CHAR(1) NOT NULL CHECK (status IN ('A', 'I')), -- Adicionado CHECK constraint (Exemplo: Ativo/Inativo)
    data_entrada DATE NOT NULL,
    data_saida   DATE, -- Alterado para NULLABLE
    observacao   VARCHAR2(100)
);
-- ALTER TABLE tb_box ADD CONSTRAINT tb_box_pk PRIMARY KEY ( id_box ); -- Removido, PK definida inline

CREATE TABLE tb_end_c (
    id_endc     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    cep         CHAR(9) NOT NULL,
    numero      NUMBER(5) NOT NULL,
    logradouro  VARCHAR2(50) NOT NULL,
    bairro      VARCHAR2(50) NOT NULL,
    cidade      VARCHAR2(50) NOT NULL,
    estado      CHAR(2) NOT NULL,
    pais        VARCHAR2(20) NOT NULL,
    complemento VARCHAR2(60) -- Alterado para NULLABLE
);
-- ALTER TABLE tb_end_c ADD CONSTRAINT tb_end_c_pk PRIMARY KEY ( id_endc ); -- Removido, PK definida inline

CREATE TABLE tb_cont_c (
    id_contc NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    email    VARCHAR2(100) NOT NULL UNIQUE, -- Adicionado UNIQUE
    telefone VARCHAR2(20), -- Alterado para NULLABLE
    celular  VARCHAR2(20) NOT NULL,
    outro    VARCHAR2(100) -- Alterado para NULLABLE
);
-- ALTER TABLE tb_cont_c ADD CONSTRAINT tb_cont_c_pk PRIMARY KEY ( id_contc ); -- Removido, PK definida inline

CREATE TABLE tb_cli (
    id_cli             NUMBER NOT NULL, -- Mantido como NOT NULL, parte de PK composta
    data_cadastro      DATE DEFAULT SYSDATE NOT NULL, -- Adicionado DEFAULT
    sexo               CHAR(1) CHECK (sexo IN ('M', 'F', 'O')), -- Alterado para CHAR(1) com CHECK (Ex: M/F/Outro)
    nome               VARCHAR2(50) NOT NULL,
    sobrenome          VARCHAR2(50) NOT NULL,
    data_nascimento    DATE NOT NULL,
    cpf                CHAR(11) NOT NULL UNIQUE, -- Adicionado UNIQUE
    profisao           VARCHAR2(50), -- Alterado para NULLABLE
    estado_civil       VARCHAR2(50), -- Alterado para NULLABLE
    tb_end_c_id_endc   NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_cont_c_id_contc NUMBER NOT NULL, -- Mantido como parte de PK composta
    status             CHAR(1) NOT NULL CHECK (status IN ('A', 'I', 'P', 'B')) -- Adicionado CHECK (Ex: Ativo/Inativo/Pendente/Bloqueado)
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_cli
    ADD CONSTRAINT tb_cli_pk PRIMARY KEY ( id_cli,
                                           tb_end_c_id_endc,
                                           tb_cont_c_id_contc );

CREATE TABLE tb_end_f (
    id_endf     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    cep         CHAR(9) NOT NULL,
    numero      NUMBER(5) NOT NULL,
    logradouro  VARCHAR2(50) NOT NULL,
    bairro      VARCHAR2(50) NOT NULL,
    cidade      VARCHAR2(50) NOT NULL,
    estado      CHAR(2) NOT NULL,
    pais        VARCHAR2(20) NOT NULL,
    complemento VARCHAR2(100) -- Alterado para NULLABLE
);
-- ALTER TABLE tb_end_f ADD CONSTRAINT tb_end_f_pk PRIMARY KEY ( id_endf ); -- Removido, PK definida inline

CREATE TABLE tb_cont_f (
    id_contf  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity (renomeada de tb_cont_f_id)
    email     VARCHAR2(100) NOT NULL UNIQUE, -- Adicionado UNIQUE
    telefone1 VARCHAR2(20) NOT NULL,
    telefone2 VARCHAR2(20), -- Alterado para NULLABLE
    outro     VARCHAR2(100) -- Alterado para NULLABLE
    -- tb_cont_f_id NUMBER NOT NULL -- Coluna original da PK removida
);
-- ALTER TABLE tb_cont_f ADD CONSTRAINT tb_cont_f_pk PRIMARY KEY ( tb_cont_f_id ); -- Removido, PK definida inline e coluna renomeada

CREATE TABLE tb_filial (
    id_fil                 NUMBER NOT NULL, -- Mantido como NOT NULL, parte de PK composta
    nome                   VARCHAR2(50) NOT NULL UNIQUE, -- Adicionado UNIQUE
    status                 CHAR(1) NOT NULL CHECK (status IN ('A', 'I')), -- Adicionado CHECK
    data_entrada           DATE DEFAULT SYSDATE NOT NULL, -- Adicionado DEFAULT
    data_saida             DATE, -- Alterado para NULLABLE
    observacao             VARCHAR2(100),
    tb_end_f_id_endf       NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_cont_f_id_contf     NUMBER NOT NULL -- Renomeada FK para corresponder à nova PK de tb_cont_f
);

-- PK Composta mantida conforme solicitado (referência a tb_end_f mantida)
ALTER TABLE tb_filial ADD CONSTRAINT tb_filial_pk PRIMARY KEY ( id_fil,
                                                                tb_end_f_id_endf );

CREATE TABLE tb_end_p (
    id_endp     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    cep         CHAR(9) NOT NULL,
    numero      NUMBER(5) NOT NULL,
    logradouro  VARCHAR2(50) NOT NULL,
    bairro      VARCHAR2(50) NOT NULL,
    cidade      VARCHAR2(50),
    estado      CHAR(2) NOT NULL,
    pais        VARCHAR2(30) NOT NULL,
    complemento VARCHAR2(100) -- Alterado para NULLABLE
);
-- ALTER TABLE tb_end_p ADD CONSTRAINT tb_end_p_pk PRIMARY KEY ( id_endp ); -- Removido, PK definida inline

CREATE TABLE tb_cont_p (
    id_contp  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    email     VARCHAR2(100) NOT NULL UNIQUE, -- Adicionado UNIQUE
    telefone1 VARCHAR2(20) NOT NULL,
    telefone2 VARCHAR2(20), -- Alterado para NULLABLE
    outro     VARCHAR2(100) -- Alterado para NULLABLE
);
-- ALTER TABLE tb_cont_p ADD CONSTRAINT tb_cont_p_pk PRIMARY KEY ( id_contp ); -- Removido, PK definida inline

CREATE TABLE tb_patio (
    id_patio           NUMBER NOT NULL, -- Mantido como NOT NULL, parte de PK composta
    nome_patio         VARCHAR2(50) NOT NULL UNIQUE, -- Adicionado UNIQUE
    tb_cont_p_id_contp NUMBER NOT NULL, -- Mantido como parte de PK composta
    status             CHAR(1) NOT NULL CHECK (status IN ('A', 'I')), -- Mantido como parte de PK composta, Adicionado CHECK
    data_entrada       DATE DEFAULT SYSDATE NOT NULL, -- Adicionado DEFAULT
    data_saida         DATE, -- Alterado para NULLABLE
    observacao         VARCHAR2(100),
    tb_end_p_id_endp   NUMBER NOT NULL -- Mantido como parte de PK composta
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_patio
    ADD CONSTRAINT tb_patio_pk PRIMARY KEY ( id_patio,
                                             tb_cont_p_id_contp,
                                             status,
                                             tb_end_p_id_endp );

CREATE TABLE tb_rastreamento (
    id_rast        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    status         CHAR(1) NOT NULL CHECK (status IN ('A', 'I', 'E')), -- Adicionado CHECK (Ex: Ativo/Inativo/Erro)
    ips_x          NUMBER(7, 3), -- Removido NOT NULL, pode não ser sempre aplicável
    ips_y          NUMBER(7, 3), -- Removido NOT NULL
    ipcs_z         NUMBER(7, 3), -- Removido NOT NULL
    ips_data_hora  TIMESTAMP WITH LOCAL TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL, -- Adicionado DEFAULT
    gprs_latitude  NUMBER(9, 6) NOT NULL,
    gprs_longitude NUMBER(9, 6) NOT NULL,
    gprs_altitude  NUMBER(7, 2) -- Removido NOT NULL, altitude pode faltar
);
-- ALTER TABLE tb_rastreamento ADD CONSTRAINT tb_rastreamento_pk PRIMARY KEY ( id_rast ); -- Removido, PK definida inline

CREATE TABLE tb_veiculo (
    id_veiculo  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    placa       VARCHAR2(10) NOT NULL UNIQUE,
    renavam     CHAR(11) NOT NULL UNIQUE,
    chassi      CHAR(17) NOT NULL UNIQUE,
    fabricante  VARCHAR2(50) NOT NULL,
    moldelo     VARCHAR2(60) NOT NULL, -- Corrigido para modelo?
    motor       VARCHAR2(30),
    ano         NUMBER(4) NOT NULL, -- Especificado tamanho
    combustivel VARCHAR2(20) NOT NULL,
    status      VARCHAR2(20) NOT NULL CHECK (status IN ('Disponível', 'Alugada', 'Manutenção', 'Vendida', 'Inativa')) -- Adicionado CHECK (Exemplo)
);
-- ALTER TABLE tb_veiculo ADD CONSTRAINT tb_veiculo_pk PRIMARY KEY ( id_veiculo ); -- Removido, PK definida inline

CREATE TABLE tb_zona (
    id_zona      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- PK Simples com Identity
    nome         VARCHAR2(50) NOT NULL UNIQUE, -- Adicionado UNIQUE
    status       CHAR(1) NOT NULL CHECK (status IN ('A', 'I')), -- Adicionado CHECK
    data_entrada DATE DEFAULT SYSDATE NOT NULL, -- Adicionado DEFAULT
    data_saida   DATE, -- Alterado para NULLABLE
    observacao   VARCHAR2(100)
);
-- ALTER TABLE tb_zona ADD CONSTRAINT tb_zona_pk PRIMARY KEY ( id_zona ); -- Removido, PK definida inline

-- =============================================
-- TABELAS DE LIGAÇÃO (PKs Compostas Mantidas)
-- =============================================

CREATE TABLE tb_cv (
    id_cv                     NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_cli_id_cli             NUMBER NOT NULL,
    tb_cli_tb_end_c_id_endc   NUMBER NOT NULL,
    tb_cli_tb_cont_c_id_contc NUMBER NOT NULL,
    tb_veiculo_id_veiculo     NUMBER NOT NULL
    -- Faltam campos de locação aqui!
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_cv
    ADD CONSTRAINT tb_cv_pk PRIMARY KEY ( id_cv,
                                          tb_cli_id_cli,
                                          tb_cli_tb_end_c_id_endc,
                                          tb_cli_tb_cont_c_id_contc,
                                          tb_veiculo_id_veiculo );

CREATE TABLE tb_fp (
    id_fp                      NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_filial_id_fil           NUMBER NOT NULL,
    tb_patio_id_patio          NUMBER NOT NULL,
    tb_patio_id_contp          NUMBER NOT NULL,
    tb_patio_status            CHAR(1) NOT NULL,
    tb_filial_tb_end_f_id_endf NUMBER NOT NULL,
    tb_patio_id_endp           NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_fp
    ADD CONSTRAINT tb_fp_pk PRIMARY KEY ( id_fp,
                                          tb_filial_id_fil,
                                          tb_filial_tb_end_f_id_endf,
                                          tb_patio_id_patio,
                                          tb_patio_id_contp,
                                          tb_patio_status,
                                          tb_patio_id_endp );

CREATE TABLE tb_fv (
    id_fv                      NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_veiculo_id_veiculo      NUMBER NOT NULL,
    tb_filial_id_fil           NUMBER NOT NULL,
    tb_filial_tb_end_f_id_endf NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_fv
    ADD CONSTRAINT tb_fv_pk PRIMARY KEY ( id_fv,
                                          tb_filial_id_fil,
                                          tb_filial_tb_end_f_id_endf,
                                          tb_veiculo_id_veiculo );

CREATE TABLE tb_vb (
    id_vb                 NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_veiculo_id_veiculo NUMBER NOT NULL,
    tb_box_id_box         NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_vb
    ADD CONSTRAINT tb_vb_pk PRIMARY KEY ( id_vb, -- Colocado id_vb primeiro por convenção
                                          tb_veiculo_id_veiculo,
                                          tb_box_id_box );

CREATE TABLE tb_vp (
    id_vp                       NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_veiculo_id_veiculo       NUMBER NOT NULL,
    tb_patio_id_patio           NUMBER NOT NULL,
    tb_patio_tb_cont_p_id_contp NUMBER NOT NULL,
    tb_patio_status             CHAR(1) NOT NULL,
    tb_patio_tb_end_p_id_endp   NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_vp
    ADD CONSTRAINT tb_vp_pk PRIMARY KEY ( id_vp,
                                          tb_veiculo_id_veiculo,
                                          tb_patio_id_patio,
                                          tb_patio_tb_cont_p_id_contp,
                                          tb_patio_status,
                                          tb_patio_tb_end_p_id_endp );

CREATE TABLE tb_vr (
    id_vr                   NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_veiculo_id_veiculo   NUMBER NOT NULL,
    tb_rastreamento_id_rast NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_vr
    ADD CONSTRAINT tb_vr_pk PRIMARY KEY ( id_vr, -- Colocado id_vr primeiro
                                          tb_veiculo_id_veiculo,
                                          tb_rastreamento_id_rast );

CREATE TABLE tb_vz (
    id_vz                 NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_veiculo_id_veiculo NUMBER NOT NULL,
    tb_zona_id_zona       NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_vz
    ADD CONSTRAINT tb_vz_pk PRIMARY KEY ( id_vz, -- Colocado id_vz primeiro
                                          tb_veiculo_id_veiculo,
                                          tb_zona_id_zona );

CREATE TABLE tb_zb (
    id_zb           NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_zona_id_zona NUMBER NOT NULL,
    tb_box_id_box   NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_zb
    ADD CONSTRAINT tb_zb_pk PRIMARY KEY ( id_zb, -- Colocado id_zb primeiro
                                          tb_zona_id_zona,
                                          tb_box_id_box );

CREATE TABLE tb_zp (
    id_zp                       NUMBER NOT NULL, -- Mantido como parte de PK composta
    tb_patio_id_patio           NUMBER NOT NULL,
    tb_patio_tb_cont_p_id_contp NUMBER NOT NULL,
    tb_zona_id_zona             NUMBER NOT NULL,
    tb_patio_status             CHAR(1) NOT NULL,
    tb_patio_tb_end_p_id_endp   NUMBER NOT NULL
);

-- PK Composta mantida conforme solicitado
ALTER TABLE tb_zp
    ADD CONSTRAINT tb_zp_pk PRIMARY KEY ( id_zp,
                                          tb_patio_id_patio,
                                          tb_patio_tb_cont_p_id_contp,
                                          tb_patio_status,
                                          tb_patio_tb_end_p_id_endp,
                                          tb_zona_id_zona );

-- =============================================
-- CHAVES ESTRANGEIRAS (FKs)
-- =============================================

ALTER TABLE tb_cli
    ADD CONSTRAINT tb_cli_tb_cont_c_fk FOREIGN KEY ( tb_cont_c_id_contc )
        REFERENCES tb_cont_c ( id_contc );

ALTER TABLE tb_cli
    ADD CONSTRAINT tb_cli_tb_end_c_fk FOREIGN KEY ( tb_end_c_id_endc )
        REFERENCES tb_end_c ( id_endc );

ALTER TABLE tb_cv
    ADD CONSTRAINT tb_cv_tb_cli_fk FOREIGN KEY ( tb_cli_id_cli,
                                                 tb_cli_tb_end_c_id_endc,
                                                 tb_cli_tb_cont_c_id_contc )
        REFERENCES tb_cli ( id_cli,
                            tb_end_c_id_endc,
                            tb_cont_c_id_contc );

ALTER TABLE tb_cv
    ADD CONSTRAINT tb_cv_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_filial
    ADD CONSTRAINT tb_filial_tb_cont_f_fk FOREIGN KEY ( tb_cont_f_id_contf ) -- Coluna FK renomeada
        REFERENCES tb_cont_f ( id_contf ); -- Referência PK corrigida

ALTER TABLE tb_filial
    ADD CONSTRAINT tb_filial_tb_end_f_fk FOREIGN KEY ( tb_end_f_id_endf )
        REFERENCES tb_end_f ( id_endf );

ALTER TABLE tb_fp
    ADD CONSTRAINT tb_fp_tb_filial_fk FOREIGN KEY ( tb_filial_id_fil,
                                                    tb_filial_tb_end_f_id_endf )
        REFERENCES tb_filial ( id_fil,
                               tb_end_f_id_endf );

ALTER TABLE tb_fp
    ADD CONSTRAINT tb_fp_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                   tb_patio_id_contp,
                                                   tb_patio_status,
                                                   tb_patio_id_endp )
        REFERENCES tb_patio ( id_patio,
                               tb_cont_p_id_contp,
                               status,
                               tb_end_p_id_endp );

ALTER TABLE tb_fv
    ADD CONSTRAINT tb_fv_tb_filial_fk FOREIGN KEY ( tb_filial_id_fil,
                                                    tb_filial_tb_end_f_id_endf )
        REFERENCES tb_filial ( id_fil,
                               tb_end_f_id_endf );

ALTER TABLE tb_fv
    ADD CONSTRAINT tb_fv_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_patio
    ADD CONSTRAINT tb_patio_tb_cont_p_fk FOREIGN KEY ( tb_cont_p_id_contp )
        REFERENCES tb_cont_p ( id_contp );

ALTER TABLE tb_patio
    ADD CONSTRAINT tb_patio_tb_end_p_fk FOREIGN KEY ( tb_end_p_id_endp )
        REFERENCES tb_end_p ( id_endp );

ALTER TABLE tb_vb
    ADD CONSTRAINT tb_vb_tb_box_fk FOREIGN KEY ( tb_box_id_box )
        REFERENCES tb_box ( id_box );

ALTER TABLE tb_vb
    ADD CONSTRAINT tb_vb_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_vp
    ADD CONSTRAINT tb_vp_tb_patio_fk FOREIGN KEY ( tb_patio_id_patio,
                                                   tb_patio_tb_cont_p_id_contp,
                                                   tb_patio_status,
                                                   tb_patio_tb_end_p_id_endp )
        REFERENCES tb_patio ( id_patio,
                               tb_cont_p_id_contp,
                               status,
                               tb_end_p_id_endp );

ALTER TABLE tb_vp
    ADD CONSTRAINT tb_vp_tb_veiculo_fk FOREIGN KEY ( tb_veiculo_id_veiculo )
        REFERENCES tb_veiculo ( id_veiculo );

ALTER TABLE tb_vr
    ADD CONSTRAINT tb_vr_tb_rastreamento_fk FOREIGN KEY ( tb_rastreamento_id_rast )
        REFERENCES tb_rastreamento ( id_rast );

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
                                                   tb_patio_tb_cont_p_id_contp,
                                                   tb_patio_status,
                                                   tb_patio_tb_end_p_id_endp )
        REFERENCES tb_patio ( id_patio,
                               tb_cont_p_id_contp,
                               status,
                               tb_end_p_id_endp );

ALTER TABLE tb_zp
    ADD CONSTRAINT tb_zp_tb_zona_fk FOREIGN KEY ( tb_zona_id_zona )
        REFERENCES tb_zona ( id_zona );


-- =============================================
-- ÍNDICES (para FKs e colunas de filtro comuns)
-- =============================================

-- Índices para FKs
CREATE INDEX idx_cli_cont_c_fk ON tb_cli (tb_cont_c_id_contc);
CREATE INDEX idx_cli_end_c_fk ON tb_cli (tb_end_c_id_endc);
CREATE INDEX idx_cv_cli_fk ON tb_cv (tb_cli_id_cli, tb_cli_tb_end_c_id_endc, tb_cli_tb_cont_c_id_contc);
CREATE INDEX idx_cv_veiculo_fk ON tb_cv (tb_veiculo_id_veiculo);
CREATE INDEX idx_filial_cont_f_fk ON tb_filial (tb_cont_f_id_contf);
CREATE INDEX idx_filial_end_f_fk ON tb_filial (tb_end_f_id_endf);
CREATE INDEX idx_fp_filial_fk ON tb_fp (tb_filial_id_fil, tb_filial_tb_end_f_id_endf);
CREATE INDEX idx_fp_patio_fk ON tb_fp (tb_patio_id_patio, tb_patio_id_contp, tb_patio_status, tb_patio_id_endp);
CREATE INDEX idx_fv_filial_fk ON tb_fv (tb_filial_id_fil, tb_filial_tb_end_f_id_endf);
CREATE INDEX idx_fv_veiculo_fk ON tb_fv (tb_veiculo_id_veiculo);
CREATE INDEX idx_patio_cont_p_fk ON tb_patio (tb_cont_p_id_contp);
CREATE INDEX idx_patio_end_p_fk ON tb_patio (tb_end_p_id_endp);
CREATE INDEX idx_vb_box_fk ON tb_vb (tb_box_id_box);
CREATE INDEX idx_vb_veiculo_fk ON tb_vb (tb_veiculo_id_veiculo);
CREATE INDEX idx_vp_patio_fk ON tb_vp (tb_patio_id_patio, tb_patio_tb_cont_p_id_contp, tb_patio_status, tb_patio_tb_end_p_id_endp);
CREATE INDEX idx_vp_veiculo_fk ON tb_vp (tb_veiculo_id_veiculo);
CREATE INDEX idx_vr_rastreamento_fk ON tb_vr (tb_rastreamento_id_rast);
CREATE INDEX idx_vr_veiculo_fk ON tb_vr (tb_veiculo_id_veiculo);
CREATE INDEX idx_vz_veiculo_fk ON tb_vz (tb_veiculo_id_veiculo);
CREATE INDEX idx_vz_zona_fk ON tb_vz (tb_zona_id_zona);
CREATE INDEX idx_zb_box_fk ON tb_zb (tb_box_id_box);
CREATE INDEX idx_zb_zona_fk ON tb_zb (tb_zona_id_zona);
CREATE INDEX idx_zp_patio_fk ON tb_zp (tb_patio_id_patio, tb_patio_tb_cont_p_id_contp, tb_patio_status, tb_patio_tb_end_p_id_endp);
CREATE INDEX idx_zp_zona_fk ON tb_zp (tb_zona_id_zona);

-- Índices para colunas de filtro comuns
CREATE INDEX idx_cli_cpf ON tb_cli (cpf);
CREATE INDEX idx_cli_status ON tb_cli (status);
CREATE INDEX idx_veiculo_placa ON tb_veiculo (placa);
CREATE INDEX idx_veiculo_renavam ON tb_veiculo (renavam);
CREATE INDEX idx_veiculo_chassi ON tb_veiculo (chassi);
CREATE INDEX idx_veiculo_status ON tb_veiculo (status);
CREATE INDEX idx_rastreamento_data_hora ON tb_rastreamento (ips_data_hora);
CREATE INDEX idx_box_status ON tb_box (status);
CREATE INDEX idx_filial_status ON tb_filial (status);
-- Nao criar indice em tb_patio(status) pois ja faz parte da PK composta
CREATE INDEX idx_zona_status ON tb_zona (status);


-- =============================================
-- SEQUENCES E TRIGGERS (Removido para tb_cont_f)
-- =============================================

-- CREATE SEQUENCE tb_cont_f_tb_cont_f_id_seq START WITH 1 NOCACHE ORDER; -- REMOVIDO
-- CREATE OR REPLACE TRIGGER tb_cont_f_tb_cont_f_id_trg BEFORE -- REMOVIDO
--     INSERT ON tb_cont_f
--     FOR EACH ROW
--     WHEN ( new.tb_cont_f_id IS NULL )
-- BEGIN
--     :new.tb_cont_f_id := tb_cont_f_tb_cont_f_id_seq.nextval;
-- END;
-- /


-- =============================================
-- TABELAS E TRIGGERS DE AUDITORIA/JOURNALING (_JN)
-- (Mantidas conforme DDL anterior, verificar necessidade)
-- =============================================

CREATE TABLE TB_BOX_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_box NUMBER NOT NULL
 ,nome VARCHAR2 (50) NOT NULL
 ,status CHAR (1) NOT NULL
 ,data_entrada DATE NOT NULL
 ,data_saida DATE -- Alterado para NULLABLE
 ,observacao VARCHAR2 (100)
 );

CREATE OR REPLACE TRIGGER TB_BOX_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_BOX for each row
 Declare
  rec TB_BOX_JN%ROWTYPE;
  blank TB_BOX_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_box := :NEW.id_box;
      rec.nome := :NEW.nome;
      rec.status := :NEW.status;
      rec.data_entrada := :NEW.data_entrada;
      rec.data_saida := :NEW.data_saida;
      rec.observacao := :NEW.observacao;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_box := :OLD.id_box;
      rec.nome := :OLD.nome;
      rec.status := :OLD.status;
      rec.data_entrada := :OLD.data_entrada;
      rec.data_saida := :OLD.data_saida;
      rec.observacao := :OLD.observacao;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_BOX_JN VALUES rec;
  END;
 /

CREATE TABLE TB_END_C_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_endc NUMBER NOT NULL
 ,cep CHAR (9) NOT NULL
 ,numero NUMBER (5) NOT NULL
 ,logradouro VARCHAR2 (50) NOT NULL
 ,bairro VARCHAR2 (50) NOT NULL
 ,cidade VARCHAR2 (50) NOT NULL
 ,estado CHAR (2) NOT NULL
 ,pais VARCHAR2 (20) NOT NULL
 ,complemento VARCHAR2 (60) -- Alterado para NULLABLE
 );

CREATE OR REPLACE TRIGGER TB_END_C_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_END_C for each row
 Declare
  rec TB_END_C_JN%ROWTYPE;
  blank TB_END_C_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_endc := :NEW.id_endc;
      rec.cep := :NEW.cep;
      rec.numero := :NEW.numero;
      rec.logradouro := :NEW.logradouro;
      rec.bairro := :NEW.bairro;
      rec.cidade := :NEW.cidade;
      rec.estado := :NEW.estado;
      rec.pais := :NEW.pais;
      rec.complemento := :NEW.complemento;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_endc := :OLD.id_endc;
      rec.cep := :OLD.cep;
      rec.numero := :OLD.numero;
      rec.logradouro := :OLD.logradouro;
      rec.bairro := :OLD.bairro;
      rec.cidade := :OLD.cidade;
      rec.estado := :OLD.estado;
      rec.pais := :OLD.pais;
      rec.complemento := :OLD.complemento;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_END_C_JN VALUES rec;
  END;
 /

CREATE TABLE TB_CONT_C_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_contc NUMBER NOT NULL
 ,email VARCHAR2 (100) NOT NULL
 ,telefone VARCHAR2 (20) -- Alterado para NULLABLE
 ,celular VARCHAR2 (20) NOT NULL
 ,outro VARCHAR2 (100) -- Alterado para NULLABLE
 );

CREATE OR REPLACE TRIGGER TB_CONT_C_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_CONT_C for each row
 Declare
  rec TB_CONT_C_JN%ROWTYPE;
  blank TB_CONT_C_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_contc := :NEW.id_contc;
      rec.email := :NEW.email;
      rec.telefone := :NEW.telefone;
      rec.celular := :NEW.celular;
      rec.outro := :NEW.outro;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_contc := :OLD.id_contc;
      rec.email := :OLD.email;
      rec.telefone := :OLD.telefone;
      rec.celular := :OLD.celular;
      rec.outro := :OLD.outro;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_CONT_C_JN VALUES rec;
  END;
 /

CREATE TABLE TB_CLI_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_cli NUMBER NOT NULL
 ,data_cadastro DATE NOT NULL
 ,sexo CHAR (1) -- Alterado para CHAR(1)
 ,nome VARCHAR2 (50) NOT NULL
 ,sobrenome VARCHAR2 (50) NOT NULL
 ,data_nascimento DATE NOT NULL
 ,cpf CHAR (11) NOT NULL
 ,profisao VARCHAR2 (50) -- Alterado para NULLABLE
 ,estado_civil VARCHAR2 (50) -- Alterado para NULLABLE
 ,TB_END_C_id_endc NUMBER NOT NULL
 ,TB_CONT_C_id_contc NUMBER NOT NULL
 ,status CHAR (1) NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_CLI_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_CLI for each row
 Declare
  rec TB_CLI_JN%ROWTYPE;
  blank TB_CLI_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_cli := :NEW.id_cli;
      rec.data_cadastro := :NEW.data_cadastro;
      rec.sexo := :NEW.sexo;
      rec.nome := :NEW.nome;
      rec.sobrenome := :NEW.sobrenome;
      rec.data_nascimento := :NEW.data_nascimento;
      rec.cpf := :NEW.cpf;
      rec.profisao := :NEW.profisao;
      rec.estado_civil := :NEW.estado_civil;
      rec.TB_END_C_id_endc := :NEW.TB_END_C_id_endc;
      rec.TB_CONT_C_id_contc := :NEW.TB_CONT_C_id_contc;
      rec.status := :NEW.status;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_cli := :OLD.id_cli;
      rec.data_cadastro := :OLD.data_cadastro;
      rec.sexo := :OLD.sexo;
      rec.nome := :OLD.nome;
      rec.sobrenome := :OLD.sobrenome;
      rec.data_nascimento := :OLD.data_nascimento;
      rec.cpf := :OLD.cpf;
      rec.profisao := :OLD.profisao;
      rec.estado_civil := :OLD.estado_civil;
      rec.TB_END_C_id_endc := :OLD.TB_END_C_id_endc;
      rec.TB_CONT_C_id_contc := :OLD.TB_CONT_C_id_contc;
      rec.status := :OLD.status;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_CLI_JN VALUES rec;
  END;
 /

CREATE TABLE TB_END_F_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_endf NUMBER NOT NULL
 ,cep CHAR (9) NOT NULL
 ,numero NUMBER (5) NOT NULL
 ,logradouro VARCHAR2 (50) NOT NULL
 ,bairro VARCHAR2 (50) NOT NULL
 ,cidade VARCHAR2 (50) NOT NULL
 ,estado CHAR (2) NOT NULL
 ,pais VARCHAR2 (20) NOT NULL
 ,complemento VARCHAR2 (100) -- Alterado para NULLABLE
 );

CREATE OR REPLACE TRIGGER TB_END_F_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_END_F for each row
 Declare
  rec TB_END_F_JN%ROWTYPE;
  blank TB_END_F_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_endf := :NEW.id_endf;
      rec.cep := :NEW.cep;
      rec.numero := :NEW.numero;
      rec.logradouro := :NEW.logradouro;
      rec.bairro := :NEW.bairro;
      rec.cidade := :NEW.cidade;
      rec.estado := :NEW.estado;
      rec.pais := :NEW.pais;
      rec.complemento := :NEW.complemento;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_endf := :OLD.id_endf;
      rec.cep := :OLD.cep;
      rec.numero := :OLD.numero;
      rec.logradouro := :OLD.logradouro;
      rec.bairro := :OLD.bairro;
      rec.cidade := :OLD.cidade;
      rec.estado := :OLD.estado;
      rec.pais := :OLD.pais;
      rec.complemento := :OLD.complemento;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_END_F_JN VALUES rec;
  END;
 /

CREATE TABLE TB_CONT_F_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_contf NUMBER NOT NULL
 ,email VARCHAR2 (100) NOT NULL
 ,telefone1 VARCHAR2 (20) NOT NULL
 ,telefone2 VARCHAR2 (20) -- Alterado para NULLABLE
 ,outro VARCHAR2 (100) -- Alterado para NULLABLE
 -- ,TB_CONT_F_ID NUMBER NOT NULL -- Removido
 );

CREATE OR REPLACE TRIGGER TB_CONT_F_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_CONT_F for each row
 Declare
  rec TB_CONT_F_JN%ROWTYPE;
  blank TB_CONT_F_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_contf := :NEW.id_contf;
      rec.email := :NEW.email;
      rec.telefone1 := :NEW.telefone1;
      rec.telefone2 := :NEW.telefone2;
      rec.outro := :NEW.outro;
      -- rec.TB_CONT_F_ID := :NEW.TB_CONT_F_ID; -- Removido
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_contf := :OLD.id_contf;
      rec.email := :OLD.email;
      rec.telefone1 := :OLD.telefone1;
      rec.telefone2 := :OLD.telefone2;
      rec.outro := :OLD.outro;
      -- rec.TB_CONT_F_ID := :OLD.TB_CONT_F_ID; -- Removido
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_CONT_F_JN VALUES rec;
  END;
 /

CREATE TABLE TB_FILIAL_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_fil NUMBER NOT NULL
 ,nome VARCHAR2 (50) NOT NULL
 ,status CHAR (1) NOT NULL
 ,data_entrada DATE NOT NULL
 ,data_saida DATE -- Alterado para NULLABLE
 ,observacao VARCHAR2 (100)
 ,TB_END_F_id_endf NUMBER NOT NULL
 ,TB_CONT_F_ID_CONTF NUMBER NOT NULL -- Coluna da FK renomeada
 );

CREATE OR REPLACE TRIGGER TB_FILIAL_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_FILIAL for each row
 Declare
  rec TB_FILIAL_JN%ROWTYPE;
  blank TB_FILIAL_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_fil := :NEW.id_fil;
      rec.nome := :NEW.nome;
      rec.status := :NEW.status;
      rec.data_entrada := :NEW.data_entrada;
      rec.data_saida := :NEW.data_saida;
      rec.observacao := :NEW.observacao;
      rec.TB_END_F_id_endf := :NEW.TB_END_F_id_endf;
      rec.TB_CONT_F_ID_CONTF := :NEW.TB_CONT_F_ID_CONTF; -- Coluna da FK renomeada
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_fil := :OLD.id_fil;
      rec.nome := :OLD.nome;
      rec.status := :OLD.status;
      rec.data_entrada := :OLD.data_entrada;
      rec.data_saida := :OLD.data_saida;
      rec.observacao := :OLD.observacao;
      rec.TB_END_F_id_endf := :OLD.TB_END_F_id_endf;
      rec.TB_CONT_F_ID_CONTF := :OLD.TB_CONT_F_ID_CONTF; -- Coluna da FK renomeada
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_FILIAL_JN VALUES rec;
  END;
 /

CREATE TABLE TB_END_P_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_endp NUMBER NOT NULL
 ,cep CHAR (9) NOT NULL
 ,numero NUMBER (5) NOT NULL
 ,logradouro VARCHAR2 (50) NOT NULL
 ,bairro VARCHAR2 (50) NOT NULL
 ,cidade VARCHAR2 (50)
 ,estado CHAR (2) NOT NULL
 ,pais VARCHAR2 (30) NOT NULL
 ,complemento VARCHAR2 (100) -- Alterado para NULLABLE
 );

CREATE OR REPLACE TRIGGER TB_END_P_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_END_P for each row
 Declare
  rec TB_END_P_JN%ROWTYPE;
  blank TB_END_P_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_endp := :NEW.id_endp;
      rec.cep := :NEW.cep;
      rec.numero := :NEW.numero;
      rec.logradouro := :NEW.logradouro;
      rec.bairro := :NEW.bairro;
      rec.cidade := :NEW.cidade;
      rec.estado := :NEW.estado;
      rec.pais := :NEW.pais;
      rec.complemento := :NEW.complemento;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_endp := :OLD.id_endp;
      rec.cep := :OLD.cep;
      rec.numero := :OLD.numero;
      rec.logradouro := :OLD.logradouro;
      rec.bairro := :OLD.bairro;
      rec.cidade := :OLD.cidade;
      rec.estado := :OLD.estado;
      rec.pais := :OLD.pais;
      rec.complemento := :OLD.complemento;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_END_P_JN VALUES rec;
  END;
 /

CREATE TABLE TB_CONT_P_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_contp NUMBER NOT NULL
 ,email VARCHAR2 (100) NOT NULL
 ,telefone1 VARCHAR2 (20) NOT NULL
 ,telefone2 VARCHAR2 (20) -- Alterado para NULLABLE
 ,outro VARCHAR2 (100) -- Alterado para NULLABLE
 );

CREATE OR REPLACE TRIGGER TB_CONT_P_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_CONT_P for each row
 Declare
  rec TB_CONT_P_JN%ROWTYPE;
  blank TB_CONT_P_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_contp := :NEW.id_contp;
      rec.email := :NEW.email;
      rec.telefone1 := :NEW.telefone1;
      rec.telefone2 := :NEW.telefone2;
      rec.outro := :NEW.outro;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_contp := :OLD.id_contp;
      rec.email := :OLD.email;
      rec.telefone1 := :OLD.telefone1;
      rec.telefone2 := :OLD.telefone2;
      rec.outro := :OLD.outro;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_CONT_P_JN VALUES rec;
  END;
 /

CREATE TABLE TB_PATIO_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_patio NUMBER NOT NULL
 ,nome_patio VARCHAR2 (50) NOT NULL
 ,TB_CONT_P_id_contp NUMBER NOT NULL
 ,status CHAR (1) NOT NULL
 ,data_entrada DATE NOT NULL
 ,data_saida DATE -- Alterado para NULLABLE
 ,observacao VARCHAR2 (100)
 ,TB_END_P_id_endp NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_PATIO_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_PATIO for each row
 Declare
  rec TB_PATIO_JN%ROWTYPE;
  blank TB_PATIO_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_patio := :NEW.id_patio;
      rec.nome_patio := :NEW.nome_patio;
      rec.TB_CONT_P_id_contp := :NEW.TB_CONT_P_id_contp;
      rec.status := :NEW.status;
      rec.data_entrada := :NEW.data_entrada;
      rec.data_saida := :NEW.data_saida;
      rec.observacao := :NEW.observacao;
      rec.TB_END_P_id_endp := :NEW.TB_END_P_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_patio := :OLD.id_patio;
      rec.nome_patio := :OLD.nome_patio;
      rec.TB_CONT_P_id_contp := :OLD.TB_CONT_P_id_contp;
      rec.status := :OLD.status;
      rec.data_entrada := :OLD.data_entrada;
      rec.data_saida := :OLD.data_saida;
      rec.observacao := :OLD.observacao;
      rec.TB_END_P_id_endp := :OLD.TB_END_P_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_PATIO_JN VALUES rec;
  END;
 /

CREATE TABLE TB_RASTREAMENTO_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_rast NUMBER NOT NULL
 ,status CHAR (1) NOT NULL
 ,ips_x NUMBER (7,3) -- Removido NOT NULL
 ,ips_y NUMBER (7,3) -- Removido NOT NULL
 ,ipcs_z NUMBER (7,3) -- Removido NOT NULL
 ,ips_data_hora TIMESTAMP WITH LOCAL TIME ZONE NOT NULL
 ,gprs_latitude NUMBER (9,6) NOT NULL
 ,gprs_longitude NUMBER (9,6) NOT NULL
 ,gprs_altitude NUMBER (7,2) -- Removido NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_RASTREAMENTO_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_RASTREAMENTO for each row
 Declare
  rec TB_RASTREAMENTO_JN%ROWTYPE;
  blank TB_RASTREAMENTO_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_rast := :NEW.id_rast;
      rec.status := :NEW.status;
      rec.ips_x := :NEW.ips_x;
      rec.ips_y := :NEW.ips_y;
      rec.ipcs_z := :NEW.ipcs_z;
      rec.ips_data_hora := :NEW.ips_data_hora;
      rec.gprs_latitude := :NEW.gprs_latitude;
      rec.gprs_longitude := :NEW.gprs_longitude;
      rec.gprs_altitude := :NEW.gprs_altitude;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_rast := :OLD.id_rast;
      rec.status := :OLD.status;
      rec.ips_x := :OLD.ips_x;
      rec.ips_y := :OLD.ips_y;
      rec.ipcs_z := :OLD.ipcs_z;
      rec.ips_data_hora := :OLD.ips_data_hora;
      rec.gprs_latitude := :OLD.gprs_latitude;
      rec.gprs_longitude := :OLD.gprs_longitude;
      rec.gprs_altitude := :OLD.gprs_altitude;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_RASTREAMENTO_JN VALUES rec;
  END;
 /

CREATE TABLE TB_VEICULO_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_veiculo NUMBER NOT NULL
 ,placa VARCHAR2 (10) NOT NULL
 ,renavam CHAR (11) NOT NULL
 ,chassi CHAR (17) NOT NULL
 ,fabricante VARCHAR2 (50) NOT NULL
 ,moldelo VARCHAR2 (60) NOT NULL -- Corrigido para modelo?
 ,motor VARCHAR2 (30)
 ,ano NUMBER(4) NOT NULL
 ,combustivel VARCHAR2 (20) NOT NULL
 ,status VARCHAR2 (20) NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_VEICULO_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_VEICULO for each row
 Declare
  rec TB_VEICULO_JN%ROWTYPE;
  blank TB_VEICULO_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_veiculo := :NEW.id_veiculo;
      rec.placa := :NEW.placa;
      rec.renavam := :NEW.renavam;
      rec.chassi := :NEW.chassi;
      rec.fabricante := :NEW.fabricante;
      rec.moldelo := :NEW.moldelo;
      rec.motor := :NEW.motor;
      rec.ano := :NEW.ano;
      rec.combustivel := :NEW.combustivel;
      rec.status := :NEW.status;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_veiculo := :OLD.id_veiculo;
      rec.placa := :OLD.placa;
      rec.renavam := :OLD.renavam;
      rec.chassi := :OLD.chassi;
      rec.fabricante := :OLD.fabricante;
      rec.moldelo := :OLD.moldelo;
      rec.motor := :OLD.motor;
      rec.ano := :OLD.ano;
      rec.combustivel := :OLD.combustivel;
      rec.status := :OLD.status;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_VEICULO_JN VALUES rec;
  END;
 /

CREATE TABLE TB_ZONA_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_zona NUMBER NOT NULL
 ,nome VARCHAR2 (50) NOT NULL
 ,status CHAR (1) NOT NULL
 ,data_entrada DATE NOT NULL
 ,data_saida DATE -- Alterado para NULLABLE
 ,observacao VARCHAR2 (100)
 );

CREATE OR REPLACE TRIGGER TB_ZONA_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_ZONA for each row
 Declare
  rec TB_ZONA_JN%ROWTYPE;
  blank TB_ZONA_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_zona := :NEW.id_zona;
      rec.nome := :NEW.nome;
      rec.status := :NEW.status;
      rec.data_entrada := :NEW.data_entrada;
      rec.data_saida := :NEW.data_saida;
      rec.observacao := :NEW.observacao;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_zona := :OLD.id_zona;
      rec.nome := :OLD.nome;
      rec.status := :OLD.status;
      rec.data_entrada := :OLD.data_entrada;
      rec.data_saida := :OLD.data_saida;
      rec.observacao := :OLD.observacao;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_ZONA_JN VALUES rec;
  END;
 /

-- Tabelas JN para tabelas de ligação (mantidas, verificar necessidade)

CREATE TABLE TB_CV_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_cv NUMBER NOT NULL
 ,TB_CLI_id_cli NUMBER NOT NULL
 ,TB_CLI_TB_END_C_id_endc NUMBER NOT NULL
 ,TB_CLI_TB_CONT_C_id_contc NUMBER NOT NULL
 ,TB_VEICULO_id_veiculo NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_CV_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_CV for each row
 Declare
  rec TB_CV_JN%ROWTYPE;
  blank TB_CV_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_cv := :NEW.id_cv;
      rec.TB_CLI_id_cli := :NEW.TB_CLI_id_cli;
      rec.TB_CLI_TB_END_C_id_endc := :NEW.TB_CLI_TB_END_C_id_endc;
      rec.TB_CLI_TB_CONT_C_id_contc := :NEW.TB_CLI_TB_CONT_C_id_contc;
      rec.TB_VEICULO_id_veiculo := :NEW.TB_VEICULO_id_veiculo;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_cv := :OLD.id_cv;
      rec.TB_CLI_id_cli := :OLD.TB_CLI_id_cli;
      rec.TB_CLI_TB_END_C_id_endc := :OLD.TB_CLI_TB_END_C_id_endc;
      rec.TB_CLI_TB_CONT_C_id_contc := :OLD.TB_CLI_TB_CONT_C_id_contc;
      rec.TB_VEICULO_id_veiculo := :OLD.TB_VEICULO_id_veiculo;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_CV_JN VALUES rec;
  END;
 /

CREATE TABLE TB_FP_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_FP NUMBER NOT NULL
 ,TB_FILIAL_id_fil NUMBER NOT NULL
 ,TB_PATIO_id_patio NUMBER NOT NULL
 ,TB_PATIO_id_contp NUMBER NOT NULL
 ,TB_PATIO_status CHAR (1) NOT NULL
 ,TB_FILIAL_TB_END_F_id_endf NUMBER NOT NULL
 ,TB_PATIO_id_endp NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_FP_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_FP for each row
 Declare
  rec TB_FP_JN%ROWTYPE;
  blank TB_FP_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_FP := :NEW.id_FP;
      rec.TB_FILIAL_id_fil := :NEW.TB_FILIAL_id_fil;
      rec.TB_PATIO_id_patio := :NEW.TB_PATIO_id_patio;
      rec.TB_PATIO_id_contp := :NEW.TB_PATIO_id_contp;
      rec.TB_PATIO_status := :NEW.TB_PATIO_status;
      rec.TB_FILIAL_TB_END_F_id_endf := :NEW.TB_FILIAL_TB_END_F_id_endf;
      rec.TB_PATIO_id_endp := :NEW.TB_PATIO_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_FP := :OLD.id_FP;
      rec.TB_FILIAL_id_fil := :OLD.TB_FILIAL_id_fil;
      rec.TB_PATIO_id_patio := :OLD.TB_PATIO_id_patio;
      rec.TB_PATIO_id_contp := :OLD.TB_PATIO_id_contp;
      rec.TB_PATIO_status := :OLD.TB_PATIO_status;
      rec.TB_FILIAL_TB_END_F_id_endf := :OLD.TB_FILIAL_TB_END_F_id_endf;
      rec.TB_PATIO_id_endp := :OLD.TB_PATIO_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_FP_JN VALUES rec;
  END;
 /

CREATE TABLE TB_FV_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_fv NUMBER NOT NULL
 ,TB_VEICULO_id_veiculo NUMBER NOT NULL
 ,TB_FILIAL_id_fil NUMBER NOT NULL
 ,TB_FILIAL_TB_END_F_id_endf NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_FV_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_FV for each row
 Declare
  rec TB_FV_JN%ROWTYPE;
  blank TB_FV_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_fv := :NEW.id_fv;
      rec.TB_VEICULO_id_veiculo := :NEW.TB_VEICULO_id_veiculo;
      rec.TB_FILIAL_id_fil := :NEW.TB_FILIAL_id_fil;
      rec.TB_FILIAL_TB_END_F_id_endf := :NEW.TB_FILIAL_TB_END_F_id_endf;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_fv := :OLD.id_fv;
      rec.TB_VEICULO_id_veiculo := :OLD.TB_VEICULO_id_veiculo;
      rec.TB_FILIAL_id_fil := :OLD.TB_FILIAL_id_fil;
      rec.TB_FILIAL_TB_END_F_id_endf := :OLD.TB_FILIAL_TB_END_F_id_endf;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_FV_JN VALUES rec;
  END;
 /

CREATE TABLE TB_VB_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_vb NUMBER NOT NULL
 ,TB_VEICULO_id_veiculo NUMBER NOT NULL
 ,TB_BOX_id_box NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_VB_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_VB for each row
 Declare
  rec TB_VB_JN%ROWTYPE;
  blank TB_VB_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_vb := :NEW.id_vb;
      rec.TB_VEICULO_id_veiculo := :NEW.TB_VEICULO_id_veiculo;
      rec.TB_BOX_id_box := :NEW.TB_BOX_id_box;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_vb := :OLD.id_vb;
      rec.TB_VEICULO_id_veiculo := :OLD.TB_VEICULO_id_veiculo;
      rec.TB_BOX_id_box := :OLD.TB_BOX_id_box;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_VB_JN VALUES rec;
  END;
 /

CREATE TABLE TB_VP_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_vp NUMBER NOT NULL
 ,TB_VEICULO_id_veiculo NUMBER NOT NULL
 ,TB_PATIO_id_patio NUMBER NOT NULL
 ,TB_PATIO_TB_CONT_P_id_contp NUMBER NOT NULL
 ,TB_PATIO_status CHAR (1) NOT NULL
 ,TB_PATIO_TB_END_P_id_endp NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_VP_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_VP for each row
 Declare
  rec TB_VP_JN%ROWTYPE;
  blank TB_VP_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_vp := :NEW.id_vp;
      rec.TB_VEICULO_id_veiculo := :NEW.TB_VEICULO_id_veiculo;
      rec.TB_PATIO_id_patio := :NEW.TB_PATIO_id_patio;
      rec.TB_PATIO_TB_CONT_P_id_contp := :NEW.TB_PATIO_TB_CONT_P_id_contp;
      rec.TB_PATIO_status := :NEW.TB_PATIO_status;
      rec.TB_PATIO_TB_END_P_id_endp := :NEW.TB_PATIO_TB_END_P_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_vp := :OLD.id_vp;
      rec.TB_VEICULO_id_veiculo := :OLD.TB_VEICULO_id_veiculo;
      rec.TB_PATIO_id_patio := :OLD.TB_PATIO_id_patio;
      rec.TB_PATIO_TB_CONT_P_id_contp := :OLD.TB_PATIO_TB_CONT_P_id_contp;
      rec.TB_PATIO_status := :OLD.TB_PATIO_status;
      rec.TB_PATIO_TB_END_P_id_endp := :OLD.TB_PATIO_TB_END_P_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_VP_JN VALUES rec;
  END;
 /

CREATE TABLE TB_VR_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_vr NUMBER NOT NULL
 ,TB_VEICULO_id_veiculo NUMBER NOT NULL
 ,TB_RASTREAMENTO_id_rast NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_VR_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_VR for each row
 Declare
  rec TB_VR_JN%ROWTYPE;
  blank TB_VR_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_vr := :NEW.id_vr;
      rec.TB_VEICULO_id_veiculo := :NEW.TB_VEICULO_id_veiculo;
      rec.TB_RASTREAMENTO_id_rast := :NEW.TB_RASTREAMENTO_id_rast;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_vr := :OLD.id_vr;
      rec.TB_VEICULO_id_veiculo := :OLD.TB_VEICULO_id_veiculo;
      rec.TB_RASTREAMENTO_id_rast := :OLD.TB_RASTREAMENTO_id_rast;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_VR_JN VALUES rec;
  END;
 /

CREATE TABLE TB_VZ_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_vz NUMBER NOT NULL
 ,TB_VEICULO_id_veiculo NUMBER NOT NULL
 ,TB_ZONA_id_zona NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_VZ_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_VZ for each row
 Declare
  rec TB_VZ_JN%ROWTYPE;
  blank TB_VZ_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_vz := :NEW.id_vz;
      rec.TB_VEICULO_id_veiculo := :NEW.TB_VEICULO_id_veiculo;
      rec.TB_ZONA_id_zona := :NEW.TB_ZONA_id_zona;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_vz := :OLD.id_vz;
      rec.TB_VEICULO_id_veiculo := :OLD.TB_VEICULO_id_veiculo;
      rec.TB_ZONA_id_zona := :OLD.TB_ZONA_id_zona;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_VZ_JN VALUES rec;
  END;
 /

CREATE TABLE TB_ZB_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_zb NUMBER NOT NULL
 ,TB_ZONA_id_zona NUMBER NOT NULL
 ,TB_BOX_id_box NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_ZB_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_ZB for each row
 Declare
  rec TB_ZB_JN%ROWTYPE;
  blank TB_ZB_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_zb := :NEW.id_zb;
      rec.TB_ZONA_id_zona := :NEW.TB_ZONA_id_zona;
      rec.TB_BOX_id_box := :NEW.TB_BOX_id_box;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_zb := :OLD.id_zb;
      rec.TB_ZONA_id_zona := :OLD.TB_ZONA_id_zona;
      rec.TB_BOX_id_box := :OLD.TB_BOX_id_box;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_ZB_JN VALUES rec;
  END;
 /

CREATE TABLE TB_ZP_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,id_zp NUMBER NOT NULL
 ,TB_PATIO_id_patio NUMBER NOT NULL
 ,TB_PATIO_TB_CONT_P_id_contp NUMBER NOT NULL
 ,TB_ZONA_id_zona NUMBER NOT NULL
 ,TB_PATIO_status CHAR (1) NOT NULL
 ,TB_PATIO_TB_END_P_id_endp NUMBER NOT NULL
 );

CREATE OR REPLACE TRIGGER TB_ZP_JNtrg
  AFTER
  INSERT OR
  UPDATE OR
  DELETE ON TB_ZP for each row
 Declare
  rec TB_ZP_JN%ROWTYPE;
  blank TB_ZP_JN%ROWTYPE;
  BEGIN
    rec := blank;
    IF INSERTING OR UPDATING THEN
      rec.id_zp := :NEW.id_zp;
      rec.TB_PATIO_id_patio := :NEW.TB_PATIO_id_patio;
      rec.TB_PATIO_TB_CONT_P_id_contp := :NEW.TB_PATIO_TB_CONT_P_id_contp;
      rec.TB_ZONA_id_zona := :NEW.TB_ZONA_id_zona;
      rec.TB_PATIO_status := :NEW.TB_PATIO_status;
      rec.TB_PATIO_TB_END_P_id_endp := :NEW.TB_PATIO_TB_END_P_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      IF INSERTING THEN
        rec.JN_OPERATION := 'INS';
      ELSIF UPDATING THEN
        rec.JN_OPERATION := 'UPD';
      END IF;
    ELSIF DELETING THEN
      rec.id_zp := :OLD.id_zp;
      rec.TB_PATIO_id_patio := :OLD.TB_PATIO_id_patio;
      rec.TB_PATIO_TB_CONT_P_id_contp := :OLD.TB_PATIO_TB_CONT_P_id_contp;
      rec.TB_ZONA_id_zona := :OLD.TB_ZONA_id_zona;
      rec.TB_PATIO_status := :OLD.TB_PATIO_status;
      rec.TB_PATIO_TB_END_P_id_endp := :OLD.TB_PATIO_TB_END_P_id_endp;
      rec.JN_DATETIME := SYSDATE;
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER');
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE');
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID');
      rec.JN_OPERATION := 'DEL';
    END IF;
    INSERT into TB_ZP_JN VALUES rec;
  END;
 /


-- Relatório do Resumo do Oracle SQL Developer Data Modeler:
--
-- CREATE TABLE                            44 -- (22 originais + 22 JN)
-- CREATE INDEX                            29 -- Adicionados
-- ALTER TABLE                             46 -- (PKs + FKs originais)
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           22 -- (Triggers JN)
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
-- CREATE SEQUENCE                          0 -- Removido
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