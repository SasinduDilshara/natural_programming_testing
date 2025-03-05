# Order Management System API

This is a simple order management system implemented using Ballerina. The system provides RESTful APIs for managing orders and users.

## Features
- Create and manage orders
- Get user specific orders
- Update and delete orders
- View all users

## API Endpoints

### Orders
- **Create an order**: `POST /orders`
- **Update an order**: `PUT /orders/{orderId}`
- **Delete an order**: `DELETE /orders/{orderId}`
- **Get orders by user**: `GET /orders/users/{userId}`
- **Get user orders**: `GET /users/{userId}/orders`

### Users
- **Get all users**: `GET /users`

## Data Structures

### Order
```json
{
    "orderId": "string",
    "userId": "string",
    "items": [
        {
            "itemId": "string",
            "quantity": "int",
            "price": "decimal"
        }
    ],
    "totalAmount": "decimal",
    "status": "string"
}
```

### OrderCreationRequest
```json
{
    "userId": "string",
    "items": [
        {
            "itemId": "string",
            "quantity": "int",
            "price": "decimal"
        }
    ]
}
```

### User
```json
{
    "userId": "string",
    "userName": "string",
    "email": "string"
}
```

## Error Response
```json
{
    "message": "string",
    "code": "string"
}
```

## Running the Service
Run the following command to start the order management service:
```sh
bal run
```

The service will be available at `http://localhost:8080/`.

## License
This project is licensed under the MIT License.