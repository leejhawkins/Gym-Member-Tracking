import { LightningElement, wire, track } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import { subscribe, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getBenchmarks from "@salesforce/apex/BenchmarkController.getBenchmarks";

import getMemberWorkout from "@salesforce/apex/WorkoutController.getMemberWorkout";
import NAME_FIELD from "@salesforce/schema/Contact.Name";
import LEVEL_FIELD from "@salesforce/schema/Contact.Fitness_Level__c";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Benchmark__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Benchmark__c.Shoulder_Press__c";
import DESCRIPTION_FIELD from "@salesforce/schema/Workout__c.Workout_Description__c";

const fields = [NAME_FIELD, LEVEL_FIELD, EMAIL_FIELD];

export default class SampleChartTemplate extends LightningElement {
  @track flpc = true;
  @track aplg = false;
  @track mplg = false;
  @track cpbg = false;

  subscription = null;
  currentBackSquat = 0;
  currentDeadlift = 0;
  currentBenchPress = 0;
  currentShoulderPress = 0;
  goalBackSquat = 0;
  goalDeadlift = 0;
  goalBenchPress = 0;
  goalShoulderPress = 0;
  recordId;

  Name;
  Email__c;
  Fitness_Level__c;

  @wire(getRecord, { recordId: "$recordId", fields })
  wiredRecord({ error, data }) {
    if (error) {
      this.dispatchToast(error);
    } else if (data) {
      fields.forEach(
        (item) => (this[item.fieldApiName] = getFieldValue(data, item))
      );
    }
  }
  @wire(getMemberWorkout, { memberId: "$recordId", workoutDate: null })
  workout;

  get workoutDes() {
    return this.workout.data
      ? getSObjectValue(this.workout.data, DESCRIPTION_FIELD)
      : "";
  }
  get toBSNextLevel() {
    return this.currentBackSquat >= this.goalBackSquat
      ? `Achieved!`
      : ` ${this.goalBackSquat - this.currentBackSquat}lbs `;
  }
  get toDLNextLevel() {
    return this.currentDeadlift >= this.goalDeadlift
      ? `Achieved!`
      : ` ${this.goalDeadlift - this.currentDeadlift}lbs `;
  }
  get toBPNextLevel() {
    return this.currentBenchPress >= this.goalBenchPress
      ? `Achieved!`
      : ` ${this.goalBenchPress - this.currentBenchPress}lbs `;
  }
  get toSPNextLevel() {
    return this.currentShoulderPress >= this.goalShoulderPress
      ? `Achieved!`
      : `${this.goalShoulderPress - this.currentShoulderPress}lbs `;
  }

  handleMessage(message) {
    this.currentBackSquat = 0;
    this.currentDeadlift = 0;
    this.currentBenchPress = 0;
    this.currentShoulderPress = 0;
    this.goalBackSquat = 0;
    this.goalDeadlift = 0;
    this.goalBenchPress = 0;
    this.goalShoulderPress = 0;
    this.recordId = message.recordId;
    getBenchmarks({ memberId: this.recordId })
      .then((data) => {
        let curBen = data["Current"];
        let goalBen = data["Goal"];
        console.log(goalBen);
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
      })
      .catch((error) => {
        this.error = error;
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
      (message) => this.handleMessage(message)
    );
  }
  // Standard lifecycle hooks used to sub/unsub to message channel
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

  displayFPLC() {
    this.flpc = true;
    this.aplg = false;
    this.mplg = false;
    this.cpbg = false;
  }

  displayAPLG() {
    this.flpc = false;
    this.aplg = true;
    this.mplg = false;
    this.cpbg = false;
  }
  displayMPLG() {
    this.flpc = false;
    this.aplg = false;
    this.mplg = true;
    this.cpbg = false;
  }
  displayCPBG() {
    this.flpc = false;
    this.aplg = false;
    this.mplg = false;
    this.cpbg = true;
  }
}
