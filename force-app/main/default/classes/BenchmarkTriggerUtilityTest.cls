/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-04-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public inherited sharing class BenchmarkTriggerUtilityTest {
  /*
  @TestSetup
  static void makeData() {
    insert new Contact(
      Name = 'Test Member',
      Height_Feet__c = 5,
      Height_Inches__c = 6,
      Date_of_Birth__c = Date.newInstance(1980, 3, 1)
    );
    insert new Contact(
      name = 'Tester',
      Date_of_Birth__c = Date.today(),
      Height_Feet__c = 6,
      Height_Inches__c = 5
    );
    Contact m = [SELECT Id FROM Contact WHERE Name = 'Test Member'];
    Contact m2 = [SELECT Id FROM Contact WHERE Name = 'Tester'];
    insert new Benchmark__c(
      Name = 'Tester Benchmark',
      Weight__c = 180,
      Contact = m2.id
    );
    insert new Benchmark__c(
      Name = 'Goal Benchmark',
      Deadlift__c = 400,
      Bench_Press__c = 250,
      Shoulder_Press__c = 175,
      Back_Squat__c = 350,
      Weight__c = 165,
      Contact = m.id,
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
      Contact = m.id
    );
    insert new Benchmark__c(
      Name = 'March Benchmark',
      Date__c = Date.newInstance(2021, 3, 1),
      Deadlift__c = 450,
      Contact = m.id
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
    Contact m = [
      SELECT Fitness_level__c
      FROM Contact
      WHERE Name = 'Test Member'
    ];
    System.assertEquals(m.Fitness_Level__c, 'Intermediate');
  }
  @isTest
  static void getCurrentBenchmarkTest() {
    Contact m = [SELECT Id FROM Contact WHERE Name = 'Test Member'];
    Benchmark__c b = BenchmarkTriggerUtility.getMostRecent(m.id, Date.today());
    System.assertEquals('Robust-Benchmark 0', b.Name);
  }
  @isTest
  public static void performCalculations() {
    Contact member = [
      SELECT name, BMI__c
      FROM Contact
      WHERE Name = 'Tester'
    ];
    System.assertEquals(21.344648525019768, member.BMI__c);
  }
  */
}
