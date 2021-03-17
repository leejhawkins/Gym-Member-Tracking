@isTest
public inherited sharing class BenchmarkTriggerUtilityTest {
  @TestSetup
  static void makeData() {
    insert new Member__c(
      Name = 'Test Member',
      Height_Feet__c = 5,
      Height_Inches__c = 6,
      Date_of_Birth__c = Date.newInstance(1980, 3, 1)
    );
    insert new Member__c(
      name = 'Tester',
      Date_of_Birth__c = Date.today(),
      Height_Feet__c = 6,
      Height_Inches__c = 5
    );
    Member__c m = [SELECT Id FROM Member__c WHERE Name = 'Test Member'];
    Member__c m2 = [SELECT Id FROM Member__c WHERE Name = 'Tester'];
    insert new Benchmark__c(
      Name = 'Tester Benchmark',
      Weight__c = 180,
      Member__c = m2.id
    );
    insert new Benchmark__c(
      Name = 'Goal Benchmark',
      Deadlift__c = 400,
      Bench_Press__c = 250,
      Shoulder_Press__c = 175,
      Back_Squat__c = 350,
      Weight__c = 165,
      Member__c = m.id,
      Goal_Benchmarks__c = true
    );
    insert new Benchmark__c(
      Name = 'February Benchmark',
      Date__c = Date.newInstance(2021, 2, 1),
      Deadlift__c = 350,
      Bench_Press__c = 250,
      Shoulder_Press__c = 175,
      Back_Squat__c = 350,
      Weight__c = 165,
      Member__c = m.id
    );
    insert new Benchmark__c(
      Name = 'March Benchmark',
      Date__c = Date.newInstance(2021, 3, 1),
      Deadlift__c = 450,
      Member__c = m.id
    );
    TestDataFactory.generateBenchmarks(m, 5);
  }
  @isTest
  static void setEmptyBenchmarkFieldsTest() {
    Benchmark__c b = [
      SELECT Id, Bench_Press__c, Shoulder_Press__c, Back_Squat__c
      FROM Benchmark__c
      WHERE Name = 'March Benchmark'
    ];
    System.assertEquals(b.Bench_Press__c, 250);
    System.assertEquals(b.Back_Squat__c, 350);
    System.assertEquals(b.Shoulder_Press__c, 175);
  }
  @isTest
  static void fitnessLevelTest() {
    Member__c m = [
      SELECT Fitness_level__c
      FROM Member__c
      WHERE Name = 'Test Member'
    ];
    System.assertEquals(m.Fitness_Level__c, 'Intermediate');
  }
  @isTest
  static void getCurrentBenchmarkTest() {
    Member__c m = [SELECT Id FROM Member__c WHERE Name = 'Test Member'];
    Benchmark__c b = BenchmarkTriggerUtility.getMostRecent(m.id, Date.today());
    System.assertEquals('Robust-Benchmark 0', b.Name);
  }
  @isTest
  public static void performCalculations() {
    Member__c member = [
      SELECT name, BMI__c
      FROM Member__c
      WHERE Name = 'Tester'
    ];
    System.assertEquals(21.344648525019768, member.BMI__c);
  }
}
