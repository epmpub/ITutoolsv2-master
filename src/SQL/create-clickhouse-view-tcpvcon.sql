CREATE MATERIALIZED  VIEW YOUDB.tcpvcon2_view
(

    `timestamp` String,

    `host` String,

    `protocol` String,

    `name` String,

    `pid` String,

    `state` String,

    `local` String,

    `remote` String

)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS host,

    split[3] AS protocol,

    split[4] AS name,

    split[5] AS pid,

    split[6] AS state,

    split[7] AS local,

    split[8] AS remote
   
FROM
(
    SELECT Message
    FROM YOUDB.tcpvcon2
);
