import { LightningElement, wire } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAllWorkoutsForDay from "@salesforce/apex/WorkoutController.getAllWorkoutsForDay";
import LEVEL_FIELD from "@salesforce/schema/Workout__c.Fitness_Level__c";
import ID_FIELD from "@salesforce/schema/Workout__c.Id";
import { loadScript } from "lightning/platformResourceLoader";
import MOMENT_JS from "@salesforce/resourceUrl/moment";

export default class OwnerWorkoutView extends LightningElement {
  workoutDate = new Date().toISOString();
  error;
  beginnerId = null;
  advancedId = null;
  intermediateId = null;
  eliteId = null;
  renderedCallback() {
    if (this.momentjsInitialized) {
      return;
    }
    this.momentjsInitialized = true;
    loadScript(this, MOMENT_JS)
      .then(() => {
        this.workoutDate = moment().format("YYYY-MM-DD");
      })
      .catch((error) => {
        this.error = error;
      });
  }

  @wire(getAllWorkoutsForDay, { workoutDate: "$workoutDate" })
  getEliteWorkout({ error, data }) {
    if (data) {
      this.beginnerId = null;
      this.advancedId = null;
      this.intermediateId = null;
      this.eliteId = null;
      data.forEach((workout) => {
        let fitnessLevel = getSObjectValue(workout, LEVEL_FIELD);
        switch (fitnessLevel) {
          case "Beginner":
            this.beginnerId = getSObjectValue(workout, ID_FIELD);
            break;
          case "Intermediate":
            this.intermediateId = getSObjectValue(workout, ID_FIELD);
            break;
          case "Advanced":
            this.advancedId = getSObjectValue(workout, ID_FIELD);
            break;
          case "Elite":
            this.eliteId = getSObjectValue(workout, ID_FIELD);
            break;
          default:
        }
      });
      this.error = undefined;
    } else if (error) {
      this.error = error;
    }
  }

  handleSuccess(event) {
    let level = event.detail.level;
    if (level === "Beginner") {
      this.beginnerId = event.detail.id;
    } else if (level === "Intermediate") {
      this.intermediateId = event.detail.id;
    } else if (level === "Advanced") {
      this.advancedId = event.detail.id;
    } else if (level === "Elite") {
      this.eliteId = event.detail.id;
    }
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: level + " workout created",
        variant: "success"
      })
    );
  }
  handleChange(event) {
    this.workoutDate = event.target.value;
  }
}
