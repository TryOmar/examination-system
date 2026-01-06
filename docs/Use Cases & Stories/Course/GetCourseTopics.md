Title: Get Course Topics

**User Story:**
As an instructor or student, I want to view all topics covered in a specific course, so I can understand the course curriculum and structure.

**Basic Flow:**
1. Call `GetCourseTopics` with a Course ID
2. System validates the Course ID exists
3. System returns all topics for that course with details:
   - CourseID
   - CourseTitle
   - CourseCode
   - CourseDescription
   - Credits
   - TopicID
   - TopicTitle
   - TopicOrder
   - TopicDuration
   - TotalTopics (count)
   - TopicProgress (e.g., "Topic 1 of 5")

**Example Usage:**
```sql
EXEC GetCourseTopics @CourseID = 1;
```

**Example Output Format:**

| CourseID | CourseTitle | TopicOrder | TopicTitle | TopicDuration | TopicProgress |
|----------|-------------|------------|------------|---------------|---------------|
| 1 | Database Fundamentals | 1 | SQL Basics | 2 weeks | Topic 1 of 3 |
| 1 | Database Fundamentals | 2 | Database Design | 3 weeks | Topic 2 of 3 |
| 1 | Database Fundamentals | 3 | Normalization | 2 weeks | Topic 3 of 3 |

**Return Codes:**
- `0` : Success
- `-1` : CourseID is NULL
- `-2` : Course not found
- `-99` : Database error

**Notes:**
- Topics are ordered by `topic_order` for logical curriculum flow
- Uses DISTINCT to avoid duplicate topics (since multiple questions can link to same topic)
- Returns empty result set if course has no topics (not an error)
- Includes course metadata for report headers
- Calculated fields help with report formatting

**Use Cases:**
- Course outline reports
- Student course preview
- Curriculum planning
- Academic documentation
