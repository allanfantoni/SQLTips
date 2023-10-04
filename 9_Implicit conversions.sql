-- Searching for implicit conversions

SELECT TOP (100)
    DB_NAME(b.[dbid]) AS [Database],
    b.[text] AS [Consulta],
    a.total_worker_time AS [Total Worker Time],
    a.total_worker_time / a.execution_count AS [Avg Worker Time],
    a.max_worker_time AS [Max Worker Time],
    a.total_elapsed_time / a.execution_count AS [Avg Elapsed Time],
    a.max_elapsed_time AS [Max Elapsed Time],
    a.total_logical_reads / a.execution_count AS [Avg Logical Reads],
    a.max_logical_reads AS [Max Logical Reads],
    a.execution_count AS [Execution Count],
    a.creation_time AS [Creation Time],
    c.query_plan AS [Query Plan]
FROM
    sys.dm_exec_query_stats AS a WITH (nolock)
    CROSS APPLY sys.dm_exec_sql_text(a.plan_handle) AS b
    CROSS APPLY sys.dm_exec_query_plan(a.plan_handle) AS c
WHERE
    CAST(c.query_plan AS nvarchar(MAX)) LIKE ('%CONVERT_IMPLICIT%')
    AND b.[dbid] = DB_ID()
    AND b.[text] NOT LIKE '%sys.dm_exec_sql_text%' -- Não pegar a própria consulta
ORDER BY
    a.total_worker_time DESC