-- =============================================
-- Test Data Script for sp_GetExamForStudent
-- Creates complete test scenario with student taking an exam
-- =============================================

-- Clean up existing test data (optional - comment out if not needed)
-- DELETE FROM student_answer_question WHERE student_id = 1;
-- DELETE FROM student_exam WHERE student_id = 1;
-- DELETE FROM instructor_generate_course_exam WHERE exam_id = 1;
-- DELETE FROM exam_questions WHERE exam_id = 1;

SET IDENTITY_INSERT person ON;

-- 1. Insert Person records (Student and Instructor)
INSERT INTO person (person_id, first_name, last_name, email) VALUES
(1, 'Ahmed', 'Hassan', 'ahmed.hassan@student.edu'),
(2, 'Dr. Mohamed', 'Ali', 'mohamed.ali@instructor.edu');

SET IDENTITY_INSERT person OFF;

-- 2. Insert Student
INSERT INTO student (student_id) VALUES (1);

-- 3. Insert Instructor
INSERT INTO instructor (instructor_id, hire_date) VALUES (2, '2020-01-15');

SET IDENTITY_INSERT branch ON;

-- 4. Insert Branch
INSERT INTO branch (branch_id, branch_name, branch_city) VALUES
(1, 'Main Campus', 'Cairo');

SET IDENTITY_INSERT branch OFF;

SET IDENTITY_INSERT department ON;

-- 5. Insert Department
INSERT INTO department (department_id, department_name) VALUES
(1, 'Computer Science');

SET IDENTITY_INSERT department OFF;

-- 6. Link Branch and Department
INSERT INTO branch_department (branch_id, department_id) VALUES (1, 1);

SET IDENTITY_INSERT courses ON;

-- 7. Insert Course
INSERT INTO courses (course_id, course_code, description, course_title, credits) VALUES
(1, 101, 'Introduction to Database Systems', 'Database Fundamentals', '3');

SET IDENTITY_INSERT courses OFF;

-- 8. Link Department and Course
INSERT INTO department_courses (course_id, department_id) VALUES (1, 1);

-- 9. Enroll Student in Course
INSERT INTO student_course (student_id, course_id, enrollment_date) VALUES
(1, 1, '2025-09-01 00:00:00');

-- 10. Assign Instructor to Course
INSERT INTO instructor_course (instructor_id, course_id) VALUES (2, 1);

SET IDENTITY_INSERT topic ON;

-- 11. Insert Topics
INSERT INTO topic (topic_id, topic_order, topic_duration, topic_title) VALUES
(1, 1, '2 weeks', 'SQL Basics'),
(2, 2, '3 weeks', 'Database Design'),
(3, 3, '2 weeks', 'Normalization');

SET IDENTITY_INSERT topic OFF;

SET IDENTITY_INSERT exam ON;

-- 12. Create Exam
INSERT INTO exam (exam_id, exam_title, total_grade, exam_date, exam_type, duration_mins) VALUES
(1, 'Database Midterm Exam', 10, '2026-01-05 10:00:00', 'mid', 60);

SET IDENTITY_INSERT exam OFF;

SET IDENTITY_INSERT quesiton_choice ON;

-- 13. Insert Question Choices
INSERT INTO quesiton_choice (choice_id, choice_text) VALUES
-- Question 1 choices
(1, 'A unique identifier for each record in a table'),
(2, 'A key that references another table'),
(3, 'An index on a table'),
(4, 'A constraint that allows NULL values'),
-- Question 2 choices
(5, 'Structured Query Language'),
(6, 'Simple Query Language'),
(7, 'Standard Question Language'),
(8, 'System Query Language'),
-- Question 3 choices
(9, 'True'),
(10, 'False'),
-- Question 4 choices
(11, 'SELECT'),
(12, 'INSERT'),
(13, 'UPDATE'),
(14, 'DELETE'),
-- Question 5 choices
(15, '1NF'),
(16, '2NF'),
(17, '3NF'),
(18, 'BCNF'),
-- Question 6 choices
(19, 'True'),
(20, 'False'),
-- Question 7 choices
(21, 'INNER JOIN'),
(22, 'LEFT JOIN'),
(23, 'RIGHT JOIN'),
(24, 'FULL OUTER JOIN'),
-- Question 8 choices
(25, 'True'),
(26, 'False'),
-- Question 9 choices
(27, 'Data Definition Language'),
(28, 'Data Dictionary Language'),
(29, 'Data Design Language'),
(30, 'Data Development Language'),
-- Question 10 choices
(31, 'Primary Key'),
(32, 'Foreign Key'),
(33, 'Unique Key'),
(34, 'Composite Key');

SET IDENTITY_INSERT quesiton_choice OFF;

SET IDENTITY_INSERT question ON;

-- 14. Insert Questions
INSERT INTO question (question_id, question_text, question_type, question_difficulty, correct_ans_id) VALUES
(1, 'What is a Primary Key?', 'MCQ', 'easy', 1),
(2, 'What does SQL stand for?', 'MCQ', 'easy', 5),
(3, 'Database normalization reduces data redundancy', 'True_False', 'medium', 9),
(4, 'Which SQL command is used to retrieve data?', 'MCQ', 'easy', 11),
(5, 'What is the highest normal form commonly used?', 'MCQ', 'medium', 18),
(6, 'A foreign key can contain duplicate values', 'True_False', 'medium', 19),
(7, 'Which JOIN returns all records from left table?', 'MCQ', 'medium', 22),
(8, 'NULL represents zero in database', 'True_False', 'easy', 26),
(9, 'What does DDL stand for?', 'MCQ', 'hard', 27),
(10, 'Which key ensures uniqueness in a table?', 'MCQ', 'easy', 31);

SET IDENTITY_INSERT question OFF;

-- 15. Link Questions to Choices
INSERT INTO question_choise_bridge (question_id, choice_id) VALUES
-- Question 1
(1, 1), (1, 2), (1, 3), (1, 4),
-- Question 2
(2, 5), (2, 6), (2, 7), (2, 8),
-- Question 3
(3, 9), (3, 10),
-- Question 4
(4, 11), (4, 12), (4, 13), (4, 14),
-- Question 5
(5, 15), (5, 16), (5, 17), (5, 18),
-- Question 6
(6, 19), (6, 20),
-- Question 7
(7, 21), (7, 22), (7, 23), (7, 24),
-- Question 8
(8, 25), (8, 26),
-- Question 9
(9, 27), (9, 28), (9, 29), (9, 30),
-- Question 10
(10, 31), (10, 32), (10, 33), (10, 34);

-- 16. Link Questions to Course and Topics
INSERT INTO course_questions_on_topic (course_id, question_id, topic_id) VALUES
(1, 1, 1),  -- SQL Basics
(1, 2, 1),  -- SQL Basics
(1, 3, 3),  -- Normalization
(1, 4, 1),  -- SQL Basics
(1, 5, 3),  -- Normalization
(1, 6, 2),  -- Database Design
(1, 7, 1),  -- SQL Basics
(1, 8, 1),  -- SQL Basics
(1, 9, 1),  -- SQL Basics
(1, 10, 2); -- Database Design

-- 17. Add Questions to Exam
INSERT INTO exam_questions (exam_id, questoin_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(1, 6), (1, 7), (1, 8), (1, 9), (1, 10);

-- 18. Record Instructor Generated the Exam
INSERT INTO instructor_generate_course_exam (instructor_id, exam_id, course_id, genrate_date) VALUES
(2, 1, 1, '2026-01-01 09:00:00');

-- 19. Student Takes the Exam (Record in student_exam)
INSERT INTO student_exam (student_id, exam_id, state, exam_date, grade) VALUES
(1, 1, 'Submitted', '2026-01-05 10:00:00', 7);

-- 20. Student's Answers
INSERT INTO student_answer_question (student_id, exam_id, quesiotn_id, student_answer, answer_date) VALUES
(1, 1, 1, '1', '2026-01-05 10:05:00'),   -- Correct: Primary Key
(1, 1, 2, '5', '2026-01-05 10:08:00'),   -- Correct: SQL = Structured Query Language
(1, 1, 3, '9', '2026-01-05 10:10:00'),   -- Correct: True
(1, 1, 4, '11', '2026-01-05 10:12:00'),  -- Correct: SELECT
(1, 1, 5, '17', '2026-01-05 10:15:00'),  -- Wrong: Answered 3NF, correct is BCNF
(1, 1, 6, '19', '2026-01-05 10:18:00'),  -- Correct: True
(1, 1, 7, '21', '2026-01-05 10:22:00'),  -- Wrong: Answered INNER JOIN, correct is LEFT JOIN
(1, 1, 8, '26', '2026-01-05 10:25:00'),  -- Correct: False
(1, 1, 9, '27', '2026-01-05 10:30:00'),  -- Correct: Data Definition Language
(1, 1, 10, '31', '2026-01-05 10:35:00'); -- Correct: Primary Key

-- =============================================
-- TEST THE STORED PROCEDURE
-- =============================================

PRINT '==============================================';
PRINT 'Test Data Inserted Successfully!';
PRINT '==============================================';
PRINT 'Student ID: 1';
PRINT 'Student Name: Ahmed Hassan';
PRINT 'Exam ID: 1';
PRINT 'Exam Title: Database Midterm Exam';
PRINT 'Student Score: 7 / 10';
PRINT '==============================================';
PRINT '';
PRINT 'Execute the stored procedure with:';
PRINT 'EXEC sp_GetExamForStudent @student_id = 1, @exam_id = 1;';
PRINT '==============================================';

-- Uncomment to run the test immediately
-- EXEC sp_GetExamForStudent @student_id = 1, @exam_id = 1;
