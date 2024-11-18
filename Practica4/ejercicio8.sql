/*1. Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad ‘La Plata’ y estén
inscriptos en torneos disputados en 2023.*/

SELECT i.DNI, i.nombre, i.apellido, i.email 
FROM Integrante i INNER JOIN Inscripcion ins ON (i.codgioE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
WHERE (ciudad = 'La Plata' AND (tp.fecha BETWEEN '2023-01-01' AND '2023-12-31')
)



/*2. Reportar nombre y descripción de equipos que solo se hayan inscripto en torneos de 2020*/

SELECT e.nombreE, e.descripcionE
FROM Equipo e INNER JOIN Inscripcion i ON (e.codigoE = i.codigoE)
INNER JOIN TorneoPesca tp ON (i.codTorneo = tp.codTorneo)
WHERE (tp.fecha BETWEEN '2020-01-01' AND '2020-12-31') AND e.codigoE NOT IN (
    SELECT e.codigoE 
    FROM Equipo e1 INNER JOIN Inscripcion i1 ON (e1.codigoE = i1.codigoE)
    INNER JOIN TorneoPesca tp1 ON (i1.codTorneo = tp1.codTorneo)
    WHERE tp1.fecha < '2020-01-01' OR tp1.fecha > '2020-12-31'
)



/*3. Listar DNI, nombre, apellido,email y ciudad de integrantes que asistieron a torneos en la laguna con
nombre ‘La Salada, Coronel Granada’ y su equipo no tenga inscripciones a torneos disputados en
2023.
*/

SELECT DNI, nombre, apellido, email, ciudad 
FROM Integrante i INNER JOIN Equipo e ON (i.codgioE = e.codigoE)
INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE) 
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
WHERE (l.nombreL = 'La Salada, Coronel Granada') AND (ins.asistio = true) 
AND i.codigoE NOT IN (
    SELECT ins1.codigoE 
    FROM Inscripcion ins1 INNER JOIN TorneoPesca tp1 ON (ins1.codTorneo = tp1.codTorneo)
    WHERE tp1.fecha BETWEEN '2023-01-01' AND '2023-12-31'
)



/*4. Reportar nombre y descripción de equipos que tengan al menos 5 integrantes.Ordenar por nombre.*/

SELECT nombreE, descripcionE 
FROM Equipo INNER JOIN Integrante i ON (e.codigoE = i.codigoE)
GROUP BY codigoE, nombreE, descripcionE 
HAVING SELECT COUNT (i.DNI) >= 5
ORDER BY e.nombreE



/*5. Reportar nombre y descripción de equipos que tengan inscripciones en todas las lagunas.*/

SELECT e.nombreE, e.descripcionE
FROM Equipo e 
WHERE NOT EXISTS (
    SELECT l.nroLaguna
    FROM Laguna l 
    WHERE NOT EXISTS (
        SELECT i.codigoE 
        FROM Inscripcion i INNER JOIN TorneoPesca tp ON (i.codTorneo = tp.codTorneo)
        WHERE (tp.nroLaguna = l.nroLaguna) AND (i.codigoE = e.codigoE) 
    )
) 
                        /*RESOLVER EN CLASE --- RESUELTO */



/*6. Eliminar el equipo con código 10000.*/

DELETE FROM Integrante WHERE codigoE = 10000
DELETE FROM Inscripcion WHERE codigoE = 10000
DELETE FROM Equipo WHERE codigoE = 10000



/*7. Listar nombre, ubicación,extensión y descripción de lagunas que no tuvieron torneos.*/

SELECT nombre, ubicacion, extension, descripcion 
FROM Laguna 
WHERE (nroLaguna NOT IN (
    SELECT tp.nroLaguna 
    FROM TorneoPesca tp 
))



/*8. Reportar nombre y descripción de equipos que tengan inscripciones a torneos a disputarse durante
2024, pero no tienen inscripciones a torneos de 2023.*/

SELECT e.nombreE, e.descripcionE 
FROM Equipo e INNER JOIN Inscripcion i ON (e.codigoE = i.codigoE)
INNER JOIN TorneoPesca tp ON (i.codTorneo = tp.codTorneo)
WHERE (tp.fecha BETWEEN '2024-01-01' AND '2024-12-31') AND e.codigoE NOT IN (
    SELECT codigoE 
    FROM Inscripcion i1 INNER JOIN TorneoPesca tp1 ON (i1.codTorneo = tp.codTorneo)
    WHERE (tp1.fecha BETWEEN '2023-01-01' AND '2023-12-31')
)



/*9. Listar DNI, nombre, apellido, ciudad y email de integrantes que ganaron algún torneo que se disputó
en la laguna con nombre: ‘Laguna de Chascomús’.*/

SELECT DISTINCT i.DNI, i.nombre, i.apellido, i.ciudad, i.email 
FROM Integrante i INNER JOIN Inscripcion ins ON (i.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
WHERE (ins.gano = true) AND (l.nombreL = 'Laguna de Chascomus')

/*Equipo = (codigoE, nombreE, descripcionE)
Integrante = (DNI, nombre, apellido,ciudad,email, telefono,codigoE(fk))
Laguna = (nroLaguna, nombreL, ubicación,extension, descripción)
TorneoPesca = (codTorneo, fecha,hora, nroLaguna(fk), descripcion)
Inscripcion = (codTorneo(fk),codigoE(fk), asistio, gano) // asistio y gano son true o false según
corresponda*/


