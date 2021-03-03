public inherited sharing class WorkoutController {
    @AuraEnabled(cacheable=true)
    public static Workout__c getMemberWorkout(Id memberId,Date workoutDate){
        try {
            Member__c m = [Select Fitness_Level__c from Member__c Where Id=:memberId];
            return [SELECT Workout_Description__c,Fitness_Level__c
            FROM Workout__c 
            WHERE Fitness_Level__c =:m.Fitness_Level__c
            AND Date__c >: workoutDate.addDays(-1)
            AND Date__c <=: workoutDate
            LIMIT 1];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}
