/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 * Created-on: 01/01/2023 6:39 pm
 * last-edited-on: 01/01/2023 6:39 pm
 */

trigger Address on Account_Address__c (after insert, after update) {


        if (Trigger.isAfter && Trigger.isUpdate) {
            MainAddressHandler.toggleMainAddressOnUpdate(Trigger.newMap);
        }

        if (Trigger.isAfter && Trigger.isInsert) {
            MainAddressHandler.toggleTraverseMainAddressToAccountOnInsert(Trigger.newMap);
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            MainAddressHandler.updateAccountMainAddressOnMainAddressUpdate(Trigger.newMap);
        }
}