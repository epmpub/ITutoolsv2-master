CREATE MATERIALIZED  VIEW demo.winevent3_view
(
    `timestamp` DateTime,
    `hostname` String,
    `RuleName` String,
    `UtcTime` Datetime64,
    `ProcessGuid` String,

    `ProcessId` UInt64,
    `Image` String,
    `User` String,
    `Protocol` String,
    `Initiated` String,

    `SourceIsIpv6` String,
    `SourceIp` String,
    `SourceHostname` String,
    `SourcePort` String,
    `SourcePortName` String,

    `DestinationIsIpv6` String,
    `DestinationIp` String,
    `DestinationHostname` String,
    `DestinationPort` String,
    `DestinationPortName` String

)
ENGINE = MergeTree
ORDER BY UtcTime
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
    split[8] AS User,
    split[9] AS Protocol,
    split[10] AS Initiated,

    split[11] AS SourceIsIpv6,
    split[12] AS SourceIp,
    split[13] AS SourceHostname,
    split[14] AS SourcePort,
    split[15] AS SourcePortName,

    split[16] AS DestinationIsIpv6,
    split[17] AS DestinationIp,
    split[18] AS DestinationHostname,
    split[19] AS DestinationPort,
    split[20] AS DestinationPortName
FROM
(
    SELECT Message
    FROM demo.winevent3
);
