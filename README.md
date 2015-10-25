# pg_card PostgreSQL playing card type extensions

This extension aims to offer a type representing a french playing card (those used in Poker).

## Type values
The characteristics of the type should be:

1. **card value**: it can be only one of the following values:
- Ace
- Integers in [2, 10]
- Jack
- Queen
- King
- Joker

2. **card suit**: it can be only one of the following values:
- clovers or clubs: ♣
- tiles or diamonds: ♦
- hearts: ♥
- pikes or spades: ♠

## Functions

1. Get the suit color
1. Get the value
1. Get the suit as text
1. Get the suit as symbol
1. Get the whole card as string
