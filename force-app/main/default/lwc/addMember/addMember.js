import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import CONTACT_MEMBER from '@salesforce/schema/Contact';

import FNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import BIRTHDATE_FIELD from '@salesforce/schema/Contact.Birthdate';
import FITNESS_LEVEL_FIELD from '@salesforce/schema/Contact.Fitness_Level__c';
import TRAINING_CLASS_FIELD from '@salesforce/schema/Contact.Training_Class__c';
import HEIGHT_INCHES_FIELD from '@salesforce/schema/Contact.Height_Inches__c';
import HEIGHT_FEET_FIELD from '@salesforce/schema/Contact.Height_Feet__c';
import GENDER_FIELD from '@salesforce/schema/Contact.Gender__c';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import ACTIVE_FIELD from '@salesforce/schema/Contact.Active__c';

export default class AddMember extends LightningElement {
   
  contactMemberObject = CONTACT_MEMBER;
  fnameField = FNAME_FIELD; 
  lnameField = LNAME_FIELD;
  emailField =  EMAIL_FIELD;
  birthDateField =  BIRTHDATE_FIELD;
  fitnessLevelField =  FITNESS_LEVEL_FIELD;
  trainingClassField =  TRAINING_CLASS_FIELD;
  heightINField =  HEIGHT_INCHES_FIELD;
  heightFTField =  HEIGHT_FEET_FIELD;
  genderField =  GENDER_FIELD;
  phoneField =  PHONE_FIELD;
  activeField =  ACTIVE_FIELD;


  handleMemberCreated() {
    const evt = new ShowToastEvent({
      title: "Member Added",
      message: "Add a benchmark to the Member!",
      variant: "success",
      mode: "dismissable"
    });
    this.dispatchEvent(evt);
    window.location.reload();
  }
  
}
