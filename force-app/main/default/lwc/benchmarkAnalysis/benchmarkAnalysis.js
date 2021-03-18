import { LightningElement, wire } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { subscribe, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getBenchmarks from "@salesforce/apex/BenchmarkController.getBenchmarks";
import getAnnualProgress from "@salesforce/apex/BenchmarkController.getAnnualProgress";
import getMembershipMonths from "@salesforce/apex/BenchmarkController.getMembershipMonths";
//import getMonthlyProgress from "@salesforce/apex/BenchmarkController.getMonthlyProgress";
//import getMonthlyBenchmarkDates from "@salesforce/apex/BenchmarkController.getMonthlyBenchmarkDates";
import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Benchmark__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Benchmark__c.Shoulder_Press__c";

export default class MemberDetails extends LightningElement {
  //Fields for conditional rendering
  fitnessLevelPieChart = true;
  annualProgressLineGraph;
  monthlyProgressLineGraph;
  currentProgressBarGraph;


  subscription = null;

  //Fields for Bar Graph
  currentBackSquat = 0;
  currentDeadlift= 0;
  currentBenchPress = 0;
  currentShoulderPress = 0;
  goalBackSquat = 0;
  goalDeadlift = 0;
  goalBenchPress = 0;
  goalShoulderPress = 0;

  //Fields for Line Graph
  bp;
  bs;
  dl;
  sp;
  months;

  error;
  recordId;
  Name;
   
  handleMessage(message) {
    this.recordId = message.recordId;
    if(this.annualProgressLineGraph){
      this.generateAnnualLineChart();
    }
    if(this.monthlyProgressLineGraph){
      //this.generateMonthlyLineChart();
    }
    if(this.currentProgressBarGraph){
      this.generateBarChart();
    }
  }

  async generateAnnualLineChart(){
        await getMembershipMonths({memberId: this.recordId})
        .then((data) => {
            this.months = data;
        }).catch((error) => {
          console.log("BAD");
            this.error = error;
            
            }
           );
        await getAnnualProgress({ memberId: this.recordId })
        .then((data) => {
            this.bp = data['Bench Press'] != null?  data['Bench Press'] : [];
            console.log(this.bp);
            this.bs = data['Back Squat'] != null?  data['Back Squat'] : [];
            console.log(this.bs);
            this.dl = data['Deadlift'] != null?  data['Deadlift'] : [];
            console.log(this.dl);
            this.sp = data['Shoulder Press'] != null?  data['Shoulder Press'] : [];
            console.log(this.sp);

            if (this.template.querySelector("c-benchmark-line-chart").chartCreated()) {
            this.template
                .querySelector("c-benchmark-line-chart")
                .updateChart(
                    this.bp,
                    this.bs,
                    this.dl,
                    this.sp,
                    this.months,
                );
            }
        })
        .catch((error) => {
          console.log("ALSO BAD");
            this.error = error;
            this.bp = [];
            this.bs = [];
            this.dl = [];
            this.sp = [];
            if (this.template.querySelector("c-benchmark-line-chart").chartCreated()) {
            this.template
                .querySelector("c-benchmark-line-chart")
                .updateChart(
                    this.bp,
                    this.bs,
                    this.dl,
                    this.sp,
                    this.months
                );
            }
        });
  }
      /*
    async generateMontlyLineChart(){
    await getMonthlyBenchmarkDates({memberId: this.recordId})
    .then((data) => {
        console.log(data);
        this.months = data;
        console.log(this.months);
    }).catch((error) => {
      console.log("BAD");
        this.error = error;
        
        }
    );

    await getMonthlyProgress({ memberId: this.recordId })
    .then((data) => {
        this.bp = data['Bench Press'] != null?  data['Bench Press'] : [];
        console.log(this.bp);
        this.bs = data['Back Squat'] != null?  data['Back Squat'] : [];
        console.log(this.bs);
        this.dl = data['Deadlift'] != null?  data['Deadlift'] : [];
        console.log(this.dl);
        this.sp = data['Shoulder Press'] != null?  data['Shoulder Press'] : [];
        console.log(this.sp);

        if (this.template.querySelectorAll("c-benchmark-line-chart")[1].chartCreated()) {
        this.template
            .querySelectorAll("c-benchmark-line-chart")[1]
            .updateChart(
                this.bp,
                this.bs,
                this.dl,
                this.sp,
                this.months,
            );
        }
    })
    .catch((error) => {
      console.log("ALSO BAD");
        this.error = error;
        this.bp = [];
        this.bs = [];
        this.dl = [];
        this.sp = [];
        if (this.template.querySelector("c-benchmark-line-chart")[1].chartCreated()) {
        this.template
            .querySelector("c-benchmark-line-chart")[1]
            .updateChart(
                this.bp,
                this.bs,
                this.dl,
                this.sp,
                this.months
            );
        }
    });
  }
  */
  generateBarChart(){
    console.log('Generating Bar Chart');
    this.currentBackSquat = 0;
    this.currentDeadlift= 0;
    this.currentBenchPress = 0;
    this.currentShoulderPress = 0;
    this.goalBackSquat = 0;
    this.goalDeadlift = 0;
    this.goalBenchPress = 0;
    this.goalShoulderPress = 0;
    getBenchmarks({memberId : this.recordId})
      .then((data) => {
        let curBen = data['Current'];
        console.log(curBen);
        let goalBen = data['Goal'];
        console.log(goalBen)
        this.currentBackSquat = getSObjectValue(curBen, BACKSQUAT_FIELD) !=null? getSObjectValue(curBen, BACKSQUAT_FIELD):0;
        console.log(this.currentBackSquat);
        this.currentDeadlift = getSObjectValue(curBen, DEADLIFT_FIELD) != null? getSObjectValue(curBen, DEADLIFT_FIELD):0 ;
        this.currentBenchPress = getSObjectValue(curBen, BENCHPRESS_FIELD) !=null? getSObjectValue(curBen, BENCHPRESS_FIELD):0;
        this.currentShoulderPress = getSObjectValue(curBen, SHOULDERPRESS_FIELD) != null? getSObjectValue(curBen, SHOULDERPRESS_FIELD):0;
        this.goalBackSquat = getSObjectValue(goalBen, BACKSQUAT_FIELD) != null? getSObjectValue(goalBen, BACKSQUAT_FIELD):0;
        this.goalDeadlift = getSObjectValue(goalBen, DEADLIFT_FIELD) != null? getSObjectValue(goalBen, DEADLIFT_FIELD):0 ;
        this.goalBenchPress = getSObjectValue(goalBen, BENCHPRESS_FIELD) !=null? getSObjectValue(goalBen, BENCHPRESS_FIELD):0;
        this.goalShoulderPress = getSObjectValue(goalBen, SHOULDERPRESS_FIELD) != null? getSObjectValue(goalBen, SHOULDERPRESS_FIELD):0;
        if (this.template.querySelector("c-benchmark-bar-chart").chartCreated()) {
          console.log('Updating Bar Chart');
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
        }
       );
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
        console.log(message);
        this.handleMessage(message);        
      }
    );
    

  }
  // Standard lifecycle hooks used to sub/unsub to message channel
  connectedCallback() {
    this.subscribeToMessageChannel();
  }

  handleSelect(event){
    console.log(event.target.value);
     switch(event.target.value){
       case "fitnessLevelPieChart":
          this.fitnessLevelPieChart = true;
          this.annualProgressLineGraph = false;
          this.monthlyProgressLineGraph = false;
          this.currentProgressBarGraph = false;
          break;
        case "annualProgressLineGraph":
          this.fitnessLevelPieChart = false;
          this.annualProgressLineGraph = true;
          this.monthlyProgressLineGraph = false;
          this.currentProgressBarGraph = false;
          if(this.recordId != null){
            this.generateAnnualLineChart();
          }
          break;
        case "monthlyProgressLineGraph":
          this.fitnessLevelPieChart = false;
          this.annualProgressLineGraph = false;
          this.monthlyProgressLineGraph = true;
          this.currentProgressBarGraph = false;
          break;
        case "currentProgressBarGraph":
          this.fitnessLevelPieChart = false;
          this.annualProgressLineGraph = false;
          this.monthlyProgressLineGraph = false;
          this.currentProgressBarGraph = true;
          if(this.recordId != null){
            this.generateBarChart();
          }
          break;
        default:
          this.fitnessLevelPieChart = false;
          this.annualProgressLineGraph = false;
          this.monthlyProgressLineGraph = false;
          this.currentProgressBarGraph = false;
     }
        
  }
}
