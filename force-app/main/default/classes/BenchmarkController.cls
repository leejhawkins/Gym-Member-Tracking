public inherited sharing class BenchmarkController {
    @AuraEnabled(cacheable=true)
    public static Map<String,Benchmark__c> getBenchmarks(Id memberId) {
            Map<String,Benchmark__c> bens = new Map<String,Benchmark__c>();
            Benchmark__c cb = (Integer)[SELECT count() FROM Benchmark__c WHERE Member__c=:memberId AND Date__c <=:Date.today().addDays(1)] !=0 ?
            [SELECT Back_Squat__c,Deadlift__c,Bench_Press__c,Shoulder_Press__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId

                AND Date__c <=:Date.today().addDays(1) ORDER BY Date__c DESC LIMIT 1] : new Benchmark__c(Back_Squat__c=0,Deadlift__c=0,Bench_Press__c=0,Shoulder_Press__c=0);
            bens.put('Current',cb);
            Benchmark__c gb = (Integer)[SELECT count() FROM Benchmark__c WHERE Member__c=:memberId AND Goal_Benchmarks__c=true] != 0 ?
            [SELECT Back_Squat__c,Deadlift__c,Bench_Press__c,Shoulder_Press__c
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Goal_Benchmarks__c = true LIMIT 1]:new Benchmark__c(Back_Squat__c=0,Deadlift__c=0,Bench_Press__c=0,Shoulder_Press__c=0);
            bens.put('Goal',gb);
            return bens;

    }
    //method used in the displayMemberBenchmark LWC
    @AuraEnabled(cacheable=true)
    public static Benchmark__c getBenchmark(Id memberId){
        return [SELECT Back_Squat__c,Deadlift__c,
                Bench_Press__c, Shoulder_Press__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Goal_Benchmarks__c != true LIMIT 1];
    }
    @AuraEnabled(cacheable=true)
    public static Benchmark__c getGoalBenchmark(Id memberId){
        return [SELECT Back_Squat__c,Deadlift__c,
                Bench_Press__c, Shoulder_Press__c 
                FROM Benchmark__c 
                WHERE Member__c=:memberId
                AND Goal_Benchmarks__c = true LIMIT 1];
    }
}
