/**
 * @description       : Create member records each time a member object is inserted.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-30-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class ContactController {
     @AuraEnabled(cacheable=true)
     public static Map<Id, Contact> findMembers(String searchKey) {
         Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Gym_Member').getRecordTypeId();
         String key = '%' + searchKey + '%';
         
         Map<Id, Contact> results = new Map<Id, Contact>([
           SELECT Id, Name, Fitness_Level__c, Training_Class__c
           FROM Contact
           WHERE Name LIKE :key AND RecordTypeId =: devRecordTypeId
         ]); 
         
         
         return results;
      }

       @AuraEnabled(cacheable=true)
  public static Contact getMember(Id userId){
    User u = [
     SELECT Id, Email
     FROM User 
     WHERE Id=: userId Limit 1];
    return [
      SELECT Id, Name 
      FROM Contact
      WHERE Email =:u.Email Limit 1
    ];
  }
}

  

