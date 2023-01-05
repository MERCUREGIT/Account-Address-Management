import { api, LightningElement } from 'lwc';

export default class AddressActionGroup extends LightningElement {

    @api address;

    view() {
        this.dispatchEvent(new CustomEvent('view', { detail: { id: this.address.Id } }));
    }
    update() {
        this.dispatchEvent(new CustomEvent('update', { detail: { id: this.address.Id } }));
    }
    handleDeleteAddress() {
        this.dispatchEvent(new CustomEvent('deleteaddress', { detail: { id: this.address.Id } }));
    }
}