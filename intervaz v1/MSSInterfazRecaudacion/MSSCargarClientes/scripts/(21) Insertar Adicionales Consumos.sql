USE [GPCOV]
GO

/****** Object:  StoredProcedure [dbo].[InsertarAdicionalesConsumos]    Script Date: 09/28/2012 11:51:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsertarAdicionalesConsumos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InsertarAdicionalesConsumos]
GO

USE [GPCOV]
GO

/****** Object:  StoredProcedure [dbo].[InsertarAdicionalesConsumos]    Script Date: 09/28/2012 11:51:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarAdicionalesConsumos]
	-- Add the parameters for the stored procedure here
	@id_ventana varchar(15),
	@jrentry	varchar(30),
	@nroCampo	smallint,
	@valor		varchar(255)
AS
BEGIN
	-- =============================================
-- Author:		Daniel Castillo
-- Create date: 20/08/2012
-- Description:	Permite agregar valores adicionales
-- en los extender de short string
-- =============================================
	
	INSERT INTO EXT00101
           ([PT_Window_ID]
           ,[PT_UD_Key]
           ,[PT_UD_Number]
           ,[STRGA255])
     VALUES
           (@id_ventana
           ,@jrentry
           ,@nroCampo
           ,@valor)

END


GO
GRANT EXEC ON InsertarAdicionalesConsumos TO DYNGRP
GO
