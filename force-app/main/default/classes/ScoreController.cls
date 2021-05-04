public inherited sharing class ScoreController {
  @AuraEnabled(cacheable=true)
  public static Map<String, Id> getScoreRecordTypes() {
    try {
      List<RecordType> types = [
        SELECT Id, Name
        FROM RecordType
        WHERE SObjectType = 'Score__c'
      ];
      Map<String, Id> scoreMap = new Map<String, Id>();
      for (RecordType rt : types) {
        scoreMap.put(rt.Name, rt.Id);
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
}
