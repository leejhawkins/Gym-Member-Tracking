/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-14-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class ContactTriggerUtility {
    
}
 public static void fitnessLevel(List<Contact> members) {
    for (Contact m : members) {
      m.Fitness_Level__c = LiftStandardsController.getFitnessLevel(m);
    }
    
  }