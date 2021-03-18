import { LightningElement} from 'lwc';
import performCallout from '@salesforce/apex/WebServiceLWC.performCallout';

export default class displayWeather extends LightningElement {
    _weatherData;
    _parsedWeatherData;
    _name;
    _temp;
    _description;
    _icon;
    _convertedTemp;
    
    async connectedCallback(){
        try{
        this._weatherData = await performCallout();
        this._parsedWeatherData = await JSON.parse(this._weatherData);
        this._name = this._parsedWeatherData.name;
        this._temp = this._parsedWeatherData.main.temp;
        this._description = this._parsedWeatherData.weather[0].description;
        this._icon = `http://openweathermap.org/img/wn/${this._parsedWeatherData.weather[0].icon}@2x.png`;
        this._convertedTemp = (this._temp * (9/5) + 32);
        }catch(error){
            console.log(error);
        }
    }
}
