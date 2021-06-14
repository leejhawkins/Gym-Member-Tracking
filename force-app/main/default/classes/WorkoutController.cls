/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-04-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public inherited sharing class WorkoutController {
  @AuraEnabled(cacheable=true)
  public static Workout__c getMemberWorkout(Id memberId, Date workoutDate) {
    try {
      workoutDate = workoutDate != null ? workoutDate : Date.today();
      Contact m = [
        SELECT Fitness_Level__c
        FROM Contact
        WHERE Id = :memberId
        LIMIT 1
      ];
      m.Fitness_Level__c = m.Fitness_Level__c == 'Novice'
        ? 'Beginner'
        : m.Fitness_Level__c;
      return [
        SELECT Workout_Description__c, Fitness_Level__c, Id
        FROM Workout__c
        WHERE Fitness_Level__c = :m.Fitness_Level__c AND Date__c = :workoutDate
        LIMIT 1
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static List<Workout__c> getAllWorkoutsForDay(Date workoutDate) {
    try {
      return [
        SELECT Workout_Description__c, Fitness_Level__c, Id, Date__c, Type__c
        FROM Workout__c
        WHERE Date__c = :workoutDate
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static Workout__c getWorkoutById(Id workoutId) {
    try {
      return [
        SELECT Fitness_Level__c, Id, Date__c
        FROM Workout__c
        WHERE Id = :workoutId
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static void cloneWorkout(
    Id workoutId,
    String workoutName,
    Date workoutDate
  ) {
    try {
      Workout__c w = [
        SELECT
          Id,
          Date__c,
          Fitness_Level__c,
          Training_Class__c,
          Issues__c,
          Workout_Description__c
        FROM Workout__c
        WHERE Id = :workoutId
      ];

      workoutName = workoutName != null ? workoutName : w.Name;
      workoutDate = workoutDate != null ? workoutDate : Date.today();

      Workout__c clone = new Workout__c(
        Name = workoutName,
        Date__c = workoutDate
      );

      clone.Fitness_Level__c = w.Fitness_Level__c;
      clone.Training_Class__c = w.Training_Class__c;
      clone.Issues__c = w.Issues__c;
      clone.Workout_Description__c = w.Workout_Description__c;

      insert clone;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
