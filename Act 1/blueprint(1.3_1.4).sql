CREATE DATABASE blueprint2

GO

USE blueprint2

GO

CREATE TABLE clientes(
    IDCliente int IDENTITY(1,1) PRIMARY KEY not null,
    razonSocial varchar(50) unique not null,
    CUIT VARCHAR(20) unique not null,
    mail VARCHAR(30) null,
    telefono varchar(20) null,
    celular varchar(20) NULL,
    tipoCliente int FOREIGN KEY REFERENCES tipoCliente(IDTipo)
);

GO

CREATE TABLE tipoCliente(
    IDTipo int PRIMARY KEY not null,
    nombre VARCHAR(15) not null
);

GO

CREATE TABLE proyectos(
    IDProyecto int IDENTITY(1,1) PRIMARY KEY not null,
    IDCliente int FOREIGN KEY REFERENCES clientes(IDCliente),
    nombre VARCHAR(30) not null,
    descripcion VARCHAR(100) not null,
    fechaInicio DATE not null,
    fechaFin DATE null,
    costoEstimado money not null,
    vigente BIT not null
);

GO

CREATE TABLE modulos(
    IDModulo int PRIMARY KEY IDENTITY(1,1),
    IDProyecto int FOREIGN KEY REFERENCES proyectos(IDProyecto),
    nombre VARCHAR(15) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    costo money NOT NULL
);

GO

CREATE TABLE duracionModulo(
    IDModulo int PRIMARY KEY REFERENCES modulos(IDModulo),
    fechaInicio DATE NOT NULL,
    finEstimado DATE NOT NULL,
    finReal DATE NULL,
    horasEstimadas TIME NOT NULL,
    duracion DATE null,
    difDuracionEstimada DATE NULL,
);

GO

CREATE TABLE colaborador(
    IDColaborador int PRIMARY KEY IDENTITY(1,1),
    nombres varchar(15) NOT NULL,
    apellidos varchar(15) NOT NULL,
    edad TINYINT NOT NULL,
    tipo char not NULL CHECK(tipo='I' or tipo='E'),

);

CREATE TABLE pais(
    codigoPais varchar(2) PRIMARY KEY,
    nombrePais varchar(10)
);

CREATE TABLE localidad(
    IDLocalidad INT PRIMARY KEY IDENTITY(1,1),
    codigoPais varchar(2) FOREIGN KEY REFERENCES pais(codigoPais),
    nombreLocalidad VARCHAR(15)
);

CREATE TABLE contactoColaborador(
    IDColaborador INT PRIMARY KEY REFERENCES colaborador(IDColaborador),
    mail VARCHAR(50),
    celular VARCHAR(20),
    domicilio VARCHAR(30),
    IDLocalidad int FOREIGN KEY REFERENCES localidad(IDLocalidad)
);

GO

CREATE TABLE tareas(
    IDTarea INT PRIMARY KEY IDENTITY(1,1),
    IDModulo INT FOREIGN KEY REFERENCES modulos(IDModulo),
    TipoTarea varchar(50) not null,
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    Estado BIT NOT NULL
);

GO

CREATE TABLE colaboracion(
    IDColaborador INT  REFERENCES colaborador(IDColaborador),
    IDTarea INT REFERENCES tareas(IDTarea),
    HorasDeTrabajo TIME NULL,
    PrecioPorHora MONEY NOT NULL,
    Estado BIT NOT NULL,
    CONSTRAINT [pk_colaboracion] PRIMARY KEY CLUSTERED (IDColaborador,IDTarea)
);