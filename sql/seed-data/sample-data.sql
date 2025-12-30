

-- 3️⃣ Insert Courses
INSERT INTO courses (course_code, description, course_title, credits)
VALUES
(101, 'Introduction to Programming', 'CS101', '3'),
(102, 'Data Structures', 'CS102', '3'),
(103, 'Databases', 'CS103', '3');

-- 4️⃣ Insert Topics
INSERT INTO topic (topic_order, topic_duration, topic_title)
VALUES
(1, '2 hours', 'Variables and Data Types'),
(2, '3 hours', 'Control Structures'),
(3, '2 hours', 'Loops'),
(4, '3 hours', 'Arrays and Lists'),
(5, '2 hours', 'SQL Basics');

-- 5️⃣ Insert Questions
-- MCQs
INSERT INTO question (question_text, question_type, question_difficulty)
VALUES
('What is a variable?', 'MCQ', 'easy'),
('Which of these is a loop?', 'MCQ', 'medium'),
('What is SQL used for?', 'MCQ', 'easy'),
('What is an array?', 'MCQ', 'medium'),
('Which is a conditional statement?', 'MCQ', 'easy');

-- True/False
INSERT INTO question (question_text, question_type, question_difficulty)
VALUES
('A variable can store multiple types at once.', 'True_False', 'medium'),
('SQL can create databases.', 'True_False', 'easy'),
('Loops always execute at least once.', 'True_False', 'medium'),
('Arrays are dynamic by default.', 'True_False', 'hard'),
('If statements are conditional.', 'True_False', 'easy');

-- 6️⃣ Insert course_questions_on_topic
-- Use actual inserted IDs with SCOPE_IDENTITY() if needed; here assuming empty DB
INSERT INTO course_questions_on_topic (course_id, question_id, topic_id)
VALUES
-- CS101
(1, 1, 1),
(1, 2, 2),
(1, 6, 1),
(1, 7, 2),

-- CS102
(2, 3, 5),
(2, 4, 4),
(2, 8, 3),
(2, 9, 4),

-- CS103
(3, 5, 2),
(3, 10, 5);


-- 1. Create the Person first
INSERT INTO [person] (first_name, last_name, email) 
VALUES ('Test', 'Instructor', 'instructor@example.com');

-- Get the ID that was just generated
DECLARE @NewID INT = SCOPE_IDENTITY();

-- 2. Create the Instructor using that same ID
-- (Note: your instructor table doesn't use IDENTITY, it uses the Person ID)
INSERT INTO [instructor] (instructor_id, hire_date) 
VALUES (@NewID, '2024-01-01');

-- 3. Now link them to the Course (This was the line that failed)
-- Replace '1' with your course_id if different
INSERT INTO [instructor_course] (instructor_id, course_id) 
VALUES (@NewID, 1);

-- IMPORTANT: Note this ID for your SP test
PRINT 'Use this Instructor ID in your EXEC statement: ' + CAST(@NewID AS VARCHAR(10));