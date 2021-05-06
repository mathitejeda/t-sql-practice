CREATE DATABASE act1

GO

USE act1

GO

IF OBJECT_ID('Alumnos') IS NOT NULL
DROP TABLE Alumnos

GO

create table Alumnos (
    Legajo BIGINT IDENTITY(1000,1) PRIMARY KEY,
    IDCarrera varchar(4) NOT NULL foreign key REFERENCES Carreras(IDCarrera),
    Apellidos VARCHAR(30) NOT NULL,
    Nombres VARCHAR(30) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Mail VARCHAR(50) NOT NULL UNIQUE,
    Telefono INT NOT NULL
)

GO
IF OBJECT_ID('Carreras') IS NOT NULL
DROP TABLE Carreras
GO
create table Carreras(
    IDCarrera VARCHAR(4) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    FechaCreacion DATE NOT NULL check(SYSDATETIME() > FechaCreacion),
    Mail VARCHAR(50) NOT NULL,
    Nivel VARCHAR(30) NOT NULL check(Nivel ='Diplomatura' OR Nivel='Pregrado' OR Nivel='Grado' OR Nivel='Posgrado')
)

GO
IF OBJECT_ID('Materias') IS NOT NULL
DROP TABLE Materias
GO
create table Materias(
	IDMateria int IDENTITY(1,1) PRIMARY KEY,
	IDCarrera varchar(4) foreign key references Carreras(IDCarrera),
	Nombre varchar(30) NOT NULL,
	CargaHoraria int check(CargaHoraria > 0)
	
)