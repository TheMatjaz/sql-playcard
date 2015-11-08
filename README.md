pg_playcard: french playable cards UDT for PostgreSQL
=====================================================

pg_playcard is a PostgreSQL extension that provides a user defined type for 
standard french playable card (those used in Poker).

Features
--------
_pg\_playcard_ offers a compact on-disk representation of the playable card 
that uses only 2 bytes (technically a `char(2)`) and a 
[set of functions](docs/pg_playcard_docs.md) to extract and expand the 
information stored in it. The representation is defined with the domain 
`playcard`.

_pg\_playcard_ supports all the cards in a standard 52-cards deck, which are  
_ace, two, three, ..., ten, jack, queen_ and _king_ of four suits: _hearts_ 
(♥), _diamonds_ (♦), _clubs_ (♣) and _spades_ (♠). It also has special values 
for the _jokers_: _red_ (☆) and _black_ (★) aswell as a _card back_ (#) value, 
used to indicade a card that is covered, thus showing the back, which value 
and suit are unknown.

For a complete documentation about the functions, please check the 
[docs file](docs/pg_playcard_docs.md).

_pg\_playcard_ is written only with SQL and PL/pgSQL, so it has no other 
dependencies other than PostgreSQL.

Hope you find it helpful!

Installation
------------
For now, _pg\_playcard_ comes in a SQL-script-only version. This means that 
you simply need to run the SQL installer script and that's it.
```bash
psql [other parameters] -f pg_card.sql
```

License
-------
_pg\_playcard_ is released under the terms of the 
[BSD 3-clause license](LICENSE.md), 
which makes it free software. You are free to use it as you wish, as long as 
you include the BSD copyright and license notice in it.
