USE gestion_comercio;

CREATE INDEX idx_productos_nombre ON productos(nombre_producto);
CREATE INDEX idx_productos_eliminado_nombre ON productos(eliminado, nombre_producto);
CREATE INDEX idx_codigo_barras_tipo_id ON codigo_barras(tipo_id);
CREATE INDEX idx_productos_precios ON productos(precio);
CREATE INDEX idx_productos_precio_eliminado_1 ON productos(precio, eliminado);