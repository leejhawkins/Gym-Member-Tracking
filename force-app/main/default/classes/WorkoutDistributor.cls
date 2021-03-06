/*
    Created by Simon Sawyer
    Sends daily Workouts to gym Members according to fitness level, training class, and health issues
*/
public class WorkoutDistributor implements Schedulable {
  public void execute(SchedulableContext context) {
    List<Contact> members = [
      SELECT Name, Email, Fitness_Level__c
      FROM Contact
      WHERE Email != NULL
    ];
    List<Workout__c> workouts = [
      SELECT
        Training_Class__c,
        Fitness_Level__c,
        Issues__c,
        Workout_Description__c,
        Date__c
      FROM Workout__c
      WHERE Date__c = TODAY
    ];
    Map<Contact, Workout__c> assignments = getAssignments(members, workouts);
    List<Messaging.SendEmailResult> results = sendEmails(assignments);
  }
  //Assign workouts to members
  public static Map<Contact, Workout__c> getAssignments(
    List<Contact> members,
    List<Workout__c> workouts
  ) {
    Map<Contact, Workout__c> assignments = new Map<Contact, Workout__c>();
    Workout__c w = new Workout__c();
    for (Contact m : members) {
      w = getProgram(m, workouts);
      if (w != null) {
        assignments.put(m, w);
      }
    }
    return assignments;
  }
  //Find correct workout for a given member
  public static Workout__c getProgram(Contact m, List<Workout__c> workouts) {
    for (Workout__c w : workouts) {
      if (
        (w.Fitness_Level__c == m.Fitness_Level__c ||
        (w.Fitness_Level__c == 'Beginner' &&
        m.Fitness_Level__c == 'Novice'))
      ) {
        return w;
      }
    }
    return null;
  }
  //Prepares and sends emails containing workout assignments
  public static List<Messaging.SendEmailResult> sendEmails(
    Map<Contact, Workout__c> assignments
  ) {
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    for (Contact m : assignments.keySet()) {
      messages.add(prepEmail(m, assignments.get(m)));
    }
    List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
    return results;
  }
  //Generate message to send workout to a given member
  public static Messaging.SingleEmailMessage prepEmail(
    Contact m,
    Workout__c w
  ) {
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.setSenderDisplayName('Workout Delivery Bot');
    message.setToAddresses(new List<String>{ m.Email });
    message.setHtmlBody(
      '<p>Hello ' +
      m.Name +
      ',</p> </p>Below is your daily workout for ' +
      Date.today().format() +
      ':</p>' +
      w.Workout_Description__c
    );
    message.setSubject('Your Daily Workout');
    return message;
  }
}
