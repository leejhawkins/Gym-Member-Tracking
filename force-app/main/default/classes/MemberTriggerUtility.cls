public inherited sharing class MemberTriggerUtility {
  public static void fitnessLevel(List<Member__c> members) {
    for (Member__c m : members) {
      m.Fitness_Level__c = LiftStandardsController.getFitnessLevel(m);
    }
  }
}
