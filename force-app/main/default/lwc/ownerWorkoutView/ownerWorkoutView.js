import { LightningElement,wire } from 'lwc';
import { getSObjectValue } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllWorkoutsForDay from '@salesforce/apex/WorkoutController.getAllWorkoutsForDay';
import LEVEL_FIELD from '@salesforce/schema/Workout__c.Fitness_Level__c';
import ID_FIELD from '@salesforce/schema/Workout__c.Id';
import DATE_FIELD from '@salesforce/schema/Workout__c.Date__c';

export default class OwnerWorkoutView extends LightningElement {
    workoutDate = null;
    error;
    beginnerId = null;
    advancedId = null;
    intermediateId = null;
    eliteId = null;

    @wire(getAllWorkoutsForDay,{workoutDate:'$workoutDate'})
    getEliteWorkout({ error, data }) {
        if (data) {
            this.beginnerId = null;
            this.advancedId = null;
            this.intermediateId = null;
            this.eliteId = null;
            data.forEach(workout=> {
                
                let fitnessLevel = getSObjectValue(workout,LEVEL_FIELD);
                switch(fitnessLevel) {
                    case 'Beginner':
                        this.beginnerId = getSObjectValue(workout,ID_FIELD)
                        console.log(this.beginnerId)
                    break;
                    case 'Intermediate':
                        this.intermediateId = getSObjectValue(workout,ID_FIELD)
                    break;
                    case 'Advanced':
                        this.advancedId = getSObjectValue(workout,ID_FIELD)
                    break;
                    case 'Elite':
                        this.eliteId = getSObjectValue(workout,ID_FIELD)
                    break;
                    default:
                }    
            })
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }

    get targetDate(){
        return this.workout.data
        ? getSObjectValue(this.workout.data, DATE_FIELD):'';
    }
    handleBeginner(event){
        this.beginnerId = event.detail.id;
        this.showToast('Beginner');
    }
    handleIntermediate(event){
        this.intermediateId = event.detail.id;
        this.showToast('Intermediate');
    }
    handleAdvanced(event){
        this.advancedId = event.detail.id;
        this.showToast('Advanced');
    }
    handleElite(event){
        this.eliteId = event.detail.id;
        this.showToast('Elite');
    }
    showToast(level){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: level + ' workout created',
                variant: 'success'
            })
        );
    }
    handleChange(event) {
        this.workoutDate = event.target.value
    }
}