CREATE TABLE A(ID INT);
CREATE TABLE B(S STRING);

CREATE OR REPLACE FUNCTION fn_override ( _id number )
  RETURNS TABLE (id int)
  AS 'select id from a where id > _id'
;


CREATE OR REPLACE FUNCTION fn_override ( _s string )
  RETURNS TABLE (s string)
  AS 'select s from b where s != _s'
;

CREATE VIEW V1 AS
SELECT * FROM TABLE(fn_override(1));

CREATE VIEW V2 AS
SELECT * FROM TABLE(fn_override('1'));