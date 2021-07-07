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
trigger ScoreTrigger on Score__c(after insert, after update) {
  if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
    ScoreTriggerUtility.setMemberLifts(Trigger.new);
  }
}
