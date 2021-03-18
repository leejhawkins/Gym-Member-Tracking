import { LightningElement, api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chartJs';
export default class MemberBarChart extends LightningElement {
    error;
    chart;
    chartjsInitialized = false;
    @api cbs;
    @api cdl;
    @api gbs;
    @api gdl;

    config = {
        type: 'line',
        data: {
          labels: ["2/16", "2/23", "3/2", "3/9", "3/16"],
          datasets: [{
              data: [86, 87, 87, 88, 88],
              label: "Bench Press",
              borderColor: 'rgb(0, 0, 0)',
              fill: false
            }, { 
              data: [81, 81, 82, 83, 84],
              label: "Back Squat",
              borderColor: 'rgb(0, 255, 255)',
              fill: false
            }, { 
              data: [78, 79, 80, 80, 81],
              label: "Deadlift",
              borderColor: 'rgb(128, 128, 128)',
              fill: false
            }, { 
              data: [91, 91, 92, 92, 93],
              label: "Shoulder Press",
              borderColor: 'rgb(0,115,255)',
              fill: false
            }
          ]
        },
        options: {
          title: {
            display: true,
            text: 'Lift Progress as a Ratio to Goal Weight'
          }
        }
      };
    
    connectedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
        console.log("making chart..")
        Promise.all([
            loadScript(this, chartjs + '/Chart.min.js'),
            loadStyle(this, chartjs + '/Chart.min.css')
        ])
            .then(() => {
                // disable Chart.js CSS injection
                window.Chart.platform.disableCSSInjection = true;
                this.config.data.datasets[0].data[0] = this.cbs;
                this.config.data.datasets[0].data[1] = this.gbs;
                this.config.data.datasets[0].data[2] = this.cdl;
                this.config.data.datasets[0].data[3] = this.gdl;
                const canvas = document.createElement('canvas');
                this.template.querySelector('div.chart').appendChild(canvas);
                const ctx = canvas.getContext('2d');
                this.chart = new window.Chart(ctx, this.config);
            })
            .catch((error) => {
                console.log(error)
                this.error = error;
            });
    }
    @api
    updateChart(cB,gB,cD,gD){
        this.chart.data.datasets[0].data[0] = cB;
        this.chart.data.datasets[0].data[1] = gB;
        this.chart.data.datasets[0].data[2] = cD;
        this.chart.data.datasets[0].data[3] = gD;
        this.chart.update()    
    }
    @api
    chartCreated(){
        if(this.chart){
            console.log(true)
            return true
        }
    }
}