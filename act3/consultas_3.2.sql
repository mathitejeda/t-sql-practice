use BluePrint

Go
--1.Hacer un trigger que al ingresar una colaboración obtenga el precio de la misma a partir del precio hora base del tipo de tarea.
--Tener en cuenta que si el colaborador es externo el costo debe ser un 20% más caro.

create trigger TR_NUEVA_COLABORACION on colaboraciones
after insert
as
BEGIN
    declare @IDTarea int
    select @IDTarea= IDTarea from inserted
    declare @IDColaborador INT
    SELECT @IDColaborador=IDColaborador
    from inserted
    --Obtener el precio del tipo de tarea
    declare @precio money
    select @precio=TT.PrecioHoraBase
    from TiposTarea  as TT
    inner join tareas as T on TT.ID=T.IDTipo
    where T.ID=@IDTarea

    --Si el colaborador es externo aumentar 20%
    declare @TipoColab CHAR
    select @TipoColab=C.tipo
    from Colaboradores as C
    where C.ID=@IDColaborador
    
    if @TipoColab='E'begin
    set @precio=@precio*1.2 end

    update Colaboraciones set PrecioHora=@precio
    where IDColaborador=@IDColaborador and IDTarea=@IDTarea
end

GO

--2.Hacer un trigger que no permita que un colaborador registre más de 15 tareas en un mismo mes.
--De lo contrario generar un error con un mensaje aclaratorio.

CREATE TRIGGER TR_NUEVA_TAREA on colaboraciones
after insert
as
BEGIN
    declare @IDColaborador INT
    declare @IDTarea INT
    declare @FechaTarea DATE
    declare @cantTareas int
    select @IDColaborador=IDColaborador from inserted
    select @IDTarea=IDTarea from inserted

    --determinar fecha de la tarea
    select @FechaTarea=FechaInicio from tareas where tareas.ID=@IDTarea
    
    --determinar cantidad de tareas
    select @cantTareas=COUNT(C.IDTarea) from Colaboraciones as C
    inner join tareas as T on T.ID = C.IDTarea
    where MONTH(T.FechaInicio)=MONTH(@FechaTarea) and YEAR(T.FechaInicio)=YEAR(@FechaTarea)
    and C.IDColaborador=@IDColaborador

    --finally
    if @cantTareas>15 BEGIN
        DELETE from Colaboraciones where Colaboraciones.IDColaborador=@IDColaborador and IDTarea=@IDTarea 
        RAISERROR('No se pueden registrar mas de 15 colaboraciones en un mes',1,16)
    END
end

GO

--3.Hacer un trigger que al ingresar una tarea cuyo tipo contenga el nombre 'Programación' se agreguen automáticamente dos tareas 
--de tipo 'Testing unitario' y 'Testing de integración' de 4 horas cada una. La fecha de inicio y fin de las mismas debe ser NULL.


create TRIGGER TR_TAREA_PROGRAMACION on tareas
after insert as
begin
    declare @IDModulo int
    declare @IDTipo int 
    select @IDModulo=IDModulo from inserted
    select @IDTipo=IDTipo from inserted
    declare @Tipo varchar(50)
    --Almacenar el nombre de la tarea en una variable
    select @Tipo=TT.Nombre from TiposTarea as TT
    where TT.ID=@IDTipo
    --checkear si el tipo de tarea es programacion
    if @Tipo like '%programación%' 
    begin
        insert into tareas(IDModulo,IDTipo) values(@IDModulo,10)
        insert into tareas(IDModulo,IDTipo) values(@IDModulo,11)
    end
end 

GO
--4.Hacer un trigger que al borrar una tarea realice una baja lógica de la misma en lugar de una baja física.

create TRIGGER TR_BORRAR_TAREA on tareas
instead of DELETE
as begin
    declare @IDTarea INT
    select @IDTarea=ID from deleted

    UPDATE Tareas set Estado=0 where id=@IDTarea
end

GO
--5.Hacer un trigger que al borrar un módulo realice una baja lógica del mismo en lugar de una baja física. Además, debe borrar todas las 
--tareas asociadas al módulo.

--6.Hacer un trigger que al borrar un proyecto realice una baja lógica del mismo en lugar de una baja física. Además, debe borrar todas los 
--módulos asociados al proyecto.


--7.Hacer un trigger que si se agrega una tarea cuya fecha de fin es mayor a la fecha estimada de fin del módulo asociado a la tarea 
--entonces se modifique la fecha estimada de fin en el módulo.


--8.Hacer un trigger que al borrar una tarea que previamente se ha dado de baja lógica realice la baja física de la misma.


--9.Hacer un trigger que al ingresar una colaboración no permita que el colaborador/a superponga las fechas con las de otras colaboraciones 
--que se les hayan asignado anteriormente. En caso contrario, registrar la colaboración sino generar un error con un mensaje aclaratorio.


--10.Hacer un trigger que al modificar el precio hora base de un tipo de tarea registre en una tabla llamada HistorialPreciosTiposTarea el ID, 
--el precio antes de modificarse y la fecha de modificación. NOTA: La tabla debe estar creada previamente. NO crearla dentro del trigger.