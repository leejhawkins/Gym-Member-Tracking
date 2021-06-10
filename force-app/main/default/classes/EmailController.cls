public inherited sharing class EmailController {
  @AuraEnabled(cacheable=true)
  public static void sendSingleEmail(
    String name,
    String email,
    String description
  ) {
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    List<String> sendTo = new List<String>();
    message.setSenderDisplayName('Workout Delivery Bot');
    message.setToAddresses(new List<String>{ email });
    message.setHtmlBody(
      '<p>Hello ' +
      name +
      ',</p> </p>Below is your daily workout for ' +
      Date.today().format() +
      ':</p>' +
      description
    );
    message.setSubject('Your Daily Workout');
    messages.add(message);
    Messaging.sendEmail(messages);
  }

  public static void sendCongratulationsEmail(
    String name,
    String email,
    String oldLevel,
    String newLevel,
    Member__c nextLevel
  ) {
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    List<String> sendTo = new List<String>();
    String messageString =
      '<p>Congratulations ' +
      name +
      '!!!</p> <p>You are moving towards your goal!</p>';
    messageString +=
      '<p>  You have advanced from ' +
      oldLevel +
      ' level to ' +
      newLevel +
      ' level</p>';
    messageString +=
      '<p> You will now receive the daily ' +
      newLevel +
      ' workouts' +
      '<p> Next Back Squat Level: ' +
      nextLevel.Back_Squat__c +
      '</p>' +
      '<p> Next Deadlift Level: ' +
      nextLevel.Deadlift__c +
      '</p>' +
      '<p> Next Bench Press Level: ' +
      nextLevel.Bench_Press__c +
      '</p>' +
      '<p> Next Shoulder Press Level: ' +
      nextLevel.Shoulder_Press__c;
    message.setSenderDisplayName('Your Gym');
    message.setToAddresses(new List<String>{ email });
    message.setHtmlBody(messageString);
    message.setSubject(
      'Congratulations, ' +
      name +
      ': You have reached a new level!!'
    );
    messages.add(message);
    Messaging.sendEmail(messages);
  }
}
