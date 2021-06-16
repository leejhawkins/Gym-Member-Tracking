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
        WHERE Member__c = :memberId
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
      Member__c = memberId,
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
}
