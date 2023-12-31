SET db_var = 'DWHDEMO_DB01_1';
SET schema_var = 'DWHDEMO_DB01_1.SCH1';
SET table_var1 = 'T1';
SET table_var2 = 'public.t3';
SET tablefunction = 'tblfn';

CREATE OR REPLACE DATABASE identifier($db_var);
CREATE SCHEMA identifier($schema_var);

CREATE TABLE identifier($table_var1) (
  i1 INT,
  v1 VARIANT
);
CREATE TABLE identifier($table_var2) (
  f3 INT
);

CREATE FUNCTION tblfn()
RETURNS TABLE (
  C1 INT, C2 VARIANT
) AS
  $$
    SELECT
      *
    FROM
      T1
  $$
;

-- Object Identifier
CREATE VIEW V1 AS
  SELECT * 
  FROM
    identifier($table_var1)
;

CREATE VIEW V2 AS
  SELECT identifier($table_var1).*
  FROM
    identifier($table_var1)
;

CREATE VIEW V3 AS
  SELECT *
  FROM
    TABLE(identifier($tablefunction)())
;

-- Column Identifier
CREATE VIEW V4 AS
  SELECT identifier('DWHDEMO_DB01_1.SCH1.T1.V1'):json_prop as prop 
  FROM 
    DWHDEMO_DB01_1.SCH1.T1
;

CREATE VIEW V5 AS
  with t(x) as (
    SELECT i1 FROM T1
  )
  SELECT identifier('t.x')
  FROM t
;

-- Table Literal
CREATE VIEW V6 AS
  SELECT * 
  FROM
    table('t1')
;

CREATE VIEW V7 AS
  SELECT *
  FROM
    table($$DWHDEMO_DB01_1."SCH1"."T1"$$)
;

-- Double-Dot Notation
CREATE VIEW V8 AS
  SELECT * 
  FROM
    DWHDEMO_DB01_1..T3
;