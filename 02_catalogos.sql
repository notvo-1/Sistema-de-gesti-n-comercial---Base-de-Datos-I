USE gestion_comercio;
## inserts para las tablas auxiliares ##

-- Marcas

INSERT INTO marcas (nombre_marca, logo) VALUES 
( 'Samsung', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Samsung_old_logo_before_year_2015.svg/2560px-Samsung_old_logo_before_year_2015.svg.png'), -- 1
('LG',''), -- 2
('Sony',''), -- 3
('Apple',''), -- 4
('HP',''), -- 5
('DELL',''), -- 6
('LENOVO',''), -- 7
('PHILIPS',''), -- 8
('Whirlpool',''), -- 9
('Electrolux',''), -- 10 
('Bosch',''),  -- 11
('Drean',''), -- 12
('Gafa',''), -- 13
('Liliana',''), -- 14
('Mourix',''), -- 15
('Oster',''), -- 16
('Moulinex',''), -- 17
('Nespresso',''), -- 18
('GA.MA',''), -- 19
('JBL',''); -- 20

-- Categorias

INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Celulares','smartphones, accesorios, cargadores'),
('Computación','Notebook, PC escritorio, perifericos, componentes de pc'),
('Televisores','Televisores y accesorios para televisores'),
('Audio','Parlantes, sistemas de sonido para el hogar, auriculares'),
('Linea Blanca','Grandes electrodomesticos para el hogar: lavarropas, cocinas, heladeras, etc'),
('Pequeños Electrodomésticos','Microondas, cafeteras, licuadoras, tostadoras, etc'),
('Climatización','Aires acondicionados, ventiladores, humidificadores, etc'),
('Cuidado Personal','Afeitadoras, depiladoras, secadoras, planchitas, etc'),
('Consolas','Consolas de video juegos'),
('Herramientas y jardineria','Herramientas de trabajo, cortadoras de cesped, bordeadoras, etc');

-- tipo de codigo de barras

INSERT INTO tipo_codigo_barras (nombre, descripcion) VALUES
('EAN13', 'European Article Number de 13 dígitos'),
('EAN8', 'European Article Number de 8 dígitos'),
('UPC', 'Universal Product Code');
