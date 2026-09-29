SET PAGESIZE 1000;
SET LINESIZE 1000;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

BEGIN
    FOR v IN (SELECT view_name FROM user_views WHERE view_name IN ('STUDENT_COURSE_VIEW', 'DEPT_STUDENT_COUNT', 'HIGH_MARKS_VIEW')) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v.view_name;
    END LOOP;
    
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN ('WORKS', 'PROJECT', 'EMPLOYEE', 'DEPARTMENT', 'ENROLLMENT', 'EVENING_STUDENT', 'COURSE', 'STUDENT', 'ENROLLS', 'COURSES', 'ROOMS', 'FACULTY', 'STUDENTS', 'DEPARTMENTS', 'ALUMNI')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

CREATE TABLE departments (
    dept_id NUMBER(3) PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL,
    location VARCHAR2(50),
    head_id NUMBER(5),
    contact_email VARCHAR2(50) UNIQUE,
    phone_no VARCHAR2(20)
);

CREATE TABLE faculty (
    FID NUMBER(5) PRIMARY KEY,
    Fname VARCHAR2(50),
    phone_no VARCHAR2(20),
    email VARCHAR2(50) UNIQUE,
    designation VARCHAR2(30),
    dept_id NUMBER(3),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

ALTER TABLE departments 
ADD CONSTRAINT fk_dept_head FOREIGN KEY (head_id) REFERENCES faculty(FID);

CREATE TABLE students (
    student_id NUMBER(5) PRIMARY KEY,
    name VARCHAR2(50),
    email VARCHAR2(50) UNIQUE,
    contact_no VARCHAR2(20),
    date_of_birth DATE,
    batch VARCHAR2(10),
    cgpa NUMBER(3,2),
    admission_year NUMBER(4),
    dept_id NUMBER(3),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE evening_students (
    student_id NUMBER(5) PRIMARY KEY,
    name VARCHAR2(50),
    dept_id NUMBER(3)
);

CREATE TABLE alumni (
    alumni_id NUMBER(5) PRIMARY KEY,
    name VARCHAR2(50),
    email VARCHAR2(50) UNIQUE,
    cgpa NUMBER(3,2),
    dept_id NUMBER(3)
);

CREATE TABLE rooms (
    room_no NUMBER(4) PRIMARY KEY,
    room_status VARCHAR2(20),
    room_type VARCHAR2(20),
    capacity NUMBER(3),
    floor_no NUMBER(2),
    ac_status VARCHAR2(5),
    building VARCHAR2(50),
    dept_id NUMBER(3),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE courses (
    course_code VARCHAR2(10) PRIMARY KEY,
    c_title VARCHAR2(50),
    credit_hrs NUMBER(3,2),
    c_type VARCHAR2(20),
    c_level NUMBER(2),
    FID NUMBER(5),
    dept_id NUMBER(3),
    FOREIGN KEY (FID) REFERENCES faculty(FID),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE enrolls (
    student_id NUMBER(5),
    course_code VARCHAR2(10),
    semester VARCHAR2(10),
    grade_obtained VARCHAR2(2),
    marks NUMBER(3),
    PRIMARY KEY (student_id, course_code),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_code) REFERENCES courses(course_code)
);

ALTER TABLE departments ADD temp_code CHAR(5);
ALTER TABLE departments MODIFY temp_code VARCHAR2(10);
ALTER TABLE departments RENAME COLUMN temp_code TO dept_code;
ALTER TABLE departments DROP COLUMN dept_code;

INSERT INTO departments VALUES (101, 'CSE', 'Building 1', NULL, 'cse@univ.edu', '01710000000');
INSERT INTO departments VALUES (102, 'EEE', 'Building 2', NULL, 'eee@univ.edu', '01810000000');
INSERT INTO departments VALUES (103, 'ME', 'Building 3', NULL, 'me@univ.edu', '01910000000');
INSERT INTO departments VALUES (104, 'BBA', 'Building 4', NULL, 'bba@univ.edu', '01610000000');

INSERT INTO faculty VALUES (501, 'Dr. Mahbub', '01720000000', 'mahbub@univ.edu', 'Professor', 101);
INSERT INTO faculty VALUES (502, 'Tanvir Ahmed', '01820000000', 'tanvir@univ.edu', 'Lecturer', 102);

UPDATE departments SET head_id = 501 WHERE dept_id = 101;
UPDATE departments SET head_id = 502 WHERE dept_id = 102;

INSERT INTO rooms VALUES (201, 'Available', 'Lab', 40, 2, 'Yes', 'Science Complex', 101);
INSERT INTO rooms VALUES (305, 'Idle', 'Theory', 60, 3, 'No', 'Engineering Block', 102);

INSERT INTO courses VALUES ('CSE-1101', 'Database Systems', 4.00, 'Theory', 1, 501, 101);
INSERT INTO courses VALUES ('CSE-1102', 'Algorithms', 3.00, 'Theory', 1, 501, 101);
INSERT INTO courses VALUES ('EEE-1201', 'Circuits', 4.00, 'Lab', 2, 502, 102);
INSERT INTO courses VALUES ('BBA-2101', 'Finance', 2.00, 'Theory', 1, NULL, 104);

INSERT INTO students VALUES (101, 'Ayesha', 'ayesha@gm.com', '01910000000', DATE '2001-05-12', '58', 3.80, 2020, 101);
INSERT INTO students VALUES (102, 'Rahim', 'rahim@gm.com', '01810000000', DATE '2002-08-20', '59', 3.20, 2022, 101);
INSERT INTO students VALUES (103, 'Karim', 'karim@gm.com', '01730000000', DATE '2000-01-10', '57', 3.50, 2022, 102);
INSERT INTO students VALUES (104, 'Nusrat', 'nusrat@gm.com', '01600000000', DATE '2003-03-15', '60', 3.90, 2021, 104);
INSERT INTO students VALUES (105, 'Tariq', 'tariq@gm.com', '01500000000', DATE '2001-11-05', '58', 2.80, 2023, 101);

INSERT INTO evening_students VALUES (101, 'Ayesha', 101);
INSERT INTO evening_students VALUES (201, 'Sultana', 102);

INSERT INTO alumni VALUES (2001, 'Arafat Rahman', 'arafat@gm.com', 3.70, 101);
INSERT INTO alumni VALUES (2002, 'Farzana', 'farzana@gm.com', 3.85, 102);

INSERT INTO enrolls VALUES (101, 'CSE-1101', 'Spring23', 'A+', 85);
INSERT INTO enrolls VALUES (101, 'CSE-1102', 'Spring23', 'A+', 90);
INSERT INTO enrolls VALUES (102, 'CSE-1101', 'Spring23', 'B', 70);
INSERT INTO enrolls VALUES (103, 'EEE-1201', 'Spring23', 'A', 88);
INSERT INTO enrolls VALUES (104, 'CSE-1101', 'Spring23', 'A+', 95);
INSERT INTO enrolls VALUES (105, 'CSE-1102', 'Spring23', 'C', 60);

COMMIT;

-- Filtering & Relational Operators
SELECT * FROM students WHERE cgpa < 3.50;
SELECT * FROM students WHERE cgpa <= 3.20;
SELECT * FROM students WHERE dept_id <> 101;

-- Range Operator
SELECT * FROM students WHERE cgpa BETWEEN 3.20 AND 3.80;

-- Logical Operators
SELECT * FROM students WHERE dept_id = 101 AND batch = '58';
SELECT * FROM students WHERE dept_id = 102 OR batch = '57';
SELECT * FROM students WHERE NOT (dept_id = 102);

-- Set Membership
SELECT * FROM students WHERE dept_id IN (101, 102);
SELECT * FROM students WHERE student_id NOT IN (SELECT student_id FROM enrolls);

-- Quantifiers
SELECT * FROM students WHERE cgpa > SOME (SELECT cgpa FROM students WHERE dept_id = 101);
SELECT * FROM students WHERE cgpa > ANY (SELECT cgpa FROM students WHERE dept_id = 101);
SELECT * FROM students WHERE cgpa > ALL (SELECT cgpa FROM students WHERE dept_id = 101);

-- Existence Operators
SELECT name FROM students s WHERE EXISTS (SELECT 1 FROM enrolls e WHERE s.student_id = e.student_id);
SELECT * FROM courses c WHERE NOT EXISTS (SELECT 1 FROM enrolls e WHERE e.course_code = c.course_code);

-- Unique Check via Group By
SELECT s.student_id, s.name 
FROM students s JOIN enrolls e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(e.course_code) = COUNT(DISTINCT e.course_code);

-- Pattern Matching (LIKE)
SELECT * FROM students WHERE name LIKE 'A%';
SELECT * FROM students WHERE name LIKE '%i%';
SELECT * FROM students WHERE name LIKE '_a%';
SELECT * FROM students WHERE name LIKE 'A__a';
SELECT * FROM students WHERE name LIKE 'R____';

-- Aggregate Functions
SELECT COUNT(*) AS total_students FROM students;
SELECT AVG(cgpa) AS average_cgpa FROM students;
SELECT SUM(marks) AS total_marks FROM enrolls;
SELECT MAX(cgpa) AS highest_cgpa FROM students;
SELECT MIN(cgpa) AS lowest_cgpa FROM students;

-- Group By
SELECT dept_id, COUNT(*) AS student_count FROM students GROUP BY dept_id;
SELECT dept_id, AVG(cgpa) AS avg_dept_cgpa FROM students GROUP BY dept_id;

-- Having Clause
SELECT dept_id, AVG(cgpa) FROM students GROUP BY dept_id HAVING AVG(cgpa) > 3.50;
SELECT course_code, MAX(marks) FROM enrolls GROUP BY course_code HAVING MAX(marks) > 85;
SELECT dept_id, COUNT(*) FROM students GROUP BY dept_id HAVING COUNT(*) > 2;

-- Distinct & Sorting
SELECT DISTINCT dept_id FROM students;
SELECT COUNT(DISTINCT course_code) FROM enrolls;
SELECT name, cgpa FROM students ORDER BY cgpa ASC;
SELECT name, cgpa FROM students ORDER BY cgpa DESC, name ASC;

-- Joins
SELECT s.name, c.c_title, e.grade_obtained 
FROM students s 
INNER JOIN enrolls e ON s.student_id = e.student_id 
INNER JOIN courses c ON e.course_code = c.course_code;

SELECT s.name, e.course_code FROM students s LEFT JOIN enrolls e ON s.student_id = e.student_id;

SELECT c.c_title, e.student_id FROM enrolls e RIGHT JOIN courses c ON e.course_code = c.course_code;

SELECT s.name, d.dept_name FROM students s FULL JOIN departments d ON s.dept_id = d.dept_id;

-- Set Operators
SELECT name FROM students UNION SELECT name FROM evening_students;
SELECT name FROM students UNION ALL SELECT name FROM evening_students;
SELECT name FROM students INTERSECT SELECT name FROM evening_students;
SELECT name FROM students MINUS SELECT name FROM evening_students;

-- CTE (WITH Clause)
WITH HighScorers AS (
    SELECT student_id, marks FROM enrolls WHERE marks > 75
)
SELECT s.name, h.marks FROM students s JOIN HighScorers h ON s.student_id = h.student_id;

-- Nested & Correlated Subqueries
SELECT * FROM students WHERE cgpa > (SELECT AVG(cgpa) FROM students);
SELECT * FROM students WHERE dept_id = (SELECT dept_id FROM students WHERE name = 'Rahim') AND name <> 'Rahim';
SELECT * FROM students WHERE student_id IN (SELECT student_id FROM enrolls WHERE marks = (SELECT MAX(marks) FROM enrolls));
SELECT s.* FROM students s WHERE s.cgpa > (SELECT AVG(s2.cgpa) FROM students s2 WHERE s2.dept_id = s.dept_id);

-- Views Creation
CREATE VIEW student_course_view AS
SELECT s.name AS student_name, c.c_title, e.grade_obtained 
FROM students s JOIN enrolls e ON s.student_id = e.student_id JOIN courses c ON e.course_code = c.course_code;

CREATE VIEW dept_student_count AS
SELECT d.dept_name, COUNT(s.student_id) AS total_students 
FROM departments d LEFT JOIN students s ON d.dept_id = s.dept_id GROUP BY d.dept_name;

CREATE VIEW high_marks_view AS
SELECT s.name, e.marks FROM students s JOIN enrolls e ON s.student_id = e.student_id WHERE e.marks > 80;

-- View Usage
SELECT * FROM student_course_view;
SELECT * FROM dept_student_count;
SELECT * FROM high_marks_view;

-- Procedures & Functions
CREATE OR REPLACE PROCEDURE greet_student IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello Student, Welcome to PL/SQL!');
END;
/

CREATE OR REPLACE FUNCTION square_num(n NUMBER) RETURN NUMBER IS
BEGIN
    RETURN n * n;
END;
/

EXEC greet_student;

SELECT square_num(5) AS squared_result FROM DUAL;

-- PL/SQL Comprehensive Block
DECLARE
    v_name students.name%TYPE;
    v_student_rec students%ROWTYPE;
    v_marks NUMBER := 85;
    v_dummy NUMBER;

    TYPE assoc_array_type IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    assoc_names assoc_array_type;

    TYPE varray_type IS VARRAY(5) OF VARCHAR2(50);
    v_names varray_type := varray_type('Rahim', 'Karim', 'Hasan');

    TYPE cgpa_array IS VARRAY(5) OF NUMBER(3,2);
    all_cgpa cgpa_array := cgpa_array();

    i NUMBER := 1;
    w_ctr NUMBER := 1;
    v_sid NUMBER := 101;
    v_scgpa students.cgpa%TYPE;

    CURSOR student_cursor IS SELECT name FROM students;
    c_name students.name%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PL/SQL MASTER BLOCK START ===');

    SELECT name INTO v_name FROM students WHERE student_id = 101;
    SELECT * INTO v_student_rec FROM students WHERE student_id = 101;
    DBMS_OUTPUT.PUT_LINE('Fetched Name (%TYPE): ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Fetched Record CGPA (%ROWTYPE): ' || v_student_rec.cgpa);

    IF v_marks >= 80 THEN
        DBMS_OUTPUT.PUT_LINE('Grade: A+');
    ELSIF v_marks >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('Grade: A');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Grade: B');
    END IF;

    assoc_names(1) := 'MHSU';
    DBMS_OUTPUT.PUT_LINE('Associative Array Value at Index 1: ' || assoc_names(1));

    LOOP
        EXIT WHEN i > 3;
        SELECT cgpa INTO v_scgpa FROM students WHERE student_id = v_sid;
        all_cgpa.EXTEND;
        all_cgpa(i) := v_scgpa;
        v_sid := v_sid + 1;
        i := i + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('EXTEND Result (Index 2 CGPA): ' || all_cgpa(2));

    WHILE w_ctr <= 3 LOOP
        DBMS_OUTPUT.PUT_LINE('WHILE Counter: ' || w_ctr);
        w_ctr := w_ctr + 1;
    END LOOP;

    FOR f_ctr IN 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE('FOR Counter: ' || f_ctr);
    END LOOP;

    OPEN student_cursor;
    LOOP
        FETCH student_cursor INTO c_name;
        EXIT WHEN student_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cursor Fetched Name: ' || c_name);
    END LOOP;
    CLOSE student_cursor;

    BEGIN
        v_dummy := 10 / 0;
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Exception Handled: ZERO_DIVIDE (Division by Zero prohibited)');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('General Error Handled.');
    END;

    DBMS_OUTPUT.PUT_LINE('=== PL/SQL MASTER BLOCK END ===');
END;
/
