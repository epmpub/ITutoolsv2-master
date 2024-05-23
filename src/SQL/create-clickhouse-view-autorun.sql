CREATE MATERIALIZED  VIEW demo.autorun_view
(
    `timestamp` DateTime,

    `entrytime` String,

    `hostname` String,

    `entrylocation` String,

    `entryname` String,

    `enabled` String,

    `category` String,

    `profile` String,

    `description` String,

    `company` String,

    `imagepath` String,

    `versioin` String,

    `launchstring` String

)
ENGINE = MergeTree
ORDER BY timestamp
SETTINGS index_granularity = 8192 AS
WITH splitByChar('$',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS entrytime,

    split[3] AS hostname,

    split[4] AS entrylocation,

    split[5] AS entryname,

    split[6] AS enabled,

    split[7] AS category,

    split[8] AS profile,

    split[9] AS description,

    split[10] AS company,

    split[11] AS imagepath,

    split[12] AS versioin,

    split[13] AS launchstring
FROM
(
    SELECT Message
    FROM demo.autorun
);
