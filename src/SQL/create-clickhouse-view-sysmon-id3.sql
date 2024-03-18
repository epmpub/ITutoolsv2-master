CREATE MATERIALIZED  VIEW YOUDB.winevent_sysmon_id3
(
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
    split[1] AS RuleName,
    split[2] AS UtcTime,
    split[3] AS ProcessGuid,

    split[4] AS ProcessId,
    split[5] AS Image,
    split[6] AS User,
    split[7] AS Protocol,
    split[8] AS Initiated,

    split[9] AS SourceIsIpv6,
    split[10] AS SourceIp,
    split[11] AS SourceHostname,
    split[12] AS SourcePort,
    split[13] AS SourcePortName,

    split[14] AS DestinationIsIpv6,
    split[15] AS DestinationIp,
    split[16] AS DestinationHostname,
    split[17] AS DestinationPort,
    split[18] AS DestinationPortName
FROM
(
    SELECT Message
    FROM YOUDB.winevent3
);
