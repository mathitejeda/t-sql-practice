use BluePrint
--1.Hacer un trigger que al ingresar una colaboración obtenga el precio de la misma a partir del precio hora base del tipo de tarea.
--Tener en cuenta que si el colaborador es externo el costo debe ser un 20% más caro.



--2.Hacer un trigger que no permita que un colaborador registre más de 15 tareas en un mismo mes.
--De lo contrario generar un error con un mensaje aclaratorio.


--3.Hacer un trigger que al ingresar una tarea cuyo tipo contenga el nombre 'Programación' se agreguen automáticamente dos tareas 
--de tipo 'Testing unitario' y 'Testing de integración' de 4 horas cada una. La fecha de inicio y fin de las mismas debe ser NULL. Calcular el costo estimado de la tarea.


--4.Hacer un trigger que al borrar una tarea realice una baja lógica de la misma en lugar de una baja física.

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