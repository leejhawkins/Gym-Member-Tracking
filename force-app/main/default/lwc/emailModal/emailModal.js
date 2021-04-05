import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getSObjectValue } from "@salesforce/apex";
import sendSingleEmail from "@salesforce/apex/EmailController.sendSingleEmail";
import getMemberWorkout from "@salesforce/apex/WorkoutController.getMemberWorkout";
import DESCRIPTION_FIELD from "@salesforce/schema/Workout__c.Workout_Description__c";

export default class EmailModal extends LightningElement {
  showModal = false;
  @api name;
  @api email;
  @api level;
  @api memberid;
  workoutdes;

  @wire(getMemberWorkout, { memberId: "$memberid", workoutDate: null })
  wiredWorkout({ error, data }) {
    if (error) {
      console.log(error);
    } else if (data) {
      this.workoutdes = getSObjectValue(data, DESCRIPTION_FIELD);
    }
  }

  handleChange(event) {
    this.workoutdes = event.target.value;
  }
  sendEmail() {
    sendSingleEmail({
      name: this.name,
      email: this.email,
      description: this.workoutdes
    })
      .then(() => {
        this.hide();
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Email sent to " + this.name,
            variant: "success"
          })
        );
      })
      .catch((error) => {
        this.error = error;
        this.hide();
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: this.error,
            variant: "error"
          })
        );
      });
  }
  @api show() {
    this.showModal = true;
  }

  @api hide() {
    this.showModal = false;
  }
  handleDialogClose() {
    //Let parent know that dialog is closed (mainly by that cross button) so it can set proper variables if needed
    const closedialog = new CustomEvent("closedialog");
    this.dispatchEvent(closedialog);
    this.hide();
  }

  handleSlotTaglineChange() {
    // Only needed in "show" state. If hiding, we're removing from DOM anyway
    // Added to address Issue #344 where querySelector would intermittently return null element on hide
    if (this.showModal === false) {
      return;
    }
    const taglineEl = this.template.querySelector("p");
    taglineEl.classList.remove(CSS_CLASS);
  }

  handleSlotFooterChange() {
    // Only needed in "show" state. If hiding, we're removing from DOM anyway
    // Added to address Issue #344 where querySelector would intermittently return null element on hide
    if (this.showModal === false) {
      return;
    }
    const footerEl = this.template.querySelector("footer");
    footerEl.classList.remove(CSS_CLASS);
  }
}
