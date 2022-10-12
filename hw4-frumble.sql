-- 1) Creating bad table directly for Frumble file
CREATE TABLE Frumble (
  --id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(6),
  discount VARCHAR(3),
  month VARCHAR(3),
  price DOUBLE
);

-- 2) Checking for each dependency
-- 2.1) name -> discount? == FALSE
SELECT COUNT(*) FROM (
  SELECT name FROM Frumble
  GROUP BY name HAVING COUNT(DISTINCT discount) > 1
);
-- It returns 36 (more than 0) so there exists more than
-- one distinct discount values for each name
-- It tells us that discount doesn't depend on name

-- 2.2) name -> price? == TRUE
SELECT COUNT(*) FROM (
  SELECT name FROM Frumble
  GROUP BY name HAVING COUNT(DISTINCT price) > 1
);
-- It returns 0, so one name value determines one price
-- So, name -> price

-- 2.3) month -> discount? == TRUE, returned 0 row
SELECT COUNT(*) FROM (
  SELECT month FROM Frumble
  GROUP BY month HAVING COUNT(DISTINCT discount) > 1
);

-- 2.4) discount -> month? == FALSE, returned 3 rows
SELECT COUNT(*) FROM (
  SELECT discount FROM Frumble
  GROUP BY discount HAVING COUNT(DISTINCT month) > 1
);

-- 2.5) name, month -> price? == TRUE, returned 0 row
SELECT COUNT(*) FROM (
  SELECT name, month FROM Frumble
  GROUP BY name, month HAVING COUNT(DISTINCT price) > 1
);

-- In Summary, there are two dependencies in Frumble
-- month -> discount
-- name -> price

-- 3) Creating table that satisfies the BCNF
CREATE TABLE User (
  name VARCHAR(6) PRIMARY KEY,
  price DOUBLE
);
CREATE TABLE Promotion (
  month VARCHAR(3) PRIMARY KEY,
  discount VARCHAR(3)
);
CREATE TABLE Purchase (
  u_name VARCHAR(6) REFERENCES User,
  p_month VARCHAR(3) REFERENCES Promotion,
  PRIMARY KEY (u_name, p_month)
);

-- 4) Insert the Frumble data into the new database schema
INSERT INTO User
SELECT name, MAX(price)
FROM Frumble
GROUP BY name;

INSERT INTO Promotion
SELECT month, MAX(discount)
FROM Frumble
GROUP BY month;

INSERT INTO Purchase
SELECT name, month
FROM Frumble;

-- 4.2) Output the rows for each tables
SELECT COUNT(*) FROM User;
-- 36 Rows
SELECT COUNT(*) FROM Promotion;
-- 12 Rows
SELECT COUNT(*) FROM Purchase;
-- 426 Rows
