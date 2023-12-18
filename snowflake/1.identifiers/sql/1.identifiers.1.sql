-- https://docs.snowflake.com/en/sql-reference/identifiers-syntax

CREATE OR REPLACE DATABASE DWHDEMO_DB01;

CREATE TABLE My$identifier (
  f1 INT
);

CREATE TABLE _my_identifier (
  f2 INT
);

CREATE TABLE "My 'Identifier'" (
  f3 INT
);

CREATE TABLE "$Identifier" (
  f4 INT
);

CREATE TABLE `Myidentifier` (
  f5 INT
);

CREATE TABLE "quote""andunquote""" (
  f6 INT
);

CREATE VIEW V1 AS 
  SELECT * 
  FROM 
    My$identifier,
    _my_identifier,
    "My 'Identifier'", 
    "$Identifier",
    `Myidentifier`,
    "quote""andunquote"""
  ;