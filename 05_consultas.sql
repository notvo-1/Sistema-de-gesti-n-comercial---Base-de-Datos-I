USE gestion_comercio;

    #Consulta 1
    -- La utilidad de esta consulta para el negocio radica en poder presentar una lista de los productos su codigo de barra,
    -- su marca, categoria y precio. Podemos obtener una vista general sobre el producto y filtrar solo modificando el where dependiendo
    -- de si necesitamos que la busqueda sea mas especifica a marcas, precios, categorias o un rango de codigos de barra. 
SELECT 
	p.nombre_producto as Nombre,
    c.valor as Codigo_Barra,
    m.nombre_marca, 
    cat.nombre_categoria, 
    p.precio as Precio 
FROM productos as p
JOIN codigo_barras as c
ON p.codigo_id = c.codigo_id
JOIN marcas as m 
ON p.marca_id = m.marca_id
JOIN categorias as cat
ON p.categoria_id = cat.categoria_id
WHERE p.eliminado = false AND c.eliminado = false
ORDER BY p.nombre_producto ASC;

	#Consulta 2
-- Consulta para evaluar la precencia de referencias NULL y validar la integridad del sistema. 
-- A fines de que sea apreciable limitamos la consulta por tipo de codigo de barra 
-- y agregamos un contadore para ver el total de registros de la consulta. 

SELECT 
	p.nombre_producto as Producto,
    c.valor as Codigo_Barra,
    t.nombre as Tipo_Codigo,
    COUNT(*) OVER() as TOTAL -- over evita que se unifique la cuenta en una sola fila y la agrega como una columna nueva en cada tupla
FROM productos as p
LEFT JOIN codigo_barras as c
ON p.codigo_id = c.codigo_id
LEFT JOIN tipo_codigo_barras as t
ON c.tipo_id = t.tipo_id
WHERE p.eliminado = false 
and c.eliminado = false
AND c.tipo_id = 1
ORDER BY p.nombre_producto;

	#consulta 3
-- En esta cosulta utilizamos GROUP BY + HAVING y realizamos 2 consultar 1 para obtener las marcas que en promedio tengan productos mas caros
-- la importancia en el negocio para esto es en detectar productos de gama alta o productos muy caros sin ser de gama alta que podamos aplicarle una promocion o descuento    
-- por otro lado en la seguda consulta simplemente cambiamos el valor y el operador logico de having para obtener marcas de productos de gama baja respecto a precios
-- la importancia en el negocio es para detectar que marcas son mas economicas y en que valor oscilan para entender como ofertarlas o diseñar una estrategia de negocio
-- en funcion de estas. 
SELECT 
    m.nombre_marca as Marca,
    COUNT(*) as cantidad_productos,
    AVG(p.precio) as precio_promedio
FROM marcas as m
JOIN productos as p ON p.marca_id = m.marca_id
WHERE p.eliminado = false
GROUP BY m.nombre_marca
HAVING AVG(p.precio) > 750;

SELECT 
    m.nombre_marca as Marca,
    COUNT(*) as cantidad_productos,
    AVG(p.precio) as precio_promedio
FROM marcas as m
JOIN productos as p ON p.marca_id = m.marca_id
WHERE p.eliminado = false
GROUP BY m.nombre_marca
HAVING AVG(p.precio) < 400;

 #Consulta 4
 
-- EN esta consulta realizamos una operacion del tipo analica para lograr representar la cantidad relativa de productos por marcas y ademas mostrar una frecuencia acumulada
-- de esta frecuencia relativa a fines de poder realizar analisis respecto a la distribucion de los productos de stock y la cantidad por marca. 


SELECT 
    m.nombre_marca as Marca,
    COUNT(*) as Cant_Prod,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM productos WHERE eliminado = false), 2), '%') as Porcentaje,
    CONCAT(ROUND(SUM(COUNT(*)) OVER(ORDER BY COUNT(*) ASC) * 100.0 / (SELECT COUNT(*) FROM productos WHERE eliminado = false), 2), '%') as Frecuencia_Acumulada
FROM marcas as m
JOIN productos as p ON p.marca_id = m.marca_id
WHERE p.eliminado = false
GROUP BY m.nombre_marca
ORDER BY Porcentaje ASC;

SELECT COUNT(*) FROM productos WHERE eliminado = false;

# Validar FK Huérfanas

# Si devuelve algún valor NULL quiere decir que hay un producto con una 
# marca que no se encuentra en la tabla marcas
SELECT COUNT(p.producto_id) AS FK_marca_id_huerfana
FROM productos p
LEFT JOIN marcas m ON p.marca_id = m.marca_id
WHERE m.marca_id IS NULL;



# Si devuelve algún valor NULL quiere decir que hay un producto con una 
# categoria_id que no se encuentra en la tabla categorias
SELECT COUNT(p.producto_id) AS FK_categoria_id_huerfana
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.categoria_id
WHERE c.categoria_id IS NULL;


# Si devuelve algún valor NULL quiere decir que hay un producto con una 
# codigo_id que no se encuentra en la tabla codigo_barras
SELECT COUNT(p.producto_id) AS FK_codigo_barras_huerfana
FROM productos p
LEFT JOIN codigo_barras cb ON p.codigo_id = cb.codigo_id
WHERE cb.codigo_id IS NULL;


# Si devuelve algún valor NULL quiere decir que hay un codigo de barras con un
# tipo_id que no se encuentra en la tabla tipo_codigo_barras
SELECT COUNT(cb.codigo_id) AS FK_tipo_id_huerfana
FROM codigo_barras cb
LEFT JOIN tipo_codigo_barras tcb ON cb.tipo_id = tcb.tipo_id
WHERE tcb.tipo_id IS NULL;
