/*
    a class to make a GET Api call to the openweathermap api. Method performs a call, 
    gets the response. Uses the JSON2Apex class to get the data. Then data gets serialized 
    to be processed by the JS class in the LWC
*/
public class MemberCallouts {
    
    //GET method to fetch data from the openweathermap API
    @AuraEnabled(cacheable =true)
    public static String makeGetCallout(Id memberId) {
       Member__c member = new Member__c();
       member = [SELECT Id, City__c FROM Member__c WHERE Id=:memberId];

       
       String memberCity = member.City__c;
       String apiKey = '4ef90ad4a7e5df0276f8920bcb07d888';

       String requestEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
       requestEndPoint+='?q='+memberCity;
       requestEndPoint+='&units=metric';
       requestEndPoint+='&APPID='+apiKey;

       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint(requestEndPoint);
       request.setMethod('GET');
       HttpResponse response = http.send(request);
       JSON2Apex parsedResult = JSON2Apex.parse(response.getBody());
       String jsonString = JSON.serialize(parsedResult);
       return jsonString;
  
    }


}

