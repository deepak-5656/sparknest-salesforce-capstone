@IsTest
private class EnquiryProductHelperTest{
    
    @IsTest
    static void testCount() {
        Product2 prod = new Product2(Name = 'Test Phone');
        insert prod;
        Enquiry__c enq = new Enquiry__c(Name = 'Test Enquiry');
        insert enq;

        Enquiry_Product__c ep = new Enquiry_Product__c(Enquiry__c = enq.Id, Product__c = prod.Id);
        insert ep;
        System.assertEquals(1, getCount(enq.Id));

        delete ep;
        System.assertEquals(0, getCount(enq.Id));

        undelete ep;
        System.assertEquals(1, getCount(enq.Id));
    }

    static Decimal getCount(Id enqId) {
        return [SELECT Total_Products_Interested__c FROM Enquiry__c WHERE Id = :enqId].Total_Products_Interested__c;
    }
}