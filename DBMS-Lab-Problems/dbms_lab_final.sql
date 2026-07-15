DROP DATABASE IF EXISTS universitydb;
CREATE DATABASE universitydb;
USE universitydb;

-- =========================
-- TABLE DROP (safety)
-- =========================
DROP TABLE IF EXISTS prereq;
DROP TABLE IF EXISTS advisor;
DROP TABLE IF EXISTS takes;
DROP TABLE IF EXISTS teaches;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS department;

-- =========================
-- CREATE TABLES
-- =========================

CREATE TABLE department (
    dept_name VARCHAR(20),
    building VARCHAR(15),
    budget DECIMAL(12,2),
    PRIMARY KEY (dept_name)
);

CREATE TABLE instructor (
    ID VARCHAR(5),
    name VARCHAR(20),
    dept_name VARCHAR(20),
    salary DECIMAL(8,2),
    PRIMARY KEY (ID),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE course (
    course_id VARCHAR(8),
    title VARCHAR(50),
    dept_name VARCHAR(20),
    credits DECIMAL(2,0),
    PRIMARY KEY (course_id),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE section (
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year DECIMAL(4,0),
    building VARCHAR(15),
    room_number VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

CREATE TABLE student (
    ID VARCHAR(5),
    name VARCHAR(20),
    dept_name VARCHAR(20),
    tot_cred DECIMAL(3,0),
    PRIMARY KEY (ID),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE teaches (
    ID VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year DECIMAL(4,0),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES instructor(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);

CREATE TABLE takes (
    ID VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year DECIMAL(4,0),
    grade VARCHAR(2),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES student(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);

CREATE TABLE advisor (
    s_ID VARCHAR(5),
    i_ID VARCHAR(5),
    PRIMARY KEY (s_ID),
    FOREIGN KEY (s_ID) REFERENCES student(ID),
    FOREIGN KEY (i_ID) REFERENCES instructor(ID)
);

CREATE TABLE prereq (
    course_id VARCHAR(8),
    prereq_id VARCHAR(8),
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (prereq_id) REFERENCES course(course_id)
);

-- =========================
-- INSERT DATA (ORDER FIXED)
-- =========================

-- Department (MUST FIRST)
INSERT INTO department VALUES ('Comp. Sci.', 'Taylor', 100000);
INSERT INTO department VALUES ('Biology', 'Watson', 90000);
INSERT INTO department VALUES ('Finance', 'Painter', 120000);
INSERT INTO department VALUES ('Physics', 'Newton', 80000);
INSERT INTO department VALUES ('History', 'King', 70000);

-- Instructor
INSERT INTO instructor VALUES ('10101', 'Srinivasan', 'Comp. Sci.', 65000);
INSERT INTO instructor VALUES ('12121', 'Wu', 'Finance', 90000);
INSERT INTO instructor VALUES ('22222', 'Einstein', 'Physics', 95000);
INSERT INTO instructor VALUES ('32343', 'El Said', 'History', 60000);
INSERT INTO instructor VALUES ('83821', 'Brandt', 'Comp. Sci.', 92000);

-- Course
INSERT INTO course VALUES ('CS-101', 'Intro to CS', 'Comp. Sci.', 4);
INSERT INTO course VALUES ('CS-315', 'Robotics', 'Comp. Sci.', 3);
INSERT INTO course VALUES ('BIO-101', 'Intro to Bio', 'Biology', 3);
INSERT INTO course VALUES ('FIN-201', 'Investment', 'Finance', 3);

-- Section
INSERT INTO section VALUES ('CS-101', '1', 'Fall', 2024, 'Taylor', '3128', 'A');
INSERT INTO section VALUES ('CS-315', '1', 'Spring', 2025, 'Taylor', '3128', 'B');

-- Student
INSERT INTO student VALUES ('00128', 'Zhang', 'Comp. Sci.', 102);
INSERT INTO student VALUES ('12345', 'Shankar', 'Comp. Sci.', 32);
INSERT INTO student VALUES ('76543', 'Brown', 'Comp. Sci.', 58);

-- Teaches
INSERT INTO teaches VALUES ('10101', 'CS-101', '1', 'Fall', 2024);
INSERT INTO teaches VALUES ('83821', 'CS-315', '1', 'Spring', 2025);

-- Takes
INSERT INTO takes VALUES ('00128', 'CS-101', '1', 'Fall', 2024, 'A');
INSERT INTO takes VALUES ('12345', 'CS-315', '1', 'Spring', 2025, 'A');

-- Advisor
INSERT INTO advisor VALUES ('00128', '10101');

-- Prereq
INSERT INTO prereq VALUES ('CS-315', 'CS-101');


select name,dept_name
from instructor
where salary>20000;
select s.name,t.grade
from student as s
join takes as t
on s.id=t.id
where dept_name='CSE';
select name,avg(salary) 
from instructor
where avg(salary)>
           (select avg(salary) 
            from instructor);
use universitydb;
SELECT dept_name
from instructor
group by dept_name 
having avg(salary)>
		          (select avg(salary) 
	              from instructor);
delimiter //
create procedure adjust_budget
(in p_dept_name varchar(50), p_percent numeric(4,3))
begin
update department set budget=budget*(p_percent)
where dept_name=p_dept_name;
end //
delimiter ;
call adjust_budget('Biology',1.05);
select*from department;
use universitydb;
            

            
            
            
