/**
 * @description       : Create member records each time a member object is inserted.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-30-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class ContactController {
     @AuraEnabled(cacheable=true)
     public static List<Contact> findMembers(String searchKey) {
         Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Gym_Member').getRecordTypeId();
         String key = '%' + searchKey + '%';

         return [
           SELECT Id, Name, Fitness_Level__c, Training_Class__c
           FROM Contact
           WHERE Name LIKE :key AND RecordTypeId =: devRecordTypeId
         ];
      }
}

  

