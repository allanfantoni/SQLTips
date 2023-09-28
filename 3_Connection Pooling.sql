-- Connection Pooling

select login_name, count(*)
from sys.dm_exec_sessions
group by login_name

select @@CONNECTIONS

select b.login_name, b.host_name, b.program_name, db_name(b.database_id), count(*)
from sys.dm_exec_connections a
left join sys.dm_exec_sessions b on a.session_id = b.session_id
group by b.login_name, b.host_name, b.program_name, db_name(b.database_id)

select *
from sys.dm_os_performance_counters a
where a.counter_name = 'User Connections'
