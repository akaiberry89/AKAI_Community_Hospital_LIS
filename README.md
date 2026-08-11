# AKAI_Community_Hospital_LIS
Healthcare Data Engineering portfolio mapping clinical pipelines, SQL databases, HL7 workflows, and executive analytics for AKAI Community Hospital. ** A portfolio project documenting a transition from professional musician to healthcare data professional. **


## 🎯 Overarching Project Mission

AKAI Community Hospital LIS is an end-to-end Healthcare Data Architecture platform designed to answer two critical questions:
1. **Operational:** *How can a healthcare organization capture, secure, model, and analyze clinical data to improve patient care and executive decision-making?*
2. **Technical:** *How should healthcare data be collected, stored, secured, organized, and reported so the right people get the right information at the right time?*

---

## 🗺️ Curriculum Mapping & Architecture Deliverables

### Phase 1: Ingestion & Logic Validation (INFM 109 & SDEV 120)
* **Core Question:** *How is raw healthcare data captured and validated at entry?*
* **What You Build:** Python interface scripts parsing raw HL7 `ORM^O01` streams, extracting `PID`/`OBR` segments, and handling malformed message errors.

### Phase 2: Relational Data Warehousing (DBMS 110 & DBMS 130)
* **Core Question:** *How should healthcare data be structured, stored, and normalized?*
* **What You Build:** Normalized PostgreSQL database schema managing `Patients`, `Specimens`, `Accession_Orders`, and LOINC-mapped `Lab_Results`.

### Phase 3: Security, Audit & Compliance (HIMT 104 & CSIA 105)
* **Core Question:** *How is patient data secured and audited for HIPAA compliance?*
* **What You Build:** Role-Based Access Control (RBAC) policies and immutable `audit_log` triggers tracking all read/write events on Protected Health Information (PHI).

### Phase 4: Analytics & Executive Decision Support (INFM 219 & CPIN 269)
* **Core Question:** *How does data drive operational efficiency and patient outcomes?*
* **What You Build:** Power BI executive dashboards tracking laboratory turnaround times (TAT), specimen rejection rates, and critical flag alerts.
