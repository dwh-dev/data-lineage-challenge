# Test Your Data Lineage Tool
**[Dwh.dev](https://dwh.dev)** team has been dealing with SQL static analysis for a long time, and we know very well that all databases behave differently: unique SQL syntax, object types, and relationships, peculiar behavior of seemingly obvious things. 

Documentation often describes not all the nuances of a database's behavior, or yet sometimes it simply doesn't match the actual state of affairs.

That's why we decided to create a collection of specific use cases for different databases that we've encountered.

You can execute these statements from any of the attached SQL files and check how your selected DATA LINEAGE TOOL handles such syntax. (Spoiler: not very well). 

Additionally, we've attached the results of **[Dwh.dev](https://dwh.dev)**'s work so that you can make the right choice :)

Let's start with **Snowflake** because at the moment, we know this database the best. 
In this repository, we intentionally won't cover cases with special **Snowflake** objects (PIPE, STREAM, TASK, POLICY, etc.) because the vast majority of existing DATA LINEAGE TOOLS know nothing about them and won't provide you any information (but not **[Dwh.dev](https://dwh.dev)**). 

The focus will be on the peculiar behavior of regular objects and the relationships encapsulated within them. 

Some of the **Snowflake** syntax exists for compatibility with other databases.

We'll also tell you about the functionality of **[Dwh.dev](https://dwh.dev)**, which, in our opinion, should exist in all DATA LINEAGE TOOLS, but unfortunately doesn't exist yet...

The repository will be updated, stay tuned!

# Identifiers

### Basic Syntax
**Snowflake** provides an extensive toolkit for working with object and column identifiers. Let's start with the basics: identifiers with and without quotes ([documentation](https://docs.snowflake.com/en/sql-reference/identifiers-syntax))

Even at this stage, we won't achieve full compatibility with the syntax of other databases. However, two nuances deserve special attention:
- Identifiers without quotes are converted to uppercase.
- Identifiers within backticks behave similarly.

```sql
CREATE TABLE `Myidentifier` (
  f5 INT
);

CREATE TABLE "quote""andunquote""" (
  f6 INT
);
```

We collected all the varieties of the basic syntax [in 1.identifiers.1.sql](./snowflake/1.identifiers/sql/1.identifiers.1.sql)

Here is the **[Dwh.dev](https://dwh.dev)** result:

[<img src="./snowflake/1.identifiers/media/1.identifiers.1.jpg" alt="dwh.dev identifiers #1" height=400 />](./snowflake/1.identifiers/media/1.identifiers.1.jpg)


### Special syntax
In addition to the basic syntax, **Snowflake** has special functionality:

- [Literals and Variables as Identifiers](https://docs.snowflake.com/en/sql-reference/identifier-literal).
A special **IDENTIFIER()** function to get a reference to an object or column from a session variable or string.

- [Table Literals](https://docs.snowflake.com/en/sql-reference/literals-table)
Special function **TABLE()** to get a reference to an object from a session variable or string.

- [Double-Dot Notation](https://docs.snowflake.com/en/sql-reference/name-resolution#resolution-when-schema-omitted-double-dot-notation)
A special syntax that allows the **PUBLIC** scheme to be omitted when addressing an object.


```sql

CREATE VIEW V1 AS
  SELECT * 
  FROM
    identifier($table_var1)
;

-- Column Identifier
CREATE VIEW V4 AS
  SELECT identifier('DEMO_DB.SCH1.T1.V1'):json_prop as prop 
  FROM 
    DEMO_DB.SCH1.T1
;

-- Double-Dot Notation
CREATE VIEW V8 AS
  SELECT * 
  FROM
    DEMO_DB..T3
;
```

This syntax is often found in the description of transformations, because it helps to use the same source code with different object names.

We have collected all kinds of special syntax [in 1.identifiers.2.sql](./snowflake/1.identifiers/sql/1.identifiers.2.sql).

Here is the **[Dwh.dev](https://dwh.dev)** result:


[<img src="./snowflake/1.identifiers/media/1.identifiers.2.jpg" alt="dwh.dev identifiers #2" height=400/>](./snowflake/1.identifiers/media/1.identifiers.2.jpg)
