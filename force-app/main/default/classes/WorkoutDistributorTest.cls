@isTest
public class WorkoutDistributorTest {
    @TestSetup
    public static void makeData(){
        //Add Members
        List<Member__c> members = new List<Member__c>{
                new Member__c(Name='George Costanza', Email__c= 'gcost@smoothstack.com', Issues__c= 'Knee', Training_Class__c= 'Basic', Fitness_Level__c= 'Beginner', Active__c = true, Date_of_Birth__c = Date.today()),
                new Member__c(Name='Jerry Seinfeld', Email__c= 'jsein@smoothstack.com', Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Beginner', Active__c = true, Date_of_Birth__c = Date.today()),
                new Member__c(Name='Cosmo Kramer', Email__c= 'ckram@smoothstack.com', Issues__c= 'Shoulder', Training_Class__c= 'Cross-Training', Fitness_Level__c= 'Intermediate', Active__c = true, Date_of_Birth__c = Date.today()),
                new Member__c(Name='Elaine Benes', Email__c= 'eben@smoothstack.com', Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Elite', Active__c = true, Date_of_Birth__c = Date.today()),
                new Member__c(Name='Newman', Email__c= 'newman@smoothstack.com', Issues__c= 'Knee;Shoulder', Training_Class__c= 'Cross-Training', Fitness_Level__c= 'Advanced', Active__c = true, Date_of_Birth__c = Date.today()),
                new Member__c(Name='Extra 1', Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Elite', Active__c = true, Date_of_Birth__c = Date.today()),
                new Member__c(Name='Extra 2', Email__c= 'extra2@smoothstack.com', Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Elite', Active__c = false, Date_of_Birth__c = Date.today())
        };
        insert members;
        //Add Workouts
        List<Workout__c> workouts = new List<Workout__c>{
                new Workout__c(Name= 'Basic Beginner Workout Test', Date__c= Date.today(), Training_Class__c= 'Basic', Fitness_Level__c= 'Beginner', Workout_Description__c= 'Basic Beginner Workout'),
                new Workout__c(Name= 'Basic Beginner Workout Knees Test', Date__c= Date.today(),  Training_Class__c= 'Basic', Issues__c= 'Knee', Fitness_Level__c= 'Beginner', Workout_Description__c= 'Basic Beginner Kneeless Workout'),
                new Workout__c(Name= 'Intermediate Cross-Training Shoulders Workout Test', Date__c= Date.today(),  Issues__c= 'Shoulder', Training_Class__c= 'Cross-Training', Fitness_Level__c= 'Intermediate', Workout_Description__c= 'Intermediate Cross-Training Shoulders Workout'),
                new Workout__c(Name= 'Beginner Bodybuilding Workout Test', Date__c= Date.today(), Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Beginner', Workout_Description__c= 'Basic Beginner Workout'),
                new Workout__c(Name= 'Elite Bodybuilding Workout Test', Date__c= Date.today(), Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Elite', Workout_Description__c= 'Elite Bodybuilding Workout'),
                new Workout__c(Name= 'Advanced Cross-Training Workout Test', Date__c= Date.today(), Training_Class__c= 'Cross-Training', Fitness_Level__c= 'Advanced', Workout_Description__c= 'Advanced Cross-Training Workout'),
                new Workout__c(Name= 'Elite Bodybuilding Workout Test', Date__c= Date.today().addDays(1), Training_Class__c= 'Bodybuilding', Fitness_Level__c= 'Elite', Workout_Description__c= 'Basic Beginner Workout')
        };
        insert workouts;
    }

    @isTest
    public static void baseTest(){
        try{
            Test.startTest();
            WorkoutDistributor wd = new WorkoutDistributor();
            String cron = '0 0 5 * ? *';
            String jobID = system.schedule('Distribute Workouts '+ date.today(), cron, wd);
            Test.stopTest();
            System.assert(true);
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        List<Member__c> members = [SELECT Name, Email__c, Training_Class__c, Fitness_Level__c, Issues__c FROM Member__c WHERE Active__c = TRUE AND Email__c != NULL];
        List<Workout__c> workouts = [SELECT Training_Class__c, Fitness_Level__c, Issues__c, Workout_Description__c, Date__c FROM Workout__c WHERE Date__c = TODAY];
        Map<Member__c, Workout__c> assignments = WorkoutDistributor.getAssignments(members, workouts);        
        List<Messaging.SendEmailResult> results = WorkoutDistributor.sendEmails(assignments);
        for(Messaging.SendEmailResult r : results){
            System.assert(r.isSuccess());
        }
    }
}
