/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 01/01/2023 10:46 am
 * last-edited on: 01/01/2023
 * Description: Handles inserteing and updating of account address object state. 
 */


public without sharing class AccountAddressStateHandler {
public accountAddressStateHandler() {

}

public static void createAddressesFromListOfAccounts(List<Account> accountList){
        List<Id> accountIdList = new List<id>();
        List<address__c> newAddressList = new List<address__c>();
        for(id account: accountList){
            accountIdList.add(account.id);
        }
        List<address__c> existingMainAdress = [SELECT status__c,Address_Type__c FROM Address__c where Account__c in :accountIdList and status__c=true];

        for(Account acc:accountList){
            newAddressList.add(AccountAddressStateHandler.createBillingAddresses(existingMainAdress, acc)) ;
            newAddressList.add(AccountAddressStateHandler.createShippingAddresses(existingMainAdress, acc)) ;
        }
    upsert newAddressList;
}

public static Address__c createBillingAddresses(List<address__c> existingMainAdress, Account acc){

        Address__c newAddress = new Address__c();
        if(acc.BillingState && acc.BillingCity && acc.BillingCountry && acc.BillingStreet && acc.BillingPostalCode){
            Schema.PicklistEntry picklistEntry =  PickListHelper.getPicklistValues(Address__c.Address_Type__c,'Billing'); 

            newAddress.city__c = acc.BillingCity;
            newAddress.country__c = acc.BillingCountry;
            newAddress.state__c = acc.BillingState;
            newAddress.street__c = acc.BillingStreet;
            newAddress.Postal_code__c = acc.BillingPostalCode;
            newAddress.name__c=acc.name;
            newAddress.Account__c= acc.id;
            newAddress.Address_Type__c = picklistEntry ?. picklistEntry.getValue();
            newAddress.status__c = true;


            for(Address__c address: existingMainAdress){
                if(address.Address_Type__c==picklistEntry ?.picklistEntry.getLabel() && address.Account__c==acc.id){
                    address.status__c=false;
                }
            }
        }
        else{
            newAddress.city__c = acc.BillingCity;
            newAddress.country__c = acc.BillingCountry;
            newAddress.state__c = acc.BillingState;
            newAddress.street__c = acc.BillingStreet;
            newAddress.Postal_code__c = acc.BillingPostalCode;
            newAddress.name__c=acc.name;
            newAddress.Account__c= acc.id;
            newAddress.Address_Type__c = picklistEntry ?. picklistEntry.getValue();
            newAddress.status__c = false;  
        }
    return newAddress;
}

public static Address__c createShippingAddresses(List<address__c> existingMainAdress, Account acc){
        Address__c newAddress = new Address__c();

        if(acc.ShippingState && acc.ShippingCity && acc.ShippingCountry && acc.ShippingState && acc.ShippingPostalCode){
            Schema.PicklistEntry picklistEntry =  PickListHelper.getPicklistValues(Address__c.Address_Type__c,'Shipping');
            newAddress.city__c = acc.ShippingCity;
            newAddress.country__c = acc.ShippingCountry;
            newAddress.state__c = acc.ShippingState;
            newAddress.street__c = acc.ShippingStreet;
            newAddress.Postal_code__c = acc.ShippingPostalCode;
            newAddress.name__c=acc.name;
            newAddress.Account__c= acc.id;
            newAddress.Address_Type__c = picklistEntry ?. picklistEntry.getValue();
            newAddress.status__c = true;
                for(Address__c address: existingMainAdress ){
                    if(address.Address_Type__c==picklistEntry ?.picklistEntry.getLabel() && address.Account__c==acc.id){
                        address.status__c=false;
                    }
                }
        }
        else{
            newAddress.city__c = acc.ShippingCity;
            newAddress.country__c = acc.ShippingCountry;
            newAddress.state__c = acc.ShippingState;
            newAddress.street__c = acc.ShippingStreet;
            newAddress.Postal_code__c = acc.ShippingPostalCode;
            newAddress.name__c=acc.name;
            newAddress.Account__c= acc.id;
            newAddress.Address_Type__c = picklistEntry ?. picklistEntry.getValue();
            newAddress.status__c = false;
        }
        return newAddress;
    }


    public static void updateAccountBillingAddress(Account newAccount, Account oldAccount){
        Account acc = newAccount;
        Schema.PicklistEntry billingPicklistEntry =  PickListHelper.getPicklistValues(Address__c.Address_Type__c,'Billing'); 
        Schema.PicklistEntry shippingPicklistEntry =  PickListHelper.getPicklistValues(Address__c.Address_Type__c,'Shipping'); 

        list<Address__c> existingShippingAddress = [select id, city__c, country__c, state__c,street__c,Postal_code__c,name FROM Address__c where  Account__c=:acc.id and status__c=true and Address_Type__c=:shippingPicklistEntry ?. shippingPicklistEntry.getValue()];
        
        list<Address__c> existingBillingAddress = [select id, city__c, country__c, state__c,street__c,Postal_code__c,name FROM Address__c where  Account__c=:acc.id and status__c=true and Address_Type__c=:billingPicklistEntry ?. billingPicklistEntry.getValue()];

        if(oldAccount.ShippingAddress !=acc.ShippingAddress){
            existingShippingAddress[0].city__c = acc.BillingCity;
            existingShippingAddress[0].country__c = acc.BillingCountry;
            existingShippingAddress[0].state__c = acc.BillingState;
            existingShippingAddress[0].street__c = acc.BillingStreet;
            existingShippingAddress[0].Postal_code__c = acc.BillingPostalCode;
            existingShippingAddress[0].name__c=acc.name;

            update existingShippingAddress;
        }
        if(oldAccount.BillingAddress !=acc.BillingAddress){
            existingBillingAddress[0].city__c = acc.BillingCity;
            existingBillingAddress[0].country__c = acc.BillingCountry;
            existingBillingAddress[0].state__c = acc.BillingState;
            existingBillingAddress[0].street__c = acc.BillingStreet;
            existingBillingAddress[0].Postal_code__c = acc.BillingPostalCode;
            existingBillingAddress[0].name__c=acc.name;

            update existingBillingAddress;
        }  
    }

}
