USE [AllanFantoni]
GO

CREATE OR ALTER PROCEDURE dbo.stpConsulta_Tabela (
    @nome VARCHAR(128)
)
AS
BEGIN

    DECLARE @Query VARCHAR(MAX) = 'SELECT * FROM sys.all_objects WHERE name = ''' + @nome + ''''

    PRINT(@Query)
    EXEC(@Query)

END
GO

--

EXEC dbo.stpConsulta_Tabela @nome = 'objects'
EXEC dbo.stpConsulta_Tabela @nome = 'tables'

-- SQL Injection example

EXEC stpConsulta_Tabela @nome = '''; SELECT * FROM sys.databases; SELECT * FROM sys.database_principals; SELECT * FROM sys.tables;--'

-- 

USE [AllanFantoni]
GO

CREATE OR ALTER PROCEDURE dbo.stpConsulta_Tabela_V2 (
    @nome VARCHAR(128)
)
AS
BEGIN

    DECLARE @Query NVARCHAR(MAX) = 'SELECT * FROM sys.all_objects WHERE name = @nome' -- remember, must be a nvarchar variable

    EXEC sys.sp_executesql
        @stmt = @Query,
        @params = N'@nome VARCHAR(128)',
        @nome = @nome

END
GO

--

EXEC dbo.stpConsulta_Tabela_V2 @nome = 'objects'
EXEC dbo.stpConsulta_Tabela_V2 @nome = 'tables'

-- SQL Injection example

EXEC stpConsulta_Tabela_V2 @nome = '''; SELECT * FROM sys.databases; SELECT * FROM sys.database_principals; SELECT * FROM sys.tables;--'
