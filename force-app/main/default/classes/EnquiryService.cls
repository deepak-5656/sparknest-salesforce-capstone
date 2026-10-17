public class EnquiryService {

    // Before Insert: if Status is empty, set it to New
    public static void setDefaultStatus(List<Enquiry__c> enquiryList) {
        for (Enquiry__c enq : enquiryList) {
            if (String.isBlank(enq.Status__c)) {
                enq.Status__c = 'New';
            }
        }
    }

    // Before Insert: budget must be at least 1000
    public static void checkBudget(List<Enquiry__c> enquiryList) {
        for (Enquiry__c enq : enquiryList) {
            if (enq.Customer_Budget__c != null && enq.Customer_Budget__c < 1000) {
                enq.Customer_Budget__c.addError('Customer budget must be at least ₹1,000');
            }
        }
    }

    // After Insert: create a follow-up task for each new enquiry
    public static void createFollowUpTasks(List<Enquiry__c> enquiryList) {
        List<Task> taskList = new List<Task>();

        for (Enquiry__c enq : enquiryList) {
            Task followUp = new Task();
            followUp.Subject = 'Follow up: ' + enq.Name;
            followUp.OwnerId = enq.OwnerId;
            followUp.WhatId = enq.Id;
            followUp.ActivityDate = Date.today().addDays(3);
            followUp.Status = 'Not Started';
            followUp.Priority = 'Normal';
            taskList.add(followUp);
        }

        if (!taskList.isEmpty()) {
            insert taskList;
        }
    }

    // Before Update: when Status changes to Closed, set Closed Date to today
    public static void setClosedDate(List<Enquiry__c> enquiryList, Map<Id, Enquiry__c> oldMap) {
        for (Enquiry__c enq : enquiryList) {
            Enquiry__c oldEnq = oldMap.get(enq.Id);
            if (enq.Status__c == 'Closed' && oldEnq.Status__c != 'Closed') {
                enq.Closed_Date__c = Date.today();
            }
        }
    }
}