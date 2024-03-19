CREATE MATERIALIZED  VIEW YOUDB.autorun_view
(
    `createTime` DateTime,

    `entrytime` String,

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
ORDER BY createTime
SETTINGS index_granularity = 8192 AS
WITH splitByChar(',',
 Message) AS split
SELECT
    split[1] AS createTime,

    split[2] AS entrytime,

    split[3] AS host,

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
    FROM YOUDB.autorun
);
