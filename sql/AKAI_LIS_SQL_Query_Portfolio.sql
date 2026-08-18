-- ============================================================================
-- AKAI LIS SQL QUERY PORTFOLIO
-- AUTHOR: Theophilus K. Akai
-- PURPOSE:
-- Healthcare Informatics, LIS Operations, Quality Assurance,
-- and Clinical Reporting Queries
-- ============================================================================

-- ============================================================================
-- QUERY 001: Rejected Specimen Count
-- BUSINESS QUESTION:
-- How many specimens were rejected?
-- ============================================================================

SELECT COUNT(*)
FROM specimens
WHERE rejection_reason IS NOT NULL;

-- ============================================================================
-- QUERY 002: Rejection Reason Summary
-- BUSINESS QUESTION:
-- How many specimens were rejected for each reason?
-- ============================================================================

SELECT
    rejection_reason,
    COUNT(rejection_reason) AS rejection_count
FROM specimens
WHERE rejection_reason IS NOT NULL
GROUP BY rejection_reason;

-- ============================================================================
-- QUERY 003: Provider Order Volume
-- BUSINESS QUESTION:
-- How many orders has each provider placed?
-- ============================================================================

SELECT
    ordering_provider,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY ordering_provider
ORDER BY total_orders DESC;

-- ============================================================================
-- QUERY 004: Rejected Specimen Investigation
-- BUSINESS QUESTION:
-- Which patients had a rejected specimen and why was it rejected?
--
-- SKILLS:
-- INNER JOIN
-- WHERE
-- ORDER BY
-- Healthcare Quality Assurance Reporting
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

-- ============================================================================
-- QUERY 005: Human-Readable Laboratory Results
-- BUSINESS QUESTION:
-- Show laboratory results using human-readable test name rather than LOINC code.
--
-- SKILLS:
-- Normalization
-- LOINC Integration
-- JOINs
-- Clinical terminology
-- ============================================================================

SELECT
    lr.result_id,
    lm.test_name,
    lr.result_value
FROM lab_results lr
JOIN loinc_map lm
    ON lr.loinc_code = lm.loinc_code;
