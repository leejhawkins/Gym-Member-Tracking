trigger ContactTrigger on Contact(after insert, before insert, before update) {
  if (Trigger.isAfter && Trigger.isInsert) {
    MailToNewMember.sendWelcomeEmail(Trigger.new);
  }
  if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)) {
    ContactTriggerUtility.fitnessLevel(Trigger.new);
  }

}
