# Dubai Economic Powerhouses: Sector-Wise Performance Tracker
## Overview 

The MD14thJ2_db database models the economic and corporate landscape of Dubai by capturing detailed data on economic sectors, companies, financial performance, large-scale projects, and international operations. It consists of five main tables:

•sectors: Tracks GDP contribution and growth rate for key economic sectors (e.g., Oil & Gas, Real Estate, Technology).

•companies: Stores details on Dubai-based firms, including ownership type, employee size, and whether they are publicly traded.

•financials: Records yearly revenue, profit, assets, and market capitalization for each company.

•projects: Lists major infrastructure and corporate initiatives, their cost, and progress status.

•international_operations: Tracks global expansion of Dubai companies, including country presence, type of operation, and revenue impact.


The database supports a wide range of analytical queries—identifying the top-performing companies, evaluating sector-wise contributions, tracking mega-projects, analyzing international influence, and comparing private vs government-owned enterprise metrics.

## Objectives 

To analyze the financial and operational impact of Dubai's major companies on GDP, employment, and infrastructure development, supporting economic diversification strategies

## Database Creation 
``` sql
CREATE DATABASE MD14thJ2_db;
USE MD14thJ2_db;
```
## Tables Creation
### Table:sectors
``` sql
CREATE TABLE sectors (
        sector_id            INT PRIMARY KEY AUTO_INCREMENT,
        sector_name          TEXT,
        contribution_to_gdp  DECIMAL (10,2),
        growth_rate          DECIMAL (10,2)
);

SELECT * FROM sectors ;
```
### Table:companies
``` sql
CREATE TABLE companies (
        company_id            INT PRIMARY KEY AUTO_INCREMENT,
        company_name          TEXT,
        founded_year          INT,
        sector_id             INT,
        headquarters          TEXT,
        ceo                   TEXT,
        employee_count        INT,
        is_government_owned   BOOLEAN,
        is_publicly_traded    BOOLEAN,
        stock_symbol          TEXT,
        FOREIGN KEY (sector_id) REFERENCES sectors(sector_id)
);

SELECT * FROM companies ;
```
### Table:financials
``` sql
CREATE TABLE financials (
        financial_id     INT PRIMARY KEY AUTO_INCREMENT,
        company_id       INT,
        year             INT,
        revenue_aed      DECIMAL (10,2),
        profit_aed       DECIMAL (10,2),
        assets_aed       DECIMAL (10,2),
        market_cap_aed   DECIMAL (10,2),
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

SELECT * FROM financials ;
```
### Table:projects
``` sql
CREATE TABLE projects (
        project_id           INT PRIMARY KEY AUTO_INCREMENT,
        company_id           INT,
        project_name         TEXT,
        start_date           DATE,
        completion_date      DATE,
        estimated_cost_aed   DECIMAL (10,2),
        sector_id            INT,
        status               TEXT,
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

SELECT * FROM projects ;
```
### Table:international_operations
``` sql
CREATE TABLE international_operations (
        international_operation_id  INT PRIMARY KEY AUTO_INCREMENT,
        company_id                  INT,
        country                     TEXT,
        entry_year                  INT,
        operation_type              TEXT,
        revenue_contribution        DECIMAL (10,2),
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

SELECT * FROM international_operations ;
```
## Key Queries 

#### 1-Which Dubai company had the highest revenue in 2023, and what was its profit margin?
``` sql
SELECT 
        c.company_name,f.year,
    SUM(f.revenue_aed) AS Total_revenue,
    SUM(f.profit_aed) AS Total_Profit,
    ROUND(SUM(f.profit_aed)*100.0/SUM(f.revenue_aed),2) AS Profit_margin
FROM companies c 
JOIN financials f ON f.company_id=c.company_id
WHERE f.year=2023
GROUP BY c.company_name,f.year
ORDER BY Total_revenue DESC 
LIMIT 1;
```
#### 2-Compare the average revenue growth of government-owned vs private companies.
``` sql
SELECT 
        CASE 
                WHEN c.is_government_owned=TRUE THEN 'Government Companies'
        ELSE 'Private Companies'
        END AS Company_type,
    f.year,
    ROUND(AVG(f.revenue_aed),2) AS Average_Revenue
FROM companies c 
JOIN financials f ON f.company_id=c.company_id
GROUP BY Company_type,f.year;
```
#### 3-List companies with profit margins above 20% in 2023.
``` sql
SELECT 
        c.company_name,f.year,
    SUM(f.revenue_aed) AS Total_revenue,
    SUM(f.profit_aed) AS Total_Profit,
    ROUND(SUM(f.profit_aed)*100.0/SUM(f.revenue_aed),2) AS Profit_margin_percentage
FROM companies c 
JOIN financials f ON f.company_id=c.company_id
WHERE f.year=2023
GROUP BY c.company_name,f.year
HAVING Profit_margin_percentage>20
ORDER BY Profit_margin_percentage DESC;
```
#### 4-What is the total market capitalization of all publicly traded Dubai companies?
``` sql
SELECT 
        SUM(market_cap_aed) AS Total_Market_Capitalization
FROM financials f
JOIN companies c ON c.company_id=f.company_id
WHERE c.is_publicly_traded=TRUE;
```
#### 5-Which economic sector contributes most to Dubai's GDP and why?
``` sql
SELECT 
        sector_name,contribution_to_gdp,growth_rate
FROM sectors 
ORDER BY contribution_to_gdp DESC 
LIMIT 1;
```
#### 6-Show the revenue distribution across sectors (pie chart suitable).
``` sql
SELECT 
        s.sector_name,SUM(f.revenue_aed) AS Total_Revenue
FROM sectors s 
JOIN companies c ON c.sector_id=s.sector_id
JOIN financials f ON f.company_id=c.company_id
GROUP BY s.sector_name;
```
#### 7-Which sector has the highest growth rate but lowest current GDP contribution
``` sql
SELECT 
        sector_name,contribution_to_gdp,growth_rate
FROM sectors 
ORDER BY 
        contribution_to_gdp ASC,
    growth_rate DESC
LIMIT 1;
```
#### 8-List all ongoing mega-projects with budgets exceeding AED 10 billion.
``` sql
SELECT 
        p.project_name,c.company_name,s.sector_name,
    p.start_date,p.completion_date,p.estimated_cost_aed,p.status
FROM projects p 
JOIN companies c ON p.company_id=c.company_id
JOIN sectors s ON c.sector_id=s.sector_id
WHERE 
        LOWER(p.status)='ongoing'
        AND p.estimated_cost_aed>10000
ORDER BY p.estimated_cost_aed DESC;
```
#### 9-Which company has the most delayed projects, and what's the average delay duration?
``` sql
SELECT 
    c.company_name,
    COUNT(*) AS delayed_projects,
    ROUND(AVG(DATEDIFF(CURDATE(), p.completion_date)), 2) AS avg_days_delayed
FROM projects p
JOIN companies c ON c.company_id = p.company_id
WHERE 
    p.status != 'Completed'
    AND p.completion_date < CURDATE()
GROUP BY c.company_name
ORDER BY delayed_projects DESC;
```
#### 10-Calculate the total estimated cost of all real estate projects under development.
``` sql
SELECT 
    s.sector_name,
    ROUND(SUM(p.estimated_cost_aed), 2) AS total_real_estate_dev_cost
FROM projects p
JOIN sectors s ON p.sector_id = s.sector_id
WHERE 
    s.sector_name = 'Real Estate'
    AND p.status IN ('Ongoing', 'Announced');
```
#### 11-Which Dubai-based company has the most international subsidiaries?
``` sql
SELECT 
    c.company_name,COUNT(*) AS subsidiary_count
FROM international_operations io
JOIN companies c ON io.company_id = c.company_id
WHERE io.operation_type = 'Subsidiary'
GROUP BY c.company_name
ORDER BY subsidiary_count DESC
LIMIT 1;
```
#### 12-Show countries where multiple Dubai companies have operations (market overlap).
``` sql
SELECT 
    country,COUNT(DISTINCT company_id) AS company_count
FROM international_operations
GROUP BY country
HAVING company_count >= 2
ORDER BY company_count DESC;
```
#### 13-Which company derives the highest percentage of revenue from overseas?
``` sql
SELECT 
    c.company_name,
    ROUND(SUM(io.revenue_contribution), 2) AS overseas_revenue,
    f.revenue_aed AS Total_Revenue,
    ROUND((SUM(io.revenue_contribution) / f.revenue_aed) * 100, 2) AS overseas_revenue_share_percentage
FROM international_operations io
JOIN companies c ON io.company_id = c.company_id
JOIN financials f ON io.company_id = f.company_id
GROUP BY c.company_name, f.revenue_aed
ORDER BY overseas_revenue_share_percentage DESC
LIMIT 1;
```
#### 15-Compare employee counts between government and private entities.
``` sql
SELECT 
    CASE 
        WHEN is_government_owned = TRUE THEN 'Government-Owned'
        ELSE 'Private'
    END AS Company_type,
    COUNT(*) AS num_companies,
    SUM(employee_count) AS total_employees,
    ROUND(AVG(employee_count), 2) AS avg_employees_per_company
FROM companies
GROUP BY Company_type;
```
## Conclusion 

The MD14thJ2_db provides a rich and structured view of Dubai’s dynamic corporate sector. With it, decision-makers and analysts can:

•Assess sector growth trends and economic priorities.

•Evaluate company performance and market reach.

•Understand investment patterns and project execution status.

•Measure global integration and overseas revenue dependencies.


This database is a robust foundation for financial reporting, urban planning, business intelligence, and economic development strategies in the UAE context.

