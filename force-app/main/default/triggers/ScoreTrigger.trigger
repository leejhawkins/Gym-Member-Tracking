trigger ScoreTrigger on Score__c(after insert, after update) {
  if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
    ScoreTriggerUtility.createRelatedBenchmark(Trigger.new);
  }
}
