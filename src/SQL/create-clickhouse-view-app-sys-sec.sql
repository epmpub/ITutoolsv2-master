CREATE MATERIALIZED VIEW demo.app_sys_sec_view
(
    `timestamp` String,

    `hostname` String,

    `catalog` String,

    `eventid` String,

    `message` String
)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS hostname,

    split[3] AS catalog,

    split[4] AS eventid,

    split[5] AS message
FROM
(
    SELECT Message
    FROM demo.app_sys_sec
);
