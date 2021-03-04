import { LightningElement,wire } from 'lwc';
import { getSObjectValue } from '@salesforce/apex';
import getAllWorkoutsForDay from '@salesforce/apex/WorkoutController.getAllWorkoutsForDay';
import DESCRIPTION_FIELD from '@salesforce/schema/Workout__c.Workout_Description__c';
import LEVEL_FIELD from '@salesforce/schema/Workout__c.Fitness_Level__c';
import ID_FIELD from '@salesforce/schema/Workout__c.Id';
import DATE_FIELD from '@salesforce/schema/Workout__c.Date__c';

export default class OwnerWorkoutView extends LightningElement {
    workoutDate = null;

   
    @wire(getAllWorkoutsForDay,{workoutDate:'$workoutDate',fitnessLevel:'Beginner'}) workout;
    @wire(getAllWorkoutsForDay,{workoutDate:'$workoutDate',fitnessLevel:'Intermediate'}) intermediateWorkout;
    @wire(getAllWorkoutsForDay,{workoutDate:'$workoutDate',fitnessLevel:'Advanced'}) advancedWorkout;
    @wire(getAllWorkoutsForDay,{workoutDate:'$workoutDate',fitnessLevel:'Elite'}) eliteWorkout;

    get workoutId(){
        return this.workout.data
        ? getSObjectValue(this.workout.data, ID_FIELD):'';
    }
    get intermediateWorkoutId(){
        return this.intermediateWorkout.data
        ? getSObjectValue(this.intermediateWorkout.data, ID_FIELD):'';
    }
    get advancedWorkoutId(){
        return this.advancedWorkout.data
        ? getSObjectValue(this.advancedWorkout.data, ID_FIELD):'';
    }
    get eliteWorkoutId(){
        return this.eliteWorkout.data
        ? getSObjectValue(this.eliteWorkout.data, ID_FIELD):'';
    }
    get targetDate(){
        return this.workout.data
        ? getSObjectValue(this.workout.data, DATE_FIELD):'';
    }
    successHandler(event){
        this.eliteWorkoutId = event.detail.id;
    }
    handleChange(event) {
        this.workoutDate = event.target.value
    }
}