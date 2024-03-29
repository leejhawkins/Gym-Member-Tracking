/*

   Created by Kareem El Sayed
   a class to get the details of the members from the org to the Gym manager
*/
public class ContactController {
  @AuraEnabled(cacheable=true)
  public static List<Contact> findMembers(String searchKey) {
    String key = '%' + searchKey + '%';
    return [SELECT Id, Name FROM Contact WHERE Name LIKE :key];
  }

  @AuraEnabled(cacheable=true)
  public static User getMember(Id userId) {
    return [SELECT ContactId, Name FROM User WHERE Id = :userId LIMIT 1];
  }
}
