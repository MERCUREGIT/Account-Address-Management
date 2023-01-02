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
        relatedAccounts = [SELECT id,BillingCity,BillingCountry,BillingState, BillingStreet, BillingPostalCode, name,ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode FROM Account WHERE id in :accountIds];

        List<Account> accountsToUpdate = new List<Account>();

        for(address__c address : addressList){
            for(Account acc:relatedAccounts){
        
                if(address.Account__c ==acc.id && address.Address_Type__c=='Shipping' ){
                   if(!(address.city__c == acc.ShippingCity && address.country__c == acc.ShippingCountry && address.state__c == acc.ShippingState && address.street__c == acc.ShippingStreet && address.Postal_code__c == acc.ShippingPostalCode && address.name == acc.name)){
                            
                            acc.ShippingCity = address.city__c;
                            acc.ShippingCountry = address.country__c;
                            acc.ShippingState = address.state__c ;
                            acc.ShippingStreet = address.street__c;
                            acc.ShippingPostalCode = address.Postal_code__c;
                            acc.name = address.name;
                            accountsToUpdate.add(acc);
                   }
                }
                
                if(address.Account__c ==acc.id && address.Address_Type__c=='Billing' ){
                   if(!(address.city__c == acc.BillingCity &&
                        address.country__c == acc.BillingCountry &&
                        address.state__c == acc.BillingState &&
                        address.street__c == acc.BillingStreet &&
                        address.Postal_code__c == acc.BillingPostalCode &&
                        address.name == acc.name)){

                            acc.BillingCity = address.city__c ; 
                            acc.BillingCountry =  address.country__c;
                            acc.BillingState = address.state__c;
                            acc.BillingStreet = address.street__c;
                            acc.BillingPostalCode = address.Postal_code__c;
                            acc.name= address.name;
                            accountsToUpdate.add(acc);
                   }
                }
            }

            update accountsToUpdate;
        }
    }
}
