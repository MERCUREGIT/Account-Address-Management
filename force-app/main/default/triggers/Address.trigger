/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 * Created-on: 01/01/2023 6:39 pm
 * last-edited-on: 01/01/2023 6:39 pm
 */

trigger Address on Address__c (after insert, after update) {

    TriggerSwitch__mdt[] swicthes = [SELECT QualifiedApiName, MasterLabel,  is_active__c
    , name__c FROM TriggerSwitch__mdt where name__c='address'];
    
    if(swicthes[0].is_active__c){
        if (Trigger.isAfter && Trigger.isUpdate) {
            MainAddressHandler.traverseMainAddressUpdateOnAccount(Trigger.new);
        }
    }
}