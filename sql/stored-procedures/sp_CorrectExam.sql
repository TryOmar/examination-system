CREATE PROCEDURE CorrectExam
(
    @exam_id INT,
    @student_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS
        (
            SELECT 1
            FROM student_exam
            WHERE exam_id = @exam_id
              AND student_id = @student_id
        )
        BEGIN
            THROW 50001, 'Student has not submitted this exam.', 1;
        END;

         IF EXISTS
        (
            SELECT 1
            FROM student_exam
            WHERE exam_id = @exam_id
              AND student_id = @student_id
              AND grade IS NOT NULL
              AND state = 'Graded'
        )
        BEGIN
            THROW 50002, 'Exam already corrected for this student.', 1;
        END;

        DECLARE @total_grade INT;

        SELECT @total_grade = e.total_grade
        FROM Exam e
        WHERE exam_id = @exam_id;

        DECLARE @correct_answers INT;

        SELECT @correct_answers = COUNT(*)
        FROM student_answer_question sa
        INNER JOIN question q
            ON sa.quesiotn_id = q.question_id
        WHERE sa.exam_id = @exam_id
          AND sa.student_id = @student_id
          AND sa.student_answer = q.correct_ans_id;

        DECLARE @final_score DECIMAL(5,2);

        SET @final_score =
            CAST(@correct_answers AS DECIMAL(5,2)) / @total_grade * 100;

        UPDATE student_exam
        SET grade = @final_score
        , state = 'Graded'
        WHERE exam_id = @exam_id
        AND student_id = @student_id


        COMMIT TRANSACTION;

        SELECT
            @exam_id AS exam_id,
            @student_id AS student_id,
            @total_grade AS total_questions,
            @correct_answers AS correct_answers,
            @final_score AS final_score;

        RETURN @final_score;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
