Task Management App
This is a Task Management application that allows users to manage their tasks efficiently. The app has two main components:

Frontend: Developed using Flutter, providing a user-friendly mobile interface.
Backend: Developed using Spring Boot, offering a secure and robust API for managing tasks and users.

Features
Frontend (Flutter)
User Authentication: Allows users to sign up and log in.
Task Management: Users can create, view, update, and delete tasks.
Task Details: View detailed information about each task.
Task Status: Mark tasks as completed or in-progress.
Responsive UI: The app is optimized for both Android and web devices.

Backend (Spring Boot)
User Registration & Login: Endpoints for user registration and login.
Task Management: APIs to create, update, delete, and retrieve tasks.
JWT Authentication: Secure login using JWT tokens for authentication.
Database: Uses a relational database (like MySQL) to store users and tasks.

Technologies Used

Frontend (Flutter):
Flutter SDK
Dart Programming Language
Provider for state management
HTTP package for API integration

Backend (Spring Boot):
Spring Security
Spring Data JPA
JWT for authentication
MySQL Database for persistent storage
Setup Instructions

Prerequisites
Before starting the setup, make sure you have the following installed on your local machine:

Flutter SDK: Flutter Installation Guide
Java JDK (version 17 or later): JDK Installation Guide
MySQL Database : MySQL Installation Guide
Spring Boot (via Spring Tool Suite or IntelliJ IDEA): Spring Boot Setup
Backend Setup (Spring Boot)


Set up Database:

Create a MySQL database called task_management.
Update the application.properties file with your database credentials:
spring.datasource.url=jdbc:mysql://localhost:3306/task_management
spring.datasource.username=root
spring.datasource.password=password


Run the Backend:

Open the project in your preferred IDE (IntelliJ IDEA, Eclipse, etc.).
Run the TaskApplication.java class.
The server will start on localhost:8080.

Frontend Setup (Flutter)
Install Dependencies:
flutter pub get

Run the App:
Connect an Android or iOS device/emulator.
Run the Flutter app
flutter run



Here's a README template for a Task Management App built with Flutter for the frontend and Spring Boot for the backend:

Task Management App
This is a Task Management application that allows users to manage their tasks efficiently. The app has two main components:

Frontend: Developed using Flutter, providing a user-friendly mobile interface.
Backend: Developed using Spring Boot, offering a secure and robust API for managing tasks and users.
Features
Frontend (Flutter)
User Authentication: Allows users to sign up and log in.
Task Management: Users can create, view, update, and delete tasks.
Task Details: View detailed information about each task.
Task Status: Mark tasks as completed or in-progress.
Responsive UI: The app is optimized for both Android and iOS devices.
Backend (Spring Boot)
User Registration & Login: Endpoints for user registration and login.
Task Management: APIs to create, update, delete, and retrieve tasks.
JWT Authentication: Secure login using JWT tokens for authentication.
Database: Uses a relational database (like MySQL) to store users and tasks.
Technologies Used
Frontend (Flutter):

Flutter SDK
Dart Programming Language
Provider for state management
HTTP package for API integration
Backend (Spring Boot):

Spring Boot 3.x
Spring Security
Spring Data JPA
JWT for authentication
MySQL or H2 Database for persistent storage
Setup Instructions
Prerequisites
Before starting the setup, make sure you have the following installed on your local machine:

Flutter SDK: Flutter Installation Guide
Java JDK (version 17 or later): JDK Installation Guide
MySQL Database (or H2 Database for testing): MySQL Installation Guide
Spring Boot (via Spring Tool Suite or IntelliJ IDEA): Spring Boot Setup
Backend Setup (Spring Boot)
Clone the Backend Repository:

bash
Copy code
git clone <your-backend-repository-url>
cd <backend-folder>
Set up Database:

Create a MySQL database called task_management.
Update the application.properties or application.yml file with your database credentials:
properties
Copy code
spring.datasource.url=jdbc:mysql://localhost:3306/task_management
spring.datasource.username=root
spring.datasource.password=password
Run the Backend:

Open the project in your preferred IDE (IntelliJ IDEA, Eclipse, etc.).
Run the TaskManagementApplication.java class.
The server will start on localhost:8080.
Frontend Setup (Flutter)
Clone the Flutter Repository:

bash
Copy code
git clone <your-flutter-repository-url>
cd <flutter-folder>
Install Dependencies:

bash
Copy code
flutter pub get
Update API URLs:

Open the Flutter project and update the API base URL in the constants.dart file to match your backend server URL (e.g., http://localhost:8080).
Run the App:


Screenshots
Here are some screenshots of the Task Management App:
![Screenshot 2024-12-09 175417](https://github.com/user-attachments/assets/b8a58c1e-b056-4130-bf77-d36a070921ff)
![Screenshot 2024-12-09 175239](https://github.com/user-attachments/assets/f1f917ec-ca49-4fc8-b494-1f7b4ba3a7fc)
![Screenshot 2024-12-09 175214](https://github.com/user-attachments/assets/a16761f9-83a0-49ba-851c-d00ea97be57d)
![Screenshot 2024-12-09 175951](https://github.com/user-attachments/assets/8e44afc2-8d9f-4395-8a3c-421b25346889)
![Screenshot 2024-12-09 175428](https://github.com/user-attachments/assets/4f74f06c-515b-41bb-95d8-cb9c33aa1fc2)


API Endpoints (Backend)
User Endpoints
POST /api/auth/register - Register a new user.
POST /api/auth/login - Login a user and receive a JWT token.
Task Endpoints
GET /api/tasks - Get all tasks for the logged-in user.
POST /api/tasks - Create a new task.
PUT /api/tasks/{id} - Update an existing task.
DELETE /api/tasks/{id} - Delete a task.

Authentication
POST /api/users/login - Logs in the user and returns a JWT token. The token should be included in the headers for subsequent API calls.

