import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import MEMBER_OBJECT from "@salesforce/schema/Contact";
import NAME_FIELD from "@salesforce/schema/Contact.Name";
import DOB_FIELD from "@salesforce/schema/Contact.Birthdate";
import HEIGHTFT_FIELD from "@salesforce/schema/Contact.Height_Feet__c";
import HEIGHTIN_FIELD from "@salesforce/schema/Contact.Height_Inches__c";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email__c";
import FITNESSLEVEL_FIELD from "@salesforce/schema/Contact.Fitness_Level__c";
import WEIGHT_FIELD from "@salesforce/schema/Contact.Weight__c";
import GENDER_FIELD from "@salesforce/schema/Contact.Gender__c";

export default class AddMember extends LightningElement {
  memberObject = MEMBER_OBJECT;
  nameField = NAME_FIELD;
  dobField = DOB_FIELD;
  heightFtField = HEIGHTFT_FIELD;
  heightInField = HEIGHTIN_FIELD;
  emailField = EMAIL_FIELD;
  fitnessLevelField = FITNESSLEVEL_FIELD;
  weightField = WEIGHT_FIELD;
  genderField = GENDER_FIELD;

  showSuccessToast() {
    const evt = new ShowToastEvent({
      title: "Member Added",
      message: "Opearation sucessful",
      variant: "success",
      mode: "dismissable"
    });
    this.dispatchEvent(evt);
    window.location.reload();
  }
}
