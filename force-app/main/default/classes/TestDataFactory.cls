/*
   Created by Kareem El Sayed
   a data factory class to be used in Test classes
*/
@isTest public inherited sharing class TestDataFactory {
   public static void createMembers(){
       List<Member__c> members = new List<Member__c>();
       for(Integer i = 0; i < 20; i++){
           Member__c m = new Member__c();
           m.Name = 'Test member ' + i;
           m.Date_of_Birth__c = Date.today();
           m.Fitness_Level__c = 'Beginner';
           m.Training_Class__c = 'Basic';
           members.add(m);
       }
       insert members;
   }
}
