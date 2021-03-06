/****** Object:  StoredProcedure [dbo].[ReporteConsumosValesObtenerDocumentos]    Script Date: 09/24/2012 12:34:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteConsumosValesObtenerDocumentos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ReporteConsumosValesObtenerDocumentos]
GO

CREATE PROCEDURE [dbo].[ReporteConsumosValesObtenerDocumentos]
	-- Add the parameters for the stored procedure here
	@fecInicio datetime,
	@fecFin datetime,
	@codestacion varchar(max),
	@idCliente varchar(max)
AS
BEGIN

-- =============================================  
-- Author:  Daniel Castillo  
-- Create date: 29/08/2012  
-- Description: Permite obtener los documentos de origen de vales  
-- que se encuentren en un rango de fechas, pertenezcan a una estacion y cliente  
-- =============================================  
 SET NOCOUNT ON;  
 -- crear tabla de documentos del cliente  
 DECLARE @codEstaciones TABLE(codEstacion varchar(5))  
 DECLARE @Clientes TABLE(codCliente varchar(30))  
   
 INSERT INTO @codEstaciones  
 SELECT value FROM dbo.FN_RPTPTO_SplitData(@codestacion)  
   
 INSERT INTO @Clientes  
 SELECT value FROM dbo.FN_RPTPTO_SplitData(@idCliente)  
   
   
 SELECT   
 DISTINCT RTRIM(ad.numeroFactura) as CLAVE, ad.numeroFactura as SOPNUMBE   
 FROM GL20000 as g  
   
 INNER JOIN COV_ADIC_CONS as ad  
 on g.JRNENTRY = ad.jrnentry   
 
 INNER JOIN t_tributarios_venta as tv
 on tv.LOC_Correlativo =RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1)
 and tv.LOC_NroDeSerie = LEFT(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''),LEN(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''))-1) 
 and LOC_CodigoDocumento ='01' 
 
 INNER JOIN SOP30200 AS s  
 on tv.LOC_Numero_Documento = s.SOPNUMBE  
   
 WHERE g.REFRENCE LIKE '%VAL:%'  
 AND CRDTAMNT =0   
 AND TRXDATE BETWEEN @fecInicio AND @fecFin  
 AND RTRIM(LTRIM(S.CUSTNMBR))IN (select codCliente from @Clientes)  
 AND ad.estacion IN (select codEstacion from @codEstaciones)  
  
 UNION  
    
 SELECT   
 DISTINCT RTRIM(ad.numeroFactura) as CLAVE, ad.numeroFactura as SOPNUMBE   
 FROM GL10001 as g INNER JOIN GL10000 as h  
 on g.JRNENTRY = h.JRNENTRY  
   
 INNER JOIN COV_ADIC_CONS as ad  
 on g.JRNENTRY = ad.jrnentry
 
 INNER JOIN t_tributarios_venta as tv
 on tv.LOC_Correlativo =RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1)
 and tv.LOC_NroDeSerie = LEFT(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''),LEN(REPLACE(ad.numeroFactura,RIGHT(ad.numeroFactura,charindex('-',REVERSE(ad.numeroFactura))-1),''))-1) 
 and LOC_CodigoDocumento ='01' 
    
 INNER JOIN SOP30200 AS s  
 on tv.LOC_Numero_Documento = s.SOPNUMBE  
   
 WHERE h.REFRENCE LIKE '%VAL:%'  
 AND CRDTAMNT =0   
 AND TRXDATE BETWEEN @fecInicio AND @fecFin  
 AND RTRIM(LTRIM(S.CUSTNMBR))IN (select codCliente from @Clientes)  
 AND ad.estacion IN (select codEstacion from @codEstaciones)  
   

END
GO
GRANT EXEC ON ReporteConsumosValesObtenerDocumentos TO DYNGRP
GO




