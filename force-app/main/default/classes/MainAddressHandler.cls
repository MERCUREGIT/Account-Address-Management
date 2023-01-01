public with sharing class MainAddressHandler {
    public MainAddressHandler() {

    }

//d.	If a user updates Main Billing Address changes should be automatically applied to Account Billing Address. The same logic should be applied for Main Shipping Address 

    public static void traverseMainAddressUpdateOnAccount(list<address__c> addressList){
        // get associated accounts
        // target and perform update

        list<id> accountIds = new list<id>();

        for(address__c address : addressList){
            accountIds.add(address.Account__c);
        }

        list<account> relatedAccounts = new list<account>();
        relatedAccounts = [SELECT ShippingAddress, BillingAddress FROM Account WHERE id in :accountIds];

        // check if account

        for(address__c address : addressList){
            for(Account acc:relatedAccounts){
                if(address.Account__c ==acc.id ){
                   
                    
                    
                }
            }
        }
    }
}
