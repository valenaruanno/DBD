
/* 1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio. */

SELECT nombre, stock, precio 
FROM Repuesto 
ORDER BY precio 

/*2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
se usaron en reparaciones del técnico ‘José Gonzalez’. */

SELECT nombre, stock, precio
FROM Repuesto r INNER JOIN RepuestoPreparacion rp ON (r.codRep = rp.codRep)
INNER JOIN Reparacion re ON (rp.nroReparac = re.nroReparac)
WHERE (re.fecha BETWEEN '2023-01-01' AND '2023-12-31') AND NOT EXISTS (
    SELECT nombre, stock, precio
    FROM Repuesto r1 INNER JOIN RepuestoReparacion rp1 ON (r1.codRep = rp1.codRep)
    INNER JOIN Reparacion re1 ON (rp1.nroReparac = re1.nroReparac)
    INNER JOIN Tecnico t ON (re1.codTec = t.codTec)
    WHERE (t.nombre = 'Jose Gonzalez') AND (rp1.codRep = r.codRep)
)



/* 3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
por nombre ascendentemente.*/

SELECT nombre, especialidad 
FROM Tecnico t
WHERE (t.codTec NOT IN (
    SELECT codTec 
    FROM Reparacion  
)) ORDER BY nombre 



/* 4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones
durante 2022.*/

SELECT nombre, especialidad 
FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
WHERE (r.fecha BETWEEN '2022-01-01' AND '2022-12-31') AND t.codTec NOT IN (
    SELECT r1.codTec 
    FROM Reparacion r1 
    WHERE (r1.fecha < '2022-01-01' AND r1.fecha > '2022-12-31')
)



/*5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un
repuesto no participó en alguna reparación igual debe aparecer en dicho listado.*/

SELECT nombre, stock, COUNT (DISTINCT t.codTec)     /*Utilizo el DISTINCT para contar la cantidad de tecnicos distintos*/
FROM Repuesto r INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
LEFT JOIN Reparacion re ON (rr.nroReparac = re.nroReparac)
LEFT JOIN Tecnico t ON (re.codTec = t.codTec)
GROUP BY codRep, nombre, stock 
        /*Utilizo el LEFT JOIN en lugar de INNER JOIN para incluir 
        los repuestos que no participaron en ninguna reparacion tmb*/

        

/* 6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el
técnico con menor cantidad de reparaciones.*/

SELECT t.nombre, t.especialidad 
FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT (*) >= ALL (
    SELECT COUNT (*) 
    FROM Reparacion r1  
    GROUP BY t.codTec 
) UNION SELECT t.nombre, t.especialidad 
FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT (*) <= ALL (
    SELECT COUNT (*) 
    FROM Reparacion r 
    GROUP BY t.codTec 
)

                                /*NO SE COMO SE REALIZA ---- HECHO */



/*7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
no haya estado en reparaciones con un precio total superior a $10000.*/

SELECT r.nombre, r.stock, r.precio 
FROM Repuesto r 
WHERE (r.stock > 0) AND (r.codRep NOT IN (
    SELECT rr.codRep 
    FROM RepuestoReparacion rr INNER JOIN Reparacion re ON (rr.nroReparac = re.nroReparac)
    WHERE (re.precio_total > 10000)
))



/*8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
con precio en el momento de la reparación mayor a $10000 y menor a $15000*/

SELECT rr.nroReparac, r.fecha, r.precio_total 
FROM Repuesto re INNER JOIN RepuestoReparacion rr ON (re.codRep = rr.codRep)
INNER JOIN Reparacion r ON (rr.nroReparac = r.nroReparac)
WHERE (rr.precio > 10000 AND rr.precio < 15000)

/*9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos.*/
                            /*Consultar ejercicio*/
SELECT r.nombre, r.stock, r.precio 
FROM Repuesto r 
WHERE NOT EXISTS (
    SELECT t.codTec
    FROM Tecnico t 
    WHERE NOT EXISTS (
        SELECT rr.codRep 
        FROM RepuestoReparacion rr INNER JOIN Reparacion rep ON (rep.nroReparac = rp.nroReparac)
        WHERE (rep.codTec = t.codTec) AND (rr.codRep = r.codRep)
    )
)



/**/
/*Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
reparaciones.
Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.
