import { LightningElement, api} from 'lwc';
import getCallout from '@salesforce/apex/MemberCallouts.makeGetCallout';

export default class MemberWeather extends LightningElement {
    @api recordId;
    _weatherData;
    _parsedWeatherData;
    _name;
    _humidity;
    _pressure;
    _temp;
    _temp_min;
    _temp_max;
    _lat;
    _lon;
    _description;
    _icon;

    
    
    async connectedCallback(){
        
        try{
        this._weatherData = await getCallout({memberId: this.recordId});
        this._parsedWeatherData = await JSON.parse(this._weatherData);
        this._name = this._parsedWeatherData.name;
        this._humidity = this._parsedWeatherData.main.humidity;
        this._pressure = this._parsedWeatherData.main.pressure;
        this._temp = this._parsedWeatherData.main.temp;
        this._temp_max = this._parsedWeatherData.main.temp_max;
        this._temp_min = this._parsedWeatherData.main.temp_min;
        this._lat = this._parsedWeatherData.coord.lat;
        this._lon = this._parsedWeatherData.coord.lon;
        this._description = this._parsedWeatherData.weather[0].description;
        this._icon = `http://openweathermap.org/img/wn/${this._parsedWeatherData.weather[0].icon}@2x.png`;

        }catch(error){
            console.log(error);
        }
       
    }

    

}