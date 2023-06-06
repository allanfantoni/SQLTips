--------------------------------------------------------------------------------------------------------------------------------------------------------
--https://www.dirceuresende.com/blog/sql-server-como-identificar-e-coletar-informacoes-de-consultas-demoradas-utilizando-extended-events-xe/
--https://www.dirceuresende.com/blog/sql-server-como-identificar-timeout-ou-conexoes-interrompidas-utilizando-extended-events-xe-ou-sql-profiler-trace/
--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Extended events

-- Apaga a sessão, caso ela já exista
IF ((SELECT COUNT(*) FROM sys.server_event_sessions WHERE [name] = 'Monitora Timeouts') > 0) DROP EVENT SESSION [Monitora Timeouts] ON SERVER 
GO
 
CREATE EVENT SESSION [Monitora Timeouts]
ON SERVER
ADD EVENT sqlserver.attention ( 
    ACTION
    (
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.[database_name],
        sqlserver.nt_username,
        sqlserver.num_response_rows,
        sqlserver.server_instance_name,
        sqlserver.server_principal_name,
        sqlserver.server_principal_sid,
        sqlserver.session_id,
        sqlserver.session_nt_username,
        sqlserver.session_server_principal_name,
        sqlserver.sql_text,
        sqlserver.username
    )
)
ADD TARGET package0.event_file ( 
    SET 
        filename = N'D:\SQL\Traces\Monitora_Timeout.xel', -- Não esqueça de mudar o caminho aqui :)
        max_file_size = ( 50 ), -- Tamanho máximo (MB) de cada arquivo
        max_rollover_files = ( 8 ) -- Quantidade de arquivos gerados
)
WITH
(
    STARTUP_STATE = OFF
)
 
-- Ativando a sessão (por padrão, ela é criada desativada)
ALTER EVENT SESSION [Monitora Timeouts] ON SERVER STATE = START
GO

-------------------
-- Another example
-------------------

-- Apaga a sessão, caso ela já exista
IF ((SELECT COUNT(*) FROM sys.server_event_sessions WHERE [name] = 'Query Lenta') > 0) DROP EVENT SESSION [Query Lenta] ON SERVER 
GO

-- Cria o Extended Event no servidor, configurado para iniciar automaticamente quando o serviço do SQL é iniciado
CREATE EVENT SESSION [Query Lenta] ON SERVER 
ADD EVENT sqlserver.sql_batch_completed (
    ACTION (
        sqlserver.session_id,
        sqlserver.client_app_name,
        sqlserver.client_hostname,
        sqlserver.database_name,
        sqlserver.username,
        sqlserver.session_nt_username,
        sqlserver.session_server_principal_name,
        sqlserver.sql_text
    )
    WHERE
        duration > (3000000) -- 3 segundos
)
ADD TARGET package0.event_file (
    SET filename=N'C:\Traces\Query Lenta',
    max_file_size=(10),
    max_rollover_files=(10)
)
WITH (STARTUP_STATE=ON)
GO

-- Ativa o Extended Event
ALTER EVENT SESSION [Query Lenta] ON SERVER STATE = START
GO