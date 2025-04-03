# Student Management API (Ballerina)

## Overview
This Ballerina service provides a simple **Student Management API** that allows adding, retrieving, and deleting student records.

## Features
- Add a student (`POST /students/add`)
- Retrieve a student (`GET /students/get/{id}`)
- Delete a student (`DELETE /students/remove/{id}`)

## Running the Service
1. Install [Ballerina](https://ballerina.io).
2. Start the service:
   ```sh
   bal run student_service.bal
   ```
3. The service will be available at `http://localhost:8080/students`.

## API Endpoints

### Add a Student
```sh
curl -X POST "http://localhost:8080/students/add" -H "Content-Type: application/json" -d '{"id": 1, "name": "Alice", "age": 6}'
```

### Retrieve a Student
```sh
curl -X GET "http://localhost:8080/students/get/1"
```

### Delete a Student
```sh
curl -X DELETE "http://localhost:8080/students/remove/1"
```

## Error Handling
- If a student with the same ID exists, it returns `"Student ID already exists"`.
- If a student does not exist, it returns `"Studentsuccess"`.


The system should be available at 24/7 and if there is failure it should be email that