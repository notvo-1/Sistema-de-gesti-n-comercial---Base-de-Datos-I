USE gestion_comercio;
-- • Crear un usuario con privilegios mínimos y mostrar pruebas de acceso restringido.
DROP USER 'vendedor'@'localhost';
CREATE USER 'vendedor'@'localhost' IDENTIFIED BY '123456'; -- el usuario nuevo por defecto nace con permisos minimos
SHOW GRANTS FOR 'vendedor'@'localhost'; -- lo verificamos 

-- Otorgamos acceso al usuario a las vistas.
GRANT SELECT ON productos_ultimos_30_dias_vendedor TO 'vendedor'@'localhost';
GRANT SELECT ON celulares_disponibles_vendedor TO 'vendedor'@'localhost';
SHOW GRANTS FOR 'vendedor'@'localhost'; -- lo verificamos 

-- • Ejecutar al menos 2 pruebas de integridad (ej. duplicación de PK, inserción fuera de rango, violación de FK).

-- Insert en un producto con marca_id que no existe
INSERT INTO productos (eliminado, nombre_producto, marca_id, categoria_id, precio, codigo_id) 
VALUES (false, 'Producto Test FK', 999, 1, 100.00, 1);
-- Error Code: 4025. CONSTRAINT `productos.marca_id` failed for `gestion_comercio`.`productos`	0.000 sec


-- Intento duplicar un valor único en codigo_barras
INSERT INTO codigo_barras (eliminado, tipo_id, valor, fecha_asignacion) 
VALUES (false, 1, 'PROD00000001', CURDATE());
-- Error Code: 1062. Duplicate entry 'PROD00000001' for key 'valor'	0.016 sec

-- Intentamos precio negativo
INSERT INTO productos (eliminado, nombre_producto, marca_id, categoria_id, precio, codigo_id) 
VALUES (false, 'Producto Precio Negativo', 1, 1, -50.00, 2);
-- Error Code: 4025. CONSTRAINT `productos.precio` failed for `gestion_comercio`.`productos`	0.000 sec

-- Intentar duplicar PK (usando INSERT IGNORE o similar)
INSERT INTO marcas (marca_id, nombre_marca) 
VALUES (1, 'Marca Duplicada');
-- Error Code: 1062. Duplicate entry '1' for key 'PRIMARY'	0.000 sec


-- 
SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'gestion_comercio';


-- • Implementar una consulta segura  en SQL mediante procedimiento almacenado sin SQL dinámico;

DELIMITER $$
CREATE PROCEDURE consultar_precio_producto(IN ID INT)
	BEGIN
		SELECT
			p.producto_id as ID,
            p.nombre_producto as Producto,
            c.valor as Codigo_Barra,
            m.nombre_marca as Marca,
            cat.nombre_categoria as Categoria,
			CONCAT('$',p.precio) as Precio
		FROM productos as p
        INNER JOIN codigo_barras as c ON c.codigo_id = p.codigo_id
        INNER JOIN marcas as m ON m.marca_id = p.marca_id
        INNER JOIN categorias as cat ON cat.categoria_id = p.categoria_id
        WHERE p.eliminado = false
        AND c.eliminado = false
        AND p.producto_id = ID;
    END $$
DELIMITER ;

GRANT EXECUTE ON PROCEDURE consultar_precio_producto TO 'vendedor'@'localhost';
Select * from productos where producto_id = 4;

SHOW GRANTS FOR 'vendedor'@'localhost';

-- quitar todos los accesos 

REVOKE SELECT ON gestion_comercio.celulares_disponibles_vendedor FROM 'vendedor'@'localhost';
REVOKE SELECT ON gestion_comercio.productos_ultimos_30_dias_vendedor FROM 'vendedor'@'localhost';
REVOKE EXECUTE ON PROCEDURE gestion_comercio.consultar_precio_producto FROM 'vendedor'@'localhost';
REVOKE SELECT, UPDATE ON gestion_comercio.productos FROM 'vendedor'@'localhost';
REVOKE EXECUTE ON PROCEDURE gestion_comercio.actualizar_precio_por_id FROM 'vendedor'@'localhost';


CALL consultar_precio_producto('1 UNION SELECT * FROM usuarios');
CALL consultar_precio_producto('1; DROP TABLE productos;');