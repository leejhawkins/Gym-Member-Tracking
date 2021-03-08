trigger MemberTrigger on Member__c (before insert,before update) {
     if(Trigger.isInsert && Trigger.isBefore){
        //MemberTriggerUtility.lookupOnInsert(Trigger.new);
     }
     if(Trigger.isUpdate && Trigger.isBefore){
         //MemberTriggerUtility.checkAssignment(Trigger.new);
         //MemberTriggerUtility.checkBenchmarkType(Trigger.new);
     }
}