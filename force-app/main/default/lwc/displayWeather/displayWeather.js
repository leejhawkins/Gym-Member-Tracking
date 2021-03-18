import { LightningElement, api} from 'lwc';
import performCallout from '@salesforce/apex/WebServiceLWC.performCallout';

export default class displayWeather extends LightningElement {
    @api recordId;
    _weatherData;
    _parsedWeatherData;
    _name;
    _temp;
    _description;
    _icon;
    _time;
    _convertedTemp;
    
    async connectedCallback(){
        var d = new Date();
        try{
        this._weatherData = await performCallout({recordId: this.recordId});
        this._parsedWeatherData = await JSON.parse(this._weatherData);
        this._name = this._parsedWeatherData.name;
        this._humidity = this._parsedWeatherData.main.humidity;
        this._temp = this._parsedWeatherData.main.temp;
        this._description = this._parsedWeatherData.weather[0].description;
        this._icon = `http://openweathermap.org/img/wn/${this._parsedWeatherData.weather[0].icon}@2x.png`;
        this._time = d.toLocaleTimeString();
        this._convertedTemp = (this._temp * 2) + 30;
        }catch(error){
            console.log(error);
        }
    }
}
