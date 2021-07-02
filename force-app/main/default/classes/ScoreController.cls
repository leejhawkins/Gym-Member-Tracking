public inherited sharing class ScoreController {
  @AuraEnabled(cacheable=true)
  public static Map<String, Id> getScoreRecordTypes() {
    try {
      List<Schema.RecordTypeInfo> rt = Score__c.SObjectType.getDescribe()
        .getRecordTypeInfos();
      Map<String, Id> scoreMap = new Map<String, Id>();
      for (Schema.RecordTypeInfo r : rt) {
        scoreMap.put(r.getName(), r.getRecordTypeId());
      }
      return scoreMap;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static Map<String, String> getScoresByMember(Id memberId) {
    try {
      Map<String, String> scoreMap = new Map<String, String>();
      List<Score__c> scores = [
        SELECT Id, Workout__c
        FROM Score__c
        WHERE Contact__c = :memberId
      ];

      for (Score__c s : scores) {
        scoreMap.put((String) s.Workout__c, (String) s.Id);
      }
      System.debug(scoreMap);
      return scoreMap;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled
  public static void insertScoreMemberWorkout(
    String name,
    Id memberId,
    Id workoutId,
    Integer weight,
    String key1,
    String value1,
    String key2,
    String value2,
    Id recordType
  ) {
    Score__c s = new Score__c(
      Name = name,
      Contact__c = memberId,
      Workout__c = workoutId,
      Weight__c = weight,
      RecordTypeId = recordType
    );
    s.put(key1, value1);
    s.put(key2, value2);
    try {
      insert s;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(cacheable=true)
  public static Map<String, List<Score__c>> getMonthlyScores(Id memberId){
    List<Score__c> monthlyScores = [Select Id, Strength_Type__c, Weight__c, Workout_Date__c FROM Score__c WHERE Workout_Date__c >=: Date.today().addMonths(-1) ORDER BY Workout_Date__c ASC];
    List<Score__c> bsScores = new List<Score__c>();
    List<Score__c> bpScores = new List<Score__c>();
    List<Score__c> dlScores = new List<Score__c>();
    List<Score__c> spScores = new List<Score__c>();
    for(Score__c s : monthlyScores){
      if(s.Strength_Type__c == 'Back Squat'){
        bsScores.add(s);
      }
      if(s.Strength_Type__c == 'Bench Press'){
        bpScores.add(s);
      }
      if(s.Strength_Type__c == 'Deadlift'){
        dlScores.add(s);
      }
      if(s.Strength_Type__c == 'Shoulder Press'){
        spScores.add(s);
      }
    }
    Map<String, List<Score__c>> scoreMap = new Map<String, List<Score__c>>();
    scoreMap.put('Back Squat', bsScores);
    scoreMap.put('Bench Press', bpScores);
    scoreMap.put('Deadlift', dlScores);
    scoreMap.put('Shoulder Press', spScores);
    return scoreMap;
  }
  @AuraEnabled(cacheable=true)
  public static Map<String, List<Score__c>> getAnnualScores(Id memberId){
    List<Score__c> monthlyScores = [Select Id, Strength_Type__c, Weight__c, Workout_Date__c FROM Score__c ORDER BY Workout_Date__c ASC];
    List<Score__c> bsScores = new List<Score__c>();
    List<Score__c> bpScores = new List<Score__c>();
    List<Score__c> dlScores = new List<Score__c>();
    List<Score__c> spScores = new List<Score__c>();
    for(Score__c s : monthlyScores){
      if(s.Strength_Type__c == 'Back Squat'){
        bsScores.add(s);
      }
      if(s.Strength_Type__c == 'Bench Press'){
        bpScores.add(s);
      }
      if(s.Strength_Type__c == 'Deadlift'){
        dlScores.add(s);
      }
      if(s.Strength_Type__c == 'Shoulder Press'){
        spScores.add(s);
      }
    }
    Map<String, List<Score__c>> scoreMap = new Map<String, List<Score__c>>();
    scoreMap.put('Back Squat', bsScores);
    scoreMap.put('Bench Press', bpScores);
    scoreMap.put('Deadlift', dlScores);
    scoreMap.put('Shoulder Press', spScores);
    return scoreMap;
  }
}
