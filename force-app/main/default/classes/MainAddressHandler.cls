/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 * Created-on: 01/01/2023 7:40 pm
 */

public with sharing class MainAddressHandler {

    public static TriggerSwitch__mdt triggerOperationsSwitch = TriggerSwitch__mdt.getInstance('account_address_switch_on_address');

    public static void toggleTraverseMainAddressToAccountOnInsert(Map<id,Account_Address__c> newAddressMap){
        if(! MainAddressHandler.triggerOperationsSwitch.is_active__c){
            return;
        }
        list<id> accountIds = new list<id>();
        list<Account_Address__c> newMainAdressList = new list<Account_Address__c>();

        set<Account_Address__c> mainAdressesToUpdateAsNotMainList = new set<Account_Address__c>();
        for(Account_Address__c address :  newAddressMap.values()){
            if(address.is_main__c){
                newMainAdressList.add(address);
                accountIds.add(address.Account__c);

                Map<Id,Account_Address__c> existingMainAddressesOnAccount =new Map<Id,Account_Address__c> ([select id, city__c, country__c, state__c,street__c,PostalCode__c,Address_Type__c FROM Account_Address__c where  Account__c =: address.Account__c and is_main__c=true and Address_Type__c=: address.Address_Type__c]);
                
                list<Account_Address__c> existingMainAddressesOnAccountList = existingMainAddressesOnAccount.values();

                if(!existingMainAddressesOnAccount.isEmpty()){
                    for (Account_Address__c oldOrNewMainAddress : existingMainAddressesOnAccountList) {
                        if(!(oldOrNewMainAddress.id == address.id)){
                            oldOrNewMainAddress.is_main__c = false;
                            mainAdressesToUpdateAsNotMainList.add(oldOrNewMainAddress);
                        }
                        
                    }
                }
            }
        }

        if(!mainAdressesToUpdateAsNotMainList.isEmpty()){
            update new list<Account_Address__c>(mainAdressesToUpdateAsNotMainList);
        }

        if(newMainAdressList.isEmpty()){
            return;
        }

        Map<id,account> relatedAccountsMap = new Map<id,account>([SELECT id,BillingCity,BillingCountry,BillingState, BillingStreet, BillingPostalCode, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode FROM Account WHERE id in :accountIds]);
    
            set<Account> accountsToUpdate = new set<Account>();
    
            for(Account_Address__c address : newMainAdressList){
                Account relatedAccount = relatedAccountsMap.get(address.Account__c);
    
                if(address.Address_Type__c=='Shipping' && !(MainAddressHandler.checkIfShippingAddressHasNotChanged(relatedAccount,address))){
                        relatedAccount.ShippingCity = address.city__c;
                        relatedAccount.ShippingCountry = address.country__c;
                        relatedAccount.ShippingState = address.state__c ;
                        relatedAccount.ShippingStreet = address.street__c;
                        relatedAccount.ShippingPostalCode = address.PostalCode__c;
                    }
                    
                    if(address.Address_Type__c=='Billing' && !(MainAddressHandler.checkIfBillingAddressHasNotChanged(relatedAccount,address)) ){
                        relatedAccount.BillingCity = address.city__c ; 
                        relatedAccount.BillingCountry =  address.country__c;
                        relatedAccount.BillingState = address.state__c;
                        relatedAccount.BillingStreet = address.street__c;
                        relatedAccount.BillingPostalCode = address.PostalCode__c;
                        
                    }
                    if(!(MainAddressHandler.checkIfShippingAddressHasNotChanged(relatedAccount,address)) || !(MainAddressHandler.checkIfBillingAddressHasNotChanged(relatedAccount,address))){
                        accountsToUpdate.add(relatedAccount);
                    }
                }
            if(!accountsToUpdate.isEmpty()){
                update new list<account>(accountsToUpdate);
            }
    }
    public static void toggleMainAddressOnUpdate(Map<id,Account_Address__c> addressMap){
        if(! MainAddressHandler.triggerOperationsSwitch.is_active__c){
            set<Account_Address__c> mainAdressesToUpdateAsNotMainList = new set<Account_Address__c>();
            for(Account_Address__c address :  addressMap.values()){
                if(address.is_main__c){
                    Map<Id,Account_Address__c> existingMainAddressesOnAccount =new Map<Id,Account_Address__c> ([select id, city__c, country__c, state__c,street__c,PostalCode__c,Address_Type__c FROM Account_Address__c where  Account__c =: address.Account__c and is_main__c=true and Address_Type__c=: address.Address_Type__c]);
                    
                    list<Account_Address__c> existingMainAddressesOnAccountList = existingMainAddressesOnAccount.values();
                    integer indexOfCurrentMain;
                 
                    if(!existingMainAddressesOnAccount.isEmpty()){
                        if(existingMainAddressesOnAccount.containsKey(address.id)){
                            indexOfCurrentMain = existingMainAddressesOnAccountList.indexof(existingMainAddressesOnAccount.get(address.id));
                            for (Integer i = 0; i < existingMainAddressesOnAccountList.size(); i++) {
                                if(indexOfCurrentMain != i){
                                    existingMainAddressesOnAccountList[i].is_main__c = false;
                                    mainAdressesToUpdateAsNotMainList.add(existingMainAddressesOnAccountList[i]);
                                }
                            }
                        }else{
                            for (Account_Address__c oldMainAddress : existingMainAddressesOnAccountList) {
                                oldMainAddress.is_main__c = false;
                                mainAdressesToUpdateAsNotMainList.add(oldMainAddress);
                            }
                        }
                    }
                }
            }
            if(!mainAdressesToUpdateAsNotMainList.isEmpty()){
                update new list<Account_Address__c>(mainAdressesToUpdateAsNotMainList);
            }  
        }
    }

    public static void updateAccountMainAddressOnMainAddressUpdate(Map<id,Account_Address__c> addressMap){
        if(MainAddressHandler.triggerOperationsSwitch.is_active__c){

            list<id> accountIds = new list<id>();
            list<Account_Address__c> newMainAdressList = new list<Account_Address__c>();
    
            for(Account_Address__c address : addressMap.values()){
                if(address.is_main__c){
                    newMainAdressList.add(address);
                    accountIds.add(address.Account__c);
                }
            }
    
            if(newMainAdressList.isEmpty()){
                return;
            }
    
            Map<id,account> relatedAccountsMap = new Map<id,account>([SELECT id,BillingCity,BillingCountry,BillingState, BillingStreet, BillingPostalCode, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode FROM Account WHERE id in :accountIds]);
    
            List<Account> accountsToUpdate = new List<Account>();
    
            for(Account_Address__c address : newMainAdressList){
                Account relatedAccount = relatedAccountsMap.get(address.Account__c);
    
                    if(address.Address_Type__c=='Shipping' && !(MainAddressHandler.checkIfShippingAddressHasNotChanged(relatedAccount,address))){
                            relatedAccount.ShippingCity = address.city__c;
                            relatedAccount.ShippingCountry = address.country__c;
                            relatedAccount.ShippingState = address.state__c ;
                            relatedAccount.ShippingStreet = address.street__c;
                            relatedAccount.ShippingPostalCode = address.PostalCode__c;
                    }
                    
                    if(address.Address_Type__c=='Billing' && !(MainAddressHandler.checkIfBillingAddressHasNotChanged(relatedAccount,address)) ){
                        relatedAccount.BillingCity = address.city__c ; 
                        relatedAccount.BillingCountry =  address.country__c;
                        relatedAccount.BillingState = address.state__c;
                        relatedAccount.BillingStreet = address.street__c;
                        relatedAccount.BillingPostalCode = address.PostalCode__c;
                    }

                    if(!(MainAddressHandler.checkIfShippingAddressHasNotChanged(relatedAccount,address)) || !(MainAddressHandler.checkIfBillingAddressHasNotChanged(relatedAccount,address))){
                        accountsToUpdate.add(relatedAccount);
                    }
                }
            
            if(!accountsToUpdate.isEmpty()){
                update accountsToUpdate;
            }

        }
    }

    private static Boolean checkIfBillingAddressHasNotChanged(account relatedAccount, Account_Address__c address){
        return address.city__c == relatedAccount.BillingCity &&
        address.country__c == relatedAccount.BillingCountry &&
        address.state__c == relatedAccount.BillingState &&
        address.street__c == relatedAccount.BillingStreet &&
        address.PostalCode__c == relatedAccount.BillingPostalCode;
    }
    private static Boolean checkIfShippingAddressHasNotChanged(account relatedAccount, Account_Address__c address){
        return address.city__c == relatedAccount.ShippingCity && 
        address.country__c == relatedAccount.ShippingCountry && 
        address.state__c == relatedAccount.ShippingState && 
        address.street__c == relatedAccount.ShippingStreet && 
        address.PostalCode__c == relatedAccount.ShippingPostalCode; 
    }
}
