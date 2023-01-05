public with sharing class AccountAddressController {

    @AuraEnabled(Cacheable=true)
    public static List<Account_Address__c> getRelatedAddresses(String recordId) {
        return [select id, city__c, country__c, state__c,street__c,PostalCode__c, is_main__c, Address_Type__c , Name FROM Account_Address__c where  Account__c=:recordId];        
    }

    @AuraEnabled
    public static void deleteAddress(string recordId){
        list<Account_Address__c> addresses = [SELECT Id, Name from Account_Address__c WHERE id = : recordId];
        
        if(!addresses.isEmpty()){
            delete addresses;
        }
    }

}
