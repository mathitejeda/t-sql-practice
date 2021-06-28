use ModeloParcial1
GO
--Hacer un trigger que al cargar un crédito verifique que el importe del mismo sumado a los importes de los créditos que actualmente 
--solicitó esa persona no supere al triple de la declaración de ganancias.
--Sólo deben tenerse en cuenta en la sumatoria los créditos que no se encuentren cancelados.
--De no poder otorgar el crédito aclararlo con un mensaje.
Create TRIGGER TR_CARGA_CREDITO on Creditos
after insert AS
BEGIN
    --Declaracion de variables
    declare @importeCredito money
    declare @sumaImportes money
    declare @DeclaracionGanancias money
    declare @DNIPersona varchar(10)
    --Asignacion de variables
    select @importeCredito=Importe from inserted

    select @DNIPersona=DNI from inserted
    
    select @sumaImportes=SUM(Importe)
    from Creditos
    where DNI=@DNIPersona and Cancelado=0
    
    select @DeclaracionGanancias=DeclaracionGanancias
    from Personas
    where DNI=@DNIPersona
    --Metodos
    if @importeCredito+@sumaImportes>@DeclaracionGanancias
    BEGIN
        RAISERROR('No se puede otorgar el credito',16,1)
        ROLLBACK TRANSACTION --mucho muy importante
    END
END

GO

--testeo
/*
select              * from Bancos
insert into Creditos (IDBanco, DNI, Fecha, Importe, Plazo, Cancelado) values(1,'1111','2021-8-6',150000,5,0)
select * from Creditos where DNI=1111
delete from creditos where id=11
select  * from Personas where DNI=1111
*/

--Hacer un trigger que al eliminar un crédito realice la cancelación del mismo.

create trigger baja_credito on creditos
instead of delete AS
begin
    declare @IDCredito int
    select @IDCredito=@IDCredito from inserted

    update Creditos set Cancelado=1 where id=@IDCredito
end

GO

--2Hacer un trigger que no permita otorgar créditos con un plazo de 20 o más años a personas cuya declaración de ganancias sea menor al
--promedio de declaración de ganancias.

create trigger TR_CREDITOPLUS20 on creditos
after insert AS
BEGIN
    --declare
        declare @DNIPersona varchar(10)
        declare @gananciasPersona money
        declare @promedioGanancias money
        declare @plazoCredito SMALLINT
    --Asign
    select @DNIPersona=DNI from inserted
    select @plazoCredito=Plazo from inserted

    select @promedioGanancias=AVG(DeclaracionGanancias)
    from Personas
    
    select @gananciasPersona=DeclaracionGanancias
    from personas
    where DNI=@DNIPersona
    
    if @plazoCredito > 20 and @gananciasPersona < @promedioGanancias
    begin
        RAISERROR('No se puede otorgar el credito',16,1)
    end
end

GO
--Hacer un procedimiento almacenado que reciba dos fechas y liste todos los créditos otorgados entre esas fechas.
--Debe listar el apellido y nombre del solicitante, el nombre del banco, el tipo de banco, la fecha del crédito y el importe solicitado.

CREATE PROCEDURE PR_CREDITOSPORFECHAS(
    @fecha1 date,
    @fecha2 date
) AS
BEGIN
    select 
    P.Apellidos+' '+P.Nombres as 'Solicitante',
    B.Nombre as 'NombreBanco',
    B.Tipo as 'tipoBanco',
    C.Fecha as 'FechaCredito',
    c.Importe
    from creditos as C
        inner join Personas AS P on C.DNI=P.DNI 
        inner join bancos as B on C.IDBanco=B.ID
    where C.Fecha BETWEEN @fecha1 and @fecha2 
END

exec PR_CREDITOSPORFECHAS '2019/1/1','2020/8/5'
