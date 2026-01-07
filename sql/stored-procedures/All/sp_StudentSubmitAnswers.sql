CREATE TYPE StudentAnswers AS TABLE
(
    student_answer INT,
    question_id INT
);
GO
CREATE PROCEDURE StudentSubmitAnswers
(
    @student_id INT,
    @exam_id INT,
    @Answers StudentAnswers READONLY
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

  
        DECLARE @course_id INT;

        SELECT @course_id = course_id
        FROM instructor_generate_course_exam
        WHERE exam_id = @exam_id;

        IF @course_id IS NULL
       BEGIN
           THROW 50001, 'Student is not allowed to answer this exam.', 1;
       END;

        IF NOT EXISTS
        (
            SELECT 1
            FROM student_course
            WHERE student_id = @student_id
              AND course_id = @course_id
        )
        BEGIN
            THROW 50001, 'Student is not allowed to answer this exam.', 1;
        END;


        IF NOT EXISTS
        (
            SELECT 1
            FROM Exam
            WHERE exam_id = @exam_id
              AND GETDATE() BETWEEN exam_date
              AND DATEADD(MINUTE, duration_mins, exam_date)
        )
        BEGIN
            THROW 50002, 'Exam is not currently active.', 1;
        END;


        IF NOT EXISTS
        (
            SELECT 1
            FROM student_exam
            WHERE student_id = @student_id
              AND exam_id = @exam_id
        )
        BEGIN
            INSERT INTO student_exam
            (
                student_id,
                exam_id,
                state,
                grade
            )
            VALUES
            (
                @student_id,
                @exam_id,
                'Submitted',
                NULL
            );
        END;


        IF EXISTS
        (
            SELECT 1
            FROM @Answers a
            LEFT JOIN Exam_Questions eq
                ON eq.questoin_id = a.question_id
               AND eq.exam_id = @exam_id
            WHERE eq.questoin_id IS NULL
        )
        BEGIN
            THROW 50003, 'One or more questions do not belong to this exam.', 1;
        END;


        INSERT INTO student_answer_question
        (
            student_id,
            exam_id,
            quesiotn_id,
            student_answer
        )
        SELECT
            @student_id,
            @exam_id,
            a.question_id,
            a.student_answer
        FROM @Answers a
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM student_answer_question sa
            WHERE sa.student_id = @student_id
              AND sa.exam_id = @exam_id
              AND sa.quesiotn_id = a.question_id
        );

        EXEC CorrectExam @exam_id,@student_id; 
        COMMIT TRANSACTION;

        SELECT 'Answers saved successfully' AS Result;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
