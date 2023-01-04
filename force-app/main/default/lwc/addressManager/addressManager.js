/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 02/01/2023 
 * 
 */

import { api,wire, LightningElement, track  } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';


export default class AddressManager extends LightningElement {

    display=false;
    edit= false;

    fecthError ;
    addresses = [];

    @api objectApiName;
    @api recordId;

    @wire(getRelatedListRecords, {
        parentRecordId: objectApiName,
        relatedListId: 'Account_Address__c',
        fields: ['Account_Address__c.Name', 'Account_Address__c.Account__c','Account_Address__c.Address_Type__c','Account_Address__c.city__c','Account_Address__c.Country__c','Account_Address__c.Is_main__c','Account_Address__c.state__c','Account_Address__c.street__c','Account_Address__c.PostalCode__c'],
        pageSize: 10,
    }) 
    relatedAccountAddress({ error, data }) {
        if (data) {
            this.addresses = data.records;
            this.fecthError = undefined;
        } else if (error) {
            this.fecthError = error;
            this.addresses = [];
        }
    }

    

    toggleEdit(){
        this.edit = !this.edit; 
    }
}