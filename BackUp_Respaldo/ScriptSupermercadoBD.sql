USE supermercadodb
GO


/* *************************************************************************************************************************************************** */
-- CREANDO NUESTRAS TABLAS PRINCIPALES DE NUESTRA BASE DE DATOS DE SUPERMERCADO
  
CREATE TABLE formapago(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo VARCHAR (50)
)

CREATE TABLE motivocontrato(
	id INT IDENTITY(1,1) PRIMARY KEY,
	motivo VARCHAR (100)
)

CREATE TABLE contratos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fechainicio DATE,
	fechafinalizacion DATE,
	descripcion VARCHAR(255),
	monto DECIMAL(10,2),
	idformapago INT,
	FOREIGN KEY (idformapago) REFERENCES formapago(id),
	idmotivocontrato INT,
	FOREIGN KEY (idmotivocontrato) REFERENCES motivocontrato(id)
)

CREATE TABLE empresasasociadas(
	id INT IDENTITY(1,1) PRIMARY KEY,
	ruc BIGINT UNIQUE NOT NULL,
	nombre NVARCHAR(100) NOT NULL,
	direccion NVARCHAR(255),
	telefonoprivado NVARCHAR(12),
	telefonopublico NVARCHAR(12),
	idcontrato INT,
	FOREIGN KEY (idcontrato) REFERENCES contratos(id)
)

CREATE TABLE sucursales (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(255),
    ciudad NVARCHAR(50),
    telefono NVARCHAR(20)
)

CREATE TABLE empresassucursales(
	idempresa INT,
   	idsucursal INT,
   	PRIMARY KEY (idempresa, idsucursal),
   	FOREIGN KEY (idempresa) REFERENCES empresasasociadas(id),
   	FOREIGN KEY (idsucursal) REFERENCES sucursales(id)
)

CREATE TABLE tiposector(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100) NOT NULL
)

CREATE TABLE sectores(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100) NOT NULL,
	idtiposector INT,
	FOREIGN KEY (idtiposector) REFERENCES tiposector(id),
	idsucursal INT,
	FOREIGN KEY (idsucursal) REFERENCES sucursales(id)
)

CREATE TABLE tipocliente(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(50) NOT NULL,
)

CREATE TABLE clientes (
	dni INT PRIMARY KEY,
	nombre NVARCHAR(100) NOT NULL,
	apellidopaterno NVARCHAR(100) NOT NULL,
	apellidomaterno NVARCHAR(100) NOT NULL,
	idtipocliente INT,
	FOREIGN KEY (idtipocliente) REFERENCES tipocliente(id),
	fechanacimiento DATE
)

CREATE TABLE sectoresclientes(
	idsector INT,
	idcliente INT,
	PRIMARY KEY (idsector, idcliente),
	FOREIGN KEY (idsector) REFERENCES sectores(id),
	FOREIGN KEY (idcliente) REFERENCES clientes(dni)
)


CREATE TABLE tipoempleado(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100) NOT NULL,
	sueldo DECIMAL(10, 2) NOT NULL
)


CREATE TABLE empleados(
	dni INT PRIMARY KEY,
	codigo VARCHAR(50) NOT NULL UNIQUE,
	nombre NVARCHAR(100) NOT NULL,
	apellidopaterno NVARCHAR(100) NOT NULL,
	apellidomaterno NVARCHAR(100) NOT NULL,
	idtipoempleado INT,
	FOREIGN KEY (idtipoempleado) REFERENCES tipoempleado(id),
	fechacontrato DATE NOT NULL,
	horastrabajo DECIMAL(10, 2) NOT NULL,
	idsector INT,
	FOREIGN KEY (idsector) REFERENCES sectores(id)
)



CREATE TABLE tipoproducto (
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(50),
)

CREATE TABLE claseproducto(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(50),
	idtipoproducto INT,
	FOREIGN KEY (idtipoproducto) REFERENCES tipoproducto(id)
)

CREATE TABLE marcaproducto (
	id INT IDENTITY(1,1) PRIMARY KEY,
	marca NVARCHAR(50)
)

CREATE TABLE unidadmedida(
	id INT IDENTITY(1,1) PRIMARY KEY,
	unidadmedida VARCHAR(10)
)


CREATE TABLE motivodescuento(
	id INT IDENTITY(1,1) PRIMARY KEY,
	motivo VARCHAR(100)
)

CREATE TABLE descuentos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	descuento DECIMAL(10,2),
	idmotivodescuento INT,
	FOREIGN KEY (idmotivodescuento) REFERENCES motivodescuento(id)
)

CREATE TABLE productos (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(100),
	idclaseproducto INT,
	FOREIGN KEY (idclaseproducto) REFERENCES claseproducto(id),
	idmarca INT,
	FOREIGN KEY (idmarca) REFERENCES marcaproducto(id),
	descripcion NVARCHAR(255),
   	precio DECIMAL(10, 2) NOT NULL,
    fechavencimiento DATE,
	idsector INT,
	FOREIGN KEY (idsector) REFERENCES sectores(id),
	cantidad INT,
	contenidoneto DECIMAL(10, 2),
	idunidadmedida INT,
	FOREIGN KEY (idunidadmedida) REFERENCES unidadmedida(id),
	iddescuento INT,
	FOREIGN KEY (iddescuento) REFERENCES descuentos(id)
)

CREATE TABLE rol(
	id INT IDENTITY(1,1) PRIMARY KEY,
	rol NVARCHAR(100) NOT NULL
)

CREATE TABLE usuarios(
	dni INT PRIMARY KEY,
	codigo NVARCHAR(50),
	nombre NVARCHAR(100) NOT NULL,
	apellidopaterno NVARCHAR(100) NOT NULL,
	apellidomaterno NVARCHAR(100) NOT NULL,
	correo NVARCHAR(200) NOT NULL,
	contrasena NVARCHAR(100) NOT NULL,
	estado BIT NOT NULL,
	idrol INT,
	FOREIGN KEY (idrol) REFERENCES rol(id)
)

CREATE TABLE logprocesos (
	id INT IDENTITY(1,1) PRIMARY KEY,
	motivo NVARCHAR(100) NOT NULL,
	descripcion NVARCHAR(255),
	fecha DATETIME NOT NULL,
	dniusuario INT,
	FOREIGN KEY(dniusuario) REFERENCES usuarios(dni)
)


/* *************************************************************************************************************************************************** */
-- REALIZANDO INSERTS INICIALES EN NUESTRA BASE DE DATOS DE SUPER MERCADO
  

INSERT INTO rol(rol)
	VALUES	('Sistema'), ('Administrador'), ('Auditor')
GO

INSERT INTO usuarios(dni, codigo, nombre, apellidopaterno, apellidomaterno, correo, contrasena, estado, idrol)
	VALUES	(71143660, 'SIS-0001', 'Aldo Ray', 'Vasquez', 'Lopez', 'avasquezl@ulasalle.edu.pe', 'aldo123', 1, 1),
			(75185802, 'SIS-0002', 'Maria Fernada Adira', 'Pinazo', 'Vera', 'mpinazov@ulasalle.edu.pe', 'mafer123', 1, 1)
GO

INSERT INTO tipoproducto(tipo)
	VALUES	('Comestible'), ('Bebida'), ('Limpieza'), ('Tecnologia')
GO

INSERT INTO claseproducto(nombre, idtipoproducto)
	VALUES	('Snack', 1), ('Gaseosa', 2), ('Detergente', 3), ('Celular', 4)
GO

INSERT INTO marcaproducto(marca)
	VALUES	('Pepsico'), ('Pringles'), ('Coca Cola'), ('Kola Real'), ('AliCorp'), ('P&G'), ('Samsung'), ('Apple')
GO

INSERT INTO unidadmedida(unidadmedida)
	VALUES	('g'), ('ml')
GO

INSERT INTO motivodescuento(motivo)
	VALUES	('Dia de la Madre'), ('Dia del Padre'), ('Dia del Trabajador'), ('Aniversario')
GO

INSERT INTO descuentos(idmotivodescuento, descuento)
	VALUES	(1, 18), (2, 17), (3, 16), (4, 20)
GO


INSERT INTO sucursales(nombre, direccion, ciudad, telefono)

	VALUES
	('Compra segura', 'Av. Villa Placentera 504', 'Arequipa', '952256632'),
	('Compra mas', 'Av. Cercado de Leon 105', 'Arequipa', '952253321')

GO


INSERT INTO tiposector(tipo)
	VALUES ('Limpieza'), ('Electrodomesticos'), ('Comestibles')
GO


INSERT INTO sectores (nombre, idtiposector, idsucursal)
VALUES
	('Limpieza para tu Hogar', 1, 1),
	('Electronicos y tú', 2, 1),
	('Come cuanto puedas', 3, 1),
	('Limpieza y tú', 1, 2),
	('Electronicos y más', 2, 2),
	('Comida para ti', 3, 2)
GO



INSERT INTO tipocliente(tipo)
	VALUES ('Nuevo'), ('Regular'), ('Constante')
GO


INSERT INTO clientes
           (dni, nombre, apellidopaterno, apellidomaterno, idtipocliente, fechanacimiento)
     VALUES
           (200000001, 'Juan', 'Pérez', 'Gómez', 1, '1990-05-15'),
           (200000002, 'María', 'López', 'Martínez', 2, '1985-08-20'),
           (200000003, 'Carlos', 'González', 'Hernández', 3, '1982-04-10'),
           (200000004, 'Ana', 'Rodríguez', 'García', 1, '1992-09-25'),
           (200000005, 'Pedro', 'Martínez', 'Fernández', 2, '1988-06-30'),
           (200000006, 'Laura', 'Sánchez', 'López', 3, '1995-03-12'),
           (200000007, 'José', 'Gómez', 'Pérez', 1, '1980-11-08'),
           (200000008, 'Sofía', 'Hernández', 'Martínez', 2, '1979-07-17'),
           (200000009, 'Luis', 'Díaz', 'González', 3, '1998-01-04'),
           (200000010, 'Elena', 'Pérez', 'Rodríguez', 1, '1991-02-28'),
           (200000011, 'Mario', 'García', 'López', 2, '1986-10-22'),
           (200000012, 'Ana', 'Martínez', 'Gómez', 3, '1983-12-19'),
           (200000013, 'Juan', 'López', 'Fernández', 1, '1977-06-14'),
           (200000014, 'María', 'González', 'Hernández', 2, '1993-08-03'),
           (200000015, 'Pedro', 'Martínez', 'Pérez', 3, '1989-04-27'),
           (200000016, 'Laura', 'Hernández', 'García', 1, '1984-03-08'),
           (200000017, 'José', 'Pérez', 'Martínez', 2, '1978-09-01'),
           (200000018, 'Sofía', 'González', 'López', 3, '1996-11-11'),
           (200000019, 'Luis', 'Martínez', 'Hernández', 1, '1981-07-07'),
           (200000020, 'Elena', 'López', 'Gómez', 2, '1990-05-23'),
           (200000021, 'Andrea', 'Gómez', 'Fernández', 1, '1990-12-05'),
           (200000022, 'Miguel', 'Martínez', 'López', 2, '1985-07-18'),
           (200000023, 'Lucía', 'Hernández', 'González', 3, '1982-11-30'),
           (200000024, 'Gabriel', 'López', 'Pérez', 1, '1992-03-15'),
           (200000025, 'Paula', 'González', 'Martínez', 2, '1988-10-28'),
           (200000026, 'David', 'Hernández', 'Gómez', 3, '1995-04-02'),
           (200000027, 'Valentina', 'Martínez', 'Rodríguez', 1, '1980-09-10'),
           (200000028, 'Javier', 'Gómez', 'López', 2, '1979-06-23'),
           (200000029, 'Camila', 'Pérez', 'González', 3, '1998-01-14'),
           (200000030, 'Sebastián', 'López', 'Martínez', 1, '1991-02-08'),
           (200000031, 'Natalia', 'González', 'Hernández', 2, '1986-10-17'),
           (200000032, 'Diego', 'Martínez', 'Pérez', 3, '1983-12-22'),
           (200000033, 'Valeria', 'López', 'Gómez', 1, '1977-06-03'),
           (200000034, 'Juan', 'González', 'Martínez', 2, '1993-08-14'),
           (200000035, 'María', 'Pérez', 'Hernández', 3, '1989-04-29'),
           (200000036, 'Pedro', 'López', 'González', 1, '1984-02-18'),
           (200000037, 'Laura', 'Martínez', 'Pérez', 2, '1978-08-11'),
           (200000038, 'Carlos', 'González', 'López', 3, '1996-11-01'),
           (200000039, 'Ana', 'Pérez', 'Martínez', 1, '1981-07-25'),
           (200000040, 'José', 'González', 'Hernández', 2, '1990-05-02'),
           (200000041, 'Andrés', 'Martínez', 'Gómez', 1, '1990-12-05'),
           (200000042, 'Valentina', 'López', 'Martínez', 2, '1985-07-18'),
           (200000043, 'Santiago', 'Gómez', 'Hernández', 3, '1982-11-30'),
           (200000044, 'Juliana', 'Hernández', 'Pérez', 1, '1992-03-15'),
           (200000045, 'Alejandro', 'Martínez', 'González', 2, '1988-10-28'),
           (200000046, 'Florencia', 'Gómez', 'López', 3, '1995-04-02'),
           (200000047, 'Matías', 'Pérez', 'Martínez', 1, '1980-09-10'),
           (200000048, 'Luciana', 'Martínez', 'López', 2, '1979-06-23'),
           (200000049, 'Emilia', 'González', 'Pérez', 3, '1998-01-14'),
           (200000050, 'Ignacio', 'López', 'González', 1, '1991-02-08'),
           (200000051, 'Renata', 'Martínez', 'Hernández', 2, '1986-10-17'),
           (200000052, 'Gonzalo', 'López', 'Pérez', 3, '1983-12-22'),
           (200000053, 'Abril', 'Martínez', 'González', 1, '1977-06-03'),
           (200000054, 'Sebastián', 'Gómez', 'López', 2, '1993-08-14'),
           (200000055, 'Martina', 'López', 'Martínez', 3, '1989-04-29'),
           (200000056, 'Facundo', 'González', 'Gómez', 1, '1984-02-18'),
           (200000057, 'Romina', 'Martínez', 'López', 2, '1978-08-11'),
           (200000058, 'Tobías', 'López', 'González', 3, '1996-11-01'),
           (200000059, 'Valeria', 'González', 'Martínez', 1, '1981-07-25'),
           (200000060, 'Lautaro', 'López', 'Gómez', 2, '1990-05-02')

GO


INSERT INTO sectoresclientes (idsector, idcliente)
VALUES
    (1, 200000016), (1, 200000015), (1, 200000059), (1, 200000060), (1, 200000009), (1, 200000045), (1, 200000057), (1, 200000002), (1, 200000033), (1, 200000027), (1, 200000012), (1, 200000018),
    (2, 200000034), (2, 200000012), (2, 200000023), (2, 200000005), (2, 200000048), (2, 200000033), (2, 200000041), (2, 200000030), (2, 200000007), (2, 200000022), (2, 200000003), (2, 200000019), (2, 200000025),
    (3, 200000011), (3, 200000029), (3, 200000050), (3, 200000021), (3, 200000036), (3, 200000019), (3, 200000006), (3, 200000040), (3, 200000004), (3, 200000017), (3, 200000010),
    (4, 200000054), (4, 200000003), (4, 200000025), (4, 200000039), (4, 200000027), (4, 200000002), (4, 200000043), (4, 200000028), (4, 200000001), (4, 200000044), (4, 200000013), (4, 200000007),
    (5, 200000013), (5, 200000030), (5, 200000058), (5, 200000031), (5, 200000038), (5, 200000020), (5, 200000049), (5, 200000024), (5, 200000014), (5, 200000008), (5, 200000006), (5, 200000042), (5, 200000009), (5, 200000011),
    (6, 200000047), (6, 200000014), (6, 200000053), (6, 200000004), (6, 200000001), (6, 200000055), (6, 200000046), (6, 200000035), (6, 200000023), (6, 200000018), (6, 200000005), (6, 200000012), (6, 200000050), (6, 200000052), (6, 200000026)
GO


INSERT INTO formapago(tipo)
VALUES
	('Efectivo'), ('Tarjeta')
GO


INSERT INTO motivocontrato(motivo)
VALUES
	('Alquiler')
GO

INSERT INTO contratos(fechainicio, fechafinalizacion, descripcion, monto, idformapago, idmotivocontrato)
VALUES
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1),
	('2024-01-01', '2024-12-31', 'Este contrato ha sido registrado bajo ley, se debe respetar durante la fecha acordada.', 2500, 1, 1)
GO


INSERT INTO empresasasociadas
           (ruc, nombre, direccion, telefonoprivado, telefonopublico, idcontrato)
     VALUES
           (10000000004, 'Supermercado El Paraíso', 'Av. Paraíso 123', '123456789', '987654321', 1),
           (10000000005, 'Librería Los Escritores', 'Calle de los Libros 456', '987654321', '123456789', 2),
           (10000000006, 'Cafetería La Esquina', 'Plaza Central 789', '456789012', '789012345', 3),
           (10000000007, 'Inmobiliaria Del Valle', 'Av. Real 321', '123456789', '987654321', 4),
           (10000000008, 'Ferretería El Martillo', 'Calle del Hierro 654', '987654321', '123456789', 5),
           (10000000009, 'Laboratorio BioSalud', 'Av. de la Ciencia 789', '456789012', '789012345', 6),
           (10000000010, 'Pizzería Bella Napoli', 'Av. Italia 123', '123456789', '987654321', 7),
           (10000000011, 'Carnicería Don Juan', 'Calle de las Carnes 456', '987654321', '123456789', 8),
           (10000000012, 'Florería Flores del Campo', 'Plaza de las Flores 789', '456789012', '789012345', 9),
           (10000000013, 'Veterinaria Animalia', 'Av. de los Animales 321', '123456789', '987654321', 10),
           (10000000014, 'Óptica Visión Perfecta', 'Calle de la Visión 654', '987654321', '123456789', 11),
           (10000000015, 'Panadería El Horno Mágico', 'Av. del Pan 789', '456789012', '789012345', 12),
           (10000000016, 'Gimnasio Fitness World', 'Av. de la Salud 123', '123456789', '987654321', 13),
           (10000000017, 'Mueblería Hogar Feliz', 'Calle de los Muebles 456', '987654321', '123456789', 14),
           (10000000018, 'Estudio de Arquitectura Creativa', 'Plaza del Diseño 789', '456789012', '789012345', 15),
           (10000000019, 'Taller Automotriz Rápido y Seguro', 'Av. de los Autos 321', '123456789', '987654321', 16),
           (10000000020, 'Academia de Idiomas Polyglot', 'Calle de los Idiomas 654', '987654321', '123456789', 17),
           (10000000021, 'Tienda de Juguetes El Mundo de los Niños', 'Av. de los Juguetes 789', '456789012', '789012345', 18),
           (10000000022, 'Centro de Estética Bella Piel', 'Av. de la Belleza 123', '123456789', '987654321', 19),
           (10000000023, 'Centro Cultural La Plaza', 'Calle del Arte 456', '987654321', '123456789', 20)
GO


INSERT INTO empresassucursales(idempresa, idsucursal)
VALUES
	(12, 1), (6, 1), (15, 1), (19, 1), (2, 1), (18, 1), (7, 1), (3, 1), (10, 1), (14, 1),
	(4, 2), (7, 2), (8, 2), (20, 2), (13, 2), (11, 2), (9, 2), (5, 2), (16, 2), (17, 2);
GO



INSERT INTO tipoempleado(tipo, sueldo)
	VALUES	('Cajero', 1200), ('Seguridad', 1350), ('Limpieza', 1150)
GO


INSERT INTO empleados(dni, codigo, nombre, apellidopaterno, apellidomaterno, idtipoempleado, fechacontrato, horastrabajo, idsector)
	VALUES	
	-- Cajeros
	(45568923, 'EMP-0001', 'Ernesto', 'Garcia', 'Lopez', 1, '2024-01-01', 50, 1),
	(89895612, 'EMP-0002', 'Angel', 'Medina', 'Vasquez', 1, '2024-01-01', 50, 1),
	(78561245, 'EMP-0003', 'Luis', 'Torres', 'Manrique', 1, '2024-01-01', 50, 1),
	(89653526, 'EMP-0004', 'Roberto', 'Egusquiza', 'Fernandez', 1, '2024-01-01', 50, 1),

	-- Seguridad
	(12547896, 'EMP-0005', 'Carlos', 'Fernandez', 'Rojas', 2, '2024-01-01', 50, 1),
	(23659874, 'EMP-0006', 'Miguel', 'Ramirez', 'Quispe', 2, '2024-01-01', 50, 1),
	(36987412, 'EMP-0007', 'Jose', 'Martinez', 'Silva', 2, '2024-01-01', 50, 1),
	(47896521, 'EMP-0008', 'Juan', 'Paredes', 'Gutierrez', 2, '2024-01-01', 50, 1),

	-- Limpieza
	(58963214, 'EMP-0009', 'Pedro', 'Sanchez', 'Vargas', 3, '2024-01-01', 50, 1),
	(69874523, 'EMP-0010', 'Martin', 'Mendoza', 'Salas', 3, '2024-01-01', 50, 1),
	(78965412, 'EMP-0011', 'Andres', 'Guzman', 'Rios', 3, '2024-01-01', 50, 1),
	(89654732, 'EMP-0012', 'Manuel', 'Ortega', 'Castro', 3, '2024-01-01', 50, 1),

	-- Cajeros adicionales
	(14568923, 'EMP-0013', 'Mario', 'Lopez', 'Martinez', 1, '2024-01-01', 50, 2),
	(19895612, 'EMP-0014', 'Jorge', 'Hernandez', 'Diaz', 1, '2024-01-01', 50, 2),
	(27561245, 'EMP-0015', 'Ricardo', 'Gonzalez', 'Jimenez', 1, '2024-01-01', 50, 2),
	(39653526, 'EMP-0016', 'Victor', 'Ruiz', 'Navarro', 1, '2024-01-01', 50, 2),

	-- Seguridad adicionales
	(52547896, 'EMP-0017', 'Sebastian', 'Reyes', 'Ortega', 2, '2024-01-01', 50, 2),
	(63659874, 'EMP-0018', 'Ramiro', 'Soto', 'Ramos', 2, '2024-01-01', 50, 2),
	(76987412, 'EMP-0019', 'Rafael', 'Vega', 'Molina', 2, '2024-01-01', 50, 2),
	(87896521, 'EMP-0020', 'Emilio', 'Flores', 'Castillo', 2, '2024-01-01', 50, 2),

	-- Limpieza adicionales
	(98963214, 'EMP-0021', 'Oscar', 'Alvarez', 'Pena', 3, '2024-01-01', 50, 2),
	(10874523, 'EMP-0022', 'Hugo', 'Mora', 'Cruz', 3, '2024-01-01', 50, 2),
	(11965412, 'EMP-0023', 'Diego', 'Ponce', 'Herrera', 3, '2024-01-01', 50, 2),
	(12954732, 'EMP-0024', 'Antonio', 'Campos', 'Espinoza', 3, '2024-01-01', 50, 2)
GO


INSERT INTO productos(nombre, idclaseproducto, idmarca, descripcion, precio, fechavencimiento, idsector, cantidad, contenidoneto, idunidadmedida, iddescuento)
	VALUES	('Lays', 1, 1, 'Papitas Fritas Crujientes', 2.0, '2025-01-01', 1, 40, 56, 1, null),
			('Pringles', 1, 2, 'Papitas Fritas Crujientes', 12.0, '2025-01-01', 1, 25, 70, 1, null),
			('Fanta', 2, 3, 'Bebida refrescante sabor naranja', 2.5, '2025-01-01', 1, 100, 250, 2, null),
			('KR Naranja', 2, 4, 'Bebida gasificada sabor naranja', 1.0, '2025-01-01', 1, 250, 180, 2, null),
			('ACE', 3, 5, 'Detergente Aromatico multiuso', 25.0, '2027-01-01', 2, 30, 1500, 1, null),
			('Bolivar', 3, 6, 'Jabón Olor Lavanderia', 25.0, '2027-01-01', 2, 75, 60, 1, null),
			('Samsung 21', 4, 7, 'Ultimo en Tecnologia', 1250.0, null, 2, 30, null, null, null),
			('IPhone 14', 4, 7, 'Tecnología de Última Novedad', 2150.0, null, 2, 35, null, null, null)
GO
