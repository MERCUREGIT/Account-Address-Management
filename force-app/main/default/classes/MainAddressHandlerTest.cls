@isTest
public class MainAddressHandlerTest {

    /**
     * description:  test (if a new main address is inserted, then let it become the new account address)
     */
    @isTest
    static void toggleTraverseMainAddressToAccountOnInsertTest(){

        account testAccount =  new account(name='test');
        insert testAccount;
        Account_Address__c testBillingAddress=new Account_Address__c(
            name = 'test',
            city__c= 'test', 
            country__c= 'test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Address_Type__c= 'Billing',
            Account__c = testAccount.id,
            Is_main__c=true
        );

        Account_Address__c testShippingAddress =  new Account_Address__c(
            name = 'test',
            city__c= 'test', 
            country__c= 'test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Account__c = testAccount.id,
            Address_Type__c= 'Shipping',
            Is_main__c=true
        );

        insert new List<Account_Address__c>{
            testShippingAddress,
            testBillingAddress
        };


        list<account> testAccountList = [SELECT BillingCountry, ShippingCountry FROM Account WHERE id=:testAccount.id];

        System.assertEquals(1, testAccountList.size());
        System.assertEquals(testShippingAddress.country__c,testAccountList[0].ShippingCountry);
        System.assertEquals(testBillingAddress.country__c,testAccountList[0].BillingCountry);
    }
    /**
     * description:  test (if  main address is updated, then update account address)
     */


    @isTest
    static void toggleMainAddressOnUpdateTest(){

        account testAccount =  new account(name='test');
        insert testAccount;

        list<Account_Address__c> testAccountAddresses = new List<Account_Address__c>();

        Account_Address__c testOldBillingAddress=new Account_Address__c(
            name = 'initial main',
            city__c= 'test', 
            country__c= 'test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Address_Type__c= 'Billing',
            Account__c = testAccount.id,
            Is_main__c=true
        );

        Account_Address__c testOldShippingAddress =  new Account_Address__c(
            name = 'initial main',
            city__c= 'test', 
            country__c= 'test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Account__c = testAccount.id,
            Address_Type__c= 'Shipping',
            Is_main__c=true
        );
        Account_Address__c newtestBillingAddress = new Account_Address__c(
            name = 'new or final main',
            city__c= 'test', 
            country__c= 'new test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Address_Type__c= 'Billing',
            Account__c = testAccount.id,
            Is_main__c=false
        );
        Account_Address__c newtestShippingAddress = new Account_Address__c(
            name = 'new or final main',
            city__c= 'test', 
            country__c= 'new test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Account__c = testAccount.id,
            Address_Type__c= 'Shipping',
            Is_main__c=false
        );

        insert new List<Account_Address__c>{ newtestBillingAddress, testOldShippingAddress, testOldBillingAddress, newtestShippingAddress };

        list<account> testAccountList = [SELECT BillingCountry, ShippingCountry FROM Account WHERE id=:testAccount.id limit 1]; 

        System.assert(testOldShippingAddress.is_main__c);
        System.assert(testOldBillingAddress.is_main__c);
        System.assert(newtestShippingAddress.is_main__c == false);
        System.assert(newtestBillingAddress.is_main__c == false);
        System.assertEquals(testOldShippingAddress.country__c,testAccountList[0].ShippingCountry);
        System.assertEquals(testOldBillingAddress.country__c,testAccountList[0].BillingCountry);

        newtestBillingAddress.Is_main__c = true;
        newtestShippingAddress.Is_main__c = true;
        update new List<Account_Address__c>{newtestBillingAddress,newtestShippingAddress};

        testAccountList = [SELECT BillingCountry, ShippingCountry FROM Account WHERE id=:testAccount.id limit 1];
        
        System.assert(([SELECT id, is_main__c from Account_Address__c where id =:testOldShippingAddress.id limit 1])[0].is_main__c ==false);
        System.assert(([SELECT id, is_main__c from Account_Address__c where id =:testOldBillingAddress.id limit 1])[0].is_main__c ==false);
        System.assert(newtestShippingAddress.is_main__c );
        System.assert(newtestBillingAddress.is_main__c );

        System.assertEquals(newtestShippingAddress.country__c,testAccountList[0].ShippingCountry);
        System.assertEquals(newtestBillingAddress.country__c,testAccountList[0].BillingCountry);

    }

    @istest 
    static void updateAccountMainAddressOnMainAddressUpdateTest(){
        account testAccount =  new account(name='test');
        insert testAccount;
        Account_Address__c testBillingAddress=new Account_Address__c(
            name = 'test',
            city__c= 'test', 
            country__c= 'test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Address_Type__c= 'Billing',
            Account__c = testAccount.id,
            Is_main__c=true
        );

        Account_Address__c testShippingAddress =  new Account_Address__c(
            name = 'test',
            city__c= 'test', 
            country__c= 'test', 
            state__c= 'test',
            street__c= 'test',
            PostalCode__c= 'test',
            Account__c = testAccount.id,
            Address_Type__c= 'Shipping',
            Is_main__c=true
        );

        insert new List<Account_Address__c>{
            testShippingAddress,
            testBillingAddress
        };


        list<account> testAccountList = [SELECT BillingCountry, ShippingCountry FROM Account WHERE id=:testAccount.id];

        System.assertEquals(1, testAccountList.size());
        System.assertEquals(testShippingAddress.country__c,testAccountList[0].ShippingCountry);
        System.assertEquals(testBillingAddress.country__c,testAccountList[0].BillingCountry);


        testShippingAddress.country__c= 'Cameroon';
        testBillingAddress.country__c= 'Cameroon';

        update new List<Account_Address__c>{
            testShippingAddress,
            testBillingAddress
        };

        testAccountList = [SELECT BillingCountry, ShippingCountry FROM Account WHERE id=:testAccount.id];
        
        System.assertEquals(1, testAccountList.size());
        System.assertEquals(testShippingAddress.country__c,testAccountList[0].ShippingCountry);
        System.assertEquals(testBillingAddress.country__c,testAccountList[0].BillingCountry);

    }

}
