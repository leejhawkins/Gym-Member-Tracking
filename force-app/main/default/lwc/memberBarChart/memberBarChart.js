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
        type: 'horizontalBar',
        data: {
            datasets: [
                {
                    data: [0,0,0,0

                    ],
                    backgroundColor: [
                        'rgb(255, 99, 132)',
                        'rgb(255, 159, 64)',
                        'rgb(255, 205, 86)',
                        'rgb(75, 192, 192)'
                    ],
                    label: 'Lifts'
                }
            ],
            labels: ['Current Back Squat', 'Goal Back Squat', 'Current Deadlift', 'Goal Deadlift']
        },
        options: {
            legend: {
                display:false
            },
            animation: {
                animateScale: false
            },
            options: {
                scales: {
                    xAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
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