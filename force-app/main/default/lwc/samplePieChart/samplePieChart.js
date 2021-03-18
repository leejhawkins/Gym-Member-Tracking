import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/chartJs';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

export default class SamplePieChart extends LightningElement {
    error;
    chart;
    chartjsInitialized = false;
    levels;
    
    config = {
        type: 'pie',
        data: {
          labels: ["Beginner", "Novice", "Intermediate", "Advanced", "Elite"],
          datasets: [{
            label: "Population (millions)",
            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
            data: [5,20,14,5,3]
          }]
        },
        options: {
          title: {
            display: true,
            text: 'Fitness Level of Members'
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
            loadScript(this, chartjs),
            loadStyle(this, chartjs)
        ])
            .then(() => {
                // disable Chart.js CSS injection
                window.Chart.platform.disableCSSInjection = true;
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
    updateChart(){
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