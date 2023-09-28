USE [AdventureWorksDW2019]
GO

SELECT A.ProductKey, A.OrderDateKey, A.SalesOrderNumber, A.OrderQuantity, A.SalesAmount, A.ExtendedAmount, A.UnitPrice, A.UnitPriceDiscountPct, A.RevisionNumber
FROM dbo.FactInternetSales A
JOIN dbo.DimDate B
	ON B.DateKey = A.DueDateKey
JOIN dbo.DimCustomer C
	ON C.CustomerKey = A.CustomerKey
JOIN (SELECT MAX(DateKey) AS MaxDate FROM dbo.DimDate JOIN dbo.FactInternetSales
	ON FactInternetSales.OrderDateKey = DimDate.DateKey
	WHERE FullDateAlternateKey >= '2010-01-01'
	AND FullDateAlternateKey < '2020-01-01'
	AND FiscalYear < 2020
	) D
	ON B.DateKey = D.MaxDate
JOIN dbo.DimProduct E
	ON E.ProductKey = A.ProductKey
LEFT JOIN dbo.DimProductSubcategory F
	ON E.ProductSubcategoryKey = F.ProductSubcategoryKey

--

IF (OBJECT_ID('tempdb..#Maior_Data') IS NOT NULL) DROP TABLE #Maior_Data
SELECT
    MAX(DateKey) as MaxDate
INTO
    #Maior_Data
FROM
    dbo.DimDate A
    JOIN dbo.FactInternetSales B ON B.OrderDateKey = A.DateKey
WHERE
    FullDateAlternateKey >= '2010-01-01'
	AND FullDateAlternateKey < '2020-01-01'
	AND FiscalYear < 2020

SELECT 
    A.ProductKey, 
    A.OrderDateKey, 
    A.SalesOrderNumber, 
    A.OrderQuantity, 
    A.SalesAmount, 
    A.ExtendedAmount, 
    A.UnitPrice, 
    A.UnitPriceDiscountPct, 
    A.RevisionNumber
FROM
    dbo.FactInternetSales A
    JOIN dbo.DimDate B ON B.DateKey = A.DueDateKey
    JOIN dbo.DimCustomer C ON C.CustomerKey = A.CustomerKey
    JOIN #Maior_Data D ON B.DateKey = D.MaxDate
    JOIN dbo.DimProduct E ON E.ProductKey = A.ProductKey
    LEFT JOIN dbo.DimProductSubcategory F ON E.ProductSubcategoryKey = F.ProductSubcategoryKey;
