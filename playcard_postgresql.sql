-------------------------------------------------------------------------------
-- French playable cards (for Poker) representation in SQL for PostgreSQL
--
-- This SQL script contains is a relly simple but comprehensive representation 
-- of a standard french playable card (those used in Poker). Be sure to use
-- an UTF-8 database to fully support the unicode characters for the cards.
-- 
-- For more information and versions of this script for other RDBMS, visit the
-- GitHub repository of the project: https://github.com/TheMatjaz/pg_playcard
-------------------------------------------------------------------------------
-- Copyright © 2016, Matjaž Guštin <dev@matjaz.it> matjaz.it
--
-- This source code is subject to the terms of the BSD 3-clause license. If a 
-- copy of the license was not distributed with this file, you can obtain one 
-- at http://directory.fsf.org/wiki/License:BSD_3Clause
-------------------------------------------------------------------------------

START TRANSACTION;


CREATE OR REPLACE FUNCTION is_empty_or_space(string text)
    RETURNS BOOLEAN
    RETURNS NULL ON NULL INPUT
    IMMUTABLE
    LANGUAGE sql
    AS $body$
        SELECT string ~ '^[[:space:]]*$';
    $body$;


DROP TYPE IF EXISTS playcard_enum_color CASCADE;
CREATE TYPE playcard_enum_color
    AS ENUM ('red', 'black');


DROP TYPE IF EXISTS playcard_enum_suit CASCADE;
CREATE TYPE playcard_enum_suit
    AS ENUM ('hearts', 'diamonds', 'clubs', 'spades');


DROP TYPE IF EXISTS playcard_enum_value CASCADE;
CREATE TYPE playcard_enum_value
    AS ENUM ('ace',  'two',   'three',  'four',  'five',
             'six',  'seven', 'eight',  'nine',  'ten',
             'jack', 'queen', 'king',   'joker');


DROP TABLE IF EXISTS playcards;
CREATE TABLE playcards (
    id             smallint
  , value_smallint smallint            -- NULL when Joker or covered card
  , value_text     playcard_enum_value -- NULL when Joker or covered card
  , value_symbol   char(2)             -- NULL when Joker or covered card
  , suit_symbol    char(1)             -- NULL when Joker or covered card
  , suit_text      playcard_enum_suit  -- NULL when Joker or covered card
  , suit_color     playcard_enum_color -- NULL when Joker or covered card
  , unicode_char   char(1)             NOT NULL UNIQUE

  , PRIMARY KEY (id)
  , CONSTRAINT playcard_id_range
        CHECK (id >= 0 AND id <= 54)
  , CONSTRAINT value_smallint_range
        CHECK (value_smallint > 0 AND value_smallint <= 13)
  , CONSTRAINT value_symbol_not_empty
        CHECK (NOT is_empty_or_space(value_symbol))
  , CONSTRAINT suit_symbol_not_empty
        CHECK (NOT is_empty_or_space(suit_symbol))
  , CONSTRAINT unicode_char_not_empty
        CHECK (NOT is_empty_or_space(unicode_char))
    );


CREATE VIEW vw_playcards AS
    SELECT
        id
      , value_smallint
      , value_text
      , value_symbol
      , suit_symbol
      , suit_text
      , suit_color
      , CASE id
            WHEN 53 THEN value_symbol
            WHEN 54 THEN value_symbol
            WHEN  0 THEN '#'
            ELSE value_symbol || suit_symbol
        END AS full_symbol
      , CASE id
            WHEN 53 THEN suit_color || ' ' || value_text
            WHEN 54 THEN suit_color || ' ' || value_text
            WHEN  0 THEN 'card back'
            ELSE value_text || ' of ' || suit_text
        END AS full_name
      , unicode_char
        FROM playcards;


INSERT INTO playcards 
(id, value_smallint, value_text, value_symbol, suit_symbol, 
    suit_text, suit_color, unicode_char)
VALUES
    -- HEARTS
    ( 1,  1, 'ace',   'A', '♥', 'hearts',   'red',   '🂱')
  , ( 2,  2, 'two',   '2', '♥', 'hearts',   'red',   '🂲')
  , ( 3,  3, 'three', '3', '♥', 'hearts',   'red',   '🂳')
  , ( 4,  4, 'four',  '4', '♥', 'hearts',   'red',   '🂴')
  , ( 5,  5, 'five',  '5', '♥', 'hearts',   'red',   '🂵')
  , ( 6,  6, 'six',   '6', '♥', 'hearts',   'red',   '🂶')
  , ( 7,  7, 'seven', '7', '♥', 'hearts',   'red',   '🂷')
  , ( 8,  8, 'eight', '8', '♥', 'hearts',   'red',   '🂸')
  , ( 9,  9, 'nine',  '9', '♥', 'hearts',   'red',   '🂹')
  , (10, 10, 'ten',  '10', '♥', 'hearts',   'red',   '🂺')
  , (11, 11, 'jack',  'J', '♥', 'hearts',   'red',   '🂻')
  , (12, 12, 'queen', 'Q', '♥', 'hearts',   'red',   '🂽')
  , (13, 13, 'king',  'K', '♥', 'hearts',   'red',   '🂾')

    -- DIAMONDS
  , (14,  1, 'ace',   'A', '♦', 'diamonds', 'red',   '🃁')
  , (15,  2, 'two',   '2', '♦', 'diamonds', 'red',   '🃂')
  , (16,  3, 'three', '3', '♦', 'diamonds', 'red',   '🃃')
  , (17,  4, 'four',  '4', '♦', 'diamonds', 'red',   '🃄')
  , (18,  5, 'five',  '5', '♦', 'diamonds', 'red',   '🃅')
  , (19,  6, 'six',   '6', '♦', 'diamonds', 'red',   '🃆')
  , (20,  7, 'seven', '7', '♦', 'diamonds', 'red',   '🃇')
  , (21,  8, 'eight', '8', '♦', 'diamonds', 'red',   '🃈')
  , (22,  9, 'nine',  '9', '♦', 'diamonds', 'red',   '🃉')
  , (23, 10, 'ten',  '10', '♦', 'diamonds', 'red',   '🃊')
  , (24, 11, 'jack',  'J', '♦', 'diamonds', 'red',   '🃋')
  , (25, 12, 'queen', 'Q', '♦', 'diamonds', 'red',   '🃍')
  , (26, 13, 'king',  'K', '♦', 'diamonds', 'red',   '🃎')

    -- CLUBS
  , (27,  1, 'ace',   'A', '♣', 'clubs',    'black', '🃑')
  , (28,  2, 'two',   '2', '♣', 'clubs',    'black', '🃒')
  , (29,  3, 'three', '3', '♣', 'clubs',    'black', '🃓')
  , (30,  4, 'four',  '4', '♣', 'clubs',    'black', '🃔')
  , (31,  5, 'five',  '5', '♣', 'clubs',    'black', '🃕')
  , (32,  6, 'six',   '6', '♣', 'clubs',    'black', '🃖')
  , (33,  7, 'seven', '7', '♣', 'clubs',    'black', '🃗')
  , (34,  8, 'eight', '8', '♣', 'clubs',    'black', '🃘')
  , (35,  9, 'nine',  '9', '♣', 'clubs',    'black', '🃙')
  , (36, 10, 'ten',  '10', '♣', 'clubs',    'black', '🃚')
  , (37, 11, 'jack',  'J', '♣', 'clubs',    'black', '🃛')
  , (38, 12, 'queen', 'Q', '♣', 'clubs',    'black', '🃝')
  , (39, 13, 'king',  'K', '♣', 'clubs',    'black', '🃞')

    -- SPADES
  , (40,  1, 'ace',   'A', '♠', 'spades',   'black', '🂡')
  , (41,  2, 'two',   '2', '♠', 'spades',   'black', '🂢')
  , (42,  3, 'three', '3', '♠', 'spades',   'black', '🂣')
  , (43,  4, 'four',  '4', '♠', 'spades',   'black', '🂤')
  , (44,  5, 'five',  '5', '♠', 'spades',   'black', '🂥')
  , (45,  6, 'six',   '6', '♠', 'spades',   'black', '🂦')
  , (46,  7, 'seven', '7', '♠', 'spades',   'black', '🂧')
  , (47,  8, 'eight', '8', '♠', 'spades',   'black', '🂨')
  , (48,  9, 'nine',  '9', '♠', 'spades',   'black', '🂩')
  , (49, 10, 'ten',  '10', '♠', 'spades',   'black', '🂪')
  , (50, 11, 'jack',  'J', '♠', 'spades',   'black', '🂫')
  , (51, 12, 'queen', 'Q', '♠', 'spades',   'black', '🂭')
  , (52, 13, 'king',  'K', '♠', 'spades',   'black', '🂮')

    -- JOKERS
  , (53, NULL, 'joker', '☆', NULL, NULL, 'red',   '🃟')
  , (54, NULL, 'joker', '★', NULL, NULL, 'black', '🃏')

    -- COVERED CARD / BACK OF A CARD
  , ( 0, NULL, NULL, NULL, NULL, NULL, NULL, '🂠')
  ;


COMMIT;

VACUUM FULL ANALYZE playcards;
