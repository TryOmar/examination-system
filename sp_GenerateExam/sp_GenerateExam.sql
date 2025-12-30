CREATE TYPE QuestionsGroupNum AS TABLE
(
    topic_id INT,
    question_type VARCHAR(50),
    questions_num INT
);

CREATE PROCEDURE sp_GenerateExam
(
    @Items QuestionsGroupNum READONLY,
    @course_id INT,
    @exam_title NVARCHAR(200),
    @exam_date DATETIME,
    @duration_mins INT,
    @total_grade DECIMAL(5,2),
    @instructor_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY


        BEGIN TRANSACTION;
        
        DECLARE @sum INT
        SELECT @sum = SUM(i.questions_num)
        FROM @Items i;

        IF @sum <> @total_grade
        BEGIN
            THROW 50001, 'Total grad not equal to number of questions', 1;
        END;


        DECLARE @count INT;

        SELECT @count = COUNT(*)
        FROM instructor_course
        WHERE instructor_id = @instructor_id and course_id = @course_id;

        IF @count = 0
        BEGIN
            THROW 50001, 'Instructor is not assigned to any course.', 1;
        END;



        DECLARE @exam_id INT;

        INSERT INTO Exam
        (
            exam_title,
            exam_date,
            duration_mins,
            total_grade
        )
        VALUES
        (
            @exam_title,
            @exam_date,
            @duration_mins,
            @total_grade
        );

        SET @exam_id = SCOPE_IDENTITY();

        INSERT INTO Exam_Questions (exam_id, questoin_id)
        SELECT
            @exam_id,
            q.question_id
        FROM @Items i
        CROSS APPLY
        (
            SELECT TOP (i.questions_num) q.question_id
            FROM question q
            INNER JOIN course_questions_on_topic cqt
                ON q.question_id = cqt.question_id
            WHERE
                cqt.course_id = @course_id
                AND cqt.topic_id = i.topic_id
                AND q.question_type = i.question_type
            ORDER BY NEWID()
        ) q;

        DECLARE @InsertedQuestions INT = @@ROWCOUNT;

        IF @InsertedQuestions <> @total_grade
        BEGIN
            THROW 50001, 'There are not enough questions to fulfill the exam.', 1;
        END;



        INSERT INTO instructor_generate_course_exam
        (
            instructor_id,
            course_id,
            exam_id,
            genrate_date
        )
        VALUES
        (
            @instructor_id,
            @course_id,
            @exam_id,
            GETDATE()
        );

        COMMIT TRANSACTION;
        return @exam_id ;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO




