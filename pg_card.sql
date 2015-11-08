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

CREATE OR REPLACE FUNCTION playcard_value_as_int(card_id playcard)
    RETURNS int
    LANGUAGE sql
    AS $body$
        SELECT
            CASE substring(card_id for 1)
                WHEN 'A' THEN 1
                WHEN '2' THEN 2
                WHEN '3' THEN 3
                WHEN '4' THEN 4
                WHEN '5' THEN 5
                WHEN '6' THEN 6
                WHEN '7' THEN 7
                WHEN '8' THEN 8
                WHEN '9' THEN 9
                WHEN '0' THEN 10
                WHEN 'J' THEN 11
                WHEN 'Q' THEN 12
                WHEN 'K' THEN 13
                ELSE NULL -- for joker 'S_' and card back 'B_'
            END;
    $body$;


COMMIT;
