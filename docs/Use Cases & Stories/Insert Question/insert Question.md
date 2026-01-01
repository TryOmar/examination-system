# Question Management System – Complete Documentation & User Story

## Overview
This system allows admins to create two types of questions: MCQ (Multiple Choice Questions) with 4 choices (one correct) and True/False questions with pre-defined choices (ID 1 = True, ID 2 = False).  
Frontend (JSON) → Backend (.NET) → Database (SQL Server).

## Frontend JSON Examples
```
MCQ Question:
{
  "question": {
    "text": "What is 2 + 2?",
    "type": "MCQ",
    "difficulty": "easy"
  },
  "choices": [
    { "text": "3", "is_correct": false },
    { "text": "4", "is_correct": true },
    { "text": "5", "is_correct": false },
    { "text": "6", "is_correct": false }
  ]
}
```

```
True/False Question:
{
  "question": {
    "text": "The sky is blue",
    "type": "True_False",
    "difficulty": "easy"
  },
  "correct_answer": true
}
```

```
## Backend Response Example
{
  "success": true,
  "questionId": 501,
  "choiceIds": [101, 102, 103, 104],
  "message": "Question created successfully"
}
```

## Admin User Story – Step by Step

1. Admin opens "Add New Question" page.  
2. Admin enters question text, selects difficulty and type (MCQ / True-False).  

### MCQ Flow
3. Admin fills 4 choices, marks exactly one correct.  
4. Submits the form. Frontend sends JSON to backend.  
5. Backend calls InsertQuestion → gets question_id.  
6. Backend loops through choices → calls InsertMCQChoice for each, updates correct_ans_id if needed.  
7. Backend returns success with question_id and choice_ids.

### True/False Flow
3. Admin selects True or False as correct.  
4. Submits the form. Frontend sends JSON to backend.  
5. Backend calls InsertQuestion → gets question_id.  
6. Backend calls InsertTrueFalseChoice → sets correct_ans_id to 1 (True) or 2 (False) and inserts bridge for both choices.  
7. Backend returns success with question_id and choice_ids [1, 2].

## Admin Validation Rules
- Question text required.  
- Difficulty required.  
- Question type required.  
- MCQ: exactly 4 choices, exactly 1 correct.  
- True/False: correct answer required.

## Success Outcome
Admin sees: “Question created successfully” and question is available in quizzes/exams.

## Failure Outcome
Admin sees error messages like:  
- "Question text is required"  
- "Please select a correct answer"  
- "MCQ must have exactly one correct choice"
