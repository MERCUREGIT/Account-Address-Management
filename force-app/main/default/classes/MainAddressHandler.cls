/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 * Created-on: 01/01/2023 7:40 pm
 */

public with sharing class MainAddressHandler {
    public MainAddressHandler() {

    }

    public static void traverseMainAddressUpdateOnAccount(list<address__c> addressList){

        list<id> accountIds = new list<id>();
        list<address__c> mainAdresses = new list<address__c>();

        for(address__c address : addressList){
            if(address.status__c){
                mainAdresses.add(address);
                accountIds.add(address.Account__c);
            }
        }

        list<account> relatedAccounts = new list<account>();
        relatedAccounts = [SELECT ShippingAddress, BillingAddress FROM Account WHERE id in :accountIds];

        List<Account> accountsToUpdate = new List<Account>();

        for(address__c address : addressList){
            for(Account acc:relatedAccounts){
                if(address.Account__c ==acc.id && address.Address_Type__c=='Shipping' ){
                   if(!(address[0].city__c == acc.ShippingCity &&
                        address[0].country__c == acc.ShippingCountry &&
                        address[0].state__c == acc.ShippingState &&
                        address[0].street__c == acc.ShippingStreet &&
                        address[0].Postal_code__c == acc.ShippingPostalCode &&
                        address[0].name == acc.name)){
                            
                            address[0].city__c = acc.ShippingCity &&
                            address[0].country__c = acc.ShippingCountry &&
                            address[0].state__c = acc.ShippingState &&
                            address[0].street__c =  acc.ShippingStreet &&
                            address[0].Postal_code__c = acc.ShippingPostalCode &&
                            address[0].name = acc.name;
                            accountsToUpdate.add(acc);
                   }
                }
                if(address.Account__c ==acc.id && address.Address_Type__c=='Billing' ){
                   if(!(address[0].city__c == acc.BillingCity &&
                        address[0].country__c == acc.BillingCountry &&
                        address[0].state__c == acc.BillingState &&
                        address[0].street__c == acc.BillingStreet &&
                        address[0].Postal_code__c == acc.BillingPostalCode &&
                        address[0].name == acc.name)){

                            address[0].city__c = acc.BillingCity &&
                            address[0].country__c = acc.BillingCountry &&
                            address[0].state__c = acc.BillingState &&
                            address[0].street__c =  acc.BillingStreet &&
                            address[0].Postal_code__c = acc.BillingPostalCode &&
                            address[0].name = acc.name;
                            accountsToUpdate.add(acc);
                   }
                }
            }

            update accountsToUpdate;
        }
    }
}
