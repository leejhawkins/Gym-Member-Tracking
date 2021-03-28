import { LightningElement, api, wire } from "lwc";
import { getSObjectValue } from "@salesforce/apex";
import getMemberWorkout from "@salesforce/apex/WorkoutController.getMemberWorkout";

import DESCRIPTION_FIELD from "@salesforce/schema/Workout__c.Workout_Description__c";
import LEVEL_FIELD from "@salesforce/schema/Workout__c.Fitness_Level__c";

export default class MemberWorkout extends LightningElement {
  @api recordId;
  workoutDate = null;

  @wire(getMemberWorkout, {
    memberId: "$recordId",
    workoutDate: "$workoutDate"
  })
  workout;

  get description() {
    return this.workout.data
      ? getSObjectValue(this.workout.data, DESCRIPTION_FIELD)
      : "";
  }
  get fitnessLevel() {
    return this.workout.data
      ? getSObjectValue(this.workout.data, LEVEL_FIELD)
      : "";
  }

  handleChange(event) {
    this.workoutDate = event.target.value;
  }
}
