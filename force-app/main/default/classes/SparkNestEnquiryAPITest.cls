@IsTest
private class SparkNestEnquiryAPITest {

    // empty request and response
    static void setUpRequest() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/services/apexrest/enquiry';
        RestContext.request.httpMethod = 'POST';
    }

    // new customer
    @IsTest
    static void testNewCustomer() {
        setUpRequest();
        Test.startTest();
        SparkNestEnquiryAPI.submitEnquiry('Suresh', 'Patel', 'suresh.patel@test.com', '9876500011', 'Laptop query', 'Product Enquiry', 20000);
        Test.stopTest();

        System.assertEquals(201, RestContext.response.statusCode, 'Should return 201');
        System.assertEquals(1, [SELECT COUNT() FROM Contact WHERE Email = 'suresh.patel@test.com'], 'Contact should be created');
        System.assertEquals(1, [SELECT COUNT() FROM Enquiry__c], 'Enquiry should be created');
    }

    // existing customer
    @IsTest
    static void testExistingCustomer() {
        insert new Contact(FirstName = 'Suresh', LastName = 'Patel', Email = 'suresh.patel@test.com');
        setUpRequest();
        Test.startTest();
        SparkNestEnquiryAPI.submitEnquiry('Suresh', 'Patel', 'suresh.patel@test.com', '9876500011', 'Care plan query', 'Care Plan Enquiry', 5000);
        Test.stopTest();

        System.assertEquals(201, RestContext.response.statusCode, 'Should return 201');
        System.assertEquals(1, [SELECT COUNT() FROM Contact WHERE Email = 'suresh.patel@test.com'], 'No duplicate contact');
        System.assertEquals(1, [SELECT COUNT() FROM Enquiry__c], 'Enquiry should be created');
    }

    // missing email
    @IsTest
    static void testMissingEmail() {
        setUpRequest();
        Test.startTest();
        SparkNestEnquiryAPI.submitEnquiry('Suresh', 'Patel', null, '9876500011', 'No email', 'Product Enquiry', 5000);
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode, 'Should return 400');
        System.assertEquals(0, [SELECT COUNT() FROM Enquiry__c], 'Nothing should be created');
    }

    // low budget
    @IsTest
    static void testLowBudgetRollsBack() {
        setUpRequest();
        Test.startTest();
        SparkNestEnquiryAPI.submitEnquiry('Suresh', 'Patel', 'suresh.patel@test.com', '9876500011', 'Low budget', 'Product Enquiry', 500);
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode, 'Should return 400');
        System.assertEquals(0, [SELECT COUNT() FROM Contact WHERE Email = 'suresh.patel@test.com'], 'Contact should be rolled back');
    }
}