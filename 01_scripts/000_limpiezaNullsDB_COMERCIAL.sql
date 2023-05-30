USE DB_COMERCIAL

--borrando columnas mal generadas
ALTER TABLE Producto
DROP COLUMN F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15

DELETE FROM Categoria 
WHERE Desc_Categoria IS NULL 
	AND [COD_Categoria] IS NULL

DELETE FROM Cliente
WHERE Desc_Cliente IS NULL
	AND COD_Cliente IS NULL

DELETE FROM Pais
WHERE Desc_Pais IS NULL
	AND COD_PAIS IS NULL

DELETE FROM Producto
WHERE Desc_Producto IS NULL 
	AND COD_Producto IS NULL

DELETE FROM Sucursal
WHERE Desc_Sucursal IS NULL
	AND COD_Sucursal IS NULL

DELETE FROM Vendedor
WHERE Desc_Vendedor IS NULL
	AND COD_Vendedor IS NULL

/*
(996 filas afectadas) 
	(204 filas afectadas) 
	(986 filas afectadas) 
	(982 filas afectadas) 
	(934 filas afectadas) 
	(934 filas afectadas)
*/