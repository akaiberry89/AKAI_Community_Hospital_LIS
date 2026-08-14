# AKAI_Community_Hospital_EHR_Informatics
Clinical Informatics & Healthcare Systems Portfolio mapping clinical pipelines, SQL databases, HL7 workflows, and executive analytics for AKAI Community Hospital. Each phase is connected to the classes I take in my Informatics program.


## 🎯 Overarching Project Mission

AKAI Community Hospital LIS_EHR_Informatics is an end-to-end Laboratory Information Systems and EHR Application Architecture designed to answer two critical questions:
1. **Operational:** *How can a healthcare organization capture, secure, model, and analyze clinical data to improve patient care and executive decision-making?*
2. **Technical:** *How should healthcare data be collected, stored, secured, organized, and reported so the right people get the right information at the right time?*

---

## 🗺️ Curriculum Mapping & Architecture Deliverables

### Phase 1: HL7 Interface Engineering & Logic Validation (INFM 109 & SDEV 120)
* **Core Question:** *How are external laboratory instrument interfaces validated, and how is raw clinical data ingested securely into the EHR?*
* **What I'm Building:** End-to-end interface validation workflows simulating an EHR inbound engine. This includes parsing and validating inbound HL7 `ORM^O01` (Laboratory Order) and `ORU^R01` (Observation Result) messages. It focuses on validating Patient Identification `PID`, Common Order `ORC`, and Observation Request `OBR` segments to eliminate interface parsing faults before they hit clinical environments.

### Phase 2: Clinical Data Dictionary & Relational Architecture (DBMS 110 & DBMS 130)
* **Core Question:** *How are complex laboratory master files, specimen records, and clinical dictionaries structured to ensure data integrity?*
* **What I'm Building:** Normalized PostgreSQL database schema managing `Patients`, `Specimens`, `Accession_Orders`, and LOINC-mapped `Lab_Results`.

### Phase 3: Security, Audit & Compliance (HIMT 104 & CSIA 105)
* **Core Question:** *How is patient data secured and audited for HIPAA compliance?*
* **What I'm Building:** Role-Based Access Control (RBAC) policies and immutable `audit_log` triggers tracking all read/write events on Protected Health Information (PHI).

### Phase 4: Clinical Systems Reporting & Performance Analytics (INFM 219 & CPIN 269)
* **Core Question:** *How does data drive operational efficiency and patient outcomes?*
* **What I'm Building:** Power BI executive dashboards tracking laboratory turnaround times (TAT), specimen rejection rates, and critical flag alerts.
