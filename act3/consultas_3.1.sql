use blueprint

go
--1 Hacer un reporte que liste por cada tipo de tarea se liste el nombre, el precio de hora base y el promedio de valor hora real 
--(obtenido de las colaboraciones).

create view vw_tipos_tareas
AS
    select
        TT.Nombre,
        TT.PrecioHoraBase,
        (
        select AVG(colab.PrecioHora)
        from Colaboraciones as colab
            inner join tareas on colab.IDTarea = Tareas.ID
        where Tareas.IDTipo = TT.ID
    ) as 'prom. Valor de hora'
    from TiposTarea as TT

go

select *
from vw_tipos_tareas

go

--2 Modificar el reporte de (1) para que también liste una columna llamada Variación con las siguientes reglas:
--Poca → Si la diferencia entre el promedio y el precio de hora base es menor a $500.
--Mediana → Si la diferencia entre el promedio y el precio de hora base está entre $501 y $999.
--Alta → Si la diferencia entre el promedio y el precio de hora base es $1000 o más.

alter view vw_tipos_tareas
AS
    select aux.*,
        case 
when aux.promHora - aux.PrecioHoraBase < 500 then 'poca'
when aux.promHora - aux.PrecioHoraBase between 501 and 999 then 'mediana'
else 'alta'
end as variacion
    from(
    select
            TT.Nombre,
            TT.PrecioHoraBase, (
        select AVG(colab.PrecioHora)
            from Colaboraciones as colab
                inner join tareas on colab.IDTarea = Tareas.ID
            where Tareas.IDTipo = TT.ID
        ) as 'promHora'
        from TiposTarea as TT
) as aux

GO
--3 Crear un procedimiento almacenado que liste las colaboraciones de un colaborador cuyo ID se envía como parámetro.

create PROCEDURE listadoColaboraciones
    (
    @id int
)
AS
BEGIN
    select *
    from Colaboraciones as colabs
    where colabs.IDColaborador = @id
END

GO

exec listadoColaboraciones 1

GO

--4 Hacer una vista que liste por cada colaborador el apellido y nombre, el nombre del tipo (Interno o Externo) y la cantidad de proyectos 
--distintos en los que haya trabajado.
--Opcional: Hacer una aplicación en C# (consola, escritorio o web) que consuma la vista y la muestre por pantalla.

create view vw_colaboradores
as
    select
        Colaboradores.Apellido,
        Colaboradores.Nombre,
        Colaboradores.Tipo,
        (
            select COUNT(*)
        from Proyectos
            inner join Modulos on Modulos.IDProyecto = Proyectos.ID
            inner join tareas on tareas.IDModulo = Modulos.ID
            inner join Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
        where Colaboraciones.IDColaborador = Colaboradores.ID
        ) cantProyectos
    from Colaboradores

go

--5 Hacer un procedimiento almacenado que reciba dos fechas como parámetro y liste todos los datos de los proyectos que se encuentren entre 
--esas fechas.

alter PROCEDURE SP_proyectosPorFecha(
    @fecha1 date,
    @fecha2 date
)
AS
BEGIN
    select *
    from Proyectos
    where
    @fecha1 >= Proyectos.FechaInicio and
        @fecha2 <= Proyectos.FechaFin
end

GO

--6 Hacer un procedimiento almacenado que reciba un ID de Cliente, un ID de Tipo de contacto y un valor y modifique los datos de contacto de 
--dicho cliente. El ID de Tipo de contacto puede ser: 1 - Email, 2 - Teléfono y 3 - Celular.

create PROCEDURE sp_modificarContacto(
    @IDCliente int,
    @IDTipoContacto int,
    @valor VARCHAR(100)
)
as
begin
    if @IDTipoContacto = 1
        begin
        update Clientes
        set EMail=@valor
        where ID=@IDCliente
        end
    else
        BEGIN
            if @IDTipoContacto = 2
            begin
            UPDATE Clientes
            set Telefono=@valor
            where ID=@IDCliente
            end
        else
            begin
            UPDATE Clientes
            set Celular=@valor
            where ID=@IDCliente
            end
        end
end

go

--7 Hacer un procedimiento almacenado que reciba un ID de Módulo y realice la baja lógica tanto del módulo como de todas sus tareas futuras. 
--Utilizar una transacción para realizar el proceso de manera atómica.

create PROCEDURE SP_BajaModulo 
(
    @IDModulo int
)
AS
BEGIN

BEGIN TRY
    BEGIN TRANSACTION
        update Modulos
        set Estado = 0
        where Modulos.ID = @IDModulo

        update Tareas
        set Estado = 0
        where Tareas.IDModulo = @IDModulo and Tareas.FechaInicio > GETDATE()
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    RAISERROR('No se pudo realizar la baja',16,1)
END CATCH

END


