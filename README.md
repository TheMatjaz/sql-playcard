French playing cards (for Poker) representation in SQL
===============================================================================

This repository contains a simple free SQL script for different RDMBS used
to create and fill the `playcard` table which stores standard french playing 
cards (those used in Poker) and contains a full deck.


Usage
---------------------------------------

1. Choose a script for a RDBMS of your choise
2. Run it to create and populate the `playcard` table and the view
   `vw_playcard` which contains some more columns.
3. Reference the rows of the table (which are the actual cards in the deck) 
   with a foreign key from another table.
4. Done.

P.S.: any contributions are more than welcome!


Features
---------------------------------------

Probably the best way to understand what data types are stored for each card
is to look at the `CREATE TABLE` query in the script or (better) by selecting 
the table and view (once created by running the script):

```sql
SELECT * FROM playcards;
SELECT * FROM vw_playcards;
```

Playable cards are represented in the `playcards` table. The columns are:

- `id`: a (small|tiny) integer `∈ [0, 54]`, primary key;
- `value_(smallint|tinyint|integer)`: the card value (points) as an integer 
  `∈ [1, 13]`;
- `value_text`: the english name of the card value such as _ace_, _king_ or 
  _eight_;
- `value_symbol`: the card value as the symbol usually displayed on the card 
  such as _A_, _K_, _10_ or _2_
- `suit_symbol`: the (black) [unicode symbol](https://en.wikipedia.org/wiki/Playing_cards_in_Unicode) of the suit: _♥♦♣♠_
- `suit_text`: the english name of the suit in plural such as _hearts_ or 
  _spades_
- `suit_color`: the english name of the color of the suit, _red_ or _black_
- `unicode_char`: the 
  [unicode symbol](https://en.wikipedia.org/wiki/Playing_cards_in_Unicode)
  of the whole card

Each row represents a card from the deck. There are 55 rows (cards) in it:

- 52 cards for a full deck, 13 cards for each suit: _hearts_, _diamonds_, 
  _clubs_ and _spades_. `id ∈ [1, 52]`;
- 2 jokers: red and black. `id ∈ [53, 54]`;
- an additional spacial card called _covered card_ or _card back_, used to 
  represent a card with unknown value. `id = 0`.


UTF-8
---------------------------------------

The suit and card symbols are Unicode characters so be sure to use UTF-8 (best)
or other UTF-* encodings. On PostgreSQL and SQLite works by default, **on MySQL
even by setting the `utf8` encoding does not work**. You need the `utf8mb4` 
encoding since the `utf8` in MySQL does not support 4-byte characters. The 
script is already configured to use those, but double check if you experience 
any problems.


License
-------
`pg_playcard` is released under the terms of the 
[BSD 3-clause license](LICENSE.md).
