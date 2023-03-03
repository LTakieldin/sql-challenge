DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Employee_No;
DROP TABLE IF EXISTS Dept_Manager;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS Title;

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Dept_Emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "Dept_Manager" (
    "dept_no" VARCHAR   NOT NULL,
	"emp_no" INT   NOT NULL
);

CREATE TABLE "Employees" (
    "emp_no" INT   NOT NULL,
    "title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "Title" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Title" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "Employees" ADD CONSTRAINT "fk_employees_title_id" FOREIGN KEY("title_id")
REFERENCES "Title" ("title_id");

ALTER TABLE "Dept_Manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

ALTER TABLE "Dept_Manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Dept_Emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "Employees" ("emp_no");

ALTER TABLE "Dept_Emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "Departments" ("dept_no");

SELECT "Employees".last_name FROM "Employees"

-- List the employee number, last name, first name, sex, and salary of each employee
SELECT "Employees".emp_no, "Employees".last_name, "Employees".first_name, "Employees".sex, "Salaries".salary
FROM "Employees"
INNER JOIN "Salaries" ON "Employees".emp_no = "Salaries".emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name, last_name, hire_date 
FROM "Employees"
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT "Departments".dept_no, "Departments".dept_name, "Dept_Manager".emp_no, "Employees".last_name, "Employees".first_name
FROM "Departments"
INNER JOIN "Dept_Manager"
ON "Departments".dept_no = "Dept_Manager".dept_no
INNER JOIN "Employees"
ON "Dept_Manager".emp_no = "Employees".emp_no;

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name 
SELECT "Dept_Emp".emp_no, "Employees".last_name, "Employees".first_name, "Departments".dept_name
FROM "Dept_Emp"
JOIN "Employees"
ON "Dept_Emp".emp_no = "Employees".emp_no
JOIN "Departments"
ON "Dept_Emp".dept_no = "Departments".dept_no;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT first_name, last_name, sex
FROM "Employees"
WHERE first_name = 'Hercules'
AND last_name Like 'B%'

-- List each employee in the Sales department, including their employee number, last name, and first name
SELECT last_name, first_name, "Employees".emp_no 
FROM "Employees"
JOIN "Dept_Emp"
ON  "Employees".emp_no = "Dept_Emp".emp_no
JOIN "Departments"
ON "Dept_Emp".dept_no = "Departments".dept_no
WHERE "Departments".dept_name = 'Sales';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT "Dept_Emp".emp_no, "Employees".last_name, "Employees".first_name, "Departments".dept_name
FROM "Dept_Emp"
JOIN "Employees"
ON "Dept_Emp".emp_no = "Employees".emp_no
JOIN "Departments"
ON "Dept_Emp".dept_no = "Departments".dept_no
WHERE "Departments".dept_name = 'Sales' 
OR "Departments".dept_name = 'Development';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM "Employees"
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;

