/*
    a class to make a GET Api call to the openweathermap api. Method performs a call, 
    gets the response. Uses the JSON2Apex class to get the data. Then the data gets serialized 
    to be processed by the JS class in the LWC
*/
public class WebServiceLWC {
    @AuraEnabled (cacheable=true)
    public static String performCallout(Id recordId) {
       String ownerCity = 'London';
    
       String apiKey = '4ef90ad4a7e5df0276f8920bcb07d888';
       
       //https://api.openweathermap.org/data/2.5/forecast?q=Moscow&appid=... requestEndPoint to get the forecast 
       String requestEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
       requestEndPoint+='?q='+ownerCity;
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




