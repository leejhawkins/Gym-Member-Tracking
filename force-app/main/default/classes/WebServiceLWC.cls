/*
    a class to make a GET Api call to the openweathermap api. Method performs a call, 

    gets the response. Uses the JSON2Apex class to get the data. Then data gets serialized 
    to be processed by the JS class in the LWC
*/
public class WebServiceLWC {
  //GET method to fetch data from the openweathermap API
  private static String ownerCity = 'McLean';
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
 
  public static void getGIF(
    String name,
    String email,
    String oldLevel,
    String newLevel
  ) {
    String queryURL = 'https://api.giphy.com/v1/gifs/search?q=celebrations';
    queryURL += '&api_key=BkaUZZWcFij6J7AoQj3WtPb1R2p9O6V9&limit=10';
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(queryURL);
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() == 200) {
      System.debug(response.getBody());
      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      List<Object> URLS = (List<Object>) results.get('data');
      Map<String, Object> url = (Map<String, Object>) URLS[0];
      String urlString = url.get('url').toString();
      EmailController.sendCongratulationsEmail(
        name,
        email,
        oldLevel,
        newLevel,
        urlString
      );
    }
  }
}

