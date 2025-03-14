# Guest Management Service

This is a simple guest management service implemented using Ballerina. The service provides RESTful APIs for managing guest information.

## Features
- Create new guests
- Retrieve all guests
- Retrieve specific guest details
- Update guest information
- Delete guests

## API Endpoints

### Guest Service (`/guests`)

#### Create Guest
- **Endpoint**: `POST /guests`
- **Request Body**: `GuestCreateRequest`
- **Response**: `Guest` or `ErrorResponse`
- **Description**: Creates a new guest with the given information

#### Get All Guests
- **Endpoint**: `GET /guests`
- **Response**: `Guest[]` or `ErrorResponse`
- **Description**: Retrieves all registered guests

#### Get Guest
- **Endpoint**: `GET /guests/{id}`
- **Path Parameters**:
  - `id`: String - Unique identifier of the guest
- **Response**: `Guest` or `ErrorResponse`
- **Description**: Retrieves details of a specific guest

#### Update Guest
- **Endpoint**: `PUT /guests/{id}`
- **Path Parameters**:
  - `id`: String - Unique identifier of the guest
- **Request Body**: `GuestUpdateRequest`
- **Response**: `Guest` or `ErrorResponse`
- **Description**: Updates an existing guest's information

#### Delete Guest
- **Endpoint**: `DELETE /guests/{id}`
- **Path Parameters**:
  - `id`: String - Unique identifier of the guest
- **Response**: `http:Ok` or `ErrorResponse`
- **Description**: Deletes a guest by their ID

## Data Structures

### Guest
```json
{
    "id": "string",
    "name": "string",
    "email": "string",
    "phoneNumber": "string"
}
```

### GuestCreateRequest
```json
{
    "name": "string",
    "email": "string",
    "phoneNumber": "string"
}
```

### GuestUpdateRequest
```json
{
    "name": "string",
    "email": "string",
    "phoneNumber": "string"
}
```

### ErrorResponse
```json
{
    "message": "string",
    "code": "string"
}
```

## Running the Service

Run the following command to start the guest management service:
```sh
bal run
```

The service will be available at:
- Guest Service: `http://localhost:8080/guests`

## Error Handling

All endpoints may return an `ErrorResponse` in case of failures with:
- Appropriate error message
- Error code indicating the type of failure

## License
This project is licensed under the MIT License.