import { createElement } from 'lwc';
import AddressManager from 'c/addressManager';
import getRelatedAddresses from '@salesforce/apex/AccountAddressController.getRelatedAddresses';

const mockGetAccountAddressListList = require('./data/addresses.json');

const mockGetAccountAddressListNoRecords = require('./data/noAddresses.json');

jest.mock(
  '@salesforce/apex/AccountAddressController.getRelatedAddresses',
  () => {
    const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe('c-address-manager', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('TODO: Test the number of table rows generated', () => {
        const element = createElement('c-address-manager', {
            is: AddressManager
        });
        expect(element.addresses).toBe(undefined);

        document.body.appendChild(element);
        getRelatedAddresses.emit(mockGetAccountAddressListList);

    
        return Promise.resolve().then(() => {
            const accountElements = element.shadowRoot.querySelectorAll('tr.address-item');
            expect(accountElements.length).toBe(mockGetAccountAddressListList.length);
            console.log('element.addresses',element.addresses);

      });
    });
    it('TODO: Test the number of table rows generated for no address', () => {
        const element = createElement('c-address-manager', {
            is: AddressManager
        });
        expect(element.addresses).toBe(undefined);

        document.body.appendChild(element);
        getRelatedAddresses.emit(mockGetAccountAddressListNoRecords);

    
        return Promise.resolve().then(() => {
            console.log('element.addresses',element.addresses);
            const accountElements = element.shadowRoot.querySelectorAll('tr.address-item');
            expect(accountElements.length).toBe(mockGetAccountAddressListNoRecords.length);
      });
    });
});