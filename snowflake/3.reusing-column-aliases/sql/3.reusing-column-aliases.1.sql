CREATE OR REPLACE DATABASE DWHDEMO_DB03;

CREATE TABLE abc AS SELECT 1 AS a, 100 AS b, 1000 AS c;

CREATE VIEW v13 AS 
SELECT 
    a+1 AS b,
    b+1 AS c
FROM abc;

CREATE VIEW v14 AS 
SELECT 
    a+1 AS d,
    d+1 AS e
FROM abc;

CREATE TABLE t12 AS SELECT 1 AS a, 100 AS b;
CREATE TABLE t13 AS SELECT 1 AS c, 100 AS d;

CREATE VIEW v15 AS
SELECT 
 a + b AS e,
 c + d AS f
FROM 
  t12 
  JOIN t13 ON e =f
;

CREATE VIEW v16 AS
SELECT 
  a1 + b1 AS e,
  c1 + d1 AS f,
  ROUND(e, f) AS g,
  ROUND(f, e) AS h 
FROM 
  t12 AS t121(a1,b1) 
  JOIN t13 AS t131(c1,d1) ON e = f
where 
  g = h
;

