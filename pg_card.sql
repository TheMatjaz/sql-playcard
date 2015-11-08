-- pg_card installer script

START TRANSACTION;

DROP DOMAIN IF EXISTS playcard;
CREATE DOMAIN playcard
    AS char(2)
    DEFAULT 'BC' -- card back
    CONSTRAINT playcard_format
        CHECK (VALUE ~ '[AJQK234567890BS][HDCS]');

DROP TYPE IF EXISTS playcard_color_enum;
CREATE TYPE playcard_color_enum
    AS ENUM ('red', 'black');

DROP TYPE IF EXISTS playcard_suit_enum;
CREATE TYPE playcard_suit_enum
    AS ENUM ('hearts', 'diamonds', 'clubs', 'spades');

COMMIT;
