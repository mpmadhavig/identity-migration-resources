CREATE TABLE IF NOT EXISTS IDN_OAUTH2_USER_CONSENT (
    ID INTEGER NOT NULL AUTO_INCREMENT,
    USER_ID VARCHAR(255) NOT NULL,
    APP_ID CHAR(36) NOT NULL,
    TENANT_ID INTEGER NOT NULL DEFAULT -1,
    CONSENT_ID VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (APP_ID) REFERENCES SP_APP(UUID) ON DELETE CASCADE,
    UNIQUE (USER_ID, APP_ID, TENANT_ID),
    UNIQUE (CONSENT_ID)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_USER_CONSENTED_SCOPES (
    ID INTEGER NOT NULL AUTO_INCREMENT,
    CONSENT_ID VARCHAR(255) NOT NULL,
    TENANT_ID INTEGER NOT NULL DEFAULT -1,
    SCOPE VARCHAR(255) NOT NULL,
    CONSENT BOOLEAN NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (CONSENT_ID) REFERENCES IDN_OAUTH2_USER_CONSENT(CONSENT_ID) ON DELETE CASCADE,
    UNIQUE (CONSENT_ID, SCOPE)
);
