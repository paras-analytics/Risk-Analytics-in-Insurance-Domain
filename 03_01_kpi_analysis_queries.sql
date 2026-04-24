-- KPI Analysis Queries

-- KPI 1 — Total Claims
SELECT COUNT(*) AS total_claims
FROM claim_history;

-- KPI 2 — Average Claim Amount
SELECT ROUND(AVG(Claim_Amount), 2) AS avg_claim_amount
FROM claim_history;

-- KPI 3 — Claim Approval Rate
SELECT 
    ROUND(
        SUM(CASE WHEN Claim_Status = 'Approved' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS approval_rate_percentage
FROM claim_history;

-- KPI 4 — Fraud Ratio
SELECT 
    ROUND(
        SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS fraud_ratio_percentage
FROM claim_history;

-- KPI 5 — Policy Lapse Rate
SELECT 
    ROUND(
        SUM(CASE WHEN Status = 'Lapsed' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS lapse_rate_percentage
FROM policy_details;

-- KPI 6 — Region-wise Claim Count
SELECT 
    cm.Region,
    COUNT(ch.Claim_ID) AS total_claims
FROM claim_history ch
JOIN policy_details pd 
    ON ch.Policy_ID = pd.Policy_ID
JOIN customer_master cm
    ON pd.Customer_ID = cm.Customer_ID
GROUP BY cm.Region
ORDER BY total_claims DESC;

ALTER TABLE policy_details
RENAME COLUMN `ï»¿policy_id` TO Policy_ID;

-- KPI 7 — Product-wise Claim Amount
SELECT 
    pd.Product_Type,
    ROUND(SUM(ch.Claim_Amount), 2) AS total_claim_amount
FROM claim_history ch
JOIN policy_details pd
    ON ch.Policy_ID = pd.Policy_ID
GROUP BY pd.Product_Type
ORDER BY total_claim_amount DESC;

-- KPI 8 — Agent Productivity
SELECT 
    Agent_ID,
    Total_Policies_Sold,
    Lapsed_Policies,
    ROUND(
        (Total_Policies_Sold - Lapsed_Policies) * 100.0
        / Total_Policies_Sold, 2
    ) AS retention_rate
FROM agent_info
ORDER BY retention_rate DESC;

