trigger MemberTrigger on Member__c(after insert) {
  if (Trigger.isAfter) {
    MailToNewMember.sendWelcomeEmail(Trigger.new);
  }

}
