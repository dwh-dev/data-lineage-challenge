# Data Lineage Challenge
**[Dwh.dev](https://dwh.dev)** team has been dealing with SQL static analysis for a long time, and we know very well that all databases behave differently: unique SQL syntax, object types, and relationships, peculiar behavior of seemingly obvious things. 

Documentation often describes not all the nuances of a database's behavior, or yet sometimes it simply doesn't match the actual state of affairs.

That's why we decided to create a collection of specific use cases for different databases that we've encountered.

You can execute these statements from any of the attached SQL files and check how your selected DATA LINEAGE TOOL handles such syntax. (Spoiler: not very well). 

Additionally, we've attached the results of **[Dwh.dev](https://dwh.dev)**'s work so that you can make the right choice!

**Feel free to send us the results from other data lineage tools using these examples. We will add them for comparison :)**

Let's start with **Snowflake** because at the moment, we know this database the best. 

In this repository (in [Snowflake SQL Syntax and Behavior](#snowflake-sql-syntax-and-behavior) section), we intentionally won't cover cases with special **Snowflake** objects (PIPE, STREAM, TASK, POLICY, etc.) because the vast majority of existing **DATA LINEAGE TOOLS** know nothing about them and won't provide you any information (but not **[Dwh.dev](https://dwh.dev)**). 

The focus will be on the peculiar behavior of regular objects and the relationships encapsulated within them. 

Some of the **Snowflake** syntax exists for compatibility with other databases.

We'll also tell you about the functionality of **[Dwh.dev](https://dwh.dev)**, which, in our opinion, should exist in all **DATA LINEAGE TOOLS**, but unfortunately doesn't exist yet...

The repository will be updated, stay tuned!

PS: Also **[Dwh.dev](https://dwh.dev)** provides an API for SQL parsing and compilation. [Contact us](mailto:oem@dwh.dev) to get demo access. We cooperate with different data companies (even our competitors)

## Snowflake SQL Syntax and Behavior
- [Identifiers](#identifiers)
- [Default and Virtual Columns](#default-and-virtual-columns)
- [Reusing column aliases](#reusing-column-aliases)
- [SELECT \* ILIKE EXCLUDE REPLACE RENAME](#select-ilike-exclude-replace-rename)
- Scalar Functions from PUBLIC schema
- Function overloading
- Objects auto renaming
- Columns auto renaming
- CTE name equals existing object
- CTE as an expression alias

## Dwh.dev Features
- [Navigation](#navigation)
- [Join and Where](#join-and-where)
- [Strong and Weak dependencies](#strong-and-weak-dependencies)
- [Fancy SQL Highlight](#fancy-sql-highlight)
- Tasks and Pipes
- Argument forwarding
- Circle dependencies

# Snowflake SQL Syntax and Behavior
## Identifiers

### Basic Syntax ([Youtube](https://youtu.be/RIfgdpIOA3Q))
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


### Special syntax ([Youtube](https://youtu.be/hGf2VtBxzHU))
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


## Default and Virtual Columns
[Youtube](https://youtu.be/eLi8CnXP8LA)

**Default and Virtual Columns** also contain information about data lineage. And as usual, nobody pays attention to it :)

```sql
-- default value
CREATE TABLE t1 (
  id1 int,
  id2 int default (id1 +1)
);

CREATE VIEW v1 AS
  SELECT *
  FROM t1
;
```

If during data transformations, only the id1 column is inserted into the **T1** table, the lineage information will be lost.

At **[Dwh.dev](https://dwh.dev)**, we display it like this:

[<img src="./snowflake/2.default-and-virtual-columns/media/default-virtual.1.png" alt="dwh.dev default columns"/>](./snowflake/2.default-and-virtual-columns/media/default-virtual.1.png)

With **Virtual columns**, an even more precarious situation arises. It's impossible to insert data into a virtual column, and they will ALWAYS depend on other columns in the table.
```sql
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
```
At **[Dwh.dev](https://dwh.dev)**, we display it like this:
[<img src="./snowflake/2.default-and-virtual-columns/media/default-virtual.2.png" alt="dwh.dev virtual columns"/>](./snowflake/2.default-and-virtual-columns/media/default-virtual.2.png)

Source is [in 2.default-and-virtual-columns.1.sql](./snowflake/2.default-and-virtual-columns/sql/2.default-and-virtual-columns.1.sql)

## Reusing column aliases

In any database, you can use aliases for both columns and expressions within queries:

```sql
SELECT
    id AS user_id,
    name AS user_name,
    age AS user_age,
    age * 2 AS user_age_doubled
FROM users;
```

But what can we do with these aliases?
Database vendors allow different things. For example, in MySQL and PostgreSQL, aliases can only be used in **GROUP BY** and **ORDER BY**.
In Clickhouse and **Snowflake**, however, aliases can be used everywhere. But, as usual, there are nuances :)

Let's create syntactically identical VIEWs:

```sql
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
```
At first glance, the lineage for these views should be the same. But let's see what happened:
[<img src="./snowflake/3.reusing-column-aliases/media/3.reusing-column-aliases.1.png" alt="dwh.dev reusing column aliases"/>](./snowflake/3.reusing-column-aliases/media/3.reusing-column-aliases.1.png)

Why in **V13** the column **C** did not reuse the alias **B**? Because in **Snowflake**, when using an alias equivalent to the original column name from the source, the original column takes precedence!

By the way, in Clickhouse, it works differently...

What was meant by saying that aliases work everywhere?

Aliases can be reused in JOIN and WHERE clauses:
```sql
CREATE TABLE t12 AS SELECT 1 AS a, 100 AS b;
CREATE TABLE t13 AS SELECT 1 AS c, 100 AS d;

CREATE VIEW v15 AS
SELECT 
 a + b AS e,
 c + d AS f
FROM 
  t12 
  JOIN t13 ON e = f;
```

or even like this:
```sql
CREATE VIEW v16 AS
SELECT 
  a1 + b1 AS e,
  c1 + d1 AS f,
  ROUND(e, f) AS g,
  ROUND(f, e) AS h 
FROM 
  t12 AS t121(a1, b1) 
  JOIN t13 AS t131(c1, d1) ON e = f
WHERE 
  g = h;
```
Since in **[Dwh.dev](https://dwh.dev)** we display not only the data flows but also [the columns used in JOIN and WHERE](#join-and-where), you will also see the original column sources in the corresponding section.

Source is [in 3.reusing-column-aliases.1.sql](./snowflake/3.reusing-column-aliases/sql/3.reusing-column-aliases.1.sql)

## SELECT ILIKE EXCLUDE REPLACE RENAME
Database vendors are competing to see who can come up with the most features for **SELECT \***.
**Snowflake** is not lagging behind and supports as many as 4 modifiers for **SELECT \***:  
**ILIKE EXCLUDE REPLACE RENAME**

We all know that **SELECT \*** is bad. Now it's 4 times worse :)  
Ok, 3. You can't use them all together (either **ILIKE** or **EXCLUDE**).

But the most disgusting modifier is **REPLACE**. It allows you to replace one column with any expression. Good luck debugging, dudes :)

What happens to lineage when using these modifiers? 
A few examples are collected here:
[in 4.select-ilike-exclude-replace-rename.1.sql](./snowflake/4.select-ilike-exclude-replace-rename/sql/4.select-ilike-exclude-replace-rename.1.sql)

Take a look at one of them:
```sql
CREATE TABLE t19(
  id INT,
  c1 BOOLEAN, 
  c2 BOOLEAN,
  c3 BOOLEAN,
  c4 BOOLEAN,
  c12c BOOLEAN
);
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
```

At **[Dwh.dev](https://dwh.dev)**, we display it like this:
[<img src="./snowflake/4.select-ilike-exclude-replace-rename/media/4.select-ilike-exclude-replace-rename.1.png" alt="dwh.dev SELECT * ILIKE EXCLUDE REPLACE RENAME"/>](./snowflake/4.select-ilike-exclude-replace-rename/media/4.select-ilike-exclude-replace-rename.1.png)



# Dwh.dev Features
## Navigation
[Youtube](https://youtu.be/BS0XvzyTnwA)
The commonly accepted navigation standard for Lineage is "expanding" each subsequent level on demand. This involves requesting information about each subsequent level from the backend.

At **[Dwh.dev](https://dwh.dev)**, we took a different approach - dependency information is loaded to the client, allowing us to display the necessary number of levels instantly, rebuilding the graph as needed.

Small graphs (with up to 500 connections) can be displayed entirely. Large graphs are available for exploration only in parts. Initially, through a search, you find the necessary object in the catalog and by clicking the "lineage" button, you enter the "group" of that object.

[<img src="./dwh/media/navigation.1.png" alt="dwh.dev navigation #1"/>](./dwh/media/navigation.1.png)

The main object of the group is highlighted with a dashed border.

The lineage screen supports scaling, scrolling, various types of centering, and a mini-map. You can always return to the main object by clicking the first button in the button group, aligning it in the toolbar, or by the object name in the top right.

[<img src="./dwh/media/toolbar.png" alt="dwh.dev toolbar"/>](./dwh/media/toolbar.png)

To the left of the central object are **Upstream** objects; to the right, **Downstream** objects. **Upstream** objects may have violet circles on the right side of the object. The numbers in these circles indicate the number of objects in **Downstream** that do not belong to the current group. Similarly, there is a green circle on the left of **Downstream** objects, indicating the number of objects from **Upstream** outside of this group.

To enter a group of any of the objects on the screen, double-click on it. To go back, press ESC.

By default, 2 levels of lineage are displayed. You can change this value in the settings panel under **Stream Options**:

[<img src="./dwh/media/navigation.2.png" alt="dwh.dev navigation #2"/>](./dwh/media/navigation.2.png)

You can also quickly disable the display of all Upstream/Downstream levels in the toolbar with the **"Toggle stream length to 0"** buttons.

If you want to explore the graph in a "classic" mode, navigating through its levels by "expanding" them, there is a **"Custom Path"** mode for this purpose:

[<img src="./dwh/media/custom-path.1.png" alt="dwh.dev navigation #3 - custom path #1"/>](./dwh/media/custom-path.1.png)

The labels on the edges of the graph show how many levels are hidden in this branch, the number of objects in the first level, and the total number of objects.

You can highlight only the objects that interest you at the moment:

[<img src="./dwh/media/custom-path.2.png" alt="dwh.dev navigation #3 - custom path #2"/>](./dwh/media/custom-path.2.png)

When working with complex graphs, even in **"Custom Path"** mode, it can be challenging to orient oneself. Therefore, you can "straighten" the selected path using the **"Straighten the path"** button in the toolbar:

[<img src="./dwh/media/custom-path.3.png" alt="dwh.dev navigation #3 - custom path #3"/>](./dwh/media/custom-path.3.png)

Both of these modes also work at the column level:

[<img src="./dwh/media/c2c.1.png" alt="dwh.dev navigation #3 - c2c #1"/>](./dwh/media/c2c.1.png)

[<img src="./dwh/media/c2c.2.png" alt="dwh.dev navigation #3 - c2c #2"/>](./dwh/media/c2c.2.png)


## Join and Where

Typically, data lineage tools provide information about the immediate movement of data within the database:

```sql
CREATE VIEW v1
AS 
  SELECT c1
  FROM t1
```
Data from the column **t1.c1** flows into **v1.c1**:

[<img src="./dwh/media/jw.1.png" alt="dwh.dev join and where #1"/>](./dwh/media/jw.1.png)

However, this data might be insufficient when it comes to refactoring. For instance, when certain columns aren't involved in the data movement but are only involved in **JOIN** or **WHERE** clauses:

```sql
CREATE VIEW v2
AS 
  SELECT c1
  FROM t1
    JOIN t2 ON t1.id = t2.parent_id
  WHERE 
    t1.c2 > t2.f2
```

Usually, data lineage tools won't provide information about columns **t1.id, t1.c2, t2.parent_id, t2.f2**, but at **[Dwh.dev](https://dwh.dev)**, we've made them visible!

[<img src="./dwh/media/jw.2.png" alt="dwh.dev join and where #2"/>](./dwh/media/jw.2.png)

## Strong and Weak dependencies
[Youtube](https://youtu.be/jQeVVlqxjj8)

In the previous section, we talked about displaying columns that are used in JOIN and WHERE clauses.
But we wanted to go further :)

Even if columns are data sources, it makes sense to divide them into 2 categories: columns that are direct data sources and columns that only influence them.

For example:
```sql
SELECT
  ROUND(a, b)
FROM t
```

Here, column A is a direct data source, while B is not. B influences the result, but A is the primary source.

Another example:
```sql
SELECT
  CASE
    WHEN A IS NULL
      THEN B
    ELSE C 
  END
FROM t
```
Here, the value from A doesn't appear in the result but affects it.

At **[Dwh.dev](https://dwh.dev)**, we divided such dependencies into classes: **STRONG** and **WEAK**. We annotated all core functions to determine which argument belongs to which class. We also analyze CASE WHEN and other cases.
You can disable any of these classes in the settings panel:

[<img src="./dwh/media/strong-weak.png" alt="dwh.dev strong and weak sources"/>](./dwh/media/strong-weak.png)

Source is [in 3.strong-and-weak-sources.sql](./dwh/sql/dwhdev-features.strong-and-weak-sources.sql)

## Fancy SQL Highlight
The static analyzer **[Dwh.dev](https://dwh.dev)** allows having comprehensive information about all objects and columns at any point in an SQL query. This enables making SQL highlighting more convenient and functional.

In detailed object information and in the DDL on the Lineage screen, you can observe SQL highlighting in this manner:

[<img src="./dwh/media/highlight.1.png" alt="dwh.dev highlight #1"/>](./dwh/media/highlight.1.png)

Each object has an icon corresponding to its type and is clickable. Clicking on it will take you to the selected object. We distinguish all types of Snowflake objects - TABLE, VIEW, STAGE, STREAM, FUNCTION, etc.

Additionally, we've created a reference guide for core functions. Hovering over such a function in SQL, you'll see a brief description:

[<img src="./dwh/media/highlight.2.png" alt="dwh.dev highlight #2"/>](./dwh/media/highlight.2.png)

Clicking will expand the details and provide a link to the original documentation.

