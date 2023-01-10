/**
 * Author: Ngum buka Fon Nyuydze
 * email: ngumbukafon@gmail.com
 * Created-on: 01/01/2023 6:39 pm
 * last-edited-on: 01/01/2023 6:39 pm
 */


public with sharing class PickListHelper {

    public static Schema.PicklistEntry getPicklistValuesForLabel(Schema.sObjectField field, string label) {
            Schema.PicklistEntry picklistEntry;  
            List<Schema.PicklistEntry> entries = field.getDescribe().getPickListValues();

            for (Schema.PicklistEntry entry : entries) {
                if (entry.isActive() && entry.getLabel().toUpperCase()==label.toUpperCase()) {
                    picklistEntry = entry;
                    break;
                }
            }
            return picklistEntry;
    }
}