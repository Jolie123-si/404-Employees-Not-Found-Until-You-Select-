# 🧠 404 Employees Not Found(Until you Select)

## SQLassic Park: Where Queries Roam Free
## 👨🏽‍💻 Team Members' names

- **Nabonyimana Jospin  (26511)**  ![Badge](https://img.shields.io/badge/Team-Member-green)
- **Jolie Blandine SIFA   (26911)**  ![Badge](https://img.shields.io/badge/Team-Member-green)

---

## 📚 Project Descriptions

This project demonstrates how to create and manipulate an `EMPLOYEES` table in Oracle SQL. It uses **analytical functions** like `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, and others to perform powerful data analysis. The work reflects real-life HR tasks such as employee comparison, ranking, salary analysis, and department insights.

💼 **Real-life Scenario**: Think of an HR system where you're asked to analyze performance, track salary changes, or find top performers in departments. This project replicates those everyday tasks through SQL.

---

## 🛠️ Technologies Used

- ![Oracle](https://img.shields.io/badge/Oracle-SQL-red) **Oracle SQL Developer**
- 🧪 **Oracle PDB** (PL assignment)

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


![Best Practice](https://img.shields.io/badge/Reminder-Best%20Practice-yellow)

> 🔎 **Quick Note:** Always check if the table already exists before trying to create it.  
> It avoids duplicate table errors and keeps your schema clean!


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

📊 **Example**: This logic helps HR detect if a newly hired person is earning more than those already in the same department.

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

🔍 **Scenario**: Used in team restructuring to assess if future peers earn more/less.

---

## 🥇 Rank and Dense Rank by Salary

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

🎯 **Example**: In a bonus scheme, if two employees have the same salary, `RANK()` vs `DENSE_RANK()` changes how bonuses are distributed.

---

## 🏆 Top 3 Salaries per Department

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

📌 **Use Case**: HR wants to shortlist candidates for promotion based on top 3 earners in each department.

---

## ⏳ First Two Employees to Join Each Department

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

📅 **Use Case**: Identifying employees eligible for long-service awards.

---

## 💰 Maximum Salary per Department and Overall

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

🏢 **Example**: HR benchmarking salaries internally and against market standards.

---

## ⭐ Highlight Employees with Max Salary per Department

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
![image](https://github.com/user-attachments/assets/2eb5235d-ca30-42b1-a202-6ec1a9cfc225)

🏆 **Real-world Match**: Recognizing top contributors during performance reviews.

---

## ✅ Conclusion

This project showcases how analytical SQL functions can be used to simulate real-world HR data analysis, We practiced:

- 🧩 Data organization
- 🔍 Comparison logic
- 🥇 Ranking systems
- 🌍 Real-life insights for departments

> 👥 Done with great teamwork by **Nabonyimana Jospin** and **Jolie Blandine SIFA**.

🚀 *Powering smarter HR with SQL!*
# Employees Data Analysis Project (Oracle SQL)
---
