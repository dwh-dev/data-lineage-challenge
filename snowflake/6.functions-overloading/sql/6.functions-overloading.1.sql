CREATE TABLE A(ID INT);
CREATE TABLE B(S STRING);

CREATE OR REPLACE FUNCTION fn_overload ( _id number )
  RETURNS TABLE (id int)
  AS 'select id from a where id > _id'
;


CREATE OR REPLACE FUNCTION fn_overload ( _s string )
  RETURNS TABLE (s string)
  AS 'select s from b where s != _s'
;

CREATE VIEW V1 AS
SELECT * FROM TABLE(fn_overload(1));

CREATE VIEW V2 AS
SELECT * FROM TABLE(fn_overload('1'));