
 -- Tabela principal: demographics (sem FK, é a origem)
CREATE TABLE demographics (
    customer_id     VARCHAR(20)  NOT NULL,
    gender          VARCHAR(10),
    age             INT          CHECK (age > 0 AND age < 120),
    under_30        VARCHAR(5),
    senior_citizen  VARCHAR(5),
    married         VARCHAR(5),
    dependents      VARCHAR(5),
    num_dependents  INT          CHECK (num_dependents >= 0),
    CONSTRAINT pk_demographics PRIMARY KEY (customer_id)
);

CREATE TABLE location (
    customer_id  VARCHAR(20)  NOT NULL,
    country      VARCHAR(50),
    state        VARCHAR(50),
    city         VARCHAR(100),
    zip_code     VARCHAR(10),
    latitude     FLOAT,
    longitude    FLOAT,
    CONSTRAINT pk_location PRIMARY KEY (customer_id),
    CONSTRAINT fk_location_customer FOREIGN KEY (customer_id)
        REFERENCES demographics (customer_id)
);

CREATE TABLE services (
    customer_id                  VARCHAR(20)  NOT NULL,
    quarter                      VARCHAR(5),
    referred_a_friend            VARCHAR(5),
    num_referrals                INT          CHECK (num_referrals >= 0),
    tenure_months                INT          CHECK (tenure_months >= 0),
    offer                        VARCHAR(20),
    phone_service                VARCHAR(5),
    avg_monthly_long_distance    FLOAT,
    multiple_lines               VARCHAR(5),
    internet_service             VARCHAR(5),
    internet_type                VARCHAR(20),
    avg_monthly_gb_download      FLOAT,
    online_security              VARCHAR(5),
    online_backup                VARCHAR(5),
    device_protection_plan       VARCHAR(5),
    premium_tech_support         VARCHAR(5),
    streaming_tv                 VARCHAR(5),
    streaming_movies             VARCHAR(5),
    streaming_music              VARCHAR(5),
    unlimited_data               VARCHAR(5),
    contract                     VARCHAR(30),
    paperless_billing            VARCHAR(5),
    payment_method               VARCHAR(30),
    monthly_charge               FLOAT        CHECK (monthly_charge >= 0),
    total_charges                FLOAT        CHECK (total_charges >= 0),
    total_refunds                FLOAT        CHECK (total_refunds >= 0),
    total_extra_data_charges     FLOAT        CHECK (total_extra_data_charges >= 0),
    total_long_distance_charges  FLOAT        CHECK (total_long_distance_charges >= 0),
    total_revenue                FLOAT        CHECK (total_revenue >= 0),
    CONSTRAINT pk_services PRIMARY KEY (customer_id),
    CONSTRAINT fk_services_customer FOREIGN KEY (customer_id)
        REFERENCES demographics (customer_id)
);

CREATE TABLE status (
    customer_id        VARCHAR(20)  NOT NULL,
    quarter            VARCHAR(5),
    satisfaction_score INT          CHECK (satisfaction_score BETWEEN 1 AND 5),
    customer_status    VARCHAR(20),
    churn_label        VARCHAR(5),
    churn_value        INT          CHECK (churn_value IN (0, 1)),
    churn_score        INT          CHECK (churn_score BETWEEN 0 AND 100),
    cltv               INT          CHECK (cltv >= 0),
    churn_category     VARCHAR(50),
    churn_reason       VARCHAR(100),
    CONSTRAINT pk_status PRIMARY KEY (customer_id),
    CONSTRAINT fk_status_customer FOREIGN KEY (customer_id)
        REFERENCES demographics (customer_id)
);

CREATE TABLE population (
    zip_code    VARCHAR(10)  NOT NULL,
    population  INT          CHECK (population >= 0),
    CONSTRAINT pk_population PRIMARY KEY (zip_code)
);

COPY demographics (customer_id, gender, age, under_30, senior_citizen, married, dependents, num_dependents)
FROM 'C:/tmp/demographics.csv'
DELIMITER ',' CSV HEADER;

COPY location (customer_id, country, state, city, zip_code, latitude, longitude)
FROM 'C:/tmp/location.csv'
DELIMITER ',' CSV HEADER;

COPY services (customer_id, quarter, referred_a_friend, num_referrals, tenure_months, offer, phone_service, avg_monthly_long_distance, multiple_lines, internet_service, internet_type, avg_monthly_gb_download, online_security, online_backup, device_protection_plan, premium_tech_support, streaming_tv, streaming_movies, streaming_music, unlimited_data, contract, paperless_billing, payment_method, monthly_charge, total_charges, total_refunds, total_extra_data_charges, total_long_distance_charges, total_revenue)
FROM 'C:/tmp/services.csv'
DELIMITER ',' CSV HEADER;

COPY status (customer_id, quarter, satisfaction_score, customer_status, churn_label, churn_value, churn_score, cltv, churn_category, churn_reason)
FROM 'C:/tmp/status.csv'
DELIMITER ',' CSV HEADER;

COPY population (zip_code, population)
FROM 'C:/tmp/population.csv'
DELIMITER ',' CSV HEADER;

SELECT 'demographics' AS tabela, COUNT(*) AS linhas FROM demographics
UNION ALL
SELECT 'location',   COUNT(*) FROM location
UNION ALL
SELECT 'services',   COUNT(*) FROM services
UNION ALL
SELECT 'status',     COUNT(*) FROM status
UNION ALL
SELECT 'population', COUNT(*) FROM population;

-------------------

SELECT
	COUNT(*) AS total,
	COUNT(*) / (SELECT COUNT(*) FROM status where customer_status = 'Churned')  AS Churn_geral
FROM status

-------------------

SELECT 
	customer_status,
	COUNT(*) AS total,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS churn_percentual
FROM
	status
GROUP BY customer_status
ORDER BY churn_percentual DESC

-------------------

SELECT 
	SE.contract,
	ST.churn_label,
	COUNT(*) as total_clients,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY SE.contract),2) AS churn_percentage
FROM 
	services AS SE
INNER JOIN 
	status AS ST ON SE.customer_id = ST.customer_id
GROUP BY SE.contract,st.churn_label
ORDER BY contract DESC, churn_percentage

-------------------

SELECT
	AVG(monthly_charge) AS AVG_monthly_charge,
	MAX(monthly_charge) AS MAX_monthly_charge,
	MIN(monthly_charge) AS MIN_monthly_charge,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_charge) AS mediana
FROM
	services

-------------------

CREATE VIEW vw_clientes AS
SELECT
    se.customer_id,
    se.contract,
    se.monthly_charge,
    se.tenure_months,
    se.internet_service,
    se.internet_type,
    se.premium_tech_support,
    se.streaming_tv,
    se.payment_method,
    st.churn_label,
    st.churn_value,
    st.satisfaction_score,
    st.churn_category,
    st.churn_reason,
    de.gender,
    de.age,
    de.senior_citizen,
    de.married,
    CASE
        WHEN se.monthly_charge < 40 THEN 'Low'
        WHEN se.monthly_charge < 75 THEN 'Medium'
        ELSE 'High'
    END AS charge_category
FROM services se
INNER JOIN status st ON se.customer_id = st.customer_id
INNER JOIN demographics de ON se.customer_id = de.customer_id;

-------------------

SELECT 
	CASE
		WHEN tenure_months <= 12 THEN '0-12'
		WHEN tenure_months > 12 AND tenure_months < 25 THEN '13-24'
		WHEN tenure_months >= 25 AND tenure_months < 49 THEN '25-48'
		ELSE '48+'
	END AS tenure_months_category,
	COUNT(*) AS TOTAL,
	COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) AS churn_count,
	ROUND(COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) * 100.0 / COUNT(*),2) AS churn_percentage
FROM vw_clientes
GROUP BY tenure_months_category
ORDER BY churn_percentage

-------------------
	
SELECT 
	charge_category,
	COUNT(*) AS TOTAL,
	COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) AS churn_count,
	ROUND(COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) * 100.0 / COUNT(*),2) AS churn_percentage
FROM vw_clientes
GROUP BY charge_category
ORDER BY churn_percentage
