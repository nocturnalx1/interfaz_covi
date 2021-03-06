USE [REPCOVI]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'obtenerRepCliente') AND type in (N'P', N'PC'))
DROP PROC obtenerRepCliente
GO

CREATE PROC obtenerRepCliente

	@idCliente varchar(20)
AS
BEGIN

-- =============================================
-- Author:		Daniel Castillo
-- Create date: 13/08/2012
-- Description:	obtiene el cliente por codigo
-- =============================================

	SELECT * FROM REPCLIENTE
	WHERE idcliente = @idCliente;
	
END
