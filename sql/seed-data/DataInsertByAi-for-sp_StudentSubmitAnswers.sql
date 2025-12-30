-- 1. Create a Choice
INSERT INTO [quesiton_choice] (choice_text) VALUES ('Choice A'); -- Will likely be ID 1
DECLARE @ChoiceA INT = SCOPE_IDENTITY();

-- 2. Create a Question where 'Choice A' is correct
INSERT INTO [question] (question_text, question_type, question_difficulty, correct_ans_id) 
VALUES ('What is SQL?', 'MCQ', 'easy', @ChoiceA);
DECLARE @Qid INT = SCOPE_IDENTITY();

-- 3. Create an Exam worth 1 point
INSERT INTO [exam] (exam_title, total_grade, exam_date, exam_type, duration_mins)
VALUES ('Correction Test Exam', 1, GETDATE(), 'mid', 30);
DECLARE @Eid INT = SCOPE_IDENTITY();

-- 4. Create a Student
INSERT INTO [person] (first_name, last_name, email) VALUES ('Jane', 'Doe', 'jane@test.com');
DECLARE @Sid INT = SCOPE_IDENTITY();
INSERT INTO [student] (student_id) VALUES (@Sid);

-- 5. Enroll student in the exam (Status: Submitted)
INSERT INTO [student_exam] (student_id, exam_id, state, exam_date, grade)
VALUES (@Sid, @Eid, 'Submitted', GETDATE(), NULL);

-- 6. Record Student Answer (Correct Answer)
-- Note: Using your typo 'quesiotn_id' from your schema
INSERT INTO [student_answer_question] (student_id, exam_id, quesiotn_id, student_answer, answer_date)
VALUES (@Sid, @Eid, @Qid, CAST(@ChoiceA AS VARCHAR(255)), GETDATE());

-- Show generated IDs for testing
SELECT @Eid AS TestExamID, @Sid AS TestStudentID, @ChoiceA AS CorrectChoiceID;