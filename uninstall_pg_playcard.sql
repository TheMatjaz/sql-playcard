------------------------------------------------------------------------
--
--               ++----------------------------------++
--               ||  PG_PLAYCARD UNINSTALLER SCRIPT  ||
--               ++----------------------------------++
--
-- This script uninstalls `pg_playcard`, the PostgreSQL extension that 
-- provides a user defined type for standard french playable card 
-- (those used in Poker).
-- For more information, visit the GitHub repository of the project:
-- https://github.com/TheMatjaz/pg_playcard
--
------------------------------------------------------------------------
--
--                 +********************************+
--                 |  WARNING! POSSIBLE DATA LOSS!  |
--                 +********************************+
--
-- This script, as you can see, performs a CASCADE DROP of the domain 
-- `playcard`, which deletes every table, function etc. that uses this 
-- domain as parameter or column type.  Check what would happen BEFORE
-- dropping it. A simple way to do is is by running this script with a 
-- ROLLBACK instead of a COMMIT, as this script's default. Enable the 
-- COMMIT when you are sure nothing important will be lost.
------------------------------------------------------------------------
-- Copyright (c) 2015, Matjaž <dev@matjaz.it> matjaz.it
--
-- This Source Code Form is subject to the terms of the BSD 3-clause 
-- license. If a copy of the license was not distributed with this
-- file, You can obtain one at 
-- http://directory.fsf.org/wiki/License:BSD_3Clause
------------------------------------------------------------------------

START TRANSACTION;

DROP TYPE IF EXISTS playcard_color_enum CASCADE;
DROP TYPE IF EXISTS playcard_suit_enum CASCADE;
DROP DOMAIN IF EXISTS playcard CASCADE;

ROLLBACK;    
-- COMMIT; -- check what would be dropped before enabling this commit
