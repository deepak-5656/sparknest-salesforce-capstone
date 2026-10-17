public class EnquiryTriggerHandler implements ITriggerHandler {

    public void beforeInsert(List<SObject> newList) {
        List<Enquiry__c> enquiryList = (List<Enquiry__c>) newList;
        EnquiryService.setDefaultStatus(enquiryList);
        EnquiryService.checkBudget(enquiryList);
    }

    public void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        List<Enquiry__c> enquiryList = (List<Enquiry__c>) newList;
        Map<Id, Enquiry__c> oldEnquiryMap = (Map<Id, Enquiry__c>) oldMap;
        EnquiryService.setClosedDate(enquiryList, oldEnquiryMap);
    }

    public void afterInsert(List<SObject> newList) {
        List<Enquiry__c> enquiryList = (List<Enquiry__c>) newList;
        EnquiryService.createFollowUpTasks(enquiryList);
    }

    public void afterUpdate(List<SObject> newList, Map<Id, SObject> oldMap) {
        //Based on requirements, it is not required as of now.
    }
}