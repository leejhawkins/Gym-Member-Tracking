import { LightningElement , wire, api} from 'lwc';
import { getSObjectValue } from '@salesforce/apex';


import BACKSQUAT_FIELD from '@salesforce/schema/Benchmark__c.Back_Squat__c';
import DEADLIFT_FIELD from '@salesforce/schema/Benchmark__c.Deadlift__c';


export default class DisplayMemberBenchmark extends LightningElement {
   /*
    @api recordId;
    error;

    @wire(getCurrentBenchmark,{memberId:'$recordId'})
    currentBenchmark;
    @wire(getGoalBenchmark, {memberId:'$recordId'})
    goalBenchmark;

     get firstDeadlift(){
        return this.currentBenchmark.data
        ? getSObjectValue(this.currentBenchmark.data, DEADLIFT_FIELD):'';
    }

     get firstSquat(){
        return this.currentBenchmark.data
        ? getSObjectValue(this.currentBenchmark.data, BACKSQUAT_FIELD):'';
    }


     get goalDeadlift(){
        return this.goalBenchmark.data
        ? getSObjectValue(this.goalBenchmark.data, DEADLIFT_FIELD):'';
    }

     get goalSquat(){
        return this.goalBenchmark.data
        ? getSObjectValue(this.goalBenchmark.data, BACKSQUAT_FIELD):'';
    }

   */
   

}