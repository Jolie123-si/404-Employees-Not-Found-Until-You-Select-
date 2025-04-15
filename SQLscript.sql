-- Checking if the table exists
SELECT table_name
FROM user_tables
WHERE table_name = 'EMPLOYEES';

-- Creating the EMPLOYEES table
CREATE TABLE EMPLOYEES (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR2(100),
    Department VARCHAR2(50),
    Salary NUMBER(8, 2),
    JoinDate DATE
);
INSERT INTO EMPLOYEES VALUES (1, 'Alice', 'IT', 9000, TO_DATE('2021-03-15', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (2, 'Bob', 'IT', 8500, TO_DATE('2020-07-10', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (3, 'Charlie', 'IT', 8500, TO_DATE('2021-06-20', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (4, 'David', 'IT', 8000, TO_DATE('2019-09-25', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (5, 'Eve', 'HR', 7500, TO_DATE('2022-01-05', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (6, 'Frank', 'HR', 7200, TO_DATE('2021-08-14', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (7, 'Grace', 'HR', 7000, TO_DATE('2020-11-30', 'YYYY-MM-DD'));
SELECT * FROM EMPLOYEES;
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    LAG(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS PrevSalary,
    LEAD(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS NextSalary,
    CASE
        WHEN Salary > LAG(Salary) OVER (PARTITION BY Department ORDER BY Salary) THEN 'HIGHER'
        WHEN Salary < LAG(Salary) OVER (PARTITION BY Department ORDER BY Salary) THEN 'LOWER'
        ELSE 'EQUAL'
    END AS ComparisonWithPrev
FROM Employees;
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    LAG(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS PrevSalary,
    LEAD(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS NextSalary,
    CASE
        WHEN Salary > LEAD(Salary) OVER (PARTITION BY Department ORDER BY Salary) THEN 'HIGHER'
        WHEN Salary < LEAD(Salary) OVER (PARTITION BY Department ORDER BY Salary) THEN 'LOWER'
        ELSE 'EQUAL'
    END AS ComparisonWithNext
FROM Employees;
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DenseRank
FROM Employees;
WITH RankedEmployees AS (
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank
    FROM Employees
)
SELECT * FROM RankedEmployees
WHERE Rank <= 3;
SELECT EmployeeID, EmployeeName, Department, JoinDate
FROM (
    SELECT EmployeeID, EmployeeName, Department, JoinDate
    FROM Employees
    WHERE Department = 'IT'
    ORDER BY Department, JoinDate
)
WHERE ROWNUM <= 2
UNION ALL
SELECT EmployeeID, EmployeeName, Department, JoinDate
FROM (
    SELECT EmployeeID, EmployeeName, Department, JoinDate
    FROM Employees
    WHERE Department = 'HR'
    ORDER BY Department, JoinDate
)
WHERE ROWNUM <= 2;
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    MAX(Salary) OVER (PARTITION BY Department) AS MaxSalaryPerDept,
    MAX(Salary) OVER () AS MaxSalaryOverall
FROM Employees;
SELECT *
FROM (
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        MAX(Salary) OVER (PARTITION BY Department) AS MaxSalaryPerDept
    FROM Employees
)
WHERE Salary = MaxSalaryPerDept;

