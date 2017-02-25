-- Copyright (C) 2017 HackYourFuture

-- Make sure we're in the right database.
USE class6;

-- Start a transaction.
BEGIN;
-- Get rid of the old tables.
DROP TABLE IF EXISTS todos;
DROP TABLE IF EXISTS statuses;

-- Create the empty statuses table.
-- Field 'Name' is VARCHAR(12), just as field 'Status' was previously in
-- table 'todos'.
CREATE TABLE `statuses` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;

-- Check that the table was created as we expect.
DESCRIBE statuses;

-- Create the empty todos table.
-- Fields 'Id' and 'Name' match HYF materials at:
--   https://github.com/HackYourFuture/databases/
-- Field 'Done' is left after migration to 'Status', but can be used later to
-- explain views (autogenerate based on Status)
-- NOTE: ON DELETE CASCADE is there as a teaching point.
-- Other options:
--   RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
-- See https://dev.mysql.com/doc/refman/5.6/en/create-table-foreign-keys.html
CREATE TABLE `todos` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Done` BOOLEAN DEFAULT false,
  `Name` VARCHAR(255) NOT NULL,
  `StatusId` INT(11) DEFAULT NULL,
  `Due` DATETIME DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `todos_statuses_FK`
    FOREIGN KEY (`StatusId`)
    REFERENCES `statuses` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;

-- Check that the table was created as we expect.
DESCRIBE todos;

-- Consolidate and standardize our previous 'Status' values
INSERT INTO statuses (Name) VALUES ('Not Started');
INSERT INTO statuses (Name) VALUES ('In Progress');
INSERT INTO statuses (Name) VALUES ('Completed');
-- Talk about 'LAST_INSERT_ID()' function here. It will likely do what we want
-- in trivial cases, but as volume gets higher it's not guaranteed.
-- See variable sets below.

-- Display the inserted data
SELECT * FROM statuses;

-- Setup some variables for inserting tasks
-- Ask for exactly what we want, get exactly what we ask for.
SELECT `Id` INTO @notStartedId FROM `statuses` WHERE `Name` = 'Not Started';
SELECT `Id` INTO @inProgressId FROM `statuses` WHERE `Name` = 'In Progress';
SELECT `Id` INTO @completedId FROM `statuses` WHERE `Name` = 'Completed';

-- Some completed tasks
INSERT INTO todos (Name, Done, StatusId, Due)
  VALUES ('Sign up for HackYourFuture', true, @completedId, '20160831000000');
INSERT INTO todos (Name, Done, StatusId, Due)
  VALUES ('Learn HTML', true, @completedId, '20160930000000');
INSERT INTO todos (Name, Done, StatusId, Due)
  VALUES ('Complete Node.js course', true, @completedId, '20170212000000');

-- Some not yet completed tasks
-- Inconsistent 'Status' column is again intentional for same reason
INSERT INTO todos (Name, StatusId, Due)
  VALUES ('Submit week one homework', @notStartedId, '20170226000000');
INSERT INTO todos (Name, StatusId, Due)
  VALUES ('Submit week two homework', @notStartedId, '20170305000000');
INSERT INTO todos (Name, StatusId, Due)
  VALUES ('Submit week three homework', @inProgressId, '20170312000000');

-- Demonstrating optional "Status" column.
INSERT INTO todos (Name, Due)
  VALUES ('Pick up meze for dinner', '20170219163000');
INSERT INTO todos (Name, Due)
  VALUES ('Call New York', '20170222223000');
INSERT INTO todos (Name, Due)
  VALUES ('Buy John a birthday present', '20170901000000');

-- Demonstrating optional "Due" column.
INSERT INTO todos (Name, StatusId)
  VALUES ('Ride my bike from Amsterdam to Groningen', @notStartedId);
INSERT INTO todos (Name, StatusId)
  VALUES ('Teach a class on something I know', @inProgressId);
INSERT INTO todos (Name, Done, StatusId)
  VALUES ('Meet my life partner', true, @completedId);

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
