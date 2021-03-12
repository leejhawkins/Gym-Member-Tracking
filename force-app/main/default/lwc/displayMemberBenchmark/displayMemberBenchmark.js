import { LightningElement , api} from 'lwc';
//import { getSObjectValue } from '@salesforce/apex';
import getGoalBenchmark from '@salesforce/apex/BenchmarkController.getGoalBenchmark';
import getBenchmark from '@salesforce/apex/BenchmarkController.getBenchmark';

//import BACKSQUAT_FIELD from '@salesforce/schema/Benchmark__c.Back_Squat__c';
//import DEADLIFT_FIELD from '@salesforce/schema/Benchmark__c.Deadlift__c';

//imperative apex with direct assignment to public template properties
export default class DisplayMemberBenchmark extends LightningElement {
          @api recordId;

          backsquatGoal
          deadliftGoal
          backsquatCurrent
          deadliftCurrent
        
          // private
          _goalData;
          _benchmarkData;
        
          //directly assigned what comes back from server payload (this._goalData) to your template bound variable
          async connectedCallback() {
            try {
              this._goalData = await getGoalBenchmark({ memberId: this.recordId });
              this._benchmarkData = await getBenchmark({ memberId: this.recordId });
            } catch (error) {
              console.error(error)
            }
            if (this._goalData) {
              this.backsquatGoal = this._goalData.Back_Squat__c;
              this.deadliftGoal = this._goalData.Deadlift__c;
            }
            if (this._benchmarkData) {
              this.backsquatCurrent = this._benchmarkData.Back_Squat__c;
              //console.log(this.backsquatCurrent);
              this.deadliftCurrent = this._benchmarkData.Deadlift__c;
              //console.log(this.deadliftCurrent);
            }
          }
      

}
   

