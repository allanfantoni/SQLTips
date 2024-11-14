-------------------------------------
-- Criar tabela de exemplo _Clientes
-------------------------------------

DROP TABLE IF EXISTS _Clientes

CREATE TABLE _Clientes (
    Id_Cliente INT IDENTITY(1,1),
    Dados_Serializados VARCHAR(25)
)

INSERT INTO _Clientes ( Dados_Serializados )
SELECT
    CONVERT(VARCHAR(19), DATEADD(SECOND, (ABS(CHECKSUM(PWDENCRYPT(N''))) / 2147483647.0) * 199999999, '2015-01-01'), 121) + '|' +
    CONVERT(VARCHAR(20), CONVERT(INT, (ABS(CHECKSUM(PWDENCRYPT(N''))) / 2147483647.0) * 9)) + '|' +
    CONVERT(VARCHAR(20), CONVERT(INT, (ABS(CHECKSUM(PWDENCRYPT(N''))) / 2147483647.0) * 10)) + '|' +
    CONVERT(VARCHAR(20), CONVERT(INT, 0.459485495 * (ABS(CHECKSUM(PWDENCRYPT(N''))) / 2147483647.0)) * 1999)
GO 10000

INSERT INTO _Clientes ( Dados_Serializados )
SELECT Dados_Serializados
FROM _Clientes
GO 9

CREATE CLUSTERED INDEX SK01_Pedidos ON _Clientes(Id_Cliente)
CREATE NONCLUSTERED INDEX SK02_Pedidos ON _Clientes(Dados_Serializados)
GO

-------------------------------------------------------------------
-- Nunca usar funções, mesmo aquelas nativas como SUBSTRING e LEFT
-------------------------------------------------------------------

SET STATISTICS TIME, IO ON
SET STATISTICS PROFILE OFF

SELECT *
FROM _Clientes
WHERE Dados_Serializados = '2016-11-22 04:49:06|2|0|0'

SELECT * 
FROM _Clientes
WHERE SUBSTRING(Dados_Serializados, 1, 10) = '2016-11-22'

--(2048 rows affected)
--Table '_Clientes'. Scan count 1, logical reads 24876, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 656 ms,  elapsed time = 717 ms.

SELECT * 
FROM _Clientes
WHERE LEFT(Dados_Serializados, 10) = '2016-11-22'

--(2048 rows affected)
--Table '_Clientes'. Scan count 1, logical reads 24876, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 640 ms,  elapsed time = 714 ms.

-----------------
-- Solução: LIKE
-----------------

SELECT * 
FROM _Clientes
WHERE Dados_Serializados LIKE '2016-11-22%'

--(2048 rows affected)
--Table '_Clientes'. Scan count 1, logical reads 14, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 76 ms.

-----------------------
-- E no caso de RIGHT? 
-----------------------

SELECT * 
FROM _Clientes
WHERE Dados_Serializados LIKE '%1|4|0'

--(56832 rows affected)
--Table '_Clientes'. Scan count 1, logical reads 24876, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 6578 ms,  elapsed time = 7646 ms.

SELECT * 
FROM _Clientes
WHERE REVERSE(Dados_Serializados) LIKE REVERSE('1|4|0') + '%'

--(56832 rows affected)
--Table '_Clientes'. Scan count 1, logical reads 24876, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 703 ms,  elapsed time = 1465 ms.

-----------
-- Solução
-----------

-- Cria a nova coluna calculada
ALTER TABLE _Clientes ADD Right_5 AS (RIGHT(Dados_Serializados, 5))
GO

-- Cria um índice para a nova coluna criada
CREATE NONCLUSTERED INDEX SK03_Clientes ON _Clientes(Right_5)
GO

-- Executa a consulta nova
SELECT Right_5
FROM _Clientes
WHERE Right_5 = '1|4|0'

--(56832 rows affected)
--Table '_Clientes'. Scan count 1, logical reads 139, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 202 ms.