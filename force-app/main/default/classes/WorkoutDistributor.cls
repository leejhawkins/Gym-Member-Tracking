/*
    Created by Simon Sawyer
    Sends daily Workouts to gym Members according to fitness level, training class, and health issues
*/
public class WorkoutDistributor implements Schedulable{

    public void execute(SchedulableContext context){
        List<Member__c> members = [SELECT Name, Email__c, Training_Class__c, Fitness_Level__c, Issues__c FROM Member__c WHERE Active__c = TRUE AND Email__c != NULL];
        List<Workout__c> workouts = [SELECT Training_Class__c, Fitness_Level__c, Issues__c, Workout_Description__c, Date__c FROM Workout__c WHERE Date__c = TODAY];
        EmailTemplate template = [SELECT Id, Subject from EmailTemplate where Name = 'Workout Template' LIMIT 1];
        Map<Member__c, Workout__c> assignments = new Map<Member__c, Workout__c>();
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        Workout__c w = new Workout__c();
        for(Member__c m : members){
            w = getProgram(m, workouts);
            assignments.put(m, w);
            messages.add(sendWorkout(w, m, template));
        }
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
    }
    //Finds correct program for a given member
    static Workout__c getProgram(Member__c m, List<Workout__c> workouts){
        for(Workout__c w : workouts){
            if((w.Training_Class__c == m.Training_Class__c) && (w.Fitness_Level__c == m.Fitness_Level__c) && (w.Issues__c == m.Issues__c)){
                return w;
            }
        }
        return null;
    }
    //Generates message to send workout to a given member
    static Messaging.SingleEmailMessage sendWorkout(Workout__c w, Member__c m, EmailTemplate template){

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTemplateId(template.id);
        message.setToAddresses(new String[]{m.Email__c});
        message.setHtmlBody(w.Workout_Description__c);

        return message;
    }
}