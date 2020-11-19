--verteilung der Buffermamanger... siehe SQL Memory Consumption Report
SELECT  OBJECT_NAME
,counter_name
,CONVERT(VARCHAR(10),cntr_value) AS cntr_value
FROM sys.dm_os_performance_counters
WHERE ((OBJECT_NAME LIKE '%Manager%')
AND(counter_name = 'Memory Grants Pending'
OR counter_name='Memory Grants Outstanding'
OR counter_name = 'Page life expectancy'))

--Übersicht der Speicherverteilung der Clerks
DBCC MEMORYSTATUS

--siehe auch hier Clerks
select * from sys. dm_os_memory_clerks


--Verteilung der Clerks in MB 
SELECT TOP(100) [type] AS [ClerkType],
SUM(pages_kb) / 1024 AS [SizeMb]
FROM sys.dm_os_memory_clerks WITH (NOLOCK)
GROUP BY [type]
ORDER BY SUM(pages_kb) DESC



--Verbrauch einer dedizerten Abfrage
-- dbcc checkdb('nwindbig')
SELECT session_id, requested_memory_kb / 1024 as RequestedMemMb, 
granted_memory_kb / 1024 as GrantedMemMb, text
FROM sys.dm_exec_query_memory_grants qmg
CROSS APPLY sys.dm_exec_sql_text(sql_handle)


--Verteilung pro NUMA 
--64=DAC
SELECT DOMC.memory_node_id
    , DOMC.pages_kb
    , DOMC.virtual_memory_reserved_kb
    , DOMC.virtual_memory_committed_kb 
FROM sys.dm_os_memory_clerks DOMC where type = 'MEMORYCLERK_SQLCLR'


--Gesamter Speicherverbrauch
-- SQL Server 2012, 2014, and 2016:
SELECT SUM(domc.pages_kb) AS [TotalPagesKb],
       SUM(domc.virtual_memory_committed_kb) AS [TotalVirtualMemoryKb]
FROM   sys.dm_os_memory_clerks domc
WHERE  domc.[type] LIKE '%CLR%'
AND    domc.[memory_node_id] <> 64;


--Rückgabe aller Datenseiten im Arbeitsspeicher
SELECT TOP 5 DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC OPTION (RECOMPILE);

select * from sys.dm_os_buffer_descriptors
--pro DB Seiten im Cache
SELECT COUNT(*)AS cached_pages_count   
    ,name ,index_id   
FROM sys.dm_os_buffer_descriptors AS bd   
    INNER JOIN   
    (  
        SELECT object_name(object_id) AS name   
            ,index_id ,allocation_unit_id  
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.hobt_id   
                    AND (au.type = 1 OR au.type = 3)  
        UNION ALL  
        SELECT object_name(object_id) AS name     
            ,index_id, allocation_unit_id  
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.partition_id   
                    AND au.type = 2  
    ) AS obj   
        ON bd.allocation_unit_id = obj.allocation_unit_id  
WHERE database_id = DB_ID()  
GROUP BY name, index_id   
ORDER BY cached_pages_count DESC;  




SELECT  
(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
process_physical_memory_low,  
process_virtual_memory_low  
FROM sys.dm_os_process_memory;  