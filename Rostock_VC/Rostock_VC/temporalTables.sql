CREATE TABLE dbo.Employee
(
  [EmployeeID] int NOT NULL PRIMARY KEY CLUSTERED
  , [Name] nvarchar(100) NOT NULL
  , [Position] varchar(100) NOT NULL
  , [Department] varchar(100) NOT NULL
  , [Address] nvarchar(1024) NOT NULL
  , [AnnualSalary] decimal (10,2) NOT NULL
  , [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START
  , [ValidTo] datetime2 GENERATED ALWAYS AS ROW END
  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));

select * from [dbo].[EmployeeHistory]

SELECT * FROM Employee
  FOR SYSTEM_TIME
    BETWEEN '2020-11-17 14:54:00.0000000' AND '2020-11-18 14:57:00.0000000'
  --    WHERE EmployeeID = 1000 ORDER BY ValidFrom;

  select @@MAX_CONNECTIONS