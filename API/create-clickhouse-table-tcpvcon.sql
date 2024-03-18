 CREATE TABLE demo.tcpvcon2
(
    `Id` String,
    `Message` String
)
ENGINE = MergeTree
PRIMARY KEY Id
ORDER BY Id
SETTINGS index_granularity = 8192