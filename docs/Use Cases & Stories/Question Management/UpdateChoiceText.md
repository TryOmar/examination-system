Title: Update Choice Text

User Story:
As an instructor or content editor, I want to update the text of an existing choice so that choice content remains accurate and clear.

Flow:
1. Open the choice edit UI for a specific Choice ID (or from the question edit screen).
2. Enter the new choice text and submit the update.
3. System validates the Choice ID is provided and exists; validates the new text is not empty after trimming.
4. System checks that the choice is not one of the protected True/False choices (IDs 1 or 2). If protected, show error: "Cannot update True/False choices.".
5. On success, update the choice text in the choice table and return success; on DB error, return an error message.

Acceptance Criteria:
- Prevents updating protected choice IDs (1 and 2).
- Rejects empty or whitespace-only choice text.