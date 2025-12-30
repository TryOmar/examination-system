------------------------------1-------------------------------------------
DECLARE @Items QuestionsGroupNum;
-- Requesting 3 questions that we know exist from your data
INSERT INTO @Items VALUES (1, 'MCQ', 2), (3, 'True_False', 1); 

-- Total grade must be 3 because you have 3 questions total
EXEC GenerateExam 
    @Items = @Items, 
    @course_id = 1, 
    @exam_title = 'Success Test Exam', 
    @exam_date = '2025-12-30', 
    @duration_mins = 60, 
    @total_grade = 3.0, 
    @instructor_id = 1; -- Use the ValidInstructorID from step 1

-- Verification
SELECT * FROM exam WHERE exam_title = 'Success Test Exam';
SELECT * FROM instructor_generate_course_exam WHERE course_id = 1;
select * from exam_questions;



------------------------------2-------------------------------------------
DECLARE @Items QuestionsGroupNum;
INSERT INTO @Items VALUES (1, 'MCQ', 1);

BEGIN TRY
    EXEC GenerateExam 
        @Items = @Items, 
        @course_id = 1, 
        @exam_title = 'Unauthorized Instructor', 
        @exam_date = '2025-12-30' , 
        @duration_mins = 60, 
        @total_grade = 1.0, 
        @instructor_id = 9999; -- ID that doesn't exist in instructor_course
END TRY
BEGIN CATCH
    SELECT 'Test Case 2 Passed' AS Test, ERROR_MESSAGE() AS CaughtError;
END CATCH


------------------------------3-------------------------------------------
DECLARE @Items QuestionsGroupNum;
INSERT INTO @Items VALUES (1, 'MCQ', 3); -- Requesting 100 questions (none exist)

BEGIN TRY
    EXEC GenerateExam 
        @Items = @Items, 
        @course_id = 1, 
        @exam_title = 'Too Many Questions', 
        @exam_date = '2025-12-30', 
        @duration_mins = 60, 
        @total_grade = 1, 
        @instructor_id = 1;
END TRY
BEGIN CATCH
    SELECT 'Test Case 3 Passed' AS Test, ERROR_MESSAGE() AS CaughtError;
END CATCH


------------------------------4-------------------------------------------
DECLARE @Items QuestionsGroupNum;
INSERT INTO @Items VALUES (1, 'MCQ', 5); -- Requested 5 questions

BEGIN TRY
    EXEC GenerateExam 
        @Items = @Items, 
        @course_id = 1, 
        @exam_title = 'Grade Mismatch', 
        @exam_date = '2025-12-30', 
        @duration_mins = 60, 
        @total_grade = 10.0, -- This mismatch triggers the 'not enough questions' error
        @instructor_id = 1;
END TRY
BEGIN CATCH
    SELECT 'Test Case 4 Passed' AS Test, ERROR_MESSAGE() AS CaughtError;
END CATCH