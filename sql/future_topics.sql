-- ============================================================================
-- AKAI COMMUNITY HOSPITAL EHR INFORMATICS - METADATA VIEW MODEL
-- TARGET MODULE: PHASE 4 CLINICAL OPERATIONS & PERFORMANCE DASHBOARDS
-- ============================================================================

-- QUERY 1: LABORATORY TURNAROUND TIME (TAT) RUN-RATE BY TEST COMPONENT
-- Purpose: Pinpoint routing delays from patient collection to doctor notification.
SELECT 
    lm.loinc_code,
    lm.test_name,
    COUNT(lr.result_id) AS total_tests_completed,
    
    -- Collection to Lab Arrival (Transit Time)
    ROUND(AVG(EXTRACT(EPOCH FROM (s.received_datetime - s.collection_datetime))/60)::numeric, 1) AS avg_transit_to_lab_minutes,
    
    -- Lab Arrival to Final Result Signature (Processing Time)
    ROUND(AVG(EXTRACT(EPOCH FROM (lr.result_datetime - s.received_datetime))/60)::numeric, 1) AS avg_analyzer_processing_minutes,
    
    -- Full Cycle Turnaround Time (Total TAT)
    ROUND(AVG(EXTRACT(EPOCH FROM (lr.reported_datetime - s.collection_datetime))/60)::numeric, 1) AS total_end_to_end_tat_minutes
FROM lab_results lr
JOIN specimens s ON lr.specimen_id = s.specimen_id
JOIN loinc_map lm ON lr.loinc_code = lm.loinc_code
WHERE s.rejection_reason IS NULL
GROUP BY lm.loinc_code, lm.test_name
ORDER BY total_end_to_end_tat_minutes DESC;


-- QUERY 2: SPECIMEN REJECTION AUDIT (Pre-Analytical Error Tracking)
-- Purpose: Identify training gaps in clinical areas causing corrupted specimens.
SELECT 
    s.specimen_type,
    s.rejection_reason,
    COUNT(s.specimen_id) AS total_rejected_specimens,
    ROUND((COUNT(s.specimen_id)::numeric / (SELECT COUNT(*) FROM specimens)) * 100, 2) AS hospital_wide_rejection_percentage    
FROM specimens s
WHERE s.rejection_reason IS NOT NULL
GROUP BY s.specimen_type, s.rejection_reason
ORDER BY total_rejected_specimens DESC;


-- QUERY 3: CRITICAL VALUE INCIDENT NOTIFICATION METRICS
-- Purpose: Audit trail response rate monitoring for emergency healthcare notifications.
SELECT 
    o.ordering_provider,
    lm.test_name,
    lr.result_value,
    lr.result_datetime,
    al.action_time AS analyst_logged_notification_time,
    -- Calculate how fast the emergency flag was documented
    ROUND(EXTRACT(EPOCH FROM (al.action_time - lr.result_datetime))/60::numeric, 1) AS communication_lag_minutes
FROM lab_results lr
JOIN specimens s ON lr.specimen_id = s.specimen_id
JOIN orders o ON s.order_id = o.order_id
JOIN loinc_map lm ON lr.loinc_code = lm.loinc_code
LEFT JOIN audit_log al ON al.object_id = lr.result_id AND al.object_type = 'lab_results'
WHERE lr.result_flag = 'critical'
ORDER BY lr.result_datetime DESC;
