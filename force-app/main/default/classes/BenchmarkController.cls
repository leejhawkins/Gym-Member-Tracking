public inherited sharing class BenchmarkController {
    @AuraEnabled(cacheable=true)
    public static Map<String,Benchmark__c> getBenchmarks(Id memberId) {
            Map<String,Benchmark__c> bens = new Map<String,Benchmark__c>();
            Member__c gender = [Select Gender__c from Member__c Where Id=:memberId] != null ?
                [Select Gender__c from Member__c Where Id=:memberId] : new Member__c(Gender__c='Male');
            Benchmark__c currentBenchmark = BenchmarkTriggerUtility.getMostRecent(memberId, Date.Today());
            System.debug(currentBenchmark);
            bens.put('Current',currentBenchmark);
            Benchmark__c gb = LiftStandardsController.getNextLevel(currentBenchmark,gender.Gender__c);
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
