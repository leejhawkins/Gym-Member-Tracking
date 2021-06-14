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
public class MailToNewMemberTest {
  /*
  @TestSetup
  static void makeData() {
    Contact m = new Contact();
    m.LastName = 'Bob';
    m.Birthdate = Date.today();
    m.Email = 'kareemthedeveloper' + 1 + '@gmail.com';
    insert m;

    List<Contact> newMembers = TestDataFactory.generateMembers('Gym Member',5);
    Integer counter = 1;
    for (Contact member : newMembers) {
      member.Email = 'kareemfullstackdev' + counter + '@gmail.com';
    }
    insert newMembers;
  }
  @isTest
  public static void baseTest() {
    Test.startTest();
    List<Contact> newMember = [
      SELECT LastName, Email
      FROM Contact
      WHERE LastName LIKE 'Bob'
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
      List<Contact> newMembers = [
        SELECT LastName, Email
        FROM Contact
        WHERE LastName LIKE 'Test member'
      ];
      MailToNewMember.sendWelcomeEmail(newMembers);
    } catch (LimitException e) {
      System.debug(e.getMessage());
    }
    Test.stopTest();
  }
  */
}
