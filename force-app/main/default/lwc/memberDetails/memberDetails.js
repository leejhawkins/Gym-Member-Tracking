import { LightningElement, wire } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import { subscribe, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";
import getBenchmarks from "@salesforce/apex/BenchmarkController.getBenchmarks";

import getMemberWorkout from '@salesforce/apex/WorkoutController.getMemberWorkout';
import NAME_FIELD from "@salesforce/schema/Member__c.Name";
import LEVEL_FIELD from "@salesforce/schema/Member__c.Fitness_Level__c";
import EMAIL_FIELD from "@salesforce/schema/Member__c.Email__c";
import BACKSQUAT_FIELD from "@salesforce/schema/Benchmark__c.Back_Squat__c";
import DEADLIFT_FIELD from "@salesforce/schema/Benchmark__c.Deadlift__c";
import BENCHPRESS_FIELD from "@salesforce/schema/Benchmark__c.Bench_Press__c";
import SHOULDERPRESS_FIELD from "@salesforce/schema/Benchmark__c.Shoulder_Press__c";
import DESCRIPTION_FIELD from "@salesforce/schema/Workout__c.Workout_Description__c"

const fields = [NAME_FIELD, LEVEL_FIELD, EMAIL_FIELD];

export default class MemberDetails extends LightningElement {
  subscription = null;
  currentBackSquat = 0;
  currentDeadlift= 0;
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
  
  handleMessage(message) {
    this.currentBackSquat = 0;
    this.currentDeadlift= 0;
    this.currentBenchPress = 0;
    this.currentShoulderPress = 0;
    this.goalBackSquat = 0;
    this.goalDeadlift = 0;
    this.goalBenchPress = 0;
    this.goalShoulderPress = 0;
    this.recordId = message.recordId;
    getBenchmarks({ memberId: this.recordId })
      .then((data) => {
        let curBen = data['Current'];
        let goalBen = data['Goal'];
        this.currentBackSquat = getSObjectValue(curBen, BACKSQUAT_FIELD);
        this.currentDeadlift = getSObjectValue(curBen, DEADLIFT_FIELD);
        this.currentBenchPress = getSObjectValue(curBen, BENCHPRESS_FIELD);
        this.currentShoulderPress = getSObjectValue(curBen, SHOULDERPRESS_FIELD);
        this.goalBackSquat = getSObjectValue(goalBen, BACKSQUAT_FIELD);
        this.goalDeadLift = getSObjectValue(goalBen, DEADLIFT_FIELD);
        this.goalBenchPress = getSObjectValue(goalBen, BENCHPRESS_FIELD);
        this.goalShoulderPress = getSObjectValue(goalBen, SHOULDERPRESS_FIELD);
        if (this.template.querySelector("c-member-bar-chart").chartCreated()) {
          this.template
            .querySelector("c-member-bar-chart")
            .updateChart(
              this.currentBackSquat,
              this.goalBackSquat,
              this.currentDeadlift,
              this.goalDeadLift,
              this.currentBenchPress,
              this.goalBenchPress,
              this.currentShoulderPress,
              this.goalShoulderPress
            );
        }
      })
      .catch((error) => {
        this.error = error;
        
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
