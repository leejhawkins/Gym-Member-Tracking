import { LightningElement } from "lwc";
import Id from "@salesforce/user/Id";
import getMember from "@salesforce/apex/ContactController.getMember";

export default class IdentifyMember extends LightningElement {
  userId = Id;
  recordid;
  memberName;
  error;

  connectedCallback() {
    console.log(Id);
    getMember({ userId: this.userId })
      .then((data) => {
        this.recordid = data.Id;
        this.memberName = data.Name;
        console.log(this.memberName);
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
