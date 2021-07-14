/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 06-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   06-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public inherited sharing class ContactTriggerUtility {
  public static void fitnessLevel(List<Contact> members) {
    for (Contact m : members) {
      m.Fitness_Level__c = LiftStandardsController.getFitnessLevel(m);
    }
  }
  public static void createUserForMember(List<Contact> members) {
    List<User> newMembers = new List<User>();
    String rt = Schema.getGlobalDescribe()
      .get('Contact')
      .getDescribe()
      .getRecordTypeInfosByName()
      .get('Gym Member')
      .getRecordTypeId();
    Profile p = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Customer Community Plus Login User'
      LIMIT 1
    ];
    for (Contact m : members) {
      if (m.RecordTypeId == rt) {
        User u = new User(
          Alias = m.FirstName.charAt(0) + m.LastName.abbreviate(4),
          Email = m.Email,
          EmailEncodingKey = 'UTF-8',
          FirstName = m.FirstName,
          LastName = m.LastName,
          LanguageLocaleKey = 'en_US',
          LocaleSidKey = 'en_US',
          ProfileId = p.Id,
          ContactId = m.Id,
          TimeZoneSidKey = 'America/Denver',
          Username = m.FirstName + '.' + m.LastName + '@benchmarkmemberhub.com',
          CommunityNickname = m.FirstName + ' ' + m.LastName
        );
        newMembers.add(u);
      }
    }
    if (newMembers.size() > 0)
      insert newMembers;
  }
}
