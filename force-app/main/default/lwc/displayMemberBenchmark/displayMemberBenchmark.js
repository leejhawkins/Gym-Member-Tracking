import { LightningElement , api} from 'lwc';
import getGoalBenchmark from '@salesforce/apex/BenchmarkController.getGoalBenchmark';
import getBenchmark from '@salesforce/apex/BenchmarkController.getBenchmark';


export default class DisplayMemberBenchmark extends LightningElement {
          @api recordId;

          backsquatGoal
          deadliftGoal
          backsquatCurrent
          deadliftCurrent
          benchpressGoal
          benchpressCurrent
          shoulderpressGoal
          shoulderpressCurrent
        
          // private
          // Get the current and goal data
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
              this.benchpressGoal = this._goalData.Bench_Press__c;
              this.shoulderpressGoal = this._goalData.Shoulder_Press__c;
            }
            if (this._benchmarkData) {
              this.backsquatCurrent = this._benchmarkData.Back_Squat__c;
              this.deadliftCurrent = this._benchmarkData.Deadlift__c;
              this.benchpressCurrent = this._benchmarkData.Bench_Press__c;
              this.shoulderpressCurrent = this._benchmarkData.Shoulder_Press__c;
            }
          }
      

}
   

