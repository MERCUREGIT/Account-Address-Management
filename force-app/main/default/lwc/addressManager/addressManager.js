/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 02/01/2023 
 * 
 */

import { api, wire, LightningElement, track } from 'lwc';
import getRelatedAddresses from '@salesforce/apex/AccountAddressController.getRelatedAddresses';
import handleAddressDelete from '@salesforce/apex/AccountAddressController.deleteAddress';

export default class AddressManager extends LightningElement {

    isEdit = false;
    isViewOnly = false;
    isCreate = false;
    recordIdToEdit = "";
    fecthError;

   // @track
    addresses = [{Id:1},{Id:2},{Id:3}];



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
            console.log('fecthError ::',this.fecthError);
            this.addresses = [];
        }
    }

    handleDeleteAddress(event) {
        handleAddressDelete({ recordId: event.detail.id })
            .then(res => {
                this.addresses = [...this.addresses.filter(address => { return address.Id != event.detail.id })];
            }).catch(error => {
                console.log('Error :::: ', error)
            })
    }

    get isAction() {
        return (this.isCreate || this.isEdit || this.isViewOnly);
    }

    createRecord(event) {
        this.cancelAction();
        this.recordIdToEdit = event.detail.id;
        this.isCreate = !this.isCreate;
    }

    toggleEdit(event) {
        this.cancelAction();
        this.recordIdToEdit = event.detail.id;
        this.isEdit = !this.isEdit;
    }

    cancelAction() {
        this.isViewOnly = false;
        this.isEdit = false;
        this.isCreate = false;
    }

    viewOnly(event) {
        this.cancelAction();
        this.recordIdToEdit = event.detail.id;
        this.isViewOnly = !this.isViewOnly;
    }
}