use blueprint
select *
from tareas
--1 La cantidad de colaboradores

select COUNT(*) as 'cantidad'
from Colaboradores as C

--2 La cantidad de colaboradores nacidos entre 1990 y 2000.

select COUNT(*)
from Colaboradores
where FechaNacimiento BETWEEN '1990-1-1' and '2000-1-1'

--3 El promedio de precio hora base de los tipos de tareas

select avg(TT.PrecioHoraBase)
from TiposTarea as TT

--4 El promedio de costo de los proyectos iniciados en el año 2019.

SELECT AVG(P.CostoEstimado) as 'Promedio costo'
FROM Proyectos as P
where P.FechaInicio like '2019%'

--5 El costo más alto entre los proyectos de clientes de tipo 'Unicornio'

select max(p.CostoEstimado) as 'Costo maximo Unicornio'
from Proyectos as P
    inner join Clientes as C on P.IDCliente = C.ID
    inner join TiposCliente as TC on C.IDTipo = TC.ID
where TC.Nombre like 'unicornio'

--6 El costo más bajo entre los proyectos de clientes del país 'Argentina'

select paises.Nombre, min(Proyectos.CostoEstimado) as 'costo minimo'
from Proyectos
    inner join Clientes on Clientes.ID = Proyectos.IDCliente
    inner join Ciudades on Ciudades.ID = Clientes.IDCiudad
    inner join Paises on Paises.ID = Ciudades.IDPais
where Paises.Nombre like 'argentina'
GROUP by Paises.Nombre

--7 La suma total de los costos estimados entre todos los proyectos.

select SUM(Proyectos.CostoEstimado) as 'total costos'
from Proyectos

--8 Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.

select Ciudades.Nombre, COUNT(Clientes.IDCiudad) as 'cantidad de clientes'
from Ciudades
    inner join Clientes on Clientes.IDCiudad = Ciudades.ID
GROUP by(Ciudades.Nombre)

--9 Por cada país, listar el nombre del país y la cantidad de clientes.

select Paises.Nombre, COUNT(Clientes.IDCiudad) as 'Cantidad de clientes'
from Paises
    inner join Ciudades on Ciudades.IDPais = Paises.ID
    inner join Clientes on Clientes.IDCiudad = Ciudades.ID
GROUP by Paises.Nombre

--10 Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el tipo de tarea y la cantidad calculada.

select TT.Nombre, count(C.IDTarea) as colaboraciones
from TiposTarea as TT
    inner join Tareas as T on T.IDTipo = TT.ID
    inner join Colaboraciones as c on c.IDTarea = T.ID
GROUP by TT.Nombre

--11 Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.

select TiposTarea.Nombre, COUNT(Colaboraciones.IDColaborador) as colaboradores
from TiposTarea
    inner JOIN tareas on Tareas.IDTipo = TiposTarea.ID
    INNER JOIN Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
GROUP by TiposTarea.Nombre

--12 Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre del módulo y la cantidad totalizada. Mostrar los módulos sin horas registradas con 0.

select M.ID, M.Nombre, coalesce(sum(Colaboraciones.Tiempo),0) as 'tiempo'
from Modulos as M
    left join tareas on Tareas.IDModulo=M.ID
    left join Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
GROUP BY M.ID,M.Nombre

--13 Por cada módulo y tipo de tarea, el promedio de horas trabajadas. Indicar el ID y nombre del módulo, el nombre del tipo de tarea y el total calculado.

SELECT
    Modulos.ID,
    Modulos.Nombre,
    TiposTarea.Nombre as 'tipo tarea',
    avg(Colaboraciones.Tiempo) as 'Promedio horas'
from Modulos
    inner join tareas on Tareas.IDModulo=Modulos.ID
    inner JOIN TiposTarea on Tareas.IDTipo = TiposTarea.ID
    inner join Colaboraciones on Colaboraciones.IDTarea = Tareas.id
GROUP by Modulos.ID,Modulos.Nombre, TiposTarea.Nombre

--14 Por cada módulo, indicar su ID, apellido y nombre del colaborador y total que se le debe abonar en concepto de colaboraciones realizadas en dicho módulo.



--15 Por cada proyecto indicar el nombre del proyecto y la cantidad de horas registradas en concepto de colaboraciones y el total que debe abonar en concepto de colaboraciones.
--16 Listar los nombres de los proyectos que hayan registrado menos de cinco
--colaboradores distintos y más de 100 horas total de trabajo.
--17 Listar los nombres de los proyectos que hayan comenzado en el año 2020 que
--hayan registrado más de tres módulos.
--18 Listar para cada colaborador externo, el apellido y nombres y el tiempo
--máximo de horas que ha trabajo en una colaboración.
--19 Listar para cada colaborador interno, el apellido y nombres y el promedio
--percibido en concepto de colaboraciones.
--20 Listar el promedio percibido en concepto de colaboraciones para
--colaboradores internos y el promedio percibido en concepto de
--colaboraciones para colaboradores externos.
--21 Listar el nombre del proyecto y el total neto estimado. Este último valor surge
--del costo estimado menos los pagos que requiera hacer en concepto de
--colaboraciones.22 Listar la cantidad de colaboradores distintos que hayan colaborado en alguna
--tarea que correspondan a proyectos de clientes de tipo 'Unicornio'.
--23 La cantidad de tareas realizadas por colaboradores del país 'Argentina'.
--24 Por cada proyecto, la cantidad de módulos que se haya estimado mal la fecha
--de fin. Es decir, que se haya finalizado antes o después que la fecha estimada.
--Indicar el nombre del proyecto y la cantidad calculada