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
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;

-- Check that the table was created as we expect.
DESCRIBE todos;

-- Some completed tasks
INSERT INTO todos (Name, Done)
  VALUES ('Sign up for HackYourFuture', true);
INSERT INTO todos (Name, Done)
  VALUES ('Learn HTML', true);
INSERT INTO todos (Name, Done)
  VALUES ('Complete Node.js course', true);
INSERT INTO todos (Name, Done)
  VALUES ('Meet my life partner', true);

-- Some not yet completed tasks
INSERT INTO todos (Name, Done)
  VALUES ('Submit database week one homework', false);
INSERT INTO todos (Name, Done)
  VALUES ('Submit database week two homework', false);
INSERT INTO todos (Name, Done)
  VALUES ('Submit database week three homework', false);

-- Demonstrating optional "Done" column.
INSERT INTO todos (Name)
  VALUES ('Pick up meze for dinner');
INSERT INTO todos (Name)
  VALUES ('Call New York');
INSERT INTO todos (Name)
  VALUES ('Buy John a birthday present');
INSERT INTO todos (Name)
  VALUES ('Ride my bike from Amsterdam to Groningen');
INSERT INTO todos (Name)
  VALUES ('Teach a class on something I know');
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