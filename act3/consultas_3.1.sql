use blueprint

go
--1 Hacer un reporte que liste por cada tipo de tarea se liste el nombre, el precio de hora base y el promedio de valor hora real 
--(obtenido de las colaboraciones).

create view vw_tipos_tareas AS
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

select * from vw_tipos_tareas

go

--2 Modificar el reporte de (1) para que también liste una columna llamada Variación con las siguientes reglas:
--Poca → Si la diferencia entre el promedio y el precio de hora base es menor a $500.
--Mediana → Si la diferencia entre el promedio y el precio de hora base está entre $501 y $999.
--Alta → Si la diferencia entre el promedio y el precio de hora base es $1000 o más.

alter view vw_tipos_tareas as
select
from
{

}

--3 Crear un procedimiento almacenado que liste las colaboraciones de un colaborador cuyo ID se envía como parámetro.

--4 Hacer una vista que liste por cada colaborador el apellido y nombre, el nombre del tipo (Interno o Externo) y la cantidad de proyectos 
--distintos en los que haya trabajado.
--Opcional: Hacer una aplicación en C# (consola, escritorio o web) que consuma la vista y la muestre por pantalla.


--5 Hacer un procedimiento almacenado que reciba dos fechas como parámetro y liste todos los datos de los proyectos que se encuentren entre 
--esas fechas.


--6 Hacer un procedimiento almacenado que reciba un ID de Cliente, un ID de Tipo de contacto y un valor y modifique los datos de contacto de 
--dicho cliente. El ID de Tipo de contacto puede ser: 1 - Email, 2 - Teléfono y 3 - Celular.


--7 Hacer un procedimiento almacenado que reciba un ID de Módulo y realice la baja lógica tanto del módulo como de todas sus tareas futuras. 
--Utilizar una transacción para realizar el proceso de manera atómica.




