-- Script 2.e.

/* Creación de SPs para las cargas de Tablas DIM y FACT.
EXECUTES auxiliares para la carga de Dimension Tiempo y Fact Ventas 
	comentados al final del script. */


USE DW_COMERCIAL
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SPs para carga DIMS
CREATE PROCEDURE sp_carga_dim_tiempo
	@anio Int
As
SET NOCOUNT ON
SET arithabort off
SET arithignore on
 
/**************/
/* Variables  */
/**************/
 
SET DATEFIRST 1;
SET DATEFORMAT mdy
DECLARE @dia smallint
DECLARE @mes smallint
DECLARE @f_txt  	varchar(10)
DECLARE @fecha  smalldatetime
DECLARE @key int
DECLARE @vacio  smallint
DECLARE @fin smallint
DECLARE @fin_mes int
DECLARE @anioperiodicidad int
  	
SELECT @dia  = 1
SELECT @mes  = 1
SELECT @f_txt = Convert(char(2), @mes) + '/' + Convert(char(2), @dia) + '/' + Convert(char(4), @anio)
SELECT @fecha = Convert(smalldatetime, @f_txt)
select @anioperiodicidad = @anio

/************************************/
/* Se chequea que el a¤o a procesar */
/* no exista en la tabla TIME   	*/
/************************************/

IF (SELECT Count(*) FROM dim_tiempo WHERE anio = @anio) > 0
  BEGIN
		Print 'El año que ingreso ya existe en la tabla'
		Print 'Procedimiento CANCELADO.................'
			Return 0
  END

/*************************/
/* Se inserta dia a dia  */
/* hasta terminar el anio */
/*************************/

SELECT @fin = @anio + 1
WHILE (@anio < @fin)
  BEGIN
   	--Armo la fecha
   	IF Len(Rtrim(Convert(Char(2),Datepart(mm, @fecha))))=1
   	  BEGIN
				IF Len(Rtrim(Convert(Char(2),Datepart(dd, @fecha))))=1
						SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + '0' + Rtrim(Convert(Char(2),Datepart(mm, @fecha))) + '0' + Rtrim(Convert(Char(2),Datepart(dd, @fecha)))
				ELSE
						SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + '0' + Rtrim(Convert(Char(2),Datepart(mm, @fecha))) + Convert(Char(2),Datepart(dd, @fecha))
   	  END
   	ELSE
   	  BEGIN
         	IF Len(Rtrim(Convert(Char(2),Datepart(dd, @fecha))))=1
						SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + Convert(Char(2),Datepart(mm, @fecha)) + '0' + Rtrim(Convert(Char(2),Datepart(dd, @fecha)))
         	ELSE
						SET @f_txt = Convert(char(4),Datepart(yyyy, @fecha)) + Convert(Char(2),Datepart(mm, @fecha)) + Convert(Char(2),Datepart(dd, @fecha))
   	  END
   	--Calculo el último día del mes  
   	SET @fin_mes = day(dateadd(d, -1, dateadd(m, 1, dateadd(d, - day(@fecha) + 1, @fecha))))
 
INSERT DIM_TIEMPO 
	(
		TIEMPO_KEY, ANIO, MES_NRO, MES_NOMBRE, SEMESTRE, TRIMESTRE, SEMANA_ANIO
		, SEMANA_NRO_MES, DIA, DIA_NOMBRE, DIA_SEMANA_NRO 
	)
 
	SELECT
				tiempo_key    	= @fecha
			, anio                 	= Datepart(yyyy, @fecha)
			, mes                  	= Datepart(mm, @fecha)
			--, mes_nombre = Datename(mm, @fecha)
			, mes_nombre  = CASE Datename(mm, @fecha)
																	when 'January'         	then 'Enero'
																	when 'February'        	then 'Febrero'
																	when 'March'    	then 'Marzo'
																	when 'April'    	then 'Abril'
																	when 'May'             	then 'Mayo'
																	when 'June'            	then 'Junio'
																	when 'July'            	then 'Julio'
																	when 'August'   	then 'Agosto'
																	when 'September'	then 'Septiembre'
																	when 'October'         	then 'Octubre'
																	when 'November'        	then 'Noviembre'
																	when 'December'        	then 'Diciembre'
																	else Datename(mm, @fecha)
														END
			, semestre      	= CASE Datepart(mm, @fecha)
																	when (SELECT Datepart(mm, @fecha)
																						WHERE Datepart(mm, @fecha) between 1 and 6) then 1
																	else   2
															END 
			, trimestre            	= Datepart(qq, @fecha)
			, semana_anio   	= Datepart(wk, @fecha)
			, semana_nro_mes	= Datepart(wk, @fecha) - datepart(week, dateadd(dd,-day(@fecha)+1,@fecha)) +1
			, dia                  	= Datepart(dd, @fecha)
		, dia_nombre    	= CASE Datename(dw, @fecha)
																	when 'Monday'   	then 'Lunes'
																	when 'Tuesday'         	then 'Martes'
																	when 'Wednesday'	then 'Miercoles'
																	when 'Thursday'        	then 'Jueves'
																	when 'Friday'   	then 'Viernes'
																	when 'Saturday'        	then 'Sabado'
																	when 'Sunday'   	then 'Domingo'
																	else Datename(dw, @fecha)
										END
		--, dia_nombre         	= Datename(dw, @fecha)
			, dia_semana_nro	= Datepart(dw, @fecha)
         	   
	SELECT @fecha = Dateadd(dd, 1, @fecha)
	SELECT @dia     	= Datepart(dd, @fecha)
	SELECT @mes     	= Datepart(mm, @fecha)
	SELECT @anio  = Datepart(yy, @fecha) 	CONTINUE	
END
GO

CREATE PROCEDURE sp_carga_dim_producto
AS
BEGIN
	SET NOCOUNT ON;

	-- ACTUALIZO REGISTROS EXISTENTES
	UPDATE d
	SET d.DESC_PRODUCTO = i.DESC_PRODUCTO
	FROM DIM_PRODUCTO AS d
		INNER JOIN INT_DIM_PRODUCTO AS i
			ON d.COD_PRODUCTO = i.COD_PRODUCTO

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO DIM_PRODUCTO
	(
		COD_PRODUCTO,
		DESC_PRODUCTO
	)
	SELECT 
		i.COD_PRODUCTO,
		i.DESC_PRODUCTO
	FROM INT_DIM_PRODUCTO AS i
		LEFT JOIN DIM_PRODUCTO AS d
			ON i.COD_PRODUCTO = d.COD_PRODUCTO
	WHERE d.COD_PRODUCTO IS NULL
END
GO


CREATE PROCEDURE sp_carga_dim_categoria
AS
BEGIN
	SET NOCOUNT ON;

	-- ACTUALIZO REGISTROS EXISTENTES
	UPDATE d
	SET d.DESC_CATEGORIA = i.DESC_CATEGORIA
	FROM DIM_CATEGORIA AS d
		INNER JOIN INT_DIM_CATEGORIA AS i
			ON d.COD_CATEGORIA = i.COD_CATEGORIA

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO DIM_CATEGORIA
	(
		COD_CATEGORIA,
		DESC_CATEGORIA
	)
	SELECT 
		i.COD_CATEGORIA,
		i.DESC_CATEGORIA
	FROM INT_DIM_CATEGORIA AS i
		LEFT JOIN DIM_CATEGORIA AS d
			ON i.COD_CATEGORIA = d.COD_CATEGORIA
	WHERE d.COD_CATEGORIA IS NULL
END
GO


CREATE PROCEDURE sp_carga_dim_pais
AS
BEGIN
	SET NOCOUNT ON;

	-- ACTUALIZO REGISTROS EXISTENTES
	UPDATE d
	SET d.DESC_PAIS = i.DESC_PAIS
	FROM DIM_PAIS AS d
		INNER JOIN INT_DIM_PAIS AS i
			ON d.COD_PAIS = i.COD_PAIS

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO DIM_PAIS
	(
		COD_PAIS,
		DESC_PAIS
	)
	SELECT 
		i.COD_PAIS,
		i.DESC_PAIS
	FROM INT_DIM_PAIS AS i
		LEFT JOIN DIM_PAIS AS d
			ON i.COD_PAIS = d.COD_PAIS
	WHERE d.COD_PAIS IS NULL
END
GO


CREATE PROCEDURE sp_carga_dim_sucursal
AS
BEGIN
	SET NOCOUNT ON;

	-- ACTUALIZO REGISTROS EXISTENTES
	UPDATE d
	SET d.DESC_SUCURSAL = i.DESC_SUCURSAL
	FROM DIM_SUCURSAL AS d
		INNER JOIN INT_DIM_SUCURSAL AS i
			ON d.COD_SUCURSAL = i.COD_SUCURSAL

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO DIM_SUCURSAL
	(
		COD_SUCURSAL,
		DESC_SUCURSAL
	)
	SELECT 
		i.COD_SUCURSAL,
		i.DESC_SUCURSAL
	FROM INT_DIM_SUCURSAL AS i
		LEFT JOIN DIM_SUCURSAL AS d
			ON i.COD_SUCURSAL = d.COD_SUCURSAL
	WHERE d.COD_SUCURSAL IS NULL
END
GO


CREATE PROCEDURE sp_carga_dim_cliente
AS
BEGIN
	SET NOCOUNT ON;

	-- ACTUALIZO REGISTROS EXISTENTES
	UPDATE d
	SET d.NOMBRE = i.NOMBRE,
		d.APELLIDO = i.APELLIDO	
	FROM DIM_CLIENTE AS d
		INNER JOIN INT_DIM_CLIENTE AS i
			ON d.COD_CLIENTE = i.COD_CLIENTE

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO DIM_CLIENTE
	(
		COD_CLIENTE,
		NOMBRE,
		APELLIDO
	)
	SELECT 
		i.COD_CLIENTE,
		i.NOMBRE,
		i.APELLIDO
	FROM INT_DIM_CLIENTE AS i
		LEFT JOIN DIM_CLIENTE AS d
			ON i.COD_CLIENTE = d.COD_CLIENTE
	WHERE d.COD_CLIENTE IS NULL
END
GO


CREATE PROCEDURE sp_carga_dim_vendedor
AS
BEGIN
	SET NOCOUNT ON;

	-- ACTUALIZO REGISTROS EXISTENTES
	UPDATE d
	SET d.NOMBRE = i.NOMBRE,
		d.APELLIDO = i.APELLIDO	
	FROM DIM_VENDEDOR AS d
		INNER JOIN INT_DIM_VENDEDOR AS i
			ON d.COD_VENDEDOR = i.COD_VENDEDOR

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO DIM_VENDEDOR
	(
		COD_VENDEDOR,
		NOMBRE,
		APELLIDO
	)
	SELECT 
		i.COD_VENDEDOR,
		i.NOMBRE,
		i.APELLIDO
	FROM INT_DIM_VENDEDOR AS i
		LEFT JOIN DIM_VENDEDOR AS d
			ON i.COD_VENDEDOR = d.COD_VENDEDOR
	WHERE d.COD_VENDEDOR IS NULL
END
GO



-- SP para carga FACT
CREATE PROCEDURE sp_carga_fact_ventas
@FechaDesde SMALLDATETIME,
@FechaHasta SMALLDATETIME

AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM FACT_VENTAS
	WHERE TIEMPO_KEY BETWEEN @FechaDesde AND @FechaHasta

	-- INSERTO NUEVOS REGISTROS
	INSERT INTO FACT_VENTAS
	(
		[PRODUCTO_KEY]
		,[CATEGORIA_KEY]
		,[CLIENTE_KEY]
		,[PAIS_KEY]
		,[VENDEDOR_KEY]
		,[SUCURSAL_KEY]
		,[TIEMPO_KEY]
		,[CANTIDAD_VENDIDA]
		,[MONTO_VENDIDO]
		,[PRECIO]
		,[COMISION_COMERCIAL]
	)
	SELECT 
		ISNULL(prod.PRODUCTO_KEY,-1) AS PRODUCTO_KEY, 
		ISNULL(cat.CATEGORIA_KEY,-1) AS CATEGORIA_KEY, 
		ISNULL(cli.CLIENTE_KEY,-1) AS CLIENTE_KEY, 
		ISNULL(pa.PAIS_KEY,-1) AS PAIS_KEY, 
		ISNULL(vend.VENDEDOR_KEY,-1) AS VENDEDOR_KEY, 
		ISNULL(suc.SUCURSAL_KEY,-1) AS SUCURSAL_KEY, 
		ISNULL(t.TIEMPO_KEY,
			CAST('1900-01-01 00:00:00' AS SMALLDATETIME) 
			) AS TIEMPO_KEY,
		i.CANTIDAD_VENDIDA,
		i.MONTO_VENDIDO,
		i.PRECIO,
		i.COMISION_COMERCIAL
	FROM INT_FACT_VENTAS AS i
		LEFT JOIN DIM_PRODUCTO AS prod 
			ON i.COD_PRODUCTO = prod.COD_PRODUCTO
		LEFT JOIN DIM_CATEGORIA AS cat 
			ON i.COD_CATEGORIA = cat.COD_CATEGORIA
		LEFT JOIN DIM_CLIENTE AS cli 
			ON i.COD_CLIENTE = cli.COD_CLIENTE
		LEFT JOIN DIM_PAIS AS pa
			ON i.COD_PAIS = pa.COD_PAIS
		LEFT JOIN DIM_SUCURSAL AS suc
			ON i.COD_SUCURSAL = suc.COD_SUCURSAL
		LEFT JOIN DIM_VENDEDOR AS vend 
			ON i.COD_VENDEDOR = vend.COD_VENDEDOR
		LEFT JOIN DIM_TIEMPO AS t
			ON i.Fecha = t.TIEMPO_KEY 
	WHERE i.Fecha BETWEEN @FechaDesde AND @FechaHasta
END


/* EXECUTES AUXILIARES (Comentado)

-- carga DIM_TIEMPO años 2016 - 2021
EXECUTE sp_carga_dim_tiempo 2016
EXECUTE sp_carga_dim_tiempo 2017
EXECUTE sp_carga_dim_tiempo 2018
EXECUTE sp_carga_dim_tiempo 2019
EXECUTE sp_carga_dim_tiempo 2020
EXECUTE sp_carga_dim_tiempo 2021

-- Carga de tabla de hechos
-- Encuentro fecha minima y fecha maxima
DECLARE @fecha_minima AS SMALLDATETIME;
DECLARE @fecha_maxima AS SMALLDATETIME;
SELECT @fecha_minima = MIN(Fecha), -- 2016
	@fecha_maxima = MAX(Fecha)	 -- 2021 
FROM INT_FACT_VENTAS;
-- Ejecuto el procedimiento con los valores encontrados
EXECUTE sp_carga_fact_ventas @fecha_minima, @fecha_maxima;
*/