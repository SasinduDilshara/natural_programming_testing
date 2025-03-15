import ballerina/http;
import ballerina/email;
import ballerinax/twilio;
import ballerinax/slack;

// Configuration for notification services
configurable string emailHost = "smtp.gmail.com";
configurable string emailUsername = "your-email@gmail.com";
configurable string emailPassword = "your-app-password";

configurable string twilioAccountSid = "your-account-sid";
configurable string twilioAuthToken = "your-auth-token";
configurable string twilioFromNumber = "your-twilio-number";

configurable string slackToken = "your-slack-token";

// Initialize clients
final email:SmtpClient emailClient = check new (
    host = emailHost,
    username = emailUsername,
    password = emailPassword,
    clientConfig = {
        port: 465,
        security: email:SSL
    }
);

final twilio:Client twilioClient = check new (
    twilioAccountSid,
    twilioAuthToken
);

final slack:Client slackClient = check new (
    auth = {
        token: slackToken
    }
);

service /notifications on new http:Listener(8081) {
    resource function post send(@http:Payload NotificationRequest request) returns NotificationResponse|ErrorResponse|error {
        match request.channel {
            EMAIL => {
                if request.recipientEmail is string {
                    check self.sendEmail(request.recipientEmail, request.subject ?: "Notification", request.message);
                }
            }
            SMS => {
                if request.recipientPhone is string {
                    check self.sendSms(request.recipientPhone, request.message);
                }
            }
            SLACK => {
                if request.slackChannel is string {
                    check self.sendSlackMessage(request.slackChannel, request.message);
                }
            }
        }

        return {
            status: "SUCCESS",
            message: string `Notification sent via ${request.channel}`
        };
    }

    resource function post bulk(@http:Payload NotificationRequest[] requests) returns NotificationResponse|ErrorResponse|error {
        foreach NotificationRequest request in requests {
            check self.sendNotification(request);
        }

        return {
            status: "SUCCESS",
            message: "Bulk notifications sent successfully"
        };
    }

    private function sendEmail(string recipientEmail, string subject, string message) returns error? {
        email:Message emailMessage = {
            'from: emailUsername,
            to: recipientEmail,
            subject: subject,
            body: message
        };
        check emailClient->sendMessage(emailMessage);
    }

    private function sendSms(string recipientPhone, string message) returns error? {
        check twilioClient->sendSms(
            fromNumber = twilioFromNumber,
            toNumber = recipientPhone,
            message = message
        );
    }

    private function sendSlackMessage(string channel, string message) returns error? {
        check slackClient->postMessage({
            channel: channel,
            text: message
        });
    }

    private function sendNotification(NotificationRequest request) returns error? {
        match request.channel {
            EMAIL => {
                if request.recipientEmail is string {
                    check self.sendEmail(request.recipientEmail, request.subject ?: "Notification", request.message);
                }
            }
            SMS => {
                if request.recipientPhone is string {
                    check self.sendSms(request.recipientPhone, request.message);
                }
            }
            SLACK => {
                if request.slackChannel is string {
                    check self.sendSlackMessage(request.slackChannel, request.message);
                }
            }
        }
    }
}