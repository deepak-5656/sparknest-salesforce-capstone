public with sharing class EnquiryProductHelper {

    public static void countProducts(Set<Id> enqIds) {
        enqIds.remove(null);
        if (enqIds.isEmpty()) return;

        List<AggregateResult> results = [SELECT Enquiry__c, COUNT(Id) total FROM Enquiry_Product__c  WHERE Enquiry__c IN :enqIds GROUP BY Enquiry__c];


        Map<Id, Integer> productCount = new Map<Id, Integer>();
        for (AggregateResult ar : results) {
         Id enqId = (Id) ar.get('Enquiry__c');
        Integer total = (Integer) ar.get('total');
        productCount.put(enqId, total);
        }

        List<Enquiry__c> enquiryList = new List<Enquiry__c>();
        for (Id enqId : enqIds) {
            Integer total = productCount.containsKey(enqId) ? productCount.get(enqId) : 0;

            enquiryList.add(new Enquiry__c(Id = enqId, Total_Products_Interested__c = total));
        }
        update enquiryList;
    }

}