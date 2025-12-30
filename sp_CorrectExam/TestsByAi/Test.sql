---------------------------------------1-------------------------------


DECLARE @ExamID INT = (SELECT MAX(exam_id) FROM exam);
DECLARE @StudentID INT = (SELECT MAX(student_id) FROM student);

EXEC CorrectExam @exam_id = @ExamID, @student_id = @StudentID;

-- Verify the grade was updated in student_exam
SELECT student_id, exam_id, grade FROM student_exam 
WHERE student_id = @StudentID AND exam_id = @ExamID;


---------------------------------------2-------------------------------

BEGIN TRY
    -- Using a fake Student ID (999)
    EXEC CorrectExam @exam_id = 1, @student_id = 999;
END TRY
BEGIN CATCH
    SELECT 'Test Case 2 Passed' AS Test, ERROR_MESSAGE() AS ErrorMsg;
END CATCH

---------------------------------------3-------------------------------

UPDATE student_answer_question 
SET student_answer = '999' 
WHERE student_id = (SELECT MAX(student_id) FROM student);

DECLARE @ExamID INT = (SELECT MAX(exam_id) FROM exam);
DECLARE @StudentID INT = (SELECT MAX(student_id) FROM student);

EXEC CorrectExam @exam_id = @ExamID, @student_id = @StudentID;