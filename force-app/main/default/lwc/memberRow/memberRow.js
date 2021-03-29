import { LightningElement, api } from "lwc";

export default class MemberRow extends LightningElement {
  @api member;
  handleSelect(event) {
    event.preventDefault();
    const selectEvent = new CustomEvent("memberselect", { bubbles: true });
    this.dispatchEvent(selectEvent);
  }
}
