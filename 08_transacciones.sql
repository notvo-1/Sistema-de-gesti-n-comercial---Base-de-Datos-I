USE gestion_comercio;

-- Comenzamos dando permisos al usuario 'vendedor' para que pueda realizas transacciones desde su lado.
GRANT SELECT, UPDATE ON gestion_comercio.productos TO 'vendedor'@'localhost';
SHOW GRANTS FOR 'vendedor'@'localhost';

-- Para que podamos demostrar un deadlock vamos usar transacciones no commiteadas para que queden abiertas. 

START TRANSACTION;
UPDATE productos SET precio = precio + 10 WHERE producto_id = 1;
-- no commit para que quede abierto 
-- en este momento vamos a realizar una consulta sobre el id = 2 que es la transaccion abierta desde usuario 
UPDATE productos SET precio = precio + 5 WHERE producto_id = 2;
COMMIT;
-- resultado de la consulta: Error Code: 1213. Deadlock found when trying to get lock; try restarting transaction	0.015 sec

SELECT @@GLOBAL.tx_isolation, @@SESSION.tx_isolation; 


-- -----------------------------------------------------------------
-- SCRIPT PARA EJECUTAR EN SESIÓN 2 (Usuario 'vendedor')
-- Y PROVOCAR EL DEADLOCK
-- -----------------------------------------------------------------
-- START TRANSACTION;
-- UPDATE productos SET precio = 100 WHERE producto_id = 2;
-- -- no commitear, ejecutar hasta acá y volver a sesión 1
--
-- -- Ejecutar después de que la sesión 1 intente el update sobre id=2
-- UPDATE productos SET precio = precio + 8 WHERE producto_id = 1;  
-- -----------------------------------------------------------------