CREATE MATERIALIZED  VIEW demo.hardware_inventory_view
(
    `timestamp` DateTime,

    `hostname` String,

    `cpu` String,

    `ram` String,

    `gpu` String,

    `ver` String

)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS hostname,

    split[3] AS cpu,

    split[4] AS ram,

    split[5] AS gpu,

    split[6] AS ver

FROM
(
    SELECT Message
    FROM demo.hardware_inventory
);
