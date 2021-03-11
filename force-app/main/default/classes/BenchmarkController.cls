public inherited sharing class BenchmarkController {
    @AuraEnabled(cacheable=true)
    public static Map<String,Benchmark__c> getBenchmarks(Id memberId) {
            Map<String,Benchmark__c> bens = new Map<String,Benchmark__c>();
            Date dB = Date.today().toStartOfMonth();
            Date dU = Date.Today().addMonths(1).toStartofMonth();
            Benchmark__c cb = [SELECT Back_Squat__c,Deadlift__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Date__c >=:dB
                AND Date__c <:dU LIMIT 1];
            bens.put('Current',cb);
            Benchmark__c gb = [SELECT Back_Squat__c,Deadlift__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Goal_Benchmarks__c = true LIMIT 1];
            bens.put('Goal',gb);
            return bens;

    }
}
