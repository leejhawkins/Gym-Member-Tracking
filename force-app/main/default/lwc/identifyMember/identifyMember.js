import { LightningElement, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getMember from '@salesforce/apex/ContactController.getMember';
import NAME_FIELD from "@salesforce/schema/Contact.Name";
import { publish, MessageContext } from "lightning/messageService";
import RECORD_SELECTED_CHANNEL from "@salesforce/messageChannel/Record_Selected__c";

export default class IdentifyMember extends LightningElement {
    userId = Id;
    recordid;
    
    error;
    
    connectedCallback(){
        console.log("begin");
        getMember({userId: this.userId})
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