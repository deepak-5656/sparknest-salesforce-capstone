@IsTest
public class TestDataFactory {

    // creates test enquiries, inserts them only if doInsert is true
    public static List<Enquiry__c> createEnquiries(Integer count, Boolean doInsert) {
        List<Enquiry__c> enquiryList = new List<Enquiry__c>();

        for (Integer i = 1; i <= count; i++) {
            Enquiry__c enq = new Enquiry__c();
            enq.Name = 'Test Enquiry ' + i;
            enq.Enquiry_Type__c = 'Product Enquiry';
            enq.Customer_Budget__c = 5000;
            enquiryList.add(enq);
        }

        if (doInsert) {
            insert enquiryList;
        }
        return enquiryList;
    }
}