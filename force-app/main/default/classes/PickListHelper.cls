public with sharing class PickListHelper {
    public PickListHelper() {

    }
    public static Schema.PicklistEntry getPicklistValuesForLabel(
            Schema.sObjectField field, string label) {
                Schema.PicklistEntry picklistEntry;  
        List<Schema.PicklistEntry> entries = field.getDescribe().getPickListValues();

        for (Schema.PicklistEntry entry : entries) {
            if (entry.isActive() && entry.getLabel().toUpperCase()==label.toLowerCase()) {
                picklistEntry = entry;
                break;
            }
        }
        return picklistEntry;
    }
}
