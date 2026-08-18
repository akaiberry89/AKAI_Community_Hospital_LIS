-- ============================================================================
-- QUERY: Rejected Specimen Audit
-- PURPOSE:
-- List patients whose specimens were rejected and display rejection reasons.
--
-- RELATED TABLES:
-- patients
-- orders
-- specimens
--
-- BUSINESS USE:
-- Supports laboratory quality assurance (QA) and specimen collection training.
-- This is where we can bring up arguments for staff training initiatives!
-- ============================================================================
 
SELECT
  p.first_name,
  p.last_name,
  s.accession_number,
  s.rejection_reason
FROM patients p
JOIN orders o
  ON p.patient_id = o.patient_id
JOIN specimens s
  ON o.order_id = s.order_id
WHERE s.rejection_reason IS NOT NULL
ORDER BY s.accession_number ASC;
