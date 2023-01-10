/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 01/01/2023 10:46 am
 * last-edited on: 01/01/2023
 * target org: https://wise-koala-bhzgyy-dev-ed.trailblaze.lightning.force.com/
 */

@isTest
public with sharing class PickListHelperTest {
    @isTest
    static void getPicklistValuesForLabelTest(){
        string addressType = 'Billing';
        Schema.PicklistEntry picklistEntry =  PickListHelper.getPicklistValuesForLabel(Account_Address__c.Address_Type__c,addressType);
        string pickListValue = picklistEntry.getValue().toUpperCase();
        System.assertEquals(addressType.toUpperCase(), pickListValue);
    }
}