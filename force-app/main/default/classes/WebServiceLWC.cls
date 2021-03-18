/*
    a class to make a GET Api call to the openweathermap api. Method performs a call, 
    gets the response. Uses the JSON2Apex class to get the data. Then the data gets serialized 
    to be processed by the JS class in the LWC
*/
public class WebServiceLWC {
    
    private static String ownerCity = 'London';
    private static String apiKey = '4ef90ad4a7e5df0276f8920bcb07d888';

    
    @AuraEnabled (cacheable=true)
    public static String performCallout(Id recordId) {
       
       String apiUrl = 'http://api.openweathermap.org/data/2.5/weather';
       apiUrl+='?q='+ownerCity;
       apiUrl+='&units=metric';
       apiUrl+='&APPID='+apiKey;

       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint(apiUrl);
       request.setMethod('GET');
       HttpResponse response = http.send(request);
       JSON2Apex parsedResult = JSON2Apex.parse(response.getBody());
       String jsonString = JSON.serialize(parsedResult);
       return jsonString;
  
    }
  

}




