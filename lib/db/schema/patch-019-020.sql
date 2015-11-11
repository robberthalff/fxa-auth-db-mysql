-- Add callbackPublicKey column to devices table
ALTER TABLE devices ADD COLUMN callbackPublicKey BINARY(32);

-- Update upsertDevice stored procedure with callbackPublicKey column
-- and to signal an error if the session token doesn't match
CREATE PROCEDURE `upsertDevice_2` (
  IN `inUid` BINARY(16),
  IN `inId` BINARY(16),
  IN `inSessionTokenId` BINARY(32),
  IN `inName` VARCHAR(255),
  IN `inType` VARCHAR(16),
  IN `inCreatedAt` BIGINT UNSIGNED,
  IN `inCallbackURL` VARCHAR(255),
  IN `inCallbackPublicKey` BINARY(32)
)
BEGIN
  DECLARE targetSessionTokenId BINARY(32) DEFAULT NULL;
  DECLARE deviceCount INT UNSIGNED DEFAULT 0;

  IF inSessionTokenId IS NOT NULL THEN
    SELECT sessionTokenId FROM devices
    WHERE uid = inUid AND id = inId
    INTO targetSessionTokenId;

    IF targetSessionTokenId IS NULL OR targetSessionTokenId <> inSessionTokenId THEN
      SELECT COUNT(*) FROM devices
      WHERE sessionTokenId = inSessionTokenId
      INTO deviceCount;

      IF deviceCount > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Session token is registered with a different device';
      END IF;
    END IF;
  END IF;

  INSERT INTO devices(
    uid,
    id,
    sessionTokenId,
    name,
    type,
    createdAt,
    callbackURL,
    callbackPublicKey
  )
  VALUES (
    inUid,
    inId,
    inSessionTokenId,
    inName,
    inType,
    inCreatedAt,
    inCallbackURL,
    inCallbackPublicKey
  )
  ON DUPLICATE KEY UPDATE
    sessionTokenId = COALESCE(inSessionTokenId, sessionTokenId),
    name = COALESCE(inName, name),
    type = COALESCE(inType, type),
    callbackURL = COALESCE(inCallbackURL, callbackURL),
    callbackPublicKey = COALESCE(inCallbackPublicKey, callbackPublicKey);
END;

-- Update accountDevices stored procedure with callbackPublicKey column
CREATE PROCEDURE `accountDevices_3` (
  IN `inUid` BINARY(16)
)
BEGIN
  SELECT
    d.uid,
    d.id,
    d.sessionTokenId,
    d.name,
    d.type,
    d.createdAt,
    d.callbackURL,
    d.callbackPublicKey,
    s.uaBrowser,
    s.uaBrowserVersion,
    s.uaOS,
    s.uaOSVersion,
    s.uaDeviceType,
    s.lastAccessTime
  FROM
    devices d LEFT JOIN sessionTokens s
  ON
    d.sessionTokenId = s.tokenId
  WHERE
    d.uid = inUid;
END;

-- Bump the schema version
UPDATE dbMetadata SET value = '20' WHERE name = 'schema-patch-level';

