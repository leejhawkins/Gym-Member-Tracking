import { LightningElement, wire } from 'lwc';
import findMembers from '@salesforce/apex/MemberController.findMembers';
import { publish, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';
const DELAY = 100;

export default class MemberOperations extends LightningElement {
    searchKey = '';
    
    @wire(findMembers,{searchKey:'$searchKey'})members;
    @wire(MessageContext)
    messageContext;

    handleContactSelect(event) {
        event.preventDefault();
        const payload = { recordId: event.target.member.Id };
        
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }

    handleKeyChange(event) {
        // Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

}