CREATE DATABASE MD14thJ2_db;
USE MD14thJ2_db;

CREATE TABLE sectors (
	sector_id            INT PRIMARY KEY AUTO_INCREMENT,
	sector_name          TEXT,
	contribution_to_gdp  DECIMAL (10,2),
	growth_rate          DECIMAL (10,2)
);

SELECT * FROM sectors ;

INSERT INTO sectors (sector_name, contribution_to_gdp, growth_rate) VALUES
	('Oil & Gas', 28.5, 3.2),
	('Aviation', 12.7, 8.4),
	('Real Estate', 15.3, 5.1),
	('Banking & Finance', 18.2, 6.8),
	('Tourism & Hospitality', 9.8, 10.5),
	('Retail', 7.5, 4.3),
	('Logistics', 5.2, 7.9),
	('Technology', 3.8, 15.2);
	
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

INSERT INTO companies (company_name, founded_year, sector_id, headquarters, ceo, employee_count, is_government_owned, is_publicly_traded, stock_symbol) VALUES
	('Emirates Group', 1985, 2, 'Garhoud', 'Ahmed bin Saeed Al Maktoum', 102000, TRUE, FALSE, NULL),
	('DP World', 2005, 7, 'Jebel Ali', 'Sultan Ahmed bin Sulayem', 108000, TRUE, TRUE, 'DPW'),
	('Emaar Properties', 1997, 3, 'Downtown Dubai', 'Mohamed Alabbar', 11000, FALSE, TRUE, 'EMAAR'),
	('Emirates NBD', 2007, 4, 'Burj Khalifa District', 'Shayne Nelson', 28000, TRUE, TRUE, 'EMIRATESNBD'),
	('Dubai Islamic Bank', 1975, 4, 'Dubai', 'Adnan Chilwan', 5000, FALSE, TRUE, 'DIB'),
	('Nakheel', 2000, 3, 'Dubai', 'Naaman Atallah', 8000, TRUE, FALSE, NULL),
	('Dubai Holding', 2004, 3, 'Dubai', 'Amit Kaushal', 22000, TRUE, FALSE, NULL),
	('Meraas', 2007, 3, 'Dubai', 'Abdulla Al Habbai', 9000, TRUE, FALSE, NULL),
	('Majid Al Futtaim', 1992, 6, 'City Centre Deira', 'Alain Bejjani', 43000, FALSE, FALSE, NULL),
	('Dubai Airports', 2007, 2, 'Dubai International Airport', 'Paul Griffiths', 40000, TRUE, FALSE, NULL);

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

INSERT INTO financials (company_id, year, revenue_aed, profit_aed, assets_aed, market_cap_aed) VALUES
	(1, 2023, 137500.00, 8900.00, 452800.00, NULL),
	(2, 2023, 35800.00, 7200.00, 187500.00, 105000.00),
	(3, 2023, 27500.00, 6800.00, 154000.00, 85000.00),
	(4, 2023, 42200.00, 12500.00, 742000.00, 92000.00),
	(5, 2023, 18700.00, 5800.00, 285000.00, 45000.00),
	(6, 2023, 9800.00, 3200.00, 87500.00, NULL),
	(7, 2023, 15200.00, 4100.00, 112000.00, NULL),
	(8, 2023, 8700.00, 2100.00, 68000.00, NULL),
	(9, 2023, 36400.00, 3800.00, 125000.00, NULL),
	(10, 2023, 12800.00, 2900.00, 98000.00, NULL);

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

INSERT INTO projects (company_id, project_name, start_date, completion_date, estimated_cost_aed, sector_id, status) VALUES
	(3, 'Dubai Creek Harbour', '2016-01-01', NULL, 75000.00, 3, 'Ongoing'),
	(6, 'Palm Jebel Ali', '2023-01-01', NULL, 35000.00, 3, 'Announced'),
	(1, 'Emirates Fleet Expansion', '2022-01-01', NULL, 45000.00, 2, 'Ongoing'),
	(2, 'Jebel Ali Port Expansion', '2021-01-01', '2025-12-31', 18000.00, 7, 'Ongoing'),
	(4, 'Digital Banking Platform', '2022-06-01', '2023-12-15', 1200.00, 4, 'Completed'),
	(7, 'Dubai Urban Tech District', '2023-01-01', NULL, 8000.00, 8, 'Ongoing'),
	(9, 'City Centre Al Zahia', '2020-01-01', '2023-03-15', 3200.00, 6, 'Completed');

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

INSERT INTO international_operations (company_id, country, entry_year, operation_type, revenue_contribution) VALUES
	(1, 'United Kingdom', 1987, 'Subsidiary', 18.5),
	(1, 'Australia', 1996, 'Subsidiary', 8.2),
	(2, 'United Kingdom', 2006, 'Joint Venture', 12.8),
	(2, 'India', 2013, 'Subsidiary', 15.4),
	(3, 'Egypt', 2005, 'Subsidiary', 9.7),
	(3, 'Turkey', 2012, 'Joint Venture', 6.3),
	(4, 'Saudi Arabia', 2015, 'Subsidiary', 11.2),
	(9, 'Oman', 2001, 'Subsidiary', 8.9),
	(9, 'Kuwait', 2008, 'Joint Venture', 6.5);

-- 1-Which Dubai company had the highest revenue in 2023, and what was its profit margin?
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

-- 2-Compare the average revenue growth of government-owned vs private companies.
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

-- 3-List companies with profit margins above 20% in 2023.
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

-- 4-What is the total market capitalization of all publicly traded Dubai companies?
SELECT 
	SUM(market_cap_aed) AS Total_Market_Capitalization
FROM financials f
JOIN companies c ON c.company_id=f.company_id
WHERE c.is_publicly_traded=TRUE;
    
-- 5-Which economic sector contributes most to Dubai's GDP and why?
SELECT 
	sector_name,contribution_to_gdp,growth_rate
FROM sectors 
ORDER BY contribution_to_gdp DESC 
LIMIT 1;

-- 6-Show the revenue distribution across sectors (pie chart suitable).
SELECT 
	s.sector_name,SUM(f.revenue_aed) AS Total_Revenue
FROM sectors s 
JOIN companies c ON c.sector_id=s.sector_id
JOIN financials f ON f.company_id=c.company_id
GROUP BY s.sector_name;

-- 7-Which sector has the highest growth rate but lowest current GDP contribution?
SELECT 
	sector_name,contribution_to_gdp,growth_rate
FROM sectors 
ORDER BY 
	contribution_to_gdp ASC,
    growth_rate DESC
LIMIT 1;

-- 8-List all ongoing mega-projects with budgets exceeding AED 10 billion.
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

-- 9-Which company has the most delayed projects, and what's the average delay duration?
SELECT 
    c.company_name,
    COUNT(*) AS delayed_projects,
    ROUND(AVG(DATEDIFF(CURDATE(), p.completion_date)), 2) AS avg_days_delayed
FROM projects p
JOIN companies c ON c.company_id = p.company_id
WHERE 
	p.status !='Completed'
    AND p.completion_date < CURDATE()
GROUP BY c.company_name
ORDER BY delayed_projects DESC;

-- 10-Calculate the total estimated cost of all real estate projects under development.
SELECT 
    s.sector_name,
    ROUND(SUM(p.estimated_cost_aed), 2) AS total_real_estate_dev_cost
FROM projects p
JOIN sectors s ON p.sector_id = s.sector_id
WHERE 
    s.sector_name = 'Real Estate'
    AND p.status IN ('Ongoing', 'Announced');
    
-- 11-Which Dubai-based company has the most international subsidiaries?
SELECT 
    c.company_name,COUNT(*) AS subsidiary_count
FROM international_operations io
JOIN companies c ON io.company_id = c.company_id
WHERE io.operation_type = 'Subsidiary'
GROUP BY c.company_name
ORDER BY subsidiary_count DESC
LIMIT 1;

-- 12-Show countries where multiple Dubai companies have operations (market overlap).
SELECT 
    country,COUNT(DISTINCT company_id) AS company_count
FROM international_operations
GROUP BY country
HAVING company_count >= 2
ORDER BY company_count DESC;
    
-- 13-Which company derives the highest percentage of revenue from overseas?
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

-- 15-Compare employee counts between government and private entities.
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