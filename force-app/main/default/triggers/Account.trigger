/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 01/01/2023 10:46 am
 * email: ngumbukafon@gmail.com
 * last-edited-on: 01/01/2023 10:46 am
 */

trigger Account on Account ( after insert, after update) {
        if (Trigger.isAfter && Trigger.isInsert) {
                AccountAddressStateHandler.createAddressesFromListOfNewAccounts(Trigger.newMap);
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
                AccountAddressStateHandler.updateMainAddressOnAccountMainAddressUpdate(Trigger.newMap);
        }
}