public with sharing class ScoreTriggerUtility {
  public static void createRelatedBenchmark(List<Score__c> scores) {
    Map<String, String> liftMap = new Map<String, String>{
      'Back Squat' => 'Back_Squat__c',
      'Deadlift' => 'Deadlift__c',
      'Bench Press' => 'Bench_Press__c',
      'Shoulder Press' => 'Shoulder_Press__c'
    };
    List<Member__c> members = new List<Member__c>();
    List<Id> memberIds = new List<Id>();
    Map<Id, Member__c> memberMap = new Map<Id, Member__c>();
    for (Score__c s : scores) {
      memberIds.add(s.Member__c);
    }
    for (AggregateResult a : [
      SELECT Member__r.Id, Max(Weight__c) MaxWeight, Strength_Type__c
      FROM Score__c
      WHERE
        Member__c IN :memberIds
        AND Strength_Reps__c = 1
        AND Workout_Date__c >= :Date.Today().addDays(-90)
      GROUP BY Strength_Type__c, Member__r.Id
    ]) {
      Member__c m = memberMap.containsKey(a.Id)
        ? memberMap.get(a.Id)
        : new Member__c(Id = a.Id);

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
      Member__c member = memberMap.get(s.Member__c);
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
