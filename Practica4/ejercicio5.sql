/* Ejercicio 5
AGENCIA = (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD = (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE = (DNI, nombre, apellido, teléfono, dirección)
VIAJE = (FECHA, HORA, DNI (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje */


/* 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por
teléfono. */

SELECT a.RAZON_SOCIAL, a.direccion, a. telef 
FROM Agencia a INNER JOIN Viaje v on (a.RAZON_SOCIAL = v.RAZON_SOCIAL) 
INNER JOIN  Cliente c ON (v.DNI = c.DNI)
INNER JOIN Ciudad ciu ON (v.cpOrigen = ciu.CODIGOPOSTAL)
WHERE (v.cpOrigen = 'La Plata') AND (c.apellido = 'Roma')
ORDER BY a.RAZON_SOCIAL, a.telef

/* 2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y 
destino de viajes
realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.*/

SELECT v.FECHA, v.HORA, c.DNI, c.nombre, c.apellido, c.telefono, c.direccion, 
ciu_origen.nombreCiudad AS ciudad_origen, ciu_destino.nombreCiudad AS ciudad_destino
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
INNER JOIN Ciudad ciu_origen ON v.cpOrigen = ciu_origen.CODIGOPOSTAL
INNER JOIN Ciudad ciu_destino ON v.cpDestino = ciu_destino.CODIGOPOSTAL
WHERE (v.fecha between 2019/01/01 and 2019/01/31) and (v.descripcion LIKE '%demorado%')


/* 3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
mail que termine con ‘@jmail.com’. */

SELECT a.razon_social, a.direccion, a.telef, a.e-mail
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
WHERE (v.fecha between 2019/01/01 and 2019/12/31) or (a.e-mail LIKE '%@jmail.com')


/*4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’*/

SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
INNER JOIN Ciudad ciu ON (v.cpdestino = c.codigopostal)
WHERE (ciu.nombreCiudad = 'Coronel Brandsen')
EXCEPT (
    SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
    FROM Cliente c
    INNER JOIN Viaje v ON (c.dni = v.dni)
    INNER JOIN Ciudad ciu ON (v.cpdestino = c.codigopostal)
    WHERE (ciu.nombreCiudad <> 'Coronel Brandsen')
)

/* 5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’. */

SELECT COUNT(*)
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
INNER JOIN Ciudad c ON (v.cpDestino = c.codigopostal)
WHERE (a.razon_social = 'TAXI Y') and (c.nombreCiudad = 'Villa Elisa')


/* 6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */


SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
WHERE NOT EXISTS ((
    SELECT a.RAZON_SOCIAL 
    FROM Agencia a
    WHERE NOT EXISTS (
        SELECT v.razon_social 
        FROM Viaje v
        WHERE (v.razon_social = a.razon_social) AND (v.DNI = c.DNI)
    )
))


/* 7. Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’. */

UPDATE Cliente SET telef='221-4400897' WHERE dni=38495444

/* 8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
realizados. */

SELECT a.razon_social, a.direccion, a.telef
FROM Agencia a INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
GROUP BY a.razon_social, a.direccion, a.telef
HAVING COUNT(*) >= (
    SELECT COUNT(*)
    FROM Agencia a INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
    GROUP BY a.razon_social, a.direccion, a.telef
)

/* 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes. */

SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c INNER JOIN Viaje v ON (c.dni = v.dni)
GROUP BY c.dni, c.nombre, c.apellido, c.direccion, c.telefono
HAVING COUNT(*) >= 10

/* 10. Borrar al cliente con DNI 40325692. */

DELETE FROM Viaje WHERE dni=40325692 
DELETE FROM Cliente WHERE dni=40325692 

/*AGENCIA = (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD = (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE = (DNI, nombre, apellido, teléfono, dirección)
VIAJE = (FECHA, HORA, DNI (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)*/