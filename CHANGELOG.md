v1.0.0
======

Removed
-------

- User defined type, domains and functions and every code from v0.1.0.


Added
-----

- A much simpler and portable solution using a table with all standard french
  playable cards. The table has many columns for various details about the
  cards. An UDT is not needed since the number of its instances is limited to
  55 (52 cards + 2 jokers + 1 covered card).
- A view for full card symbols and full card names (in english)
- The script is for PostgreSQL, MySQL and SQLite.


Changed
-------

- Readme file has detailed explanation on how the table is structured.


v0.1.0
======

Added
-----

- Domain `playcard` to represent a standard deck's french playable card
  with minimal storage space (2 bytes)
- Enums for card's suit and suit's color
- Functions to extract value, suit and color in various forms from a 
  `playcard` field
- Functions to pretty print the `playcard` value and suit in human readable 
  english description
- Function to create a `playcard` from a human readable english description
  (the opposite of the previous point)
- BSD 3-clause license file
- This changelog and the readme file
