/**
 * @description       : Changed from Apex to Workflow
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class MailToNewMemberTest {
  /*
  @TestSetup
  static void makeData() {
    Member__c m = new Member__c();
    m.LastName = 'Bob';
    m.Birthdate = Date.today();
    m.Email = 'kareemthedeveloper' + 1 + '@gmail.com';
    insert m;

    List<Member__c> newMembers = TestDataFactory.generateMembers(5);
    Integer counter = 1;
    for (Member__c member : newMembers) {
      member.Email = 'kareemfullstackdev' + counter + '@gmail.com';
    }
    insert newMembers;
  }
  @isTest
  public static void baseTest() {
    Test.startTest();
    List<Member__c> newMember = [
      SELECT Name, Email
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
        SELECT Name, Email
        FROM Member__c
        WHERE Name LIKE 'Test member'
      ];
      MailToNewMember.sendWelcomeEmail(newMembers);
    } catch (LimitException e) {
      System.debug(e.getMessage());
    }
    Test.stopTest();
  }
  */
}
