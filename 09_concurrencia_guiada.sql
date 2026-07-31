USE gestion_comercio;

-- •Implementar en Java o en SQL (procedimiento almacenado) un ejemplo de transacciones con START TRANSACTION/COMMIT/ROLLBACK y logging de errores. Si hay deadlock (1213/SQLSTATE 40001), aplicar retry hasta 2 reintentos con backoff breve.

-- vamos a crear el procedure con backoff progresivo
DROP PROCEDURE actualizar_precio_por_id;
DELIMITER $$
CREATE PROCEDURE actualizar_precio_por_id (IN precio_nuevo decimal(10,2), IN id INT)

	BEGIN
        DECLARE contador INT DEFAULT 1;
        DECLARE realizado INT DEFAULT 0;
        
        WHILE contador <= 3 AND realizado = 0 DO
			BEGIN
				DECLARE EXIT HANDLER FOR 1213 ,1205, 1216  -- deadlock
				BEGIN
					SET contador = contador + 1;
                    SELECT CONCAT('Deadlock capturado, contador ahora: ', contador) AS debug;
					IF contador <= 3 THEN
						DO SLEEP(0.1 * contador); 
					END IF;
				END; 
			START TRANSACTION;
				UPDATE productos SET precio = precio_nuevo WHERE producto_id = id;
				SET realizado = 1;
            COMMIT;
            END;
		END WHILE;
        IF realizado = 1 THEN
			SELECT 'Actualización exitosa' AS resultado;
		ELSE
			SELECT 'Error: Falló después de 3 intentos' AS resultado;
		END IF;
    END $$
DELIMITER ;

GRANT EXECUTE ON PROCEDURE actualizar_precio_por_id TO 'vendedor'@'localhost';
-- --------------------------------------------------------------------------------------
-- Para producir la excepcion 1205 por tiempo de espera
SET SESSION innodb_lock_wait_timeout = 3; -- setear el tiempo 
-- Luego abrimos una transaccion en 'vendedor' uptadeando id=2;
CALL actualizar_precio_por_id(12,2); -- llamamos al procedimiento


SELECT * FROM information_schema.INNODB_TRX; -- vemos transacciones activas
KILL 9; -- para matar transacciones buggeadas


-- •Comparar en la práctica 2 niveles de aislamiento (ej. READ COMMITTED y REPEATABLE READ) mostrando diferencias con ejemplos simples (basta con un ejemplo breve que muestre una diferencia observable; no se requiere análisis de phantoms ni next-key locks).
-- comenzamos probando read commited para lecturas no repetidas
-- para comenzar usamos hacemos una consulta a un id cualquiera, en este caso 5
UPDATE productos SET precio = 815.82 where producto_id = 5;

SELECT precio FROM productos WHERE producto_id = 5; -- devuelve 815.82

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT precio FROM productos WHERE producto_id = 5; -- primero ejecutamos la transaccion solo hasta esta consulta sin cerrarla y vamos a 'vendedor' para hacer la otra transaccion
-- aca nos devuelve 815.82 como en la prueba control
-- no commiteada
COMMIT; -- Luego ejecutamos desde el select hasta el commit y vemos que esta vez nos devuelve 915.82 que es el valor modificaco por la transaccion en s2

-- Ahora probamos con REPEATABLE READ
UPDATE productos SET precio = 815.82 where producto_id = 5; -- devolvemos el producto a su precio original
SELECT precio FROM productos WHERE producto_id = 5; -- devuelve 815.82 nuevamente
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION; -- en ese caso nos usamos el nivel de aislamiento REPEATABLE READ. Viene por defecto pero para claridad usamos SET.
SELECT precio FROM productos WHERE producto_id = 5; -- hacemos el mismo proceso y ejectuamos la transaccion hasta aca y vamos a s2 a ejecutar la transaccion
-- leemos 815.82
COMMIT;