CREATE MATERIALIZED  VIEW demo.winevent12_view
(
    `timestamp` DateTime,
    `hostname` String,
    `RuleName` String,
    `EventType` String,
    `UtcTime` String,

    `ProcessGuid` String,
    `ProcessId` String,
    `Image` String,
    `TargetObject` String,
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
    split[4] AS EventType,
    split[5] AS UtcTime,

    split[6] AS ProcessGuid,
    split[7] AS ProcessId,
    split[8] AS Image,
    split[9] AS TargetObject,
    split[10] AS User
    
FROM
(
    SELECT Message
    FROM demo.winevent12
);
