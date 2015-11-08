`pg_playcard` documentation
===========================

`playcard` domain
-----------------
The basis of _pg\_playcard_ is the
[user defined domain](http://www.postgresql.org/docs/current/static/sql-createdomain.html)
called `playcard` used as a computer-readable representation of a standard
french playing card.


#### `playcard` values
`playcard` is a `char(2)` with constrained values as in the regex
`[AJQK234567890BS][HDCS]` and default value of `BC`, indicating a Card back.
Note that only capital letters are allowed. The first character indicates the
**value** of the card, while the second indicates its **suit**. The chars are
chosen to be easy to remember and to type.

Char | Meaning
-----|--------
 A   | **A**ce
 2-9 | The same numbers respectively
 0   | 1**0**
 J   | **J**ack
 Q   | **Q**ueen
 K   | **K**ing
 S   | Joker (\*)
 B   | Card **B**ack (\*\*)
     | 
 H   | **H**earts (♥)
 D   | **D**iamonds (♦)
 C   | **C**lubs (♣)
 S   | **S**pades (♠)
 
(\*): the char for "Joker" is "S" from "**S**tar", the symbol of the Joker on a
playing card. This choise has been done since "J" is obviously taken for "Jack".


#### "Special" values
Two values of the `playcard` domain are special in two ways: firstly they are
an exception rather than a rule in most of the code, secondly they are different
from other cards also in real cards.

The first one is the **Joker**: although the Joker can be written as a
`playcard` like `SH`, `SD`, `SC` or `SS`, it has no suit and no value, only a
color: _red_ or _black_. The second char (the suit char) of a Joker `playcard`
is used only when the color of the Joker is needed. In that case _Hearts_ and
_Diamonds_ provide a _red_ color, while _Clubs_ and _Spades_ provide the
_black_ one.

The second one is the **Card back**: this is not an actual card in a standard
52-cards deck, but rather a useful tool instead of `NULL` values. A Card back
is used to indicate a covered card, a card of unknown value, but an existing
one. As for the Jokers, the Card back has no suit, no value and also no color.
For this reason the second char is completely arbitrary: `BH`, `BD`, `BC` and
`BS` are exactly the same thing. The use of `BC` is suggested since it has a
similarity with "**B**ack (of a) **C**ard".

Enum types
----------
- `playcard_color_enum` stores the possible colors of the cards: `red`, `black`
- `playcard_suit_enum` stores the possible suits of the cards: `hearts`,
  `diamonds`, `clubs`, `spades`

Stored procedures
-----------------
#### `playcard_value_as_int(playcard)`
Returns an **int** indicating the value of the card from 1 to 13 for cards from
Ace to King. Returns `NULL` for the Joker and the Card back.


#### `playcard_value_as_string(playcard)`
Returns a **varchar(5)** indicating the value of the card as a word rather than
as int. Examples are: `ace`, `king`, `three`, `ten`. For Jokers and
Card backs returns `joker` and `back`.


#### `playcard_value_as_string_with_ints(playcard)`
This is a variation of `playcard_value_as_string()`. The only difference is that
the values from 2 to 10 are returned as strings with arabic numeral `2`,
`3`, ..., `10` instead of the english words `two`, `three`, ...,
`ten`.


#### `playcard_value_as_symbol(playcard)`
Returns an string with 1 or 2 characters indicating the value of the card as
shortly as possible. The value is the same as the first char in the playcard
identifier passed to the function with only three exceptions:

- `0` returns `10`, the only output long two chars
- `S` returns `★`, a star for the Joker
- `B` returns `#`, as a pattern on the Back of the card


#### `playcard_suit_as_string(playcard)`
Returns a **string**, actually a value of `playcard_suit_enum`, indicating the
suit of the card, extracted from the second char of the parameter. The output
may be `hearts`, `diamonds`, `clubs` or `spades` for a known suit or `NULL` for
Jokers and Card backs.


#### `playcard_suit_as_symbol(playcard)`
Returns a **char** with the symbol of the suit of the card, extracted from the
second char of the parameter. The output may be `♥`, `♦`, `♣`, `♠` for a
known suit or `NULL` for Jokers and Card backs.


#### `playcard_suit_color(playcard)`
Returns a **string**, actually a value of `playcard_color_enum`, indicating the
color of the suit of the card, extracted from the second char of the parameter.
The output may be `red` (for hearts and diamonds) or `black`
(for clubs and spades). Jokers have also a color, even if they don't
have a suit. The color is picked from the suit they are assigned to,
e.g.: `SH` would be a joker of hearts, but is actually a `red joker`.
Card backs produce a `NULL` output.


#### `playcard_value_and_suit_string(playcard, text, char(2)`
Returns a **string** with the symbol of the value (`A`, `J`, `2`, `10`, `★`,
`#`) and a symbol of the suit (`♥`, `♦`, `♣`, `♠`) concatenated. Optionally a
delimiter between the two may be set and a character on the beginning and end
of the string aswell. Some examples of inputs and outputs

```
playcard_value_and_suit_string('0S') --> '10♠'
playcard_value_and_suit_string('JS', ', ') --> 'J, ♠'
playcard_value_and_suit_string('KS', ' ', '[]') --> '[K ♠]'
playcard_value_and_suit_string('0S', ';', '()') --> '(10;♠)'
playcard_value_and_suit_string('SS', NULL, '[]') --> '[★]'
playcard_value_and_suit_string('BC') --> '#'
```


#### `playcard_full_name(playcard)`
Returns a **string** with a human readable english explanation of the card
value and suit, such as `ace of spades`, `three of diamonds`,
`queen of hearts`, `red joker` or `card back`.


#### `playcard_full_name_with_int(playcard)`
This is a variation of `playcard_full_name()`. The only difference is that the
values from 2 to 10 are returned as strings with arabic numeral `2`,
`3`, ..., `10` instead of the english words `two`, `three`, ...,
`ten`. The final result is for instance `3 of diamonds` instead of
`three of diamonds`.


#### `playcard_from_full_name(varchar(17))`
Returns a **playcard** from parsing an english human readable description of
the card. It is the inverse function of `playcard_full_name()`. The parsed
string should contain the value and the suit (in plural) in this order, with
optional punctuation and an `of` word. Jokers should have a color and Card
backs just the word `back`. The function is case insensitive. A few examples:

- `ace of spades` --> `AS`
- `KING    diamONDs` --> `KD`
- `3 clubs` or `three clubs` or `three of clubs` --> `3C`
- `clubs 3` --> Error!
- `joker red` or `red ...:::somegarbage::;-     joker` -> `SH`
- `back` or `card back` --> `BC`


#### `playcard_draw_card(playcard)`
Returns a 6 row **string** containing a box-drawing with the value and suit of
the card inside, which may be useful for terminal-based interfaces.
An example for `AS`:

```
┌──────┐
│ A  ♠ │
│      │
│      │
│ ♠  A │
└──────┘
```


Tables and views
----------------

- `playcards` is a table containing all the allowed `playcard` values as
  primary key. There are 52 cards from the standard deck, 2 Jokers (red and
  black) and a Card back record. For each card there is also a unicode
  character with the full card drawn in it.
- `playcards_vw_full` is a view adding to the columns available in the table
  `playcards` a column for each function that extracts data from the
  `playcard` format, such as value, suit, color, full name and so on. 
