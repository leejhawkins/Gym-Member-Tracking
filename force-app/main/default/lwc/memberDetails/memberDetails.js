import { LightningElement, wire } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import { subscribe, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getCurrentBenchmark from "@salesforce/apex/BenchmarkController.getCurrentBenchmark";
import getGoalBenchmark from "@salesforce/apex/BenchmarkController.getGoalBenchmark";

import getMemberWorkout from '@salesforce/apex/WorkoutController.getMemberWorkout';
import NAME_FIELD from "@salesforce/schema/Member__c.Name";
import LEVEL_FIELD from "@salesforce/schema/Member__c.Fitness_Level__c";
import EMAIL_FIELD from "@salesforce/schema/Member__c.Email__c";
import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import DESCRIPTION_FIELD from "@salesforce/schema/Workout__c.Workout_Description__c"

const fields = [NAME_FIELD, LEVEL_FIELD, EMAIL_FIELD];

export default class MemberDetails extends LightningElement {
  subscription = null;
  currentBackSquat;
  currentDeadlift;
  goalBackSquat;
  goalDeadlift;
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
  
  handleMessage(message) {
    this.recordId = message.recordId;
    getCurrentBenchmark({ memberId: this.recordId })
      .then((data) => {
        this.currentBackSquat = getSObjectValue(data, BACKSQUAT_FIELD);
        this.currentDeadlift = getSObjectValue(data, DEADLIFT_FIELD);
      })
      .catch((error) => {
        this.error = error;
        this.currentBackSquat = 0;
        this.currentDeadlift = 0;
      });
    getGoalBenchmark({ memberId: this.recordId })
      .then((data) => {
        console.log(data);
        this.goalBackSquat = getSObjectValue(data, BACKSQUAT_FIELD);
        this.goalDeadLift = getSObjectValue(data, DEADLIFT_FIELD);
        if (this.template.querySelector("c-member-bar-chart").chartCreated()) {
          this.template
            .querySelector("c-member-bar-chart")
            .updateChart(
              this.currentBackSquat,
              this.goalBackSquat,
              this.currentDeadlift,
              this.goalDeadLift
            );
        }
      })
      .catch((error) => {
        this.error = error;
        this.goalBackSquat = 0;
        this.goalDeadLift = 0;
        if (this.template.querySelector("c-member-bar-chart").chartCreated()) {
          this.template
            .querySelector("c-member-bar-chart")
            .updateChart(
              this.currentBackSquat,
              this.goalBackSquat,
              this.currentDeadlift,
              this.goalDeadLift
            );
        }
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
}
