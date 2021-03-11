/*
   Created by Kareem El Sayed
   A class with a method to send an email to a member, gets invoked when member is inserted
*/
public with sharing class MailToNewMember {
    public static void sendWelcomeEmail(List<Member__c> members){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for(Member__c m: members){
           if(m.Email__c != null && m.Name != null){
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

             List<String> sendTo = new List<String>();
              sendTo.add(m.Email__c);
              mail.setToAddresses(sendTo);

              mail.setReplyTo('kareem.elsayed@smoothstack.com');
              mail.setSenderDisplayName('Gym Owner');


              mail.setSubject('Welcome to the Gym');
              String body = 'Hi ' + m.Name + ', ';
              body += 'Thanks for joining our Gym. ';
              body+= 'You’ve taken the first step towards achieving your fitness goals. ';
              body += 'We are excited have you on board!';

              mail.setHtmlBody(body);

             mails.add(mail);
           }

             Messaging.sendEmail(mails);
             checkSentEmails(mails);
        }

    }

}
