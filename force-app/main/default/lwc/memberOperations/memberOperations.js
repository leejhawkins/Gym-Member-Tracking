import { LightningElement } from 'lwc';
import findMembers from '@salesforce/apex/MemberController.findMembers';


export default class MemberOperations extends LightningElement {
    searchKey = '';
    members;
    error;

    handleKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        findMembers({ searchKey: this.searchKey })
            .then((result) => {
                this.members = result;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.members = undefined;
            });
    }
}