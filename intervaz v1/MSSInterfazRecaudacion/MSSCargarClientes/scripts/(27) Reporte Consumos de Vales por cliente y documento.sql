USE [GPCOV]
GO

/****** Object:  StoredProcedure [dbo].[ReporteConsumosValesxClienteDocumento]    Script Date: 09/25/2012 12:51:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteConsumosValesxClienteDocumento]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ReporteConsumosValesxClienteDocumento]
GO

USE [GPCOV]
GO

/****** Object:  StoredProcedure [dbo].[ReporteConsumosValesxClienteDocumento]    Script Date: 09/25/2012 12:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ReporteConsumosValesxClienteDocumento]
	-- Add the parameters for the stored procedure here
	@nroDoc varchar(max),
	@idCliente varchar(max),
	@codestacion varchar(max),
	@fecInicio datetime,
	@fecFin datetime
AS
BEGIN
	
-- =============================================  
-- Author:  Daniel Castillo  
-- Create date: 20/08/2012  
-- Description: Reporte de consumos de  
-- vales por cliente, documento, estacion y rango de fechas  
-- =============================================  
 SET NOCOUNT ON;  
   
   
 DECLARE @docs TABLE(nroDoc varchar(30))  
 DECLARE @codEstaciones TABLE(codEstacion varchar(5))  
 DECLARE @Clientes TABLE(codCliente varchar(30))  
   
 INSERT INTO @docs   
 SELECT value FROM dbo.FN_RPTPTO_SplitData(@nroDoc)  
   
 INSERT INTO @codEstaciones  
 SELECT value FROM dbo.FN_RPTPTO_SplitData(@codestacion)  
   
 INSERT INTO @Clientes  
 SELECT value FROM dbo.FN_RPTPTO_SplitData(@idCliente)  
   
 SELECT   
 ad.numeroFactura  DOCNUMBR,  
 ad.numeroVale VALE,  
 CONVERT(varchar,TRXDATE,103) AS FECHA,  
 convert(numeric(19,2),DEBITAMT) as MONTO,  
 ad.turno  TURNO,  
 ad.estacion  ESTACION,  
 ad.categoria CATEGORIA,  
 RTRIM(s.CUSTNMBR) as CUSTNMBR ,  
 RTRIM(s.CUSTNAME) as CUSTNAME,  
 convert(numeric(19,2),tax.TAXDTSLS) as DOCAMNT,  
 dbo.UFN_TOTAL_FACTURADO_DIVIDIDO_VALES(@codestacion,ad.numeroFactura,@fecInicio,@fecFin) as DOCAMNTDIV,  
 g.JRNENTRY    
 FROM GL20000 as g  
 INNER JOIN COV_ADIC_CONS as ad  
 on g.JRNENTRY = ad.jrnentry
 INNER JOIN t_tributarios_venta as tv
 on tv.LOC_Correlativo =RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1)
 and tv.LOC_NroDeSerie = LEFT(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''),LEN(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''))-1) 
 and LOC_CodigoDocumento ='01'     
 INNER JOIN SOP30200 AS s  
 on tv.LOC_Numero_Documento = s.SOPNUMBE  
 INNER JOIN SOP10105 as tax  
 on s.SOPNUMBE = tax.SOPNUMBE  
 WHERE tax.LNITMSEQ=0  
 AND  
 g.REFRENCE LIKE '%VAL:%'  
 AND CRDTAMNT =0  
 AND ad.numeroFactura in (select nroDoc from @docs)  
 AND ad.estacion in(select codEstacion from @codEstaciones)  
 AND s.CUSTNMBR in (select codCliente from @Clientes)  
 AND TRXDATE BETWEEN @fecInicio AND @fecFin  
   
 UNION  
 
 SELECT   
 ad.numeroFactura  DOCNUMBR,  
 ad.numeroVale VALE,  
 CONVERT(varchar,TRXDATE,103) AS FECHA,  
 convert(numeric(19,2),DEBITAMT) as MONTO,  
 ad.turno  TURNO,  
 ad.estacion  ESTACION,  
 ad.categoria CATEGORIA,  
 RTRIM(s.CUSTNMBR) as CUSTNMBR ,  
 RTRIM(s.CUSTNAME) as CUSTNAME,  
 convert(numeric(19,2),tax.TAXDTSLS) as DOCAMNT,  
 dbo.UFN_TOTAL_FACTURADO_DIVIDIDO_VALES(@codestacion,ad.numeroFactura,@fecInicio,@fecFin) as DOCAMNTDIV,  
 g.JRNENTRY    
 FROM GL10001 as g   
 INNER JOIN GL10000 as h  
 on g.JRNENTRY = h.JRNENTRY  
   
 INNER JOIN COV_ADIC_CONS as ad  
 on g.JRNENTRY = ad.jrnentry   
 INNER JOIN t_tributarios_venta as tv
 on tv.LOC_Correlativo =RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1)
 and tv.LOC_NroDeSerie = LEFT(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''),LEN(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''))-1) 
 and LOC_CodigoDocumento ='01' 
 INNER JOIN SOP30200 AS s  
 on tv.LOC_Numero_Documento = s.SOPNUMBE  
   
 INNER JOIN SOP10105 as tax  
 on s.SOPNUMBE = tax.SOPNUMBE  
 WHERE tax.LNITMSEQ=0  
 AND h.REFRENCE LIKE '%VAL:%'  
 AND CRDTAMNT =0  
 AND ad.numeroFactura in (select nroDoc from @docs)  
 AND ad.estacion in(select codEstacion from @codEstaciones)  
 AND s.CUSTNMBR in (select codCliente from @Clientes)  
 AND TRXDATE BETWEEN @fecInicio AND @fecFin   

END
GO
GRANT EXEC ON ReporteConsumosValesxClienteDocumento TO DYNGRP
GO