import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


import { subscribe, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

import NAME_FIELD from '@salesforce/schema/Member__c.Name';
import LEVEL_FIELD from '@salesforce/schema/Member__c.Fitness_Level__c';
import EMAIL_FIELD from '@salesforce/schema/Member__c.Email__c';


const fields = [
    NAME_FIELD,   
    LEVEL_FIELD,
    EMAIL_FIELD
];

export default class MemberDetails extends LightningElement {
    subscription = null;
    recordId;

    Name;
    Email__c;
    Fitness_Level__c;

    @wire(getRecord, { recordId: '$recordId', fields })
    wiredRecord({ error, data }) {
        if (error) {
            this.dispatchToast(error);
        } else if (data) {
            fields.forEach(
                (item) => (this[item.fieldApiName] = getFieldValue(data, item))
            );
        }
    }

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            RECORD_SELECTED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    // Handler for message received by component
    handleMessage(message) {
        this.recordId = message.recordId;
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

}