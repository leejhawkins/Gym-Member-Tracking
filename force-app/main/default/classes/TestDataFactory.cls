/*
   Created by Kareem El Sayed
   a data factory class to be used in Test classes
*/
@isTest public inherited sharing class TestDataFactory {
    
    //methods to create records and populate the required fields
    public static List<Member__c> generateMembers(Integer numOfMembers){
       List<Member__c> members = new List<Member__c>();
       for(Integer i = 0; i < numOfMembers; i++){
           Member__c m = new Member__c();
           m.Name = 'Test member ' + i;
           m.Date_of_Birth__c = Date.today();
           members.add(m);
       }
       insert members;

       return members;
   }

    public static List<Workout__c> generateWorkouts(Integer numOfWorkouts){
        List<Workout__c> workouts = new List<Workout__c>();
        Integer i = 0;
        while(i < numOfWorkouts){
            Workout__c workout = new Workout__c();
            workout.Name = 'Test workout ' + i;
            workout.Date__c = date.today();
            workouts.add(workout);
            i+=1;
        }

        insert workouts;

        return workouts;

    }

   public static List<Benchmark__c> generateBenchmarks(Integer numOfBenchMarks, List<Member__c> members){
       List<Benchmark__c> benchmarks = new List<Benchmark__c>();
       
         for(Member__c m: members){
           for(Integer j = 1; j < numOfBenchMarks; j++){
              Benchmark__c b = new Benchmark__c();
              b.Name = 'Test benchmark ' + j;
              b.Member__c = m.Name;
              benchmarks.add(b);
           }
         }

         insert benchmarks;

         return benchmarks;
   }

    //methods to create records with specified fields
    public static List<Member__c> generateMembers(String email, String fitnessLevel, String trainingClass, String issues, Integer membersNum){
         List<Member__c> members = new List<Member__c>();
         for(Integer i = 0; i < membersNum; i++){
            Member__c member = new Member__c();
            member.Name = 'Robust-Test-Member '+i;
            member.Email__c = email;
            member.Issues__c = issues;
            member.Fitness_Level__c = fitnessLevel;
            member.Training_Class__c = trainingClass;
            members.add(member);
         }
         insert members;
         return members;

   }
    
    public static List<Workout__c> generateWorkouts(Date workoutDate, String fitnessLevel, String trainingClass, String description, String issues, Integer numWorkouts){
            List<Workout__c> workouts = new List<Workout__c>();

            for(Integer i = 0; i < numWorkouts; i++){
                Workout__c workout = new Workout__c();
                workout.Name = 'Robust-workout '+i;
                workout.Date__c = workoutDate;
                workout.Fitness_Level__c = fitnessLevel;
                workout.Training_Class__c = trainingClass;
                workout.Issues__c = issues;
                workout.Workout_Description__c = description;
                workouts.add(workout);
            }

            insert workouts;

            return workouts;
    }

    
   public static List<Benchmark__c> generateBenchmarks(List<Member__c> members, Integer weight, Integer numBenchMarks){  
           List<Benchmark__c> benchmarks = new List<Benchmark__c>();
    
           for(Member__c m: members){
              for(Integer i=0; i < numBenchMarks; i++){
                Benchmark__c b = new Benchmark__c();
                b.Name = 'Robust-Benchmark '+i;
                b.Member__r = m;
                b.Weight__c = weight;
                benchmarks.add(b);
              }
           }
            
             insert benchmarks;

            return benchmarks;
   }
}
