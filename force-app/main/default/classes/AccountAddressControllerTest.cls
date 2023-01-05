@isTest
public with sharing class AccountAddressControllerTest {
    
    @TestSetup
    static void createAddressesForAccount(){
        account acc = new Account(name='Test');
        insert acc;
        List<Account_Address__c> relatedAccountAddress =  new List<Account_Address__c>();
        for (Integer i = 0; i < 200; i++) {
            relatedAccountAddress.add(
                new Account_Address__c( 
                    name = acc.name,
                    city__c = 'test city' + i,
                    Country__c = 'test country' + i,
                    state__c = 'test state'+i,
                    Is_main__c= false,
                    street__c = 'test city' + i,
                    PostalCode__c = 'test postal code'+ i,
                    Address_Type__c = 'Billing',
                    Account__c = acc.id)
            );
        }
        insert relatedAccountAddress;
    }

    @isTest 
    static void getRelatedAddressesTest(){
        list<account> acc = [SELECT id,name from account LIMIT 1];
        List<Account_Address__c> relatedAddresses = AccountAddressController.getRelatedAddresses(String.valueOf(acc[0].id));
        System.assertEquals(200, relatedAddresses.size());
    }

    @isTest 
    static void deleteAddressTest(){
        list<account> acc = [SELECT id,name from account LIMIT 1];
        list<Account_Address__c> accAddress = [SELECT id,name from Account_Address__c WHERE Account__c  =:acc[0].id LIMIT 1];
        id accAddressID = accAddress[0].id;
        AccountAddressController.deleteAddress(String.valueOf(accAddressID));
        list<Account_Address__c> deletedAccAddress = [SELECT id,name from Account_Address__c WHERE id  =:accAddressID];
        System.assertEquals(0, deletedAccAddress.size());
    }
}
