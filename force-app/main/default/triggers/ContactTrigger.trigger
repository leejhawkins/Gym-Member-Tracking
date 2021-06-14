/**
 * @description       : Contact trigger
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-30-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
trigger ContactTrigger on Contact (after insert, before insert, before update) {
   
  if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
    ContactTriggerUtility.fitnessLevel(Trigger.new);
  }
  
}