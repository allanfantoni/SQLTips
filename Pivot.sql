-- Pivot

USE [AdventureWorksDW2019]

IF (OBJECT_ID('tempdb..#Teste') is not null) drop table #Teste
SELECT
    YEAR(OrderDate) as Ano,
    MONTH(OrderDate) as Mes,
    OrderQuantity
INTO
    #Teste
FROM
    dbo.FactInternetSales

SELECT
    Ano,
    [1] = SUM(case when Mes = 1 then OrderQuantity end),
    [2] = SUM(case when Mes = 2 then OrderQuantity end),
    [3] = SUM(case when Mes = 3 then OrderQuantity end),
    [4] = SUM(case when Mes = 4 then OrderQuantity end),
    [5] = SUM(case when Mes = 5 then OrderQuantity end),
    [6] = SUM(case when Mes = 6 then OrderQuantity end),
    [7] = SUM(case when Mes = 7 then OrderQuantity end),
    [8] = SUM(case when Mes = 8 then OrderQuantity end),
    [9] = SUM(case when Mes = 9 then OrderQuantity end),
    [10] = SUM(case when Mes = 10 then OrderQuantity end),
    [11] = SUM(case when Mes = 11 then OrderQuantity end),
    [12] = SUM(case when Mes = 12 then OrderQuantity end)
FROM
    #Teste
GROUP BY
    Ano
ORDER BY
    Ano

-- Example of pivot

SELECT
    Ano,
    *
FROM
    #Teste PIVOT(sum(OrderQuantity) for Mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) p
ORDER BY
    1;