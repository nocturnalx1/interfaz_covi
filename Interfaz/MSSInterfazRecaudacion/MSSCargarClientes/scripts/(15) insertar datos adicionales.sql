USE [GPTST]
GO

/****** Object:  StoredProcedure [dbo].[InterfazCovi_InsertaClienteLOC]    Script Date: 09/28/2012 11:39:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InterfazCovi_InsertaClienteLOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InterfazCovi_InsertaClienteLOC]
GO


CREATE PROC [dbo].[InterfazCovi_InsertaClienteLOC]
-- =============================================
-- Author:		Daniel Castillo
-- Create date: 20/08/2012
-- Description:	permite insertar los datos adicionales (localizacion)
-- del cliente
-- =============================================
			@CUSTNAME char(65)
           ,@CUSTNMBR char(15)
           ,@LOC_Nombre1 char(31)
           ,@LOC_Nombre2 char(31)
           ,@LOC_Apellido_Paterno char(31)
           ,@LOC_Apellido_Materno char(31)
           ,@LOC_Numero_Documento char(31)
           ,@F_Tipo_Persona_DDL smallint
           ,@F_Tipo_Documento_ID char(11)
           ,@LOC_Razon_Social char(101)
           ,@USERID char(15)
           ,@SLPRSNID char(15)
           ,@PYMTRMID char(21)
           ,@F_TipoDoc_Emitir char(21)
           ,@F_TipoPedido char(67)
	
AS
BEGIN

declare @F_Tipo_Documento_Desc varchar(51)

SELECT @F_Tipo_Documento_Desc=F_Tipo_Documento_Desc 
FROM T_GN_Tipo_Documento_MSTR
WHERE LTRIM(RTRIM(F_Tipo_Documento_ID)) = LTRIM(RTRIM(@F_Tipo_Documento_ID))

	INSERT INTO [t_cliente]
           ([CUSTNAME]
           ,[CUSTNMBR]
           ,[LOC_Nombre1]
           ,[LOC_Nombre2]
           ,[LOC_Apellido_Paterno]
           ,[LOC_Apellido_Materno]
           ,[LOC_Numero_Documento]
           ,[F_Tipo_Persona_DDL]
           ,[F_Tipo_Documento_ID]
           ,[F_Tipo_Documento_Desc]
           ,[LOC_Razon_Social]
           ,[USERID]
           ,[CREATDDT]
           ,[MODIFDT]
           ,[SLPRSNID]
           ,[PYMTRMID]
           ,[F_TipoDoc_Emitir]
           ,[F_TipoPedido])
     VALUES
       (
          	@CUSTNAME 
           ,@CUSTNMBR 
           ,@LOC_Nombre1 
           ,@LOC_Nombre2 
           ,@LOC_Apellido_Paterno 
           ,@LOC_Apellido_Materno 
           ,@LOC_Numero_Documento 
           ,@F_Tipo_Persona_DDL 
           ,@F_Tipo_Documento_ID 
           ,@F_Tipo_Documento_Desc 
           ,@LOC_Razon_Social 
           ,@USERID 
           ,convert(datetime,Convert(varchar, GETDATE(),103),103)
           ,convert(datetime,Convert(varchar, GETDATE(),103),103)
           ,@SLPRSNID 
           ,@PYMTRMID
           ,@F_TipoDoc_Emitir 
           ,@F_TipoPedido
         )
END


GO
GRANT EXEC ON InterfazCovi_InsertaClienteLOC TO DYNGRP
GO

