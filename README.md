1. Project Overview
The Task Management System is a software application designed to help individuals and teams organize, track, and manage tasks efficiently. It provides features like creating, updating, and deleting tasks, assigning tasks to users, setting deadlines, prioritizing tasks, and tracking progress.

Key Features:

User registration and authentication.
Create, view, update, and delete tasks.
Set deadlines and priorities.
Track task completion status.
Filter and sort tasks by priority, status, or deadline.
REST APIs for integration with other systems (if applicable).

2. Tech Stack
Backend: Spring Boot, Java
Frontend: React.js/Angular (or any other frontend framework, if applicable)
Database: MySQL
Authentication: JWT (JSON Web Token)
Tools: Maven/Gradle, Postman (for API testing)

3. Prerequisites
Before running the project, ensure you have the following installed:

Java 11 or higher
Maven or Gradle
MySQL
Postman 

4. API Endpoints
User APIs
POST /register - Register a new user.
POST /login - User login and token generation.
Task APIs
GET /tasks - Retrieve all tasks.
POST /tasks - Create a new task.
PUT /tasks/{id} - Update a task.
DELETE /tasks/{id} - Delete a task.
Other APIs
GET /tasks/filter - Filter tasks by status, priority, or deadline.
GET /tasks/user/{id} - Get tasks assigned to a specific user.
