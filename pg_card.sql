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

CREATE OR REPLACE FUNCTION playcard_value_as_string(card_id playcard)
    RETURNS varchar(5)
    LANGUAGE sql
    AS $body$
        SELECT
            CASE substring(card_id for 1)
                WHEN 'A' THEN 'ace'
                WHEN '2' THEN 'two'
                WHEN '3' THEN 'three'
                WHEN '4' THEN 'four'
                WHEN '5' THEN 'five'
                WHEN '6' THEN 'six'
                WHEN '7' THEN 'seven'
                WHEN '8' THEN 'eight'
                WHEN '9' THEN 'nine'
                WHEN '0' THEN 'ten'
                WHEN 'J' THEN 'jack'
                WHEN 'Q' THEN 'queen'
                WHEN 'K' THEN 'king'
                WHEN 'S' THEN 'joker'
                WHEN 'B' THEN 'back'
                ELSE NULL
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_value_as_string_with_ints(card_id playcard)
    RETURNS varchar(5)
    LANGUAGE sql
    AS $body$
        SELECT
            CASE substring(card_id for 1)
                WHEN 'A' THEN 'ace'
                WHEN '0' THEN '10'
                WHEN 'J' THEN 'jack'
                WHEN 'Q' THEN 'queen'
                WHEN 'K' THEN 'king'
                WHEN 'S' THEN 'joker'
                WHEN 'B' THEN 'back'
                ELSE substring(card_id for 1)
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_value_as_symbol(card_id playcard)
    RETURNS char(2)
    LANGUAGE sql
    AS $body$
        SELECT
            CASE substring(card_id for 1)
                WHEN '0' THEN '10'
                WHEN 'S' THEN '★'
                WHEN 'B' THEN '#'
                ELSE substring(card_id for 1)
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_suit_as_string(card_id playcard)
    RETURNS playcard_suit_enum
    LANGUAGE sql
    AS $body$
       SELECT
            CASE (
                CASE substring(card_id for 1)
                    WHEN 'S' THEN NULL
                    WHEN 'B' THEN NULL
                    ELSE substring(card_id from 2 for 1)
                END
            )
                WHEN 'H' THEN 'hearts'
                WHEN 'D' THEN 'diamonds'
                WHEN 'C' THEN 'clubs'
                WHEN 'S' THEN 'spades'
                ELSE NULL :: playcard_suit_enum
            END;
    $body$;

COMMIT;
