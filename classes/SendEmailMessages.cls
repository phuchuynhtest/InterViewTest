public class SendEmailMessages {
    public static void sendSingleEmailMessage (String subjectEmail, List<String> toEmails, String bodyEmail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toEmails);
        mail.setSubject(subjectEmail);
        mail.setPlainTextBody(bodyEmail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}