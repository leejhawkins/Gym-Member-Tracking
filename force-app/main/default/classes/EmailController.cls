public inherited sharing class EmailController {
    
    @AuraEnabled(cacheable=true)
    public static void sendSingleEmail(String name,String email,String description){
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        message.setSenderDisplayName('Workout Delivery Bot');
        message.setToAddresses(new String[]{email});
        message.setHtmlBody('<p>Hello ' + name + ',</p> </p>Below is your daily workout for ' + Date.today().format() + ':</p>' + description);
        message.setSubject('Your Daily Workout');
        messages.add(message);
        Messaging.sendEmail(messages);
    }
    

    
    
}
 