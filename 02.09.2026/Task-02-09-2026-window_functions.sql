create database window_functions;
use window_functions;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);

INSERT INTO employees (emp_id, emp_name, department, salary, hire_date) VALUES
(1, 'Arun', 'IT', 90000, '2024-01-10'),
(2, 'Bala', 'IT', 80000, '2024-02-15'),
(3, 'Charan', 'IT', 80000, '2024-03-20'),
(4, 'Divya', 'HR', 75000, '2024-01-12'),
(5, 'Esha', 'HR', 70000, '2024-04-01'),
(6, 'Farhan', 'HR', 70000, '2024-05-05'),
(7, 'Gokul', 'Sales', 95000, '2024-02-02'),
(8, 'Hari', 'Sales', 85000, '2024-06-18');

-- row number
-- select(row_number() over (order by salary desc)) as s_no, emp_id ,salary from employees;

-- rank
-- select(rank() over (order by salary desc)) as s_no, emp_id ,salary from employees;

-- dense rank
-- SELECT x.s_no, x.emp_id, x.salary FROM (SELECT DENSE_RANK() OVER (ORDER BY salary DESC) AS s_no,emp_id,salary FROM employees) AS x WHERE x.s_no = 4;

-- partition by
-- SELECT x.s_no, x.emp_id, x.dept_id, x.salary FROM (SELECT DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS s_no, emp_id, dept_id, salary FROM employees) AS x WHERE x.s_no <= 4;

-- 1. Write a query to display emp_name, department, salary, and a unique row number for all employees ordered by salary from highest to lowest. Use ROW_NUMBER().
 select (row_number() over (order by salary desc)) as s_no , emp_name ,salary from employees;

-- 2. Write a query to rank all employees by salary in descending order. Employees with the same salary must receive the same rank, and the next rank should be skipped.
select(rank() over(order by salary desc)) as s_no, emp_name,salary from employees;

-- 3. Write a query to rank all employees by salary in descending order, but do not leave gaps in the ranking when two or more employees have the same salary.
select (dense_rank() over(order by salary desc)) as s_no,emp_name, salary from employees;

-- 4. row number inside each department - row_number()
-- write a query to assign a row number to employees separately inside each department. within every department, the highest paid employee must receive row number 1.
select row_number() over (partition by department order by salary desc) as s_no, emp_name, department, salary
from employees;


-- 5. department wise salary rank - rank()
-- write a query to rank employees by salary within each department. if two employees in the same department have the same salary, they must share the same rank.
select rank() over (partition by department order by salary desc) as s_no, emp_name, department, salary from employees;

-- 6. top 2 distinct salaries in each department - dense_rank()
-- write a query to return only employees who belong to the top 2 distinct salary levels in their department. use dense_rank() in a subquery or cte.

select * from (select emp_name, department, salary, dense_rank() over (partition by department order by salary desc) as s_no from employees) x where s_no <= 2;


-- 7. highest paid employee name per department - first_value()
-- write a query that displays every employee along with the name of the highest-paid employee in that employee's department. use first_value().

select emp_name, department, salary, first_value(emp_name) over (partition by department order by salary desc) as highest_paid
from employees;


-- 8. lowest paid employee name per department - last_value()
-- write a query that displays every employee along with the name of the lowest-paid employee in that department. use last_value() with an explicit window frame so the result is correct for all rows.

select emp_name, department, salary, last_value(emp_name) over (partition by department order by salary desc rows between unbounded preceding and unbounded following) as lowest_paid
from employees;


-- 9. compare first and last salary in each department
-- write a query that displays emp_name, department, salary, highest salary in the department, and lowest salary in the department using first_value() and last_value(). order the window by salary desc and use the correct frame.

select emp_name, department, salary, first_value(salary) over (partition by department order by salary desc) as highest_salary,
last_value(salary) over (partition by department order by salary desc rows between unbounded preceding and unbounded following) as lowest_salary
from employees;


-- 10. find the 2nd highest distinct salary employees - dense_rank()
-- write a query to return all employees whose salary is the second-highest distinct salary in the entire company. do not use limit. use dense_rank().

select * from (select emp_id, emp_name, department, salary, dense_rank() over (order by salary desc) as s_no
from employees) x where s_no = 2;