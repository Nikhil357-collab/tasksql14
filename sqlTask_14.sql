CREATE DATABASE company_db;
USE company_db;

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    join_date DATE
);
DELIMITER $$

CREATE PROCEDURE insert_employee (
    IN p_name VARCHAR(100),
    IN p_department VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    IN p_join_date DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error occurred while inserting employee' AS message;
    END;

    START TRANSACTION;

    INSERT INTO employees (emp_name, department, salary, join_date)
    VALUES (p_name, p_department, p_salary, p_join_date);

    COMMIT;
END $$

DELIMITER ;

CALL insert_employee('Rahul Sharma', 'IT', 60000, '2024-01-15');
CALL insert_employee('Anita Verma', 'HR', 45000, '2023-06-10');

SELECT * FROM employees;

DELIMITER $$

CREATE FUNCTION calculate_bonus(salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE bonus DECIMAL(10,2);

    IF salary >= 50000 THEN
        SET bonus = salary * 0.10;
    ELSE
        SET bonus = salary * 0.05;
    END IF;

    RETURN bonus;
END $$

DELIMITER ;

SELECT emp_name, salary, calculate_bonus(salary) AS bonus
FROM employees;

DELIMITER $$
#Procedure Using Function (Reusable Business Logic)
CREATE PROCEDURE employee_salary_details ()
BEGIN
    SELECT 
        emp_name,
        salary,
        calculate_bonus(salary) AS bonus,
        salary + calculate_bonus(salary) AS total_pay
    FROM employees;
END $$

DELIMITER ;

CALL employee_salary_details();


