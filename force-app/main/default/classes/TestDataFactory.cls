/*
   Created by Kareem El Sayed
   a data factory class to be used in Test classes
*/
@isTest
public inherited sharing class TestDataFactory {
  //methods to create records and populate the required fields
  public static List<Contact> generateContacts(String recTypeName, Integer numOfMembers) {
    Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(recTypeName).getRecordTypeId();
    List<Contact> members = new List<Contact>();
    for (Integer i = 0; i < numOfMembers; i++) {
        Contact member = new Contact();
        member.LastName = 'Member ' + i;
        member.FirstName = 'Test';
        member.Birthdate = Date.today();
        member.RecordTypeId = devRecordTypeId;
        members.add(member);
    }
    
    return members;
  }

  public static List<Workout__c> generateWorkouts(Integer numOfWorkouts) {
    List<Workout__c> workouts = new List<Workout__c>();
    Integer i = 0;
    while (i < numOfWorkouts) {
      Workout__c workout = new Workout__c();
      workout.Name = 'Test workout ' + i;
      workout.Date__c = date.today();
      workouts.add(workout);
      i += 1;
    }

    

    return workouts;
  }

  public static List<Benchmark__c> generateBenchmarks(
    Integer numOfBenchMarks,
    Contact member
  ) {
    List<Benchmark__c> benchmarks = new List<Benchmark__c>();

    for (Integer j = 1; j < numOfBenchMarks; j++) {
      Benchmark__c b = new Benchmark__c();
      b.Name = 'Test benchmark ' + j;
      b.Gym_Member__c = member.Name;
      b.Date__c = Date.today();
      benchmarks.add(b);
    }

    

    return benchmarks;
  }

  public static List<Account> generateAccounts(String recTypeName, Integer numAccts) {
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recTypeName).getRecordTypeId();
    List<Account> accounts = new List<Account>();

    for(Integer i = 0; i < numAccts; i++) {
       Account a = new Account();
       a.Name = 'Test-Account ' + i;
       accounts.add(a);
    }

    return accounts;
  }
 
  //methods to create records with specified fields
  public static List<Contact> generateMembers(
    String email,
    String fitnessLevel,
    String trainingClass,
    String issues,
    Integer membersNum
  ) {
    Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Gym Member').getRecordTypeId();
    List<Contact> members = new List<Contact>();
    for (Integer i = 0; i < membersNum; i++) {
      Contact member = new Contact();
      member.LastName = 'Test-Member ' + i;
      member.FirstName = 'Robust-';
      member.Birthdate = Date.today();
      member.Email = email;
      member.Issues__c = issues;
      member.Fitness_Level__c = fitnessLevel;
      member.Training_Class__c = trainingClass;
      members.add(member);
    }
    
    return members;
  }

  public static List<Workout__c> generateWorkouts(
    Date workoutDate,
    String fitnessLevel,
    String trainingClass,
    String description,
    String issues,
    Integer numWorkouts
  ) {
    List<Workout__c> workouts = new List<Workout__c>();

    for (Integer i = 0; i < numWorkouts; i++) {
      Workout__c workout = new Workout__c();
      workout.Name = 'Robust-workout ' + i;
      workout.Date__c = workoutDate;
      workout.Fitness_Level__c = fitnessLevel;
      workout.Training_Class__c = trainingClass;
      workout.Issues__c = issues;
      workout.Workout_Description__c = description;
      workouts.add(workout);
    }

    return workouts;
  }

  //Avoid DML statements in this class since its a costly transaction 
  public static void generateBenchmarks(
    Contact member,
    Integer numBenchMarks
  ) {
    List<Benchmark__c> benchmarks = new List<Benchmark__c>();

    for (Integer i = 0; i < numBenchMarks; i++) {
      Benchmark__c b = new Benchmark__c();
      b.Deadlift__c = 350 + i;
      b.Bench_Press__c = 250 + 1;
      b.Shoulder_Press__c = 175 + i;
      b.Back_Squat__c = 350 + i;
      b.Name = 'Robust-Benchmark ' + i;
      b.Gym_Member__c = member.Id;
      b.Date__c = Date.today().addDays(-i);
      benchmarks.add(b);
      insertBenchmark(b);
    }
  }
  //helper function to insert benchmarks
  public static void insertBenchmark(Benchmark__c b) {
        insert b;
  }


}
