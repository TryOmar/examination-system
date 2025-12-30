-- 1. Create Base Tables with IDENTITY PKs

CREATE TABLE [branch] (
  [branch_id] int IDENTITY(1,1) PRIMARY KEY,
  [branch_name] varchar(255),
  [branch_city] varchar(255)
);

CREATE TABLE [department] (
  [department_id] int IDENTITY(1,1) PRIMARY KEY,
  [department_name] varchar(255)
);

CREATE TABLE [courses] (
  [course_id] int IDENTITY(1,1) PRIMARY KEY,
  [course_code] integer,
  [description] varchar(255),
  [course_title] varchar(255),
  [credits] varchar(255)
);

CREATE TABLE [topic] (
  [topic_id] int IDENTITY(1,1) PRIMARY KEY,
  [topic_order] int,
  [topic_dration] varchar(255),
  [topic_title] varchar(255)
);

CREATE TABLE [exam] (
  [exam_id] int IDENTITY(1,1) PRIMARY KEY,
  [exam_title] varchar(255),
  [total_grade] int,
  [exam_date] datetime,
  [exam_type] varchar(50) CHECK ([exam_type] IN ('final', 'mid', 'semifinal')),
  [duration_mins] int
);

CREATE TABLE [quesiton_choice] (
  [choice_id] int IDENTITY(1,1) PRIMARY KEY,
  [choice_text] varchar(255)
);

CREATE TABLE [question] (
  [question_id] int IDENTITY(1,1) PRIMARY KEY,
  [question_text] varchar(255),
  [question_type] varchar(50) CHECK ([question_type] IN ('MCQ', 'True_False')),
  [question_difficulty] varchar(50) CHECK ([question_difficulty] IN ('hard', 'medium', 'easy')),
  [correct_ans_id] int
);

CREATE TABLE [person] (
  [person_id] int IDENTITY(1,1) PRIMARY KEY,
  [first_name] varchar(255),
  [last_name] varchar(255),
  [email] varchar(255)
);

-- Note: student and instructor PKs reference person_id, 
-- so they usually do NOT use IDENTITY; they inherit the ID from Person.
CREATE TABLE [student] (
  [student_id] int PRIMARY KEY
);

CREATE TABLE [instructor] (
  [instructor_id] int PRIMARY KEY,
  [hire_date] date
);

-- 2. Relation and Ternary Tables (Composite PKs)

CREATE TABLE [branch_department] (
  [branch_id] int,
  [department_id] int,
  PRIMARY KEY ([branch_id], [department_id])
);

CREATE TABLE [department_courses] (
  [course_id] int,
  [department_id] int,
  PRIMARY KEY ([course_id], [department_id])
);

CREATE TABLE [exam_questions] (
  [exam_id] int,
  [questoin_id] int,
  PRIMARY KEY ([exam_id], [questoin_id])
);

CREATE TABLE [question_choise_bridge] (
  [question_id] int,
  [choice_id] int,
  PRIMARY KEY ([question_id], [choice_id])
);

CREATE TABLE [student_exam] (
  [student_id] int,
  [exam_id] int,
  [state] varchar(255),
  [exam_date] datetime,
  [grade] int,
  PRIMARY KEY ([student_id], [exam_id])
);

CREATE TABLE [student_course] (
  [student_id] int,
  [course_id] int,
  [enrollment_date] datetime,
  PRIMARY KEY ([student_id], [course_id])
);

CREATE TABLE [instructor_course] (
  [instructor_id] int,
  [course_id] int,
  PRIMARY KEY ([instructor_id], [course_id])
);

CREATE TABLE [person_jong_department_branch] (
  [person_id] int,
  [branch_id] int,
  [department_id] int,
  [join_date] datetime,
  PRIMARY KEY ([person_id], [join_date])
);

CREATE TABLE [instructor_generate_course_exam] (
  [instructor_id] int,
  [exam_id] int,
  [course_id] int,
  [genrate_date] datetime,
  PRIMARY KEY ([instructor_id], [course_id], [genrate_date])
);

CREATE TABLE [course_questions_on_topic] (
  [course_id] int,
  [question_id] int,
  [topic_id] int,
  PRIMARY KEY ([course_id], [question_id], [topic_id])
);

CREATE TABLE [student_answer_question] (
  [student_id] int,
  [exam_id] int,
  [quesiotn_id] int,
  [student_answer] varchar(255),
  [answer_date] datetime,
  PRIMARY KEY ([student_id], [quesiotn_id], [answer_date])
);

-- 3. Foreign Key Constraints

ALTER TABLE [branch_department] ADD FOREIGN KEY ([branch_id]) REFERENCES [branch] ([branch_id]);
ALTER TABLE [branch_department] ADD FOREIGN KEY ([department_id]) REFERENCES [department] ([department_id]);

ALTER TABLE [department_courses] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([course_id]);
ALTER TABLE [department_courses] ADD FOREIGN KEY ([department_id]) REFERENCES [department] ([department_id]);

ALTER TABLE [question] ADD FOREIGN KEY ([correct_ans_id]) REFERENCES [quesiton_choice] ([choice_id]);

ALTER TABLE [exam_questions] ADD FOREIGN KEY ([exam_id]) REFERENCES [exam] ([exam_id]);
ALTER TABLE [exam_questions] ADD FOREIGN KEY ([questoin_id]) REFERENCES [question] ([question_id]);

ALTER TABLE [question_choise_bridge] ADD FOREIGN KEY ([question_id]) REFERENCES [question] ([question_id]);
ALTER TABLE [question_choise_bridge] ADD FOREIGN KEY ([choice_id]) REFERENCES [quesiton_choice] ([choice_id]);

ALTER TABLE [student] ADD FOREIGN KEY ([student_id]) REFERENCES [person] ([person_id]);
ALTER TABLE [instructor] ADD FOREIGN KEY ([instructor_id]) REFERENCES [person] ([person_id]);

ALTER TABLE [student_exam] ADD FOREIGN KEY ([student_id]) REFERENCES [student] ([student_id]);
ALTER TABLE [student_exam] ADD FOREIGN KEY ([exam_id]) REFERENCES [exam] ([exam_id]);

ALTER TABLE [student_course] ADD FOREIGN KEY ([student_id]) REFERENCES [student] ([student_id]);
ALTER TABLE [student_course] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([course_id]);

ALTER TABLE [instructor_course] ADD FOREIGN KEY ([instructor_id]) REFERENCES [instructor] ([instructor_id]);
ALTER TABLE [instructor_course] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([course_id]);

ALTER TABLE [person_jong_department_branch] ADD FOREIGN KEY ([person_id]) REFERENCES [person] ([person_id]);
ALTER TABLE [person_jong_department_branch] ADD FOREIGN KEY ([branch_id]) REFERENCES [branch] ([branch_id]);
ALTER TABLE [person_jong_department_branch] ADD FOREIGN KEY ([department_id]) REFERENCES [department] ([department_id]);

ALTER TABLE [instructor_generate_course_exam] ADD FOREIGN KEY ([instructor_id]) REFERENCES [instructor] ([instructor_id]);
ALTER TABLE [instructor_generate_course_exam] ADD FOREIGN KEY ([exam_id]) REFERENCES [exam] ([exam_id]);
ALTER TABLE [instructor_generate_course_exam] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([course_id]);

ALTER TABLE [course_questions_on_topic] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([course_id]);
ALTER TABLE [course_questions_on_topic] ADD FOREIGN KEY ([question_id]) REFERENCES [question] ([question_id]);
ALTER TABLE [course_questions_on_topic] ADD FOREIGN KEY ([topic_id]) REFERENCES [topic] ([topic_id]);

ALTER TABLE [student_answer_question] ADD FOREIGN KEY ([student_id]) REFERENCES [student] ([student_id]);
ALTER TABLE [student_answer_question] ADD FOREIGN KEY ([exam_id]) REFERENCES [exam] ([exam_id]);
ALTER TABLE [student_answer_question] ADD FOREIGN KEY ([quesiotn_id]) REFERENCES [question] ([question_id]);