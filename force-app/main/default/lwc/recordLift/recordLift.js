import { LightningElement, api } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import MOMENT_JS from "@salesforce/resourceUrl/moment";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getScoreRecordTypes from "@salesforce/apex/ScoreController.getScoreRecordTypes";
import insertScoreMemberWorkout from "@salesforce/apex/ScoreController.insertScoreMemberWorkout";
export default class RecordLift extends LightningElement {
  @api memberid;
  @api membername;
  date = new Date();
  recordTypeId;
  reps;
  strength;
  type;
  minutes;
  seconds;
  weight;
  workoutDescription;
  showForm = false;
  connectedCallback() {
    getScoreRecordTypes()
      .then((data) => {
        this.scoreRecordTypes = data;
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
  handleSelect(event) {
    this.type = event.target.value;
    this.recordTypeId = this.scoreRecordTypes[this.type];
    this.fieldOne = this.type === "For Time" ? "Minutes__c" : "Rounds__c";
    this.fieldTwo = this.type === "For Time" ? "Seconds__c" : "Reps__c";
  }
  handleClick() {
    this.showForm = !this.showForm;
  }
  handleChange(event) {
    this[event.target.name] = event.target.value;
  }
  get workoutName() {
    return `${this.membername} Workout for ${this.date}`.trim();
  }

  handleSuccess(event) {
    const scoreName = this.workoutName + " Score";
    insertScoreMemberWorkout({
      name: scoreName,
      memberId: this.memberid,
      workoutId: event.detail.id,
      weight: this.weight,
      key1: this.fieldOne,
      value1: this.minutes,
      key2: this.fieldTwo,
      value2: this.seconds,
      recordType: this.recordTypeId
    }).then(() => {
      const inputFields = this.template.querySelectorAll(
        "lightning-input-field"
      );
      if (inputFields) {
        inputFields.forEach((field) => {
          field.reset();
        });
      }
      this.date = new Date();
      this.reps = null;
      this.weight = null;
      this.showForm = false;
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message: "Workout for " + this.membername + " was recorded",
          variant: "success"
        })
      );
      const recordLift = new CustomEvent("record", {
        detail: { id: this.memberid }
      });
      this.dispatchEvent(recordLift);
    });
  }
}
