set statistics io , time on

dbcc freeproccache
 ALTER DATABASE  SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE 

declare @sqltext as nvarchar(4000)
declare @Oid as varchar(5)=10250

--SQLInjection
set @sqltext = 'select * from orders where Orderid= '
exec (@sqltext+ @oid)



--weitere Beispiel

DECLARE @SQL nvarchar(1000)
 
declare @Pid varchar(50)
set @pid = '11'
 
 
SET @SQL = 'SELECT ProductID,productname, Unitprice FROM products where ProductID = '+ @Pid
EXEC (@SQL)

--wieviele Pläne bei PrID 11 und 10 


select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'
		and dbid=db_id()



--besser 

--sp_executesql

dbcc freeproccache


DECLARE @sqlCommand nvarchar(1000)
DECLARE @columnList varchar(75)
DECLARE @orderid int

SET @columnList = 'orderid, freight, customerid'
SET @orderid = 10250
SET @sqlCommand = 'SELECT ' + @columnList + ' FROM dbo.orders WHERE Orderid = @oid'

EXECUTE sp_executesql @sqlCommand, N'@oid int', @oid = @orderid







select usecounts, cacheobjtype,[TEXT],* from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'
		and dbid = db_id()


--wie läßt sich das Problem umgehen neue Pläne zu erstellen: --> Prozeduren


---Thema temp tabelle

exec sp_executesql	
	N'select orderid, freight into #t1 from orders where orderid = @oid',
	N'@oid int',@oid=10259

select * from #t1 --uffff
--so gehts wieder

create table #temp1 (orderid int, freight money)
exec sp_executesql	
	N'insert into #temp1
		select orderid, freight from orders where orderid = @oid',
	N'@oid int',
	@oid=10259
	select * from #temp1



exec sp_executesql	
	N'sp_excutesql ''sp_executesql ''



