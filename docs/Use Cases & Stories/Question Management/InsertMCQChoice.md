Title: Insert MCQ Choice

User Story:
As an instructor adding options to an MCQ question, I want to insert a new choice and optionally mark it as correct, so the question reflects the new option.

Flow:
1. In the MCQ question edit screen, enter the new choice text and optionally check a "Correct" checkbox.
2. System validates the Question ID, choice text (non-empty), and IsCorrect flag.
3. System validates that the target question exists and is of type 'MCQ'. If not, show an error that the question is missing or of the wrong type.
4. On validation success, the system inserts the new choice and obtains its new Choice ID.
5. If the choice is marked correct, the system updates the question.correct_ans_id to the new choice ID.
6. The system creates a bridge entry linking the new choice to the question.
7. Return the new Choice ID (for UI to use) and show success; on error, show an appropriate error message.

Notes:
- Ensure trimming of input text. 
- Handle database errors gracefully and inform the user.