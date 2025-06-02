-- Creación de la base de datos
CREATE DATABASE ClientesDB;
GO

USE ClientesDB;
GO

-- Usuarios del sistema
CREATE TABLE usuario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario NVARCHAR(50) NOT NULL UNIQUE,
    contrasenia NVARCHAR(100) NOT NULL,
    nombre_completo NVARCHAR(100) NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE()
);
GO

-- Información general de clientes
CREATE TABLE cliente_encabezado (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    correo NVARCHAR(100),
    telefono NVARCHAR(20),
    direccion NVARCHAR(200),
    creado_por INT NOT NULL,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (creado_por) REFERENCES usuario(id)
);
GO

-- Detalles adicionales de clientes
CREATE TABLE cliente_detalle (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    valor NVARCHAR(255),
    fecha_registro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (cliente_id) REFERENCES cliente_encabezado(id)
);
GO

-- Registro de actividades realizadas sobre los clientes
CREATE TABLE bitacora_clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    usuario_id INT NOT NULL,
    accion NVARCHAR(50) NOT NULL, -- Ej: 'CREAR', 'ACTUALIZAR', 'ELIMINAR'
    descripcion NVARCHAR(500),     -- Detalles opcionales del cambio realizado
    fecha DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (cliente_id) REFERENCES cliente_encabezado(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);
GO

-- Agregamos dos usuarios para administrar el sistema
INSERT INTO usuario (usuario, contrasenia, nombre_completo)
VALUES 
('usuario1', '123456', 'Administrador Uno'),
('usuario2', '123456', 'Administrador Dos');
GO

select * from usuario;

-- Agregar algunos clientes para tener información de ellos
INSERT INTO cliente_encabezado (nombre, correo, telefono, direccion, creado_por)
VALUES 
('Carlos Ramírez', 'carlos@example.com', '55511234', 'Zona 1, Ciudad', 1),
('Ana López', 'ana@example.com', '55525678', 'Zona 2, Ciudad', 1),
('María González', 'maria@example.com', '55532345', 'Zona 3, Ciudad', 2),
('Luis Méndez', 'luis@example.com', '55547890', 'Zona 4, Ciudad', 2),
('Sofía Aguilar', 'sofia@example.com', '55554321', 'Zona 5, Ciudad', 1);
GO

select * from cliente_encabezado;

-- Agregar detalles adicionales de los clientes
INSERT INTO cliente_detalle (cliente_id, descripcion, valor)
VALUES 
(1, 'Dirección de envío', 'Avenida Reforma 10-20 Zona 9'),
(1, 'Observaciones', 'Cliente con historial positivo');

INSERT INTO cliente_detalle (cliente_id, descripcion, valor)
VALUES 
(2, 'Dirección secundaria', 'Boulevard Los Próceres, Zona 10');

INSERT INTO cliente_detalle (cliente_id, descripcion, valor)
VALUES 
(3, 'Teléfono alternativo', '4000-1122'),
(3, 'Notas', 'Solicita factura con NIT');

INSERT INTO cliente_detalle (cliente_id, descripcion, valor)
VALUES 
(4, 'Observaciones', 'Cliente nuevo, requiere seguimiento');

INSERT INTO cliente_detalle (cliente_id, descripcion, valor)
VALUES 
(5, 'Dirección de oficina', 'Torre Empresarial, Zona 15'),
(5, 'Teléfono alternativo', '3000-4455');
GO

select * from cliente_detalle;

-- Agregar una columna de estado en la tabla cliente_encabezado para activarlo o desactivarlo y con ello no perder su información en caso de que se necesite recuperar el usuario
ALTER TABLE cliente_encabezado
ADD estado BIT NOT NULL DEFAULT 1;
GO

-- Procedimientos almacenados para administrar a los clientes

-- Agregar
CREATE PROCEDURE sp_insertar_cliente
    @nombre NVARCHAR(100),
    @correo NVARCHAR(100),
    @telefono NVARCHAR(20),
    @direccion NVARCHAR(200),
    @creado_por INT,
    @nuevo_id INT OUTPUT
AS
BEGIN
    INSERT INTO cliente_encabezado (nombre, correo, telefono, direccion, creado_por, estado)
    VALUES (@nombre, @correo, @telefono, @direccion, @creado_por, 1);

    SET @nuevo_id = SCOPE_IDENTITY();

    -- dejar constancia
    INSERT INTO bitacora_clientes (cliente_id, usuario_id, accion, descripcion)
    VALUES (@nuevo_id, @creado_por, 'CREAR', 'Cliente creado.');
END;
GO

-- Editar
CREATE PROCEDURE sp_actualizar_cliente
    @id INT,
    @nombre NVARCHAR(100),
    @correo NVARCHAR(100),
    @telefono NVARCHAR(20),
    @direccion NVARCHAR(200),
    @modificado_por INT
AS
BEGIN
    UPDATE cliente_encabezado
    SET nombre = @nombre,
        correo = @correo,
        telefono = @telefono,
        direccion = @direccion
    WHERE id = @id AND estado = 1;

    -- dejar registro de acción
    INSERT INTO bitacora_clientes (cliente_id, usuario_id, accion, descripcion)
    VALUES (@id, @modificado_por, 'ACTUALIZAR', 'Cliente actualizado.');
END;
GO

-- Eliminar
CREATE PROCEDURE sp_eliminar_cliente
    @id INT,
    @usuario_id INT
AS
BEGIN
    UPDATE cliente_encabezado
    SET estado = 0
    WHERE id = @id AND estado = 1;

    -- dejar registro de accion
    INSERT INTO bitacora_clientes (cliente_id, usuario_id, accion, descripcion)
    VALUES (@id, @usuario_id, 'DESHABILITAR', 'Cliente deshabilitado.');
END;
GO

CREATE PROCEDURE sp_listar_clientes_activos
AS
BEGIN
    SELECT ce.*, u.nombre_completo AS creado_por_nombre
    FROM cliente_encabezado ce
    JOIN usuario u ON ce.creado_por = u.id
    WHERE ce.estado = 1
    ORDER BY ce.fecha_creacion DESC;
END;
GO

CREATE PROCEDURE sp_listar_clientes_inactivos
AS
BEGIN
    SELECT ce.*, u.nombre_completo AS creado_por_nombre
    FROM cliente_encabezado ce
    JOIN usuario u ON ce.creado_por = u.id
    WHERE ce.estado = 0
    ORDER BY ce.fecha_creacion DESC;
END;
GO
