import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import MEMBER_OBJECT from "@salesforce/schema/Member__c";
import NAME_FIELD from "@salesforce/schema/Member__c.Name";
import DOB_FIELD from "@salesforce/schema/Member__c.Date_of_Birth__c";
import ACTIVE_FIELD from "@salesforce/schema/Member__c.Active__c";
import HEIGHTFT_FIELD from "@salesforce/schema/Member__c.Height_Feet__c";
import HEIGHTIN_FIELD from "@salesforce/schema/Member__c.Height_Inches__c";
import EMAIL_FIELD from "@salesforce/schema/Member__c.Email__c";
import FITNESSLEVEL_FIELD from "@salesforce/schema/Member__c.Fitness_Level__c";
import TRAININGCLASS_FIELD from "@salesforce/schema/Member__c.Training_Class__c";
import GENDER_FIELD from "@salesforce/schema/Member__c.Gender__c";

export default class AddMember extends LightningElement {
  memberObject = MEMBER_OBJECT;
  nameField = NAME_FIELD;
  dobField = DOB_FIELD;
  activeField = ACTIVE_FIELD;
  heightFtField = HEIGHTFT_FIELD;
  heightInField = HEIGHTIN_FIELD;
  emailField = EMAIL_FIELD;
  fitnessLevelField = FITNESSLEVEL_FIELD;
  trainingClassField = TRAININGCLASS_FIELD;
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
