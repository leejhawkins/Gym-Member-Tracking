/*
   Created by Kareem El Sayed
   a class to get the details of the members from the org to the Gym manager
*/
public inherited sharing class ContactController {
  @AuraEnabled(cacheable=true)
  public static List<Contact> findMembers(String searchKey) {
    String key = '%' + searchKey + '%';
    return [
      SELECT Id, Name, Fitness_Level__c
      FROM Contact
      WHERE Name LIKE :key
    ];
  }

  @AuraEnabled(cacheable=true)
  public static Contact getMember(Id userId) {
    User u = [SELECT Id, Email FROM User WHERE Id = :userId LIMIT 1];
    return [SELECT Id, Name FROM Contact WHERE Email = :u.Email LIMIT 1];
  }
}