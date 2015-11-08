_All notable changes to the pg\_playcard PostgreSQL extension will be 
documented in this file._

************************************************************************
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
