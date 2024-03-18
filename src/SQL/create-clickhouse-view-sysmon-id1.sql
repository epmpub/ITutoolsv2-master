CREATE MATERIALIZED  VIEW YOUDB.winevent_sysmon_id1
(
    `timestamp` String,

    `host` String,

    `Image` String,

    `CommandLine` String,

    `ParentImage` String
)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS host,

    split[3] AS Image,

    split[4] AS CommandLine,

    split[5] AS ParentImage
FROM
(
    SELECT Message
    FROM YOUDB.winevent1
);
