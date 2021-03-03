import { LightningElement,wire } from 'lwc';
import getAllWorkoutsForDay from '@salesforce/apex/WorkoutController.getAllWorkoutsForDay';

export default class OwnerWorkoutView extends LightningElement {
    workoutDate = null;
    @wire(getAllWorkoutsForDay,{workoutDate:'$workoutDate'}) workouts;

    handleChange(event) {
        this.workoutDate = event.target.value
    }
}