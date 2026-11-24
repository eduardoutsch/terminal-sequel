-- SQL Engine Peculiarities Cheat-Sheet
-- Run individual queries in each tab (PostgreSQL, MySQL, SQLite) or run via:
--   .\run-all.ps1 -Query "<query>"

-- 1. Integer Division
--    PostgreSQL: 0
--    MySQL:      0.5000
--    SQLite:     0
SELECT 1 / 2 AS int_division;

-- 2. String Concatenation (`||` operator)
--    PostgreSQL: 'hello world'
--    MySQL:      0 (because `||` is logical OR unless PIPES_AS_CONCAT is enabled!)
--    SQLite:     'hello world'
SELECT 'hello ' || 'world' AS concat_test;

-- 3. Double Quotes ("...")
--    PostgreSQL: ERROR: column "Kanye" does not exist (double quotes = identifier)
--    MySQL:      1 row (double quotes = string literal unless ANSI_QUOTES is enabled)
--    SQLite:     1 row (falls back to string literal if no matching column exists!)
SELECT * FROM student WHERE name = "Kanye";

-- 4. GROUP BY with non-aggregated column
--    PostgreSQL: ERROR: column "e.grade" must appear in the GROUP BY clause
--    MySQL:      ERROR (with default ONLY_FULL_GROUP_BY)
--    SQLite:     Succeeds and picks an arbitrary row from each group!
SELECT e.cid, e.grade, COUNT(*) AS total
FROM enrolled e
GROUP BY e.cid;

-- 5. NULL ordering in ORDER BY
--    PostgreSQL: NULLs sort LAST by default in ASC; supports NULLS FIRST / NULLS LAST
--    MySQL:      NULLs sort FIRST by default in ASC; syntax error on NULLS FIRST
--    SQLite:     NULLs sort FIRST by default in ASC; supports NULLS FIRST / NULLS LAST
SELECT name, gpa FROM student ORDER BY gpa ASC;

-- 6. Case sensitivity in LIKE
--    PostgreSQL: case-sensitive (returns 0 rows; use ILIKE for case-insensitive)
--    MySQL:      case-insensitive by default (returns 1 row)
--    SQLite:     case-insensitive for ASCII by default (returns 1 row)
SELECT name FROM student WHERE name LIKE 'kanye';

-- 7. COUNT(*) vs COUNT(col)
--    All 3 engines: COUNT(*) = 5, COUNT(gpa) = 4 (NULLs are ignored in aggregates)
SELECT COUNT(*) AS all_rows, COUNT(gpa) AS non_null_gpa FROM student;

-- 8. Dynamic / Flexible Typing (try in each terminal, then rollback/delete)
--    PostgreSQL: ERROR: invalid input syntax for type integer
--    MySQL:      ERROR: Incorrect integer value
--    SQLite:     Succeeds! (type affinity allows storing TEXT in an INTEGER column)
-- INSERT INTO student (sid, name, login, age, gpa) VALUES (99999, 'Test', 'test@cs', 'twenty', 3.0);
