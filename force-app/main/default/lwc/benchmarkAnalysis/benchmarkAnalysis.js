import { LightningElement, wire, api } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { subscribe, MessageContext } from "lightning/messageService";
import chartjs from "@salesforce/resourceUrl/chartJs";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getBenchmarks from "@salesforce/apex/BenchmarkController.getBenchmarks";
import getAnnualProgress from "@salesforce/apex/BenchmarkController.getAnnualProgress";
import getMonthlyProgress from "@salesforce/apex/BenchmarkController.getMonthlyProgress";
import getMonthlyScores from "@salesforce/apex/ScoreController.getMonthlyScores"
import getAnnualScores from "@salesforce/apex/ScoreController.getAnnualScores"

import STRENGTH_TYPE_FIELD from "@salesforce/schema/Score__c.Strength_Type__c";
import WORKOUT_DATE_FIELD from "@salesforce/schema/Score__c.Workout_Date__c";
import WEIGHT_FIELD from "@salesforce/schema/Score__c.Weight__c";

import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Benchmark__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Benchmark__c.Shoulder_Press__c";
import DATE_FIELD from "@salesforce/schema/Benchmark__c.Date__c";

export default class MemberDetails extends LightningElement {
  //Fields for conditional rendering
  fitnessLevelPieChart;
  lineGraph;
  annualProgressLineGraph;
  monthlyProgressLineGraph;
  currentProgressBarGraph;
  chart;

  subscription = null;

  //Fields for Bar Graph
  currentBackSquat = 0;
  currentDeadlift = 0;
  currentBenchPress = 0;
  currentShoulderPress = 0;
  goalBackSquat = 0;
  goalDeadlift = 0;
  goalBenchPress = 0;
  goalShoulderPress = 0;

  error;

  @api
  recordid;

  config = {
    type: "line",
    data: {
      labels: ["2/16", "2/23", "3/2", "3/9", "3/16"],
      datasets: [
        {
          data: [86, 87, 87, 88, 88],
          label: "Back Squat",
          borderColor: "rgb(0, 0, 0)"
        },
        {
          data: [81, 81, 82, 83, 84],
          label: "Bench Press",
          borderColor: "rgb(0, 255, 255)"
        },
        {
          data: [78, 79, 80, 80, 81],
          label: "Deadlift",
          borderColor: "rgb(128, 128, 128)"
        },
        {
          data: [91, 91, 92, 92, 93],
          label: "Shoulder Press",
          borderColor: "rgb(0,115,255)"
        }
      ]
    },
    options: {
      title: {
        display: true,
        text: "Lift Progress by Weight"
      }
    }
  };

  handleMessage(message) {
    this.recordid = message.recordid;
    if (this.annualProgressLineGraph) {
      this.generateAnnualLineChart();
    } else if (this.monthlyProgressLineGraph) {
      this.generateMonthlyLineChart();
    } else if (this.currentProgressBarGraph) {
      this.generateBarChart();
    }
  }

  generateAnnualLineChart() {
    getAnnualScores({ memberId: this.recordid })
      .then((data) => {
        let annualBackSquat = data["Back Squat"];
        let annualBenchPress = data["Bench Press"];
        let annualDeadlift = data["Deadlift"];
        let annualShoulderPress = data["Shoulder Press"];
        let dates = [];

        annualBackSquat.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });
        annualBenchPress.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });
        annualDeadlift.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });
        annualShoulderPress.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });

        let expandedBS = [];
        let expandedBP = [];
        let expandedDL = [];
        let expandedSP = [];

        let bsTemp = null;
        let bpTemp = null;
        let dlTemp = null;
        let spTemp = null;

        dates.sort();

        let m = 0;
        let n = 0;
        let p = 0;
        let q = 0;
        for(let i = 0; i < dates.length; i++){
          if(m < annualBackSquat.length){
            if(dates[i] == getSObjectValue(annualBackSquat[m], WORKOUT_DATE_FIELD)){
              bsTemp = annualBackSquat[m];
              m++;
            }
          }
          if(n < annualBenchPress.length){
            if(dates[i] == getSObjectValue(annualBenchPress[n], WORKOUT_DATE_FIELD)){
              bpTemp = annualBenchPress[n];
              n++;
            }
          }
          if(p < annualDeadlift.length){
            if(dates[i] == getSObjectValue(annualDeadlift[p], WORKOUT_DATE_FIELD)){
              dlTemp = annualDeadlift[p];
              p++;
            }
          }
          if(q < annualShoulderPress.length){
            if(dates[i] == getSObjectValue(annualShoulderPress[q], WORKOUT_DATE_FIELD)){
              spTemp = annualShoulderPress[q];
              q++;
            }
          }
          expandedBS.push(getSObjectValue(bsTemp, WEIGHT_FIELD));
          expandedBP.push(getSObjectValue(bpTemp, WEIGHT_FIELD));
          expandedDL.push(getSObjectValue(dlTemp, WEIGHT_FIELD));
          expandedSP.push(getSObjectValue(spTemp, WEIGHT_FIELD));
        }
        if (!this.chart) {
          const canvas = document.createElement("canvas");
          this.config.data.datasets[0].data = expandedBS;
          this.config.data.datasets[1].data = expandedBP;
          this.config.data.datasets[2].data = expandedDL;
          this.config.data.datasets[3].data = expandedSP;
          this.config.data.labels = dates;
          this.template.querySelector("div.chart").appendChild(canvas);
          const ctx = canvas.getContext("2d");
          this.chart = new window.Chart(ctx, this.config);
        } else {
          this.chart.data.datasets[0].data = expandedBS;
          this.chart.data.datasets[1].data = expandedBP;
          this.chart.data.datasets[2].data = expandedDL;
          this.chart.data.datasets[3].data = expandedSP;
          this.chart.data.labels = dates;
          this.chart.update();
        }
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }

  generateMonthlyLineChart() {
    getMonthlyScores({ memberId: this.recordid })
      .then((data) => {
        let monthlyBackSquat = data["Back Squat"];
        let monthlyBenchPress = data["Bench Press"];
        let monthlyDeadlift = data["Deadlift"];
        let monthlyShoulderPress = data["Shoulder Press"];
        let dates = [];

        monthlyBackSquat.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });
        monthlyBenchPress.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });
        monthlyDeadlift.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });
        monthlyShoulderPress.forEach((score) => {
          if(!dates.includes(getSObjectValue(score, WORKOUT_DATE_FIELD))){
            dates.push(getSObjectValue(score, WORKOUT_DATE_FIELD));
          }
        });

        let expandedBS = [];
        let expandedBP = [];
        let expandedDL = [];
        let expandedSP = [];

        let bsTemp = null;
        let bpTemp = null;
        let dlTemp = null;
        let spTemp = null;

        dates.sort();

        let m = 0;
        let n = 0;
        let p = 0;
        let q = 0;
        for(let i = 0; i < dates.length; i++){
          if(m < monthlyBackSquat.length){
            if(dates[i] == getSObjectValue(monthlyBackSquat[m], WORKOUT_DATE_FIELD)){
              bsTemp = monthlyBackSquat[m];
              m++;
            }
          }
          if(n < monthlyBenchPress.length){
            if(dates[i] == getSObjectValue(monthlyBenchPress[n], WORKOUT_DATE_FIELD)){
              bpTemp = monthlyBenchPress[n];
              n++;
            }
          }
          if(p < monthlyDeadlift.length){
            if(dates[i] == getSObjectValue(monthlyDeadlift[p], WORKOUT_DATE_FIELD)){
              dlTemp = monthlyDeadlift[p];
              p++;
            }
          }
          if(q < monthlyShoulderPress.length){
            if(dates[i] == getSObjectValue(monthlyShoulderPress[q], WORKOUT_DATE_FIELD)){
              spTemp = monthlyShoulderPress[q];
              q++;
            }
          }
          expandedBS.push(getSObjectValue(bsTemp, WEIGHT_FIELD));
          expandedBP.push(getSObjectValue(bpTemp, WEIGHT_FIELD));
          expandedDL.push(getSObjectValue(dlTemp, WEIGHT_FIELD));
          expandedSP.push(getSObjectValue(spTemp, WEIGHT_FIELD));
        }
        if (!this.chart) {
          const canvas = document.createElement("canvas");
          this.config.data.datasets[0].data = expandedBS;
          this.config.data.datasets[1].data = expandedBP;
          this.config.data.datasets[2].data = expandedDL;
          this.config.data.datasets[3].data = expandedSP;
          this.config.data.labels = dates;
          this.template.querySelector("div.chart").appendChild(canvas);
          const ctx = canvas.getContext("2d");
          this.chart = new window.Chart(ctx, this.config);
        } else {
          this.chart.data.datasets[0].data = expandedBS;
          this.chart.data.datasets[1].data = expandedBP;
          this.chart.data.datasets[2].data = expandedDL;
          this.chart.data.datasets[3].data = expandedSP;
          this.chart.data.labels = dates;
          this.chart.update();
        }
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }

  generateBarChart() {
    console.log("Generating Bar Chart");
    this.currentBackSquat = 0;
    this.currentDeadlift = 0;
    this.currentBenchPress = 0;
    this.currentShoulderPress = 0;
    this.goalBackSquat = 0;
    this.goalDeadlift = 0;
    this.goalBenchPress = 0;
    this.goalShoulderPress = 0;
    getBenchmarks({ memberId: this.recordid })
      .then((data) => {
        let curBen = data.Current;
        console.log(curBen);
        let goalBen = data.Goal;
        console.log(goalBen);
        this.currentBackSquat =
          getSObjectValue(curBen, BACKSQUAT_FIELD) != null
            ? getSObjectValue(curBen, BACKSQUAT_FIELD)
            : 0;
        console.log(this.currentBackSquat);
        this.currentDeadlift =
          getSObjectValue(curBen, DEADLIFT_FIELD) != null
            ? getSObjectValue(curBen, DEADLIFT_FIELD)
            : 0;
        this.currentBenchPress =
          getSObjectValue(curBen, BENCHPRESS_FIELD) != null
            ? getSObjectValue(curBen, BENCHPRESS_FIELD)
            : 0;
        this.currentShoulderPress =
          getSObjectValue(curBen, SHOULDERPRESS_FIELD) != null
            ? getSObjectValue(curBen, SHOULDERPRESS_FIELD)
            : 0;
        this.goalBackSquat =
          getSObjectValue(goalBen, BACKSQUAT_FIELD) != null
            ? getSObjectValue(goalBen, BACKSQUAT_FIELD)
            : 0;
        this.goalDeadlift =
          getSObjectValue(goalBen, DEADLIFT_FIELD) != null
            ? getSObjectValue(goalBen, DEADLIFT_FIELD)
            : 0;
        this.goalBenchPress =
          getSObjectValue(goalBen, BENCHPRESS_FIELD) != null
            ? getSObjectValue(goalBen, BENCHPRESS_FIELD)
            : 0;
        this.goalShoulderPress =
          getSObjectValue(goalBen, SHOULDERPRESS_FIELD) != null
            ? getSObjectValue(goalBen, SHOULDERPRESS_FIELD)
            : 0;
        if (
          this.template.querySelector("c-benchmark-bar-chart").chartCreated()
        ) {
          console.log("Updating Bar Chart");
          this.template
            .querySelector("c-benchmark-bar-chart")
            .updateChart(
              this.currentBackSquat,
              this.goalBackSquat,
              this.currentDeadlift,
              this.goalDeadlift,
              this.currentBenchPress,
              this.goalBenchPress,
              this.currentShoulderPress,
              this.goalShoulderPress
            );
        }
      })
      .catch((error) => {
        this.error = error;
        console.log(error);
      });
  }

  // By using the MessageContext @wire adapter, unsubscribe will be called
  // implicitly during the component descruction lifecycle.
  @wire(MessageContext)
  messageContext;

  // Encapsulate logic for LMS subscribe.
  subscribeToMessageChannel() {
    this.subscription = subscribe(
      this.messageContext,
      RECORD_SELECTED_CHANNEL,
      (message) => {
        this.handleMessage(message);
      }
    );
  }
  // Standard lifecycle hooks used to sub/unsub to message channel
  connectedCallback() {
    this.subscribeToMessageChannel();
  }
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
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }

  handleSelect(event) {
    console.log(event.target.value);
    switch (event.target.value) {
      case "fitnessLevelPieChart":
        this.fitnessLevelPieChart = true;
        this.lineGraph = false;
        this.annualProgressLineGraph = false;
        this.monthlyProgressLineGraph = false;
        this.currentProgressBarGraph = false;
        this.generatePieChart();
        break;
      case "annualProgressLineGraph":
        this.fitnessLevelPieChart = false;
        this.lineGraph = true;
        this.annualProgressLineGraph = true;
        this.monthlyProgressLineGraph = false;
        this.currentProgressBarGraph = false;
        this.generateAnnualLineChart();
        break;
      case "monthlyProgressLineGraph":
        this.fitnessLevelPieChart = false;
        this.lineGraph = true;
        this.annualProgressLineGraph = false;
        this.monthlyProgressLineGraph = true;
        this.currentProgressBarGraph = false;
        this.generateMonthlyLineChart();
        break;
      case "currentProgressBarGraph":
        this.fitnessLevelPieChart = false;
        this.lineGraph = false;
        this.annualProgressLineGraph = false;
        this.monthlyProgressLineGraph = false;
        this.currentProgressBarGraph = true;
        this.chart = null;
        this.generateBarChart();
        break;
      default:
        this.fitnessLevelPieChart = false;
        this.lineGraph = false;
        this.annualProgressLineGraph = false;
        this.monthlyProgressLineGraph = false;
        this.currentProgressBarGraph = false;
    }
  }
}
