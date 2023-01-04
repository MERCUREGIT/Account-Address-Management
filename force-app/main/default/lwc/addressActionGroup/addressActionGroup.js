import { api, LightningElement } from 'lwc';

export default class AddressActionGroup extends LightningElement {

    @api address;
    
    view() {
        
    }
    update() { 
        this.dispatchEvent(new CustomEvent('update'));
    }
    delete() {
        
    }
}