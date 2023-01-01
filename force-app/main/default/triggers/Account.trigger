/**
 * Author: Ngum buka Fon Nyuydze
 * Created-on: 01/01/2023 10:46 am
 * email: ngumbukafon@gmail.com
 * last-edited-on: 01/01/2023 10:46 am
 */

trigger Account on Account (before insert, before update, before
delete, after insert, after update, after delete,  after undelete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountAddressStateHandler.createAddressesFromListOfAccounts(Trigger.New);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
            AccountAddressStateHandler.updateAccountBillingAddress(Trigger.new[0], Trigger.old[0]);
    }

}