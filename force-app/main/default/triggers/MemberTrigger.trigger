trigger MemberTrigger on Member__c (before insert, before update) {
     if(Trigger.isInsert){
         BMICalculatorLogic.getAllMembers(Trigger.new);
     }
}