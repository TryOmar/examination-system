Title: Insert Question

User Story:
As an instructor or content manager, I want to create a new question (specifying text, type and difficulty) so it can be used in exams.

Flow:
1. Open the "Add Question" form.
2. Enter question text, select question type (e.g., MCQ, True_False), and choose difficulty (easy, medium, hard).
3. System validates required fields: non-empty question text, question type, and difficulty. If any is missing, show a descriptive validation message.
4. On success, system inserts the question with a NULL correct_ans_id and returns the new Question ID and a success message.
5. UI can navigate to add choices for this new question or return to the question list.

Acceptance Criteria:
- Returns the new Question ID and a success status on creation.
- Provides meaningful error messages when creation fails.