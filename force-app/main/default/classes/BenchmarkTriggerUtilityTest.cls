@isTest
public inherited sharing class BenchmarkTriggerUtilityTest {
    @TestSetup
    static void makeData(){
        insert new Member__c(Name='Test Member',Height_Feet__c=5,Height_Inches__c=6,Date_of_Birth__c = Date.newInstance(1980, 3, 1));
        Id id = [Select Id from Member__c where Name ='Test Member'].Id;
        insert new Benchmark__c(Name='Goal Benchmark',
            Deadlift__c = 400,
            Bench_Press__c = 250,
            Shoulder_Press__c = 175,
            Back_Squat__c =350,
            Weight__c = 165,
            Member__c = id,
            Goal_Benchmarks__c = true);
        insert new Benchmark__c(Name='March Benchmark',
            Date__c = Date.newInstance(2021,3,1),
            Deadlift__c = 400,
            Bench_Press__c = 250,
            Shoulder_Press__c = 175,
            Back_Squat__c =350,
            Weight__c = 165,
            Member__c = id);
        insert new Benchmark__c(Name='February Benchmark',
            Date__c = Date.newInstance(2021,2,1),
            Deadlift__c = 400,
            Bench_Press__c = 250,
            Shoulder_Press__c = 175,
            Back_Squat__c =350,
            Weight__c = 165,
            Member__c = id);
    }
    @isTest
    static void isGoalBenchmarkTest(){
        Member__c m = [Select Goal_Benchmark__c from Member__c where Name ='Test Member'];
        Benchmark__c b = [Select Id from Benchmark__c where Name='Goal Benchmark'];
        System.assertEquals(m.Goal_Benchmark__c,b.Id);
    }
    @isTest 
    static void isCurrentBenchmarkTest(){
        Member__c m = [Select Current_Benchmark__c from Member__c where Name ='Test Member'];
        Benchmark__c b = [Select Id from Benchmark__c where Name='March Benchmark'];
        System.assertEquals(m.Current_Benchmark__c,b.Id);
    }
    @isTest
    static void isNotCurrentBenchmarkTest(){
        Member__c m = [Select Current_Benchmark__c from Member__c where Name ='Test Member'];
        Benchmark__c b = [Select Id from Benchmark__c where Name='February Benchmark'];
        System.assert(m.Current_Benchmark__c != b.Id);
    }
}
