-- DML -> Database Manipulation Language

CREATE TABLE coaches (
    coach_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    last_name VARCHAR(200),
    salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
    email VARCHAR(500) NOT NULL
) engine = innodb;

-- 1. INSERT INTO: add a new row

-- Insert One
INSERT INTO coaches (first_name, email) VALUES("David", "david@swimcoaches.com");

-- salary cannot be NULL
-- ("Peter", NULL, NULL, "peterparker@swimcoaches.com"),

-- Insert Many
INSERT INTO coaches (first_name, last_name, salary, email)
 VALUES ("Tony", "Stark", 3000, "tonystark@swimcoaches.com"),        
        ("Peter", NULL, 4000, "peterparker@swimcoaches.com"),
        ("Eddard", "Stark", 4500, "eddard@swimcoaches.com");


-- Due to AUTO_INCREMENT command in PRIMARY KEY,
-- Gaps in _id are common since used ids will not be repeated,
-- also unsuccessful inserts will create ids that become unuseable,

INSERT INTO coaches (first_name, email) VALUES ("John", "johnwick@asd.com");

-- 2. UPDATE FROM: update an existing row

-- Update One
UPDATE coaches SET salary=30000 WHERE coach_id = 5;

-- Update Many
UPDATE coaches SET salary=salary*1.1 WHERE salary < 5000;

-- if no WHERE it will update all the rows
-- UPDATE coaches SET salary=30000

UPDATE coaches SET last_name="Park", email="peterpark@swimcoaches.com"
    WHERE coach_id = 6;

-- 3. DELETE FROM: delete an existing row

DELETE FROM coaches WHERE coach_id = 7;

