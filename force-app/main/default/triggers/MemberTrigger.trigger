trigger MemberTrigger on Member__c(after insert, before insert, before update) {
  if (Trigger.isAfter && Trigger.isInsert) {
    MailToNewMember.sendWelcomeEmail(Trigger.new);
  }
  if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
    MemberTriggerUtility.fitnessLevel(Trigger.new);
  }

}
