USE [GPTST]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ObtenerEstacionesPeajeTodas') AND type in (N'P', N'PC'))
DROP PROC ObtenerEstacionesPeajeTodas
GO
CREATE PROC [dbo].[ObtenerEstacionesPeajeTodas]
AS
BEGIN
-- =============================================
-- Author:		Daniel Castillo
-- Create date: 29/08/2012
-- Description:	Obtiene las estaciones de peaje
-- =============================================
	SELECT '' AS LOCNCODE, '(Todos)' AS LOCNDSCR
	UNION
	SELECT RTRIM(LTRIM(LOCNCODE)) AS LOCNCODE,RTRIM(LTRIM(LOCNDSCR)) AS LOCNDSCR FROM IV40700
	WHERE ADDRESS2='ESTPEA'
END

GO 
GRANT EXEC ON ObtenerEstacionesPeajeTodas TO DYNGRP
GO
