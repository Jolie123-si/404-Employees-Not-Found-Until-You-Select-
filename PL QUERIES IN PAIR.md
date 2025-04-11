**📄 Employee SQL Analysis — Theoretical Breakdown**

This document provides a descriptive and detailed explanation of the operations carried out in the **Employee Data Analysis** project using Oracle SQL. All SQL code logic is excluded here, with the focus on conceptual understanding.

---

### ✅ 1. Checking for Table Existence
Before attempting to create a table in Oracle SQL, it is good practice to first **verify whether the table already exists**. This prevents errors such as attempting to create a table that’s already present in the database. It ensures your operation is safe and avoids duplication.

---

### 🏗️ 2. Creating the EMPLOYEES Table
We designed a structured table named `EMPLOYEES` that includes the following fields:
- **EmployeeID**: A unique identifier for each employee.
- **EmployeeName**: The name of the employee.
- **Department**: The department where the employee works.
- **Salary**: The salary received.
- **JoinDate**: The date the employee joined the company.

This schema simulates a real-life HR database useful for analysis and reporting.

---

### ✍🏽 3. Inserting Data
We populated the `EMPLOYEES` table with sample data for 7 individuals across two departments (IT and HR). This dataset is used throughout the analysis to demonstrate various SQL functions and queries.

---

### 👁️ 4. Viewing Employee Records
A simple query was used to **display all records** within the table. This acts as a reference point to see the full dataset and is useful for verifying that insertions were successful.

---

### 🔁 5. Salary Comparison Using LAG (Previous Employee)
Here, we used the `LAG()` function to compare each employee’s salary with that of the **previous employee** in the same department. This analysis helps identify salary progression trends and check if someone is earning more or less than their predecessor.

---

### 🔁 6. Salary Comparison Using LEAD (Next Employee)
Similarly, the `LEAD()` function compares salaries with the **next employee** in the department, giving a forward-looking perspective. It’s useful for understanding how salaries differ among upcoming peers.

---

### 🏅 7. Rank vs Dense Rank
The `RANK()` and `DENSE_RANK()` functions were used to **rank employees within their departments based on salary**. The difference lies in how they handle ties:
- **RANK()**: Leaves gaps if salaries are tied.
- **DENSE_RANK()**: Doesn’t leave gaps.

These are crucial when determining performance tiers or bonus qualifications.

---

### 🥇 8. Top 3 Earners per Department
Using a combination of window functions and CTE (Common Table Expression), we isolated the **top 3 earners** in each department. This type of logic is great for promotion or bonus eligibility reviews.

---

### ⏳ 9. First Two Joiners per Department
We used logic to **find the first two employees who joined each department**. This can be helpful for recognizing long-serving staff or determining seniority.

---

### 💵 10. Maximum Salary (Department + Overall)
This section identifies:
- The highest salary **within each department**.
- The **overall maximum salary** across the company.

Such insights are essential for budgeting and compensation benchmarking.

---

### 🌟 11. Highlighting Max Earners per Department
Finally, we highlighted employees who earn the **maximum salary within their department**. These standout performers are valuable for company recognition programs.

---

### 🧠 Summary
This file explains the reasoning behind each SQL function and operation used in our employee data project. It's designed to provide clarity for collaborators, teachers, or HR professionals interested in the *why* behind the *what*.

# QUERIES

## -- CHECKING FIRST WHETHER THERE IS NO TABLE CALLED EMPLOYEES WHICH EXISTS ALREADY

```sql
SELECT table_name 
FROM user_tables
WHERE table_name = 'EMPLOYEES';

## --CREATING A TABLE


CREATE TABLE EMPLOYEES (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR2(100),
    Department VARCHAR2(50),
    Salary NUMBER(8, 2),
    JoinDate DATE
);
```
## --POPULATING A TABLE


-- Insert the first row
```sql
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (1, 'Alice', 'IT', 9000, TO_DATE('2021-03-15', 'YYYY-MM-DD'));

-- Insert the second row
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (2, 'Bob', 'IT', 8500, TO_DATE('2020-07-10', 'YYYY-MM-DD'));

-- Insert the third row
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (3, 'Charlie', 'IT', 8500, TO_DATE('2021-06-20', 'YYYY-MM-DD'));

-- Insert the fourth row
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (4, 'David', 'IT', 8000, TO_DATE('2019-09-25', 'YYYY-MM-DD'));

-- Insert the fifth row
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (5, 'Eve', 'HR', 7500, TO_DATE('2022-01-05', 'YYYY-MM-DD'));

-- Insert the sixth row
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (6, 'Frank', 'HR', 7200, TO_DATE('2021-08-14', 'YYYY-MM-DD'));

-- Insert the seventh row
INSERT INTO EMPLOYEES (EmployeeID, EmployeeName, Department, Salary, JoinDate)
VALUES (7, 'Grace', 'HR', 7000, TO_DATE('2020-11-30', 'YYYY-MM-DD'));
```
--VIEWING ALL THE TABLE

```sql
SELECT * FROM EMPLOYEES;
```
## --COMPARISON WITH PREVIOUS SALARY

```sql
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
```
## --COMPARISON WITH NEXT SALARY

```sql
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
```
## --RANK AND DENSE RANK OF SALARIES WITHIN DEPARTMENTS

```sql
SELECT 
    EmployeeID, 
    EmployeeName, 
    Department, 
    Salary,
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DenseRank
FROM Employees;
```
## --IDENTIFYING TOP THREE SALARIES PER DEPARTMENT

```sql
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
```
## --FINDING THE FIRST TWO EMPLOYEES TO JOIN PER DEPARTMENT

```sql
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
FROM 
(
    SELECT EmployeeID, EmployeeName, Department, JoinDate
    FROM Employees
    WHERE Department = 'HR'
    ORDER BY Department, JoinDate
)
WHERE ROWNUM <= 2;
```


## --FINDING MAXIMUM SALARY PER DEPARTMENT AND OVERALL

```sql
SELECT 
    EmployeeID, 
    EmployeeName, 
    Department, 
    Salary,
    MAX(Salary) OVER (PARTITION BY Department) AS MaxSalaryPerDept,
    MAX(Salary) OVER () AS MaxSalaryOverall
FROM Employees;
```
--HIGHLIGHTING EMPLOYEES WITH THE MAXIMUM SALARIES IN THEIR DEPARTMENT

```sql
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
```





