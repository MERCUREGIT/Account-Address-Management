import { api, LightningElement } from 'lwc';

export default class AddressForm extends LightningElement {
    city__c;
    name;
    Account_c;
    country__c;
    state__c;
    street__c;
    PostalCode__c;
    Address_Type__c;

    @api extistingAddress;

    cancelEdit(){
        this.dispatchEvent(new CustomEvent('cancel'));
    }
}