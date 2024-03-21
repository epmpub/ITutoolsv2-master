CREATE MATERIALIZED  VIEW demo.hardware_inventory_view
(
    `timestamp` DateTime,

    `hostname` String,

    `cpu` String,

    `ram` String,

    `disk` String,

    `gpu` String,

    `hotfix` String,

    `macAddress` String,

    `ip` String,

    `lastBootUpTime` String,

    `uptime` String,

    `osVersion` String


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

    split[5] AS disk,

    split[6] AS gpu,

    split[7] AS hotfix,

    split[8] AS macAddress,

    split[9] AS ip,

    split[10] AS lastBootUpTime,

    split[11] AS uptime,

    split[12] AS osVersion

FROM
(
    SELECT Message
    FROM demo.hardware_inventory
);
