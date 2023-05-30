-- Script 3
-- Validaciones de datos


USE DW_COMERCIAL;
GO


/** Validaciones para la tabla Fact **/

-- Validación de cantidad de registros
SELECT COUNT(*) AS [Cant registros DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas;
-- resultado: 11992

SELECT COUNT(*) AS [Cant registros DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS;
-- resultado: 11992
-- Conclusion: Los valores coinciden, validación correcta.

-- Validación de Montos Totales
SELECT SUM(Monto_Vendido) AS [Monto total ventas DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas;
-- resultado: 5122990000.00

SELECT SUM(Monto_Vendido) AS [Monto total ventas DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS;
-- resultado: 5122990000.00
-- Conclusion: Los valores coinciden, validación correcta.

-- Validación de suma de cantidades, aperturadas por distintas dimensiones.

-- a) Suma de cantidades vendidas por producto
SELECT P.Desc_Producto , SUM(V.Cantidad_Vendida) AS [Sum Cant vendida DB_COMERCIAL] 
FROM DB_COMERCIAL.dbo.Ventas AS V
	JOIN DB_COMERCIAL.dbo.Producto AS P
		ON P.COD_Producto = V.COD_Producto
GROUP BY P.Desc_Producto
ORDER BY 2 DESC;

SELECT P.DESC_PRODUCTO, SUM(V.CANTIDAD_VENDIDA) AS [Sum Cant vendida DW_COMERCIAL] 
FROM DW_COMERCIAL.dbo.FACT_VENTAS AS V
	JOIN DW_COMERCIAL.dbo.DIM_PRODUCTO AS P
		ON P.PRODUCTO_KEY = V.PRODUCTO_KEY
GROUP BY P.DESC_PRODUCTO
ORDER BY 2 DESC;
-- Conclusion: Los valores coinciden, validación correcta.

-- b) Suma de montos vendidos por categoria

SELECT C.Desc_Categoria, SUM(V.Monto_Vendido) AS [Sum Monto vendido DB_COMERCIAL] 
FROM DB_COMERCIAL.dbo.Ventas AS V
	JOIN DB_COMERCIAL.dbo.Categoria AS C
		ON C.COD_Categoria = V.COD_CATEGORIA
GROUP BY C.Desc_Categoria
ORDER BY 2 DESC;

SELECT C.DESC_CATEGORIA, SUM(V.MONTO_VENDIDO) AS [Sum Monto vendido DW_COMERCIAL] 
FROM DW_COMERCIAL.dbo.FACT_VENTAS AS V
	JOIN DW_COMERCIAL.dbo.DIM_CATEGORIA AS C
		ON C.CATEGORIA_KEY  = V.CATEGORIA_KEY
GROUP BY C.DESC_CATEGORIA
ORDER BY 2 DESC;
-- Conclusion: Los valores coinciden, validación correcta.

-- c) Top 3 vendedores por total vendido ($)
SELECT TOP (3) 
	DV.COD_Vendedor, DV.Desc_Vendedor,
	SUM(FV.Monto_Vendido) AS [Total vendido DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas AS FV
	JOIN DB_COMERCIAL.dbo.Vendedor AS DV
		ON DV.COD_Vendedor = FV.COD_VENDEDOR
GROUP BY DV.COD_Vendedor, DV.Desc_Vendedor
ORDER BY 3 DESC;

SELECT TOP (3) 
	DV.COD_VENDEDOR, DV.NOMBRE, DV.APELLIDO,
		SUM(FV.MONTO_VENDIDO) AS [Total vendido DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS AS FV
	JOIN DW_COMERCIAL.dbo.DIM_VENDEDOR AS DV
		ON DV.VENDEDOR_KEY = FV.VENDEDOR_KEY
GROUP BY DV.COD_VENDEDOR, DV.NOMBRE, DV.APELLIDO
ORDER BY 4 DESC;
-- Conclusion: Los valores coinciden, validación correcta.

-- d) Top 3 clientes por total comprado ($)
SELECT TOP (3) 
	C.COD_Cliente, C.Desc_Cliente,
	SUM(V.Monto_Vendido) AS [Total comprado DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas AS V
	JOIN DB_COMERCIAL.dbo.Cliente AS C
		ON C.COD_Cliente = V.COD_CLIENTE
GROUP BY C.COD_Cliente, C.Desc_Cliente
ORDER BY 3 DESC;

SELECT TOP (3) 
	C.COD_CLIENTE, C.NOMBRE, C.APELLIDO,
		SUM(V.MONTO_VENDIDO) AS [Total comprado DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS AS V
	JOIN DW_COMERCIAL.dbo.DIM_CLIENTE AS C
		ON C.CLIENTE_KEY = V.CLIENTE_KEY
GROUP BY C.COD_CLIENTE, C.NOMBRE, C.APELLIDO
ORDER BY 4 DESC;
-- Conclusion: Los valores coinciden, validación correcta.

-- e) Top 3 productos mas vendidos ($)
SELECT TOP (3) 
	P.COD_Producto, P.Desc_Producto,
	SUM(V.Monto_Vendido) AS [Ingresos totales DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas AS V
	JOIN DB_COMERCIAL.dbo.Producto AS P
		ON P.COD_Producto = V.COD_PRODUCTO
GROUP BY P.COD_Producto, P.Desc_Producto
ORDER BY 3 DESC;

SELECT TOP (3) 
	P.COD_PRODUCTO, P.DESC_PRODUCTO,
		SUM(V.MONTO_VENDIDO) AS [Ingresos totales DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS AS V
	JOIN DW_COMERCIAL.dbo.DIM_PRODUCTO AS P
		ON P.PRODUCTO_KEY = V.PRODUCTO_KEY
GROUP BY P.COD_PRODUCTO, P.DESC_PRODUCTO
ORDER BY 3 DESC;




-- Validaciones para las tablas de dimensiones

-- Cantidad de Clientes Total (#)
SELECT COUNT(*) AS [Cant de clientes DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Cliente;
-- resultado: 795

SELECT COUNT(*) AS [Cant de clientes DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.DIM_CLIENTE;
-- resultado: 797

/* Conclusion: La cantidad de clientes es la esperada. Difiere en 2
unidades unicamente por los valores de los inserts iniciales (-1 para
valor 'Sin Especificar' y 0 para valor 'No Aplica'). Validación correcta.*/


-- Cantidad de Vendedores Total (#)
SELECT COUNT(*) AS [Cant de vendedores DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Vendedor;
-- resultado: 65

SELECT COUNT(*) AS [Cant de vendedores DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.DIM_VENDEDOR;
-- resultado: 67

/* Conclusion: La cantidad de vendedores es la esperada. Difiere en 2
unidades unicamente por los valores de los inserts iniciales (-1 para
valor 'Sin Especificar' y 0 para valor 'No Aplica'). Validación correcta.*/


-- Cantidad de Paises Total (#)
SELECT COUNT(*) AS [Cant de paises DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Pais;
-- resultado: 13

SELECT COUNT(*) AS [Cant de paises DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.DIM_PAIS;
-- resultado: 15

/* Conclusion: La cantidad de paises es la esperada. Difiere en 2
unidades unicamente por los valores de los inserts iniciales (-1 para
valor 'Sin Especificar' y 0 para valor 'No Aplica'). Validación correcta.*/


-- Cantidad de Productos Total (#)
SELECT COUNT(*) AS [Cant de productos DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Producto;
-- resultado: 17

SELECT COUNT(*) AS [Cant de productos DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.DIM_PRODUCTO;
-- resultado: 19

/* Conclusion: La cantidad de productos es la esperada. Difiere en 2
unidades unicamente por los valores de los inserts iniciales (-1 para
valor 'Sin Especificar' y 0 para valor 'No Aplica'). Validación correcta.*/


-- Cantidad de Categorias Total (#)
SELECT COUNT(*) AS [Cant de categorias DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Categoria;
-- resultado: 3

SELECT COUNT(*) AS [Cant de categorias DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.DIM_CATEGORIA;
-- resultado: 5

/* Conclusion: La cantidad de categorias es la esperada. Difiere en 2
unidades unicamente por los valores de los inserts iniciales (-1 para
valor 'Sin Especificar' y 0 para valor 'No Aplica'). Validación correcta.*/


-- Cantidad de Sucursales Total (#)
SELECT COUNT(*) AS [Cant de sucursales DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Sucursal;
-- resultado: 65

SELECT COUNT(*) AS [Cant de sucursales DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.DIM_SUCURSAL;
-- resultado: 67

/* Conclusion: La cantidad de sucursales es la esperada. Difiere en 2
unidades unicamente por los valores de los inserts iniciales (-1 para
valor 'Sin Especificar' y 0 para valor 'No Aplica'). Validación correcta.*/


-- Visualizacion de datos:
-- Porcentaje de Total vendido que representa cada producto
DECLARE @Suma_total AS DECIMAL(18,2);
SELECT
@Suma_total = SUM(MONTO_VENDIDO) FROM FACT_VENTAS;

WITH Aux1 AS
(
	SELECT DESC_PRODUCTO, SUM(MONTO_VENDIDO) AS Suma_prod
	FROM FACT_VENTAS AS FV
		JOIN DIM_PRODUCTO AS DP
			ON DP.PRODUCTO_KEY = FV.PRODUCTO_KEY
	GROUP BY DP.DESC_PRODUCTO
)
SELECT Aux1.DESC_PRODUCTO, 
	(100.0 * Aux1.Suma_prod/@Suma_total) AS [Porcentaje de ventas total]
FROM Aux1
ORDER BY [Porcentaje de ventas total] DESC;

GO

-- Porcentaje de total vendido que representa cada categoria
DECLARE @Suma_total AS DECIMAL(18,2);
SELECT
@Suma_total = SUM(MONTO_VENDIDO) FROM FACT_VENTAS;

WITH Aux2 AS
(
	SELECT DC.DESC_CATEGORIA, SUM(MONTO_VENDIDO) AS Suma_cat
	FROM FACT_VENTAS AS FV
		JOIN DIM_CATEGORIA AS DC
			ON DC.CATEGORIA_KEY = FV.CATEGORIA_KEY
	GROUP BY DC.DESC_CATEGORIA
)
SELECT DESC_CATEGORIA,
	(100.0 * Suma_cat/@Suma_total) AS [Porcentaje de ventas total]
FROM Aux2
ORDER BY [Porcentaje de ventas total] DESC;

-- Suma de monto vendido por año
SELECT DATEPART(YEAR, TIEMPO_KEY) AS ANIO,
	SUM(MONTO_VENDIDO) AS [Monto total vendido]
FROM FACT_VENTAS
GROUP BY DATEPART(YEAR, TIEMPO_KEY)
ORDER BY ANIO ASC;

-- Suma de monto vendido por año y cuatrimestre
SELECT DATEPART(YEAR, TIEMPO_KEY) AS ANIO,
	DATEPART(QUARTER, TIEMPO_KEY) AS CUATRIMESTRE,
	SUM(MONTO_VENDIDO) AS [Monto total vendido]
FROM FACT_VENTAS
GROUP BY DATEPART(YEAR, TIEMPO_KEY), DATEPART(QUARTER, TIEMPO_KEY)
ORDER BY ANIO ASC, CUATRIMESTRE ASC;





-- Mas validaciones
USE DW_COMERCIAL;
GO;

-- Monto Total de Ventas ($)
SELECT SUM(Monto_Vendido) AS [Monto total DB_COMERCIAL] 
FROM DB_COMERCIAL.dbo.Ventas;
-- resultado: 5122990000.00

SELECT SUM(MONTO_VENDIDO) AS [Monto total DW_COMERCIAL] 
FROM DW_COMERCIAL.dbo.FACT_VENTAS;
-- resultado: 5122990000.00
-- Conclusion: Los montos totales coinciden, validación correcta.

-- Cantidad vendida Total (#)
SELECT SUM(Cantidad_Vendida) AS [Cant vendida DB_COMERCIAL] 
FROM DB_COMERCIAL.dbo.Ventas;
-- resultado: 306208.00

SELECT SUM(CANTIDAD_VENDIDA) AS [Cant vendida DW_COMERCIAL] 
FROM DW_COMERCIAL.dbo.FACT_VENTAS;
-- resultado: 306208.00
-- Conclusion: Las cantidades vendidas totales coinciden, validación correcta.

-- Monto promedio de Ventas Total ($)
SELECT AVG(Monto_Vendido) AS [Promedio ventas DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas;
-- resultado: 427200.633755

SELECT AVG(MONTO_VENDIDO) AS [Promedio ventas DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS;
-- resultado: 427200.633755
-- Conclusion: Los promedios de los montos vendidos totales coinciden, validación correcta.

-- Importe Comisión Comercial Total ($)
SELECT SUM(Comision_Comercial) 
	AS [Importe total comision comercial DB_COMERCIAL]
FROM DB_COMERCIAL.dbo.Ventas;
-- resultado: 629831584.58

SELECT SUM(COMISION_COMERCIAL) 
	AS [Importe total comision comercial DW_COMERCIAL]
FROM DW_COMERCIAL.dbo.FACT_VENTAS;
-- resultado: 629831584.58
-- Conclusion: El importe total de comisiones comerciales coinciden, validación correcta.



-- Cantidad de Clientes que participaron en ventas
WITH tabla_aux AS 
(
	SELECT C.COD_Cliente
	FROM DB_COMERCIAL.dbo.Cliente AS C
		JOIN DB_COMERCIAL.dbo.Ventas AS V
			ON C.COD_Cliente = V.COD_CLIENTE
	GROUP BY C.COD_Cliente
)
SELECT COUNT(*) AS [Cant de clientes en ventas DB_COMERCIAL]
FROM tabla_aux;
-- resultado: 795

WITH tabla_aux AS 
(
	SELECT C.CLIENTE_KEY
	FROM DIM_CLIENTE AS C
		JOIN FACT_VENTAS AS V
			ON C.CLIENTE_KEY = V.CLIENTE_KEY
	GROUP BY C.CLIENTE_KEY
)
SELECT COUNT(*) AS [Cant de clientes en ventas DW_COMERCIAL]
FROM tabla_aux;
-- resultado: 795

-- Conclusion: La cantidad de clientes que participaron en 
-- ventas coinciden, validación correcta


-- Cantidad de ventas realizadas por año.
SELECT DATEPART(YEAR, Fecha) AS Anio,
	FORMAT(SUM(Monto_Vendido),'N2') AS [Total vendido],
	'DB_COMERCIAL' AS [Base de datos]
FROM DB_COMERCIAL.dbo.Ventas
GROUP BY DATEPART(YEAR, Fecha)
ORDER BY [Total vendido] DESC;

SELECT DATEPART(YEAR, TIEMPO_KEY) AS Anio,
	FORMAT(SUM(MONTO_VENDIDO),'N2') AS [Total vendido],
	'DW_COMERCIAL' AS [Base de datos]
FROM FACT_VENTAS
GROUP BY DATEPART(YEAR, TIEMPO_KEY)
ORDER BY [Total vendido] DESC;
-- Conclusion: Valores coinciden. Validación correcta.


-- Mes y año en el que mas se recaudo 
-- Para DB_COMERCIAL
SELECT TOP(1) DATEPART(MONTH, Fecha) AS mes_nro,
	DATEPART(YEAR, Fecha) AS anio,
	FORMAT(SUM(Monto_Vendido), 'N2') AS [Ventas mes]
FROM DB_COMERCIAL.dbo.Ventas
GROUP BY DATEPART(YEAR, Fecha), DATEPART(MONTH, Fecha) 
ORDER BY [Ventas mes] DESC;

-- Para DW_COMERCIAL
SELECT TOP(1) DT.MES_NRO, DT.ANIO,
	FORMAT(SUM(FV.MONTO_VENDIDO), 'N2') AS [Ventas mes]
FROM FACT_VENTAS AS FV
	JOIN DIM_TIEMPO AS DT
		ON FV.TIEMPO_KEY = DT.TIEMPO_KEY
GROUP BY DT.ANIO, DT.MES_NRO
ORDER BY [Ventas mes] DESC;
/*
Ambos resultados indican que el mes que mas se recaudo fue mayo del 2019,
con una suma de $ 93,110,000. Validación correcta.
*/

-- Recaudacion por mes, con promedio por año en la misma tabla.

-- Para DB_COMERCIAL
SELECT mes_nro, anio, [Ventas mes],
	AVG([Ventas mes]) OVER (PARTITION BY anio) AS [Promedio de ventas anual]
FROM 
(
	SELECT DATEPART(MONTH, Fecha) AS mes_nro,
		DATEPART(YEAR, Fecha) AS anio
		,SUM(Monto_Vendido) AS [Ventas mes]
	FROM DB_COMERCIAL.dbo.Ventas
	GROUP BY DATEPART(YEAR, Fecha), DATEPART(MONTH, Fecha)
) AS T_DB_COMERCIAL
ORDER BY anio ASC, mes_nro ASC;

-- Para DW_COMERCIAL
SELECT MES_NRO, ANIO, [Ventas mes],
	AVG([Ventas mes]) OVER (PARTITION BY ANIO) AS [Promedio de ventas anual]
FROM
(
	SELECT DT.MES_NRO, DT.ANIO 
		,SUM(FV.MONTO_VENDIDO) AS [Ventas mes]
	FROM FACT_VENTAS AS FV
		JOIN DIM_TIEMPO AS DT
			ON FV.TIEMPO_KEY = DT.TIEMPO_KEY
	GROUP BY DT.ANIO, DT.MES_NRO
) AS T_DW_COMERCIAL
ORDER BY ANIO ASC, MES_NRO ASC;


-- Comprobando que no hay diferencias entre ambos resultados usando EXCEPT
SELECT * FROM 
(
	(
		SELECT mes_nro, anio, [Ventas mes],
			AVG([Ventas mes]) OVER (PARTITION BY anio) AS [Promedio de ventas anual]
		FROM 
		(
			SELECT DATEPART(MONTH, Fecha) AS mes_nro,
				DATEPART(YEAR, Fecha) AS anio
				,SUM(Monto_Vendido) AS [Ventas mes]
			FROM DB_COMERCIAL.dbo.Ventas
			GROUP BY DATEPART(YEAR, Fecha), DATEPART(MONTH, Fecha)
		) AS T_DB_COMERCIAL
	) 
EXCEPT
	(
		SELECT MES_NRO, ANIO ,[Ventas mes]
			,
				AVG([Ventas mes]) OVER (PARTITION BY ANIO) AS [Promedio de ventas anual]
		FROM
		(
			SELECT DT.MES_NRO, DT.ANIO 
				,SUM(FV.MONTO_VENDIDO) AS [Ventas mes]
			FROM FACT_VENTAS AS FV
				JOIN DIM_TIEMPO AS DT
					ON FV.TIEMPO_KEY = DT.TIEMPO_KEY
			GROUP BY DT.ANIO, DT.MES_NRO
		) AS T_DW_COMERCIAL
	) 
) AS X;
-- Resultado: 0 filas, las querys devuelven los mismos valores. Validación correcta.