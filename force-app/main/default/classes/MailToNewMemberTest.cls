@isTest
public class MailToNewMemberTest {
  @TestSetup
  static void makeData() {
    Contact m = new Contact();
    m.LastName = 'Bob';
    m.Birthdate = Date.today();
    m.Email = 'kareemthedeveloper' + 1 + '@gmail.com';
    insert m;

    List<Contact> newMembers = TestDataFactory.generateMembers(5);
    Integer counter = 1;
    for (Contact member : newMembers) {
      member.Email__c = 'kareemfullstackdev' + counter + '@gmail.com';
    }
    insert newMembers;
  }
  @isTest
  public static void baseTest() {
    Test.startTest();
    List<Contact> newMember = [
      SELECT Name, Email
      FROM Contact
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
      List<Contact> newMembers = [
        SELECT Name, Email
        FROM Contact
        WHERE Name LIKE 'Test member'
      ];
      MailToNewMember.sendWelcomeEmail(newMembers);
    } catch (LimitException e) {
      System.debug(e.getMessage());
    }
    Test.stopTest();
  }
}
