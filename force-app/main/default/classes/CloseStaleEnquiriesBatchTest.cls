@IsTest
private class CloseStaleEnquiriesBatchTest {

    @IsTest
    static void testBatchClosesEnquiries() {
        List<Enquiry__c> enquiryList = TestDataFactory.createEnquiries(5, false);
        for (Enquiry__c enq : enquiryList) {
            enq.Status__c = 'In Progress';
        }
        insert enquiryList;

        Test.startTest();
        CloseStaleEnquiriesBatch batchJob = new CloseStaleEnquiriesBatch();
        batchJob.execute(null, enquiryList);
        Test.stopTest();

        System.assertEquals(5, [SELECT COUNT() FROM Enquiry__c WHERE Status__c = 'Closed'], 'All 5 should be closed');
    }
    
    @IsTest
    static void testRecentEnquiriesStayOpen() {
        List<Enquiry__c> enquiryList = TestDataFactory.createEnquiries(5, false);
        for (Enquiry__c enq : enquiryList) {
            enq.Status__c = 'In Progress';
        }
        insert enquiryList;

        Test.startTest();
        Database.executeBatch(new CloseStaleEnquiriesBatch());
        Test.stopTest();

        System.assertEquals(5, [SELECT COUNT() FROM Enquiry__c WHERE Status__c = 'In Progress'], 'Recent enquiries should stay open');
    }

    @IsTest
    static void testScheduler() {
        Test.startTest();
        String jobId = System.schedule('Test Close Stale Enquiries', '0 0 1 * * ?', new CloseStaleEnquiriesScheduler());
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Job should be scheduled');
    }
}