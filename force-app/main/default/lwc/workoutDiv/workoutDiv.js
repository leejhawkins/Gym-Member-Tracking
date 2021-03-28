import { LightningElement, api } from "lwc";

export default class WorkoutDiv extends LightningElement {
  @api workoutid;
  @api date;
  @api name;
  workoutDes = "";
  edit = false;

  handleSuccess(event) {
    this.edit = false;
    const id = event.detail.id;
    const successEvent = new CustomEvent("add", {
      detail: { id: id, level: this.name }
    });
    this.dispatchEvent(successEvent);
  }
  showEdit() {
    this.edit = !this.edit;
  }
  get workoutName() {
    return `${this.name} Workout for ${this.date}`.trim();
  }
  allowGifDrop(event) {
    event.preventDefault();
  }
  dropGif(event) {
    event.preventDefault();
    let data = event.dataTransfer.getData("text");
    const image = `<img src=${data} alt="Workout Gif" style="width:100px" />`;
    this.workoutDes = this.workoutDes + image;
  }
  handleChange(event) {
    this.workoutDes = event.target.value;
  }
}
