import { LightningElement, api } from "lwc";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import chartjs from "@salesforce/resourceUrl/chartJs";

export default class BenchmarkLineChart extends LightningElement {
  error;
  chart;
  chartjsInitialized = false;
  @api bp;
  @api bs;
  @api dl;
  @api sp;

  @api months;

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
          borderColor: "rgb(0, 0, 0)",
          fill: false
        },
        {
          data: [67, 70, 73, 75, 78, 81, 83, 85, 88, 90, 93, 95],
          label: "Back Squat",
          borderColor: "rgb(0, 255, 255)",
          fill: false
        },
        {
          data: [62, 65, 68, 72, 75, 78, 82, 87, 90, 93, 97, 100],
          label: "Deadlift",
          borderColor: "rgb(128, 128, 128)",
          fill: false
        },
        {
          data: [65, 68, 74, 77, 82, 87, 91, 95, 99, 102, 104, 105],
          label: "Shoulder Press",
          borderColor: "rgb(0,115,255)",
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
        this.config.data.labels = this.months;
        console.log(this.bp);
        console.log(this.bs);
        console.log(this.dl);
        console.log(this.sp);
        this.config.data.datasets[0].data = this.bs;
        this.config.data.datasets[1].data = this.bp;
        this.config.data.datasets[2].data = this.dl;
        this.config.data.datasets[3].data = this.sp;
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
  updateChart(bs, bp, dl, sp, months) {
    try {
      this.chart.data.labels = months;
      console.log(months);
      this.chart.data.datasets[0].data = bs;
      console.log(bs);
      this.chart.data.datasets[1].data = bp;
      console.log(bp);
      this.chart.data.datasets[2].data = dl;
      console.log(dl);
      this.chart.data.datasets[3].data = sp;
      console.log(sp);
      this.chart.update();
      console.log("Fifth");
    } catch (e) {
      console.log(e);
    }
  }
  @api
  chartCreated() {
    if (this.chart) {
      console.log(true);
      return true;
    }
  }
}
