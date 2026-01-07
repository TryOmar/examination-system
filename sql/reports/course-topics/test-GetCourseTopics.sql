-- =============================================
-- Test Data Script for GetCourseTopics
-- Creates a course with multiple topics
-- =============================================

-- Clean up existing test data (optional - uncomment if needed)
-- DELETE FROM course_questions_on_topic WHERE course_id = 100;
-- DELETE FROM question WHERE question_id BETWEEN 1000 AND 1003;
-- DELETE FROM courses WHERE course_id = 100;
-- DELETE FROM topic WHERE topic_id BETWEEN 100 AND 103;

-- Enable IDENTITY_INSERT for test data
SET IDENTITY_INSERT courses ON;

-- 1. Insert Test Course
INSERT INTO courses (course_id, course_code, description, course_title, credits) VALUES
(100, 101, 'Introduction to Database Systems', 'Database Fundamentals', '3');

SET IDENTITY_INSERT courses OFF;

SET IDENTITY_INSERT topic ON;

-- 2. Insert Test Topics
INSERT INTO topic (topic_id, topic_order, topic_duration, topic_title) VALUES
(100, 1, '2 weeks', 'SQL Basics'),
(101, 2, '3 weeks', 'Database Design'),
(102, 3, '2 weeks', 'Normalization'),
(103, 4, '1 week', 'Transactions and Concurrency');

SET IDENTITY_INSERT topic OFF;

SET IDENTITY_INSERT quesiton_choice ON;

-- 3. Insert dummy choices (needed for questions)
INSERT INTO quesiton_choice (choice_id, choice_text) VALUES
(9001, 'Answer A'),
(9002, 'Answer B');

SET IDENTITY_INSERT quesiton_choice OFF;

SET IDENTITY_INSERT question ON;

-- 4. Insert Sample Questions (needed for the link)
INSERT INTO question (question_id, question_text, question_type, question_difficulty, correct_ans_id) VALUES
(1000, 'What is SQL?', 'MCQ', 'easy', 9001),
(1001, 'What is a Primary Key?', 'MCQ', 'easy', 9001),
(1002, 'What is 1NF?', 'MCQ', 'medium', 9001),
(1003, 'What is ACID?', 'MCQ', 'hard', 9001);

SET IDENTITY_INSERT question OFF;

-- 5. Link Topics to Course through Questions
INSERT INTO course_questions_on_topic (course_id, question_id, topic_id) VALUES
(100, 1000, 100),  -- SQL Basics
(100, 1001, 101),  -- Database Design
(100, 1002, 102),  -- Normalization
(100, 1003, 103);  -- Transactions

-- Add more questions to same topics to test DISTINCT functionality
-- (This ensures the procedure correctly returns each topic only once)
INSERT INTO course_questions_on_topic (course_id, question_id, topic_id) VALUES
(100, 1000, 101),  -- Another question for Database Design
(100, 1001, 100);  -- Another question for SQL Basics

-- =============================================
-- TEST THE STORED PROCEDURE
-- =============================================

PRINT '==============================================';
PRINT 'Test Data Inserted Successfully!';
PRINT '==============================================';
PRINT 'Course ID: 100';
PRINT 'Course Title: Database Fundamentals';
PRINT 'Total Topics: 4';
PRINT '==============================================';
PRINT '';
PRINT 'Execute the stored procedure with:';
PRINT 'EXEC GetCourseTopics @CourseID = 100;';
PRINT '==============================================';

-- Uncomment to run the test immediately
-- EXEC GetCourseTopics @CourseID = 100;

-- =============================================
-- TEST EDGE CASES
-- =============================================

PRINT '';
PRINT 'Test Edge Cases:';
PRINT '1. NULL CourseID:';
PRINT '   EXEC GetCourseTopics @CourseID = NULL;';
PRINT '   Expected: Error -1 (Course ID cannot be NULL)';
PRINT '';
PRINT '2. Non-existent Course:';
PRINT '   EXEC GetCourseTopics @CourseID = 99999;';
PRINT '   Expected: Error -2 (Course not found)';
PRINT '';
PRINT '3. Course with no topics:';
PRINT '   (Create a course without topics and test)';
PRINT '   Expected: Empty result set (not an error)';
PRINT '==============================================';

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

PRINT '';
PRINT 'Verification Queries:';
PRINT '';
PRINT '1. View inserted course:';
PRINT '   SELECT * FROM courses WHERE course_id = 100;';
PRINT '';
PRINT '2. View inserted topics:';
PRINT '   SELECT * FROM topic WHERE topic_id BETWEEN 100 AND 103;';
PRINT '';
PRINT '3. View course-topic links:';
PRINT '   SELECT * FROM course_questions_on_topic WHERE course_id = 100;';
PRINT '';
PRINT '4. Count distinct topics (should be 4):';
PRINT '   SELECT COUNT(DISTINCT topic_id) FROM course_questions_on_topic WHERE course_id = 100;';
PRINT '==============================================';
