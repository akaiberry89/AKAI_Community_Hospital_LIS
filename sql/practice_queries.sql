-- ============================================================================
-- AKAI COMMUNITY HOSPITAL EHR & INFORMATICS SYSTEM
-- SQL PRACTICE WORKSPACE
--
-- AUTHOR: Theophilus K. Akai
--
-- PURPOSE:
-- Sandbox for learning SQL concepts, testing ideas,
-- experimenting with joins, aggregates, filters,
-- and validating assumptions against the LIS database.
--
-- NOTE:
-- Portfolio-worthy queries should be promoted to:
--
-- sql/AKAI_LIS_SQL_Query_Portfolio.sql
--
-- This file is intentionally informal and may contain:
-- - Practice queries
-- - Trial-and-error attempts
-- - Query variations
-- - Learning exercises
-- ============================================================================



-- ============================================================================
-- SECTION 01: COUNTS & BASIC RETRIEVAL
-- ============================================================================

SELECT COUNT(*)
FROM patients;

SELECT COUNT(*)
FROM orders;

SELECT COUNT(*)
FROM specimens;

SELECT COUNT(*)
FROM lab_results;



-- ============================================================================
-- SECTION 02: FILTERING
-- ============================================================================

SELECT *
FROM specimens
WHERE rejection_reason IS NOT NULL;

SELECT *
FROM lab_results
WHERE result_flag = 'critical';



-- ============================================================================
-- SECTION 03: GROUP BY PRACTICE
-- ============================================================================

SELECT
    rejection_reason,
    COUNT(*) AS rejection_count
FROM specimens
WHERE rejection_reason IS NOT NULL
GROUP BY rejection_reason;

SELECT
    ordering_provider,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY ordering_provider
ORDER BY total_orders DESC;



-- ============================================================================
-- SECTION 04: JOIN PRACTICE
-- ============================================================================

SELECT
    lr.result_id,
    lm.test_name,
    lr.result_value
FROM lab_results lr
JOIN loinc_map lm
    ON lr.loinc_code = lm.loinc_code;



-- ============================================================================
-- SECTION 05: PATIENT WORKFLOW PRACTICE
-- ============================================================================

SELECT
    p.first_name,
    p.last_name,
    lr.result_value
FROM patients p
JOIN orders o
    ON p.patient_id = o.patient_id
JOIN specimens s
    ON o.order_id = s.order_id
JOIN lab_results lr
    ON s.specimen_id = lr.specimen_id
ORDER BY p.last_name ASC;




