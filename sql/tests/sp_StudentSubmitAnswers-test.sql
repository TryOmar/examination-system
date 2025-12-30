---------------------------------------1-------------------------------



-- 1. Setup Table Variable
DECLARE @MyAnswers StudentAnswers;

-- 2. Dynamically get IDs by joining Student and Person
DECLARE @S_ID INT;
SELECT @S_ID = s.student_id 
FROM student s
JOIN person p ON s.student_id = p.person_id
WHERE p.first_name = 'Happy';

DECLARE @E_ID INT = (SELECT MAX(exam_id) FROM exam WHERE exam_title = 'Happy Exam');
DECLARE @AnsID INT = (SELECT MAX(choice_id) FROM quesiton_choice WHERE choice_text = 'Correct Ans');

-- 3. Populate Answers
-- We select the questions actually assigned to this exam
INSERT INTO @MyAnswers (question_id, student_answer)
SELECT questoin_id, @AnsID
FROM exam_questions 
WHERE exam_id = @E_ID;

-- 4. Execute the Submission
EXEC StudentSubmitAnswers 
    @student_id = @S_ID, 
    @exam_id = @E_ID, 
    @Answers = @MyAnswers;

-- 5. Final Verification
SELECT 
    p.first_name + ' ' + p.last_name AS StudentName,
    e.exam_title,
    se.grade,
    se.state
FROM student_exam se
JOIN person p ON se.student_id = p.person_id
JOIN exam e ON se.exam_id = e.exam_id
WHERE se.student_id = @S_ID;
---------------------------------------2-------------------------------

-- Create a Future Exam
INSERT INTO [exam] (exam_title, exam_date, duration_mins)
VALUES ('Future Exam', DATEADD(DAY, 1, GETDATE()), 60);
DECLARE @FutureEid INT = SCOPE_IDENTITY();

DECLARE @EmptyAnswers StudentAnswers;

BEGIN TRY
    EXEC StudentSubmitAnswers @student_id = 1, @exam_id = @FutureEid, @Answers = @EmptyAnswers;
END TRY
BEGIN CATCH
    SELECT 'Test Case 2 Passed' AS Test, ERROR_MESSAGE() AS Error; -- Expected: 'Exam is not currently active.'
END CATCH
---------------------------------------3-------------------------------

-- 1. Setup: Create a student but DO NOT enroll them in the course
INSERT INTO [person] (first_name, last_name) VALUES ('Stranger', 'Student');
DECLARE @StrangerId INT = SCOPE_IDENTITY();
INSERT INTO [student] (student_id) VALUES (@StrangerId);

-- 2. Define the answers
DECLARE @MyAnswers2 StudentAnswers;
INSERT INTO @MyAnswers2 (question_id, student_answer) VALUES (1, 1);

-- 3. FIX: Assign the Exam ID to a variable first
DECLARE @TargetExamID INT;
SELECT @TargetExamID = MAX(exam_id) 
FROM exam 
WHERE exam_title = 'Live Test Exam';

-- 4. Test Case Execution
BEGIN TRY
    EXEC StudentSubmitAnswers 
        @student_id = @StrangerId, 
        @exam_id = @TargetExamID,  -- Use the variable here
        @Answers = @MyAnswers2;
END TRY
BEGIN CATCH
    SELECT 'Test Case 3 Passed' AS Test, ERROR_MESSAGE() AS Error; 
    -- Expected: 'Student is not allowed to answer this exam.'
END CATCH

---------------------------------------4-------------------------------
-- 1. Create a question that is NOT on the exam
INSERT INTO [question] (question_text) VALUES ('Secret Question');
DECLARE @SecretQ INT = SCOPE_IDENTITY();

-- 2. Setup the cheating answers
DECLARE @CheatingAnswers StudentAnswers;
-- Using SELECT instead of VALUES to avoid compatibility syntax errors
INSERT INTO @CheatingAnswers (question_id, student_answer) 
SELECT @SecretQ, 1;

-- 3. FIX: Retrieve IDs into variables FIRST
DECLARE @TesterStudentId INT;
SELECT @TesterStudentId = s.student_id 
FROM student s
JOIN person p ON s.student_id = p.person_id 
WHERE p.first_name = 'Tester';

DECLARE @LiveExamId INT;
SELECT @LiveExamId = MAX(exam_id) 
FROM exam 
WHERE exam_title = 'Live Test Exam';

-- 4. Execute the test
BEGIN TRY
    EXEC StudentSubmitAnswers 
        @student_id = @TesterStudentId, 
        @exam_id = @LiveExamId, 
        @Answers = @CheatingAnswers;
END TRY
BEGIN CATCH
    SELECT 'Test Case 4 Passed' AS Test, ERROR_MESSAGE() AS Error; 
    -- Expected: 'One or more questions do not belong to this exam.'
END CATCH