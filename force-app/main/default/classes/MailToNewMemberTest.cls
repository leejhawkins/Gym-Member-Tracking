@isTest
public class MailToNewMemberTest {
  @TestSetup
  static void makeData() {
    Member__c m = new Member__c();
    m.Name = 'Bob';
    m.Date_of_Birth__c = Date.today();
    m.Email__c = 'kareemthedeveloper' + 1 + '@gmail.com';
    insert m;

    List<Member__c> newMembers = TestDataFactory.generateMembers(5);
    Integer counter = 1;
    for (Member__c member : newMembers) {
      member.Email__c = 'kareemfullstackdev' + counter + '@gmail.com';
    }
    insert newMembers;
  }
  @isTest
  public static void baseTest() {
    Test.startTest();
    List<Member__c> newMember = [
      SELECT Name, Email__c
      FROM Member__c
      WHERE Name LIKE 'Bob'
      LIMIT 1
    ];

    if (newMember.size() > 0) {
      MailToNewMember.sendWelcomeEmail(newMember);
    } else {
      System.assert(false);
    }

    Test.stopTest();
  }

  @isTest
  public static void addMembersTest() {
    Test.startTest();
    try {
      List<Member__c> newMembers = [
        SELECT Name, Email__c
        FROM Member__c
        WHERE Name LIKE 'Test member'
      ];
      MailToNewMember.sendWelcomeEmail(newMembers);
    } catch (LimitException e) {
      System.debug(e.getMessage());
    }
    Test.stopTest();
  }
}
