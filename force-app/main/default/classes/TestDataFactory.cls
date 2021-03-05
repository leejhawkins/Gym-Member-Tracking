/*
   Created by Kareem El Sayed
   a data factory class to be used in Test classes
*/
@isTest public inherited sharing class TestDataFactory {
    
    //generates  test-members with fitness-level == Beginnner && training-class == Basic
    public static List<Member__c> generateMembers(Integer numOfMembers){
       List<Member__c> members = new List<Member__c>();
       for(Integer i = 0; i < numOfMembers; i++){
           Member__c m = new Member__c();
           m.Name = 'Test member ' + i;
           m.Date_of_Birth__c = Date.today();
           m.Fitness_Level__c = 'Beginner';
           m.Training_Class__c = 'Basic';
           members.add(m);
       }
       insert members;

       return members;
   }

     //generates test-workouts with fitness-level == Beginnner && training-class == Basic
    public static List<Workout__c> generateWorkouts(Integer numOfWorkouts){
        List<Workout__c> workouts = new List<Workout__c>();
        Integer i = 0;
        while(i < numOfWorkouts){
            Workout__c workout = new Workout__c();
            workout.Name = 'Test workout ' + i;
            workout.Date__c = date.today();
            workout.Fitness_Level__c = 'Beginner';
            workout.Training_Class__c = 'Basic';
            workouts.add(workout);
            i+=1;
        }

        insert workouts;

        return workouts;

    }

    //generate benchmarks with the members generated from the generateMembers method
   public static List<Benchmark__c> generateBenchmarks(Integer numOfBenchMarks, List<Member__c> members){
       List<Benchmark__c> benchmarks = new List<Benchmark__c>();
       
         for(Member__c m: members){
           for(Integer j = 1; j < numOfBenchMarks; j++){
              Benchmark__c b = new Benchmark__c();
              b.Name = 'Test benchmark ' + j;
              b.Member__c = m.Name;
              b.Weight__c = m.Weight__c;
              b.BMI__c = m.BMI__c;
              b.Fitness_Level__c = m.Fitness_Level__c;
              benchmarks.add(b);
           }
         }

         insert benchmarks;

         return benchmarks;
   }

    //generates a Member with specified Name, dob, fitness-level & training-class
    public static Member__c generateMember(String memName, Date dob, String fitnessLevel, String trainingClass){
         Member__c member = new Member__c();
         member.Name = memName;
         member.Date_of_Birth__c = dob;
         member.Fitness_Level__c = fitnessLevel;
         member.Training_Class__c = trainingClass;

         insert member;
         return member;

   }
    
    //generates a Workout with specified Name, dob, fitness-level(look-up relationship) & training-class
    public static Workout__c generateWorkout(String workoutName, Date workoutDate, String fitnessLevel, String trainingClass){
            Workout__c workout = new Workout__c();
            workout.Name = workoutName;
            workout.Date__c = workoutDate;
            workout.Fitness_Level__c = fitnessLevel;
            workout.Training_Class__c = trainingClass;

            insert workout;

            return workout;
    }



   //generates a benchmark with specified Name & a member with goals assosiated to the benchmark
   public static Benchmark__c generateBenchmark(String benchMarkName, ID memberID, Integer weight){  
             Member__c m = [SELECT Name FROM Member__c WHERE Id=:memberID];       
             Benchmark__c b = new Benchmark__c();
             b.Name = benchMarkName;
             b.Weight__c = weight;
             b.Member__r = m;
            insert b;
            return b;
   }

   //add details regarding specific lifts to members benchmark
   public static void generateMemberLifts(Benchmark__c benchmark, Integer backSquat, Integer benchPress, Integer shoulderPress){
       List<Benchmark__c> benchmarkList = new List<Benchmark__c>();

       try{
            benchmarkList = [SELECT Id from Benchmark__c where Id =: benchmark.id LIMIT 1];
            
            if(benchmarkList.size() > 0){
                 benchmarkList[0].Back_Squat__c = backSquat;
                 benchmarkList[0].Bench_Press__c = benchPress;
                 benchmarkList[0].Back_Squat__c = shoulderPress;
                 update benchmarkList;
             }
          }catch(DmlException e){
              System.debug(e.getMessage());
          }
          finally{
              update benchmarkList;
          }

   }

   //set benchmark to a goal benchmark
   public static void setGoalBenchmark(Benchmark__c benchmark){
         if(benchmark.Goal_Benchmarks__c == false){
             benchmark.Goal_Benchmarks__c = true;
             update benchmark;
         }
   }
}
