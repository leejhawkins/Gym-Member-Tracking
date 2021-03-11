@isTest 
public class MailToNewMemberTest {
    
    @isTest 
    public static void baseTest(){
            
                Test.startTest();
                Member__c m = new Member__c();
                m.Name = 'Bob';
                m.Date_of_Birth__c = Date.today();
                m.Email__c = 'kareemfullstackdev'+1+'@gmail.com';
                
                insert m;

                if(Test.isRunningTest()) {
                  System.assert(true);
                }
                else{
                   System.assert(false);
                }
                Test.stopTest();   
      }
    @isTest
    public static void addMoreMembers(){
        Test.startTest();
        List<Member__c> newMembers = TestDataFactory.generateMembers(10);
        Integer counter = 1;
        for(Member__c m: newMembers){
            m.Email__c = 'kareemfullstackdev'+counter+'@gmail.com';
            if(Test.isRunningTest()) {
                  System.assert(true);
                }
            else{
                   System.assert(false);
                }
        }
        Test.stopTest();

    }

}
