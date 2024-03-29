import { LightningElement } from "lwc";
import Id from "@salesforce/user/Id";
import getMember from "@salesforce/apex/ContactController.getMember";

export default class IdentifyMember extends LightningElement {
  userId = Id;
  recordid;
  memberName;
  error;

  connectedCallback() {
    getMember({ userId: this.userId })
      .then((data) => {
        this.recordid = data.ContactId;
        this.memberName = data.Name;
        console.log(this.recordid);
      })
      .catch((error) => {
        this.error = error;
        console.log(this.error);
      });
  }
  handleRecordScore(event) {
    this.recordid = null;
    this.recordid = event.detail.id;
  }
}
