USE gestion_comercio;

##### medicion comparatica con y sin indice ####

-- vamos a trabajar con la primer cosulta

	-- ejecutamos la consulta y medimos la duracion que nos da worckbench sin indice : 
    -- resultado 1: 16:30:45	116612 row(s) returned	3.234 sec 
    -- resultado 2: 16:34:09	116612 row(s) returned	3.828 sec 
    -- resultado 3: 16:34:48	116612 row(s) returned	3.843 sec 

-- Resultados con indice
	-- resultado 1: 16:36:07	116612 row(s) returned	3.875 sec 
    -- resultado 2: 16:36:33	116612 row(s) returned	3.718 sec 
    -- resultado 3: 16:36:52	116612 row(s) returned	3.890 sec
-- en esta primera ejecucion solo con el indice en nombre_producto no vemos un cambio porque probablemente el cuello de botella que "retrasa" la consulta no es exclusivamente 
-- el campo nombre_producto por eso aplicamos un indice compuesto por nombre_producto y eliminados (tambien un valor que se evalua) de la tabla productos para ver que sucede. 


-- Resultados con indice compuesto
	-- resultado 1: 16:38:47 116612 row(s) returned	3.110 sec
    -- resultado 2: 16:36:33 116612 row(s) returned	3.375 sec
    -- resultado 3: 16:36:52 116612 row(s) returned	3.062 sec
    
-- en este caso vemos un cambio notable al rededor del 20% de mejora en el tiempo de consulta. Entonces la premisa de que el factor limitante no era solamente nombre_producto
-- resulto cierta. 

EXPLAIN SELECT 
	p.nombre_producto as Producto,
    c.valor as Codigo_Barra,
    t.nombre as Tipo_Codigo,
    COUNT(*) OVER() as TOTAL 
FROM productos as p
LEFT JOIN codigo_barras as c
ON p.codigo_id = c.codigo_id
LEFT JOIN tipo_codigo_barras as t
ON c.tipo_id = t.tipo_id
WHERE p.eliminado = false 
and c.eliminado = false
AND c.tipo_id = 1
ORDER BY p.nombre_producto DESC;
    
DROP INDEX idx_productos_nombre ON productos;
DROP INDEX idx_productos_eliminado_nombre ON productos;
CREATE INDEX idx_productos_nombre ON productos(nombre_producto);
CREATE INDEX idx_productos_eliminado_nombre ON productos(eliminado, nombre_producto);
CREATE INDEX idx_codigo_barras_tipo_id ON codigo_barras(tipo_id);


-- Consulta con Where
	-- ejecutamos la consulta sin indice : 
    -- resultado 1: 22:58:21	1.844 sec 
    -- resultado 2: 22:58:58	2.204 sec  
    -- resultado 3: 22:59:01	2.312 sec 

-- Resultados con indice
	-- resultado 1: 23:01:56	0.016 sec  
    -- resultado 2: 23:01:58	0.000 sec  
    -- resultado 3: 23:01:59	0.000 sec  
EXPLAIN SELECT * FROM productos 
WHERE precio = 399  -- Apple
AND eliminado = false;    

CREATE INDEX idx_productos_precios ON productos(precio);
DROP INDEX idx_productos_precios ON productos;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
-- Consulta con BETWEEN 
	-- ejecutamos la consulta sin indice : 
    -- resultado 1: 23:17:30	0.234 sec  
    -- resultado 2: 23:17:47	0.250 sec   
    -- resultado 3: 23:17:48	0.266 sec  

-- Resultados con indice
	-- resultado 1: 23:20:34	0.000 sec   
    -- resultado 2: 23:20:35	0.000 sec   
    -- resultado 3: 23:20:36	0.000 sec   
EXPLAIN SELECT * FROM productos
WHERE precio BETWEEN 300.10 AND 300.15
AND eliminado = false;

CREATE INDEX idx_productos_precio_eliminado_1 ON productos(precio, eliminado);