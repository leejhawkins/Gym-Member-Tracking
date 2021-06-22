public with sharing class ScoreTriggerUtility {
  public static void createRelatedBenchmark(List<Score__c> scores) {
    Map<String, String> liftMap = new Map<String, String>{
      'Back Squat' => 'Back_Squat__c',
      'Deadlift' => 'Deadlift__c',
      'Bench Press' => 'Bench_Press__c',
      'Shoulder Press' => 'Shoulder_Press__c'
    };
    List<Contact> members = new List<Contact>();
    List<Id> memberIds = new List<Id>();
    Map<Id, Contact> memberMap = new Map<Id, Contact>();
    for (Score__c s : scores) {
      memberIds.add(s.Contact__c);
    }
    System.debug(scores);
    for (AggregateResult a : [
      SELECT Contact__r.Id, Max(Weight__c) MaxWeight, Strength_Type__c
      FROM Score__c
      WHERE
        Contact__c IN :memberIds
        AND Strength_Reps__c = 1
        AND Workout_Date__c >= :Date.Today().addDays(-90)
      GROUP BY Strength_Type__c, Contact__r.Id
    ]) {
      Contact m = memberMap.containsKey(a.Id)
        ? memberMap.get(a.Id)
        : new Contact(Id = a.Id);

      String liftField = liftMap.get((String) a.get('Strength_Type__c'));
      m.put(liftField, a.get('MaxWeight'));
      memberMap.put(a.id, m);
    }
    Map<Id, Score__c> relatedWorkoutMap = new Map<Id, Score__c>(
      [
        SELECT Id, Workout__r.Strength__c, Workout__r.Reps__c
        FROM Score__c
        WHERE Id IN :scores
      ]
    );
    for (Score__c s : scores) {
      Contact member = new Contact();
      if (memberMap.get(s.Contact__c) != null) {
        member = memberMap.get(s.Contact__c);
      } else {
        member.put('Id', s.Contact__c);
      }
      Score__c relatedWorkoutInfo = relatedWorkoutMap.get(s.Id);
      String liftField = liftMap.get(relatedWorkoutInfo.Workout__r.Strength__c);
      Decimal reps = relatedWorkoutInfo.Workout__r.Reps__c;
      Decimal weight = member.get(liftField) != null
        ? (Decimal) member.get(liftField)
        : 0;
      if (s.Weight__c >= weight && reps == 1) {
        member.put(liftField, s.Weight__c);
        members.add(member);
      }
    }
    update members;
  }
}
