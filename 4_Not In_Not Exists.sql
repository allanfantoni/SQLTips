USE [AdventureWorksDW2019]
GO

IF (OBJECT_ID('tempdb..#Teste') IS NOT NULL) DROP TABLE #Teste
CREATE TABLE #Teste (
    Pedido VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AI
)

INSERT INTO #Teste VALUES('SO43697'), ('SO43687'), (NULL)

SELECT *
FROM dbo.FactInternetSales
WHERE SalesOrderNumber NOT IN (
    SELECT Pedido COLLATE SQL_Latin1_General_CP1_CI_AI
    FROM #Teste
)

SELECT *
FROM dbo.FactInternetSales A
WHERE NOT EXISTS (
    SELECT Pedido COLLATE SQL_Latin1_General_CP1_CI_AI
    FROM #Teste
    WHERE Pedido = A.SalesOrderNumber COLLATE SQL_Latin1_General_CP1_CI_AI
)