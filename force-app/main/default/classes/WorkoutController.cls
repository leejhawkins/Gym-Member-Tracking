public inherited sharing class WorkoutController {
    @AuraEnabled(cacheable=true)
    public static Workout__c getMemberWorkout(Id memberId,Date workoutDate){
        try {
            workoutDate = workoutDate != null ? workoutDate: Date.today();
            Member__c m = [Select Fitness_Level__c from Member__c Where Id=:memberId];
            return [SELECT Workout_Description__c,Fitness_Level__c,Id
            FROM Workout__c 
            WHERE Fitness_Level__c =:m.Fitness_Level__c
            AND Date__c =: workoutDate
            LIMIT 1];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Workout__c getAllWorkoutsForDay(Date workoutDate,String fitnessLevel){
        try {
            workoutDate = workoutDate != null ? workoutDate: Date.today();
            return [SELECT Workout_Description__c,Fitness_Level__c,Id,Date__c
            FROM Workout__c 
            WHERE
            Date__c =: workoutDate
            AND Fitness_Level__c LIKE :fitnessLevel
            LIMIT 1];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}
