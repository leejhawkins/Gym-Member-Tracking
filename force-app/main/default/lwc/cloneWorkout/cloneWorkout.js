import { LightningElement, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import cloneWorkout from '@salesforce/apex/WorkoutController.cloneWorkout';
export default class CloneWorkout extends LightningElement {
    @api recordId;
    error;
    workoutDate;
    workoutName;
    
    handleNameChange(event){
        this.workoutName = event.target.value;
    }

    handleDateChange(event) {
        this.workoutDate = event.target.value;
    }

    handleClick(){
        cloneWorkout(
            {workoutId: this.recordId, 
            workoutName: this.workoutName,
            workoutDate: this.workoutDate}
            )
            .then(result => {
                window.console.log('result => ' + result); 
                const toast = new ShowToastEvent({
                    title:'Success!',
                    message:'Workout created successfully',
                    variant:'success'
                  });
                  this.dispatchEvent(toast);
              })
              .catch(error => {
                const toast = new ShowToastEvent({
                    title:'Failure!',
                    message:'Workout not created successfully ' + this.recordId,
                    variant:'failure'
                  });
                  this.dispatchEvent(toast);
                  this.error = error.getMessage;
              })
    }

}