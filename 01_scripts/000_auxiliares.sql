--aux
USE DB_COMERCIAL;

ALTER TABLE Ventas
ALTER COLUMN [Cantidad_Vendida] DECIMAL(18,2);
ALTER TABLE Ventas
ALTER COLUMN [Monto_Vendido] DECIMAL(18,2);
ALTER TABLE Ventas
ALTER COLUMN [Precio] DECIMAL(18,2);
ALTER TABLE Ventas
ALTER COLUMN [Comision_Comercial] DECIMAL(18,2);

select top 1000 * from Ventas