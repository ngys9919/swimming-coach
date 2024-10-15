-- DDL -> Database Definition Language 

-- 12102024 (Saturday)

show databases;

create database swimming_coach;

use swimming_coach;

create table parents(
    parent_id int unsigned auto_increment primary key,
    first_name varchar(200) not null,
    last_name varchar(200) default ''
) engine = innodb;

show tables;

create table students (
    student_id mediumint unsigned auto_increment primary key,
    name varchar(200) not null,
    date_of_birth datetime not null
) engine = innodb;

show tables;

ALTER TABLE students ADD COLUMN parent_id INT UNSIGNED;

DESCRIBE students;

ALTER TABLE students ADD CONSTRAINT fk_students_parents
FOREIGN KEY (parent_id) REFERENCES parents(parent_id);

ALTER TABLE students MODIFY COLUMN parent_id INT UNSIGNED NOT NULL;

INSERT INTO parents (first_name, last_name) VALUES ("JOHN", "WICK");

SELECT * FROM parents;

-- INSERT INTO students (name, date_of_birth) VALUES ("Jon Snow", "1984-06-13"); // This wont work
-- INSERT INTO students (name, date_of_birth, parent_id) VALUES ("Jon Snow", "1984-06-13", 99); // This wont work

INSERT INTO students (name, date_of_birth, parent_id) VALUES ("Jon Snow", "1984-06-13", 1);

SELECT * FROM students;

-- DELETE FROM parents WHERE parents_id = 1; // This wont work 

-- DROP TABLE parents; // This wont work because parents Table is not empty

-- 14102024 (Monday)

use swimming_coach;

CREATE TABLE payments (
    payment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date_paid DATETIME NOT NULL,
    parent_id INT UNSIGNED NOT NULL,
    FOREIGN KEY(parent_id) REFERENCES parents(parent_id),
    student_id MEDIUMINT UNSIGNED NOT NULL,
    FOREIGN KEY(student_id) REFERENCES students(student_id)     
) engine = innodb;

describe payments;

ALTER TABLE payments ADD COLUMN amount DECIMAL(10,2);

ALTER TABLE payments MODIFY COLUMN amount DECIMAL(10,2) NOT NULL;

SELECT * FROM coaches LIMIT 100;


