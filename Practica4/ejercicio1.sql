1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI
    SELECT nombre, apellido, DNI, telefono, direccion 
    FROM Cliente 
    WHERE (apellido LIKE "Pe%")
    ORDER BY DNI 


2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente
durante 2017.
    SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion 
    FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    WHERE (f.fecha BETWEEN "2017-01-01" AND "2017-12-31") AND c.idCliente NOT IN (
        SELECT c1.idCliente
        FROM Factura f1 ON 
        WHERE (f1.fecha < "2017-01-01" OR f1.fecha > "2017-12-31")
    )


3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
pero que no fueron vendidos a clientes de apellido ‘Garcia’.
    SELECT DISTINCT p.nombre, p.descripcion, p.precio, p.stock 
    FROM Producto p 
    INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
    INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
    WHERE c.DNI = 45789456 AND p.idProducto NOT IN (
        SELECT p1.idProducto  
        FROM Producto p1 
        INNER JOIN Detalle d1 ON (p1.idProducto = d1.idProducto)
        INNER JOIN Factura f1 ON (d1.nroTicket = f1.nroTicket)
        INNER JOIN Cliente c1 ON (f1.idCliente = c1.idCliente)
        WHERE c.apellido = 'Garcia'
    )

        /*Utilizo el distinct para evitar duplicados en los resultados ya que 
        un producto puede aparecer en multiples facturas*/


4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
nombre.

    SELECT DISTINCT p.nombreP, p.descripcion, p.precio, p.stock 
    FROM Producto p 
    WHERE p.idProducto NOT IN (
        SELECT d.idProducto
        FROM Detalle d 
        INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
        INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
        WHERE (c.telefono  LIKE '221%')
    ) ORDER BY p.nombreP


5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
cuenta que puede no haberse vendido nunca el producto.

    SELECT p.nombreP, p.descripcion, p.precio, COUNT (p.idProducto)
    FROM Producto p 
    LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
    GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio


6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’.

    SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion 
    FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
    WHERE c.idCliente IN (
        SELECT c1.idCliente 
        FROM Cliente c1
        INNER JOIN Factura f1 ON (c1.idCliente = f1.idCliente)
        INNER JOIN Detalle d1 ON (f1.nroTicket = d1.nroTicket)
        INNER JOIN Producto p1 ON (d1.idProducto = p1.idProducto)
        WHERE nombreP = 'prod1' 
        ) AND c.idCliente  IN (
            SELECT c2.idCliente 
            FROM Cliente c2 
            INNER JOIN Factura f2 ON (c2.idCliente = f2.idCliente)
            INNER JOIN Detalle d2 ON (f2.nroTicket = d2.nroTicket)
            INNER JOIN Producto p2 ON (d2.idProducto = p2.idProducto)
            WHERE nombreP = 'prod2'
            ) AND c.idCliente  NOT IN (
                SELECT c2.idCliente 
                FROM Cliente c2 
                INNER JOIN Factura f2 ON (c2.idCliente = f2.idCliente)
                INNER JOIN Detalle d2 ON (f2.nroTicket = d2.nroTicket)
                INNER JOIN Producto p2 ON (d2.idProducto = p2.idProducto)
                WHERE nombreP = 'prod3'
                )
    

7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2019.

    SELECT DISTINCT f.nroTicket, f.total, f.fecha, f.hora, c.DNI 
    FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
    WHERE (p.nombreP = 'prod38') OR (f.fecha BETWEEN '2019-01-01' AND '2019-12-31')


8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
500002. Se supone que el idCliente 500002 no existe.

    INSERT INTO Cliente (idCliente, nombre, apellido, DNI, telefono, direccion) VALUES (500002, 'Jorge Luis', 'Castor', 40578999, '221-4400789', '11 entre 500 y 501 nro:2587')


9. Listar nroTicket, total, fecha, hora para las facturas del cliente  ́Jorge Pérez ́ donde no haya
comprado el producto  'z'.

    SELECT f.nroTicket, f.total, f.fecha, f.hora 
    FROM Factura f 
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
    WHERE c.nombre = 'Jorge Pérez' AND f.nroTicket NOT IN (
        SELECT d.nroTicket 
        FROM Detalle d 
        INNER JOIN Producto p ON (d.idProducto = p.idProducto)
        WHERE p.nombreP = 'Z'
    )


10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
todas sus facturas, supere $10.000.000. 

    SELECT c.DNI, c.apellido, c.nombre 
    FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    GROUP BY c.idCliente, c.nombre, c.apellido, c.DNI 
    HAVING SUM (f.total) > 10.000.000

/*Cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
Factura (nroTicket, total, fecha, hora, idCliente (fk))
Detalle (nroTicket (fk), idProducto (fk), cantidad, preciounitario)
Producto (idProducto, nombreP, descripcion, precio, stock)