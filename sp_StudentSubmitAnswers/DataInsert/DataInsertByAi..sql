-- 1. Create a Course and a Student
INSERT INTO [courses] (course_code, course_title) VALUES (999, 'Testing 101');
DECLARE @Cid INT = SCOPE_IDENTITY();

INSERT INTO [person] (first_name, last_name, email) VALUES ('Tester', 'Student', 'test@exam.com');
DECLARE @Sid INT = SCOPE_IDENTITY();
INSERT INTO [student] (student_id) VALUES (@Sid);

-- 2. ENROLL the student in the course (Crucial for validation)
INSERT INTO [student_course] (student_id, course_id) VALUES (@Sid, @Cid);

-- 3. Create an EXAM that is currently ACTIVE (starts 5 mins ago, lasts 60 mins)
INSERT INTO [exam] (exam_title, exam_date, duration_mins, exam_type, total_grade)
VALUES ('Live Test Exam', DATEADD(MINUTE, -5, GETDATE()), 60, 'mid', 1);
DECLARE @Eid INT = SCOPE_IDENTITY();

-- 4. Assign an Instructor to generate it (Needed for your @course_id lookup)
-- (Assuming Instructor ID 1 exists from previous steps)
INSERT INTO [instructor_generate_course_exam] (instructor_id, course_id, exam_id, genrate_date)
VALUES (1, @Cid, @Eid, GETDATE());

-- 5. Add a Question to the Question Bank and link it to the Exam
INSERT INTO [question] (question_text, question_type, correct_ans_id) VALUES ('Is SQL fun?', 'MCQ', 1);
DECLARE @Qid INT = SCOPE_IDENTITY();
INSERT INTO [exam_questions] (exam_id, questoin_id) VALUES (@Eid, @Qid);

SELECT @Sid AS StudentID, @Eid AS ExamID, @Qid AS QuestionID;