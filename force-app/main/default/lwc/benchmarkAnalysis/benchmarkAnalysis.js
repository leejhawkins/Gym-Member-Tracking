import { LightningElement, wire } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { subscribe, MessageContext } from "lightning/messageService";
import chartjs from "@salesforce/resourceUrl/chartJs";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getBenchmarks from "@salesforce/apex/BenchmarkController.getBenchmarks";
import getAnnualProgress from "@salesforce/apex/BenchmarkController.getAnnualProgress";
import getMonthlyProgress from "@salesforce/apex/BenchmarkController.getMonthlyProgress";
import findMembers from "@salesforce/apex/MemberController.findMembers";
import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Benchmark__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Benchmark__c.Shoulder_Press__c";
import DATE_FIELD from "@salesforce/schema/Benchmark__c.Date__c";
import LEVEL_FIELD from "@salesforce/schema/Member__c.Fitness_Level__c";

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

  //Fields for pie chart
  beg = 0;
  nov = 0;
  int = 0;
  adv = 0;
  eli = 0;

  error;
  recordId;
  Name;

  config = {
    type: "line",
    data: {
      labels: ["2/16", "2/23", "3/2", "3/9", "3/16"],
      datasets: [
        {
          data: [86, 87, 87, 88, 88],
          label: "Bench Press",
          borderColor: "rgb(0, 0, 0)"
        },
        {
          data: [81, 81, 82, 83, 84],
          label: "Back Squat",
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
        text: "Lift Progress as a Ratio to Goal Weight"
      }
    }
  };
  
  handleMessage(message) {
    this.recordId = message.recordId;
    if (this.annualProgressLineGraph) {
      this.generateAnnualLineChart();
    } else if (this.monthlyProgressLineGraph) {
      this.generateMonthlyLineChart();
    } else if (this.currentProgressBarGraph) {
      this.generateBarChart();
    }
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
      this.template
        .querySelector("c-sample-pie-chart")
        .chartConfig(this.beg, this.nov, this.int, this.adv, this.eli);
    });
  }

  generateAnnualLineChart() {
    getAnnualProgress({ memberId: this.recordId })
      .then((data) => {
        console.log(data);
        let goalData = data.Goal;
        let goalBenchPress = getSObjectValue(goalData[0], BENCHPRESS_FIELD);
        let goalBackSquat = getSObjectValue(goalData[0], BACKSQUAT_FIELD);
        let goalDeadlift = getSObjectValue(goalData[0], DEADLIFT_FIELD);
        let goalShoulderPress = getSObjectValue(goalData[0], SHOULDERPRESS_FIELD);

        let annualBenchPress = [];
        let annualBackSquat = [];
        let annualDeadlift = [];
        let annualShoulderPress = [];
        let dates = [];
        let benchmarks = data["Benchmarks"];
        console.log(benchmarks);
        benchmarks.forEach((benchmark) => {
          annualBenchPress.push(getSObjectValue(benchmark, BENCHPRESS_FIELD)/goalBenchPress);
          annualBackSquat.push(getSObjectValue(benchmark, BACKSQUAT_FIELD)/goalBackSquat);
          annualDeadlift.push(getSObjectValue(benchmark, DEADLIFT_FIELD)/goalDeadlift);
          annualShoulderPress.push(getSObjectValue(benchmark, SHOULDERPRESS_FIELD)/goalShoulderPress);
          dates.push(getSObjectValue(benchmark, DATE_FIELD));
        });
        console.log(dates);
        if (!this.chart) {
          const canvas = document.createElement("canvas");
          this.config.data.datasets[0].data = annualBenchPress;
          this.config.data.datasets[1].data = annualBackSquat;
          this.config.data.datasets[2].data = annualDeadlift;
          this.config.data.datasets[3].data = annualShoulderPress;
          this.config.data.labels = dates;
          this.template.querySelector("div.chart").appendChild(canvas);
          const ctx = canvas.getContext("2d");
          this.chart = new window.Chart(ctx, this.config);
        } else {
          this.chart.data.datasets[0].data = annualBenchPress;
          this.chart.data.datasets[1].data = annualBackSquat;
          this.chart.data.datasets[2].data = annualDeadlift;
          this.chart.data.datasets[3].data = annualShoulderPress;
          this.chart.data.labels = dates;
          console.log(this.chart.data.labels);
          this.chart.update();
        }
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }

  generateMonthlyLineChart() {
    console.log("hello line 138");
    getMonthlyProgress({ memberId: this.recordId })
      .then((data) => {
        let goalData = data.Goal;
        let goalBenchPress = getSObjectValue(goalData[0], BENCHPRESS_FIELD);
        let goalBackSquat = getSObjectValue(goalData[0], BACKSQUAT_FIELD);
        let goalDeadlift = getSObjectValue(goalData[0], DEADLIFT_FIELD);
        let goalShoulderPress = getSObjectValue(goalData[0], SHOULDERPRESS_FIELD);

        let monthlyBenchPress = [];
        let monthlyBackSquat = [];
        let monthlyDeadlift = [];
        let monthlyShoulderPress = [];
        let dates = [];
        let benchmarks = data["Benchmarks"];
        console.log(benchmarks);
        benchmarks.forEach((benchmark) => {
          monthlyBenchPress.push(getSObjectValue(benchmark, BENCHPRESS_FIELD)/goalBenchPress);
          monthlyBackSquat.push(getSObjectValue(benchmark, BACKSQUAT_FIELD)/goalBackSquat);
          monthlyDeadlift.push(getSObjectValue(benchmark, DEADLIFT_FIELD)/goalDeadlift);
          monthlyShoulderPress.push(getSObjectValue(benchmark, SHOULDERPRESS_FIELD)/goalShoulderPress);
          dates.push(getSObjectValue(benchmark, DATE_FIELD));
        });
        console.log(dates);
        if (!this.chart) {
          const canvas = document.createElement("canvas");
          this.config.data.datasets[0].data = monthlyBenchPress;
          this.config.data.datasets[1].data = monthlyBackSquat;
          this.config.data.datasets[2].data = monthlyDeadlift;
          this.config.data.datasets[3].data = monthlyShoulderPress;
          this.config.data.labels = dates;
          this.template.querySelector("div.chart").appendChild(canvas);
          const ctx = canvas.getContext("2d");
          this.chart = new window.Chart(ctx, this.config);
        } else {
          this.chart.data.datasets[0].data = monthlyBenchPress;
          this.chart.data.datasets[1].data = monthlyBackSquat;
          this.chart.data.datasets[2].data = monthlyDeadlift;
          this.chart.data.datasets[3].data = monthlyShoulderPress;
          this.chart.data.labels = dates;
          console.log(this.chart.data.labels);
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
    getBenchmarks({ memberId: this.recordId })
      .then((data) => {
        let curBen = data["Current"];
        console.log(curBen);
        let goalBen = data["Goal"];
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
