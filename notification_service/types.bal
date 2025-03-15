// Notification request
public type NotificationRequest record {|
    string recipientEmail?;
    string recipientPhone?;
    string slackChannel?;
    string subject?;
    string message;
    NotificationType notificationType;
    NotificationChannel channel;
|};

// Notification response
public type NotificationResponse record {|
    string status;
    string message;
|};

// Notification channel enum
public enum NotificationChannel {
    EMAIL,
    SMS,
    SLACK
}

// Notification type enum
public enum NotificationType {
    GUEST_CHECKIN,
    GUEST_CHECKOUT,
    HOST_ALERT,
    SECURITY_ALERT
}

// Error response
public type ErrorResponse record {|
    string message;
    string code;
|};