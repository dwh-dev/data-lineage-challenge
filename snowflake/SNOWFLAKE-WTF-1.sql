create or replace table t1(a int, b int);
create or replace table t2(c int, d int);

-- EMPTY TABLES
SELECT * FROM t1 CROSS JOIN t1 a;
-- A B A_2 B_2

SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1

SELECT a_2 FROM (
SELECT * FROM t1 CROSS JOIN t1 a
);
-- Error: invalid identifier 'A_2' 

SELECT * FROM t1 CROSS JOIN t1 a;
SELECT A_1 FROM 
(
    SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()))
);
-- OK

----

SELECT * FROM t1 CROSS JOIN t2 as a(a,b);
-- A B A_2 B_2

SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1

SELECT * FROM t1 LEFT JOIN t1 tn USING(a);
-- A B B_2

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B B_1

SELECT * FROM (SELECT * FROM t1 CROSS JOIN t1 a);
-- A B A_2 B_2

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1

----

SELECT *
FROM t1 
  left join t1 a USING(a)
  left join t1 b USING(a)
;
-- A B B_2

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
;
-- A B B_1

SELECT *
FROM t1 
  left join t1 a ON t1.a = a.a
  left join t1 b ON t1.a = b.a
;
--A B A_2 B_2 A_3 B_3

SELECT * from  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1 A_2 B_2


SELECT *
FROM t1 
  left join t1 a USING(a)
  left join t1 b USING(a)
  left join t1 c USING(a)
  join t2 on b = c;

-----------------------------------------
-- TABLE T1 IS NOT EMPTY
insert into t1 select 1,2;
SELECT * FROM t1 CROSS JOIN t1 a;
-- A B A B

SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1


SELECT * FROM t1 CROSS JOIN t2 as a(a,b);
-- A B A_2 B_2

SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1

SELECT * FROM t1 LEFT JOIN t1 tn USING(a);
-- A B B

SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B B_1

SELECT *
FROM t1 
  left join t1 a USING(a)
  left join t1 b USING(a)
;
-- A B B

SELECT * FROM  TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B B_1

SELECT *
FROM t1 
  left join t1 a ON t1.a = a.a
  left join t1 b ON t1.a = b.a
;
--A B A B A B

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
-- A B A_1 B_1 A_2 B_2





-----------------------------------------
-- BOTH TABLES ARE NOT EMPTY
insert into t2 select 1,2;
SELECT * FROM t1 CROSS JOIN t1 a;
-- A B A B

SELECT * FROM t1 CROSS JOIN t2 as a(a,b);
-- A B A B

SELECT * FROM t1 LEFT JOIN t1 tn USING(a);
-- A B B

-----------------------------------------

CREATE TABLE T10 (A INT, B INT);
CREATE TABLE T11 (A INT, C INT);
CREATE TABLE T12 (A INT, D INT);
CREATE TABLE T13 (A INT, B INT);

SELECT
  * 
FROM T10
  LEFT JOIN T11 USING(A)
  LEFT JOIN T12 USING(A)
  LEFT JOIN T13 USING(A);

-- A B C D B_2

SELECT
  * 
FROM T10
  LEFT JOIN T11 USING(A)
  LEFT JOIN T12 USING(A)
  LEFT JOIN T13 USING(A)
  LEFT JOIN T13 x USING(A);

-- A B C D B_2

SELECT
  * 
FROM T10
  LEFT JOIN T11 USING(A)
  LEFT JOIN T12 USING(A)
  LEFT JOIN T13 USING(A)
  LEFT JOIN T10 x USING(A);

-- A B C D B_2

