trigger BenchmarkTrigger on Benchmark__c (before insert,before update,after update,after insert) {
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        BenchmarkTriggerUtility.setBenchmarkEmptyFields(Trigger.New);
        BenchmarkTriggerUtility.fitnessLevel(Trigger.New);
        BenchmarkTriggerUtility.BMICalculator(Trigger.New);
    }
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isAfter){
        BenchmarkTriggerUtility.isGoalBenchmark(Trigger.New);
        BenchmarkTriggerUtility.isCurrentBenchmark(Trigger.New);
    }
}