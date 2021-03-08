import { LightningElement,api } from 'lwc';

export default class WorkoutDiv extends LightningElement {
    @api workoutid;
    @api date;
    @api name;
    edit = false;
    handleSuccess(event){
        this.edit = false;
        const id = event.detail.id;
        const successEvent = new CustomEvent('add',{
            detail:{id:id,level:this.name}
        })
        this.dispatchEvent(successEvent);
    }
    showEdit(){
        this.edit = true;
    }
}