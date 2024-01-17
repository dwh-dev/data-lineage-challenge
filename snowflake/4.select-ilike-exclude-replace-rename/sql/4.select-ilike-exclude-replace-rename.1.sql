CREATE OR REPLACE DATABASE DWHDEMO_DB04;

CREATE TABLE t17 (a INT, b STRING);
CREATE VIEW v17 AS
  SELECT 
    *
      EXCLUDE a
      RENAME b AS c 
  FROM t17
;

CREATE TABLE t18(int_col INT, d DECIMAL(10,5), s1 VARCHAR(10), s2 VARCHAR(10));
CREATE VIEW v18 AS
  WITH a AS (
    SELECT 
      *
        EXCLUDE (int_col, d)
        RENAME (s1 AS x1, s2 AS x2 )
    FROM t18
  )
  SELECT
    *
      EXCLUDE (x1)
      RENAME (x2 AS y2 )
  FROM a
;

CREATE TABLE t19(
  id INT,
  c1 BOOLEAN, 
  c2 BOOLEAN,
  c3 BOOLEAN,
  c4 BOOLEAN,
  c12c BOOLEAN
);
CREATE VIEW v19 AS
  SELECT 
    *
      ILIKE 'c_'
  FROM t19
;

CREATE TABLE t20(
  c5 BOOLEAN, 
  c6 BOOLEAN
);
CREATE VIEW v20 AS
  SELECT
    * 
      ILIKE 'c%' 
      REPLACE (a.c1 OR b.$2 AS c1)
      RENAME c1 AS c0
  FROM t19 a, t20 b
;
