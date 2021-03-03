import { LightningElement, wire } from 'lwc';
import getMemberList from '@salesforce/apex/MemberController.getMemberList';

const columns = [
    { label: 'Member Name', fieldName: 'Name' },
    { label: 'Fitness Level', fieldName: 'Fitness_Level__c' },
    { label: 'Training Class', fieldName: 'Training_Class__c' }
];

export default class MemberManagerLWC extends LightningElement {
   error;
    columns = columns;

     @wire(getMemberList)
    members;
}