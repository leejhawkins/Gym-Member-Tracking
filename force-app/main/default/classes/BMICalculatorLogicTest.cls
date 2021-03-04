/*
   Created by Kareem El Sayed
   Test class to test if the BMI calculations are performed
*/
@isTest public inherited sharing class BMICalculatorLogicTest {
    @TestSetup
    static void makeData(){
       Member__c m = new Member__c(name = 'Tester', Date_of_Birth__c = Date.today(), Weight__c = 180, Height_Feet__c = 6, Height_Inches__c=5);
       insert m;
    }
    @isTest
    public static void performCalculations(){
        List<Member__c> member = [select name, BMI__c from Member__c where name like 'Tester' limit 1];
        if(member.size() > 0){
            System.assertEquals(21.344648525019768, member[0].BMI__c);
        }
    }
}
