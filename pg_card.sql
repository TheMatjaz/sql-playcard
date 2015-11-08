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

CREATE OR REPLACE FUNCTION playcard_suit_as_symbol(card_id playcard)
    RETURNS char(1)
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
                WHEN 'H' THEN '♥'
                WHEN 'D' THEN '♦'
                WHEN 'C' THEN '♣'
                WHEN 'S' THEN '♠'
                ELSE NULL
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_suit_color(card_id playcard)
    RETURNS playcard_color_enum
    LANGUAGE sql
    AS $body$
        SELECT
            CASE (
                CASE substring(card_id for 1)
                    WHEN 'B' THEN NULL
                    ELSE substring(card_id from 2 for 1)
                END
            )
                WHEN 'H' THEN 'red'
                WHEN 'D' THEN 'red'
                WHEN 'C' THEN 'black'
                WHEN 'S' THEN 'black'
                ELSE NULL :: playcard_color_enum
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_value_and_suit_string(
    card_id playcard 
    , delimiter text DEFAULT NULL
    , brackets char(2) DEFAULT NULL)
    RETURNS text
    LANGUAGE sql
    AS $body$
        SELECT
            concat(
                substring(brackets for 1)
                , format('%s', playcard_value_as_symbol(card_id))
                , delimiter
                , format('%s', playcard_suit_as_symbol(card_id))
                , substring(brackets from 2 for 1)
                );
    $body$;

CREATE OR REPLACE FUNCTION playcard_full_name(card_id playcard)
    RETURNS varchar(17)
    LANGUAGE sql
    AS $body$
        SELECT
            CASE substring(card_id for 1)
                WHEN 'S' THEN playcard_suit_color(card_id) || ' joker'
                WHEN 'B' THEN 'card back'
                ELSE playcard_value_as_string(card_id)
                     || ' of '
                     || playcard_suit_as_string(card_id)
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_full_name_with_int(card_id playcard)
    RETURNS varchar(17)
    LANGUAGE sql
    AS $body$
        SELECT
            CASE substring(card_id for 1)
                WHEN 'S' THEN playcard_suit_color(card_id) || ' joker'
                WHEN 'B' THEN 'card back'
                ELSE playcard_value_as_string_with_ints(card_id)
                     || ' of '
                     || playcard_suit_as_string(card_id)
            END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_from_full_name(name varchar(17))
    RETURNS playcard
    LANGUAGE plpgsql
    AS $body$
    DECLARE
        value char(1);
        suit char(1);
        name_array varchar(10)[];
        returnable playcard;
    BEGIN
        name = trim(both from lower(name));
        name = regexp_replace(name, '[[:punct:]]|of', '', 'g');
        IF (position('back' in name) > 0) THEN
            RETURN 'BH' :: playcard;
        ELSIF (position('joker' in name) > 0) THEN
            IF (position('red' in name) > 0) THEN
                RETURN 'SH' :: playcard;
            ELSIF (position('black' in name) > 0) THEN
                RETURN 'SS' :: playcard;
            ELSE
                RAISE EXCEPTION 'Illegal playcard full name: % (joker is not red nor black)', name
                    USING HINT = 'Try with "red joker" or "joker black".';
            END IF;
        ELSE
            name_array = regexp_split_to_array(name, E'\\s+');
            value = 
                CASE name_array[1]
                    WHEN 'ace'   THEN 'A'
                    WHEN 'two'   THEN '2'
                    WHEN 'three' THEN '3'
                    WHEN 'four'  THEN '4'
                    WHEN 'five'  THEN '5'
                    WHEN 'six'   THEN '6'
                    WHEN 'seven' THEN '7'
                    WHEN 'eight' THEN '8'
                    WHEN 'nine'  THEN '9'
                    WHEN 'ten'   THEN '0'
                    WHEN '10'    THEN '0'
                    WHEN 'ace'   THEN 'A'
                    WHEN 'jack'  THEN 'J'
                    WHEN 'queen' THEN 'Q'
                    WHEN 'king'  THEN 'K'
                    WHEN 'joker' THEN 'S'
                    ELSE upper(substring(name_array[1] for 1))
                END;
            suit =
                CASE name_array[2]
                    WHEN 'hearts'   THEN 'H'
                    WHEN 'diamonds' THEN 'D'
                    WHEN 'clubs'    THEN 'C'
                    WHEN 'spades'   THEN 'S'
                    ELSE NULL
                END;
        END IF;
        returnable = (value || suit) :: playcard;
        IF (returnable IS NOT NULL) THEN
            RETURN returnable;
        ELSE
            RAISE EXCEPTION 'Illegal playcard full name: % (wrong syntax)', name
                USING HINT = 
                'The input should be similar to the output of  `playcard_full'
                || '_name(playcard)`, something like "ace of spades", "five '
                || 'diamonds", "3 clubs", "card back" or "red joker".';
        END IF;
    END;
    $body$;

CREATE OR REPLACE FUNCTION playcard_draw_card(card_id playcard)
    RETURNS text
    LANGUAGE sql
    AS $body$
        SELECT 
            concat(
                E'┌──────┐\n'
                , '│ '
                , format('%-2s', playcard_value_as_symbol(card_id))
                , format('%2s', playcard_suit_as_symbol(card_id))
                , E' │\n'
                , E'│      │\n'
                , E'│      │\n'
                , '│ '
                , format('%-2s', playcard_suit_as_symbol(card_id))
                , format('%2s', playcard_value_as_symbol(card_id))
                , E' │\n'    
                , '└──────┘'
                );
    $body$;

DROP TABLE IF EXISTS playcards;
CREATE TABLE playcards (
    card_id playcard PRIMARY KEY,
    unicode_char char(1) NOT NULL UNIQUE
    );

INSERT INTO playcards (card_id, unicode_char) VALUES 
('AH', '🂱'), ('2H', '🂲'), ('3H', '🂳'), ('4H', '🂴'), ('5H', '🂵'),
('6H', '🂶'), ('7H', '🂷'), ('8H', '🂸'), ('9H', '🂹'), ('0H', '🂺'),
('JH', '🂻'), ('QH', '🂽'), ('KH', '🂾'),

('AD', '🃁'), ('2D', '🃂'), ('3D', '🃃'), ('4D', '🃄'), ('5D', '🃅'),
('6D', '🃆'), ('7D', '🃇'), ('8D', '🃈'), ('9D', '🃉'), ('0D', '🃊'),
('JD', '🃋'), ('QD', '🃍'), ('KD', '🃎'),

('AC', '🃑'), ('2C', '🃒'), ('3C', '🃓'), ('4C', '🃔'), ('5C', '🃕'),
('6C', '🃖'), ('7C', '🃗'), ('8C', '🃘'), ('9C', '🃙'), ('0C', '🃚'),
('JC', '🃛'), ('QC', '🃝'), ('KC', '🃞'),

('AS', '🂡'), ('2S', '🂢'), ('3S', '🂣'), ('4S', '🂤'), ('5S', '🂥'),
('6S', '🂦'), ('7S', '🂧'), ('8S', '🂨'), ('9S', '🂩'), ('0S', '🂪'),
('JS', '🂫'), ('QS', '🂭'), ('KS', '🂮'),

('SH', '🃟'), ('SS', '🃏'), ('BC', '🂠');

CREATE OR REPLACE VIEW playcards_vw_full AS
    SELECT
        p.card_id
        , p.unicode_char
        , playcard_value_as_int(p.card_id) :: smallint
            AS value_smallint
        , playcard_value_as_string(p.card_id)
            AS value_string
        , playcard_suit_as_symbol(p.card_id)
            AS suit_symbol
        , playcard_suit_as_string(p.card_id)
            AS suit_string
        , playcard_suit_color(p.card_id)
            AS suit_color
        , playcard_full_name(p.card_id)
            AS full_name
        , playcard_full_name_with_int(p.card_id)
            AS full_name_int
        , playcard_value_suit_pair_string(p.card_id)
            AS value_suit_pair
        , playcard_draw_card(p.card_id)
            AS drawn_card
        FROM playcards AS p;

COMMIT;
