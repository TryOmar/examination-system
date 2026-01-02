Title: Update Question

User Story:
As an instructor I want to update a question’s text or difficulty so I can correct or reclassify questions without recreating them.

Flow:
1. Open the question edit form for a specific Question ID.
2. Modify the question text and/or the difficulty field (one or both).
3. System validates that Question ID is present and that at least one field (text or difficulty) is being updated.
4. If question text is provided, ensure it is not empty after trimming. If difficulty is provided, ensure it is one of the allowed values ('easy','medium','hard').
5. Verify the question exists; if not, show "Question not found.".
6. Apply the update to only the provided fields in a single atomic update.
7. On success, return a success response; on error, show an appropriate message.

Acceptance Criteria:
- Supports partial updates (only text, only difficulty, or both).
- Validates input and rejects invalid difficulty or empty text.