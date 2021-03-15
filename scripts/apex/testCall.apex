Member__c testMember = new Member__c();
testMember = [SELECT Id, Name FROM Member__c WHERE Name LIKE 'Rahul V'];
Id memberId = testMember.Id;
MemberCallouts.makeGetCallout(memberId);
