/*1. Reportar nombre y año de fundación de aquellos clubes de la ciudad de La Plata que no poseen
estadio.*/

SELECT c.nombre, c.anioFundacion 
FROM Club c INNER JOIN Ciudad ciu ON (c.codigoCiudad = ciu.codigoCiudad)
WHERE (ciu.nombre = 'La Plata')
EXCEPT (
    SELECT c1.nombre, c1.anioFundacion 
    FROM Ciudad ciu1 INNER JOIN Club c1 ON (ciu1.codigoCiudad = c1.codigoCiudad)
    INNER JOIN Estadio e ON (c1.codigoClub = e.codigoClub)
    WHERE (ciu1.nombre = 'La Plata')
)


/* 2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso. */

SELECT c.nombre 
FROM Club c 
EXCEPT (
    SELECT c1.nombre 
    FROM Club c1 INNER JOIN ClubJugador cj ON (c1.codigoClub = cj.codigoClub)
    INNER JOIN Jugador j ON (cj.DNI = j.DNI)
    INNER JOIN Ciudad ciu ON (j.codigoCiudad = ciu.codigoCiudad)
    WHERE (ciu.nombre = 'Berisso')
)



/*3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia
y Esgrima La Plata. */

SELECT j.DNI, j.nombre, j.apellido 
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
INNER JOIN Club c ON (cj.codigoClub = c.codigoClub)
WHERE (c.nombre = 'Gimnasia y Esgrima La Plata')

/* 4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y hayan
jugado o juegan en algún club de la ciudad de Córdoba*/

SELECT j.DNI, j.nombre, j.apellido 
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
INNER JOIN Club c on (cj.codigoClub = c.codigoClub) 
INNER JOIN Ciudad ciu ON (c.codigoCiudad = ciu.codigoCiudad)
WHERE (j.edad > 29 AND ciu.nombre = 'Cordoba')

/*5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
actualmente en cada uno.*/

SELECT c.nombre, AVG (j.edad) AS edadPromedio 
FROM Club c INNER JOIN ClubJugador cj ON (c.codigoClub = cj.codigoClub)
INNER JOIN Jugador j ON (cj.DNI = j.DNI)
GROUP BY c.codigoClub, c.nombre 
HAVING (cj.desde > '2024-01-01')



/*6. Listar para cada jugador nombre, apellido, edad y cantidad de clubes diferentes en los que jugó.
(incluido el actual)*/

SELECT j.nombre, j.apellido, j.edad, COUNT (cj.codigoClub)
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI) 
GROUP BY j.DNI, j.nombre, j.apellido 

/*7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del
Plata.*/

SELECT c.nombre 
FROM Club c 
EXCEPT (
    SELECT c1.nombre 
    FROM Club c1 INNER JOIN ClubJugador cj ON (c1.codigoClub = cj.codigoClub)
    INNER JOIN Jugador j ON (cj.DNI = j.DNI)
    INNER JOIN Ciudad ciu ON (j.codigoCiudad = ciu.codigoCiudad)
    WHERE (ciu.nombre = 'Mar del Plata')
)



/*8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la
ciudad de Córdoba.*/
SELECT j.nombre, j.apellido 
FROM Jugador j 
WHERE NOT EXIST (
    SELECT cj.*
    FROM Club c 
    WHERE NOT EXIST (
        SELECT cj.*
        FROM ClubJugador cj INNER JOIN Ciudad ciu ON (cj.codigoCiudad = ciu.codigoCiudad)
        WHERE (cj.codigoClub = c.codigoClub) AND (cj.DNI = j.DNI) AND (ciu.nombre = 'Cordoba')
    )
)
                            /*COMPLETAR EN CLASE ----- CONSULTADO*/



/*9. Agregar el club “Estrella de Berisso”, con código 1234, que se fundó en 1921 y que pertenece a
la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club.*/

INSERT INTO Club (codigoClub, nombre, anioFundacion, codigoCiudad) 
VALUES (1234, 'Estrella de Berisso', 1921, SELECT codigoCiudad FROM Ciudad WHERE nombre = 'Berisso')
/*Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
Ciudad = (codigoCiudad, nombre)
Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
ClubJugador = (codigoClub (FK), DNI (FK), desde, hasta)

