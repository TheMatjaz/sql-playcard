-- pg_card installer script

START TRANSACTION;

DROP DOMAIN IF EXISTS playcard;
CREATE DOMAIN playcard
    AS char(2)
    DEFAULT 'BC' -- card back
    CONSTRAINT playcard_format
        CHECK (VALUE ~ '[AJQK234567890BS][HDCS]');

COMMIT;
