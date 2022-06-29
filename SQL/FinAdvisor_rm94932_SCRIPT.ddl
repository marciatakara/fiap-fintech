-- Gerado por Oracle SQL Developer Data Modeler 21.4.1.349.1605
--   em:        2022-05-20 12:20:05 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE t_banco (
    cd_banco NUMBER(6) NOT NULL,
    nm_banco VARCHAR2(30 CHAR) NOT NULL
);

ALTER TABLE t_banco ADD CONSTRAINT t_banco_pk PRIMARY KEY ( cd_banco );

CREATE TABLE t_categ_gasto (
    cd_categ_gasto NUMBER(6) NOT NULL,
    ds_categ_gasto VARCHAR2(30 CHAR) NOT NULL
);

ALTER TABLE t_categ_gasto ADD CONSTRAINT t_categ_gasto_pk PRIMARY KEY ( cd_categ_gasto );

CREATE TABLE t_categ_invest (
    cd_categ_invest NUMBER(6) NOT NULL,
    ds_categ_invest VARCHAR2(30 CHAR) NOT NULL
);

ALTER TABLE t_categ_invest ADD CONSTRAINT t_categ_invest_pk PRIMARY KEY ( cd_categ_invest );

CREATE TABLE t_gasto (
    t_operacao_cd_operacao       NUMBER(6) NOT NULL,
    ds_forma_pgto                VARCHAR2(30 CHAR),
    t_categ_gasto_cd_categ_gasto NUMBER(6) NOT NULL,
    t_loja_cd_loja               NUMBER(6) NOT NULL
);

ALTER TABLE t_gasto ADD CONSTRAINT t_gasto_pk PRIMARY KEY ( t_operacao_cd_operacao );

CREATE TABLE t_invest (
    t_operacao_cd_operacao         NUMBER(6) NOT NULL,
    t_categ_invest_cd_categ_invest NUMBER(6) NOT NULL,
    t_banco_cd_banco               NUMBER(6) NOT NULL
);

ALTER TABLE t_invest ADD CONSTRAINT t_invest_pk PRIMARY KEY ( t_operacao_cd_operacao );

CREATE TABLE t_loja (
    cd_loja NUMBER(6) NOT NULL,
    nm_loja VARCHAR2(30 CHAR) NOT NULL
);

ALTER TABLE t_loja ADD CONSTRAINT t_loja_pk PRIMARY KEY ( cd_loja );

CREATE TABLE t_oper_usuario (
    t_usuario_cd_usuario   NUMBER(6) NOT NULL,
    t_operacao_cd_operacao NUMBER(6) NOT NULL
);

ALTER TABLE t_oper_usuario ADD CONSTRAINT t_oper_usuario_pk PRIMARY KEY ( t_usuario_cd_usuario,
                                                                          t_operacao_cd_operacao );

CREATE TABLE t_operacao (
    cd_operacao              NUMBER(6) NOT NULL,
    vl_operacao              NUMBER(20) NOT NULL,
    dt_operacao              DATE NOT NULL,
    t_tipo_oper_cd_tipo_oper NUMBER(6) NOT NULL,
    ds_operacao              VARCHAR2(30 CHAR)
);

ALTER TABLE t_operacao ADD CONSTRAINT t_operacao_pk PRIMARY KEY ( cd_operacao );

CREATE TABLE t_tipo_oper (
    cd_tipo_oper NUMBER(6) NOT NULL,
    ds_tipo_oper VARCHAR2(30) NOT NULL
);

COMMENT ON COLUMN t_tipo_oper.cd_tipo_oper IS
    'entrada/saida
';

ALTER TABLE t_tipo_oper ADD CONSTRAINT t_tipo_oper_pk PRIMARY KEY ( cd_tipo_oper );

CREATE TABLE t_usuario (
    cd_usuario    NUMBER(6) NOT NULL,
    ds_email      VARCHAR2(254 CHAR) NOT NULL,
    ds_senha      VARCHAR2(10 CHAR) NOT NULL,
    ds_dica_senha VARCHAR2(30 CHAR)
);

ALTER TABLE t_usuario ADD CONSTRAINT t_usuario_pk PRIMARY KEY ( cd_usuario );

ALTER TABLE t_gasto
    ADD CONSTRAINT t_gasto_t_categ_gasto_fk FOREIGN KEY ( t_categ_gasto_cd_categ_gasto )
        REFERENCES t_categ_gasto ( cd_categ_gasto );

ALTER TABLE t_gasto
    ADD CONSTRAINT t_gasto_t_loja_fk FOREIGN KEY ( t_loja_cd_loja )
        REFERENCES t_loja ( cd_loja );

ALTER TABLE t_gasto
    ADD CONSTRAINT t_gasto_t_operacao_fk FOREIGN KEY ( t_operacao_cd_operacao )
        REFERENCES t_operacao ( cd_operacao );

ALTER TABLE t_invest
    ADD CONSTRAINT t_invest_t_banco_fk FOREIGN KEY ( t_banco_cd_banco )
        REFERENCES t_banco ( cd_banco );

ALTER TABLE t_invest
    ADD CONSTRAINT t_invest_t_categ_invest_fk FOREIGN KEY ( t_categ_invest_cd_categ_invest )
        REFERENCES t_categ_invest ( cd_categ_invest );

ALTER TABLE t_invest
    ADD CONSTRAINT t_invest_t_operacao_fk FOREIGN KEY ( t_operacao_cd_operacao )
        REFERENCES t_operacao ( cd_operacao );

ALTER TABLE t_oper_usuario
    ADD CONSTRAINT t_oper_usuario_t_operacao_fk FOREIGN KEY ( t_operacao_cd_operacao )
        REFERENCES t_operacao ( cd_operacao );

ALTER TABLE t_oper_usuario
    ADD CONSTRAINT t_oper_usuario_t_usuario_fk FOREIGN KEY ( t_usuario_cd_usuario )
        REFERENCES t_usuario ( cd_usuario );

ALTER TABLE t_operacao
    ADD CONSTRAINT t_operacao_t_tipo_oper_fk FOREIGN KEY ( t_tipo_oper_cd_tipo_oper )
        REFERENCES t_tipo_oper ( cd_tipo_oper );

CREATE OR REPLACE TRIGGER arc_arc_1_t_gasto BEFORE
    INSERT OR UPDATE OF t_operacao_cd_operacao ON t_gasto
    FOR EACH ROW
DECLARE
    d NUMBER(6);
BEGIN
    SELECT
        a.t_tipo_oper_cd_tipo_oper
    INTO d
    FROM
        t_operacao a
    WHERE
        a.cd_operacao = :new.t_operacao_cd_operacao;

    IF ( d IS NULL OR d <> 2 ) THEN
        raise_application_error(
                               -20223,
                               'FK T_GASTO_T_OPERACAO_FK in Table T_GASTO violates Arc constraint on Table T_OPERACAO - discriminator column T_TIPO_OPER_cd_tipo_oper doesn''t have value 2'
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_arc_1_t_invest BEFORE
    INSERT OR UPDATE OF t_operacao_cd_operacao ON t_invest
    FOR EACH ROW
DECLARE
    d NUMBER(6);
BEGIN
    SELECT
        a.t_tipo_oper_cd_tipo_oper
    INTO d
    FROM
        t_operacao a
    WHERE
        a.cd_operacao = :new.t_operacao_cd_operacao;

    IF ( d IS NULL OR d <> 1 ) THEN
        raise_application_error(
                               -20223,
                               'FK T_INVEST_T_OPERACAO_FK in Table T_INVEST violates Arc constraint on Table T_OPERACAO - discriminator column T_TIPO_OPER_cd_tipo_oper doesn''t have value 1'
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            10
-- CREATE INDEX                             0
-- ALTER TABLE                             19
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
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
