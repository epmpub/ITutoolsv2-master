CREATE MATERIALIZED  VIEW demo.winevent11_view
(
    `timestamp` DateTime,
    `hostname` String,
    `RuleName` String,
    `UtcTime` Datetime64,
    `ProcessGuid` String,

    `ProcessId` UInt64,
    `Image` String,
    `TargetFilename` String,
    `CreationUtcTime` String,
    `User` String
)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,
    split[2] AS hostname,
    split[3] AS RuleName,
    split[4] AS UtcTime,
    split[5] AS ProcessGuid,

    split[6] AS ProcessId,
    split[7] AS Image,
    split[8] AS TargetFilename,
    split[9] AS CreationUtcTime,
    split[10] AS User
FROM
(
    SELECT Message
    FROM demo.winevent11
);
