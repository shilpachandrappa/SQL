use Ankit_Bansal_SQL;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2),
    manager_id INT,
    -- Self-referencing foreign key constraint
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);
INSERT INTO employees (emp_id, emp_name, salary, manager_id) VALUES
(101, 'Alice Johnson', 150000, NULL),  -- CEO (Top Level)
(102, 'Bob Smith', 120000, 101),       -- Reports to Alice
(103, 'Charlie Davis', 115000, 101),   -- Reports to Alice
(104, 'Diana Prince', 95000, 102),     -- Reports to Bob
(105, 'Ethan Hunt', 92000, 102),       -- Reports to Bob
(106, 'Fiona Shrek', 98000, 103),      -- Reports to Charlie
(107, 'George Miller', 85000, 103),    -- Reports to Charlie
(108, 'Hannah Abbott', 75000, 104),    -- Reports to Diana
(109, 'Ian Wright', 72000, 104),       -- Reports to Diana
(110, 'Jenny Kim', 78000, 105),        -- Reports to Ethan
(111, 'Kevin Hart', 70000, 106),       -- Reports to Fiona
(112, 'Laura Palmer', 82000, 106),     -- Reports to Fiona
(113, 'Mike Ross', 65000, 107),        -- Reports to George
(114, 'Nina Simone', 68000, 107),      -- Reports to George
(115, 'Oscar Isaac', 60000, 110);      -- Reports to Jenny


SELECT e.emp_id , e.emp_name, e.salary as employee_salary, 
m.emp_name as manager_name, m.salary as manger_salary
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE  m.salary > 100000