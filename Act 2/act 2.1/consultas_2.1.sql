use Blueprint2.1

GO

--1 Listado de todos los clientes.

select * from Clientes

--2 Listado de todos los proyectos.

select * from Proyectos

--3 Listado con nombre, descripción, costo, fecha de inicio y de fin de todos los proyectos.

select Nombre, descripcion, Costo,FechaInicio, FechaFin from Proyectos

--4 Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo mayor a cien mil pesos.

select Nombre,Descripcion,Costo,FechaInicio from Proyectos where Costo<100000

--5 Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo menor a cincuenta mil pesos .

select Nombre,Descripcion,Costo,FechaInicio from Proyectos where costo < 50000

--6 Listado con todos los datos de todos los proyectos que comiencen en el año 2020.

select * from Proyectos where YEAR(FechaInicio) >= 2020

--7 Listado con nombre, descripción y costo de los proyectos que comiencen en el año 2020 y cuesten más de cien mil pesos.

select Nombre,Descripcion,Costo from Proyectos where YEAR(FechaInicio) >= 2020 and Costo > 100000

--8 Listado con nombre del proyecto, costo y año de inicio del proyecto.

select Nombre,Costo,YEAR(FechaInicio)as 'Año de inicio' from Proyectos

--9 Listado con nombre del proyecto, costo, fecha de inicio, fecha de fin y días de duración de los proyectos.

select Nombre,costo, FechaInicio,FechaFin, DATEDIFF(day,FechaInicio,FechaFin) as duracion from Proyectos

--10 Listado con razón social, cuit y teléfono de todos los clientes cuyo IDTipo sea 1, 3, 5 o 6

select RazonSocial,Cuit,TelefonoFijo from Clientes where IDTipoCliente in (1,3,5,6)

--11 Listado con nombre del proyecto, costo, fecha de inicio y fin de todos los proyectos que no pertenezcan a los clientes 1, 5 ni 10.

select Nombre,Costo,FechaInicio,FechaFin from Proyectos where IDCliente not in (1,5,10)

--12 Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan comenzado entre el 1/1/2018 y el 24/6/2018.

select Nombre,Costo,Descripcion from Proyectos where FechaInicio BETWEEN convert(date,'2018/1/1') AND convert(date,'2018/6/24')

--13 Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan finalizado entre el 1/1/2019 y el 12/12/2019.

select Nombre,Costo,Descripcion from Proyectos where FechaFin between '2019-1-1' and '2019-12-12'

--14 Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan finalizado.

select Nombre,Descripcion from Proyectos where FechaFin is null

--15 Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan comenzado.

select Nombre,Descripcion from Proyectos where FechaInicio is null

--16 Listado de clientes cuya razón social comience con letra vocal.

select * from Clientes where RazonSocial like '[a,e,i,o,u]%'

--17 Listado de clientes cuya razón social finalice con vocal.

select * from Clientes where RazonSocial like '%[a,e,i,o,u]'


--18 Listado de clientes cuya razón social finalice con la palabra 'Inc'

select * from Clientes where RazonSocial like '%inc'

--19 Listado de clientes cuya razón social no finalice con vocal.

select * from Clientes where RazonSocial not like '%[a,e,i,o,u]'

--20 Listado de clientes cuya razón social no contenga espacios.

select * from clientes where RazonSocial not like '% %'

--21 Listado de clientes cuya razón social contenga más de un espacio.

select * from Clientes where RazonSocial not like '% % %'

--22 Listado de razón social, cuit, email y celular de aquellos clientes que tengan mail pero no teléfono.

select  RazonSocial,Cuit,Email,TelefonoMovil from Clientes where Email is not null and TelefonoMovil is null

--23 Listado de razón social, cuit, email y celular de aquellos clientes que no tengan mail pero sí teléfono.

select RazonSocial,Cuit,Email,TelefonoMovil from Clientes where Email is null and TelefonoMovil is not null

--24 Listado de razón social, cuit, email, teléfono o celular de aquellos clientes que tengan mail o teléfono o celular .

select RazonSocial,Cuit,Coalesce(Email,'Sin email') as 'Mail', Coalesce(TelefonoFijo,TelefonoMovil,'Sin telefono') as 'Telefono' from Clientes

--25 Listado de razón social, cuit y mail. Si no dispone de mail debe aparecer el texto "Sin mail".

select RazonSocial,Cuit, ISNULL(Email,'sin mail') from Clientes --usar el isnull o coalesce en si es lo mismo, pero la segunda forma te permite anidar de una manera mas simplificada

--26 Listado de razón social, cuit y una columna llamada Contacto con el mail, si no posee mail, con el número de celular y si no posee número de celular con un texto que diga "Incontactable"

select RazonSocial,cuit, coalesce(Email,TelefonoMovil,TelefonoFijo,'Incontactable') as 'Contacto' from Clientes