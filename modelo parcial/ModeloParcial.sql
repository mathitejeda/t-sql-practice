--1 Apellido y nombres de los pacientes cuya cantidad de turnos de 'Protologia' sea mayor a 2.
use MODELOPARCIAL1

GO

select
    PACIENTES.APELLIDO,
    PACIENTES.NOMBRE,
    count(TURNOS.IDTURNO) as 'Turnos'
from PACIENTES
    inner join TURNOS on TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE
    inner join MEDICOS on TURNOS.IDMEDICO = MEDICOS.IDMEDICO
    inner join ESPECIALIDADES on MEDICOS.IDESPECIALIDAD = ESPECIALIDADES.IDESPECIALIDAD
where ESPECIALIDADES.NOMBRE like 'Proctologia'
GROUP by PACIENTES.APELLIDO,PACIENTES.NOMBRE
HAVING COUNT(*)> 2
--2 Los apellidos y nombres de los médicos (sin repetir) que hayan demorado en alguno de sus turnos menos de la duración promedio de turnos.
select distinct
    MEDICOS.APELLIDO,
    MEDICOS.NOMBRE
from MEDICOS
    inner join TURNOS on TURNOS.IDMEDICO = MEDICOS.IDMEDICO
where TURNOS.DURACION < (
select AVG(TURNOS.DURACION)
from TURNOS
)
--3 Por cada paciente, el apellido y nombre y la cantidad de turnos realizados en el primer semestre y la cantidad de turnos realizados en el segundo semestre. 
--Indistintamente del año.
select
    PACIENTES.NOMBRE,
    PACIENTES.APELLIDO,
    (
    select
        COUNT(TURNOS.IDTURNO)
    from TURNOS
    where TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE and MONTH(TURNOS.FECHAHORA) BETWEEN 01 and 06
    ) as 'Turnos primer semestre',
    (
    select
        COUNT(TURNOS.IDTURNO)
    from TURNOS
    where TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE and MONTH(TURNOS.FECHAHORA) BETWEEN 06 and 12
    ) as 'Turnos segundo semestre'
from PACIENTES

--4 Los pacientes que se hayan atendido más veces en el año 2000 que en el año 2001 y a su vez más veces en el año 2001 que en año 2002.

select
*
from PACIENTES
where
(
select COUNT(TURNOS.IDTURNO)
from TURNOS
where TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE and YEAR(TURNOS.FECHAHORA) = 2000
)
>
(
select COUNT(TURNOS.IDTURNO)
from TURNOS
where TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE and year(TURNOS.FECHAHORA) = 2001
)
and
(
select COUNT(TURNOS.IDTURNO)
from TURNOS
where TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE and year(TURNOS.FECHAHORA) = 2001
)
>
(
select COUNT(TURNOS.IDTURNO)
from TURNOS
where TURNOS.IDPACIENTE = PACIENTES.IDPACIENTE and year(TURNOS.FECHAHORA) = 2002
)