trigger MemberTrigger on Member__c (after insert) {
     if(Trigger.isAfter){
         MailToNewMember.sendWelcomeEmail(Trigger.new);
     }
    
    /*
    if(Trigger.isInsert && Trigger.isBefore){
        //MemberTriggerUtility.lookupOnInsert(Trigger.new);
     }
     if(Trigger.isUpdate && Trigger.isBefore){
         //MemberTriggerUtility.checkAssignment(Trigger.new);
         //MemberTriggerUtility.checkBenchmarkType(Trigger.new);
     }
     */
}