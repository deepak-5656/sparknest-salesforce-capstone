@IsTest
private class EnquiryServiceTest {

    // 1. blank Status should become New
    @IsTest
    static void testBlankStatusSetToNew() {
        List<Enquiry__c> enquiryList = TestDataFactory.createEnquiries(1, false);
        enquiryList[0].Status__c = null;

        Test.startTest();
        insert enquiryList;
        Test.stopTest();

        Enquiry__c savedEnq = [SELECT Status__c FROM Enquiry__c WHERE Id = :enquiryList[0].Id];
        System.assertEquals('New', savedEnq.Status__c, 'Blank status should be set to New');
    }

    // 2. budget below 1000 should fail with the error
    @IsTest
    static void testLowBudgetGivesError() {
        List<Enquiry__c> enquiryList = TestDataFactory.createEnquiries(1, false);
        enquiryList[0].Customer_Budget__c = 500;

        String errorMessage = '';
        Test.startTest();
        try {
            insert enquiryList;
        } catch (DmlException e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        System.assert(errorMessage.contains('Customer budget must be at least'), 'Should show budget error');
        System.assertEquals(0, [SELECT COUNT() FROM Enquiry__c], 'Enquiry should not be saved');
    }

    // 3. follow-up task should be created with correct subject, owner and due date
    @IsTest
    static void testFollowUpTaskCreated() {
        Test.startTest();
        List<Enquiry__c> enquiryList = TestDataFactory.createEnquiries(1, true);
        Test.stopTest();

        Task followUp = [SELECT Subject, OwnerId, ActivityDate FROM Task WHERE WhatId = :enquiryList[0].Id];
        System.assertEquals('Follow up: Test Enquiry 1', followUp.Subject, 'Subject is wrong');
        System.assertEquals(UserInfo.getUserId(), followUp.OwnerId, 'Owner should be enquiry owner');
        System.assertEquals(Date.today().addDays(3), followUp.ActivityDate, 'Due date should be today + 3');
    }

    // 4. closing the enquiry should set Closed Date to today
    @IsTest
    static void testClosedDateSet() {
        List<Enquiry__c> enquiryList = TestDataFactory.createEnquiries(1, true);

        Test.startTest();
        enquiryList[0].Status__c = 'Closed';
        update enquiryList;
        Test.stopTest();

        Enquiry__c savedEnq = [SELECT Closed_Date__c FROM Enquiry__c WHERE Id = :enquiryList[0].Id];
        System.assertEquals(Date.today(), savedEnq.Closed_Date__c, 'Closed Date should be today');
    }

    // 5. bulk test with 200 records
    @IsTest
    static void testBulkInsert() {
        Test.startTest();
        TestDataFactory.createEnquiries(200, true);
        Test.stopTest();

        System.assertEquals(200, [SELECT COUNT() FROM Enquiry__c WHERE Status__c = 'New'], '200 enquiries should be New');
        System.assertEquals(200, [SELECT COUNT() FROM Task WHERE Subject LIKE 'Follow up:%'], '200 tasks should be created');
    }
}