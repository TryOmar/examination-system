Title: Get Exam Questions With Choices Pivoted

**User Story:**
As an instructor or report generator, I want to retrieve all questions for a specific exam with their choices displayed in a single row format, so I can easily generate exam papers and reports where each question and its choices appear together.

**Basic Flow:**
1. Call `GetExamQuestionsWithChoicesPivoted` with an Exam ID.
2. System validates the Exam ID exists.
3. System returns all questions for that exam with choices pivoted into columns:
   - ExamID
   - ExamTitle
   - QuestionID
   - QuestionText
   - QuestionType (MCQ or True_False)
   - Difficulty (hard, medium, easy)
   - CorrectAnswerID
   - Choice1_ID, Choice1_Text
   - Choice2_ID, Choice2_Text
   - Choice3_ID, Choice3_Text (NULL for True/False)
   - Choice4_ID, Choice4_Text (NULL for True/False)

**Example Usage:**
```sql
EXEC GetExamQuestionsWithChoicesPivoted @ExamID = 1;
```

**Example Output Format:**

| ExamID | ExamTitle | QuestionID | QuestionText | QuestionType | Choice1_Text | Choice2_Text | Choice3_Text | Choice4_Text |
|--------|-----------|------------|--------------|--------------|--------------|--------------|--------------|--------------|
| 1 | Final Exam | 1 | What is 2+2? | MCQ | 3 | 4 | 5 | 6 |
| 1 | Final Exam | 2 | Is SQL declarative? | True_False | True | False | NULL | NULL |
| 1 | Final Exam | 3 | What is a PK? | MCQ | Primary Key | Public Key | Private Key | Partition Key |

**Return Codes:**
- `0` : Success
- `-1` : ExamID is NULL
- `-2` : Exam not found

**Notes:**
- Results are ordered by QuestionID
- MCQ questions will have all 4 choice columns populated
- True/False questions will only have Choice1 and Choice2 populated
- Choices are ordered by choice_id for consistent ordering
- Useful for generating printable exam papers
