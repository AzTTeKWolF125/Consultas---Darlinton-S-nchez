-- CONSULTAS PARA BASE DE DATOS JARDINERIA

-- 1. Información básica de oficinas
SELECT codigo_oficina, ciudad, pais, telefono 
FROM oficina;

-- 2. Empleados por oficina
SELECT codigo_oficina, nombre, apellido1, puesto 
FROM empleado 
ORDER BY codigo_oficina;

-- 3. Promedio límite crédito por región
SELECT region, AVG(limite_credito) AS promedio_credito 
FROM cliente 
GROUP BY region;

-- 4. Clientes con representantes
SELECT c.nombre_cliente, CONCAT(e.nombre, ' ', e.apellido1) AS representante
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 5. Productos disponibles
SELECT codigo_producto, nombre, cantidad_en_stock 
FROM producto 
WHERE cantidad_en_stock > 0;

-- 6. Productos con precio bajo el promedio
SELECT * 
FROM producto 
WHERE precio_venta < (SELECT AVG(precio_venta) FROM producto);

-- 7. Pedidos pendientes
SELECT p.codigo_pedido, p.estado, c.nombre_cliente
FROM pedido p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
WHERE p.estado <> 'Entregado';

-- 8. Total productos por gama
SELECT gama, COUNT(*) AS total_productos 
FROM producto 
GROUP BY gama;

-- 9. Ingresos por cliente
SELECT c.nombre_cliente, SUM(p.total) AS ingresos_totales
FROM pago p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.nombre_cliente;

-- 10. Pedidos por rango de fechas
SELECT codigo_pedido, fecha_pedido
FROM pedido
WHERE fecha_pedido BETWEEN '2023-01-01' AND '2023-12-31';

-- 11. Detalles de un pedido
SELECT dp.codigo_pedido, dp.codigo_producto, dp.cantidad, dp.precio_unidad,
       (dp.cantidad * dp.precio_unidad) AS total_linea
FROM detalle_pedido dp
WHERE dp.codigo_pedido = 1;

-- 12. Productos más vendidos
SELECT dp.codigo_producto, SUM(dp.cantidad) AS total_vendido
FROM detalle_pedido dp
GROUP BY dp.codigo_producto
ORDER BY total_vendido DESC;

-- 13. Pedidos con valor mayor al promedio
SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS total
FROM detalle_pedido
GROUP BY codigo_pedido
HAVING total > (
    SELECT AVG(cantidad * precio_unidad) 
    FROM detalle_pedido
);

-- 14. Clientes sin representante
SELECT * 
FROM cliente 
WHERE codigo_empleado_rep_ventas IS NULL;

-- 15. Total empleados por oficina
SELECT codigo_oficina, COUNT(*) AS total_empleados
FROM empleado 
GROUP BY codigo_oficina;

-- 16. Pagos por forma específica
SELECT * 
FROM pago 
WHERE forma_pago = 'Tarjeta de Crédito';

-- 17. Ingresos mensuales
SELECT MONTH(fecha_pago) AS mes, SUM(total) AS ingresos
FROM pago 
GROUP BY mes;

-- 18. Clientes con múltiples pedidos
SELECT c.nombre_cliente, COUNT(*) AS total_pedidos
FROM pedido p
JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.nombre_cliente
HAVING total_pedidos > 1;

-- 19. Pedidos con productos agotados
SELECT DISTINCT dp.codigo_pedido
FROM detalle_pedido dp
JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
WHERE pr.cantidad_en_stock = 0;

-- 20. Promedio, máximo y mínimo límite crédito por país
SELECT pais, AVG(limite_credito), MAX(limite_credito), MIN(limite_credito)
FROM cliente 
GROUP BY pais;

-- 21. Historial de pagos de un cliente
SELECT fecha_pago, total, forma_pago 
FROM pago 
WHERE codigo_cliente = 1;

-- 22. Empleados sin jefe
SELECT * 
FROM empleado 
WHERE codigo_jefe IS NULL;

-- 23. Productos con precio superior al promedio de su gama
SELECT p.*
FROM producto p
JOIN (
    SELECT gama, AVG(precio_venta) AS prom
    FROM producto
    GROUP BY gama
) x ON p.gama = x.gama
WHERE p.precio_venta > x.prom;

-- 24. Promedio días entrega por estado
SELECT estado,
       AVG(DATEDIFF(fecha_entrega, fecha_pedido)) AS promedio_dias
FROM pedido 
GROUP BY estado;

-- 25. Países con clientes que tienen más de un pedido
SELECT c.pais, COUNT(*) AS clientes_con_multiples
FROM cliente c
JOIN (
    SELECT codigo_cliente
    FROM pedido
    GROUP BY codigo_cliente
    HAVING COUNT(*) > 1
) x ON c.codigo_cliente = x.codigo_cliente
GROUP BY c.pais;
