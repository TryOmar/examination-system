Title: Delete Question

User Story:
As an instructor or admin, I want to delete a question from the question bank so that outdated or incorrect questions are removed.

Flow:
1. Open the question list or question detail page.
2. Select the question to delete (by Question ID or using the UI item).
3. System validates the Question ID is provided and exists. If not, show "Question not found.".
4. Prompt user to confirm deletion: warn that all linked choices (bridges) will be removed.
5. On confirm, system begins a transaction to:
   - Delete all entries in the question-choice bridge for that question.
   - Delete the question record itself.
6. If the operation succeeds, commit transaction and show success message; if any error occurs, rollback and show an error message.

Acceptance Criteria:
- Deleting a question removes its bridge records and the question record atomically.
- Appropriate error messages shown for missing ID or database errors.