public inherited sharing class BenchmarkController {
    @AuraEnabled(cacheable=true)
    public static Benchmark__c getCurrentBenchmark(Id memberId) {
            Date dB = Date.today().toStartOfMonth();
            Date dU = Date.Today().addMonths(1).toStartofMonth();
            return [SELECT Back_Squat__c,Deadlift__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Date__c >=:dB
                AND Date__c <:dU];
    }
    @AuraEnabled(cacheable=true)
    public static Benchmark__c getGoalBenchmark(Id memberId) {
            return [SELECT Back_Squat__c,Deadlift__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Goal_Benchmarks__c = true];
    }
}
