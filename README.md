# SparkNest – Enquiry Management on Salesforce

SparkNest is an enquiry management solution on the Salesforce Platform for a consumer electronics brand. It captures customer enquiries from the website, routes them to the sales and support teams, gives management real-time visibility, and lets customers check their enquiry status through an AI agent.

---

## Solution Overview

```
Website ──► REST API ──► Contact + Enquiry ──► Automation ──► Sales / Support ──► Dashboard
                                                                     │
                                                       Agentforce Support Agent
```

| Layer | Components |
|-------|------------|
| **Data Model** | `Enquiry__c`, `Enquiry_Product__c` (many-to-many with Product), Contact, Case |
| **Security** | Private sharing, role hierarchy, profiles, permission set with custom permission, criteria-based sharing rule |
| **Automation** | Apex trigger framework, screen / record-triggered / scheduled flows, nightly Batch Apex |
| **Integration** | Custom REST API for website enquiries, Composite API with transactional rollback |
| **Analytics** | Enquiry and case reports, dynamic Sales Overview dashboard |
| **AI** | Agentforce Support Agent with an Enquiry Status Check topic backed by a Flow action |

---

## How It Works

1. **Capture** – The website calls `POST /services/apexrest/enquiry`. The API matches the customer by email, reuses or creates the Contact, and creates the Enquiry.
2. **Validate & automate** – The trigger framework defaults the status, enforces the minimum budget, creates a follow-up task for the owner and stamps the closed date.
3. **Work** – Sales reps see only their own enquiries; managers see their team's through the role hierarchy. Care Plan enquiries are shared with support agents.
4. **Escalate** – A screen flow converts an enquiry into a Case and assigns it to the correct support queue.
5. **Maintain** – A nightly batch closes stale enquiries; a weekly scheduled flow sends a summary to the sales manager.
6. **Report** – A dynamic dashboard shows each user the data they are allowed to see.
7. **Self-service** – Customers ask the Agentforce agent for their enquiry status; the agent only returns that customer's latest enquiry.

---

## Apex Overview

| Class | Responsibility |
|-------|----------------|
| `EnquiryTrigger` | Thin trigger; delegates to the dispatcher |
| `TriggerDispatcher` | Routes each trigger context to the handler |
| `EnquiryTriggerHandler` | Handler implementation for `Enquiry__c` |
| `EnquiryService` | Bulk-safe business logic |
| `SparkNestEnquiryAPI` | REST endpoint for website enquiry submission |
| `CloseStaleEnquiriesBatch` | Closes inactive enquiries in batches |
| `CloseStaleEnquiriesScheduler` | Schedules the batch nightly |
| `TestDataFactory` | Reusable test data for all test classes |

All logic is bulkified and covered by unit tests with assertions, including bulk scenarios.

---

## Project Structure

```
force-app/main/default/
├── classes/            Apex classes and test classes
├── triggers/           Object triggers
├── flows/              Screen, record-triggered, scheduled and agent action flows
├── objects/            Custom objects and fields
├── permissionsets/     Permission sets
├── profiles/           Profiles
├── reports/            Reports
├── dashboards/         Dashboards
└── bots/               Agentforce agent
manifest/
└── package.xml         Metadata manifest
postman/                API collection (REST and Composite)
```

---

## Setup

```bash
sf org login web --alias sparknest
sf project deploy start --manifest manifest/package.xml --target-org sparknest
sf apex run test --target-org sparknest --test-level RunLocalTests --code-coverage --result-format human
```

---

## Tech Stack

Salesforce Platform · Apex · Flow Builder · Lightning App Builder · REST & Composite API · Reports & Dashboards · Agentforce · Salesforce CLI · Git

---

**Author:** Deepak R
