/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 02/01/2023 
 * last-edited on: 01/01/2023
 * Description: perform async update of the main addresses that don't match the parent account adresses, less than 250,000 records. 
 */

public without sharing class AddressMassUpdateQueue implements Queueable {

    public void execute(QueueableContext context) {
        List<Account_Address__c> mainAddressList = [SELECT country__c, state__c, PostalCode__c,Address_Type__c FROM Account_Address__c WHERE is_main__c=true];
 
        list<id> relatedAccountIds = new list<id>();
 
        for(Account_Address__c address : mainAddressList){
             relatedAccountIds.add(address.Account__c);
        }
 
        List<account> relatedAccounts = [SELECT id,BillingCity,BillingCountry,BillingState, BillingStreet, BillingPostalCode, name,ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode FROM Account WHERE id in :relatedAccountIds];
     
        List<Account_Address__c> addressesToUpdate = new List<Account_Address__c>();
        
        for(Account_Address__c address : mainAddressList){
         for(Account acc:relatedAccounts){
     
             if(address.Account__c ==acc.id && address.Address_Type__c=='Shipping' ){
                if(!(address.city__c == acc.ShippingCity && address.country__c == acc.ShippingCountry && address.state__c == acc.ShippingState && address.street__c == acc.ShippingStreet && address.PostalCode__c == acc.ShippingPostalCode && address.name == acc.name)){
                         
                         address.city__c = acc.ShippingCity ;
                         address.country__c=  acc.ShippingCountry;
                         address.state__c = acc.ShippingState;
                         address.street__c=acc.ShippingStreet;
                         address.PostalCode__c = acc.ShippingPostalCode;
                         address.name = acc.name;
                         addressesToUpdate.add(address);
                }
             }
             
             if(address.Account__c ==acc.id && address.Address_Type__c=='Billing' ){
                    if(!(address.city__c == acc.BillingCity &&
                        address.country__c == acc.BillingCountry &&
                        address.state__c == acc.BillingState &&
                        address.street__c == acc.BillingStreet &&
                        address.PostalCode__c == acc.BillingPostalCode &&
                        address.name == acc.name)){
    
                            address.city__c = acc.BillingCity ;
                            address.country__c=  acc.BillingCountry;
                            address.state__c = acc.BillingState;
                            address.street__c=acc.BillingStreet;
                            address.PostalCode__c = acc.BillingPostalCode;
                            address.name = acc.name;
                            addressesToUpdate.add(address);
                    }
                }
             }
         }
 
         update addressesToUpdate;
    }
}
