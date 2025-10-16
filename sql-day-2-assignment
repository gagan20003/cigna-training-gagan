--Create Table Department
  CREATE TABLE Dept(
  Dept_No NUMBER PRIMARY KEY,
  Dname VARCHAR2(30),
  Loc VARCHAR2(30)
  );
  
--Create Table Employee
CREATE TABLE Emps(
  Emp_No NUMBER PRIMARY KEY,
  Ename VARCHAR2(20),
  Job VARCHAR(30),
  Salary NUMBER(10,2),
  Dept_No NUMBER,
  CONSTRAINT FK_emp FOREIGN KEY (Dept_No) REFERENCES Dept(Dept_No)
  );

--Inserting values to Department
INSERT INTO Dept VALUES(10, 'Developer', 'Bangalore');
INSERT INTO Dept VALUES(20, 'Analyst', 'New Delhi');
INSERT INTO Dept VALUES(30, 'Tester', 'Hyderabad');
INSERT INTO Dept VALUES(40, 'Sales', 'Chennai');

--Inserting values to Employee
INSERT INTO Emps VALUES(11, 'Rohit', 'App Developer', 4000, 10);
INSERT INTO Emps VALUES(12, 'Rahul', 'Junior Tester', 2000, 30);
INSERT INTO Emps VALUES(13, 'John', 'Lead Analyst', 6700, 20);
INSERT INTO Emps VALUES(14, 'Jack', 'HRBP', 5000, 40);
INSERT INTO Emps VALUES(15, 'Ambar', 'Manager', 10000, 40);
INSERT INTO Emps VALUES(16, 'Ravi', 'Lead Tester', 9000, 30);
INSERT INTO Emps VALUES(17, 'Ramesh', 'Data Analyst', 7000, 20);
INSERT INTO Emps VALUES(18, 'Suresh', 'Web Developer', 5000, 10);
INSERT INTO Emps VALUES(19, 'Ram', 'React Developer', 3000, 10);
INSERT INTO Emps VALUES(20, 'Kishan', 'Senior Lead Developer', 2000, 10);


--1. Display employee names along with their department names.
SELECT E.Ename, D.Dname
FROM Emps E
JOIN Dept D ON E.Dept_No = D.Dept_No;

--2. List all employees with their job titles and the location of their department.
SELECT E.Ename, E.Job, D.Loc
FROM Emps E
JOIN Dept D ON E.Dept_No = D.Dept_No;

--3. Display employees who work in the SALES department.
SELECT E.Ename, E.Job, E.Salary
FROM Emps E
JOIN Dept D ON E.Dept_No = D.Dept_No
WHERE D.Dname = 'SALES';

--4. List all employees along with their department name and location, including departments that have no employees.
SELECT D.Dname, D.Loc, E.Ename, E.Job
FROM Dept D
LEFT JOIN Emps E ON D.Dept_No = E.Dept_No;

--5. Display all departments and employees, even if some employees are not assigned to any department.
SELECT D.Dname, D.Loc, E.Ename, E.Job
FROM Dept D
FULL JOIN Emps E ON D.Dept_No = E.Dept_No;

--6. Show each department name and  total salary paid to its employees.
SELECT D.Dname, SUM(E.Salary) AS Total_Salary
FROM Dept D
JOIN Emps E ON D.Dept_No = E.Dept_No
GROUP BY D.Dname;

--7. Find departments that have more than 3 employees.  Display dname and no. of employees.
SELECT D.Dname, COUNT(E.Emp_No) AS Num_Employees
FROM Dept D
JOIN Emps E ON D.Dept_No = E.Dept_No
GROUP BY D.Dname
HAVING COUNT(E.Emp_No) > 3;

--8. Display employees who work in the same location as the ACCOUNTING department.
SELECT E.Ename, D.Loc
FROM Emps E
JOIN Dept D ON E.Dept_No = D.Dept_No
WHERE D.Loc = (SELECT Loc FROM Dept WHERE Dname = 'Accounting');

--9. For each department, display the employee who has the highest salary.
SELECT E.Ename, E.Salary, D.Dname
FROM Emps E
JOIN Dept D ON E.Dept_No = D.Dept_No
WHERE E.Salary = (
  SELECT MAX(E2. Salary)
  FROM Emps E2
  WHERE E2.Dept_No = E.Dept_No
  );

--10. List employees whose salary is greater than the average salary of their department.
SELECT E.Ename, E.Salary, D.Dname
FROM Emps E
JOIN Dept D ON E.Dept_No - D.Dept_No
WHERE E.Salary > (
  SELECT AVG(E2.Salary)
  FROM Emps E2
  WHERE E2.Dept_No = E.Dept_No
  );
