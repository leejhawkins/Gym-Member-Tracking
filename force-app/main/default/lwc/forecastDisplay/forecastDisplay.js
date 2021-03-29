import { LightningElement, track } from "lwc";
import getWeatherForCity from "@salesforce/apex/WebServiceLWC.getWeatherForCity";

export default class ForecastDisplay extends LightningElement {
  @track result;
  @track todaydata = [];
  @track tomorrowdata = [];
  @track nextdaydata = [];
  @track fourthdaydata = [];
  @track fifthdaydata = [];

  connectedCallback() {
    getWeatherForCity()
      .then((data) => {
        this.result = data;
        console.log("No error", this.result);
      })
      .catch((err) => console.log(err));
  }

  get getTodayData() {
    return this.result
      ? [
          {
            key: 1,
            temp: this.result.Today[1],
            icon: this.result.Today[2],
            description: this.result.Today[3],
            dateTime: this.result.Today[4].substring(0, 10)
          }
        ]
      : "--";
  }

  get getTomorrowData() {
    return this.result
      ? [
          {
            key: 2,
            temp: this.result.Tomorrow[1],
            icon: this.result.Tomorrow[2],
            description: this.result.Tomorrow[3],
            dateTime: this.result.Tomorrow[4].substring(0, 10)
          }
        ]
      : "--";
  }

  get getNextDayData() {
    return this.result
      ? [
          {
            key: 3,
            temp: this.result.Next_Day[1],
            icon: this.result.Next_Day[2],
            description: this.result.Next_Day[3],
            dateTime: this.result.Next_Day[4].substring(0, 10)
          }
        ]
      : "--";
  }

  get getFourthDayData() {
    return this.result
      ? [
          {
            key: 4,
            temp: this.result.Fourth_Day[1],
            icon: this.result.Fourth_Day[2],
            description: this.result.Fourth_Day[3],
            dateTime: this.result.Fourth_Day[4].substring(0, 10)
          }
        ]
      : "--";
  }

  get getFifthDayData() {
    return this.result
      ? [
          {
            key: 5,
            temp: this.result.Fifth_Day[1],
            icon: this.result.Fifth_Day[2],
            description: this.result.Fifth_Day[3],
            dateTime: this.result.Fifth_Day[4].substring(0, 10)
          }
        ]
      : "--";
  }

  get getCityName() {
    if (this.result) {
      return this.result.Today[0];
    }
    return "---";
  }
}
