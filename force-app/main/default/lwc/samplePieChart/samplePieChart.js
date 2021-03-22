import { LightningElement, api } from "lwc";
import chartjs from "@salesforce/resourceUrl/chartJs";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";

export default class SamplePieChart extends LightningElement {
  error;
  chart;
  chartjsInitialized = false;

  @api beg;
  @api nov;
  @api int;
  @api adv;
  @api eli;

  config = {
    type: "pie",
    data: {
      datasets: [
        {
          backgroundColor: [
            "#3e95cd",
            "#8e5ea2",
            "#3cba9f",
            "#e8c3b9",
            "#c45850"
          ],
          data: [0, 0, 0, 0, 0],
          label: "Member Fitness Levels"
        }
      ],
      labels: ["Beginner", "Novice", "Intermediate", "Advanced", "Elite"]
    },
    options: {
      responsive: true,
      legend: {
        position: "right"
      },
      animation: {
        animateScale: true,
        animateRotate: true
      }
    }
  };

  renderedCallback() {
    if (this.chartjsInitialized) {
      return;
    }
    this.chartjsInitialized = true;
    console.log("making chart..");
    Promise.all([
      loadScript(this, chartjs + "/Chart.min.js"),
      loadStyle(this, chartjs + "/Chart.min.css")
    ])
      .then(() => {
        // disable Chart.js CSS injection
        window.Chart.platform.disableCSSInjection = true;
        const canvas = document.createElement("canvas");
        this.config.data.datasets[0].data[0] = this.beg;
        this.config.data.datasets[0].data[1] = this.nov;
        this.config.data.datasets[0].data[2] = this.int;
        this.config.data.datasets[0].data[3] = this.adv;
        this.config.data.datasets[0].data[4] = this.eli;
        this.template.querySelector("div.chart").appendChild(canvas);
        const ctx = canvas.getContext("2d");
        this.chart = new window.Chart(ctx, this.config);
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }
  @api
  chartConfig(beg, nov, int, adv, eli) {
    if (this.chart) {
      console.log("making pie chart");
      this.chart.data.datasets[0].data[0] = beg;
      this.chart.data.datasets[0].data[1] = nov;
      this.chart.data.datasets[0].data[2] = int;
      this.chart.data.datasets[0].data[3] = adv;
      this.chart.data.datasets[0].data[4] = eli;
    }
  }
}
