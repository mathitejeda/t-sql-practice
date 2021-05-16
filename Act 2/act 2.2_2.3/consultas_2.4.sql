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

SELECT
    m.Nombre,
    TT.Nombre,
    (
        select COUNT(Colaboradores.ID)
    from Colaboradores
        inner join Colaboraciones on Colaboraciones.IDColaborador = Colaboradores.ID
    where Colaboraciones.IDTarea = T.ID and Colaboradores.Tipo = 'E'
    ) as 'Colaboradores externos',
    (
        select count(Colaboradores.ID)
    from Colaboradores
        inner join Colaboraciones on Colaboraciones.IDColaborador = Colaboradores.ID
    where Colaboraciones.IDTarea = t.id and Colaboradores.Tipo = 'I'
    ) as 'Colaboradores internos'
FROM tareas as t
    inner join Modulos as M on T.IDModulo = M.ID
    inner join TiposTarea as TT on TT.ID = T.IDTipo
--10 Listado de proyectos indicando nombre del proyecto, costo estimado, cantidad de módulos cuya estimación de fin haya sido exacta, cantidad 
--de módulos con estimación adelantada y cantidad de módulos con estimación demorada. Adelantada → estimación de fin haya sido inferior a la 
--real. Demorada → estimación de fin haya sido superior a la real.

SELECT
    p.Nombre,
    p.CostoEstimado,
    (
    select count(*)
    from Modulos
    where Modulos.IDProyecto = p.ID and Modulos.FechaEstimadaFin = Modulos.FechaFin
    ) as 'Fin exacto',
    (
    select count(*)
    from Modulos
    where Modulos.IDProyecto = p.ID and Modulos.FechaEstimadaFin < Modulos.FechaFin
    ) as 'Estimacion adelantada',
    (
    select count(*)
    from Modulos
    where Modulos.IDProyecto = p.ID and Modulos.FechaEstimadaFin > Modulos.FechaFin
    ) as 'Estimacion demorada'
FROM Proyectos as p

--11 Listado con nombre del tipo de tarea y total abonado en concepto de honorarios para colaboradores internos y total abonado en concepto de 
--honorarios para colaboradores externos.

select
    TT.Nombre,
    (
        select SUM(c.PrecioHora * c.Tiempo)
    from Colaboraciones as c
        inner join colaboradores as c1 on c.IDColaborador = c1.ID
        inner join tareas as T on c.IDTarea = T.ID
    where
            TT.ID = T.IDTipo AND
        C1.Tipo = 'I'
    ) as 'Honorarios Internos',
    (
        select sum(c.PrecioHora * c.tiempo)
    from Colaboraciones as C
        inner join colaboradores as c1 on c.IDColaborador = c1.ID
        inner join tareas as T on c.IDTarea = T.ID
    where
            TT.ID = T.IDTipo and
        c1.tipo = 'E'
    ) as 'Honorarios Externos'
from TiposTarea as TT

--12 Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. El saldo final surge de la siguiente fórmula:
--Costo estimado - Σ(HCE) - Σ(HCI) * 0.1 Siendo HCE → Honorarios de colaboradores externos y HCI → Honorarios de colaboradores internos.

SELECT
    p.Nombre,
    CL.RazonSocial,
    P.CostoEstimado -
    (
        select isnull(sum(c.PrecioHora * c.Tiempo),0)
    from colaboraciones as C
        inner join colaboradores as c1 on c.IDColaborador = c1.ID
        inner join tareas as T on C.IDTarea = T.ID
        inner join Modulos as M on M.ID = T.IDModulo
    where C1.Tipo = 'E' and M.IDProyecto = P.ID
    ) -
    (
        select isnull(sum(c.PrecioHora * c.Tiempo),0)
    from Colaboraciones as C
        inner join colaboradores as c1 on c.IDColaborador = c1.ID
        inner join tareas as T on C.IDTarea = T.ID
        inner join Modulos as M on M.ID = T.IDModulo
    where C1.Tipo = 'I' and M.IDProyecto = P.ID
    ) * 0.1 as 'saldo final'
from Proyectos as P
    inner join Clientes as CL on Cl.ID = P.IDCliente

--13 Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total en tiempo que demoraron las tareas de ese módulo y qué porcentaje de
--tiempo representaron las tareas de ese módulo en relación al tiempo total de tareas del proyecto.

select
    Modulos.Nombre,
    (
        select Proyectos.Nombre
    from Proyectos
    where Modulos.IDProyecto = Proyectos.ID
    ) as 'Nombre proyecto',
    (
        select SUM(Colaboraciones.Tiempo)
    from Colaboraciones
        inner join tareas on Colaboraciones.IDTarea = Tareas.ID
    where Modulos.ID = Tareas.IDModulo
    ) as 'Tiempo total de tareas',
    (
        
    ),
    (
        select sum(Colaboraciones.Tiempo)
    from Colaboraciones
        inner join tareas on tareas.id = Colaboraciones.IDTarea
        
    )
from modulos

--14 Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según su tipo y la cantidad de tareas de tipo 'Testing' que 
--haya realizado y la cantidad de tareas de tipo 'Programación' que haya realizado. NOTA: Se consideran tareas de tipo 'Testing' a las tareas
-- que contengan la palabra 'Testing' en su nombre. Ídem para Programación.

select
    Colaboradores.Apellido,
    Colaboradores.Nombre,
    COALESCE(
    (
        select 'externo'
        where Colaboradores.Tipo = 'e'
    ),(select 'interno' where colaboradores.tipo = 'i')) as 'Tipo',
    (
        select count(*)
    from Tareas
        inner join TiposTarea on TiposTarea.ID = Tareas.IDTipo
        inner join Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
    where TiposTarea.Nombre like '%testing%' and Colaboraciones.IDColaborador = Colaboradores.ID
    ) as 'cant testing',
    (
        select count(*)
    from Tareas
        inner join TiposTarea on TiposTarea.ID = Tareas.IDTipo
        inner join Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
    where TiposTarea.Nombre like '%programación%' and Colaboraciones.IDColaborador = Colaboradores.ID
    ) as 'cant programacion'
from Colaboradores

--15 Listado apellido y nombres de los colaboradores que no hayan realizado tareas de 'Diseño de base de datos'.

select distinct
    Colaboradores.Apellido,
    Colaboradores.Nombre
from Colaboradores
where Colaboradores.ID not in 
(
    select Colaboraciones.IDColaborador
from Tareas
    inner join Colaboraciones on Colaboraciones.IDTarea = tareas.ID
    inner join TiposTarea on Tareas.IDTipo = TiposTarea.ID
where TiposTarea.Nombre like 'Diseño de base de datos'
)

--16 Por cada país listar el nombre, la cantidad de clientes y la cantidad de colaboradores.

select
    p.Nombre,
    (
        select count(*)
    from Clientes
        inner join Ciudades on clientes.IDCiudad = Ciudades.ID
    where ciudades.IDPais = P.ID
    ) as clientes,
    (
        select count(*)
    from Colaboradores
        inner join Ciudades on Colaboradores.IDCiudad = Ciudades.ID
    where Ciudades.IDPais = p.ID
    ) as colaboradores
from paises as p

--17 Listar por cada país el nombre, la cantidad de clientes y la cantidad de colaboradores de aquellos países que no tengan clientes pero sí 
--colaboradores.

select *
from (
select
        p.Nombre,
        (
        select count(*)
        from Clientes
            inner join Ciudades on clientes.IDCiudad = Ciudades.ID
        where ciudades.IDPais = P.ID
    ) as clientes,
        (
        select count(*)
        from Colaboradores
            inner join Ciudades on Colaboradores.IDCiudad = Ciudades.ID
        where Ciudades.IDPais = p.ID
    ) as colaboradores
    from paises as p
) as tablon
where tablon.clientes = 0 and tablon.colaboradores > 0

--18 Listar apellidos y nombres de los colaboradores internos que hayan realizado más tareas de tipo 'Testing' que tareas de tipo 'Programación'.

select
    C.Apellido,
    C.Nombre,
    cantProg.cantidad,
    cantTesting.cantidad
from Colaboradores as c
    join (
    select colaboraciones.IDColaborador, coalesce(count(tareas.id),0) as cantidad
    from Tareas
        inner join TiposTarea on tareas.IDTipo = TiposTarea.ID
        inner join Colaboraciones on Colaboraciones.IDTarea = tareas.ID
    where TiposTarea.Nombre like '%testing%'
    GROUP by Colaboraciones.IDColaborador
    ) as cantTesting on C.ID = cantTesting.IDColaborador
    join (
    select colaboraciones.IDColaborador, coalesce(count(tareas.id),0) as cantidad
    from Tareas
        inner join Colaboraciones on Colaboraciones.IDTarea = tareas.ID
        inner join TiposTarea on tareas.IDTipo = TiposTarea.ID
    where TiposTarea.Nombre like '%programación%'
    GROUP by Colaboraciones.IDColaborador
    ) as cantProg on C.ID = cantProg.IDColaborador
where cantTesting.cantidad > cantProg.cantidad

--19 Listar los nombres de los tipos de tareas que hayan abonado más del cuádruple en colaboradores internos que externos 
--revisar

select DISTINCT
    TiposTarea.Nombre
from TiposTarea
    inner join(
    select tareas.IDTipo, colaboraciones.PrecioHora * Colaboraciones.Tiempo as abonado
    from Colaboraciones
        inner join colaboradores on colaboraciones.IDColaborador = colaboradores.ID
        inner join tareas on Colaboraciones.IDTarea = Tareas.ID
    where Colaboradores.Tipo = 'E'
    ) as totalExternos on totalExternos.IDTipo = TiposTarea.id
    inner join(
    select tareas.IDTipo, Colaboraciones.PrecioHora * Colaboraciones.Tiempo as abonado
    from Colaboraciones
        inner join colaboradores on colaboraciones.IDColaborador = colaboradores.ID
        inner join tareas on Colaboraciones.IDTarea = tareas.ID
    where Colaboradores.Tipo = 'I'
    ) as totalInternos on totalExternos.IDTipo = TiposTarea.ID
where (totalExternos.abonado * 4) < totalInternos.abonado

--20 Listar los proyectos que hayan registrado igual cantidad de estimaciones demoradas que adelantadas y que al menos hayan registrado alguna
--estimación adelantada y que no hayan registrado ninguna estimación exacta

select p.Nombre,
Adelantada.cant,
atrasada.cant,
exacta.cant
from Proyectos as P
    FULL JOIN
    (
    select Modulos.IDProyecto, count(*) as cant
    from Modulos
    where Modulos.FechaFin < Modulos.FechaEstimadaFin
    group by Modulos.IDProyecto
    ) as Adelantada on P.ID = Adelantada.IDProyecto
    FULL JOIN
    (
       select modulos.IDProyecto, count(*) as cant
    from Modulos
    where modulos.FechaFin > Modulos.FechaEstimadaFin
    group by Modulos.IDProyecto
    ) as atrasada on atrasada.IDProyecto = P.ID
    FULL JOIN
    (
        select Modulos.IDProyecto, count(*) as cant
    from Modulos
    where Modulos.FechaFin = Modulos.FechaEstimadaFin
    group by Modulos.IDProyecto
    ) as exacta on exacta.IDProyecto = p.ID
where Adelantada.cant = atrasada.cant and Adelantada.cant >= 1 and exacta.cant is null