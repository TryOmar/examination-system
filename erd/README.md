# Entity Relationship Diagram (ERD)

This folder contains the ERD for the Online Examination System.

## Files

- `examination_system.mmd` - Mermaid diagram source file
- `examination_system.png` - Generated PNG image (after running the command below)

## Generating the Diagram

### Prerequisites

Install the Mermaid CLI globally:

```bash
npm install -g @mermaid-js/mermaid-cli
```

### Generate PNG

```bash
mmdc -i examination_system.mmd -o examination_system.png
```

### Generate SVG (alternative)

```bash
mmdc -i examination_system.mmd -o examination_system.svg
```

### Generate with Custom Width

```bash
mmdc -i examination_system.mmd -o examination_system.png -w 2000
```

## Entities Overview

| Entity | Description |
|--------|-------------|
| **Branch** | Physical branches/locations of the institution |
| **Department** | Departments/Tracks within branches |
| **Instructor** | Teaching staff members |
| **Student** | Students enrolled in the system |
| **Course** | Courses offered by departments |
| **Topic** | Topics covered within courses |
| **Question** | Exam questions belonging to courses |
| **QuestionType** | Types of questions (True/False, MCQ) |
| **Choice** | Answer choices for questions |
| **Exam** | Generated exams from question pool |
| **ExamQuestion** | Junction table linking exams to questions |
| **StudentExam** | Student's exam attempt records |
| **StudentAnswer** | Individual answers submitted by students |
| **Enrollment** | Student course enrollments |
| **InstructorCourse** | Instructor-course assignments |

## Relationships

- A **Branch** has many **Departments**
- A **Department** has many **Instructors**, **Students**, and **Courses**
- A **Course** has many **Topics**, **Questions**, and **Exams**
- A **Question** has many **Choices** and can appear in many **Exams**
- A **Student** can take many **Exams** through **StudentExam**
- Each **StudentExam** has many **StudentAnswers**
