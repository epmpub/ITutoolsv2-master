CREATE MATERIALIZED  VIEW demo.software_inventory_view
(
    `timestamp` DateTime,

    `hostname` String,

    `name` String,

    `version` String,

    `installLocation` String

)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS hostname,

    split[3] AS name,

    split[4] AS version,

    split[5] AS installLocation

FROM
(
    SELECT Message
    FROM demo.software_inventory
);
