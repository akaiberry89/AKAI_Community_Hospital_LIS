-- ============================================================================
-- AKAI LIS SQL QUERY PORTFOLIO
-- AUTHOR: Theophilus K. Akai
-- PURPOSE:
-- Collection of healthcare informatics, LIS operations,
-- quality assurance, and reporting queries.
-- ============================================================================



-- ============================================================================
-- QUERY 001: Count Total Specimens
-- BUSINESS QUESTION:
-- How many specimens are currently stored in the LIS?
-- ============================================================================

SELECT COUNT(*)
FROM specimens;



-- ============================================================================
-- QUERY 002: Rejected Specimen Count
-- BUSINESS QUESTION:
-- How many specimens were rejected?
-- ============================================================================

SELECT COUNT(*)
FROM specimens
WHERE rejection_reason IS NOT NULL;



-- ============================================================================
-- QUERY 003: Rejection Reason Summary
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
-- QUERY 004: Provider Order Volume
-- BUSINESS QUESTION:
-- How many orders has each provider placed?
-- ============================================================================

SELECT
    ordering_provider,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY ordering_provider
ORDER BY total_orders DESC;
