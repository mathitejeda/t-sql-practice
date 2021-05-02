use BluePrint

GO

--1 Por cada cliente listar raz�n social, cuit y nombre del tipo de cliente.

select Clientes.RazonSocial, Clientes.Cuit, TiposCliente.Nombre
from Clientes
    left join TiposCliente on Clientes.IDTipo = TiposCliente.ID

--2 Por cada cliente listar raz�n social, cuit y nombre de la ciudad y nombre del pa�s. S�lo de aquellos clientes que posean ciudad y pa�s.

select Clientes.RazonSocial, Clientes.Cuit, Ciudades.Nombre, Paises.Nombre
from Clientes
    inner join ciudades on Clientes.IDCiudad = Ciudades.ID
    inner join Paises on Ciudades.IDPais = Paises.ID

--3 Por cada cliente listar raz�n social, cuit y nombre de la ciudad y nombre del pa�s. Listar tambi�n los datos de aquellos clientes que no tengan ciudad relacionada.

select Clientes.RazonSocial, Clientes.CUIT, Ciudades.Nombre, paises.Nombre
from Clientes
    left join Ciudades on Clientes.IDCiudad = Ciudades.ID
    left join paises on Ciudades.IDPais = Paises.ID

--4 Por cada cliente listar raz�n social, cuit y nombre de la ciudad y nombre del pa�s. Listar tambi�n los datos de aquellas ciudades y pa�ses que no tengan clientes relacionados.

select Clientes.RazonSocial, Clientes.CUIT, isnull(Ciudades.Nombre,'N/A') as 'ciudad', isnull(paises.Nombre,'N/A') as 'pais'
from Clientes
    full join Ciudades on Clientes.IDCiudad = Ciudades.ID
    full join paises on Ciudades.IDPais = Paises.ID

--5 Listar los nombres de las ciudades que no tengan clientes asociados. Listar tambi�n el nombre del pa�s al que pertenece la ciudad.

select Ciudades.Nombre, paises.Nombre
from Ciudades left join Clientes on Ciudades.ID = Clientes.IDCiudad
    inner join Paises on Ciudades.IDPais = Paises.ID
where Clientes.IDCiudad is null

--6 Listar para cada proyecto el nombre del proyecto, el costo, la raz�n social del cliente, el nombre del tipo de cliente y el nombre de la ciudad (si la tieneregistrada) de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.
select Proyectos.Nombre, Proyectos.CostoEstimado, Clientes.RazonSocial, TiposCliente.Nombre as 'tipo de cliente', coalesce(Ciudades.Nombre,'No registrado') as 'ciudad'
from Proyectos
    left join Clientes on Proyectos.IDCliente = Clientes.ID
    left join TiposCliente on TiposCliente.ID = Clientes.ID
    left join Ciudades on Clientes.IDCiudad = Ciudades.ID
where TiposCliente.Nombre in ('extranjero', 'unicornio')

--7 Listar los nombre de los proyectos de aquellos clientes que sean de los pa�ses 'Argentina' o 'Italia'.
select Proyectos.Nombre
from Proyectos
    left join Clientes on Proyectos.IDCliente = Clientes.ID
    left join Ciudades on Clientes.IDCiudad = Ciudades.ID
where Ciudades.IDPais = 1 or Ciudades.IDPais = 5

--8 Listar para cada m�dulo el nombre del m�dulo, el costo estimado del m�dulo, el nombre del proyecto, la descripci�n del proyecto y el costo estimado del proyecto de todos aquellos proyectos que hayan finalizado.
select Modulos.Nombre, Modulos.CostoEstimado as 'Costo estimado modulo', Proyectos.Nombre, Proyectos.Descripcion, Proyectos.CostoEstimado as 'Costo Estimado Proyecto'
from Modulos
    left join proyectos on Modulos.IDProyecto = Proyectos.ID
where Proyectos.Estado = 1

--9 Listar los nombres de los m�dulos y el nombre del proyecto de aquellos m�dulos cuyo tiempo estimado de realizaci�n sea de m�s de 100 horas.

select Modulos.Nombre, Proyectos.Nombre
from Modulos
    left join Proyectos on Modulos.IDProyecto = Proyectos.ID
where Modulos.TiempoEstimado > 100

--10 Listar nombres de m�dulos, nombre del proyecto, descripci�n y tiempo estimado de aquellos m�dulos cuya fecha estimada de fin sea mayor a la fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.

select Modulos.Nombre, Proyectos.Nombre, Proyectos.Descripcion, Proyectos.CostoEstimado
from Modulos
    left join Proyectos on Modulos.IDProyecto = Proyectos.ID
where Modulos.FechaEstimadaFin > Modulos.FechaFin and Proyectos.CostoEstimado > 100000

--11 Listar nombre de proyectos, sin repetir, que registren m�dulos que hayan finalizado antes que el tiempo estimado.

select distinct(Proyectos.Nombre)
from Proyectos
    INNER join modulos on Proyectos.ID = Modulos.IDProyecto
where Modulos.FechaFin < FechaEstimadaFin

--12 Listar nombre de ciudades, sin repetir, que no registren clientes pero s� colaboradores.

select distinct(Ciudades.Nombre)
from Ciudades
    full join Clientes on Clientes.IDCiudad = Ciudades.ID
    full join Colaboradores on Colaboradores.IDCiudad = Ciudades.ID
where Clientes.IDCiudad IS NULL and Colaboradores.IDCiudad IS NOT NULL


--13 Listar el nombre del proyecto y nombre de m�dulos de aquellos m�dulos que contengan la palabra 'login' en su nombre o descripci�n.

select Proyectos.Nombre, Modulos.Nombre, Modulos.Descripcion
FROM Proyectos
    inner join Modulos on Modulos.IDProyecto = Proyectos.ID
where Modulos.Descripcion like '%login%'

--14 Listar el nombre del proyecto y el nombre y apellido de todos los colaboradores que hayan realizado alg�n tipo de tarea 
--cuyo nombre contenga 'Programaci�n' o 'Testing'. Ordenarlo por nombre de proyecto de manera ascendente.

SELECT Proyectos.Nombre as 'Proyecto', Colaboradores.Nombre as 'Nombre Colaborador', Colaboradores.Apellido as 'Apellido colaborador', TiposTarea.Nombre
from Proyectos
    INNER join Modulos on Proyectos.ID = Modulos.IDProyecto --Para poder acceder a las tareas
    INNER JOIN Tareas on Modulos.ID = Tareas.IDModulo --Para poder acceder a las colaboraciones
    INNER join TiposTarea on Tareas.IDTipo = TiposTarea.ID
    INNER join Colaboraciones on Tareas.IDModulo = Colaboraciones.IDColaborador --Para poder acceder a los colaboradores
    INNER join Colaboradores on Colaboraciones.IDColaborador = Colaboradores.ID
where TiposTarea.Nombre like '%Programacion%' or TiposTarea.Nombre like '%testing%'
order by Proyectos.Nombre ASC

--15 Listar nombre y apellido del colaborador, nombre del m�dulo, nombre del tipo de tarea, precio hora de la colaboraci�n y precio hora 
--base de aquellos colaboradores que hayan cobrado su valor hora de colaboraci�n m�s del 50% del valor hora base.

select
    Colaboradores.Nombre + ', '+ Colaboradores.Apellido as 'colaborador',
    Modulos.Nombre,
    TiposTarea.Nombre,
    Colaboraciones.PrecioHora,
    TiposTarea.PrecioHoraBase
from Colaboradores
    inner join Colaboraciones on Colaboraciones.IDColaborador = Colaboradores.ID
    inner join Tareas on Colaboraciones.IDTarea = Colaboradores.ID
    inner join TiposTarea on Tareas.IDTipo = TiposTarea.ID
    inner join Modulos on tareas.IDModulo = Modulos.ID
where Colaboraciones.IDTarea = 2
--Lo deje ahi porque la consigna es poco clara

/*16 Listar nombres y apellidos de las tres colaboraciones de colaboradores externos que m�s hayan demorado en realizar alguna tarea cuyo 
nombre de tipo de tarea contenga 'Testing'.*/
select
    top 3
    Colaboraciones.Tiempo,
    Colaboradores.Nombre + ',' + Colaboradores.Apellido as 'Colaborador',
    Colaboraciones.Tiempo as 'Tiempo'
from Colaboradores
    inner join Colaboraciones on Colaboradores.ID = Colaboraciones.IDColaborador
    inner join tareas on Colaboraciones.IDTarea = Tareas.ID
    inner join TiposTarea on tareas.IDTipo = TiposTarea.ID
where Colaboradores.Tipo = 'E' and TiposTarea.Nombre like '%testing%'

--17 Listar apellido, nombre y mail de los colaboradores argentinos que sean internos y cuyo mail no contenga '.com'.
select
    Colaboradores.Apellido + ', '+Colaboradores.Nombre as 'colaboradores',
    Colaboradores.EMail
from Colaboradores
    inner join Ciudades on Colaboradores.IDCiudad = Ciudades.ID
where Ciudades.IDPais = 1 and Colaboradores.EMail not like '%.com'
--18 Listar nombre del proyecto, nombre del m�dulo y tipo de tarea de aquellas tareas realizadas por colaboradores externos.

SELECT
    Proyectos.Nombre,
    Modulos.Nombre,
    TiposTarea.Nombre
FROM Proyectos
    INNER JOIN Modulos on Modulos.IDProyecto = Proyectos.ID
    INNER JOIN tareas on Tareas.IDModulo = Modulos.ID
    INNER JOIN TiposTarea on TiposTarea.ID = Tareas.IDTipo
    INNER join Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
    INNER JOIN colaboradores on Colaboraciones.IDColaborador = Colaboradores.ID
WHERE Colaboradores.Tipo = 'E'

--19 Listar nombre de proyectos que no hayan registrado tareas.

select
    Proyectos.Nombre
from Proyectos
    LEFT JOIN Modulos on Modulos.IDProyecto = Proyectos.ID
    LEFT JOIN tareas on tareas.IDModulo = Modulos.ID
where Tareas.IDModulo IS NULL

--20 Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que hayan trabajado en alg�n proyecto que a�n no haya 
--finalizado

select
    distinct(Colaboradores.Apellido + ', ' + Colaboradores.Nombre) as 'Colaboradores'
from Colaboradores
    INNER JOIN Colaboraciones on Colaboraciones.IDColaborador = Colaboradores.ID
    INNER JOIN Tareas on Colaboraciones.IDTarea = Tareas.ID
    INNER JOIN Modulos on Modulos.ID = Tareas.IDModulo
    INNER JOIN Proyectos on Proyectos.ID = Modulos.IDProyecto
where Proyectos.Estado = 1