pg_card to-do list
==================
Features that would be nice to have, questions about what to do, possible 
optimizations and tests to perform all in one file.

Features
--------

- Add suit simbols parsing to `playcard_from_full_name()`
- Add functions and operators to compare the cards by value. If the value is
  the same, then compare by suit (H>D>C>S). It should result as `NULL` for 
  jokers and card backs.
- Add functions to compute the value of a hand of five cards for Poker.
- Add different symbols for jokers: black star '★' for black jokers (already 
  implemented) and white star '☆' for red jokers (to add).
- Set table encoding to UTF-8.

- Add a function to change the card's value with the passed value.
- Add a function to increase and decrease the card's value by the specified
  parameter with 1 as default. Add an unary operator `++` for this function.
- Add a function to change the card's suit with the passed suit.

Questions
---------

- `DROP` and `CASCADE` clauses in installation script. Should we keep them or 
  remove them?
- Add a specific schema for the enums, functions, domains, tables and views of 
  the extension? Something like `playcard`?
- Add a command on the start of the install script that terminates when run in 
  `psql` instead of `CREATE EXTENSION`?

Optimizations
-------------

- Rewrite all the functions in C. Perform a benchmark to compare the SQL and C
  stored procedures.
- Set functions as IMMUTABLE when they depend only on the passed parameters
  (multiple calls with the same parameters produce always the same result)
- Set flags `CALLED ON NULL INPUT` or `RETURNS NULL ON NULL INPUT` a.k.a. 
  `STRICT` on specific functions. The first one "indicates that the function 
  will be called normally when some of its arguments are null", the second one 
  "indicates that the function always returns null whenever any of its 
  arguments are null" - watch out: _any_ of its arguments.

Tests
-----

- Verify that all functions return `NULL` for `NULL` arguments.
