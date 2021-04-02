/*
    Created by Simon Sawyer
    Sends daily Workouts to gym Members according to fitness level, training class, and health issues
*/
public class WorkoutDistributor implements Schedulable {
  public void execute(SchedulableContext context) {
    List<Member__c> members = [
      SELECT Name, Email__c, Training_Class__c, Fitness_Level__c, Issues__c
      FROM Member__c
      WHERE Active__c = TRUE AND Email__c != NULL
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
    Map<Member__c, Workout__c> assignments = getAssignments(members, workouts);
    List<Messaging.SendEmailResult> results = sendEmails(assignments);
  }
  //Assign workouts to members
  public static Map<Member__c, Workout__c> getAssignments(
    List<Member__c> members,
    List<Workout__c> workouts
  ) {
    Map<Member__c, Workout__c> assignments = new Map<Member__c, Workout__c>();
    Workout__c w = new Workout__c();
    for (Member__c m : members) {
      w = getProgram(m, workouts);
      if (w != null) {
        assignments.put(m, w);
      }
    }
    return assignments;
  }
  //Find correct workout for a given member
  public static Workout__c getProgram(Member__c m, List<Workout__c> workouts) {
    for (Workout__c w : workouts) {
      if (
        (w.Training_Class__c == m.Training_Class__c) &&
        (w.Fitness_Level__c == m.Fitness_Level__c  || (w.Fitness_Level__c == 'Beginner' && m.Fitness_Level__c == 'Novice')) &&
        (w.Issues__c == m.Issues__c)
      ) {
        return w;
      }
    }
    return null;
  }
  //Prepares and sends emails containing workout assignments
  public static List<Messaging.SendEmailResult> sendEmails(
    Map<Member__c, Workout__c> assignments
  ) {
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    for (Member__c m : assignments.keySet()) {
      messages.add(prepEmail(m, assignments.get(m)));
    }
    List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
    return results;
  }
  //Generate message to send workout to a given member
  public static Messaging.SingleEmailMessage prepEmail(
    Member__c m,
    Workout__c w
  ) {
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.setSenderDisplayName('Workout Delivery Bot');
    message.setToAddresses(new List<String>{ m.Email__c });
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
