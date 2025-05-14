-- E-commerce Sales Analysis using SQL Server
-- Dataset: Online Retail Transactions

-- ========================================
-- SECTION 1: Total Revenue
-- ========================================
SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue 
FROM 
    ecommerce.data;

-- ========================================
-- SECTION 2: Orders per Country
-- ========================================
SELECT
    Country,
    SUM(Quantity) AS TotalOrders
FROM
    ecommerce.data
GROUP BY
    Country
ORDER BY 
    TotalOrders DESC;

-- ========================================
-- SECTION 3: Revenue by Country
-- ========================================
SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue 
FROM 
    ecommerce.data 
GROUP BY Country;

-- ========================================
-- SECTION 4: Top 10 Selling Products by Quantity
-- ========================================
SELECT
    Description,
    SUM(Quantity) AS TotalSold
FROM
    ecommerce.data
GROUP BY
    Description
ORDER BY
    TotalSold DESC
LIMIT 10;

-- ========================================
-- SECTION 5: Top 10 Products by Revenue
-- ========================================
SELECT
    Description,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM
    ecommerce.data
GROUP BY
    Description
ORDER BY 
    TotalRevenue DESC
LIMIT 10;

-- ========================================
-- SECTION 6: Monthly Sales Trend
-- ========================================
SELECT 
    DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') AS Month,
    SUM(Quantity * UnitPrice) AS MonthlyRevenue
FROM 
    ecommerce.data
GROUP BY 
    Month
ORDER BY 
    Month;

-- ========================================
-- SECTION 7: Customer Purchase Frequency
-- ========================================
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS NumberOfPurchase,
    SUM(Quantity * UnitPrice) AS TotalSpent
FROM
    ecommerce.data
WHERE
    CustomerID IS NOT NULL
GROUP BY
    CustomerID
ORDER BY
    TotalSpent DESC;

-- ========================================
-- SECTION 8: Average Basket Size (Invoice-level Item Count and Value)
-- ========================================
SELECT
    InvoiceNo,
    SUM(Quantity) AS TotalItems,
    SUM(Quantity * UnitPrice) AS InvoiceValue
FROM 
    ecommerce.data
GROUP BY
    InvoiceNo;

-- ========================================
-- SECTION 9: Average Order Value (AOV)
-- ========================================
SELECT
    AVG(InvoiceTotal) AS AverageOrderValue
FROM (
    SELECT
        InvoiceNo,
        SUM(Quantity * UnitPrice) AS InvoiceTotal
    FROM
        ecommerce.data
    GROUP BY 
        InvoiceNo
) AS InvoiceSummary;

-- ========================================
-- SECTION 10: Most Frequent Customers (Top 20)
-- ========================================
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM
    ecommerce.data
WHERE 
    CustomerID IS NOT NULL
GROUP BY
    CustomerID
ORDER BY 
    PurchaseCount DESC 
LIMIT 20;

-- ========================================
-- SECTION 11: Customer Type Classification (One-time vs Repeat)
-- ========================================
SELECT
    CASE
        WHEN PurchaseCount = 1 THEN 'OneTime'
        ELSE 'Repeat'
    END AS CustomerType,
    COUNT(*) AS CustomerCount
FROM (
    SELECT 
        CustomerID, 
        COUNT(DISTINCT InvoiceNo) AS PurchaseCount
    FROM
        ecommerce.data
    WHERE
        CustomerID IS NOT NULL
    GROUP BY
        CustomerID
) AS Customer_summary
GROUP BY
    CustomerType;
