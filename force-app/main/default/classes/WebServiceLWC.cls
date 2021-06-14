/*
    a class to make a GET Api call to the openweathermap api. Method performs a get callout, 
    gets the response from the weatherAPI. The API key is stored in a custom 
    label named 'Forecast_API_Key' as well as the location of the Gym. and used by this class. Using a named credintial to specify 
    callout endpoint. 
*/
public class WebServiceLWC {
  public static String apiURL = '/forecast?';
  public static String apiKey = 'appid=' + system.label.Forecast_API_Key;
  public static String city = '&q=Denver';

  @AuraEnabled(cacheable=true)
  public static map<String, List<String>> getWeatherForCity() {
    string ndays = '&cnt=40';
    String units = '&units=imperial';
    map<String, List<String>> forecastData = new Map<String, List<String>>();
    String weatherUrl = apiURL + apiKey + ndays + units + city;

    String JSONResponse = getForecastJSON(weatherUrl);

    forecastData = ForecastInfoParsing.forecastJsonParse(JSONResponse);
    return forecastData;
  }

  // Pass in the endpoint to be used using the string url
  private static String getForecastJSON(String url) {
    String result = null;

    Http htp = new Http();
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:Forecast_API' + url);
    req.setMethod('GET');

    // Send the request, and return a response
    HttpResponse res = htp.send(req);
    if (res.getStatusCode() == 200) {
      result = res.getBody();
    } else {
      System.debug('res.getStatusCode() : ' + res.getStatusCode());
    }
    System.debug('result : ' + result);
    return result;
  }
}
