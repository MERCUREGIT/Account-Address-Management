/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 */

@isTest
public with sharing class AccountAddressStateHandlerTest {
    @isTest
    static void createAddressesFromListOfNewAccountsWithCompleteAddressTest(){

        TriggerSwitch__mdt triggerOperationsSwitch = TriggerSwitch__mdt.getInstance('account_address_switch_on_account');
        
        if(! MainAddressHandler.triggerOperationsSwitch.is_active__c){
            System.assertEquals(false, MainAddressHandler.triggerOperationsSwitch.is_active__c);
           return;
       }

        if(MainAddressHandler.triggerOperationsSwitch.is_active__c){
            Integer numberOfAccount=10;
            list<account> testAccounts = new List<Account>();
                for (Integer i = 0; i < numberOfAccount; i++) {
                    account testAccount =  new Account(
                        name = 'test' + i,
                        BillingCity = 'test' + i,
                        BillingCountry = 'test' + i,
                        BillingState = 'test' + i,
                        BillingStreet = 'test' + i,
                        BillingPostalCode = '0000',
        
                        ShippingCity = 'test' + i,
                        ShippingCountry = 'test' + i,
                        ShippingState = 'test' + i,
                        ShippingStreet = 'test' + i,
                        ShippingPostalCode = '0000'
                    );
                    testAccounts.add(testAccount);
                }
            if(!testAccounts.isEmpty()){
                insert testAccounts;
                Map<Id,Account> accountsMap = new Map<Id,Account>(testAccounts);

                List<Account_Address__c> existingListOfShippingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping'];
        
                List<Account_Address__c> existingListOfBillingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing'];
        
                System.assertEquals(true, MainAddressHandler.triggerOperationsSwitch.is_active__c);
                System.assertEquals(numberOfAccount, existingListOfShippingAddress.size(),'Shipping address count'); 
                System.assertEquals(numberOfAccount, existingListOfBillingAddress.size(),'Billing address count'); 
                System.assertEquals(numberOfAccount, ([SELECT id FROM Account]).size(),'number of accounts created'); 

            }
        }
    }

    /**
     * Description: Test for account that have no  address at all, no address should be created
     */
    @isTest
    static void createAddressesFromListOfNewAccountsWithNoAddressTest(){
        Integer numberOfAccount=10;
        list<account> testAccounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccount; i++) {
            account testAccount =  new Account(
                name = 'test' + i
            );
            testAccounts.add(testAccount);
        }

        insert testAccounts;

        List<Account_Address__c> existingListOfShippingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping'];
        
        List<Account_Address__c> existingListOfBillingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing'];

        List<Account> accList = [SELECT id FROM Account];

        System.assertEquals(numberOfAccount, accList.size()); 
        System.assertEquals(0, existingListOfShippingAddress.size()); 
        System.assertEquals(0, existingListOfBillingAddress.size());  
    }

    /**
     * Description: Test for account that has just Billing Address that is complete
     */
    @isTest
    static void createAddressesFromListOfNewAccountsWithJustBillingAddressTest(){
        Integer numberOfAccount=10;
        list<account> testAccounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccount; i++) {
            account testAccount =  new Account(
                name = 'test' + i,
                BillingCity = 'test' + i,
                BillingCountry = 'test' + i,
                BillingState = 'test' + i,
                BillingStreet = 'test' + i,
                BillingPostalCode = 'test' + i
            );
            testAccounts.add(testAccount);
        }

        insert testAccounts;

        List<Account_Address__c> existingListOfShippingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping'];
        
        List<Account_Address__c> existingListOfBillingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing'];

        List<Account> accList = [SELECT id FROM Account];

        System.assertEquals(numberOfAccount, accList.size()); 
        System.assertEquals(0, existingListOfShippingAddress.size()); 
        System.assertEquals(numberOfAccount, existingListOfBillingAddress.size());
    }


    /**
     * Description: Test for account that have  just One Complete Address
     */
    @isTest
    static void createAddressesFromListOfNewAccountsWithJustShippingAddressTest(){
        Integer numberOfAccount=10;
        list<account> testAccounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccount; i++) {
            account testAccount =  new Account(
                name = 'test' + i,
                ShippingCity = 'test' + i,
                ShippingCountry = 'test' + i,
                ShippingState = 'test' + i,
                ShippingStreet = 'test' + i,
                ShippingPostalCode = '0000'
            );
            testAccounts.add(testAccount);
        }

        insert testAccounts;

        List<Account_Address__c> existingListOfShippingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping'];
        
        List<Account_Address__c> existingListOfBillingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing'];

        List<Account> accList = [SELECT id FROM Account];

        System.assertEquals(numberOfAccount, accList.size()); 
        System.assertEquals(numberOfAccount, existingListOfShippingAddress.size()); 
        System.assertEquals(0, existingListOfBillingAddress.size());
    }

    /**
     * Description: Test for account that have no Complete Address
     */
    @isTest
    static void createAddressesFromListOfNewAccountsWithNoCompleteAddressTest(){
        Integer numberOfAccount=10;
        list<account> testAccounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccount; i++) {
            account testAccount =  new Account(
                name = 'test' + i,
                BillingCity = 'test' + i,
                BillingCountry = 'test' + i,
                BillingPostalCode = 'test' + i,
                ShippingCity = 'test' + i,
                ShippingCountry = 'test' + i,
                ShippingPostalCode = 'test' + i
            );
            testAccounts.add(testAccount);
        }

        insert testAccounts;

        List<Account_Address__c> existingListOfShippingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping'];
        
        List<Account_Address__c> existingListOfBillingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing'];

        List<Account> accList = [SELECT id FROM Account];

        System.assertEquals(numberOfAccount, accList.size()); 
        System.assertEquals(0, existingListOfShippingAddress.size()); 
        System.assertEquals(0, existingListOfBillingAddress.size());
        
     
    }


    /**
     * Description: Test for account that have no Complete Address
     */
    @isTest
    static void createAddressesFromListOfNewAccountsWithJustOneUncompleteAddressTest(){
        Integer numberOfAccount=10;
        list<account> testAccounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccount; i++) {
            account testAccount =  new Account(
                name = 'test' + i,
                BillingCity = 'test' + i,
                BillingCountry = 'test' + i,
                BillingState = 'test' + i,
                BillingStreet = 'test' + i,
                BillingPostalCode = 'test' + i
            );
            testAccounts.add(testAccount);
        }

        insert testAccounts;

        List<Account_Address__c> existingListOfShippingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping'];
        
        List<Account_Address__c> existingListOfBillingAddress = [SELECT id FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing'];

        List<Account> accList = [SELECT id FROM Account];

        System.assertEquals(numberOfAccount, accList.size()); 
        System.assertEquals(0, existingListOfShippingAddress.size()); 
        System.assertEquals(numberOfAccount, existingListOfBillingAddress.size());
               
    }

@istest 
static void updateMainAddressOnAccountMainAddressUpdateTest(){
    Integer numberOfAccount=10;
        list<account> testAccounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccount; i++) {
            account testAccount =  new Account(
                name = 'test' + i,
                BillingCity = 'test' + i,
                BillingCountry = 'test' + i,
                BillingState = 'test' + i,
                BillingStreet = 'test' + i,
                BillingPostalCode = '0000',

                ShippingCity = 'test' + i,
                ShippingCountry = 'test' + i,
                ShippingState = 'test' + i,
                ShippingStreet = 'test' + i,
                ShippingPostalCode = '0000'
            );
            testAccounts.add(testAccount);
        }

        insert testAccounts;
        // update with no change
        list<account> relatedAccountsList = [SELECT BillingPostalCode,ShippingPostalCode FROM Account LIMIT 1];

        // check for no change

        list<account> updatedAccounts = new list<account>();

        id testAcountId= relatedAccountsList[0].id;
        // check for changed billing
        relatedAccountsList[0].BillingState = 'test for changed state';
        // check for changed shipping
        relatedAccountsList[0].ShippingState = 'test for changed state';

        updatedAccounts.add(relatedAccountsList[0]);

        update updatedAccounts;

        relatedAccountsList = [SELECT BillingPostalCode, ShippingPostalCode FROM Account WHERE id =:testAcountId];

        List<Account_Address__c> existingListOfShippingAddress = [SELECT PostalCode__c FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Shipping' and Account__c =:testAcountId];
        
        List<Account_Address__c> existingListOfBillingAddress = [SELECT PostalCode__c FROM Account_Address__c WHERE is_main__c=true and Address_Type__c='Billing' and Account__c =:testAcountId];

        System.assert(relatedAccountsList[0].BillingPostalCode == existingListOfBillingAddress[0].PostalCode__c );
        System.assert(relatedAccountsList[0].ShippingPostalCode == existingListOfShippingAddress[0].PostalCode__c );

    }

}
