CREATE PROCEDURE skip_index_if_exists(indexName varchar(64), tableName varchar(64), tableColumns varchar(255))
BEGIN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN
        END;
        SET @s = CONCAT('CREATE INDEX ', indexName, ' ON ', tableName, tableColumns); PREPARE stmt FROM @s;
        EXECUTE stmt;
    END;
END;

CALL skip_index_if_exists('IDX_TK_VALUE_TYPE', 'IDN_OAUTH2_TOKEN_BINDING', '(TOKEN_BINDING_VALUE, TOKEN_BINDING_TYPE)');

DROP PROCEDURE IF EXISTS skip_index_if_exists;


-- --------------------------- INDEX CREATION -----------------------------

-- IDN_OIDC_PROPERTY --
CREATE INDEX IDX_IOP_CK ON IDN_OIDC_PROPERTY(CONSUMER_KEY);

-- --------------------------- REMOVE UNUSED INDICES -----------------------------

-- IDN_OAUTH2_ACCESS_TOKEN --
DROP INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN;

DROP INDEX IDX_AT_AU_TID_UD_TS_CKID ON IDN_OAUTH2_ACCESS_TOKEN;

DROP INDEX IDX_AT_AU_CKID_TS_UT ON IDN_OAUTH2_ACCESS_TOKEN;

-- IDN_OIDC_PROPERTY --
DROP INDEX IDX_IOP_TID_CK ON IDN_OIDC_PROPERTY;
