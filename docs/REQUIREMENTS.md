# Online Examination System - Project Requirements

## 1. Database Design

### 1.1 Core Deliverables

- **ER Diagram**: Complete Entity-Relationship diagram showing all entities and relationships
- **Database Backup**: Full SQL Server database backup with schema and data
- **Database Documentation**: Complete data dictionary/documentation (Red Gate SQL Doc recommended)

### 1.2 Required Entities

- **Branches** → Contains multiple Departments/Tracks
- **Departments/Tracks** → Contains multiple Instructors and Students
- **Instructors** → Teach Courses
- **Students** → Enroll in and take Exams
- **Courses** → Have multiple Questions
- **Questions** → Belong to Courses, have:
  - Question Type (True/False, Multiple Choice)
  - Choices (for MCQ)
  - Model Answer (correct answer)
  - Grade/Points value
- **Exams** → Generated from Questions
- **Student Answers** → Student responses to Exam questions

---

## 2. Stored Procedures (Total: ~43-45)

### 2.1 CRUD Operations (40 procedures)

- **For each table** (approximately 10 tables): SELECT, INSERT, UPDATE, DELETE procedures
- All data access must be through stored procedures (no direct table access)

### 2.2 Core Exam Procedures (3 procedures)

1. **Exam Generation**
   - Input: Course name, number of True/False questions, number of MCQ questions
   - Output: Generate random exam with specified question distribution
   - Store exam in database with unique Exam ID

2. **Exam Answers**
   - Input: Exam ID, Student name, Student answers
   - Output: Save student's answers to all exam questions

3. **Exam Correction**
   - Input: Exam ID, Student name
   - Output: Calculate grade percentage by comparing student answers with model answers
   - Consider individual question grades/points
   - Return final percentage score

### 2.3 Reporting Procedures (6 procedures)

1. **Department Students Report**
   - Input: Department ID
   - Output: List of all students in that department

2. **Student Courses & Grades Report**
   - Input: Student ID
   - Output: All courses taken by student with grades obtained

3. **Instructor Courses Report**
   - Input: Instructor ID
   - Output: Courses taught by instructor with student count per course

4. **Course Topics Report**
   - Input: Course ID
   - Output: Topics studied in that course

5. **Exam Print Report**
   - Input: Exam ID
   - Output: Complete exam with questions and choices (for offline printing)

6. **Student Exam Review Report**
   - Input: Exam ID, Student ID
   - Output: Exam questions with student's answers and model answers for comparison

---

## 3. Application Interface

### 3.1 Required Features

- **Platform**: Desktop OR Web application (choose one)
- **Scope**: Exam module ONLY (not full system)
- **Functionality**:
  - Exam generation interface (input course, question counts)
  - Exam taking interface (display questions, capture answers)
  - Results display (show calculated grade)

### 3.2 Technical Requirements

- Connect to SQL Server database
- Call stored procedures for all operations
- Simple, functional interface (no complex UI required)

---

## 4. Data Requirements

### 4.1 Sample Data

- **Realistic data** (not random/meaningless data)
- **Suggested sources**:
  - Use online question banks
  - Use AI tools (ChatGPT) to generate realistic questions with answers
  - Excel import for bulk data
- **Minimum**: 2-3 sample courses with complete question banks

### 4.2 Data Generation Tools (Recommended)

- Red Gate Data Generator (for test data)
- Red Gate SQL Doc (for documentation)
- Red Gate SQL Prompt (for development)

---

## 5. Additional Requirements

### 5.1 Team Structure

- Teams of 5 members (one team of 6 if needed)
- Team leader submits final assignment list

### 5.2 Timeline

- 1 month duration
- Expected completion: 2-3 weeks

### 5.3 Self-Study Topics (Bonus)

- Common Table Expressions (CTEs)
- Temp Tables (table variables, temporary tables)
- Change Data Capture
- Database High Availability concepts
- Database Mirroring

---

## 6. Deliverables Checklist

- [ ] ER Diagram (dbdiagram.io or similar)
- [ ] SQL Server Database Backup
- [ ] Complete Stored Procedures (40-45 procedures)
- [ ] Database Documentation
- [ ] Desktop/Web Application (Exam module)
- [ ] Realistic Sample Data
- [ ] 6 Report Implementations
- [ ] Team Assignment List

---

## 7. Important Notes

- All database access MUST use stored procedures (no ad-hoc queries)
- Application should focus ONLY on exam functionality
- Reports should be implemented using reporting tools (SSRS, Report Builder, Power BI, Crystal Reports, etc.)
- Sample data must be meaningful and realistic
- Documentation should be professional and complete
