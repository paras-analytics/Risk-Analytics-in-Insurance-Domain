CREATE DATABASE IF NOT EXISTS aegislife_insurance;
USE aegislife_insurance;

CREATE TABLE Customer_Master (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Full_Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(20),
    Marital_Status VARCHAR(20),
    Occupation VARCHAR(50),
    Region VARCHAR(50),
    Smoking_Status VARCHAR(10),
    Pre_Existing_Illness VARCHAR(10),
    Risk_Score DECIMAL(4,2),
    Date_Joined DATE
);
CREATE TABLE Agent_Info (
    Agent_ID VARCHAR(20) PRIMARY KEY,
    Region VARCHAR(50),
    Join_Date DATE,
    Total_Policies_Sold INT,
    Lapsed_Policies INT,
    Avg_Premium_Sold DECIMAL(12,2),
    Fraud_Association INT
);

CREATE TABLE Policy_Details (
    Policy_ID VARCHAR(20) PRIMARY KEY,
    Customer_ID VARCHAR(20),
    Product_Type VARCHAR(30),
    Coverage_Amount DECIMAL(15,2),
    Annual_Premium DECIMAL(12,2),
    Policy_Start_Date DATE,
    Policy_End_Date DATE,
    Agent_ID VARCHAR(20),
    Status VARCHAR(20),
    FOREIGN KEY (Customer_ID)
        REFERENCES Customer_Master(Customer_ID),
    FOREIGN KEY (Agent_ID)
        REFERENCES Agent_Info(Agent_ID)
);

CREATE TABLE Claim_History (
    Claim_ID VARCHAR(20) PRIMARY KEY,
    Policy_ID VARCHAR(20),
    Claim_Date DATE,
    Claim_Amount DECIMAL(15,2),
    Claim_Status VARCHAR(20),
    Claim_Type VARCHAR(30),
    Fraud_Flag VARCHAR(10),
    Days_To_Process INT,
    FOREIGN KEY (Policy_ID)
        REFERENCES Policy_Details(Policy_ID)
);
CREATE TABLE Customer_Feedback_Surveys (
    Feedback_ID VARCHAR(20) PRIMARY KEY,
    Customer_ID VARCHAR(20) NULL,
    Date_Submitted DATE,
    Feedback_Text TEXT,
    Satisfaction_Score INT,
    Contacted_Agent VARCHAR(10),
    Referred_Claim VARCHAR(10),
    FOREIGN KEY (Customer_ID)
        REFERENCES Customer_Master(Customer_ID)
);

CREATE TABLE feedback_temp (
    Feedback_ID VARCHAR(20),
    Customer_ID VARCHAR(20),
    Date_Submitted DATE,
    Feedback_Text TEXT,
    Satisfaction_Score INT,
    Contacted_Agent VARCHAR(10),
    Referred_Claim VARCHAR(10)
);
-- Optional Post-Import Fixes (Encountered During Local CSV Import)
-- During project execution, BOM / CSV encoding issues were encountered
-- in some systems, causing hidden characters to appear in column headers.
-- If you face a similar issue during import, please uncomment and use
-- the relevant query below.

-- ALTER TABLE customer_master
-- RENAME COLUMN `ï»¿customer_id` TO customer_id;

-- ALTER TABLE policy_details
-- customer_feedback_surveysRENAME COLUMN `ï»¿policy_id` TO policy_id;

-- ALTER TABLE claim_history
-- RENAME COLUMN `ï»¿claim_id` TO claim_id;

-- ALTER TABLE agent_info
-- customer_feedback_surveysRENAME COLUMN ï»¿agent_id TO agent_id;

-- ALTER TABLE customer_feedback_surveys
-- RENAME COLUMN ï»¿feedback_id TO feedback_id;

-- Changing Date format
-- 1. customer_master.date_joined
UPDATE customer_master
SET date_joined = STR_TO_DATE(date_joined, '%m/%d/%Y %H:%i');

ALTER TABLE customer_master
MODIFY COLUMN date_joined DATE;

-- SQL safe update mode off
-- SET SQL_SAFE_UPDATES=0;

-- 2 policy_details.policy_start_date, policy_end_date

UPDATE policy_details
SET policy_start_date = STR_TO_DATE(policy_start_date, '%m/%d/%Y %H:%i'),
    policy_end_date   = STR_TO_DATE(policy_end_date, '%m/%d/%Y %H:%i');
    
    ALTER TABLE policy_details
MODIFY COLUMN policy_start_date DATETIME,
MODIFY COLUMN policy_end_date DATETIME;

-- 3) claim_history.claim_date

UPDATE claim_history 
SET claim_date = STR_TO_DATE(claim_date, '%m/%d/%Y %H:%i');

ALTER TABLE claim_history
MODIFY COLUMN claim_date DATE;

-- 4) customer_feedback_surveys.date_submitted

UPDATE customer_feedback_surveys
SET date_submitted = STR_TO_DATE(date_submitted, '%m/%d/%Y %H:%i');

ALTER TABLE customer_feedback_surveys
MODIFY COLUMN date_submitted DATE;

-- 5) agent_info.join_date

ALTER TABLE agent_info
MODIFY COLUMN join_date DATE;
