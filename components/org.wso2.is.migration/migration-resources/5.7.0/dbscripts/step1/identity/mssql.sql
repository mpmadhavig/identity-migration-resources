IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OAUTH2_ACCESS_TOKEN_AUDIT]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN_AUDIT (
            TOKEN_ID VARCHAR (255),
            ACCESS_TOKEN VARCHAR(2048),
            REFRESH_TOKEN VARCHAR(2048),
            CONSUMER_KEY_ID INTEGER,
            AUTHZ_USER VARCHAR (100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            USER_TYPE VARCHAR (25),
            GRANT_TYPE VARCHAR (50),
            TIME_CREATED DATETIME,
            REFRESH_TOKEN_TIME_CREATED DATETIME,
            VALIDITY_PERIOD BIGINT,
            REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
            TOKEN_SCOPE_HASH VARCHAR(32),
            TOKEN_STATE VARCHAR(25),
            TOKEN_STATE_ID VARCHAR (128) ,
            SUBJECT_IDENTIFIER VARCHAR(255),
            ACCESS_TOKEN_HASH VARCHAR(512),
            REFRESH_TOKEN_HASH VARCHAR(512),
            INVALIDATED_TIME DATETIME
);

IF NOT EXISTS(SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[SP_TEMPLATE]') AND TYPE IN (N'U'))
CREATE TABLE SP_TEMPLATE (
  ID         INTEGER NOT NULL IDENTITY,
  TENANT_ID  INTEGER  NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION VARCHAR(1023),
  CONTENT VARBINARY(MAX) DEFAULT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT SP_TEMPLATE_CONSTRAINT UNIQUE (TENANT_ID, NAME)
);
CREATE INDEX IDX_SP_TEMPLATE ON SP_TEMPLATE (TENANT_ID, NAME);

DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('SP_AUTH_SCRIPT') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'CONTENT' AND object_id = OBJECT_ID(N'SP_AUTH_SCRIPT'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE SP_AUTH_SCRIPT DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('SP_AUTH_SCRIPT') AND name='CONTENT')
EXEC('ALTER TABLE SP_AUTH_SCRIPT ALTER COLUMN CONTENT VARBINARY(MAX) NULL');

IF NOT EXISTS(SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_AUTH_WAIT_STATUS]') AND TYPE IN (N'U'))
CREATE TABLE IDN_AUTH_WAIT_STATUS (
  ID              INTEGER IDENTITY       NOT NULL,
  TENANT_ID       INTEGER                NOT NULL,
  LONG_WAIT_KEY   VARCHAR(255)           NOT NULL,
  WAIT_STATUS     CHAR(1) NOT NULL DEFAULT '1',
  TIME_CREATED    DATETIME,
  EXPIRE_TIME     DATETIME,
  PRIMARY KEY (ID),
  CONSTRAINT IDN_AUTH_WAIT_STATUS_KEY UNIQUE (LONG_WAIT_KEY)
);

-- todo fix
IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_SAML2_ARTIFACT_STORE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_SAML2_ARTIFACT_STORE (
  ID INTEGER NOT NULL IDENTITY,
  SOURCE_ID VARCHAR(255) NOT NULL,
  MESSAGE_HANDLER VARCHAR(255) NOT NULL,
  AUTHN_REQ_DTO VARBINARY(MAX) NOT NULL,
  SESSION_ID VARCHAR(255) NOT NULL,
  INIT_TIMESTAMP DATETIME NOT NULL,
  EXP_TIMESTAMP DATETIME NOT NULL,
  ASSERTION_ID VARCHAR(255),
  PRIMARY KEY (ID)
);



IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OIDC_SCOPE]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OIDC_SCOPE  (
  ID INTEGER IDENTITY,
  NAME VARCHAR(255),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_OIDC_SCOPE_CLAIM_MAPPING]') AND TYPE IN (N'U'))
CREATE TABLE IDN_OIDC_SCOPE_CLAIM_MAPPING (
  ID INTEGER IDENTITY,
  SCOPE_ID INTEGER ,
  EXTERNAL_CLAIM_ID INTEGER ,
  PRIMARY KEY (ID),
  FOREIGN KEY (SCOPE_ID) REFERENCES  IDN_OIDC_SCOPE(ID) ON DELETE CASCADE,
  FOREIGN KEY (EXTERNAL_CLAIM_ID) REFERENCES  IDN_CLAIM(ID) ON DELETE CASCADE
);

CREATE INDEX IDX_AT_SI_ECI ON IDN_OIDC_SCOPE_CLAIM_MAPPING(SCOPE_ID, EXTERNAL_CLAIM_ID);

ALTER TABLE IDN_OAUTH2_SCOPE ADD SCOPE_TYPE VARCHAR(255) NOT NULL DEFAULT 'OAUTH2';

DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('IDN_OAUTH_CONSUMER_APPS') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'USER_ACCESS_TOKEN_EXPIRE_TIME' AND object_id = OBJECT_ID(N'IDN_OAUTH_CONSUMER_APPS'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP CONSTRAINT ' + @ConstraintName)
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD CONSTRAINT ' + @ConstraintName + ' DEFAULT 3600 FOR USER_ACCESS_TOKEN_EXPIRE_TIME');

DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('IDN_OAUTH_CONSUMER_APPS') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'APP_ACCESS_TOKEN_EXPIRE_TIME' AND object_id = OBJECT_ID(N'IDN_OAUTH_CONSUMER_APPS'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP CONSTRAINT ' + @ConstraintName)
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD CONSTRAINT ' + @ConstraintName + ' DEFAULT 3600 FOR APP_ACCESS_TOKEN_EXPIRE_TIME');

DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('IDN_OAUTH_CONSUMER_APPS') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'REFRESH_TOKEN_EXPIRE_TIME' AND object_id = OBJECT_ID(N'IDN_OAUTH_CONSUMER_APPS'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP CONSTRAINT ' + @ConstraintName)
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD CONSTRAINT ' + @ConstraintName + ' DEFAULT 84600 FOR REFRESH_TOKEN_EXPIRE_TIME');

DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS WHERE PARENT_OBJECT_ID = OBJECT_ID('IDN_OAUTH_CONSUMER_APPS') AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'ID_TOKEN_EXPIRE_TIME' AND object_id = OBJECT_ID(N'IDN_OAUTH_CONSUMER_APPS'))
IF @ConstraintName IS NOT NULL
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS DROP CONSTRAINT ' + @ConstraintName)
EXEC('ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD CONSTRAINT ' + @ConstraintName + ' DEFAULT 3600 FOR ID_TOKEN_EXPIRE_TIME');

IF NOT EXISTS (SELECT * FROM SYS.indexes WHERE name = 'IDX_AT_RTH' and object_id = OBJECT_ID('IDN_OAUTH2_ACCESS_TOKEN'))
CREATE INDEX IDX_AT_RTH ON IDN_OAUTH2_ACCESS_TOKEN(REFRESH_TOKEN_HASH);