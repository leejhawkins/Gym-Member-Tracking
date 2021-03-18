/*
   Created by Kareem El Sayed
   A class with a method to send an email to a member, gets invoked when member is inserted
*/
public with sharing class MailToNewMember {
    
  
    //first create the email template
    public static Messaging.SingleEmailMessage makeEmail(Member__c m){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSenderDisplayName('Gym Owner');
        email.setToAddresses(new String[]{m.Email__c});
        email.setHtmlBody('<p>Hello ' + m.Name + ',</p> </p>Thanks for joining our Gym. We’re excited to have you on board! You’ve taken the first step towards achieving your fitness goals.  ');
        email.setSubject('Welcome to our Gym');
        email.setReplyTo('kareem.elsayed@smoothstack.com');
        return email;
    }

  //send email to new member 
  public static void sendWelcomeEmail(List<Member__c> members){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
          for(Member__c m: members){
                if(m.Email__c != null && m.Name != null){
                   emails.add(makeEmail(m));
                 }             
            }
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);    
      }
          
}
