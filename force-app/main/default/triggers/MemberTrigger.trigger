trigger MemberTrigger on Member__c (before insert) {
     if(Trigger.isInsert){
         BMICalculatorLogic.getAllMembers(Trigger.new);
     }
}