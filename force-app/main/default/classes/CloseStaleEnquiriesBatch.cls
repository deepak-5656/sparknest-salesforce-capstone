public class CloseStaleEnquiriesBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c
            FROM Enquiry__c
            WHERE Status__c = 'In Progress'
            AND LastModifiedDate < LAST_N_DAYS:30
            AND (LastActivityDate = null OR LastActivityDate < LAST_N_DAYS:30)
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Enquiry__c> enquiryList) {
        for (Enquiry__c enq : enquiryList) {
            enq.Status__c = 'Closed';
        }
        update enquiryList;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Close stale enquiries batch finished');
    }
}