# Sistema-de-gesti-n-comercial---Base-de-Datos-I
Repositorio de la materia Base de Datos I

Archivos del TFI de Bases de Datos I.
Grupo 126 - Orellana, Gómez, Galván, Pagola.

Orden de ejecución recomendado:
1. 01_esquema.sql (Crea la base de datos y todas las tablas)
2. 02_catalogos.sql (Inserta datos maestros en marcas, categorias, etc.)
3. 03_carga_masiva.sql (Puebla la base con 510,000 registros. Este script puede tardar varios minutos en completarse.)
4. 04_indices.sql (Crea los índices para las pruebas de rendimiento)
5. 05_consultas.sql (Consultas de la Etapa 3)
6. 05_explain.sql (Pruebas de rendimiento de la Etapa 3)
7. 06_vistas.sql (Creación de vistas de Etapas 3 y 4)
8. 07_seguridad.sql (Creación de usuario, SP seguro, pruebas de integridad)
9. 08_transacciones.sql (Script para Sesión 1 de la simulación de deadlock)
10. 09_concurrencia_guiada.sql (SP con retry y pruebas de aislamiento)

Entorno de prueba:
SGBD: MariaDB Server v10.4.32
Cliente: MySQL Workbench v8.0.43
