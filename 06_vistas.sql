USE gestion_comercio;

####### Vista Util ######

-- La utilidad de esta vista recide en poder acceder sin demora el estado de los productos apple que hay en disponibilidad sin tener que crear la consulta cada vez.
-- es un activo estrategico el acceso a la vista porque son productos de gama alta y con gran movimiento actualmente que requieren consultas frecuentes. 
DROP VIEW IF EXISTS productos_apple_disponibles;
CREATE VIEW productos_apple_disponibles AS 
SELECT 
	m.nombre_marca as Marca,
	cat.nombre_categoria as Categoria,
    COUNT(*) as Cantidad,
	p.nombre_producto as Producto,
    c.valor as CODIGO    
FROM productos as p
JOIN codigo_barras as c ON p.codigo_id = c.codigo_id
JOIN marcas as m ON m.marca_id = p.marca_id
JOIN categorias as cat ON cat.categoria_id = p.categoria_id
WHERE m.nombre_marca LIKE 'Apple'
AND p.eliminado = false
GROUP BY Categoria;

SELECT * FROM productos_apple_disponibles ORDER BY Cantidad;


-- vista 1 donde solo mostramos los productos y los datos relacionados con el rol vendedor:
-- id producto, nombre, marca y categoria pero no precio, eso lo diseñamos para una consulta puntual. No mostramos datos relacionados con el codigo de barra o los tipos de estos.
-- Tambien ocultamos informacion sobre los productos dados de baja, solo mostramos los eliminados = false.
DROP VIEW IF EXISTS celulares_disponibles_vendedor;

CREATE VIEW celulares_disponibles_vendedor AS
SELECT
	p.producto_id as ID_Prod,
	p.nombre_producto as Producto,
    m.nombre_marca as Marca,
    cat.nombre_categoria as Categoria    
FROM productos as p
INNER JOIN marcas as m ON m.marca_id = p.marca_id
INNER JOIN categorias as cat ON cat.categoria_id = p.categoria_id
WHERE p.eliminado = false
AND cat.categoria_id = 1
AND m.marca_id IN (1,3,4);

SELECT * from celulares_disponibles_vendedor order by Marca ASC;


-- vista 2 
-- Agregar variación de fechas para prueba
UPDATE codigo_barras 
SET fecha_asignacion = CURDATE() - INTERVAL FLOOR(RAND() * 60) DAY
WHERE codigo_id BETWEEN 1 AND 5000;

DROP VIEW IF EXISTS productos_ultimos_30_dias_vendedor;
CREATE VIEW productos_ultimos_30_dias_vendedor AS
SELECT
	p.producto_id as ID_Prod,
    p.nombre_producto as Producto,
    m.nombre_marca as Marca,
    cat.nombre_categoria as Categoria,
    c.fecha_asignacion as Fecha_Carga
FROM productos as p
INNER JOIN marcas as m ON m.marca_id = p.marca_id
INNER JOIN categorias as cat ON cat.categoria_id = p.categoria_id
INNER JOIN codigo_barras as c ON c.codigo_id = p.codigo_id
WHERE p.eliminado = false
AND c.fecha_asignacion >= curdate() - INTERVAL 30 DAY;

SELECT * FROM productos_ultimos_30_dias_vendedor order by Fecha_Carga DESC;    

-- Garantizamos acceso al usuario a las vistas.
GRANT SELECT ON productos_ultimos_30_dias_vendedor TO 'vendedor'@'localhost';
GRANT SELECT ON celulares_disponibles_vendedor TO 'vendedor'@'localhost';