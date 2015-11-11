-- -- Drop new columns
-- ALTER TABLE devices DROP COLUMN callbackPublicKey;

-- -- Drop new stored procedures
-- DROP PROCEDURE `upsertDevice_2`;
-- DROP PROCEDURE `accountDevices_3`;

-- -- Decrement the schema version
-- UPDATE dbMetadata SET value = '19' WHERE name = 'schema-patch-level';

