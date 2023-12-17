CREATE DATABASE DWHDEMO_DB2;

-- default value
CREATE TABLE t1 (
  id1 int,
  id2 int default (id1 +1)
);

CREATE VIEW v1 AS
  SELECT *
  FROM t1
;

-- virtual column
CREATE TABLE T2 (
  A INT,
  B INT,
  C INT,
  D INT AS (CASE WHEN A>0 THEN B ELSE C END)
);

CREATE VIEW v2 AS
  SELECT *
  FROM t2
;