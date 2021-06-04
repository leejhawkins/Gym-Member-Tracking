import { LightningElement, wire, api } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import { subscribe, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getBenchmarks from "@salesforce/apex/BenchmarkController.getBenchmarks";

import NAME_FIELD from "@salesforce/schema/Member__c.Name";
import LEVEL_FIELD from "@salesforce/schema/Member__c.Fitness_Level__c";
import EMAIL_FIELD from "@salesforce/schema/Member__c.Email__c";
import PICTURE_FIELD from "@salesforce/schema/Member__c.Picture__c";
import CURRENT_BENCHMARK_FIELD from "@salesforce/schema/Member__c.Current_Benchmark__c";
import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import GENDER_FIELD from "@salesforce/schema/Member__c.Gender__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Benchmark__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Benchmark__c.Shoulder_Press__c";

const fields = [
  NAME_FIELD,
  LEVEL_FIELD,
  EMAIL_FIELD,
  PICTURE_FIELD,
  CURRENT_BENCHMARK_FIELD,
  GENDER_FIELD
];

export default class MemberDetails extends LightningElement {
  subscription = null;
  currentBackSquat = 0;
  currentDeadlift = 0;
  currentBenchPress = 0;
  currentShoulderPress = 0;
  goalBackSquat = 0;
  goalDeadlift = 0;
  goalBenchPress = 0;
  goalShoulderPress = 0;

  @api
  recordid;

  Name;
  Email__c;
  Fitness_Level__c;
  Picture__c;
  Current_Benchmark__c;
  Gender__c;

  @wire(getRecord, { recordId: "$recordid", fields })
  wiredRecord({ error, data }) {
    if (error) {
      this.dispatchToast(error);
    } else if (data) {
      fields.forEach(
        (item) =>
          (this[item.fieldApiName] =
            getFieldValue(data, item) != null
              ? getFieldValue(data, item)
              : item.fieldApiName === "Picture__c"
              ? "https://thumbs.dreamstime.com/z/avatar-fitness-man-running-icon-over-white-background-vector-illustration-avatar-fitness-man-running-icon-165673931.jpg"
              : "")
      );
    }
  }
  @wire(getBenchmarks, {
    benchmarkId: "$Current_Benchmark__c",
    gender: "$Gender__c"
  })
  wiredBenchmarks({ error, data }) {
    if (error) {
      console.log(data);
    } else if (data) {
      this.updateBenchmarkChart(data);
    }
  }

  updateBenchmarkChart(data) {
    let curBen = data.Current;
    let goalBen = data.Goal;
    this.currentBackSquat =
      getSObjectValue(curBen, BACKSQUAT_FIELD) != null
        ? getSObjectValue(curBen, BACKSQUAT_FIELD)
        : 0;
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
    this.nextLevel = getSObjectValue(goalBen, LEVEL_FIELD);
    if (this.template.querySelector("c-member-bar-chart").chartCreated()) {
      this.template
        .querySelector("c-member-bar-chart")
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
  }
  handleRecord() {
    getBenchmarks({ memberId: this.recordid })
      .then((data) => {
        this.updateBenchmarkChart(data);
      })
      .catch((error) => {
        console.log(error);
      });
  }

  get toBSNextLevel() {
    return this.currentBackSquat >= this.goalBackSquat
      ? `Achieved!✔️`
      : ` ${this.goalBackSquat - this.currentBackSquat}lbs `;
  }
  get toDLNextLevel() {
    return this.currentDeadlift >= this.goalDeadlift
      ? `Achieved!✔️`
      : ` ${this.goalDeadlift - this.currentDeadlift}lbs `;
  }
  get toBPNextLevel() {
    return this.currentBenchPress >= this.goalBenchPress
      ? `Achieved!✔️`
      : ` ${this.goalBenchPress - this.currentBenchPress}lbs `;
  }
  get toSPNextLevel() {
    return this.currentShoulderPress >= this.goalShoulderPress
      ? `Achieved!✔️`
      : `${this.goalShoulderPress - this.currentShoulderPress}lbs `;
  }
  get getBSStyle() {
    return this.currentBackSquat >= this.goalBackSquat
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }
  get getDLStyle() {
    return this.currentDeadlift >= this.goalDeadlift
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }
  get getBPStyle() {
    return this.currentBenchPress >= this.goalBenchPress
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }
  get getSPStyle() {
    return this.currentShoulderPress >= this.goalShoulderPress
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }

  handleMessage(message) {
    this.recordid = message.recordid;
  }

  @wire(MessageContext)
  messageContext;

  subscribeToMessageChannel() {
    this.subscription = subscribe(
      this.messageContext,
      RECORD_SELECTED_CHANNEL,
      (message) => this.handleMessage(message)
    );
  }
  connectedCallback() {
    this.subscribeToMessageChannel();
  }
  handleShowModal() {
    const modal = this.template.querySelector("c-email-modal");
    modal.show();
  }

  handleCancelModal() {
    const modal = this.template.querySelector("c-email-modal");
    modal.hide();
  }
}
