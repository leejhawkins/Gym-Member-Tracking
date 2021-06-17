public inherited sharing class ContactTriggerUtility {
  public static void fitnessLevel(List<Contact> members) {
    for (Contact m : members) {
      m.Fitness_Level__c = LiftStandardsController.getFitnessLevel(m);
    }
  }
}
