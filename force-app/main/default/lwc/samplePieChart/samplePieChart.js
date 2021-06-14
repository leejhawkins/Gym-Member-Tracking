import { LightningElement } from "lwc";
import chartjs from "@salesforce/resourceUrl/chartJs";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import findMembers from "@salesforce/apex/MemberController.findMembers";
import LEVEL_FIELD from "@salesforce/schema/Workout__c.Fitness_Level__c";
import { getSObjectValue } from "@salesforce/apex";

export default class SamplePieChart extends LightningElement {
  error;
  chart;
  chartjsInitialized = false;

  beg;
  nov;
  int;
  adv;
  eli;

  config = {
    type: "doughnut",
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
        position: "right",
        labels: {
          fontSize: 12
        }
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
        this.generatePieChart();
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }
  generatePieChart() {
    findMembers({ searchKey: "" }).then((data) => {
      this.beg = 0;
      this.nov = 0;
      this.int = 0;
      this.adv = 0;
      this.eli = 0;
      data.forEach((member) => {
        switch (getSObjectValue(member, LEVEL_FIELD)) {
          case "Beginner":
            this.beg++;
            break;
          case "Novice":
            this.nov++;
            break;
          case "Intermediate":
            this.int++;
            break;
          case "Advanced":
            this.adv++;
            break;
          case "Elite":
            this.eli++;
            break;
          default:
        }
      });
      const canvas = document.createElement("canvas");
      this.config.data.datasets[0].data[0] = this.beg;
      this.config.data.datasets[0].data[1] = this.nov;
      this.config.data.datasets[0].data[2] = this.int;
      this.config.data.datasets[0].data[3] = this.adv;
      this.config.data.datasets[0].data[4] = this.eli;
      this.template.querySelector("div.chart").appendChild(canvas);
      const ctx = canvas.getContext("2d");
      this.chart = new window.Chart(ctx, this.config);
    });
  }
}
