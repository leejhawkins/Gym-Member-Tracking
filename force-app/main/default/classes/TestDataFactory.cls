/*
   Created by Kareem El Sayed
   a data factory class to be used in Test classes
*/
@isTest
public inherited sharing class TestDataFactory {
  // methods to create records and populate the required fields
  public static List<Contact> generateMembers(Integer numOfMembers) {
    List<Contact> members = new List<Contact>();
    for (Integer i = 0; i < numOfMembers; i++) {
      Contact m = new Contact();
      m.LastName = 'Test member ' + i;
      m.Birthdate = Date.today();
      members.add(m);
    }
    //insert members;

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

    //insert workouts;

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

      b.Date__c = Date.today();
      benchmarks.add(b);
    }

    //insert benchmarks;

    return benchmarks;
  }

  //methods to create records with specified fields
  public static List<Contact> generateMembers(
    String email,
    String fitnessLevel,
    String trainingClass,
    String issues,
    Integer membersNum
  ) {
    List<Contact> members = new List<Contact>();
    for (Integer i = 0; i < membersNum; i++) {
      Contact member = new Contact();
      member.LastName = 'Robust-Test-Member ' + i;
      member.Birthdate = Date.today();
      member.Email = email;

      member.Fitness_Level__c = fitnessLevel;
      members.add(member);
    }
    //insert members;
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

    //insert workouts;

    return workouts;
  }

  public static void generateBenchmarks(Contact member, Integer numBenchMarks) {
    List<Benchmark__c> benchmarks = new List<Benchmark__c>();

    for (Integer i = 0; i < numBenchMarks; i++) {
      Benchmark__c b = new Benchmark__c();
      b.Deadlift__c = 350 + i;
      b.Bench_Press__c = 250 + 1;
      b.Shoulder_Press__c = 175 + i;
      b.Back_Squat__c = 350 + i;
      b.Name = 'Robust-Benchmark ' + i;
      b.Member__c = member.Id;
      b.Date__c = Date.today().addDays(-i);
      benchmarks.add(b);
      insert b;
    }
  }
}
