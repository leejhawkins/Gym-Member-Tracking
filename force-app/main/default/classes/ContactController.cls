/**
 * @description       : Create member records each time a member object is inserted.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-30-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-30-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class ContactController {
    
    public static void createMemberRecords(List<Member__c> members) {
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Gym_Member').getRecordTypeId();
        List<Contact> contacts = new List<Contact>();

        for(Member__c m: members) {
            Contact contact = new Contact(LastName=m.Name, Birthdate=m.Date_of_Birth__c, Email=m.Email__c);
            contact.RecordTypeId =  devRecordTypeId;
            contacts.add(contact);
        }
        
        insert contacts;
    }
    
}

  

