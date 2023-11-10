SELECT YEAR(t_dept_emp.from_date) AS CALENDAR_YEAR, t_employees.gender AS GENDER, COUNT(t_employees.emp_no) AS NUMBER_OF_EMPLOYEES
FROM t_employees 
JOIN t_dept_emp ON t_employees.EMP_NO = t_dept_emp.EMP_NO
GROUP BY CALENDAR_YEAR, GENDER
HAVING CALENDAR_YEAR >= 1990;

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;

SELECT  T_EMPLOYEES.GENDER, t_departments.dept_name AS DEPT_NAME, ROUND(AVG(T_SALARIES.SALARY),2) AS SALARY, YEAR(T_SALARIES.from_date) AS CALENDAR_YEAR
FROM T_EMPLOYEES
JOIN T_SALARIES ON
T_EMPLOYEES.EMP_NO = T_SALARIES.EMP_NO
JOIN t_dept_emp ON
T_EMPLOYEES.EMP_NO = T_DEPT_EMP.EMP_NO
JOIN t_departments ON
t_departments.DEPT_NO = T_DEPT_EMP.DEPT_NO
GROUP BY t_departments.DEPT_NO, T_EMPLOYEES.GENDER, CALENDAR_YEAR
HAVING CALENDAR_YEAR <= 2002
ORDER BY t_departments.DEPT_NO;

DROP PROCEDURE IF EXISTS AVG_SALARY;
DELIMITER $$
CREATE PROCEDURE AVG_SALARY ( IN sal_1 FLOAT, IN sal_2 FLOAT)
BEGIN
SELECT  T_EMPLOYEES.GENDER, t_departments.dept_name AS DEPT_NAME, AVG(T_SALARIES.SALARY) AS AVG_SALARY
FROM T_EMPLOYEES
JOIN T_SALARIES ON
T_EMPLOYEES.EMP_NO = T_SALARIES.EMP_NO
JOIN t_dept_emp ON
T_EMPLOYEES.EMP_NO = T_DEPT_EMP.EMP_NO
JOIN t_departments ON
t_departments.DEPT_NO = T_DEPT_EMP.DEPT_NO
WHERE T_SALARIES.SALARY BETWEEN sal_1 AND sal_2
GROUP BY t_departments.DEPT_NO, T_EMPLOYEES.GENDER
ORDER BY t_departments.DEPT_NO, T_EMPLOYEES.GENDER;
END $$

DELIMITER ;

CALL AVG_SALARY (50000, 90000);