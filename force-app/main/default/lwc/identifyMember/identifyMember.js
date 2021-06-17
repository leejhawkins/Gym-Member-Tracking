import { LightningElement } from "lwc";
import Id from "@salesforce/user/Id";
import getMember from "@salesforce/apex/ContactController.getMember";

export default class IdentifyMember extends LightningElement {
  userId = Id;
  recordid;

  error;

  connectedCallback() {
    console.log("begin");
    getMember({ userId: this.userId })
      .then((data) => {
        console.log(data);
        this.recordid = data.Id;
      })
      .catch((error) => {
        console.log(error);
        this.error = error;
      });
  }
}
