trigger EnquiryProductTrigger on Enquiry_Product__c (after insert, after delete,after update, after undelete) {
    EnquiryProductTriggerHandler.updateCount(Trigger.new, Trigger.old);

}