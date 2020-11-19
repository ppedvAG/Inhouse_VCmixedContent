--WINDOW FUNCTION

--ROw_number

select shipcountry , freight from orders

--> ZEILENNUMMER pro Ergebnis sortiert nach Herkunfstland
select row_number() over (order by Shipcountry), shipcountry, freight from orders	


--> ZEILENNUMMER pro Ergebnis sortiert nach Herkunfstland und Fachtkosten

select row_number() over (order by Shipcountry, freight), shipcountry, freight from orders



--Partition
--> eindeutige ZEILENNUMMER pro Herkunfts sortiert nach Herkunfstland und Frachtkosten

select row_number() over (partition by Shipcountry order by Shipcountry, freight ), 
		shipcountry, freight from orders

--jetzt kann man natürlich aus Summen bilden..Summe der Frachtkosten pro Land addierend 

select sum(freight) over (partition by Shipcountry order by Shipcountry, freight ), 
		shipcountry, freight from orders

--fortlaufende Summe pro Jahr
select sum(freight) over (partition by year(orderdate) order by orderdate ), 
		freight, year(orderdate) from orders



--RANK() vs DENSE_RANK()

select RANK() over(order by freight)
	--, RANK() over (order by shipcountry) 
from orders

--RANK() vergibt mehrfach gleichen Rang.. Sport

select DENSE_RANK() over(order by freight)as RANG1
	, DENSE_RANK() over (order by shipcountry) 
from orders order by RANG1


--NTILE(n) in n Teile

select ntile (4) over (order by freight) , freight from orders

--Kosten in (rel) gleiche Teile und bewertet


select CASE 
			when ntile(3) over (order by freight) = 1 then 'low cost'
			when ntile(3) over (order by freight) = 2 then 'normal'
			else 'extrem' 
		END as Kostentyp,
			freight 
	from orders

	select freight , orderdate from orders order by orderdate

--LAG  LEAD
--LAG Wert davor... 
--LEAD .. Wert danach

select	  lag(freight) over (order by convert(date,orderdate) )
		, lead (freight ) over (order by convert(date,orderdate))
		, convert(date,orderdate), freight
		from orders order by orderdate


--Wert davor und danach .. Entfernung bestimmbar

select	  lag(freight,2) over (order by convert(date,orderdate) )
		, lead (freight,2 ) over (order by convert(date,orderdate))
		, convert(date,orderdate), freight
		from orders order by orderdate

--von jeder Zeile ausgehend: wer war bis dahin der geringste Werte und der höchste
select	  min(freight) over (order by convert(date,orderdate) )
		, max (freight ) over (order by convert(date,orderdate))
		, convert(date,orderdate), freight
		from orders order by orderdate



--Beispiele.. gleitender Durchschnitt der Bestellungen im Laufe der Zeit

select convert(date, orderdate)orderdate, avg(unitprice*quantity) 
		over (	partition by convert(date, orderdate)
				order by od.orderid),unitprice*quantity
from [Order Details] od  inner join Orders o on o.orderid = od.orderid
order by orderdate






Select country, city,
	percent_rank()	over(partition by city order by (unitprice*quantity)),
	cume_dist()		over(partition by city order by (unitprice*quantity))
from customers c 
		inner join orders o on c.CustomerID=o.CustomerID
		inner join [Order Details] od on od.OrderID=o.OrderID
	group by country, city





Select country, city,
sum(unitprice*quantity) as Rsumme into #t1
from customers c 
		inner join orders o on c.CustomerID=o.CustomerID
		inner join [Order Details] od on od.OrderID=o.OrderID
	group by country, city


select country, City, rsumme,
	percent_rank() over (partition by country order by Rsumme),
	Cume_dist() over (partition by country order by Rsumme)
from #t1


CREATE TABLE #TMP1 (ID INT, Col1 CHAR(1), Col2 INT)
GO

INSERT INTO #TMP1 VALUES(1,'A', 1), (2, 'A', 2), (3, 'B', 3), (4, 'C', 4), (5, 'D', 5), (6,'D',6)
GO


SELECT *
  ,SUM(Col2) OVER(ORDER BY Col1 RANGE UNBOUNDED PRECEDING) "Range" 
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS UNBOUNDED PRECEDING) "Rows"   
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between CURRENT ROW and 2 Following )     
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 FOLLOWING and 3 Following )    
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 Preceding    and 2 Following ) 
FROM #TMP1
--Preceding
