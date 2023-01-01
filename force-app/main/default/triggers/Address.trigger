/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 * Created-on: 01/01/2023 6:39 pm
 * last-edited-on: 01/01/2023 6:39 pm
 */

trigger Address on Address__c (before insert, before update, before
delete, after insert, after update, after delete,  after undelete) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        MainAddressHandler.traverseMainAddressUpdateOnAccount(Trigger.new);
}
}