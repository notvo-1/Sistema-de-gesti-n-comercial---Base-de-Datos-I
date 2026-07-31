USE gestion_comercio;
DROP PROCEDURE IF EXISTS insertar_codigo_barra;

DELIMITER //
CREATE PROCEDURE insertar_codigo_barra (IN cantidad INT, IN inicio INT)
	BEGIN 
		DECLARE i INT DEFAULT inicio;
        DECLARE id_tipo INT; -- id
        DECLARE valor VARCHAR(20);
        DECLARE fecha DATE;
        DECLARE ultimo_id INT; -- id
        DECLARE nombre_producto VARCHAR(50);
        DECLARE precio_producto DECIMAL (10,2);
        DECLARE peso_producto DOUBLE;
        DECLARE marca_producto INT; -- id
        DECLARE categoria_producto INT; -- id

        WHILE i < (inicio + cantidad) DO
        
			SET id_tipo = FLOOR(RAND()*3)+1; -- en la variable de entorno id_tipo asignamos al azar un int entre 1 y 3
			SET valor = CONCAT('PROD', LPAD(i,8,'0')); -- en valor, que va a ser el UNIQUE de cb creamos un string comenzando con PROD.
			-- LPAD crea un string de 8 (en este caso) caracteres completando de izquierda a derecha con '0' y al final pero dentro de 8: i
			-- PROD00000111
			INSERT INTO codigo_barras (eliminado, tipo_id, valor, fecha_asignacion) 
			VALUES (false, id_tipo, valor, NOW());
            
           -- Creamos los FK de productos __
			SET ultimo_id = LAST_INSERT_ID(); -- Es una funcion de SQL para llamar a la ultima insercion autoincremental de id que se hizo en este contexto.
            -- en nuestro caso es id_codigo. De otra manera deberiamos buscarlo con where y es mas lento
            SET marca_producto = FLOOR(RAND()*20 + 1);
            SET categoria_producto = FLOOR(RAND() * 10 + 1);
            
            -- Creamos las otros campos --
            SET nombre_producto = CONCAT('PRODUCTAZO',i); -- cremos el producto concatenando un string con el contador asi no hay repetidos
            SET precio_producto = ROUND(RAND() * 999 + 1, 2); -- rango entre 1 y 1000
			SET peso_producto = RAND()*10 + 1; -- tango entre 1 y 10
			
            INSERT INTO productos (eliminado, nombre_producto, marca_id, categoria_id, precio, peso, codigo_id)
            VALUES (false, nombre_producto,marca_producto, categoria_producto, precio_producto, peso_producto, ultimo_id );
        
            SET i = i +1; -- contador aumentando en cada iteracion
        END WHILE;
    END //
DELIMITER ;

CALL insertar_codigo_barra(10000, 1);
CALL insertar_codigo_barra(10000, 10001);
CALL insertar_codigo_barra(10000, 20001);
CALL insertar_codigo_barra(10000, 30001);
CALL insertar_codigo_barra(10000, 40001);
CALL insertar_codigo_barra(10000, 50001);
CALL insertar_codigo_barra(10000, 60001);
CALL insertar_codigo_barra(10000, 70001);
CALL insertar_codigo_barra(10000, 80001);
CALL insertar_codigo_barra(10000, 90001);
CALL insertar_codigo_barra(10000, 100001);
CALL insertar_codigo_barra(10000, 110001);
CALL insertar_codigo_barra(10000, 120001);
CALL insertar_codigo_barra(10000, 130001);
CALL insertar_codigo_barra(10000, 140001);
CALL insertar_codigo_barra(10000, 150001);
CALL insertar_codigo_barra(10000, 160001);
CALL insertar_codigo_barra(10000, 170001);
CALL insertar_codigo_barra(10000, 180001);
CALL insertar_codigo_barra(10000, 190001);
CALL insertar_codigo_barra(10000, 200001);
CALL insertar_codigo_barra(10000, 210001);
CALL insertar_codigo_barra(10000, 220001);
CALL insertar_codigo_barra(10000, 230001);
CALL insertar_codigo_barra(10000, 240001);
CALL insertar_codigo_barra(10000, 250001);
CALL insertar_codigo_barra(10000, 260001);
CALL insertar_codigo_barra(10000, 270001);
CALL insertar_codigo_barra(10000, 280001);
CALL insertar_codigo_barra(10000, 290001);
CALL insertar_codigo_barra(10000, 300001);
CALL insertar_codigo_barra(10000, 310001);
CALL insertar_codigo_barra(10000, 320001);
CALL insertar_codigo_barra(10000, 330001);
CALL insertar_codigo_barra(10000, 340001);
CALL insertar_codigo_barra(10000, 350001);
CALL insertar_codigo_barra(10000, 360001);
CALL insertar_codigo_barra(10000, 370001);
CALL insertar_codigo_barra(10000, 380001);
CALL insertar_codigo_barra(10000, 390001);
CALL insertar_codigo_barra(10000, 400001);
CALL insertar_codigo_barra(10000, 410001);
CALL insertar_codigo_barra(10000, 420001);
CALL insertar_codigo_barra(10000, 430001);
CALL insertar_codigo_barra(10000, 440001);
CALL insertar_codigo_barra(10000, 450001);
CALL insertar_codigo_barra(10000, 460001);
CALL insertar_codigo_barra(10000, 470001);
CALL insertar_codigo_barra(10000, 480001);
CALL insertar_codigo_barra(10000, 490001);
CALL insertar_codigo_barra(10000, 500001);



SELECT COUNT(*) from productos;
SELECT COUNT(*) FROM codigo_barras;