# 📝 Online Examination System

A database-driven examination system built with SQL Server.

## 📁 Project Structure

```
examination-system/
├── docs/
│   ├── REQUIREMENTS.md           # Project requirements
│   └── erd/                      # Entity Relationship Diagrams
│       ├── examination_system.mmd    # Mermaid ERD source
│       ├── examination_system_*.png  # Generated diagrams
│       └── README.md                 # ERD generation instructions
└── sql/
    ├── schema/                   # Database schema
    │   └── schema.sql                # Tables and constraints
    ├── stored-procedures/        # Stored procedures
    │   └── sp_GenerateExam.sql       # Exam generation logic
    ├── seed-data/                # Sample data
    │   └── sample-data.sql           # Test data for development
    └── tests/                    # SQL test queries
        └── exam-generation-test.sql  # Test exam generation
```

## 🚀 ERD Generation

### Install Mermaid CLI

```bash
npm install -g @mermaid-js/mermaid-cli
```

### Generate PNG

```bash
cd docs/erd
mmdc -i examination_system.mmd -o examination_system.png
```

### Generate SVG

```bash
mmdc -i examination_system.mmd -o examination_system.svg
```

## 📋 Documentation

- [Project Requirements](docs/REQUIREMENTS.md)
- [ERD Details](docs/erd/README.md)

## 🗄️ Database

- [Schema Definition](sql/schema/schema.sql)
- [Stored Procedures](sql/stored-procedures/)
- [Sample Data](sql/seed-data/sample-data.sql)

