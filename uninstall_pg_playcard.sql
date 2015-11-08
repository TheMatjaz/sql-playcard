-- pg_card uninstallation script
--
--       +********************************+
--       |  WARNING! POSSIBLE DATA LOSS!  |
--       +********************************+
--
-- This script, as you can see, performs a CASCADE DROP of the domain 
-- "playcard", which deletes every table, function etc. that uses this domain
-- as parameter or column type. PLEASE check what would happen. A simple way 
-- to do is is by running this script with a ROLLBACK instead of a COMMIT, as 
-- this script's default. Enable the COMMIT when you are sure nothing 
-- important would be lost.

START TRANSACTION;

DROP TYPE IF EXISTS playcard_color_enum CASCADE;
DROP TYPE IF EXISTS playcard_suit_enum CASCADE;
DROP DOMAIN IF EXISTS playcard CASCADE;

ROLLBACK;    
-- COMMIT; -- check what would be dropped before enabling the commit
