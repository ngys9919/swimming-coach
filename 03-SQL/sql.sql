-- SQL -> Structured Query Language

-- Using MySQLTutorial at website url:

-- https://www.mysqltutorial.org/tryit/

-- This SQL tutorial is using a MySQL Sample Database known as classicmodels.
-- The classicmodels database is a retailer of scale models of classic cars. It contains typical business data, 
-- including information about customers, products, sales orders, sales order line items, and more.

-- https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/

-- describe (DDL -> Database Definition Language keyword) could be used in MySQLTUTORIAL 
describe employees;

SELECT * FROM employees;

SELECT firstName, lastName, email FROM employees;

SELECT orderNumber, quantityOrdered * priceEach FROM orderdetails;

-- AS is known as aliases and is optional, it gives column title
SELECT orderNumber AS "Order Number", quantityOrdered * priceEach "Total" FROM orderdetails;

SELECT city, state, country FROM offices;

SELECT checkNumber, amount * 0.09 FROM payments;

SELECT * FROM employees WHERE officeCode = 1;

SELECT * FROM employees WHERE reportsTo=1143;

SELECT firstName, lastName, email, officeCode FROM employees WHERE officeCode=1;

-- Comparison Operators (=, >, <, etc)
SELECT customerName, contactLastName, contactFirstName, phone FROM customers WHERE country="France";
SELECT * FROM customers WHERE creditLimit > 50000;

-- Logical Operators (AND, OR)
SELECT * FROM customers WHERE creditLimit > 50000 AND country="USA";
SELECT * FROM customers WHERE country="USA" OR country="France";

-- AND always executed first, followed by OR
SELECT * FROM customers WHERE (country="USA" OR country="France") AND creditLimit > 50000;

-- LIKE is for matching string pattern (case-insensitive) , % is wildcard character for anything

-- match all jobTitle that ends with "sales"
SELECT * FROM employees WHERE jobTitle LIKE "%sales";

-- match all jobTitle that starts with "sales"
SELECT * FROM employees WHERE jobTitle LIKE "sales%";

-- match all jobTitle that contains "sales"
SELECT * FROM employees WHERE jobTitle LIKE "%sales%";

-- JOIN is to extract info from 2 tables employees and offices via foreign key and primary key
SELECT * FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode;

-- JOIN always happens first, then followed by WHERE, lastly SELECT

-- Order of Precedence (SELECT, JOIN, WHERE)
-- 1. JOIN
-- 2. WHERE
-- 3. SELECT

SELECT firstName, lastName, country, city FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode;

SELECT firstName, lastName, country, city FROM employees JOIN offices
	ON employees.officeCode = offices.officeCode
	WHERE country="USA";


-- JOIN using self-referencing (self-join), that is, same table employees

-- In JOIN, usually same attribute names (say, firstName and lastName) from self-join table could occur, 
-- hence the need to differentiate them by using aliases (say, supervised_employees and supervisor) 
SELECT supervised_employees.firstName, supervised_employees.lastName, supervised_employees.jobTitle, supervisor.firstName, supervisor.lastName 
	FROM employees AS supervised_employees JOIN employees AS supervisor
	ON supervised_employees.reportsTo = supervisor.employeeNumber;


-- JOIN for more than 2 tables, say 3 tables like customers, employees, and offices

-- In JOIN, usually same attribute names (say, country and city) from different tables (say, customers and offices) could occur, 
-- hence the need to differentiate them by using proper table reference (say, offices.country and offices.city) 
SELECT customerName, firstName, lastName, offices.country, offices.city FROM customers JOIN employees
	ON customers.salesRepEmployeeNumber = employees.employeeNumber
	JOIN offices
	ON employees.officeCode = offices.officeCode;

-- JOIN using aliases
SELECT customerName, e.firstName, e.lastName, o.country, o.city
  FROM customers AS c JOIN employees as e
  ON c.salesRepEmployeeNumber = e.employeeNumber
  JOIN offices as o
  ON e.officeCode = o.officeCode;

