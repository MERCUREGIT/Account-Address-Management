/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 02/01/2023 
 * 
 */
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { api, wire, LightningElement, track } from 'lwc';
import getRelatedAddresses from '@salesforce/apex/AccountAddressController.getRelatedAddresses';
import handleAddressDelete from '@salesforce/apex/AccountAddressController.deleteAddress';
import { NavigationMixin } from 'lightning/navigation';

import CITY_FIELD from '@salesforce/schema/Account_Address__c.city__c';
import NAME_FIELD from '@salesforce/schema/Account_Address__c.Name';
import COUNTRY_FIELD from '@salesforce/schema/Account_Address__c.Country__c';
import STATE_FIELD from '@salesforce/schema/Account_Address__c.state__c';
import IS_MAIN_FIELD from '@salesforce/schema/Account_Address__c.Is_main__c';
import STREET_FIELD from '@salesforce/schema/Account_Address__c.street__c';
import POSTALCODE_FIELD from '@salesforce/schema/Account_Address__c.PostalCode__c';
import ADDRESS_TYPE_FIELD from '@salesforce/schema/Account_Address__c.Address_Type__c';
import ACCOUNT_ADDRESS_ACCOUNT_FIELD from '@salesforce/schema/Account_Address__c.Account__c';

export default class AddressManager extends LightningElement {

    fields = [NAME_FIELD, CITY_FIELD, COUNTRY_FIELD, STATE_FIELD, IS_MAIN_FIELD, STREET_FIELD, POSTALCODE_FIELD, ADDRESS_TYPE_FIELD, ACCOUNT_ADDRESS_ACCOUNT_FIELD];

    isEdit = false;
    isViewOnly = false;
    isCreate = false;
    isDelete = false;

    @api recordIdToEdit = "";
    fecthError;

    @track
    addresses=[];

    error =undefined;
    stack = undefined;

    @api objectApiName;
    @api recordId;

    @wire(getRelatedAddresses, {
        recordId: '$recordId'
    })
    getRelatedAccountAddress({ error, data }) {
        if (data) {
            this.addresses = data;            
            this.fecthError = undefined;
        } else if (error) {
            this.fecthError = error;
            this.addresses = undefined;
        }
    }

    deleteAddress(event) {
        let id = event.target.dataset.id;
        this.isDelete = true;
        handleAddressDelete({ recordId: id.toString() })
            .then(res => {
                this.addresses = this.addresses.filter(address => { return address.Id !== id });
                this.isDelete = false;
                console.log(res);
                this.showToast('Record deleted with success');
            }).catch(error => {
                console.log('Error :::: ', error);
                this.isDelete = false;

            })
    }

    get isAction() {
        return (this.isCreate || this.isEdit || this.isViewOnly);
    }

    createRecord(event) {
        event.preventDefault();
        // eslint-disable-next-line @lwc/lwc/no-api-reassignments
        this.recordIdToEdit='';
        this.cancelAction();
        this.isCreate = !this.isCreate;
        this.showToast('Record created with success');
    }

    toggleEdit(event) {
        event.preventDefault();
        this.cancelAction();
        // eslint-disable-next-line @lwc/lwc/no-api-reassignments
        this.recordIdToEdit = event.target.dataset.id;
        this.isEdit = !this.isEdit;
        

    }

    cancelAction() {
        this.isViewOnly = false;
        this.isEdit = false;
        this.isCreate = false;
    }

    viewOnly(event) {
        this.cancelAction();
        // eslint-disable-next-line @lwc/lwc/no-api-reassignments
        this.recordIdToEdit = event.target.dataset.id;
        console.log(this.recordIdToEdit);
        this.isViewOnly = !this.isViewOnly;
    }

    // eslint-disable-next-line no-unused-vars
    errorCallback(error, stack) {
        this.error = error;
        console.log('Error :::::', JSON.stringify(error));
        console.log(error);
    }

    showToast(message) {
        const event = new ShowToastEvent({
            title: '',
            message: message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    onSuccess(){
        this.showToast('Operation with success');
        window.location.reload();
    }

    handleNavigate(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.id,
                objectApiName: 'Account_Address__c',
                actionName: 'view',
            }
        })
    }

}