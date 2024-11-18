/*1. Listar nombre, descripción, fecha de inicio y fecha de fin de proyectos ya finalizados que no
fueron terminados antes de la fecha de fin estimada.
*/

SELECT nombrP, descripcion, fechaInicioP, fechaFinP 
FROM Proyecto
WHERE (fehcaFinP IS NOT null ) AND (FechaFinP < '2024-11-05') AND (fechaFinP > fechaFinEstimada)



/*2. Listar DNI, nombre, apellido, teléfono, dirección y fecha de ingreso de empleados que no son, ni
fueron responsables de proyectos. Ordenar por apellido y nombre*/

SELECT DNI, nombre, apellido, telefono, direccion, fechaIngreso 
FROM Empleado 
WHERE (DNI NOT IN (
    SELECT DNIResponsable 
    FROM Proyecto
)) ORDER BY apellido, nombre 



/*3. Listar DNI, nombre, apellido, teléfono y dirección de líderes de equipo que tenga más de un
equipo a cargo.*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion 
FROM Empleado e INNER JOIN Equipo eq ON (e.DNI = eq.DNILider)
GROUP BY e.DNI, e.nombre, e.apellido, e.telefono, e.direccion 
HAVING COUNT (eq.codEquipo) > 1



/*4. Listar DNI, nombre, apellido, teléfono y dirección de todos los empleados que trabajan en el
proyecto con nombre ‘Proyecto X’. No es necesario informar responsable y líderes*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion 
FROM Empleado e INNER JOIN Empleado_Equipo ee ON (e.DNI = ee.DNI)
INNER JOIN Equipo eq ON (ee.codEquipo = eq.codEquipo)
INNER JOIN Proyecto p ON (eq.codEquipo = p.equipoBackend OR eq.codEquipo = p.equipoFrontend)
WHERE (p.nombrP = 'Proyecto X')



/*5. Listar nombre de equipo y datos personales de líderes de equipos que no tengan empleados
asignados y trabajen con tecnología ‘Java’*/

SELECT eq.nombreE, e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
FROM Empleado e INNER JOIN Empleado_Equipo ee ON (e.DNI = ee.DNI)
INNER JOIN Equipo eq ON (ee.DNI = eq.DNILider)
GROUP BY eq.codEquipo, eq.nombreE, e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
HAVING (eq.descTecnologias = 'Java') AND (COUNT(ee.DNI) = 0)


                                /* CONSULTAR */





/*6. Modificar nombre, apellido y dirección del empleado con DNI 40568965 con los datos que desee.*/

UPDATE Empleado SET (nombre = 'Valentin', apellido = 'Aruano', direccion = 'C.493 n3057') WHERE DNI = 40568965



/*7. Listar DNI, nombre, apellido, teléfono y dirección de empleados que son responsables de
proyectos pero no han sido líderes de equipo.*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion 
FROM Empleado e INNER JOIN Proyecto p ON (e.DNI = p.DNIResponsable)
WHERE (p.fechaInicioP > '2024-01-01') AND e.DNI NOT IN (
    SELECT DNILider  
    FROM Equipo 
)

                    /*UTILIZO LA CONDICION EN EL WHERE PARA ASEGURARME QUE SEAN RESPONSABLES ACTUALMENTE, ESTA BIEN??*/



/*8. Listar nombre de equipo y descripción de tecnologías de equipos que hayan sido asignados
como equipos frontend y backend.*/

SELECT e.nombreE, e.descTecnologias 
FROM Equipo e INNER JOIN Proyecto p ON (e.codEquipo = p.equipoBackend AND e.codEquipo = p.equipoFrontend)



/*9. Listar nombre, descripción, fecha de inicio, nombre y apellido de responsables de proyectos que
se estiman finalizar durante 2025.*/

SELECT p.nombrP, p.descripcion, p.fechaInicioP, e.nombre, e.apellido 
FROM Proyecto p INNER JOIN Empleado e ON (p.DNIResponsable = e.DNI)
WHERE (p.fechaFinEstimada BETWEEN '2025-01-01' AND '2025-12-31')


/*Proyecto = (codProyecto, nombrP,descripcion, fechaInicioP, fechaFinP, fechaFinEstimada,
DNIResponsable(FK), equipoBackend(FK), equipoFrontend(FK)) // DNIResponsable corresponde a un
empleado, equipoBackend y equipoFrontend corresponden a equipos
Equipo = (codEquipo, nombreE, descTecnologias, DNILider(FK))//DNILider corresponde a un empleado
Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
Empleado_Equipo = (codEquipo(FK), DNI(FK), fechaInicio, fechaFin, descripcionRol)