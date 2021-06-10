import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class RecordLift extends LightningElement {
  @api memberid;
  @api membername;
  date = new Date();
  reps;
  strength;
  type;
  weight;
  workoutDescription;
  showForm = false;

  handleSelect(event) {
    this.benchmarkAPI = event.target.value;
    switch (this.benchmarkAPI) {
      case "Back_Squat__c":
        this.benchmarkField = "Back Squat";
        break;
      case "Deadlift__c":
        this.benchmarkField = "Deadlift";
        break;
      case "Bench_Press__c":
        this.benchmarkField = "Bench Press";
        break;
      case "Shoulder_Press__c":
        this.benchmarkField = "Shoulder Press";
        break;
      default:
        this.benchmarkField = null;
    }
  }
  handleClick() {
    this.showForm = !this.showForm;
  }
  handleChange(event) {
    this[event.target.name] = event.target.value;
  }
  handleSuccess() {
    this.date = new Date();
    this.reps = null;
    this.weight = null;

    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Lift added",
        variant: "success"
      })
    );
    const recordLift = new CustomEvent("record", { id: this.memberid });
    this.dispatchEvent(recordLift);
  }

  get benchmarkName() {
    return `${this.membername} ${this.benchmarkField} ${this.reps} x  Rep Max`.trim();
  }
  get computedWeight() {
    return parseInt(this.weight * (36 / (37 - this.reps)));
  }
}
