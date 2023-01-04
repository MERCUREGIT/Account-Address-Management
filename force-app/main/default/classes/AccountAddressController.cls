public with sharing class AccountAddressController {

    @AuraEnabled(Cacheable=true)
        public static List<Account> getRelatedAddresses(id accountId) {
        return [select id, city__c, country__c, state__c,street__c,PostalCode__c, is_main__c, Address_Type__c FROM Account_Address__c where  Account__c=:accountId];        
    }

}
