import { LightningElement, wire } from "lwc";
import { subscribe, MessageContext } from "lightning/messageService";
import workoutGifs from "@salesforce/resourceUrl/Gifs";
import GIF_SEARCH_KEY from "@salesforce/messageChannel/Gif_Search_String__c";

export default class DisplayWorkoutGifs extends LightningElement {
  gifs;
  searchKey;
  allGifs;
  matches;
  connectedCallback() {
    let request = new XMLHttpRequest();
    request.open("GET", workoutGifs, false);
    request.send(null);
    this.allGifs = JSON.parse(request.responseText);
    this.subscribeToMessageChannel();
  }
  subscribeToMessageChannel() {
    this.subscription = subscribe(
      this.messageContext,
      GIF_SEARCH_KEY,
      (message) => this.handleMessage(message)
    );
  }
  @wire(MessageContext)
  messageContext;

  handleMessage(message) {
    this.searchKey = message.searchKey;
    this.gifs = this.allGifs.filter(
      (gif) =>
        gif.Name.toLowerCase().indexOf(this.searchKey.toLowerCase()) !== -1
    );
    this.matches = this.gifs.length > 0 ? true : false;
  }
  dragGif(event) {
    console.log(event.target.name);
    event.dataTransfer.setData("text", event.target.name);
  }
}
