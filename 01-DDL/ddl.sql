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

-- INSERT INTO students (name, date_of_birth) VALUES ("Jon Snow", "1984-06-13");
-- INSERT INTO students (name, date_of_birth, parent_id) VALUES ("Jon Snow", "1984-06-13", 99);

INSERT INTO students (name, date_of_birth, parent_id) VALUES ("Jon Snow", "1984-06-13", 1);

SELECT * FROM students;

-- DELETE FROM parents WHERE parents_id = 1;

-- DROP TABLE parents;

