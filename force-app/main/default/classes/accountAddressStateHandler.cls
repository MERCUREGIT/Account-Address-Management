/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 01/01/2023 10:46 am
 * last-edited on: 01/01/2023
 * target org: https://wise-koala-bhzgyy-dev-ed.trailblaze.lightning.force.com/
 * Description: Handles inserteing and updating of account address object state. 
 */

public without sharing class AccountAddressStateHandler {
    public static TriggerSwitch__mdt triggerOperationsSwitch = TriggerSwitch__mdt.getInstance('account_address_switch_on_account');

    public static void createAddressesFromListOfNewAccounts(map<id,Account> accountMap){
        if(MainAddressHandler.triggerOperationsSwitch.is_active__c){
            List<Account_Address__c> newAddressList = new List<Account_Address__c>();

            for(Account acc:accountMap.values()){
                AccountAddressStateHandler.createBillingAddressesFromAccount(acc,newAddressList);
                AccountAddressStateHandler.createShippingAddressesFromAccount(acc,newAddressList);
            }

            if(!newAddressList.isEmpty()){
                insert newAddressList;
            } 
        }
            
    }

    public static void createBillingAddressesFromAccount(Account acc, List<Account_Address__c> newAddressList){
            Account_Address__c newAddress = new Account_Address__c();
            Schema.PicklistEntry picklistEntry =  PickListHelper.getPicklistValuesForLabel(Account_Address__c.Address_Type__c,'Billing');

            if(acc.BillingState !=null && acc.BillingCity!=null && acc.BillingCountry!=null && acc.BillingStreet!=null && acc.BillingPostalCode!=null){
                newAddress.is_main__c = true;
            }

            if(acc.BillingState ==null && acc.BillingCity==null && acc.BillingCountry==null && acc.BillingStreet==null && acc.BillingPostalCode==null){
                return;
            }

            newAddress.Address_Type__c = picklistEntry.getValue();
            newAddress.name=acc.name;
            newAddress.Account__c= acc.id;
            newAddress.city__c = acc.BillingCity;
            newAddress.country__c = acc.BillingCountry;
            newAddress.state__c = acc.BillingState;
            newAddress.street__c = acc.BillingStreet;
            newAddress.PostalCode__c = acc.BillingPostalCode;

            newAddressList.add(newAddress);
    }

    public static void createShippingAddressesFromAccount(Account acc, List<Account_Address__c> newAddressList){

            Account_Address__c newAddress = new Account_Address__c();
            Schema.PicklistEntry picklistEntry =  PickListHelper.getPicklistValuesForLabel(Account_Address__c.Address_Type__c,'Shipping');

            if(acc.ShippingState!=null && acc.ShippingCity!=null && acc.ShippingCountry!=null && acc.ShippingState!=null && acc.ShippingPostalCode!=null){
                newAddress.is_main__c = true;
            }

            if(acc.ShippingState==null && acc.ShippingCity==null && acc.ShippingCountry==null && acc.ShippingState==null && acc.ShippingPostalCode==null){
                return;
            }
            
            newAddress.city__c = acc.ShippingCity;
            newAddress.country__c = acc.ShippingCountry;
            newAddress.state__c = acc.ShippingState;
            newAddress.street__c = acc.ShippingStreet;
            newAddress.PostalCode__c = acc.ShippingPostalCode;
            newAddress.name=acc.name;
            newAddress.Account__c= acc.id;
            newAddress.Address_Type__c = picklistEntry.getValue();

            newAddressList.add(newAddress);
        }

    public static void updateMainAddressOnAccountMainAddressUpdate(Map<id,Account> updatedAccountsMap){
        if(MainAddressHandler.triggerOperationsSwitch.is_active__c){
            account  updatedAccount =  updatedAccountsMap.values()[0];

            Schema.PicklistEntry  shippingPicklistEntry =  PickListHelper.getPicklistValuesForLabel(Account_Address__c.Address_Type__c,'Shipping');
            Schema.PicklistEntry billingPicklistEntry =  PickListHelper.getPicklistValuesForLabel(Account_Address__c.Address_Type__c,'Billing');

            List<Account_Address__c> existingListOfShippingAddress = [select id, city__c, country__c, state__c,street__c,PostalCode__c FROM Account_Address__c where  Account__c=:updatedAccount.id and is_main__c=true and Address_Type__c=:shippingPicklistEntry.getValue()];

            List<Account_Address__c> existingListOfBillingAddress = [select id, city__c, country__c, state__c,street__c,PostalCode__c FROM Account_Address__c where  Account__c=:updatedAccount.id and is_main__c=true and Address_Type__c=:billingPicklistEntry.getValue()] ;

            Account_Address__c existingShippingAddress;
            Account_Address__c existingBillingAddress;

            if(!existingListOfShippingAddress.isEmpty()){
                existingShippingAddress = existingListOfShippingAddress[0];

                boolean hasShippingAddressChanged = existingShippingAddress.city__c == updatedAccount.ShippingCity &&
                                                existingShippingAddress.country__c == updatedAccount.ShippingCountry &&
                                                existingShippingAddress.state__c == updatedAccount.ShippingState &&
                                                existingShippingAddress.street__c == updatedAccount.ShippingStreet &&
                                                existingShippingAddress.PostalCode__c == updatedAccount.ShippingPostalCode;

                if(!(hasShippingAddressChanged)){
                    existingShippingAddress.city__c = updatedAccount.ShippingCity;
                    existingShippingAddress.country__c = updatedAccount.ShippingCountry;
                    existingShippingAddress.state__c = updatedAccount.ShippingState;
                    existingShippingAddress.street__c = updatedAccount.ShippingStreet;
                    existingShippingAddress.PostalCode__c = updatedAccount.ShippingPostalCode;
    
                    update existingShippingAddress;
                }
                
            }

            if(!existingListOfBillingAddress.isEmpty()){
                existingBillingAddress = existingListOfBillingAddress[0];

                boolean hasBillingAddressChanged = existingBillingAddress.city__c == updatedAccount.BillingCity &&
                                                    existingBillingAddress.country__c == updatedAccount.BillingCountry &&
                                                    existingBillingAddress.state__c == updatedAccount.BillingState &&
                                                    existingBillingAddress.street__c == updatedAccount.BillingStreet &&
                                                    existingBillingAddress.PostalCode__c == updatedAccount.BillingPostalCode;

                if(!(hasBillingAddressChanged)){
                    existingBillingAddress.city__c = updatedAccount.BillingCity;
                    existingBillingAddress.country__c = updatedAccount.BillingCountry;
                    existingBillingAddress.state__c = updatedAccount.BillingState;
                    existingBillingAddress.street__c = updatedAccount.BillingStreet;
                    existingBillingAddress.PostalCode__c = updatedAccount.BillingPostalCode;

                    update existingBillingAddress;
                }  
            }
        }
            

        }
    
}