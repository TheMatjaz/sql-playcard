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
  , value_smallint smallint            -- NULL when Joker or covered
  , value_text     text                -- NULL when Joker or covered
  , suit_symbol    char(1)             -- NULL when Joker or covered
  , suit_text      playcard_enum_suit  -- NULL when Joker or covered
  , suit_color     playcard_enum_color -- NULL when Joker or covered
  , unicode_char   char(1)             NOT NULL UNIQUE

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

INSERT INTO playcards 
(id, unicode_char, value_smallint, value_text, suit_symbol, suit_text, suit_color)
VALUES

    -- HEARTS
    ( 1, '🂱',  1, 'ace',   '♥', 'hearts',   'red')
  , ( 2, '🂲',  2, 'two',   '♥', 'hearts',   'red')
  , ( 3, '🂳',  3, 'three', '♥', 'hearts',   'red')
  , ( 4, '🂴',  4, 'four',  '♥', 'hearts',   'red')
  , ( 5, '🂵',  5, 'five',  '♥', 'hearts',   'red')
  , ( 6, '🂶',  6, 'six',   '♥', 'hearts',   'red')
  , ( 7, '🂷',  7, 'seven', '♥', 'hearts',   'red')
  , ( 8, '🂸',  8, 'eight', '♥', 'hearts',   'red')
  , ( 9, '🂹',  9, 'nine',  '♥', 'hearts',   'red')
  , (10, '🂺', 10, 'ten',   '♥', 'hearts',   'red')
  , (11, '🂻', 11, 'jack',  '♥', 'hearts',   'red')
  , (12, '🂽', 12, 'queen', '♥', 'hearts',   'red')
  , (13, '🂾', 13, 'king',  '♥', 'hearts',   'red')

    -- DIAMONDS
  , (14, '🃁',  1, 'ace',   '♦', 'diamonds', 'red')
  , (15, '🃂',  2, 'two',   '♦', 'diamonds', 'red')
  , (16, '🃃',  3, 'three', '♦', 'diamonds', 'red')
  , (17, '🃄',  4, 'four',  '♦', 'diamonds', 'red')
  , (18, '🃅',  5, 'five',  '♦', 'diamonds', 'red')
  , (19, '🃆',  6, 'six',   '♦', 'diamonds', 'red')
  , (20, '🃇',  7, 'seven', '♦', 'diamonds', 'red')
  , (21, '🃈',  8, 'eight', '♦', 'diamonds', 'red')
  , (22, '🃉',  9, 'nine',  '♦', 'diamonds', 'red')
  , (23, '🃊', 10, 'ten',   '♦', 'diamonds', 'red')
  , (24, '🃋', 11, 'jack',  '♦', 'diamonds', 'red')
  , (25, '🃍', 12, 'queen', '♦', 'diamonds', 'red')
  , (26, '🃎', 13, 'king',  '♦', 'diamonds', 'red')

    -- CLUBS
  , (27, '🃑',  1, 'ace',   '♣', 'clubs',    'black')
  , (28, '🃒',  2, 'two',   '♣', 'clubs',    'black')
  , (29, '🃓',  3, 'three', '♣', 'clubs',    'black')
  , (30, '🃔',  4, 'four',  '♣', 'clubs',    'black')
  , (31, '🃕',  5, 'five',  '♣', 'clubs',    'black')
  , (32, '🃖',  6, 'six',   '♣', 'clubs',    'black')
  , (33, '🃗',  7, 'seven', '♣', 'clubs',    'black')
  , (34, '🃘',  8, 'eight', '♣', 'clubs',    'black')
  , (35, '🃙',  9, 'nine',  '♣', 'clubs',    'black')
  , (36, '🃚', 10, 'ten',   '♣', 'clubs',    'black')
  , (37, '🃛', 11, 'jack',  '♣', 'clubs',    'black')
  , (38, '🃝', 12, 'queen', '♣', 'clubs',    'black')
  , (39, '🃞', 13, 'king',  '♣', 'clubs',    'black')

    -- SPADES
  , (40, '🂡',  1, 'ace',   '♠', 'spades',   'black')
  , (41, '🂢',  2, 'two',   '♠', 'spades',   'black')
  , (42, '🂣',  3, 'three', '♠', 'spades',   'black')
  , (43, '🂤',  4, 'four',  '♠', 'spades',   'black')
  , (44, '🂥',  5, 'five',  '♠', 'spades',   'black')
  , (45, '🂦',  6, 'six',   '♠', 'spades',   'black')
  , (46, '🂧',  7, 'seven', '♠', 'spades',   'black')
  , (47, '🂨',  8, 'eight', '♠', 'spades',   'black')
  , (48, '🂩',  9, 'nine',  '♠', 'spades',   'black')
  , (49, '🂪', 10, 'ten',   '♠', 'spades',   'black')
  , (50, '🂫', 11, 'jack',  '♠', 'spades',   'black')
  , (51, '🂭', 12, 'queen', '♠', 'spades',   'black')
  , (52, '🂮', 13, 'king',  '♠', 'spades',   'black')

    -- JOKERS
  , (53, '🃟', NULL, 'joker', NULL, NULL, 'red')
  , (54, '🃏', NULL, 'joker', NULL, NULL, 'black')

    -- COVERED CARD / BACK OF A CARD
  , ( 0, '🂠', NULL, NULL, NULL, NULL, NULL)
  ;

COMMIT;
