public with sharing class EnquiryProductTriggerHandler {
    public static void updateCount(List<Enquiry_Product__c> newList, List<Enquiry_Product__c> oldList) {
        Set<Id> enqIds = new Set<Id>();

        if (newList != null) {
            for (Enquiry_Product__c ep : newList) {
                enqIds.add(ep.Enquiry__c);
            }
        }
        if (oldList != null) {
            for (Enquiry_Product__c ep : oldList) {
                enqIds.add(ep.Enquiry__c);
            }
        }

        EnquiryProductHelper.countProducts(enqIds);
    }

}