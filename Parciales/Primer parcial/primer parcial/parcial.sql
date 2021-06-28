use parcial1

GO



--1) Listado con Apellido y nombres de los técnicos que, en promedio, hayan demorado
--más de 225 minutos en la prestación de servicios.

select
    tec.Apellido,
    tec.Nombre
from tecnicos as tec
where 255 < (
    select avg(serv.Duracion)
from Servicios as serv
where tec.ID = serv.IDTecnico
)

--Verificacion(o otra forma de hacerlo):
select
    tec.Apellido,
    tec.Nombre,
    avg(Servicios.Duracion) as 'promedio'
from tecnicos as tec
    inner join Servicios on Servicios.IDTecnico = tec.ID
where 'promedio' < 255
GROUP by tec.Apellido, tec.Nombre



--2) ID, Apellido y nombres de los técnicos que hayan otorgado más días de garantía en
--algún servicio que el máximo de días de garantía otorgado a un servicio de tipo
--"Reparacion de heladeras".

select distinct
    tec.ID,
    tec.Apellido,
    tec.Nombre
from tecnicos as tec
    join(
        select s.ID, s.IDTecnico, sum(s.DiasGarantia) as dias
    from Servicios as S
        inner join TiposServicio as ts on s.IDTipo = ts.ID
    where ts.Descripcion not like 'Reparacion de heladeras'
    GROUP by S.ID, s.IDTecnico
    ) as diasGarantia on diasGarantia.IDTecnico = tec.ID
where
    (
        select max(Servicios.DiasGarantia)
-- El maximo es 176
from Servicios
    inner join TiposServicio as ts on ts.ID = Servicios.IDTipo
where TS.Descripcion like 'Reparacion de heladeras'
    ) < diasGarantia.dias

--3) Listado con Descripción del tipo de servicio y cantidad de clientes distintos de tipo
--Particular y la cantidad de clientes distintos de tipo Empresa.

select
    ts.Descripcion as 'tipo de servicio',
    (
        select COUNT(*)
    from Clientes
        inner join Servicios on Servicios.IDCliente = Clientes.ID
    where Clientes.Tipo = 'P' and servicios.IDTipo = ts.ID
    ) as 'Clientes particulares',
    (
        select COUNT(*)
    from Clientes
        inner join Servicios on Servicios.IDCliente = Clientes.ID
    where Clientes.Tipo = 'E' and servicios.IDTipo = ts.ID
    ) as 'Clientes Empresa'
from TiposServicio as ts

--4)Cantidad de clientes que hayan contratado la misma cantidad de servicios con
--garantía que servicios sin garantía.

select
    count(*) as clientes
from clientes
where
(
    select count(*)
from Servicios
where Servicios.IDCliente = Clientes.ID and Servicios.DiasGarantia = 0
) =
(
    select count(*)
from servicios
where servicios.IDCliente = Clientes.ID and Servicios.DiasGarantia > 0
)

-- Otra manera de solucionarlo

select
    count(*) as clientes
from clientes
    join
    (  
    select s.IDCliente ,count(*) as cant 
    from servicios as s
    where s.DiasGarantia = 0
    GROUP by s.IDCliente
    ) as sinGarantia on sinGarantia.IDCliente = Clientes.ID
    JOIN
    (
        select s.IDCliente, count(*) as cant 
        from servicios as s
        where s.DiasGarantia > 0
        GROUP by s.IDCliente
    ) as conGarantia on conGarantia.IDCliente = Clientes.ID
where sinGarantia.cant = conGarantia.cant

--5) Agregar las tablas y/o restricciones que considere necesario para permitir a un
--cliente que contrate a un técnico por un período determinado. Dicha contratación
--debe poder registrar la fecha de inicio y fin del trabajo, el costo total, el domicilio al
--que debe el técnico asistir y la periodicidad del trabajo (1 - Diario, 2 - Semanal, 3 -
--Quincenal).

CREATE TABLE contratos(
    ID int IDENTITY(1,1) PRIMARY KEY not null,
    IDTecnico int FOREIGN KEY REFERENCES tecnicos(ID) not null,
    IDCliente int FOREIGN key references clientes(ID) not null,
    fechaInicio date NOT NULL,
    fechaFin date NULL,
    costoTotal money NULL CHECK(costoTotal > 0),
    domicilio varchar(100) NOT NULL,
    periodo char NOT NULL check(periodo in('D','S','Q')),
    check(fechaInicio < fechaFin and fechaFin > fechaInicio)
);

create table serviciosPorContrato(
    IDContrato int foreign key references contratos(ID) not null,
    IDTipo int foreign key references TiposServicio(ID) not null
);