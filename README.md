# 📝 Online Examination System

A database-driven examination system built with SQL Server.

## 📁 Project Structure

```
examination-system/
├── docs/
│   └── REQUIREMENTS.md      # Project requirements
└── erd/
    ├── examination_system.mmd  # Mermaid ERD source
    └── README.md               # ERD generation instructions
```

## 🚀 ERD Generation

### Install Mermaid CLI

```bash
npm install -g @mermaid-js/mermaid-cli
```

### Generate PNG

```bash
cd erd
mmdc -i examination_system.mmd -o examination_system.png
```

### Generate SVG

```bash
mmdc -i examination_system.mmd -o examination_system.svg
```

## 📋 Documentation

- [Project Requirements](docs/REQUIREMENTS.md)
- [ERD Details](erd/README.md)
