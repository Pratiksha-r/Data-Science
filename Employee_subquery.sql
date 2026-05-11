drop table  if exists employees;
drop table if exists department;
drop table  if exists salary_grade;

create table department ( 
  dep_id     Int,  
  dep_name    varchar(14),  
  dep_location        varchar(15),  
  constraint pk_department_dep_id  primary key (dep_id)  
);

create table employees(  
  emp_id    Integer,  
  emp_name   varchar(15),  
  job_name   varchar(10),  
  manager_id Integer ,  
  hire_date date,  
  salary      decimal (10,2),  
  commission     decimal (7,2),  
  dep_id   Int,  
  constraint pk_employees_emp_id  primary key (emp_id),  
  constraint fk_employees_dep_id foreign key (dep_id ) references department (dep_id)  
); 


create table salary_grade(  
  grade    Integer  ,  
  min_salary  integer,  
  max_salary  integer
);



delete from employees ;
delete from department;
delete from salary_grade;


insert into department values (1001,'FINANCE', 'SYDNEY');
insert into department values (2001,'AUDIT', 'MELBOURNE');
insert into department values (3001,'MARKETING', 'PERTH');
insert into department values (4001,'PRODUCTION', 'BRISBANE');


insert into employees values (68319, 'KAYLING', 'PRESIDENT',NULL,'1991-11-18', 6000,NULL,1001);
insert into employees values (66928, 'BLAZE', 'MANAGER',68319,'1991-05-01', 2750,NULL,3001);
insert into employees values (67832, 'CLARE', 'MANAGER',68319,'1991-06-09', 2550,NULL,1001);
insert into employees values (65646, 'JONAS', 'MANAGER',68319,'1991-04-02', 2957,NULL,2001);
insert into employees values (64989, 'ADELYN', 'SALESMAN',66928,'1991-02-20', 1700,400,3001);
insert into employees values (65271, 'WADE', 'SALESMAN',66928,'1991-02-22', 1350,600,3001);
insert into employees values (66564, 'MADDEN', 'SALESMAN',66928,'1991-09-28', 1350,1500,3001);
insert into employees values (68454, 'TUCKER', 'SALESMAN',66928,'1991-09-08', 1600,0,3001);
insert into employees values (68736, 'ADNRES', 'CLERK',67858,'1997-05-23', 1200,NULL,2001);
insert into employees values (69000, 'JULIUS', 'CLERK',66928,'1991-12-03', 1050,NULL,3001);
insert into employees values (69324, 'MARKER', 'CLERK',67832,'1992-01-23', 1400,NULL,1001);
insert into employees values (67858, 'SCARLET', 'ANALYST',65646,'1997-04-19', 3100,NULL,2001);
insert into employees values (69062, 'FRANK', 'ANALYST',65646,'1991-12-03', 3100,NULL,2001);
insert into employees values (63679, 'SANDRINE', 'CLERK',69062,'1990-12-18', 900,NULL,2001);

insert into salary_grade values (1,800,1300);
insert into salary_grade values (2,1301,1500);
insert into salary_grade values (3,1501,2100);
insert into salary_grade values (4,2101,3100);
insert into salary_grade values (5,3101,9999);



-- 1. Write a query in SQL to display all the details of managers. 

SELECT *
FROM employees
WHERE emp_id IN
    (SELECT manager_id
     FROM employees);
     

-- 2. Write a query in SQL to display the employee ID, name, job name, hire date, and experience of all the managers. 

SELECT emp_id,  emp_name, job_name, hire_date,
	   (DATEDIFF( day, hire_date, getdate()))/365  ' Years ' ,
	      ((DATEDIFF( day, hire_date, getdate()))%365)/30 ' Months ',
		  ((DATEDIFF( day, hire_date, getdate()))%30)  ' Days' 
FROM employees
WHERE emp_id IN
    (SELECT manager_id
     FROM employees);


-- 3. Write a query in SQL to list the employee ID, name, salary, department name of all the 'MANAGERS' and 'ANALYST' working in SYDNEY, PERTH with an exp more than 5 years without receiving the commission and display the list in ascending order of location. 
SELECT e.emp_id,
       e.emp_name,
       e.salary,
       d.dep_name
FROM employees e,
     department d
WHERE d.dep_location IN ('SYDNEY',
                         'PERTH')
  AND e.dep_id = d.dep_id
  AND e.emp_id IN
    (SELECT e.emp_id
     FROM employees e
     WHERE e.job_name IN ('MANAGER',
                          'ANALYST')
       AND (DATEDIFF (year, hire_date, getdate())> 5)
       AND e.commission IS NULL)
ORDER BY d.dep_location ASC;


-- 4. Write a query in SQL to display the employee ID, name, salary, department name, location, department ID, job name of all the employees working at SYDNEY or working in the FINANCE deparment with an annual salary above 28000, but the monthly salary should not be 3000 or 2800 and who does not works as a MANAGER and whose ID containing a digit of '3' or '7' in 3rd position. List the result in ascending order of department ID and descending order of job name.   
SELECT E.emp_id,
       E.emp_name,
       E.salary,
       D.dep_name,
       D.dep_location,
       E.dep_id,
       E.job_name
FROM employees E,
     department D
WHERE (D.dep_location = 'SYDNEY'
       OR D.dep_name = 'FINANCE')
  AND E.dep_id=D.dep_id
  AND E.emp_id IN
    (SELECT emp_id
     FROM employees E
     WHERE (12*E.salary) > 28000
       AND E.salary NOT IN (3000,
                            2800)
       AND E.job_name !='MANAGER'
       AND (trim(to_char(emp_id,'99999')) LIKE '__3%'
            OR trim(to_char(emp_id,'99999')) LIKE '__7%'))
ORDER BY E.dep_id ASC,
         E.job_name DESC;
-- 5. Write a query in SQL to list all the employees of grade 2 and 3.   

SELECT *
FROM employees e,
     salary_grade s
WHERE e.salary BETWEEN s.min_salary AND s.max_salary
  AND s.grade IN (2, 3);

-- 6. Write a query in SQL to display all the employees of grade 4 and 5 who are working as ANALYST or MANAGER.    

SELECT *
FROM employees e,
     salary_grade s
WHERE e.salary BETWEEN s.min_salary AND s.max_salary
  AND s.grade IN (4,
                  5)
  AND e.emp_id IN
    (SELECT e.emp_id
     FROM employees e
     WHERE e.job_name IN ('MANAGER',
                          'ANALYST'));

-- 7. Write a query in SQL to list the details of the employees whose salary is more than the salary of JONAS. 

SELECT *
FROM employees
WHERE salary >
    (SELECT salary
     FROM employees
     WHERE emp_name = 'JONAS');
-- 8. Write a query in SQL to list the employees who works in the same designation as FRANK.    

SELECT *
FROM employees
WHERE job_name =
    (SELECT job_name
     FROM employees
     WHERE emp_name = 'FRANK');
-- 9. List the employees who are senior to ADELYN    

SELECT *
FROM employees
WHERE hire_date <
    (SELECT hire_date
     FROM employees
     WHERE emp_name = 'ADELYN');
     
-- 10. Write a query in SQL to list the employees of department ID 2001 who works in the designation same as department ID 1001.    

SELECT *
FROM employees e,
     department d
WHERE d.dep_id = 2001
  AND e.dep_id = d.dep_id
  AND e.job_name IN
    (SELECT e.job_name
     FROM employees e,
          department d
     WHERE e.dep_id = d.dep_id
       AND d.dep_id =1001);

-- 11. Write a query in SQL to list the employees whose salary is same as the salary of FRANK or SANDRINE. List the result in descending order of salary.    

SELECT *
FROM employees
WHERE salary IN
    (SELECT salary
     FROM employees e
     WHERE e.emp_name IN ('FRANK',
                          'BLAZE')
       AND employees.emp_id <> e.emp_id);


-- 12. Write a query in SQL to list the employees whose designation are same as the designation of MARKER or salary is more than the salary of ADELYN.    
SELECT *
FROM employees
WHERE job_name =
    (SELECT job_name
     FROM employees
     WHERE emp_name = 'MARKER' )
  OR salary>
    (SELECT salary
     FROM employees
     WHERE emp_name = 'ADELYN');


-- 13. Write a query in SQL to list the employees whose salary is more than the total remuneration of the SALESMAN. 
SELECT *
FROM employees
WHERE salary >
    (SELECT max(salary+commission)
     FROM employees
     WHERE job_name = 'SALESMAN');


-- 14. Write a query in SQL to list the employees who are senior to BLAZE and working at PERTH or BRISBANE.    

SELECT *
FROM employees e,
     department d
WHERE d.dep_location IN ('PERTH',
                         'BRISBANE')
  AND e.dep_id = d.dep_id
  AND e.hire_date <
    (SELECT e.hire_date
     FROM employees e
     WHERE e.emp_name = 'BLAZE') ;

-- 15. Write a query in SQL to list the employees of grade 3 and 4 working in the department of FINANCE or AUDIT and whose salary is more than the salary of ADELYN and experience is more than FRANK. List the result in the ascending order of experience. 

SELECT *
FROM employees e
WHERE e.dep_id IN
    (SELECT d.dep_id
     FROM department d
     WHERE d.dep_name IN ('FINANCE',
                          'AUDIT') )
  AND e.salary >
    (SELECT salary
     FROM employees
     WHERE emp_name = 'ADELYN')
  AND e.hire_date <
    (SELECT hire_date
     FROM employees
     WHERE emp_name = 'FRANK')
  AND e.emp_id IN
    (SELECT e.emp_id
     FROM employees e,
          salary_grade s
     WHERE e.salary BETWEEN s.min_sal AND s.max_sal
       AND s.grade IN (3,
                       4) )
ORDER BY e.hire_date ASC;


-- 16. Write a query in SQL to list the employees whose designation is same as the designation of SANDRINE or ADELYN.    
SELECT *
FROM employees
WHERE job_name IN
    (SELECT job_name
     FROM employees
     WHERE emp_name = 'SANDRINE'
       OR emp_name = 'ADELYN');

-- 17. Write a query in SQL to list any job of department ID 1001 those that are not found in department ID 2001.    
SELECT e.job_name
FROM employees e
WHERE e.dep_id = 1001
  AND e.job_name NOT IN
    (SELECT job_name
     FROM employees
     WHERE dep_id =2001);

-- 18. Write a query in SQL to find the details of highest paid employee.    

SELECT *
FROM employees
WHERE salary IN
    (SELECT max(salary)
     FROM employees);
-- 19. Write a query in SQL to find the highest paid employees in the department MARKETING.    

SELECT *
FROM employees
WHERE salary IN
    (SELECT max(salary)
     FROM employees
     WHERE dep_id IN
         (SELECT d.dep_id
          FROM department d
          WHERE d.dep_name = 'MARKETING'));

-- 20. Write a query in SQL to list the employees of grade 3 who have been hired in most recently and belongs to PERTH.    

SELECT e.emp_id, e.emp_name, e.job_name, e.hire_date,e.salary
FROM employees e
WHERE e.dep_id IN
    (SELECT d.dep_id
     FROM department d
     WHERE d.dep_location = 'PERTH')
  AND e.hire_date IN
    (SELECT max(hire_date)
     FROM employees
     WHERE emp_id IN
         (SELECT emp_id
          FROM employees e,
               salary_grade s
          WHERE e.salary BETWEEN s.min_sal AND s.max_sal
            AND s.grade = 3)) ;

-- 21. Write a query in SQL to list the employees who are senior to most recently hired employee working under KAYLING.   

SELECT *
FROM employees
WHERE hire_date <
    (SELECT max(hire_date)
     FROM employees
     WHERE manager_id IN
         (SELECT emp_id
          FROM employees
          WHERE emp_name = 'KAYLING'));

-- 22. Write a query in SQL to list the details of the employees within grade 3 to 5 and belongs to SYDNEY. The employees are not in PRESIDENT designated and salary is more than the highest paid employee of PERTH where no MANAGER and SALESMAN are working under KAYLING.    

SELECT *
FROM employees
WHERE dep_id IN
    (SELECT dep_id
     FROM department
     WHERE department.dep_location ='SYDNEY')
  AND emp_id IN
    (SELECT emp_id
     FROM employees e,
          salary_grade s
     WHERE e.salary BETWEEN s.min_sal AND s.max_sal
       AND s.grade IN (3,
                       4,
                       5) )
  AND job_name != 'PRESIDENT'
  AND salary >
    (SELECT max(salary)
     FROM employees
     WHERE dep_id IN
         (SELECT dep_id
          FROM department
          WHERE department.dep_location = 'PERTH')
       AND job_name IN ('MANAGER',
                        'SALESMAN')
       AND manager_id NOT IN
         (SELECT emp_id
          FROM employees
          WHERE emp_name = 'KAYLING'));

-- 23. Write a query in SQL to list the details of the senior employees as on year 1991.    

SELECT *
FROM employees
WHERE hire_date IN
    (SELECT min(hire_date)
     FROM employees
     WHERE to_char(hire_date,'YYYY') = '1991');

-- 24. Write a query in SQL to list the employees who joined in 1991 in a designation same as the most senior person of the year 1991.    
SELECT *
FROM employees
WHERE job_name IN
    (SELECT job_name
     FROM employees
     WHERE hire_date IN
         (SELECT min(hire_date)
          FROM employees
          WHERE to_char(hire_date,'YYYY') ='1991'));


-- 25. Write a query in SQL to list the most senior employee working under KAYLING and grade is more than 3.    

SELECT *
FROM employees
WHERE hire_date IN
    (SELECT min(hire_date)
     FROM employees
     WHERE emp_id IN
         (SELECT emp_id
          FROM employees e,
               salary_grade s
          WHERE e.salary BETWEEN s.min_sal AND s.max_sal
            AND s.grade IN (4,
                            5)))
  AND manager_id IN
    (SELECT emp_id
     FROM employees
     WHERE emp_name = 'KAYLING');
-- 26. Write a query in SQL to find the total salary given to the MANAGER. 
SELECT SUM (salary)
FROM employees
WHERE job_name = 'MANAGER';


-- 27. Write a query in SQL to display the total salary of employees belonging to grade 3.   

SELECT sum(salary)
FROM employees
WHERE emp_id IN
    (SELECT emp_id
     FROM employees e,
          salary_grade s
     WHERE e.salary BETWEEN s.min_sal AND s.max_sal
       AND s.grade = 3);
-- 28. Write a query in SQL to list the employees in department 1001 whose salary is more than the average salary of employees in department 2001.    

SELECT *
FROM employees
WHERE dep_id =1001
  AND salary >
    (SELECT AVG (salary)
     FROM employees
     WHERE dep_id = 2001);
-- 29. Write a query in SQL to list the details of the departments where maximum number of employees are working.    

SELECT d.dep_id,
       d.dep_name,
       d.dep_location,
       count(*)
FROM employees e,
     department d
WHERE e.dep_id = d.dep_id
GROUP BY d.dep_id
HAVING count(*) =
  (SELECT MAX (mycount)
   FROM
     (SELECT COUNT(*) mycount
      FROM employees
      GROUP BY dep_id) a);

-- 30. Write a query in SQL to display the employees whose manager name is JONAS.    

SELECT *
FROM employees
WHERE manager_id IN
    (SELECT emp_id
     FROM employees
     WHERE emp_name = 'JONAS');

-- 31. Write a query in SQL to list the employees who are not working in the department MARKETING.    

SELECT *
FROM employees
WHERE dep_id NOT IN
    (SELECT dep_id
     FROM department
     WHERE dep_name = 'MARKETING');

-- 32. Write a query in SQL to list the name, job name, department name, location for those who are working as a manager.    

SELECT e.emp_name,
       e.job_name,
       d.dep_name,
       d.dep_location
FROM employees e,
     department d
WHERE e.dep_id = d.dep_id
  AND e.emp_id IN
    (SELECT manager_id
     FROM employees) ;

-- 33. Write a query in SQL to list the name of the employees who are getting the highest salary of each department.    

SELECT e.emp_name,
       e.dep_id
FROM employees e
WHERE e.salary IN
    (SELECT max(salary)
     FROM employees
     GROUP BY dep_id) ;
-- 34. Write a query in SQL to list the employees whose salary is equal or more to the average of maximum and minimum salary.    

SELECT *
FROM employees
WHERE salary >=
    (SELECT (max(salary)+min(salary))/2
     FROM employees);
-- 35. Write a query in SQL to list the employees who are SALESMAN and gathered an experience which month portion is more than 10.    
SELECT *
FROM employees m
WHERE m.emp_id IN
    (SELECT manager_id
     FROM employees)
  AND m.salary >
    (SELECT avg(e.salary)
     FROM employees e
     WHERE e.manager_id = m.emp_id );

-- 36. Write a query in SQL to list the employees whose salary is less than the salary of his manager but more than the salary of any other manager.    
SELECT *
FROM employees w,
     employees m
WHERE w.manager_id = m.emp_id
  AND w.salary < m.salary
  AND w.salary > ANY
    (SELECT salary
     FROM employees
     WHERE emp_id IN
         (SELECT manager_id
          FROM employees));

-- 37. Write a query in SQL to list the name and average salary of employees in department wise.    

SELECT e.emp_name,
       d.maxsal,
       e.dep_id AS "Current Salary"
FROM employees e,

  (SELECT avg(salary) maxsal,
          dep_id
   FROM employees
   GROUP BY dep_id) d
WHERE e.dep_id=d.dep_id;
-- 38. Write a query in SQL to find out the least 5 earners of the company.    
SELECT *
FROM employees e
WHERE 5>
    (SELECT count(*)
     FROM employees
     WHERE e.salary >salary);

-- 39. Write a query in SQL to list the managers who are not working under the PRESIDENT.   
SELECT *
FROM employees
WHERE emp_id IN
    (SELECT manager_id
     FROM employees)
  AND manager_id NOT IN
    (SELECT emp_id
     FROM employees
     WHERE job_name = 'PRESIDENT');

-- 40. Write a query in SQL to list the name, salary, commission and netpay for those employees whose netpay is more than any other employee.    
SELECT e.emp_name,
       e.salary,
       e.commission,

  (SELECT sum(salary+commission)
   FROM employees) NETPAY
FROM employees e
WHERE
    (SELECT sum(salary+commission)
     FROM employees) > ANY
    (SELECT salary
     FROM employees
     WHERE emp_id =e.emp_id) ;

-- 41.Write a query in SQL to list the name of the department where number of employees is equal to the number of characters in the department name.    

SELECT *
FROM department d
WHERE length(dep_name) IN
    (SELECT count(*)
     FROM employees e
     WHERE e.dep_id = d.dep_id );

-- 42. Write a query in SQL to list the name of the departments where highest number of employees are working.   

SELECT dep_name
FROM department
WHERE dep_id IN
    (SELECT dep_id
     FROM employees
     GROUP BY dep_id
     HAVING count(*) IN
       (SELECT MAX (mycount)
        FROM
          (SELECT COUNT(*) mycount
           FROM employees
           GROUP BY dep_id) a));
-- 43. Write a query in SQL to list the employees who joined in the company on the same date.    
SELECT *
FROM employees e
WHERE hire_date IN
    (SELECT hire_date
     FROM employees
     WHERE e.emp_id <> emp_id);


-- 44. Write a query in SQL to list the name of the departments where more than average number of employees are working. 

SELECT d.dep_name
FROM department d,
     employees e
WHERE e.dep_id = d.dep_id
GROUP BY d.dep_name
HAVING count(*) >
  (SELECT AVG (mycount)
   FROM
     (SELECT COUNT(*) mycount
      FROM employees
      GROUP BY dep_id) a);
-- 45. Write a query in SQL to list the name of the managers who is having maximum number of employees working under him.    
SELECT m.emp_name,
       count(*)
FROM employees w,
     employees m
WHERE w.manager_id = m.emp_id
GROUP BY m.emp_name
HAVING count(*) =
  (SELECT MAX (mycount)
   FROM
     (SELECT COUNT(*) mycount
      FROM employees
      GROUP BY manager_id) a);

-- 46. Write a query in SQL to list those managers who are getting salary to less than the salary of his employees.   

SELECT *
FROM employees w
WHERE salary < ANY
    (SELECT salary
     FROM employees
     WHERE w.emp_id=manager_id);

-- 47. Write a query in SQL to list the details of all the employees who are sub-ordinates to BLAZE .
SELECT *
FROM employees
WHERE manager_id IN
    (SELECT emp_id
     FROM employees
     WHERE emp_name = 'BLAZE');

-- 48. Write a query in SQL to list the employees who are working as managers, using co-related subquery.    
SELECT *
FROM employees
WHERE emp_id IN
    (SELECT manager_id
     FROM employees);

-- 49. Write a query in SQL to list the name of the employees for their manager JONAS and also the name of the manager of JONAS.   

SELECT w.emp_name,
       m.emp_name,

  (SELECT emp_name
   FROM employees
   WHERE m.manager_id = emp_id) "his MANAGER"
FROM employees w,
     employees m
WHERE w.manager_id = m.emp_id
  AND m.emp_name = 'JONAS';

-- 50. Write a query in SQL to find all the employees who earn the minimum salary for a designation and arrange the list in ascending order on salary.    
SELECT *
FROM employees
WHERE salary IN
    (SELECT min(salary)
     FROM employees
     GROUP BY job_name)
ORDER BY salary ASC;

-- 51. Write a query in SQL to find all the employees who earn the highest salary for a designation and arrange the list in descending order on salary.    
SELECT *
FROM employees
WHERE salary IN
    (SELECT max(salary)
     FROM employees
     GROUP BY job_name)
ORDER BY salary DESC;

-- 52. Write a query in SQL to find the most recently hired emps in each department order by hire_date.    
SELECT *
FROM employees e
WHERE hire_date IN
    (SELECT max(hire_date)
     FROM employees
     WHERE e.dep_id = dep_id )
ORDER BY hire_date DESC;

-- 53. Write a query in SQL to list the name,salary, and department id for each employee who earns a salary greater than the average salary for their department and list the result in ascending order on department id.   

SELECT e.emp_name,
       e.salary,
       e.dep_id
FROM employees e
WHERE salary >
    (SELECT avg(salary)
     FROM employees
     WHERE e.dep_id = dep_id )
ORDER BY dep_id;

-- 54. Write a query in SQL to find the name and designation of the employees who earns a commission and salary is the maximum.   
SELECT *
FROM employees
WHERE salary =
    (SELECT max(salary)
     FROM employees
     WHERE commission IS NOT NULL);
-- 55. Write a query in SQL to list the name, designation, and salary of the employees who does not work in the department 1001 but works in same designation and salary as the employees in department 3001    
SELECT emp_name,
       job_name,
       salary
FROM employees
WHERE dep_id != 1001
  AND job_name IN
    (SELECT job_name
     FROM employees
     WHERE dep_id = 3001)
  AND salary IN
    (SELECT salary
     FROM employees
     WHERE dep_id = 3001);
-- 56. Write a query in SQL to list the department id, name, designation, salary, and net salary (salary+commission) of the SALESMAN who are earning maximum net salary.   
SELECT dep_id,
       emp_name,
       job_name,
       salary,
       salary+commission "Net Salary"
FROM employees
WHERE job_name = 'SALESMAN'
  AND salary+commission IN
    (SELECT max(salary+commission)
     FROM employees
     WHERE commission IS NOT NULL);

-- 57. Write a query in SQL to list the department id, name, designation, salary, and net salary of the employees only who gets a commission and earn the second highest earnings. 
SELECT dep_id,
       emp_name,
       salary,
       job_name,
       salary+commission "Net Salary"
FROM employees e
WHERE 2-1 = (
  SELECT count(DISTINCT emp.salary+emp.commission)
  FROM employees emp WHERE emp.salary+emp.commission>e.salary+e.commission);


-- 58. Write a query in SQL to list the department ID and their average salaries for those department where the average salary is less than the averages for all departments.    

SELECT dep_id,
       avg(salary)
FROM employees
GROUP BY dep_id
HAVING avg(salary) <
  (SELECT avg(salary)
   FROM employees);
-- 59. Write a query in SQL to display the unique department of the employees. 
SELECT *
FROM department
WHERE dep_id IN
    (SELECT DISTINCT dep_id
     FROM employees);

-- 60. Write a query in SQL to list the details of the employees working at PERTH.   
SELECT *
FROM employees
WHERE dep_id IN
    (SELECT dep_id
     FROM department
     WHERE department.dep_location = 'PERTH');

-- 61. Write a query in SQL to list the employees of grade 2 and 3 who belongs to the city PERTH.   
SELECT *
FROM employees
WHERE emp_id IN
    (SELECT emp_id
     FROM employees e,
          salary_grade s
     WHERE e.salary BETWEEN s.min_sal AND s.max_sal
       AND s.grade IN (2,
                       3))
  AND dep_id IN
    (SELECT dep_id
     FROM department
     WHERE dep_LOCATION='PERTH');

-- 62. Write a query in SQL to list the employees whose designation is same as either the designation of ADLYNE or the salary is more than salary of WADE.  
SELECT *
FROM employees
WHERE job_name =
    (SELECT job_name
     FROM employees
     WHERE emp_name = 'ADELYN')
  OR salary >
    (SELECT salary
     FROM employees
     WHERE emp_name = 'WADE');


-- 63. Write a query in SQL to list the employees of department 1001 whose salary is more than the salary of ADELYN.   
SELECT *
FROM employees
WHERE dep_id = 1001
  AND salary >
    (SELECT salary
     FROM employees
     WHERE emp_name = 'ADELYN');

-- 64. Write a query in SQL to list the managers who are senior to KAYLING and who are junior to SANDRINE.   
SELECT *
FROM employees
WHERE emp_id IN
    (SELECT manager_id
     FROM employees
     WHERE hire_date<
         (SELECT hire_date
          FROM employees
          WHERE emp_name = 'KAYLING' )
       AND hire_date >
         (SELECT hire_date
          FROM employees
          WHERE emp_name = 'SANDRINE'))
  AND manager_id IS NOT NULL;

-- 65.Write a query in SQL to list the ID, name,location,salary, and department of the all the employees belonging to the department where KAYLING works.   

SELECT e.emp_id,
       e.emp_name,
       d.dep_location,
       e.salary,
       d.dep_name
FROM employees e,
     department d
WHERE e.dep_id=d.dep_id
  AND e.dep_id IN
    (SELECT dep_id
     FROM employees
     WHERE emp_name = 'KAYLING'
       AND employees.emp_id <> e.emp_id);
-- 66. Write a query in SQL to list the employees whose salary grade are greater than the grade of MARKER.    

SELECT *
FROM employees e,
     salary_grade s
WHERE e.salary BETWEEN s.min_sal AND s.max_sal
  AND s.grade >
    (SELECT s.grade
     FROM employees e,
          salary_grade s
     WHERE e.salary BETWEEN s.min_sal AND s.max_sal
       AND e.emp_name = 'MARKER') ;
-- 67. Write a query in SQL to list the employees of the grade same as the grade of TUCKER or experience is more than SANDRINE and who are belonging to SYDNEY or PERTH. 

SELECT *
FROM employees e,
     department d,
     salary_grade s
WHERE e.dep_id= d.dep_id
  AND d.dep_location IN ('SYDNEY',
                         'PERTH')
  AND e.salary BETWEEN s.min_sal AND s.max_sal
  AND (s.grade IN
         (SELECT s.grade
          FROM employees e,
               salary_grade s
          WHERE e.salary BETWEEN s.min_sal AND s.max_sal
            AND e.emp_name = 'TUCKER')
       OR age (CURRENT_DATE,hire_date) >
         (SELECT age(CURRENT_DATE,hire_date)
          FROM employees
          WHERE emp_name = 'SANDRINE')) ;
-- 68. Write a query in SQL to list the employees whose salary is same as any one of the employee.    

SELECT *
FROM employees
WHERE salary IN
    (SELECT salary
     FROM employees e
     WHERE employees.emp_id <> e.emp_id);
-- 69. Write a query in SQL to list the total remuneration (salary+commission) of all sales person of MARKETING department.    
SELECT *
FROM employees e
WHERE salary+commission IN
    (SELECT salary+commission
     FROM employees e,
          department d
     WHERE e.dep_id=d.dep_id
       AND d.dep_name = 'MARKETING'
       AND e.job_name = 'SALESMAN');
-- 70. Write a query in SQL to list the details of most recently hired employees of department 3001. 
SELECT *
FROM employees
WHERE hire_date IN
    (SELECT max(hire_date)
     FROM employees
     WHERE dep_id = 3001) AND dep_id=3001;

-- 71. Write a query in SQL to list the highest paid employees of PERTH who joined before the most recently hired employee of grade 2 
SELECT *
FROM employees
WHERE salary =
    (SELECT max(salary)
     FROM employees e,
          department d
     WHERE e.dep_id = d.dep_id
       AND d.dep_location = 'PERTH'
       AND hire_date <
         (SELECT max(hire_date)
          FROM employees e,
               salary_grade s
          WHERE e.salary BETWEEN s.min_sal AND s.max_sal
            AND s.grade = 2));
-- 72. Write a query in SQL to list the highest paid employees working under KAYLING.    
SELECT *
FROM employees
WHERE salary IN
    (SELECT max(salary)
     FROM employees
     WHERE manager_id IN
         (SELECT emp_id
          FROM employees
          WHERE emp_name = 'KAYLING'));
-- 73. Write a query in SQL to list the name, salary, and commission for those employees whose net pay is greater than or equal to the salary of any other employee in the company.    
SELECT e.emp_name,
       e.salary,
       e.commission
FROM employees e
WHERE
    (SELECT max(salary+commission)
     FROM employees) >= ANY
    (SELECT salary
     FROM employees);

-- 74. Write a query in SQL to find out the employees whose salaries are greater than the salaries of their managers.    
SELECT *
FROM employees w,
     employees m
WHERE w.manager_id = m.emp_id
  AND w.salary> m.salary;

-- 75. Write a query in SQL to find the maximum average salary drawn for each job name except for PRESIDENT.    
SELECT max(myavg)
FROM
  (SELECT avg(salary) myavg
   FROM employees
   WHERE job_name != 'PRESIDENT'
   GROUP BY job_name) a;
-- 76. Write a query in SQL to find the number of employees are performing the duty of a manager.    
SELECT count(*)
FROM employees
WHERE emp_id IN
    (SELECT manager_id
     FROM employees);

-- 77. Write a query in SQL to list the department where there are no employees.     
SELECT b.dep_id,
       count(a.dep_id)
FROM department b
LEFT OUTER JOIN employees a ON a.dep_id=b.dep_id
GROUP BY b.dep_id
HAVING count(a.dep_id) = 0;
