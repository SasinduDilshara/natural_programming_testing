import ballerina/email;

configurable string smtpHost = "smtp.gmail.com";
configurable string smtpUsername = "your-email@gmail.com";
configurable string smtpPassword = "your-app-password";

final email:SmtpClient smtpClient = check new(
    host = smtpHost,
    username = smtpUsername,
    password = smtpPassword,
    port = 465,
    security = email:SSL
);

public function sendEmailToAll(Guest guest) returns error? {
    email:Message emailMessage = {
        'to: [guest.email, "finance@company.com"],
        subject: "Guest Registration Confirmation",
        body: string `Dear ${guest.name},

Your registration has been confirmed with the following details:
ID: ${guest.id}
Name: ${guest.name}
Email: ${guest.email}
Phone: ${guest.phoneNumber}

Best regards,
Guest Management Team`
    };

    check smtpClient->sendMessage(emailMessage);
}