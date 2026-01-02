Title: Get Question With Choices

User Story:
As an instructor or UI, I want to retrieve a question’s details together with its choices so I can display the full question for editing or preview.

Flow:
1. From the question list or detail view, request the full question (by Question ID).
2. System validates the Question ID is present and the question exists. If not, return an error.
3. System returns the question record (question_id, question_text, question_type, question_difficulty, correct_ans_id).
4. System executes the choices retrieval (GetChoicesByQuestionId) to return the associated choices.
5. The UI presents the combined result: question metadata and its choices.

Acceptance Criteria:
- Returns both question info and choice list in a single flow.
- Validates missing or invalid Question ID and returns descriptive errors.