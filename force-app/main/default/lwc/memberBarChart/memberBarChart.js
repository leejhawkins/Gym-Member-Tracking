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
    @api cbp;
    @api gbp;
    @api csp;
    @api gsp;

    config = {
        type: 'horizontalBar',
        data: {
            datasets: [
                {
                    data: [0,0,0,0],
                    backgroundColor: 'rgb(0, 0, 0)',
                    label: 'Current'
                    
                },
                {
                    data: [0,0,0,0],
                    backgroundColor: 'rgb(192,192,192)',
                    label: 'Goal'
                }
            ],
            labels: ['Back Squat','Deadlift','Bench Press','Shoulder Press']
        },
        options: {
            animation: {
                animateScale: false
            },
            legend:{
                labels:{
                    fontSize:8,
                    boxWidth:15,
                }
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
                this.config.data.datasets[1].data[0] = this.gbs;
                this.config.data.datasets[0].data[1] = this.cdl;
                this.config.data.datasets[1].data[1] = this.gdl;
                this.config.data.datasets[0].data[2] = this.cbp;
                this.config.data.datasets[1].data[2] = this.gbp;
                this.config.data.datasets[0].data[3] = this.csp;
                this.config.data.datasets[0].data[3] = this.gsp;
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
    updateChart(cBS,gBS,cDL,gDL,cBP,gBP,cSP,gSP){
        this.chart.data.datasets[0].data[0] = cBS;
        this.chart.data.datasets[1].data[0] = gBS;
        this.chart.data.datasets[0].data[1] = cDL;
        this.chart.data.datasets[1].data[1] = gDL;
        this.chart.data.datasets[0].data[2] = cBP;
        this.chart.data.datasets[1].data[2] = gBP;
        this.chart.data.datasets[0].data[3] = cSP;
        this.chart.data.datasets[1].data[3] = gSP;
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