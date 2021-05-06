/* Relacion N:N: Estas tablas tienen relacion N:N porque en el juego cada pokemon puede tener uno o mas tipos, asi como estos tipos pueden ser asignados a
distintos pokemon */

create database pokedex

GO

use pokedex

GO

create table pokemon(
	numero bigint identity(1,1) primary key,
	nombre varchar(25) not null,
	descripcion varchar (100) not null,
	altura decimal not null check (altura > 0),
	peso decimal not null check(peso > 0),
	sexo char null,
)

GO

create table tipos(
	idtipo int identity(1,1) primary key,
	tipo varchar(25) not null
)

GO

create table tipo_por_pokemon(
	numero bigint not null foreign key references pokemon(numero),
	tipo int not null foreign key references tipos(idtipo)
)
