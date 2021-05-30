/**
 * @description       : Changed send email action to use a workflow
 * @author            : Kareem@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-30-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-25-2021   Kareem@UserSettingsUnder.SFDoc   Initial Version
**/

trigger MemberTrigger on Member__c(after insert, after update) {
  
  if(Trigger.isInsert) {
    ContactController.createMemberRecords(Trigger.new);
  }

}
