
import { LightningElement, wire, api } from "lwc";
import { getSObjectValue } from "@salesforce/apex";

import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import { subscribe, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getNextLevel from "@salesforce/apex/LiftStandardsController.getNextLevel";

import NAME_FIELD from "@salesforce/schema/Member__c.Name";
import LEVEL_FIELD from "@salesforce/schema/Member__c.Fitness_Level__c";
import EMAIL_FIELD from "@salesforce/schema/Member__c.Email__c";
import PICTURE_FIELD from "@salesforce/schema/Member__c.Picture__c";
import BACKSQUAT_FIELD from "@salesforce/schema/Member__c.Back_Squat__c";
import GENDER_FIELD from "@salesforce/schema/Member__c.Gender__c";
import DEADLIFT_FIELD from "@salesforce/schema/Member__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Member__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Member__c.Shoulder_Press__c";
import WEIGHT_FIELD from "@salesforce/schema/Member__c.Weight__c";

const fields = [
  NAME_FIELD,
  LEVEL_FIELD,
  EMAIL_FIELD,
  PICTURE_FIELD,
  BACKSQUAT_FIELD,
  DEADLIFT_FIELD,
  BENCHPRESS_FIELD,
  SHOULDERPRESS_FIELD,
  GENDER_FIELD,
  WEIGHT_FIELD
];

export default class MemberDetails extends LightningElement {
  subscription = null;
  nextLevel;
  recordId;
  goalBackSquat = 0;
  goalBenchPress = 0;
  goalDeadlift = 0;
  goalShoulderPress = 0;


  @api
  recordid;


  Name;
  Email__c;
  Fitness_Level__c;
  Picture__c;
  Back_Squat__c = 0;
  Deadlift__c = 0;
  Bench_Press__c = 0;
  Shoulder_Press__c = 0;
  Gender__c;
  Weight__c;

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
      this.updateBenchmarkChart();
    }
  }
  @wire(getNextLevel, {
    fitnessLevel: "$Fitness_Level__c",
    gender: "$Gender__c",
    weight: "$Weight__c"
  })
  wiredBenchmarks({ error, data }) {
    if (error) {
      console.log(data);
    } else if (data) {
      this.goalBackSquat = data.Back_Squat__c;
      this.goalDeadlift = data.Deadlift__c;
      this.goalBenchPress = data.Bench_Press__c;
      this.goalShoulderPress = data.Shoulder_Press__c;
      this.nextLevel = data.Fitness_Level__c;
      this.updateBenchmarkChart();
    }
  }

  updateBenchmarkChart() {
    if (this.template.querySelector("c-member-bar-chart").chartCreated()) {
      this.template
        .querySelector("c-member-bar-chart")
        .updateChart(
          this.Back_Squat__c,
          this.goalBackSquat,
          this.Deadlift__c,
          this.goalDeadlift,
          this.Bench_Press__c,
          this.goalBenchPress,
          this.Shoulder_Press__c,
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
    return this.Back_Squat__c >= this.goalBackSquat
      ? `Achieved!✔️`
      : ` ${this.goalBackSquat - this.Back_Squat__c}lbs `;
  }
  get toDLNextLevel() {
    return this.Deadlift__c >= this.goalDeadlift
      ? `Achieved!✔️`
      : ` ${this.goalDeadlift - this.Deadlift__c}lbs `;
  }
  get toBPNextLevel() {
    return this.Bench_Press__c >= this.goalBenchPress
      ? `Achieved!✔️`
      : ` ${this.goalBenchPress - this.Bench_Press__c}lbs `;
  }
  get toSPNextLevel() {
    return this.Shoulder_Press__c >= this.goalShoulderPress
      ? `Achieved!✔️`
      : `${this.goalShoulderPress - this.Shoulder_Press__c}lbs `;
  }
  get getBSStyle() {
    return this.Back_Squat__c >= this.goalBackSquat
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }
  get getDLStyle() {
    return this.Deadlift__c >= this.goalDeadlift
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }
  get getBPStyle() {
    return this.Bench_Press__c >= this.goalBenchPress
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }
  get getSPStyle() {
    return this.Shoulder_Press__c >= this.goalShoulderPress
      ? "achieved slds-col slds-size_5-of-12"
      : "next-level slds-col slds-size_5-of-12";
  }

  handleMessage(message) {
    this.recordid = message.recordid;
  }
  handleRecordScore(event) {
    this.recordId = null;
    this.recordId = event.detail.id;
    console.log(event.detail.id);
    this.updateBenchmarkChart();
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
