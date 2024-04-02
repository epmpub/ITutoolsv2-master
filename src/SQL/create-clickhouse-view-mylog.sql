CREATE MATERIALIZED VIEW mylog_view
(
    `timestamp` String,

    `hostname` String,

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

    split[3] AS message
FROM
(
    SELECT Message
    FROM demo.mylog
);
