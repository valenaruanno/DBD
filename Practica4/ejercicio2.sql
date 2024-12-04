1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
el podador ‘Jose Garcia’.

    SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL 
    FROM Localidad l INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
    INNER JOIN Poda p ON (a.nroArbol = p.nroArbol)
    INNER JOIN Podador po ON (p.DNI = po.DNI)
    WHERE po.nombre = 'Juan' AND po.apellido = 'Perez' AND a.nroArbol IN (
        SELECT p1.nroArbol
        FROM Poda p1 INNER JOIN Podador po1 ON (p1.DNI = po1.DNI)
        WHERE po1.nombre = 'Jose' AND po1.apellido = 'Garcia'
    )


2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores que tengan podas realizadas durante 2023.

    SELECT po.DNI, po.nombre, po.apellido, po.fnac, l.nombreL 
    FROM Localidad l INNER JOIN Podador po ON (l.codigoPostal = po.codigoPostalVive)
    WHERE po.DNI IN (
        SELECT p.DNI 
        FROM Poda p 
        WHERE (p.fecha BETWEEN '2023-01-01' AND '2023-12-31')
    )


3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.

    SELECT a.especie, a.años, a.calle, a.nro, l.nombreL 
    FROM Localidad l INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
    WHERE a.nroArbol NOT IN (
        SELECT po.nroArbol 
        FROM Poda po 
    )


4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y no
fueron podados durante 2023.

    SELECT a.especie, a.años, a.calle, a.nro, l.nombreL 
    FROM Localidad l INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
    INNER JOIN Poda p ON (a.nroArbol = p.nroArbol)
    WHERE (p.fecha BETWEEN '2022-01-01' AND '2022-12-31') AND a.nroArbol NOT IN (
        SELECT p1.nroArbol 
        FROM Poda p1 
        WHERE (p1.fecha BETWEEN '2023-01-01' AND '2023-12-31')
    )


5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
2024. Ordenar por apellido y nombre.

    SELECT po.DNI, po.nombre, po.apellido, po.fnac, l.nombreL 
    FROM Localidad l INNER JOIN Podador po ON (l.codigoPostal = po.codigoPostalVive)
    WHERE (po.apellido LIKE '%ata') AND po.DNI IN (
        SELECT p.DNI 
        FROM Poda p 
        WHERE (p.fecha BETWEEN '2024-01-01' AND '2024-12-31')
    ) ORDER BY po.nombre, po.apellido 


6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
árboles de especie ‘Coníferas.

    SELECT po.DNI, po.apellido, po.nombre, po.telefono, po.fnac 
    FROM Podador po INNER JOIN Poda p ON (po.DNI = p.DNI)
    INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol)
    WHERE (a.especia = 'Coniferas')
    EXCEPT (
        SELECT po1.DNI, po1.apellido, po1.nombre, po1.telefono, po1.fnac 
        FROM Podador po1 INNER JOIN Poda p1 ON (po1.DNI = p1.DNI) 
        INNER JOIN Arbol a1 ON (p1.nroArbol = a1.nroArbol)
        WHERE a.especie <> 'Coniferas'
    )


7. Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
localidad de ‘Salta’.

    SELECT a.especie 
    FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
    WHERE l.nombreL = 'La Plata' AND a.especie IN (
        SELECT a1.especie 
        FROM Arbol a1 INNER JOIN Localidad l1 ON (a1.codigoPostal = l1.codigoPostal)
        WHERE l1.nombreL = 'Salta'
    ) 


8. Eliminar el podador con DNI 22234566.

    DELETE FROM Poda p WHERE p.DNI = 22234566
    DELETE FROM Podador po WHERE po.DNI = 22234566
    

9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100
árboles.

    SELECT l.nombreL, l.descripcion, l.habitantes 
    FROM Localidad l INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
    GROUP BY l.codigoPostal, l.nombreL, l.descripcion, l.habitantes 
    HAVING COUNT (a.nroArbol) < 100
/* 
Localidad = (codigoPostal, nombreL, descripcion, #habitantes)
Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk))