-- Generación de procedimientos para los inserts iniciales de las tablas de dimension

USE DW_COMERCIAL

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_inserts_iniciales_dim_categoria
AS 
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT DIM_CATEGORIA ON;
	INSERT INTO DIM_CATEGORIA
		(
			CATEGORIA_KEY
			, COD_CATEGORIA
			, DESC_CATEGORIA
		)
	VALUES (-1, 'S/E', 'S/E'); -- Sin especificar

	INSERT INTO DIM_CATEGORIA
		(
			CATEGORIA_KEY
			, COD_CATEGORIA
			, DESC_CATEGORIA
		)
	VALUES (0, 'N/A', 'N/A'); -- No aplica

	SET IDENTITY_INSERT DIM_CATEGORIA OFF;
END
GO


CREATE PROCEDURE sp_inserts_iniciales_dim_cliente
AS 
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT DIM_CLIENTE ON;
	INSERT INTO DIM_CLIENTE
		(
			CLIENTE_KEY
			, COD_CLIENTE
			, NOMBRE
			, APELLIDO
		)
	VALUES (-1, 'S/E', 'S/E', 'S/E'); -- Sin especificar

	INSERT INTO DIM_CLIENTE
		(
			CLIENTE_KEY
			, COD_CLIENTE
			, NOMBRE
			, APELLIDO
		)
	VALUES (0, 'N/A', 'N/A', 'N/A'); -- No aplica

	SET IDENTITY_INSERT DIM_CLIENTE OFF;
END
GO


CREATE PROCEDURE sp_inserts_iniciales_dim_pais
AS 
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT DIM_PAIS ON;
	INSERT INTO DIM_PAIS
		(
			PAIS_KEY
			, COD_PAIS
			, DESC_PAIS
		)
	VALUES (-1, 'S/E', 'S/E'); -- Sin especificar

	INSERT INTO DIM_PAIS
		(
			PAIS_KEY
			, COD_PAIS
			, DESC_PAIS
		)
	VALUES (0, 'N/A', 'N/A'); -- No aplica

	SET IDENTITY_INSERT DIM_PAIS OFF;
END
GO


CREATE PROCEDURE sp_inserts_iniciales_dim_producto
AS 
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT DIM_PRODUCTO ON;
	INSERT INTO DIM_PRODUCTO
		(
			PRODUCTO_KEY
			, COD_PRODUCTO
			, DESC_PRODUCTO
		)
	VALUES (-1, 'S/E', 'S/E'); -- Sin especificar

	INSERT INTO DIM_PRODUCTO
		(
			PRODUCTO_KEY
			, COD_PRODUCTO
			, DESC_PRODUCTO
		)
	VALUES (0, 'N/A', 'N/A'); -- No aplica

	SET IDENTITY_INSERT DIM_PRODUCTO OFF;
END
GO


CREATE PROCEDURE sp_inserts_iniciales_dim_sucursal
AS 
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT DIM_SUCURSAL ON;
	INSERT INTO DIM_SUCURSAL
		(
			SUCURSAL_KEY
			, COD_SUCURSAL
			, DESC_SUCURSAL
		)
	VALUES (-1, 'S/E', 'S/E'); -- Sin especificar

	INSERT INTO DIM_SUCURSAL
		(
			SUCURSAL_KEY
			, COD_SUCURSAL
			, DESC_SUCURSAL
		)
	VALUES (0, 'N/A', 'N/A'); -- No aplica

	SET IDENTITY_INSERT DIM_SUCURSAL OFF;
END
GO


CREATE PROCEDURE sp_inserts_iniciales_dim_tiempo
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO DIM_TIEMPO
		(
			TIEMPO_KEY
		)
	VALUES (
		CAST('1900-01-01 00:00:00' AS SMALLDATETIME));
END
GO


CREATE PROCEDURE sp_inserts_iniciales_dim_vendedor
AS 
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT DIM_VENDEDOR ON;
	INSERT INTO DIM_VENDEDOR
		(
			VENDEDOR_KEY
			, COD_VENDEDOR
			, NOMBRE
			, APELLIDO
		)
	VALUES (-1, 'S/E', 'S/E', 'S/E'); -- Sin especificar

	INSERT INTO DIM_VENDEDOR
		(
			VENDEDOR_KEY
			, COD_VENDEDOR
			, NOMBRE
			, APELLIDO
		)
	VALUES (0, 'N/A', 'N/A', 'N/A'); -- No aplica

	SET IDENTITY_INSERT DIM_VENDEDOR OFF;
END
GO




-- Ejecutar los SP 
USE DW_COMERCIAL;
EXECUTE dbo.sp_inserts_iniciales_dim_categoria;
EXECUTE dbo.sp_inserts_iniciales_dim_cliente;
EXECUTE dbo.sp_inserts_iniciales_dim_pais;
EXECUTE dbo.sp_inserts_iniciales_dim_producto;
EXECUTE dbo.sp_inserts_iniciales_dim_sucursal;
EXECUTE dbo.sp_inserts_iniciales_dim_vendedor;
EXECUTE dbo.sp_inserts_iniciales_dim_tiempo;

GO
-- controlar inserts iniciales
SELECT * FROM dbo.DIM_CATEGORIA;
SELECT * FROM dbo.DIM_CLIENTE;
SELECT * FROM dbo.DIM_PAIS;
SELECT * FROM dbo.DIM_PRODUCTO;
SELECT * FROM dbo.DIM_VENDEDOR;
SELECT * FROM dbo.DIM_TIEMPO;

GO