use blueprint

--1 Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo costo estimado sea mayor al promedio de costos.

select Proyectos.Nombre, Proyectos.CostoEstimado
from Proyectos
where Proyectos.CostoEstimado > (
    select AVG(Proyectos.CostoEstimado)
from Proyectos
)

--2 Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos clientes que no tengan proyectos que comiencen en el año 2020.

select
    c.RazonSocial,
    c.CUIT,
    COALESCE(c.EMail,c.celular,c.telefono,'incontactable') as 'Contacto'
from Clientes as c
where c.ID not in(
    select Proyectos.IDCliente
from Proyectos
where year(Proyectos.FechaInicio) = '2020'
)

--3 Listado de países que no tengan clientes relacionados.

select *
from Paises
where Paises.ID not in(
    select distinct Paises.ID
from Paises
    inner join Ciudades on Ciudades.IDPais = Paises.ID
    inner join Clientes on Clientes.IDCiudad = Ciudades.ID
)

--4 Listado de proyectos que no tengan tareas registradas.

select *
from Proyectos
where Proyectos.ID not in(
    select Proyectos.ID
from Proyectos
    inner join Modulos on Modulos.IDProyecto = Proyectos.ID
    inner join tareas on tareas.IDModulo = Modulos.ID
)

--5 Listado de tipos de tareas que no registren tareas pendientes.

select *
from TiposTarea
where TiposTarea.ID not in(
    select TiposTarea.ID
from TiposTarea
    inner join Tareas on Tareas.IDTipo = TiposTarea.ID
where Tareas.FechaFin is NULL
)


--6 Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea menor al costo estimado de cualquier proyecto de clientes nacionales
--(clientes que sean de Argentina o no tengan asociado un país).

SELECT
    p.ID,
    p.Nombre,
    p.CostoEstimado
from Proyectos as p
where p.CostoEstimado < all(
    select Proyectos.CostoEstimado
from Proyectos
    inner join Clientes on Clientes.ID = Proyectos.IDCliente
    left join Ciudades on Ciudades.ID = Clientes.IDCiudad
    left join Paises on Paises.ID = Ciudades.IDPais
where Paises.Nombre = 'Argentina' or Clientes.IDCiudad is null
)


--7 Listado de apellido y nombres de colaboradores que hayan demorado más en una tarea que el colaborador de la ciudad de 'Buenos Aires' que más haya demorado.

SELECT
    Apellido,
    Nombre
from Colaboradores
    inner join Colaboraciones on Colaboradores.ID = Colaboraciones.IDColaborador
where Colaboraciones.Tiempo > (
select top 1
    Colaboraciones.Tiempo
from Colaboradores
    inner join Colaboraciones on Colaboraciones.IDColaborador = Colaboradores.ID
    inner join Ciudades on Ciudades.ID = colaboradores.IDCiudad
where Ciudades.Nombre like 'Buenos aires'
order by Colaboraciones.Tiempo DESC
)
order by Apellido ASC

--8 Listado de clientes indicando razón social, nombre del país (si tiene) y cantidad de proyectos comenzados y cantidad de proyectos por comenzar.

select
    Clientes.RazonSocial,
    COALESCE((
    select Paises.Nombre
    from Paises
        inner join Ciudades on Paises.ID = Ciudades.IDPais
    where Clientes.IDCiudad = Ciudades.ID
    ),'Sin pais registrado') as 'pais',
    (
    select COUNT(Proyectos.ID)
    from Proyectos
    where Proyectos.FechaInicio is not null and Clientes.ID = Proyectos.IDCliente
    ) as 'Proyectos comenzados',
    (
    select COUNT(Proyectos.ID)
    from Proyectos
    where Proyectos.FechaInicio is null and Clientes.ID = Proyectos.IDCliente
    ) as 'Proyectos por comenzar'
from Clientes

--9 Listado de tareas indicando nombre del módulo, nombre del tipo de tarea, cantidad de colaboradores externos que la realizaron y cantidad de
--colaboradores internos que la realizaron.



--10 Listado de proyectos indicando nombre del proyecto, costo estimado, cantidad de módulos cuya estimación de fin haya sido exacta, cantidad de módulos con estimación 
--adelantada y cantidad de módulos con estimación demorada. Adelantada → estimación de fin haya sido inferior a la real.
--Demorada → estimación de fin haya sido superior a la real.



--11 Listado con nombre del tipo de tarea y total abonado en concepto de honorarios para colaboradores internos y total abonado en concepto de honorarios para 
--colaboradores externos.



--12 Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. El saldo final surge de la siguiente fórmula:
--Costo estimado - Σ(HCE) - Σ(HCI) * 0.1 Siendo HCE → Honorarios de colaboradores externos y HCI → Honorarios de colaboradores internos.



--13 Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total en tiempo que demoraron las tareas de ese módulo y qué porcentaje de
--tiempo representaron las tareas de ese módulo en relación al tiempo total de tareas del proyecto.



--14 Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según su tipo y la cantidad de tareas de tipo 'Testing' que haya realizado y la
--cantidad de tareas de tipo 'Programación' que haya realizado. NOTA: Se consideran tareas de tipo 'Testing' a las tareas que contengan la palabra 'Testing' en su nombre. 
--Ídem para Programación.



--15 Listado apellido y nombres de los colaboradores que no hayan realizado tareas de 'Diseño de base de datos'.



--16 Por cada país listar el nombre, la cantidad de clientes y la cantidad de colaboradores.



--17 Listar por cada país el nombre, la cantidad de clientes y la cantidad de colaboradores de aquellos países que no tengan clientes pero sí colaboradores.



--18 Listar apellidos y nombres de los colaboradores internos que hayan realizado más tareas de tipo 'Testing' que tareas de tipo 'Programación'.



--19 Listar los nombres de los tipos de tareas que hayan abonado más del cuádruple en colaboradores internos que externos



--20 Listar los proyectos que hayan registrado igual cantidad de estimaciones demoradas que adelantadas y que al menos hayan registrado alguna
--estimación adelantada y que no hayan registrado ninguna estimación exacta



