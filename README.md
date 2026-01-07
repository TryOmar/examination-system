# 📝 Online Examination System

A comprehensive database-driven examination system built with SQL Server, featuring automated exam generation, student management, and reporting capabilities.

## 📁 Project Structure

```
examination-system/
├── docs/                          # 📚 Documentation
│   ├── use-cases/                 # Use case specifications
│   └── erd/                       # Entity relationship diagrams
│
└── sql/                           # 🗄️ Database
    ├── schema/                    # Database tables and constraints
    ├── stored-procedures/         # Business logic (organized by domain)
    ├── reports/                   # Report definitions with docs and tests
    ├── tests/                     # Test scripts
    └── seed-data/                 # Sample data for development
```

### Key Directories

- **`docs/use-cases/`** - Detailed use case documentation organized by feature (course, exam, question management)
- **`docs/erd/`** - Database entity relationship diagrams (Mermaid source + PNG exports)
- **`sql/schema/`** - Complete database schema definition
- **`sql/stored-procedures/`** - Organized by domain: course, exam, student, instructor, question-management
- **`sql/reports/`** - Each report has its SQL, documentation, tests, and .rdl files together
- **`sql/tests/`** - Integration and general test scripts
- **`sql/seed-data/`** - Sample data for testing and development

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

