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
  , unicode_char   char(1)     NOT NULL UNIQUE
  , value_smallint smallint
  , value_text     text
  , suit_symbol    char(1)
  , suit_text      text
  , suit_color     
  , full_name      text     NOT NULL UNIQUE
  , full_name_int  text     NOT NULL UNIQUE

  , PRIMARY KEY (id)
    );

INSERT INTO playcards (id, unicode_char) VALUES 
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

COMMIT;
