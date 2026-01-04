Title: Get Question With Choices Pivoted

**User Story:**
As an instructor or report generator, I want to retrieve questions with all their choices displayed in a single row format, so I can easily generate reports where each question and its choices appear together.

**Basic Flow:**
1. Call `GetQuestionWithChoicesPivoted` with a Question ID (for single question) OR call `GetAllQuestionsWithChoicesPivoted` for all questions.
2. System validates the Question ID exists (for single question procedure).
3. System returns the question data with choices pivoted into columns:
   - QuestionID
   - QuestionText
   - QuestionType (MCQ or True_False)
   - Difficulty (hard, medium, easy)
   - CorrectAnswerID
   - Choice1_ID, Choice1_Text
   - Choice2_ID, Choice2_Text
   - Choice3_ID, Choice3_Text (NULL for True/False)
   - Choice4_ID, Choice4_Text (NULL for True/False)

**Example Output Format:**

| QuestionID | QuestionText | QuestionType | Choice1_Text | Choice2_Text | Choice3_Text | Choice4_Text |
|------------|--------------|--------------|--------------|--------------|--------------|--------------|
| 1 | What is 2+2? | MCQ | 3 | 4 | 5 | 6 |
| 2 | Is SQL a programming language? | True_False | True | False | NULL | NULL |

**Procedures:**
- `GetQuestionWithChoicesPivoted(@QuestionID INT)` - Returns single question with choices
- `GetAllQuestionsWithChoicesPivoted` - Returns all questions with choices

**Return Codes (for GetQuestionWithChoicesPivoted):**
- `0` : Success
- `-1` : QuestionID is NULL
- `-2` : Question not found

**Notes:**
- MCQ questions will have all 4 choice columns populated
- True/False questions will only have Choice1 and Choice2 populated (True and False)
- Choice3 and Choice4 will be NULL for True/False questions
- Choices are ordered by choice_id to ensure consistent ordering
