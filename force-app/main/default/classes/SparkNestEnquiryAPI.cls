@RestResource(urlMapping='/enquiry/*')
global with sharing class SparkNestEnquiryAPI {

    // website calls this when a customer submits the enquiry form
    @HttpPost
    global static void submitEnquiry(String firstName, String lastName, String email, String phone, String subject, String enquiryType, Decimal budget) {

        // email is needed to find or create the customer
        if (String.isBlank(email)) {
            sendResponse(400, false, 'Email is required to submit an enquiry', null, null);
            return;
        }


        // undo all changes if anything fails
        Savepoint savePoint = Database.setSavepoint();
        try {
            Contact customer = findContactByEmail(email);
            String message = 'Existing customer found, enquiry created';

            if (customer == null) {
                customer = createContact(firstName, lastName, email, phone);
                message = 'New customer and enquiry created';
            }

            Enquiry__c newEnquiry = createEnquiry(customer.Id, subject, enquiryType, budget);
            sendResponse(201, true, message, customer.Id, newEnquiry.Id);

        } catch (DmlException e) {
            Database.rollback(savePoint);
            sendResponse(400, false, e.getDmlMessage(0), null, null);
        }
    }

    private static Contact findContactByEmail(String email) {
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email = :email LIMIT 1];
        if (contactList.isEmpty()) {
            return null;
        }
        return contactList[0];
    }

    private static Contact createContact(String firstName, String lastName, String email, String phone) {
        Contact newContact = new Contact();
        newContact.FirstName = firstName;
        newContact.LastName = lastName;
        newContact.Email = email;
        newContact.Phone = phone;

        List<Account> accountList = [SELECT Id FROM Account WHERE Name = 'SparkNest Customers' LIMIT 1];
        if (!accountList.isEmpty()) {
            newContact.AccountId = accountList[0].Id;
        }

        insert newContact;
        return newContact;
    }

    // create enquiry for the contact
    private static Enquiry__c createEnquiry(Id contactId, String subject, String enquiryType, Decimal budget) {
        Enquiry__c newEnquiry = new Enquiry__c();
        newEnquiry.Name = subject;
        newEnquiry.Contact__c = contactId;
        newEnquiry.Enquiry_Type__c = enquiryType;
        newEnquiry.Customer_Budget__c = budget;
        insert newEnquiry;
        return newEnquiry;
    }

    //it will send JSON response back
    private static void sendResponse(Integer statusCode, Boolean success, String message, Id contactId, Id enquiryId) {
        Map<String, Object> result = new Map<String, Object>();
        result.put('success', success);
        result.put('message', message);
        result.put('contactId', contactId);
        result.put('enquiryId', enquiryId);

        RestContext.response.statusCode = statusCode;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}