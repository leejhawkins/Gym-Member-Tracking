/*
    This class parses the JSON content to Apex. Reads the JSON data as a stream of tokens.
*/
public class ForecastInfoParsing {
    
    public static map<String,List<String>> forecastJsonParse(String JSONResponse){ 
        map<String,List<String>> forecastData = new map<String,List<String>>();
        if(String.isNotBlank(JSONResponse)){
            JSONParser parser = JSON.createParser(JSONResponse);
            System.debug(parser);
            List<String> temp_list = new  List<String>();
            List<String> icon_list = new  List<String>();
            List<String> description_list = new  List<String>();
            List<String> dt_txt_list = new  List<String>();
            String cityName;
            Integer firstDateCount = 0;
            List<String> allthreedays = new List<String>();
            
            while (parser.nextToken() != null && firstDateCount < 100) {
                
                if(parser.getCurrentName()=='name'){
                    cityName = String.valueOf(parser.getText());
                }
                if(parser.getCurrentName()=='temp' && String.valueOf(parser.getText()) !='temp'){
                    temp_list.add(String.valueOf(parser.getText()));
                }
                if(parser.getCurrentName()=='icon' && String.valueOf(parser.getText()) !='icon'){
                    icon_list.add(String.valueOf(parser.getText()));
                }
                if(parser.getCurrentName()=='description' && String.valueOf(parser.getText()) !='description'){
                    description_list.add(String.valueOf(parser.getText()));
                }
                if(parser.getCurrentName()=='dt_txt' && String.valueOf(parser.getText()) !='dt_txt') {
                    dt_txt_list.add(String.valueOf(parser.getText()));
                    if(firstDateCount == 0){
                        allthreedays = toDateCalculate(String.valueOf(parser.getText()));
                        System.debug('allthreedays : '+allthreedays);
                    }
                    firstDateCount++;
                }
            }
            
            
            System.debug('$$$$cityName : '+cityName);
            System.debug('$$$$temp_list : '+temp_list);
            System.debug('$$$$icon_list : '+icon_list);
            System.debug('$$$$description_list : '+description_list);
            System.debug('$$$$dt_txt_list : '+dt_txt_list);
            
            forecastData = createForecastInfoList(cityName,temp_list,icon_list,description_list,dt_txt_list,allthreedays);
        }
        System.debug('$$$$forecastData : '+forecastData);
        return forecastData;
        
    }
    // Converts the forecast dates to Apex dates
    public static List<String> toDateCalculate(string fromDate){
        List<String> threeDays = new  List<String>();
        List<Date> dateStored = new  List<Date>();
        String[] datefrom = fromDate.split(' '); //2021-03-20
        System.debug('$$$$datefrom[0] : '+datefrom); 
        Date currentDate = Date.valueOf(datefrom[0]);
        for(integer i=0;i<5;i++){
            Date daysCount = currentDate.addDays(i);  
            dateStored.add(daysCount);
        }
        
        System.debug('$$$$dateStored : '+dateStored);
        
        for(Date ds : dateStored){
            Datetime dateTimeConvert = Datetime.newInstance(ds.year(), ds.month(),ds.day());  
            String dayStore = dateTimeConvert.format('yyyy-MM-dd')+ ' ' + datefrom[1];
            threeDays.add(dayStore);
        }
        return threeDays;
    }  

    // Creates Apex collections from the response to store the days and details of each day
    public static  map<String,List<String>> createForecastInfoList
        (string cityName,
         List<String> temp_list,List<String> icon_list,
         List<String> description_list,
         List<String> dt_txt_list,List<String> allthreedays){
             
             map<String,List<String>> forecastDatamap = new map<String,List<String>>();
             List<String> DaysName = new  List<String>{'Today','Tomorrow','Next_Day', 'Fourth_Day', 'Fifth_Day'};
              
             Integer dataCount = 0;
             for(integer i=0;i<dt_txt_list.size();i++){
                 if(dt_txt_list[i].contains(allthreedays[0]) || dt_txt_list[i].contains(allthreedays[1]) || dt_txt_list[i].contains(allthreedays[2]) || dt_txt_list[i].contains(allthreedays[3]) || dt_txt_list[i].contains(allthreedays[4])){
                     List<String> currentFCList = new List<String>();
                     currentFCList.add(cityName);
                     currentFCList.add(temp_list[i]);
                     currentFCList.add('http://openweathermap.org/img/w/'+icon_list[i]+'.png');
                     currentFCList.add(description_list[i]);
                     forecastDatamap.put(DaysName[dataCount],currentFCList);
                     dataCount++;
                 }
             }
             return forecastDatamap;
         }
    
}