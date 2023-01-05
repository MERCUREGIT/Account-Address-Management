import { api, LightningElement } from 'lwc';
import CITY_FIELD from '@salesforce/schema/Account_Address__c.city__c';
import NAME_FIELD from '@salesforce/schema/Account_Address__c.Name';
import COUNTRY_FIELD from '@salesforce/schema/Account_Address__c.Country__c';
import STATE_FIELD from '@salesforce/schema/Account_Address__c.state__c';
import IS_MAIN_FIELD from '@salesforce/schema/Account_Address__c.Is_main__c';
import STREET_FIELD from '@salesforce/schema/Account_Address__c.street__c';
import POSTALCODE_FIELD from '@salesforce/schema/Account_Address__c.PostalCode__c';
import ADDRESS_TYPE_FIELD from '@salesforce/schema/Account_Address__c.Address_Type__c';
import ACCOUNT_ADDRESS_ACCOUNT_FIELD from '@salesforce/schema/Account_Address__c.Account__c';

export default class AddressForm extends LightningElement {
    @api recordIdToEdit;

    @api
    isedit= false;
    @api
    isviewonly = false;
    @api
    iscreate = false;

    fields = [NAME_FIELD,CITY_FIELD,COUNTRY_FIELD,STATE_FIELD,IS_MAIN_FIELD,STREET_FIELD,POSTALCODE_FIELD,ADDRESS_TYPE_FIELD,ACCOUNT_ADDRESS_ACCOUNT_FIELD];

    cancel(){
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Account created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}