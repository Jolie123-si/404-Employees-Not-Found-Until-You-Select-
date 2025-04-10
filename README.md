# 🧠 The Curious Analyst: A Deep Dive into SQL with Windows Functions & Wisdom
# Employee Data Analysis Project (Oracle SQL)

## 👨🏽‍💻 Team Members

- **Nabonyimana Jospin  (26511)**
- **SIFA Jolie Blandine   (26911)**

## 📚 Project Description

This project demonstrates how to create and manipulate an `EMPLOYEES` table in Oracle SQL. It uses **analytical functions** like `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, and others to perform powerful data analysis. The work reflects real-life HR tasks such as employee comparison, ranking, salary analysis, and department insights.

---

## 🛠️ Technologies Used

- **Oracle SQL Developer**
- **Oracle PDB** (pl assignment)

---

## 🏗️ Table Creation

```sql
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
```
![Creation of table-Employees](https://github.com/user-attachments/assets/62bb39ea-efb2-445a-ad20-cb781376f31b)

---

## 📥 Data Insertion

```sql
INSERT INTO EMPLOYEES VALUES (1, 'Alice', 'IT', 9000, TO_DATE('2021-03-15', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (2, 'Bob', 'IT', 8500, TO_DATE('2020-07-10', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (3, 'Charlie', 'IT', 8500, TO_DATE('2021-06-20', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (4, 'David', 'IT', 8000, TO_DATE('2019-09-25', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (5, 'Eve', 'HR', 7500, TO_DATE('2022-01-05', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (6, 'Frank', 'HR', 7200, TO_DATE('2021-08-14', 'YYYY-MM-DD'));
INSERT INTO EMPLOYEES VALUES (7, 'Grace', 'HR', 7000, TO_DATE('2020-11-30', 'YYYY-MM-DD'));
```
![Populating table with data](https://github.com/user-attachments/assets/5bf54398-d41f-42a0-a926-c1fb05218af0)

---

## 👀 View All Employees

```sql
SELECT * FROM EMPLOYEES;
```
![WhatsApp Image 2025-04-10 at 11 09 05 AM](https://github.com/user-attachments/assets/59af1daf-f013-4f2b-9479-268edbe1c367)

---

## 🔁 Salary Comparison with Previous Employee

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
![WhatsApp Image 2025-04-10 at 11 16 01 AM](https://github.com/user-attachments/assets/30f8561f-b75a-4c9a-87ca-bf75f04264b0)



**Logic**: `LAG` helps to compare the current employee's salary with the previous one **in the same department**. It works like looking at "who was before me?"

---

## 🔁 Salary Comparison with Next Employee

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
![Withnext](https://github.com/user-attachments/assets/725a1a19-eea3-4c4f-9d03-012957dd1b6a)



**Logic**: `LEAD` works like asking "how does my salary compare to the one who comes after me?"

---

## 🥇 Rank and Dense Rank by Salary.

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
![image](https://github.com/user-attachments/assets/1c8164b2-5e43-4ca5-bc7e-f00edaab9921)

**Difference**:

- `RANK()` skips numbers if there's a tie.
- `DENSE_RANK()` gives continuous numbers even if there's a tie.

---

## 🏆 Top 3 Salaries per Department.

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
![image](https://github.com/user-attachments/assets/9b7e9cf9-b8c7-47e7-988c-ad2a89ae96db)

**Use Case**: Useful in HR systems to find top performers in each department.

---

## ⏳ First Two Employees to Join Each Department.

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
FROM (
    SELECT EmployeeID, EmployeeName, Department, JoinDate
    FROM Employees
    WHERE Department = 'HR'
    ORDER BY Department, JoinDate
)
WHERE ROWNUM <= 2;
```
![image (1)](https://github.com/user-attachments/assets/7b4e26f0-c6da-42b7-aa2f-55ed2ac85d8f)

**Logic**: Retrieves the earliest joiners (based on `JoinDate`) in each department.

---

## 💰 Maximum Salary per Department and Overall.

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
![image](https://github.com/user-attachments/assets/577d56a2-6351-4442-8cf9-d1fd7095c976)

**Real Case**: HR may use this to benchmark salary limits by team and across the company.

---

## ⭐ Highlight Employees with Max Salary per Department.

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

**Purpose**: This isolates employees earning the top salary in their team — e.g., for recognition or review.

---

## ✅ Conclusion

This project showcases how analytical SQL functions can be used to simulate real-world HR data analysis. We practiced:

- Data organization
- Comparison logic
- Ranking systems
- Real-life insights for departments

The work was successfully done as a collaboration between **Nabonyimana Jospin** and **SIFA Jolie Blandine**.

---


