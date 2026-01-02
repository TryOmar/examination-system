Title: Delete Choice

User Story:
As an instructor or content manager, I want to delete a specific choice so that obsolete or incorrect options are removed from the question bank.

Flow:
1. Open the question editor or choice management view.
2. Locate and select the choice to delete (by Choice ID or from the choice list under a question).
3. System validates the selected Choice ID is present and not NULL.
4. System checks that the choice is not a protected True/False choice (IDs 1 and 2). If it is, show an error: "Cannot delete True/False choices.".
5. System verifies the choice exists in the database. If not found, show "Choice not found.".
6. Prompt the user for confirmation: "Delete choice and remove references?" with Cancel/Confirm.
7. On confirm, system begins deletion: 
   - Clear any question.correct_ans_id values that reference this choice.
   - Remove the choice-to-question bridge entries.
   - Delete the choice record itself.
8. On success, show a success message and refresh the question/choices list. On failure, show a database error message and keep the data consistent.

Notes:
- Show clear warnings about breaking references and affecting any question that used this choice as the correct answer.