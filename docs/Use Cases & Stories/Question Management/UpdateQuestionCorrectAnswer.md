Title: Update Question Correct Answer

User Story:
As an instructor, I want to change the correct answer for a question so that the question's correct choice is accurate.

Flow:
1. In the question edit UI, choose or select a new correct choice for the given Question ID.
2. System validates the Question ID and NewCorrectChoiceID are provided.
3. System verifies the question exists and reads its question_type.
4. If the question is True_False, ensure the new choice ID is either 1 (True) or 2 (False); otherwise reject with a descriptive message.
5. If the question is MCQ, verify the new choice exists and is linked to this question via the bridge; otherwise reject.
6. If the question type is unknown, reject with an appropriate error.
7. On validation success, update question.correct_ans_id to the new choice ID and return success; on DB error, return an error.

Acceptance Criteria:
- Enforces type-specific validation (True/False vs MCQ).
- Prevents assigning choices that do not belong to the question for MCQs.