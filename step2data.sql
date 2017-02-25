-- Copyright (C) 2017 HackYourFuture

-- Make sure we're in the right database.
USE class6;

-- Start a transaction.
BEGIN;
-- Get rid of the old todos table.
DROP TABLE IF EXISTS todos;

-- Create the empty todos table.
-- Fields 'Id' and 'Name' match HYF materials at:
--   https://github.com/HackYourFuture/databases/
-- Field 'Done' is left after migration to 'Status', but can be used later to
-- explain views (autogenerate based on Status)
CREATE TABLE `todos` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Done` BOOLEAN DEFAULT false,
  `Name` VARCHAR(255) NOT NULL,
  `Status` VARCHAR(12) DEFAULT 'Not Started',
  `Due` DATETIME DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;

-- Check that the table was created as we expect.
DESCRIBE todos;

-- Some completed tasks
-- Inconsistent 'Status' column is intentional to introduce normalization
INSERT INTO todos (Name, Done, Status, Due)
  VALUES ('Sign up for HackYourFuture', true, 'Completed', '20160831000000');
INSERT INTO todos (Name, Done, Status, Due)
  VALUES ('Learn HTML', true, 'Finished', '20160930000000');
INSERT INTO todos (Name, Done, Status, Due)
  VALUES ('Complete Node.js course', true, 'Done', '20170212000000');

-- Some not yet completed tasks
-- Inconsistent 'Status' column is again intentional for same reason
INSERT INTO todos (Name, Status, Due)
  VALUES ('Submit week one homework', 'Not started', '20170226000000');
INSERT INTO todos (Name, Status, Due)
  VALUES ('Submit week two homework', 'Not strted', '20170305000000');
INSERT INTO todos (Name, Status, Due)
  VALUES ('Submit week three homework', 'Incomplete', '20170312000000');

-- Demonstrating optional "Status" column.
INSERT INTO todos (Name, Due)
  VALUES ('Pick up meze for dinner', '20170219163000');
INSERT INTO todos (Name, Due)
  VALUES ('Call New York', '20170222223000');
INSERT INTO todos (Name, Due)
  VALUES ('Buy John a birthday present', '20170901000000');

-- Demonstrating optional "Due" column.
INSERT INTO todos (Name, Status)
  VALUES ('Ride my bike from Amsterdam to Groningen', 'Not started');
INSERT INTO todos (Name, Status)
  VALUES ('Teach a class on something I know', 'In progress');
INSERT INTO todos (Name, Done, Status)
  VALUES ('Meet my life partner', true, 'Complete');

-- Demonstrating that both optional columns can be left out.
INSERT INTO todos (Name)
  VALUES ('Write my memoirs');
INSERT INTO todos (Name)
  VALUES ('Sail around the world');
INSERT INTO todos (Name)
  VALUES ('Learn cross-country skiing.');

-- Display the inserted data.
SELECT * FROM todos;

-- Commit the entire transaction.
COMMIT;