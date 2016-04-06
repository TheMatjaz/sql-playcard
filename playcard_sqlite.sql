-------------------------------------------------------------------------------
-- French playable cards (for Poker) representation in SQL for SQLite
--
-- This SQLite script contains is a relly simple but comprehensive 
-- representation of a standard french playable card (those used in Poker). 
-- Be sure to use an UTF-8 database to fully support the unicode characters 
-- for the cards.
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

PRAGMA foreign_keys = ON;


BEGIN;


DROP VIEW IF EXISTS vw_playcards;
DROP TABLE IF EXISTS playcards;
DROP TABLE IF EXISTS enums_playcard_strings;


CREATE TABLE enums_playcard_strings (
    id     integer PRIMARY KEY
  , string text    NOT NULL UNIQUE

  , CONSTRAINT not_empty_string
        CHECK (length(string) > 0)
    );


CREATE INDEX idx_enums_playcard
    ON enums_playcard_strings (string);


CREATE TABLE playcards (
    id             integer
  , value_int      integer    -- NULL when Joker or covered card
  , fk_value_text  integer    -- NULL when Joker or covered card
  , value_symbol   char(2)    -- NULL when Joker or covered card
  , suit_symbol    char(1)    -- NULL when Joker or covered card
  , fk_suit_text   integer    -- NULL when Joker or covered card
  , fk_suit_color  integer    -- NULL when Joker or covered card
  , unicode_char   char(1)    NOT NULL UNIQUE

  , PRIMARY KEY (id)
  , FOREIGN KEY (fk_value_text)
        REFERENCES enums_playcard_strings (id)
  , FOREIGN KEY (fk_suit_color)
        REFERENCES enums_playcard_strings (id)
  , FOREIGN KEY (fk_suit_text)
        REFERENCES enums_playcard_strings (id)
  , CONSTRAINT playcard_id_range
        CHECK (id >= 0 AND id <= 54)
  , CONSTRAINT value_int_range
        CHECK (value_int > 0 AND value_int <= 13)
  , CONSTRAINT value_symbol_not_empty
        CHECK (length(value_symbol) > 0)
  , CONSTRAINT suit_symbol_not_empty
        CHECK (length(suit_symbol) > 0)
  , CONSTRAINT unicode_char_not_empty
        CHECK (length(unicode_char) > 0)
    );


CREATE VIEW vw_playcards AS
    SELECT
        pl.id
      , pl.value_int
      , value.string
      , pl.value_symbol
      , pl.suit_symbol
      , suit.string
      , color.string
      , CASE pl.id
            WHEN 53 THEN pl.value_symbol
            WHEN 54 THEN pl.value_symbol
            WHEN  0 THEN '#'
            ELSE pl.value_symbol || pl.suit_symbol
        END AS full_symbol
      , CASE pl.id
            WHEN 53 THEN color.string || ' ' || value.string
            WHEN 54 THEN color.string || ' ' || value.string
            WHEN  0 THEN 'card back'
            ELSE value.string || ' of ' || suit.string
        END AS full_name
      , unicode_char
        FROM playcards AS pl
        LEFT JOIN enums_playcard_strings AS color
            ON pl.fk_suit_color = color.id
        LEFT JOIN enums_playcard_strings AS suit
            ON pl.fk_suit_text = suit.id
        LEFT JOIN enums_playcard_strings AS value
            ON pl.fk_value_text = value.id
        ;


INSERT INTO enums_playcard_strings (string) VALUES
    ('ace')
  , ('two')
  , ('three')
  , ('four')
  , ('five')
  , ('six')
  , ('seven')
  , ('eight')
  , ('nine')
  , ('ten')
  , ('jack')
  , ('queen')
  , ('king')
  , ('joker')
  , ('card back')
  , ('hearts')
  , ('diamonds')
  , ('clubs')
  , ('spades')
  , ('red')
  , ('black')
  ;


INSERT INTO playcards 
(id, value_int, fk_value_text, value_symbol, suit_symbol, fk_suit_text, 
    fk_suit_color, unicode_char) VALUES

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

VACUUM;
