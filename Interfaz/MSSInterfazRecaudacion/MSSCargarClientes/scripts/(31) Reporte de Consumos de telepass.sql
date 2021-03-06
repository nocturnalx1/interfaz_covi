USE [GPTST]
GO

/****** Object:  StoredProcedure [dbo].[ReporteConsumosTelepassxClienteDocumento]    Script Date: 10/15/2012 16:40:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteConsumosTelepassxClienteDocumento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ReporteConsumosTelepassxClienteDocumento]
GO

CREATE PROCEDURE [dbo].[ReporteConsumosTelepassxClienteDocumento]
	-- Add the parameters for the stored procedure here
	@fecInicio datetime,
	@fecFin datetime,
    @codestacion varchar(max),
	@idCliente varchar(max),
	@nroDoc varchar(max)
AS
BEGIN
-- =============================================
-- Author:		Daniel Castillo
-- Create date: 29/08/2012
-- Description:	REPORTE DE CONSUMOS DE TELEPASS POR
-- RANGO DE FECHAS, ESTACION, CLIENTE Y NRO DE DOCUMENTO
-- =============================================
	SET NOCOUNT ON;
	-- crear tabla de documentos del cliente
	DECLARE @docs TABLE(nroDoc varchar(30))
	DECLARE @codEstaciones TABLE(codEstacion varchar(5))
	DECLARE @Clientes TABLE(codCliente varchar(30))
	
	INSERT INTO @docs 
	SELECT value FROM dbo.FN_RPTPTO_SplitData(@nroDoc)
	
	INSERT INTO @codEstaciones
	SELECT value FROM dbo.FN_RPTPTO_SplitData(@codestacion)
	
	INSERT INTO @Clientes
	SELECT value FROM dbo.FN_RPTPTO_SplitData(@idCliente)
	
	
		SELECT g.JRNENTRY,
		ad.numeroFactura AS DOCNUMBR,
		ad.numeroVale  TAG,
		ad.placa PLACA,
		CONVERT(varchar,TRXDATE,103) AS TRXDATE,
		CONVERT(NUMERIC(19,2),DEBITAMT) AS MONTO,
		ad.turno AS TURNO,
		ad.estacion AS ESTACION,
		ad.categoria CATEGORIA,
		s.CUSTNMBR,
		s.CUSTNAME,
		convert(numeric(19,2),tax.TAXDTSLS) as DOCAMNT,
	    dbo.UFN_TOTAL_FACTURADO_DIVIDIDO_TELEPASS(@codestacion,s.SOPNUMBE,@fecInicio,@fecFin) as DOCAMNTDIV		
		FROM GL20000 as g
		
		INNER JOIN COV_ADIC_CONS as ad
		on g.JRNENTRY = ad.jrnentry	
		INNER JOIN SOP30200 AS s
		on ad.numeroFactura = s.SOPNUMBE		
		
		INNER JOIN SOP10105 as tax
		on s.SOPNUMBE = tax.SOPNUMBE
		WHERE tax.LNITMSEQ=0
		AND g.REFRENCE LIKE '%TEL:%'
		AND CRDTAMNT =0
		AND ad.numeroFactura in (select nroDoc from @docs)
		AND ad.estacion in (select codEstacion from @codEstaciones)
		AND TRXDATE BETWEEN @fecInicio AND @fecFin
		
		UNION
		-- temporal
		
		SELECT g.JRNENTRY,
		ad.numeroFactura AS DOCNUMBR,
		ad.numeroVale  TAG,
		ad.placa PLACA,
		CONVERT(varchar,TRXDATE,103) AS TRXDATE,
		CONVERT(NUMERIC(19,2),DEBITAMT) AS MONTO,
		ad.turno AS TURNO,
		ad.estacion AS ESTACION,
		ad.categoria CATEGORIA,
		s.CUSTNMBR,
		s.CUSTNAME,
		convert(numeric(19,2),tax.TAXDTSLS) as DOCAMNT,
	    dbo.UFN_TOTAL_FACTURADO_DIVIDIDO_TELEPASS(@codestacion,s.SOPNUMBE,@fecInicio,@fecFin) as DOCAMNTDIV		
		FROM GL10001 as g INNER JOIN GL10000 as h
		on g.JRNENTRY = h.JRNENTRY
		
		INNER JOIN COV_ADIC_CONS as ad
		on g.JRNENTRY = ad.jrnentry	
		INNER JOIN SOP30200 AS s
		on ad.numeroFactura = s.SOPNUMBE		
			
		
		INNER JOIN SOP10105 as tax
		on s.SOPNUMBE = tax.SOPNUMBE
		WHERE tax.LNITMSEQ=0
		AND h.REFRENCE LIKE '%TEL:%'
		AND CRDTAMNT =0
		AND ad.numeroFactura in (select nroDoc from @docs)
		AND ad.estacion in (select codEstacion from @codEstaciones)
		AND TRXDATE BETWEEN @fecInicio AND @fecFin
END

GO
GRANT EXEC ON ReporteConsumosTelepassxClienteDocumento TO DYNGRP
GO
