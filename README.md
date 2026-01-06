# 📝 Online Examination System

A comprehensive database-driven examination system built with SQL Server, featuring automated exam generation, student management, and reporting capabilities.

## 📁 Project Structure

```
examination-system/
├── docs/
│   ├── CODE_REVIEW_REPORT.md     # Code review findings
│   ├── REQUIREMENTS.md            # Project requirements
│   ├── use-cases/                 # Use case documentation
│   │   ├── course/                # Course-related use cases
│   │   ├── exam/                  # Exam-related use cases
│   │   ├── insert-question/       # Question insertion workflows
│   │   └── question-management/   # Question management use cases
│   └── erd/                       # Entity Relationship Diagrams
│       ├── README.md              # ERD documentation
│       ├── examination_system.mmd # Mermaid ERD source
│       ├── examination_system_dark.png
│       └── examination_system_light.png
│
└── sql/
    ├── schema/
    │   └── schema.sql             # Database tables and constraints
    │
    ├── stored-procedures/         # Organized by domain
    │   ├── course/                # Course management
    │   ├── exam/                  # Exam operations
    │   ├── instructor/            # Instructor management
    │   ├── student/               # Student management
    │   ├── question-management/   # Question CRUD operations
    │   ├── sp_GenerateExam.sql    # Automated exam generation
    │   ├── sp_CorrectExam.sql     # Exam correction logic
    │   └── sp_StudentSubmitAnswers.sql
    │
    ├── reports/                   # Report definitions (SQL + docs + tests)
    │   ├── course-topics/         # Course topics report
    │   │   ├── GetCourseTopics.sql
    │   │   ├── GetCourseTopics.md
    │   │   └── test-GetCourseTopics.sql
    │   ├── student-exam/          # Student exam reports
    │   │   ├── GetStudentExam.rdl
    │   │   ├── ExamReport.rdl
    │   │   ├── ExamReport.pdf
    │   │   └── test-GetStudentExam.sql
    │   └── student/               # Student-related reports
    │       ├── courses-grade/
    │       │   └── StudentCourseGradesReport.rdl
    │       └── by-department/
    │           └── StudentsByDepartmentReport.rdl
    │
    ├── tests/                     # General test scripts
    │   ├── exam-generation-test.sql
    │   ├── sp_CorrectExam-test.sql
    │   └── sp_StudentSubmitAnswers-test.sql
    │
    └── seed-data/                 # Sample data for testing
        └── sample-data.sql
```

## ✨ Key Features

- **Automated Exam Generation** - Generate exams with configurable question distribution
- **Student Management** - Enrollment, course tracking, and grade management
- **Question Bank** - Support for MCQ and True/False questions with topic linking
- **Reporting** - Comprehensive reports for courses, exams, and student performance
- **Instructor Tools** - Course and exam management capabilities

## 📚 Documentation

### General
- [Project Requirements](docs/REQUIREMENTS.md)
- [Code Review Report](docs/CODE_REVIEW_REPORT.md)
- [ERD Documentation](docs/erd/README.md)

### Use Cases
- [Course Management](docs/use-cases/course/)
- [Exam Management](docs/use-cases/exam/)
- [Question Management](docs/use-cases/question-management/)

### Reports
- [Course Topics Report](sql/reports/course-topics/GetCourseTopics.md)

## 🗄️ Database

### Schema
- [Database Schema](sql/schema/schema.sql) - Complete table definitions and relationships

### Stored Procedures
- [Course Procedures](sql/stored-procedures/course/)
- [Exam Procedures](sql/stored-procedures/exam/)
- [Student Procedures](sql/stored-procedures/student/)
- [Instructor Procedures](sql/stored-procedures/instructor/)
- [Question Management](sql/stored-procedures/question-management/)

### Reports
All report files (SQL procedures, documentation, tests, and .rdl files) are organized in [`sql/reports/`](sql/reports/)

## 🚀 Getting Started

1. **Create Database**
   ```sql
   CREATE DATABASE OnlineExaminationSystem;
   GO
   USE OnlineExaminationSystem;
   GO
   ```

2. **Run Schema**
   ```bash
   sqlcmd -S localhost -d OnlineExaminationSystem -i sql/schema/schema.sql
   ```

3. **Deploy Stored Procedures**
   ```bash
   # Deploy all procedures in order
   sqlcmd -S localhost -d OnlineExaminationSystem -i sql/stored-procedures/[procedure-name].sql
   ```

4. **Load Sample Data** (Optional)
   ```bash
   sqlcmd -S localhost -d OnlineExaminationSystem -i sql/seed-data/sample-data.sql
   ```

## 🧪 Testing

Run test scripts to verify functionality:
```bash
sqlcmd -S localhost -d OnlineExaminationSystem -i sql/tests/exam-generation-test.sql
```

## � Reports

### Creating Reports
Each report in `sql/reports/` follows this structure:
- `[ReportName].sql` - Stored procedure
- `[ReportName].md` - Documentation
- `test-[ReportName].sql` - Test data
- `[ReportName].rdl` - SSRS report definition (optional)

### Available Reports
- **Course Topics** - View all topics for a course
- **Student Exam** - Student exam details and results
- **Student Grades** - Course grades by student
- **Students by Department** - Department enrollment reports

## 🤝 Contributing

When adding new features:
1. Create a new branch (never commit to `master`)
2. Follow the established directory structure
3. Include documentation and tests
4. Open a Pull Request with detailed description

## 📝 License

This project is part of an educational examination system.

