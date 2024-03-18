CREATE MATERIALIZED  VIEW YOUDB.autorun_view
(
    `timestamp` String,

    `host` String,

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
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS timestamp,

    split[2] AS host,

    split[3] AS entrylocation,

    split[4] AS entryname,

    split[5] AS enabled,

    split[6] AS category,

    split[7] AS profile,

    split[8] AS description,

    split[9] AS company,

    split[10] AS imagepath,

    split[11] AS versioin,

    split[12] AS launchstring
FROM
(
    SELECT Message
    FROM YOUDB.autorun
);
