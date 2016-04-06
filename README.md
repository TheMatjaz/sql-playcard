French playable cards (for Poker) representation in SQL
=======================================================

`pg_playcard` is a simple SQL script (written for PostgreSQL, but easily 
portable to other RDBMS) to create and fill the `playcard` table which 
represents a standard french play card (those used in Poker) and contains all 
of them.

Then just reference the cards with a foreign key from any other table and 
that's it.


Features
--------

Probably looking at the `CREATE TABLE` query or running 
`SELECT * FROM playcards; SELECT * FROM vw_playcards;` will claryfy most of it.
Playable cards are represented in the `playcards` table. The table contains a 
full 52-card deck (13 for each of hearts, diamonds, clubs and spades), 2 jokers 
(red and black) and an additional _covered card_ or _card back_ tuple, used to 
represent a card with unknown value.

Be sure to use an UTF-8 database to fully support the 
[unicode characters of the cards](https://en.wikipedia.org/wiki/Playing_cards_in_Unicode).


Porting to other RDBMS
----------------------

The script is created for PostgreSQL but should be easily portable to other 
RDBMS. Try this first and then adapt to your needs:

1. remove the function `is_empty_or_space()`
2. remove the enum types `playcard_enum_color` and `playcard_enum_suit`
3. remove the `CONSTRAINT` clauses from the `playcards` table, except on `id` 
   and `unicode_char`
4. substitute the enum types in the `playcards` table with a `varchar(8)` type.
   8 is the length of the suit `'diamonds'`


If anything about the script is not clear, feel free to contact me!


License
-------
`pg_playcard` is released under the terms of the 
[BSD 3-clause license](LICENSE.md).
