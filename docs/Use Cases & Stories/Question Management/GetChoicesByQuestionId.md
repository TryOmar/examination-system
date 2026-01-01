Title: Get Choices By Question ID

User Story:
As an exam editor or UI consumer, I want to fetch the list of choices for a specific question so I can display them for review or editing.

Flow:
1. In the question detail or edit view, request choices for the current Question ID.
2. System validates the Question ID is provided and that the question exists. If not, return an appropriate error.
3. System returns a list of choice records (choice_id, choice_text) associated with the question via the question-choice bridge.
4. The UI renders the returned choices for display or editing.

Notes:
- This procedure is typically called internally by other procedures or APIs that need both question and choices.