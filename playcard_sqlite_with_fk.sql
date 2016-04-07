-------------------------------------------------------------------------------
-- French playable cards (for Poker) representation in SQL for *SQLite*
-- with the usage of foreign keys.
--
-- This SQL script contains is a really simple but comprehensive representation 
-- of a deck of standard french playable cards, those used in Poker.
--
-- Be sure to use an UTF-8 database to fully support the unicode characters 
-- for the cards.
-- 
-- For more information and versions of this script, including a simpler one
-- for SQLite without using foreign keys, but also for other RDBMS, visit the
-- GitHub repository of the project: https://github.com/TheMatjaz/sql-playcard
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
  , value_int      integer
  , fk_value_text  integer
  , value_symbol   char(2)
  , suit_symbol    char(1)
  , fk_suit_text   integer
  , fk_suit_color  integer
  , unicode_char   char(1)  NOT NULL UNIQUE

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
    ( 1,  1, (SELECT id FROM enums_playcard_strings WHERE string = 'ace'),   'A', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂱')
  , ( 2,  2, (SELECT id FROM enums_playcard_strings WHERE string = 'two'),   '2', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂲')
  , ( 3,  3, (SELECT id FROM enums_playcard_strings WHERE string = 'three'), '3', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂳')
  , ( 4,  4, (SELECT id FROM enums_playcard_strings WHERE string = 'four'),  '4', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂴')
  , ( 5,  5, (SELECT id FROM enums_playcard_strings WHERE string = 'five'),  '5', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂵')
  , ( 6,  6, (SELECT id FROM enums_playcard_strings WHERE string = 'six'),   '6', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂶')
  , ( 7,  7, (SELECT id FROM enums_playcard_strings WHERE string = 'seven'), '7', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂷')
  , ( 8,  8, (SELECT id FROM enums_playcard_strings WHERE string = 'eight'), '8', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂸')
  , ( 9,  9, (SELECT id FROM enums_playcard_strings WHERE string = 'nine'),  '9', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂹')
  , (10, 10, (SELECT id FROM enums_playcard_strings WHERE string = 'ten'),  '10', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂺')
  , (11, 11, (SELECT id FROM enums_playcard_strings WHERE string = 'jack'),  'J', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂻')
  , (12, 12, (SELECT id FROM enums_playcard_strings WHERE string = 'queen'), 'Q', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂽')
  , (13, 13, (SELECT id FROM enums_playcard_strings WHERE string = 'king'),  'K', '♥', (SELECT id FROM enums_playcard_strings WHERE string = 'hearts'),   (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🂾')

    -- DIAMONDS
  , (14,  1, (SELECT id FROM enums_playcard_strings WHERE string = 'ace'),   'A', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃁')
  , (15,  2, (SELECT id FROM enums_playcard_strings WHERE string = 'two'),   '2', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃂')
  , (16,  3, (SELECT id FROM enums_playcard_strings WHERE string = 'three'), '3', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃃')
  , (17,  4, (SELECT id FROM enums_playcard_strings WHERE string = 'four'),  '4', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃄')
  , (18,  5, (SELECT id FROM enums_playcard_strings WHERE string = 'five'),  '5', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃅')
  , (19,  6, (SELECT id FROM enums_playcard_strings WHERE string = 'six'),   '6', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃆')
  , (20,  7, (SELECT id FROM enums_playcard_strings WHERE string = 'seven'), '7', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃇')
  , (21,  8, (SELECT id FROM enums_playcard_strings WHERE string = 'eight'), '8', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃈')
  , (22,  9, (SELECT id FROM enums_playcard_strings WHERE string = 'nine'),  '9', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃉')
  , (23, 10, (SELECT id FROM enums_playcard_strings WHERE string = 'ten'),  '10', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃊')
  , (24, 11, (SELECT id FROM enums_playcard_strings WHERE string = 'jack'),  'J', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃋')
  , (25, 12, (SELECT id FROM enums_playcard_strings WHERE string = 'queen'), 'Q', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃍')
  , (26, 13, (SELECT id FROM enums_playcard_strings WHERE string = 'king'),  'K', '♦', (SELECT id FROM enums_playcard_strings WHERE string = 'diamonds'), (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃎')

    -- CLUBS
  , (27,  1, (SELECT id FROM enums_playcard_strings WHERE string = 'ace'),   'A', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃑')
  , (28,  2, (SELECT id FROM enums_playcard_strings WHERE string = 'two'),   '2', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃒')
  , (29,  3, (SELECT id FROM enums_playcard_strings WHERE string = 'three'), '3', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃓')
  , (30,  4, (SELECT id FROM enums_playcard_strings WHERE string = 'four'),  '4', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃔')
  , (31,  5, (SELECT id FROM enums_playcard_strings WHERE string = 'five'),  '5', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃕')
  , (32,  6, (SELECT id FROM enums_playcard_strings WHERE string = 'six'),   '6', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃖')
  , (33,  7, (SELECT id FROM enums_playcard_strings WHERE string = 'seven'), '7', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃗')
  , (34,  8, (SELECT id FROM enums_playcard_strings WHERE string = 'eight'), '8', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃘')
  , (35,  9, (SELECT id FROM enums_playcard_strings WHERE string = 'nine'),  '9', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃙')
  , (36, 10, (SELECT id FROM enums_playcard_strings WHERE string = 'ten'),  '10', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃚')
  , (37, 11, (SELECT id FROM enums_playcard_strings WHERE string = 'jack'),  'J', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃛')
  , (38, 12, (SELECT id FROM enums_playcard_strings WHERE string = 'queen'), 'Q', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃝')
  , (39, 13, (SELECT id FROM enums_playcard_strings WHERE string = 'king'),  'K', '♣', (SELECT id FROM enums_playcard_strings WHERE string = 'clubs'),    (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃞')

    -- SPADES
  , (40,  1, (SELECT id FROM enums_playcard_strings WHERE string = 'ace'),   'A', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂡')
  , (41,  2, (SELECT id FROM enums_playcard_strings WHERE string = 'two'),   '2', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂢')
  , (42,  3, (SELECT id FROM enums_playcard_strings WHERE string = 'three'), '3', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂣')
  , (43,  4, (SELECT id FROM enums_playcard_strings WHERE string = 'four'),  '4', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂤')
  , (44,  5, (SELECT id FROM enums_playcard_strings WHERE string = 'five'),  '5', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂥')
  , (45,  6, (SELECT id FROM enums_playcard_strings WHERE string = 'six'),   '6', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂦')
  , (46,  7, (SELECT id FROM enums_playcard_strings WHERE string = 'seven'), '7', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂧')
  , (47,  8, (SELECT id FROM enums_playcard_strings WHERE string = 'eight'), '8', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂨')
  , (48,  9, (SELECT id FROM enums_playcard_strings WHERE string = 'nine'),  '9', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂩')
  , (49, 10, (SELECT id FROM enums_playcard_strings WHERE string = 'ten'),  '10', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂪')
  , (50, 11, (SELECT id FROM enums_playcard_strings WHERE string = 'jack'),  'J', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂫')
  , (51, 12, (SELECT id FROM enums_playcard_strings WHERE string = 'queen'), 'Q', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂭')
  , (52, 13, (SELECT id FROM enums_playcard_strings WHERE string = 'king'),  'K', '♠', (SELECT id FROM enums_playcard_strings WHERE string = 'spades'),   (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🂮')

    -- JOKERS
  , (53, NULL, (SELECT id FROM enums_playcard_strings WHERE string = 'joker'), '☆', NULL, NULL, (SELECT id FROM enums_playcard_strings WHERE string = 'red'),   '🃟')
  , (54, NULL, (SELECT id FROM enums_playcard_strings WHERE string = 'joker'), '★', NULL, NULL, (SELECT id FROM enums_playcard_strings WHERE string = 'black'), '🃏')

    -- COVERED CARD / BACK OF A CARD
  , ( 0, NULL, NULL, NULL, NULL, NULL, NULL, '🂠')
  ;


COMMIT;


VACUUM;
