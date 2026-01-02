Title: Insert True/False Choices

User Story:
As an instructor creating a True/False question, I want the system to create the two standard choices (True and False) and mark which one is correct.

Flow:
1. When adding or editing a True/False question, select whether True or False is the correct answer.
2. System validates the Question ID and that the question exists and is of type 'True_False'. If not, show an error.
3. System determines the correct choice ID (1 for True, 2 for False), updates question.correct_ans_id accordingly.
4. System ensures the bridge entries linking the question to choice IDs 1 and 2 exist (inserts them if needed).
5. On success, show confirmation that True/False choices were added and indicate which is correct.

Notes:
- IDs 1 and 2 are reserved for True/False choices; the UI should not allow deleting or renaming them.