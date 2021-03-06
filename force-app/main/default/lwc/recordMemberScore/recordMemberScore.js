import { LightningElement, api, wire } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import { getSObjectValue } from "@salesforce/apex";
import MOMENT_JS from "@salesforce/resourceUrl/moment";
import getScoresByMember from "@salesforce/apex/ScoreController.getScoresByMember";
import getAllWorkoutsForDay from "@salesforce/apex/WorkoutController.getAllWorkoutsForDay";
import getScoreRecordTypes from "@salesforce/apex/ScoreController.getScoreRecordTypes";
import LEVEL_FIELD from "@salesforce/schema/Workout__c.Fitness_Level__c";
import ID_FIELD from "@salesforce/schema/Workout__c.Id";
import TYPE_FIELD from "@salesforce/schema/Workout__c.Type__c";
export default class RecordMemberScore extends LightningElement {
  @api memberid;
  @api membername;
  fields;
  workoutDate = new Date().toISOString();
  fitnessLevel;
  workoutId;
  scoreId;
  scoreRecordTypes;
  recordTypeId;
  minutes;
  seconds;
  workoutType;
  fieldOne;
  fieldTwo;
  weight;
  connectedCallback() {
    getScoreRecordTypes()
      .then((data) => {
        this.scoreRecordTypes = data;
        console.log(this.scoreRecordTypes);
        console.log(this.memberid);
      })
      .catch((err) => console.log(err));
    if (this.momentjsInitialized) {
      return;
    }
    this.momentjsInitialized = true;
    loadScript(this, MOMENT_JS)
      .then(() => {
        // eslint-disable-next-line no-undef
        this.workoutDate = moment().format("YYYY-MM-DD");
      })
      .catch((error) => {
        this.error = error;
      });
  }
  @wire(getAllWorkoutsForDay, { workoutDate: "$workoutDate" })
  getWorkoutId({ error, data }) {
    if (data) {
      this.workouts = data;
      this.workoutId = null;
      this.scoreId = null;
      console.log(this.workouts.length);
      if (this.workouts.length !== 0) {
        this.getWorkout();
      }
    } else if (error) {
      this.error = error;
    }
  }
  @wire(getScoresByMember, { memberId: "$memberid" })
  setScores({ error, data }) {
    if (data) {
      this.scores = data;
      this.scoreId =
        this.scores[this.workoutId] !== undefined
          ? this.scores[this.workoutId]
          : null;
    } else if (error) {
      this.error = error;
    }
  }

  handleChange(event) {
    this[event.target.name] = event.target.value;
  }

  handleSelect(event) {
    this.fitnessLevel = event.target.value;
    this.workoutId = null;
    this.scoreId = null;
    if (this.workouts.length !== 0) {
      this.getWorkout();
    }
  }
  handleSuccess(event) {
    console.log(event.detail.id);
    this.scoreId = event.detail.id;
    this.minutes = null;
    this.seconds = null;
    const inputFields = this.template.querySelectorAll("lightning-input-field");
    if (inputFields) {
      inputFields.forEach((field) => {
        field.reset();
      });
    }
    const recordLift = new CustomEvent("recordscore", {
      detail: { id: this.memberid }
    });
    this.dispatchEvent(recordLift);
  }
  getWorkout() {
    this.workouts.forEach((workout) => {
      let fitnessLevel = getSObjectValue(workout, LEVEL_FIELD);
      this.workoutType = getSObjectValue(workout, TYPE_FIELD);
      if (this.fitnessLevel === fitnessLevel) {
        this.workoutId = getSObjectValue(workout, ID_FIELD);
        console.log("maybe error at 110");
        this.recordTypeId = this.scoreRecordTypes[this.workoutType];

        this.scoreId =
          this.scores[this.workoutId] !== undefined
            ? this.scores[this.workoutId]
            : null;
        this.fieldOne =
          this.workoutType === "For Time" ? "Minutes__c" : "Rounds__c";
        this.fieldTwo =
          this.workoutType === "For Time" ? "Seconds__c" : "Reps__c";
        this.fields = ["Weight__c", this.fieldOne, this.fieldTwo];
      }
    });
  }
  get scoreName() {
    return `${this.membername} ${this.workoutDate}`.trim();
  }
}
