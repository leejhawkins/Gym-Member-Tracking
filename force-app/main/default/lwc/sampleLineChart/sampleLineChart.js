import { LightningElement, api } from "lwc";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import chartjs from "@salesforce/resourceUrl/chartJs";
export default class MemberBarChart extends LightningElement {
  error;
  chart;
  chartjsInitialized = false;
  @api cbs;
  @api cdl;
  @api gbs;
  @api gdl;

  config = {
    type: "line",
    data: {
      labels: [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ],
      datasets: [
        {
          data: [65, 69, 74, 78, 83, 86, 89, 92, 94, 96, 98, 100],
          label: "Bench Press",
          borderColor: "#3e95cd",
          fill: false
        },
        {
          data: [67, 70, 73, 75, 78, 81, 83, 85, 88, 90, 93, 95],
          label: "Back Squat",
          borderColor: "#8e5ea2",
          fill: false
        },
        {
          data: [62, 65, 68, 72, 75, 78, 82, 87, 90, 93, 97, 100],
          label: "Deadlift",
          borderColor: "#3cba9f",
          fill: false
        },
        {
          data: [65, 68, 74, 77, 82, 87, 91, 95, 99, 102, 104, 105],
          label: "Shoulder Press",
          borderColor: "#e8c3b9",
          fill: false
        }
      ]
    },
    options: {
      title: {
        display: true,
        text: "Lift Progress as a Ratio to Goal Weight"
      }
    }
  };

  connectedCallback() {
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
        this.config.data.datasets[0].data[0] = this.cbs;
        this.config.data.datasets[0].data[1] = this.gbs;
        this.config.data.datasets[0].data[2] = this.cdl;
        this.config.data.datasets[0].data[3] = this.gdl;
        const canvas = document.createElement("canvas");
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
  updateChart(cB, gB, cD, gD) {
    this.chart.data.datasets[0].data[0] = cB;
    this.chart.data.datasets[0].data[1] = gB;
    this.chart.data.datasets[0].data[2] = cD;
    this.chart.data.datasets[0].data[3] = gD;
    this.chart.update();
  }
  @api
  chartCreated() {
    if (this.chart) {
      console.log(true);
      return true;
    }
  }
}
