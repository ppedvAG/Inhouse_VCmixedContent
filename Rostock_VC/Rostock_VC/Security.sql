--MAX sichert DB


USE [NwindBig]
GO
CREATE USER [MAX] FOR LOGIN [MAX]
GO
USE [NwindBig]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [MAX]
GO



backup database northwind to disk='c:\_SQLBACKUPS\nwind.bak'



SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name; 



/**********************************************************************************
LIST ALL DIRECT SERVER PERMISSIONS TO ANY ACCOUNT EXCEPT
SYSTEM ADMINISTRATOR accounts. DO NOT LIST ROLES.
***********************************************************************************/
DECLARE @admin_Account_name sysname
SET @admin_Account_name = 'NO administrator account found'
DECLARE @server_name sysname
SET @server_name = 'NO Server found'

SELECT @server_name = name FROM sys.servers
WHERE server_id = 0
SET @admin_Account_name = @server_name + '\Administrator'

SELECT pe.grantee_principal_id
, pr.type AS 'Grantee_Type'
, pr.name AS 'Grantee_Name'
, pe.type
, pe.permission_name
, pe.state
, pe.state_desc
FROM sys.server_permissions pe
JOIN sys.server_principals pr
ON pe.grantee_principal_id = pr.principal_id
JOIN sys.server_principals ps
ON pe.grantor_principal_id = ps.principal_id
LEFT JOIN sys.server_principals us
ON us.principal_id = pe.major_id
WHERE pr.type IN ('K', 'S', 'U')
AND pe.grantee_principal_id > 10
AND NOT pr.name IN ('##MS_PolicyEventProcessingLogin##', '##MS_PolicyTsqlExecutionLogin##',
'NT AUTHORITY\NETWORK SERVICE', 'NT AUTHORITY\SYSTEM', 'NT SERVICE\MSSQLSERVER',
'NT SERVICE\SQLSERVERAGENT', 'NT SERVICE\SQLWriter', 'NT SERVICE\Winmgmt')
AND NOT pr.name = @admin_Account_name
ORDER BY CASE pr.type
WHEN 'K' THEN 1
WHEN 'S' THEN 2
WHEN 'U' THEN 3
ELSE 4
END


SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name; 

/**********************************************************************************
LIST ALL INDIRECT (via ROLES) ACCESS TO THE SERVER PERMISSION.
***********************************************************************************/
DECLARE @admin_Account_name sysname
SET @admin_Account_name = 'NO admin ACCOUNT found'
DECLARE @server_name sysname
SET @server_name = 'NO Server found'

SELECT @server_name = name FROM sys.servers
WHERE server_id = 0
SET @admin_Account_name = @server_name + '\Administrator'

SELECT pe.grantee_principal_id
, pr.type AS 'Grantee_Type'
, pr.name AS 'Grantee_Name'
, pe.type
, pe.permission_name
, pe.state
, pe.state_desc
FROM sys.server_permissions pe
JOIN sys.server_principals pr
ON pe.grantee_principal_id = pr.principal_id
JOIN sys.server_principals ps
ON pe.grantor_principal_id = ps.principal_id
LEFT JOIN sys.server_principals us
ON us.principal_id = pe.major_id
WHERE pr.type IN ('R')
AND pe.grantee_principal_id > 10
AND NOT pr.name IN ('##MS_PolicyEventProcessingLogin##', '##MS_PolicyTsqlExecutionLogin##',
'NT AUTHORITY\NETWORK SERVICE', 'NT AUTHORITY\SYSTEM', 'NT SERVICE\MSSQLSERVER',
'NT SERVICE\SQLSERVERAGENT', 'NT SERVICE\SQLWriter', 'NT SERVICE\Winmgmt')
AND NOT pr.name = @admin_Account_name
ORDER BY CASE pe.state
WHEN 'D' THEN 1
WHEN 'W' THEN 2
WHEN 'G' THEN 3
ELSE 4
END


SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name; 


--Besitz übertragen
ALTER AUTHORIZATION ON OBJECT::dbo.KD_View1 TO SUSI;

ALTER AUTHORIZATION ON OBJECT::dbo.KD_View1 TO SCHEMA OWNER;
  GO


--Anwendungsrolle
USE [Northwind]
GO

CREATE APPLICATION ROLE [GRolle]
WITH DEFAULT_SCHEMA = [dbo], 'ppedv20xyz123!'


use master

use northwind

sp_setapprole 'Grolle', 'ppedv2019!'

use master


