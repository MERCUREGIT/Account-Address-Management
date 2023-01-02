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
            for(account account: accountList){
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
            if(acc.BillingState !='' && acc.BillingCity!='' && acc.BillingCountry!='' && acc.BillingStreet!='' && acc.BillingPostalCode!=''){
                // Schema.PicklistEntry picklistEntry =  PickListHelper.getPicklistValuesForLabel(Address__c.Address_Type__c,'Billing'); 
                
                newAddress.city__c = acc.BillingCity;
                newAddress.country__c = acc.BillingCountry;
                newAddress.state__c = acc.BillingState;
                newAddress.street__c = acc.BillingStreet;
                newAddress.Postal_code__c = acc.BillingPostalCode;
                newAddress.name=acc.name;
                newAddress.Account__c= acc.id;
                newAddress.Address_Type__c = 'Billing';
                newAddress.status__c = true;


                for(Address__c address: existingMainAdress){
                    if(address.Address_Type__c=='Billing' && address.Account__c==acc.id){
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
                newAddress.name=acc.name;
                newAddress.Account__c= acc.id;
                newAddress.Address_Type__c = 'Billing';
                newAddress.status__c = false;  
            }
        return newAddress;
    }

    public static Address__c createShippingAddresses(List<address__c> existingMainAdress, Account acc){
            Address__c newAddress = new Address__c();

            if(acc.ShippingState!='' && acc.ShippingCity!='' && acc.ShippingCountry!='' && acc.ShippingState!='' && acc.ShippingPostalCode!=''){
                newAddress.city__c = acc.ShippingCity;
                newAddress.country__c = acc.ShippingCountry;
                newAddress.state__c = acc.ShippingState;
                newAddress.street__c = acc.ShippingStreet;
                newAddress.Postal_code__c = acc.ShippingPostalCode;
                newAddress.name=acc.name;
                newAddress.Account__c= acc.id;
                newAddress.Address_Type__c = 'Shipping';
                newAddress.status__c = true;
                    for(Address__c address: existingMainAdress ){
                        if(address.Address_Type__c=='Shipping' && address.Account__c==acc.id){
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
                newAddress.name=acc.name;
                newAddress.Account__c= acc.id;
                newAddress.Address_Type__c = 'Shipping';
                newAddress.status__c = false;
            }
            return newAddress;
        }

    public static void updateAddressOnAccountAddressUpdate(Account newAccount, Account oldAccount){

            list<Address__c> existingShippingAddress = [select id, city__c, country__c, state__c,street__c,Postal_code__c,name FROM Address__c where  Account__c=:oldAccount.id and status__c=true and Address_Type__c='Shipping'];

            list<Address__c> existingBillingAddress = [select id, city__c, country__c, state__c,street__c,Postal_code__c,name FROM Address__c where  Account__c=:oldAccount.id and status__c=true and Address_Type__c='Billing'];

            if( !(existingShippingAddress[0].city__c == newAccount.ShippingCity &&
                existingShippingAddress[0].country__c == newAccount.ShippingCountry &&
                existingShippingAddress[0].state__c == newAccount.ShippingState &&
                existingShippingAddress[0].street__c == newAccount.ShippingStreet &&
                existingShippingAddress[0].Postal_code__c == newAccount.ShippingPostalCode &&
                existingShippingAddress[0].name == newAccount.name) ){

                existingShippingAddress[0].city__c = newAccount.ShippingCity;
                existingShippingAddress[0].country__c = newAccount.ShippingCountry;
                existingShippingAddress[0].state__c = newAccount.ShippingState;
                existingShippingAddress[0].street__c = newAccount.ShippingStreet;
                existingShippingAddress[0].Postal_code__c = newAccount.ShippingPostalCode;
                existingShippingAddress[0].name=newAccount.name;

                update existingShippingAddress;
            }
            if(!(existingBillingAddress[0].city__c == newAccount.BillingCity &&
            existingBillingAddress[0].country__c == newAccount.BillingCountry &&
            existingBillingAddress[0].state__c == newAccount.BillingState &&
            existingBillingAddress[0].street__c == newAccount.BillingStreet &&
            existingBillingAddress[0].Postal_code__c == newAccount.BillingPostalCode &&
            existingBillingAddress[0].name == newAccount.name)){
            
                existingBillingAddress[0].city__c = newAccount.BillingCity;
                existingBillingAddress[0].country__c = newAccount.BillingCountry;
                existingBillingAddress[0].state__c = newAccount.BillingState;
                existingBillingAddress[0].street__c = newAccount.BillingStreet;
                existingBillingAddress[0].Postal_code__c = newAccount.BillingPostalCode;
                existingBillingAddress[0].name=newAccount.name;

                update existingBillingAddress;
            }  
        }
    

}
