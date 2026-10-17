trigger EnquiryTrigger on Enquiry__c (before insert, before update, after insert, after update) {
    TriggerDispatcher.handleTrigger(new EnquiryTriggerHandler());

}