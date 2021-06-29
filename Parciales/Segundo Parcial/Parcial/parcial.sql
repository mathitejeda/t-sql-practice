use Parcial2

GO
--1) Hacer un trigger que al registrar una captura se verifique que la cantidad de capturas que haya realizado el competidor no supere las 
--reglamentadas por el torneo.
--Tampoco debe permitirse registrar más capturas si el competidor ya ha devuelto veinte peces o más en el torneo. 
--Indicar cada situación con un mensaje de error aclaratorio. Caso contrario, registrar la captura.

create trigger registrar_captura on capturas
after insert as
begin
    --Declaraciones
    declare @IDTorneo bigint
    declare @IDCompetidor bigint
    declare @MaxCapturas smallint
    declare @CantCapturas int
    declare @cantDevueltos INT
    --Asignaciones
    select @IDTorneo=IDTorneo
    from inserted 

    select @IDCompetidor=IDCompetidor
    from inserted

    select @MaxCapturas=CapturasPorCompetidor
    from torneos
    where ID=@IDTorneo
    
    select @CantCapturas=count(*)
    from capturas
    where IDCompetidor=@IDCompetidor and IDTorneo=@IDTorneo

    select @cantDevueltos=COUNT(*) 
    from Capturas
    where Devuelta=1 and IDCompetidor=@IDCompetidor and IDTorneo=IDTorneo

    --Verificar que las capturas no superen el limite maximo
    if @CantCapturas > @MaxCapturas
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('La cantidad de capturas supera la maxima reglamentada',16,1) 
    END

    --Verificar que no se hayan devuelto 20 peces o mas
    if @cantDevueltos >= 20
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('El competidor ya devolvio mas de 20 peces',16,1)
    END
end

GO

--2) Hacer un trigger que no permita que al cargar un torneo se otorguen más de un millón de pesos en premios entre todos los torneos de ese mismo
--año. En caso de ocurrir indicar el error con un mensaje aclaratorio. Caso contrario, registrar el torneo.

create trigger TR_PREMIOS_TORNEO on torneos
after insert as
BEGIN
    -- declaracion
    declare @totalPremios money
    declare @anioTorneo smallint
    
    select @anioTorneo=Año
    from inserted

    select @totalPremios=SUM(T.Premio)
    from Torneos as T
    where T.Año=@anioTorneo

    if @totalPremios>1000000
    BEGIN
        RAISERROR('No se pueden otorgar mas de un millon de pesos entre todos los torneos',16,1)
        ROLLBACK TRANSACTION
    END
END

GO

--3) Hacer un trigger que al eliminar una captura sea marcada como devuelta y que al eliminar una captura que ya se encuentra como devuelta 
--se realice la baja física del registro.
create trigger eliminar_captura on capturas
instead of delete AS
BEGIN
    declare @IDCaptura bigint
    declare @devuelta bit

    select @IDCaptura=ID
    from deleted

    select @devuelta=Devuelta
    from deleted

    if @devuelta=1
    BEGIN
        delete from Capturas where id=@IDCaptura
    END
    else
    BEGIN
        update Capturas SET Devuelta=1 where id=@IDCaptura
    END
end

GO

--4) Hacer un procedimiento almacenado que a partir de un IDTorneo indique los datos del ganador del mismo.
--El ganador es aquel pescador que haya sumado la mayor cantidad de puntos en el torneo.
--Se suman 3 puntos por cada pez capturado y se resta un punto por cada pez devuelto.
--Indicar Nombre, Apellido, Puntos y Categoría del pescador: ('El viejo Santiago' mayor a 65 años, 'Serge Ladko' entre 23 y 65 años,
--'Manolín' entre 16 y 22 años).
--NOTA: El primer puesto puede ser un empate entre varios competidores, en ese caso mostrar la información de todos los ganadores.


create procedure PR_GANADOR_TORNEO(
    @IDTorneo bigint
) AS
BEGIN
    select distinct top (1) with ties
        comp.Nombre,
        comp.Apellido, 
        (
            select count(*) *3
            from Capturas as cap2
            where cap2.IDCompetidor=comp.ID
            and cap2.Devuelta=0
        ) -
        (
            select count(*)
            from capturas as cap3
            where cap3.IDCompetidor=comp.ID and cap3.Devuelta =1 
        ) as puntos,
        case
            when year(GETDATE()) - comp.AñoNacimiento > 65 then 'Mayor a 65 años'
            when year(GETDATE()) - comp.AñoNacimiento between 23 and 65 then 'Entre 23 y 65'
            when year(GETDATE()) - comp.AñoNacimiento between 16 and 22 then 'Entre 16 y 22'
            when year(GETDATE()) - comp.AñoNacimiento < 16 then 'Menor a 16'
        end as categoria
    from Torneos as T
        inner join Capturas as cap on T.ID = cap.IDTorneo
        inner join Competidores as comp on cap.IDCompetidor=comp.ID
    where T.ID=@IDTorneo
    order by puntos DESC
END

insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(2,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(3,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(5,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(6,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(6,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(5,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(2,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(7,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(8,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(8,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(3,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(7,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(8,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(8,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(9,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(2,1,1,GETDATE(),1.5,0)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(1,1,1,GETDATE(),1.5,1)
insert into capturas(IDCompetidor,IDTorneo,IDEspecie,FechaHora,Peso,Devuelta) VALUES(3,1,1,GETDATE(),1.5,0)

update capturas set Devuelta=0 where ID=17
delete from Capturas where id=22
exec PR_GANADOR_TORNEO 1

