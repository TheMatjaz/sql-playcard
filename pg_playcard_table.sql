START TRANSACTION;

CREATE OR REPLACE FUNCTION is_empty(string text)
    RETURNS BOOLEAN
    RETURNS NULL ON NULL INPUT
    IMMUTABLE
    LANGUAGE sql
    AS $body$
        SELECT string ~ '^[[:space:]]*$';
    $body$;
    
DROP TYPE IF EXISTS playcard_enum_color;
CREATE TYPE playcard_enum_color
    AS ENUM ('red', 'black');

DROP TYPE IF EXISTS playcard_enum_suit;
CREATE TYPE playcard_enum_suit
    AS ENUM ('hearts', 'diamonds', 'clubs', 'spades');

DROP TABLE IF EXISTS playcards;

CREATE TABLE playcards (
    id             smallint
  , unicode_char   char(1)             NOT NULL UNIQUE
  , value_smallint smallint            -- NULL when Joker or covered
  , value_text     text                -- NULL when Joker or covered
  , suit_symbol    char(1)             -- NULL when Joker or covered
  , suit_text      playcard_enum_suit  -- NULL when Joker or covered
  , suit_color     playcard_enum_color -- NULL when Joker or covered

  , PRIMARY KEY (id)
  , CONSTRAINT playcard_id_range
        CHECK (id >= 0 AND id <= 54)
  , CONSTRAINT value_smallint_range
        CHECK (value_smallint > 0 AND value_smallint <= 13)
  , CONSTRAINT value_text_not_empty
        CHECK (NOT is_empty(value_text))
  , CONSTRAINT suit_symbol_not_empty
        CHECK (NOT is_empty(suit_symbol))
    );

'♥'
'♦'
'♣'
'♠'

INSERT INTO playcards 
(id, unicode_char, value_smallint, value_text, suit_symbol, suit_text, suit_color) VALUES
    (00, '🂠', NULL, NULL, NULL, NULL, NULL)

  , ( 1, '🂱',  1, 'ace', '♥', 'hearts', 'red')
  , ( 2, '🂲',  2, 'two', '♥', 'hearts', 'red')
  , ( 3, '🂳',  3, 'three', '♥', 'hearts', 'red')
  , ( 4, '🂴',  4, 'four', '♥', 'hearts', 'red')
  , ( 5, '🂵',  5, 'five', '♥', 'hearts', 'red')
  , ( 6, '🂶',  6, 'six', '♥', 'hearts', 'red')
  , ( 7, '🂷',  7, 'seven', '♥', 'hearts', 'red')
  , ( 8, '🂸',  8, 'eight', '♥', 'hearts', 'red')
  , ( 9, '🂹',  9, 'nine', '♥', 'hearts', 'red')
  , (10, '🂺', 10, 'ten', '♥', 'hearts', 'red')
  , (11, '🂻', 11, 'jack', '♥', 'hearts', 'red')
  , (12, '🂽', 12, 'queen', '♥', 'hearts', 'red')
  , (13, '🂾', 13, 'king', '♥', 'hearts', 'red')

  , (21, '🃁', 1, 'ace', '♦', 'diamonds', 'red')
  , (22, '🃂', 2, 'two', '♦', 'diamonds', 'red')
  , (23, '🃃', 3, 'three', '♦', 'diamonds', 'red')
  , (24, '🃄', 4, 'four', '♦', 'diamonds', 'red')
  , (25, '🃅', 5, 'five', '♦', 'diamonds', 'red')
  , (26, '🃆', 6, 'six', '♦', 'diamonds', 'red')
  , (27, '🃇', 7, 'seven', '♦', 'diamonds', 'red')
  , (28, '🃈', 8, 'eight', '♦', 'diamonds', 'red')
  , (29, '🃉', 9, 'nine', '♦', 'diamonds', 'red')
  , (30, '🃊', 10, 'ten', '♦', 'diamonds', 'red')
  , (31, '🃋', 11, 'jack', '♦', 'diamonds', 'red')
  , (32, '🃍', 12, 'queen', '♦', 'diamonds', 'red')
  , (33, '🃎', 13, 'king', '♦', 'diamonds', 'red')

  , (41, '🃑', 1, 'ace', '♣', 'clubs', 'black')
  , (42, '🃒', 2, 'two', '♣', 'clubs', 'black')
  , (43, '🃓', 3, 'three', '♣', 'clubs', 'black')
  , (44, '🃔', 4, 'four', '♣', 'clubs', 'black')
  , (45, '🃕', 5, 'five', '♣', 'clubs', 'black')
  , (46, '🃖', 6, 'six', '♣', 'clubs', 'black')
  , (47, '🃗', 7, 'seven', '♣', 'clubs', 'black')
  , (48, '🃘', 8, 'eight', '♣', 'clubs', 'black')
  , (49, '🃙', 9, 'nine', '♣', 'clubs', 'black')
  , (50, '🃚', 10, 'ten', '♣', 'clubs', 'black')
  , (51, '🃛', 11, 'jack', '♣', 'clubs', 'black')
  , (52, '🃝', 12, 'queen', '♣', 'clubs', 'black')
  , (53, '🃞', 13, 'king', '♣', 'clubs', 'black')

  , (61, '🂡', 1, 'ace', '♠', 'spades', 'black')
  , (62, '🂢', 2, 'two', '♠', 'spades', 'black')
  , (63, '🂣', 3, 'three', '♠', 'spades', 'black')
  , (64, '🂤', 4, 'four', '♠', 'spades', 'black')
  , (65, '🂥', 5, 'five', '♠', 'spades', 'black')
  , (66, '🂦', 6, 'six', '♠', 'spades', 'black')
  , (67, '🂧', 7, 'seven', '♠', 'spades', 'black')
  , (68, '🂨', 8, 'eight', '♠', 'spades', 'black')
  , (69, '🂩', 9, 'nine', '♠', 'spades', 'black')
  , (70, '🂪', 10, 'ten', '♠', 'spades', 'black')
  , (71, '🂫', 11, 'jack', '♠', 'spades', 'black')
  , (72, '🂭', 12, 'queen', '♠', 'spades', 'black')
  , (73, '🂮', 13, 'king', '♠', 'spades', 'black')

  , (80, '🃟', NULL, 'joker', NULL, NULL, 'red')
  , (81, '🃏', NULL, 'joker', NULL, NULL, 'black')
  ;

COMMIT;
