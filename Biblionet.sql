CREATE DATABASE biblionet1;
USE biblionet1;

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 3. Verificar la estructura de la tabla creada
DESCRIBE usuario;

SELECT * FROM usuario;

DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS Categoria;

CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Tabla: categoria
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Tabla: libros (con relaciones hacia autor y categoria)
CREATE TABLE libros (
    cod_libro INT AUTO_INCREMENT PRIMARY KEY,
    libro VARCHAR(255) NOT NULL,
    id_autor INT NOT NULL,
    edicion VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    cantidad INT NOT NULL,
    
    -- Clave foránea hacia la tabla autor
    CONSTRAINT fk_libros_autor 
        FOREIGN KEY (id_autor) 
        REFERENCES autor(id_autor) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
        
    -- Clave foránea hacia la tabla categoria
    CONSTRAINT fk_libros_categoria 
        FOREIGN KEY (id_categoria) 
        REFERENCES categoria(id_categoria) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- -------------------------------------------------------------
-- Datos de prueba iniciales (opcional para verificar)
-- -------------------------------------------------------------
INSERT INTO autor (nombres, apellidos, nacionalidad) VALUES 
('Gabriel', 'García Márquez', 'Colombiana'),
('Antoine', 'de Saint-Exupéry', 'Francesa'),
('Miguel', 'de Cervantes', 'Española');
INSERT INTO categoria (nombre_categoria) VALUES 
('Novela'),
('Fábula'),
('Clásico');
INSERT INTO libros (libro, id_autor, edicion, id_categoria, cantidad) VALUES 
('Cien Años de Soledad', 1, '1ra Edición', 1, 5),
('El Principito', 2, '2da Edición', 2, 10),
('Don Quijote de la Mancha', 3, 'Edición Conmemorativa', 3, 3);
-- -------------------------------------------------------------
-- Consulta de verificación con INNER JOIN
-- -------------------------------------------------------------
SELECT 
    l.cod_libro,
    l.libro,
    CONCAT(a.nombres, ' ', a.apellidos) AS autor,
    l.edicion,
    c.nombre_categoria AS categoria,
    l.cantidad
FROM libros l
INNER JOIN autor a ON l.id_autor = a.id_autor
INNER JOIN categoria c ON l.id_categoria = c.id_categoria;

CREATE TABLE IF NOT EXISTS estudiantes (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    tipo_usuario VARCHAR(50) NOT NULL,
    seccion VARCHAR(50) NOT NULL,
    anio VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE NOT NULL,
    CONSTRAINT fk_prestamos_estudiante 
        FOREIGN KEY (id_estudiante) REFERENCES estudiantes (codigo) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 2. Tabla detalle de préstamos (libros solicitados)
CREATE TABLE IF NOT EXISTS detalle_prestamos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    cod_libro INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_detalle_prestamo 
        FOREIGN KEY (id_prestamo) REFERENCES prestamos (id_prestamo) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_libro 
        FOREIGN KEY (cod_libro) REFERENCES libros (cod_libro) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS devoluciones (
    id_devolucion INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    cod_libro INT NOT NULL,
    fecha_entrega DATE NOT NULL,
    estado VARCHAR(50) DEFAULT 'Entregado',
    observaciones TEXT,
    CONSTRAINT fk_devolucion_prestamo FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo) ON DELETE CASCADE,
    CONSTRAINT fk_devolucion_libro FOREIGN KEY (cod_libro) REFERENCES libros(cod_libro) ON DELETE CASCADE
);

SELECT * FROM devoluciones;

-- Insertar 20 Categorías variadas
INSERT INTO Categoria (nombre_categoria) VALUES 
('Ficción Contemporánea'),
('Ciencia Ficción'),
('Fantasía'),
('Misterio y Suspenso'),
('Terror'),
('Romance'),
('Novela Histórica'),
('Biografía y Memorias'),
('Ensayo'),
('Poesía'),
('Desarrollo Personal'),
('Historia'),
('Filosofía'),
('Tecnología y Programación'),
('Ciencias Exactas'),
('Arte y Fotografía'),
('Cómics y Novelas Gráficas'),
('Literatura Infantil'),
('Literatura Juvenil'),
('Economía y Negocios');

-- Insertar 20 Autores de distintas nacionalidades
INSERT INTO Autor (nombres, apellidos, nacionalidad) VALUES 
('Gabriel', 'García Márquez', 'Colombiana'),
('J.K.', 'Rowling', 'Británica'),
('Stephen', 'King', 'Estadounidense'),
('Isabel', 'Allende', 'Chilena'),
('Jorge Luis', 'Borges', 'Argentina'),
('Haruki', 'Murakami', 'Japonesa'),
('Agatha', 'Christie', 'Británica'),
('George R.R.', 'Martin', 'Estadounidense'),
('Julio', 'Cortázar', 'Argentina'),
('Mario', 'Vargas Llosa', 'Peruana'),
('Isaac', 'Asimov', 'Estadounidense'),
('Edgar Allan', 'Poe', 'Estadounidense'),
('Jane', 'Austen', 'Británica'),
('Miguel', 'de Cervantes', 'Española'),
('Franz', 'Kafka', 'Checa'),
('H.P.', 'Lovecraft', 'Estadounidense'),
('J.R.R.', 'Tolkien', 'Británica'),
('Laura', 'Esquivel', 'Mexicana'),
('Paulo', 'Coelho', 'Brasileña'),
('Arthur', 'Conan Doyle', 'Británica');

DELIMITER //
-- =============================================================================
-- 1. PROCEDIMIENTOS DEL DASHBOARD (MÉTRICAS Y ESTADÍSTICAS)
-- =============================================================================
-- 1.1 Total de libros físicos en inventario
DELIMITER //
CREATE PROCEDURE sp_dashboard_total_libros()
BEGIN
    SELECT COALESCE(SUM(cantidad), 0) AS total_libros 
    FROM libros;
END //
-- 1.2 Total de préstamos activos (con libros pendientes de devolución)
DELIMITER //
CREATE PROCEDURE sp_dashboard_prestamos_activos()
BEGIN
    SELECT COUNT(DISTINCT p.id_prestamo) AS prestamos_activos
    FROM prestamos p
    INNER JOIN detalle_prestamos dp ON p.id_prestamo = dp.id_prestamo
    LEFT JOIN devoluciones d ON (d.id_prestamo = p.id_prestamo AND d.cod_libro = dp.cod_libro)
    WHERE d.id_devolucion IS NULL;
END //
-- 1.3 Total de devoluciones pendientes morosas (superaron la fecha límite)
DELIMITER //
CREATE PROCEDURE sp_dashboard_morosos()
BEGIN
    SELECT COUNT(DISTINCT p.id_prestamo) AS morosos
    FROM prestamos p
    INNER JOIN detalle_prestamos dp ON p.id_prestamo = dp.id_prestamo
    LEFT JOIN devoluciones d ON (d.id_prestamo = p.id_prestamo AND d.cod_libro = dp.cod_libro)
    WHERE d.id_devolucion IS NULL AND p.fecha_devolucion < CURDATE();
END //
-- 1.4 Actividad reciente: últimos 5 préstamos realizados
DELIMITER //
CREATE PROCEDURE sp_dashboard_actividad_reciente()
BEGIN
    SELECT 
        CONCAT(e.nombres, ' ', e.apellidos) AS estudiante,
        l.libro,
        p.fecha_prestamo
    FROM prestamos p
    INNER JOIN estudiantes e ON p.id_estudiante = e.codigo
    INNER JOIN detalle_prestamos dp ON p.id_prestamo = dp.id_prestamo
    INNER JOIN libros l ON dp.cod_libro = l.cod_libro
    ORDER BY p.fecha_prestamo DESC, p.id_prestamo DESC
    LIMIT 5;
END //
-- 1.5 Préstamos agrupados por mes en el año actual para el gráfico
DELIMITER //
CREATE PROCEDURE sp_dashboard_prestamos_por_mes()
BEGIN
    SELECT 
        MONTH(fecha_prestamo) AS mes_num,
        COUNT(*) AS total
    FROM prestamos
    WHERE YEAR(fecha_prestamo) = YEAR(CURDATE())
    GROUP BY MONTH(fecha_prestamo)
    ORDER BY mes_num ASC;
END //
-- =============================================================================
-- 2. PROCEDIMIENTOS DEL MÓDULO DEVOLUCIONES
-- =============================================================================
-- 2.1 Listar préstamos pendientes (agrupando libros con GROUP_CONCAT y días restantes)
DELIMITER //
CREATE PROCEDURE sp_listar_prestamos_pendientes(IN p_criterio VARCHAR(100))
BEGIN
    IF p_criterio IS NULL OR TRIM(p_criterio) = '' THEN
        SELECT 
            p.id_prestamo,
            GROUP_CONCAT(l.libro SEPARATOR ', ') AS libros_prestados,
            CONCAT(e.nombres, ' ', e.apellidos) AS nombreEstudiante,
            p.fecha_prestamo,
            p.fecha_devolucion,
            DATEDIFF(p.fecha_devolucion, CURDATE()) AS dias_restantes
        FROM prestamos p
        INNER JOIN detalle_prestamos dp ON p.id_prestamo = dp.id_prestamo
        INNER JOIN libros l ON dp.cod_libro = l.cod_libro
        INNER JOIN estudiantes e ON p.id_estudiante = e.codigo
        LEFT JOIN devoluciones d ON (d.id_prestamo = p.id_prestamo AND d.cod_libro = dp.cod_libro)
        WHERE d.id_devolucion IS NULL
        GROUP BY p.id_prestamo, e.nombres, e.apellidos, p.fecha_prestamo, p.fecha_devolucion
        ORDER BY p.id_prestamo DESC;
    ELSE
        SELECT 
            p.id_prestamo,
            GROUP_CONCAT(l.libro SEPARATOR ', ') AS libros_prestados,
            CONCAT(e.nombres, ' ', e.apellidos) AS nombreEstudiante,
            p.fecha_prestamo,
            p.fecha_devolucion,
            DATEDIFF(p.fecha_devolucion, CURDATE()) AS dias_restantes
        FROM prestamos p
        INNER JOIN detalle_prestamos dp ON p.id_prestamo = dp.id_prestamo
        INNER JOIN libros l ON dp.cod_libro = l.cod_libro
        INNER JOIN estudiantes e ON p.id_estudiante = e.codigo
        LEFT JOIN devoluciones d ON (d.id_prestamo = p.id_prestamo AND d.cod_libro = dp.cod_libro)
        WHERE d.id_devolucion IS NULL
          AND (CONCAT(e.nombres, ' ', e.apellidos) LIKE CONCAT('%', p_criterio, '%')
               OR CAST(e.codigo AS CHAR) LIKE CONCAT('%', p_criterio, '%')
               OR l.libro LIKE CONCAT('%', p_criterio, '%'))
        GROUP BY p.id_prestamo, e.nombres, e.apellidos, p.fecha_prestamo, p.fecha_devolucion
        ORDER BY p.id_prestamo DESC;
    END IF;
END //
-- 2.2 Registrar devolución de todos los libros de un préstamo e incrementar stock (+1)
DELIMITER //
CREATE PROCEDURE sp_registrar_devolucion_por_prestamo(
    IN p_id_prestamo INT,
    IN p_estado VARCHAR(50),
    IN p_observaciones TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    -- 1. Insertar en tabla devoluciones los libros pendientes de ese préstamo
    INSERT INTO devoluciones (id_prestamo, cod_libro, fecha_entrega, estado, observaciones)
    SELECT 
        dp.id_prestamo,
        dp.cod_libro,
        CURDATE(),
        COALESCE(p_estado, 'Entregado'),
        COALESCE(p_observaciones, 'Devolución registrada en sistema')
    FROM detalle_prestamos dp
    LEFT JOIN devoluciones d ON (d.id_prestamo = dp.id_prestamo AND d.cod_libro = dp.cod_libro)
    WHERE dp.id_prestamo = p_id_prestamo AND d.id_devolucion IS NULL;
    -- 2. Reintegrar la cantidad al stock de cada libro devuelto
    UPDATE libros l
    INNER JOIN detalle_prestamos dp ON l.cod_libro = dp.cod_libro
    SET l.cantidad = l.cantidad + dp.cantidad
    WHERE dp.id_prestamo = p_id_prestamo;
    COMMIT;
END //
-- =============================================================================
-- 3. PROCEDIMIENTOS DEL MÓDULO PRÉSTAMOS
-- =============================================================================
-- 3.1 Insertar cabecera de préstamo y retornar el ID generado
DELIMITER //
CREATE PROCEDURE sp_insertar_prestamo(
    IN p_id_estudiante INT,
    IN p_fecha_prestamo DATE,
    IN p_fecha_devolucion DATE,
    OUT p_id_prestamo INT
)
BEGIN
    INSERT INTO prestamos (id_estudiante, fecha_prestamo, fecha_devolucion)
    VALUES (p_id_estudiante, p_fecha_prestamo, p_fecha_devolucion);
    SET p_id_prestamo = LAST_INSERT_ID();
END //
-- 3.2 Insertar detalle de libro prestado y descontar stock (-1)
DELIMITER //
CREATE PROCEDURE sp_insertar_detalle_prestamo(
    IN p_id_prestamo INT,
    IN p_cod_libro INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    -- Insertar el detalle
    INSERT INTO detalle_prestamos (id_prestamo, cod_libro, cantidad)
    VALUES (p_id_prestamo, p_cod_libro, p_cantidad);
    -- Descontar del inventario
    UPDATE libros 
    SET cantidad = cantidad - p_cantidad 
    WHERE cod_libro = p_cod_libro;
    COMMIT;
END //
-- 3.3 Listar historial de préstamos con nombre de estudiante
DELIMITER //
CREATE PROCEDURE sp_listar_prestamos()
BEGIN
    SELECT 
        p.id_prestamo,
        p.id_estudiante,
        p.fecha_prestamo,
        p.fecha_devolucion,
        CONCAT(e.nombres, ' ', e.apellidos) AS nombreEstudiante
    FROM prestamos p
    INNER JOIN estudiantes e ON p.id_estudiante = e.codigo
    ORDER BY p.id_prestamo DESC;
END //
-- =============================================================================
-- 4. PROCEDIMIENTOS DEL MÓDULO LIBROS
-- =============================================================================
-- 4.1 Listar libros con nombres de autor y categoría (INNER JOIN)
DELIMITER //
CREATE PROCEDURE sp_listar_libros()
BEGIN
    SELECT 
        l.cod_libro,
        l.libro,
        l.id_autor,
        CONCAT(a.nombres, ' ', a.apellidos) AS autor,
        l.edicion,
        l.id_categoria,
        c.nombre_categoria AS categoria,
        l.cantidad
    FROM libros l
    INNER JOIN autor a ON l.id_autor = a.id_autor
    INNER JOIN categoria c ON l.id_categoria = c.id_categoria
    ORDER BY l.cod_libro ASC;
END //
-- 4.2 Insertar nuevo libro
DELIMITER //
CREATE PROCEDURE sp_insertar_libro(
    IN p_libro VARCHAR(255),
    IN p_id_autor INT,
    IN p_edicion VARCHAR(100),
    IN p_id_categoria INT,
    IN p_cantidad INT
)
BEGIN
    INSERT INTO libros (libro, id_autor, edicion, id_categoria, cantidad)
    VALUES (p_libro, p_id_autor, p_edicion, p_id_categoria, p_cantidad);
END //
-- 4.3 Actualizar libro existente
DELIMITER //
CREATE PROCEDURE sp_actualizar_libro(
    IN p_cod_libro INT,
    IN p_libro VARCHAR(255),
    IN p_id_autor INT,
    IN p_edicion VARCHAR(100),
    IN p_id_categoria INT,
    IN p_cantidad INT
)
BEGIN
    UPDATE libros 
    SET libro = p_libro,
        id_autor = p_id_autor,
        edicion = p_edicion,
        id_categoria = p_id_categoria,
        cantidad = p_cantidad
    WHERE cod_libro = p_cod_libro;
END //
-- 4.4 Eliminar libro por código
DELIMITER //
CREATE PROCEDURE sp_eliminar_libro(IN p_cod_libro INT)
BEGIN
    DELETE FROM libros WHERE cod_libro = p_cod_libro;
END //
-- 4.5 Buscar libros por título, autor o categoría
DROP PROCEDURE IF EXISTS sp_buscar_libros //
CREATE PROCEDURE sp_buscar_libros(IN p_criterio VARCHAR(100))
BEGIN
    SELECT 
        l.cod_libro,
        l.libro,
        l.id_autor,
        CONCAT(a.nombres, ' ', a.apellidos) AS autor,
        l.edicion,
        l.id_categoria,
        c.nombre_categoria AS categoria,
        l.cantidad
    FROM libros l
    INNER JOIN autor a ON l.id_autor = a.id_autor
    INNER JOIN categoria c ON l.id_categoria = c.id_categoria
    WHERE l.libro LIKE CONCAT('%', p_criterio, '%')
       OR CONCAT(a.nombres, ' ', a.apellidos) LIKE CONCAT('%', p_criterio, '%')
       OR c.nombre_categoria LIKE CONCAT('%', p_criterio, '%')
    ORDER BY l.cod_libro ASC;
END //
-- 4.6 Obtener siguiente ID disponible para formulario de libros
DELIMITER //
CREATE PROCEDURE sp_obtener_siguiente_id_libro()
BEGIN
    SELECT COALESCE(MAX(cod_libro), 0) + 1 AS siguiente_id FROM libros;
END //
-- =============================================================================
-- 5. PROCEDIMIENTOS DEL MÓDULO ESTUDIANTES
-- =============================================================================
-- 5.1 Listar todos los estudiantes
DELIMITER //
CREATE PROCEDURE sp_listar_estudiantes()
BEGIN
    SELECT codigo, nombres, apellidos, telefono, tipo_usuario, seccion, anio 
    FROM estudiantes 
    ORDER BY codigo ASC;
END //
-- 5.2 Insertar nuevo estudiante
DELIMITER //
CREATE PROCEDURE sp_insertar_estudiante(
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_telefono VARCHAR(30),
    IN p_tipo_usuario VARCHAR(50),
    IN p_seccion VARCHAR(50),
    IN p_anio VARCHAR(20)
)
BEGIN
    INSERT INTO estudiantes (nombres, apellidos, telefono, tipo_usuario, seccion, anio)
    VALUES (p_nombres, p_apellidos, p_telefono, p_tipo_usuario, p_seccion, p_anio);
END //
-- 5.3 Actualizar datos de estudiante
DELIMITER //
CREATE PROCEDURE sp_actualizar_estudiante(
    IN p_codigo INT,
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_telefono VARCHAR(30),
    IN p_tipo_usuario VARCHAR(50),
    IN p_seccion VARCHAR(50),
    IN p_anio VARCHAR(20)
)
BEGIN
    UPDATE estudiantes 
    SET nombres = p_nombres,
        apellidos = p_apellidos,
        telefono = p_telefono,
        tipo_usuario = p_tipo_usuario,
        seccion = p_seccion,
        anio = p_anio
    WHERE codigo = p_codigo;
END //
-- 5.4 Eliminar estudiante por código
DELIMITER //
CREATE PROCEDURE sp_eliminar_estudiante(IN p_codigo INT)
BEGIN
    DELETE FROM estudiantes WHERE codigo = p_codigo;
END //
-- 5.5 Buscar estudiante por código, nombres o apellidos
DROP PROCEDURE IF EXISTS sp_buscar_estudiantes //
CREATE PROCEDURE sp_buscar_estudiantes(IN p_criterio VARCHAR(100))
BEGIN
    SELECT codigo, nombres, apellidos, telefono, tipo_usuario, seccion, anio 
    FROM estudiantes
    WHERE CAST(codigo AS CHAR) LIKE CONCAT('%', p_criterio, '%')
       OR nombres LIKE CONCAT('%', p_criterio, '%')
       OR apellidos LIKE CONCAT('%', p_criterio, '%')
    ORDER BY codigo ASC;
END //
-- 5.6 Obtener siguiente código disponible para formulario de estudiantes
DELIMITER //
CREATE PROCEDURE sp_obtener_siguiente_id_estudiante()
BEGIN
    SELECT COALESCE(MAX(codigo), 0) + 1 AS siguiente_id FROM estudiantes;
END //
-- =============================================================================
-- 6. PROCEDIMIENTOS DEL MÓDULO USUARIOS (SEGURIDAD / LOGIN)
-- =============================================================================
-- 6.1 Validar credenciales de usuario para inicio de sesión
DELIMITER //
CREATE PROCEDURE sp_validar_usuario(
    IN p_correo VARCHAR(100),
    IN p_contraseña VARCHAR(255)
)
BEGIN
    SELECT id_usuario, nombres, apellidos, correo, rol 
    FROM usuario
    WHERE correo = p_correo AND contraseña = p_contraseña;
END //
DELIMITER ;



SHOW triggers;

-- -----------------------------------------------------------------------------
-- 1. CREACIÓN DE ROLES
-- -----------------------------------------------------------------------------
DROP ROLE IF EXISTS 'rol_administrador', 'rol_bibliotecario';
CREATE ROLE 'rol_administrador';
CREATE ROLE 'rol_bibliotecario';
-- -----------------------------------------------------------------------------
-- 2. ASIGNACIÓN DE PRIVILEGIOS A ROLES
-- -----------------------------------------------------------------------------
-- ROL ADMINISTRADOR: Control total sobre la base de datos y sus procedimientos
GRANT ALL PRIVILEGES ON biblionet1.* TO 'rol_administrador';
-- ROL BIBLIOTECARIO: 
-- Acceso operativo (SELECT, INSERT, UPDATE) sin permiso de DELETE en tablas operativas.
GRANT SELECT, INSERT, UPDATE ON biblionet1.libros TO 'rol_bibliotecario';
GRANT SELECT, INSERT, UPDATE ON biblionet1.estudiantes TO 'rol_bibliotecario';
GRANT SELECT, INSERT, UPDATE ON biblionet1.prestamos TO 'rol_bibliotecario';
GRANT SELECT, INSERT, UPDATE ON biblionet1.detalle_prestamos TO 'rol_bibliotecario';
GRANT SELECT, INSERT, UPDATE ON biblionet1.devoluciones TO 'rol_bibliotecario';
GRANT SELECT, INSERT, UPDATE ON biblionet1.autor TO 'rol_bibliotecario';
GRANT SELECT, INSERT, UPDATE ON biblionet1.categoria TO 'rol_bibliotecario';
-- Permiso de ejecución en procedimientos almacenados para las operaciones del sistema
GRANT EXECUTE ON biblionet1.* TO 'rol_bibliotecario';
-- RESTRICCIÓN EXPLÍCITA: No se concede ningún permiso sobre 'usuario' ni 'bitacora'
-- (Al no incluirse en los GRANT, MySQL deniega automáticamente el acceso).
-- -----------------------------------------------------------------------------
-- 3. CREACIÓN DE USUARIOS LOCALES
-- -----------------------------------------------------------------------------
DROP USER IF EXISTS 'administrador'@'localhost';
DROP USER IF EXISTS 'bibliotecario'@'localhost';
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'AdminBiblio2026!';
CREATE USER 'bibliotecario'@'localhost' IDENTIFIED BY 'BiblioUser2026!';
-- -----------------------------------------------------------------------------
-- 4. ASIGNACIÓN Y ACTIVACIÓN DE ROLES POR DEFECTO
-- -----------------------------------------------------------------------------
GRANT 'rol_administrador' TO 'administrador'@'localhost';
GRANT 'rol_bibliotecario' TO 'bibliotecario'@'localhost';
SET DEFAULT ROLE 'rol_administrador' TO 'administrador'@'localhost';
SET DEFAULT ROLE 'rol_bibliotecario' TO 'bibliotecario'@'localhost';
FLUSH PRIVILEGES;


CREATE TABLE IF NOT EXISTS bitacora(
    id_bitacora INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tabla VARCHAR(100) NOT NULL,
    accion VARCHAR(50) NOT NULL,
    usuario VARCHAR(150) NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_registro_afectado VARCHAR(50) NULL,
    detalles TEXT NULL,
    
    -- Índices para optimizar consultas y reportes de auditoría
    INDEX idx_bitacora_fecha (fecha_hora),
    INDEX idx_bitacora_tabla (nombre_tabla),
    INDEX idx_bitacora_usuario (usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
USE biblionet1;

-- =============================================================================
-- RECREACIÓN GLOBAL DE TRIGGERS: ROL (IFNULL(@app_rol, 'SISTEMA')) Y USUARIO (IFNULL(@app_correo, CURRENT_USER()))
-- BASE DE DATOS: biblionet1
-- =============================================================================

USE biblionet1;

-- -----------------------------------------------------------------------------
-- 1. TABLA: usuario (PK: id_usuario)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_usuario_after_insert;
CREATE TRIGGER trg_usuario_after_insert
AFTER INSERT ON usuario
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('usuario', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_usuario);

DROP TRIGGER IF EXISTS trg_usuario_after_update;
CREATE TRIGGER trg_usuario_after_update
AFTER UPDATE ON usuario
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('usuario', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_usuario);

DROP TRIGGER IF EXISTS trg_usuario_after_delete;
CREATE TRIGGER trg_usuario_after_delete
AFTER DELETE ON usuario
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('usuario', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.id_usuario);

-- -----------------------------------------------------------------------------
-- 2. TABLA: estudiantes (PK: codigo)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_estudiantes_after_insert;
CREATE TRIGGER trg_estudiantes_after_insert
AFTER INSERT ON estudiantes
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('estudiantes', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.codigo);

DROP TRIGGER IF EXISTS trg_estudiantes_after_update;
CREATE TRIGGER trg_estudiantes_after_update
AFTER UPDATE ON estudiantes
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('estudiantes', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.codigo);

DROP TRIGGER IF EXISTS trg_estudiantes_after_delete;
CREATE TRIGGER trg_estudiantes_after_delete
AFTER DELETE ON estudiantes
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('estudiantes', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.codigo);

-- -----------------------------------------------------------------------------
-- 3. TABLA: libros (PK: cod_libro)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_libros_after_insert;
CREATE TRIGGER trg_libros_after_insert
AFTER INSERT ON libros
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('libros', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.cod_libro);

DROP TRIGGER IF EXISTS trg_libros_after_update;
CREATE TRIGGER trg_libros_after_update
AFTER UPDATE ON libros
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('libros', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.cod_libro);

DROP TRIGGER IF EXISTS trg_libros_after_delete;
CREATE TRIGGER trg_libros_after_delete
AFTER DELETE ON libros
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('libros', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.cod_libro);

-- -----------------------------------------------------------------------------
-- 4. TABLA: prestamos (PK: id_prestamo)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_prestamos_after_insert;
CREATE TRIGGER trg_prestamos_after_insert
AFTER INSERT ON prestamos
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('prestamos', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_prestamo);

DROP TRIGGER IF EXISTS trg_prestamos_after_update;
CREATE TRIGGER trg_prestamos_after_update
AFTER UPDATE ON prestamos
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('prestamos', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_prestamo);

DROP TRIGGER IF EXISTS trg_prestamos_after_delete;
CREATE TRIGGER trg_prestamos_after_delete
AFTER DELETE ON prestamos
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('prestamos', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.id_prestamo);

-- -----------------------------------------------------------------------------
-- 5. TABLA: detalle_prestamos (PK: id_detalle)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_detalle_prestamos_after_insert;
CREATE TRIGGER trg_detalle_prestamos_after_insert
AFTER INSERT ON detalle_prestamos
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('detalle_prestamos', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_detalle);

DROP TRIGGER IF EXISTS trg_detalle_prestamos_after_update;
CREATE TRIGGER trg_detalle_prestamos_after_update
AFTER UPDATE ON detalle_prestamos
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('detalle_prestamos', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_detalle);

DROP TRIGGER IF EXISTS trg_detalle_prestamos_after_delete;
CREATE TRIGGER trg_detalle_prestamos_after_delete
AFTER DELETE ON detalle_prestamos
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('detalle_prestamos', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.id_detalle);

-- -----------------------------------------------------------------------------
-- 6. TABLA: devoluciones (PK: id_devolucion)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_devoluciones_after_insert;
CREATE TRIGGER trg_devoluciones_after_insert
AFTER INSERT ON devoluciones
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('devoluciones', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_devolucion);

DROP TRIGGER IF EXISTS trg_devoluciones_after_update;
CREATE TRIGGER trg_devoluciones_after_update
AFTER UPDATE ON devoluciones
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('devoluciones', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_devolucion);

DROP TRIGGER IF EXISTS trg_devoluciones_after_delete;
CREATE TRIGGER trg_devoluciones_after_delete
AFTER DELETE ON devoluciones
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('devoluciones', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.id_devolucion);

-- -----------------------------------------------------------------------------
-- 7. TABLA: autor (PK: id_autor)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_autor_after_insert;
CREATE TRIGGER trg_autor_after_insert
AFTER INSERT ON autor
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('autor', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_autor);

DROP TRIGGER IF EXISTS trg_autor_after_update;
CREATE TRIGGER trg_autor_after_update
AFTER UPDATE ON autor
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('autor', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_autor);

DROP TRIGGER IF EXISTS trg_autor_after_delete;
CREATE TRIGGER trg_autor_after_delete
AFTER DELETE ON autor
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('autor', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.id_autor);

-- -----------------------------------------------------------------------------
-- 8. TABLA: categoria (PK: id_categoria)
-- -----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_categoria_after_insert;
CREATE TRIGGER trg_categoria_after_insert
AFTER INSERT ON categoria
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('categoria', 'INSERT', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_categoria);

DROP TRIGGER IF EXISTS trg_categoria_after_update;
CREATE TRIGGER trg_categoria_after_update
AFTER UPDATE ON categoria
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('categoria', 'UPDATE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), NEW.id_categoria);

DROP TRIGGER IF EXISTS trg_categoria_after_delete;
CREATE TRIGGER trg_categoria_after_delete
AFTER DELETE ON categoria
FOR EACH ROW
INSERT INTO bitacora (nombre_tabla, accion, rol, usuario, fecha_hora, id_registro_afectado)
VALUES ('categoria', 'DELETE', IFNULL(@app_rol, 'SISTEMA'), IFNULL(@app_correo, CURRENT_USER()), NOW(), OLD.id_categoria);



USE biblionet1;


SELECT * FROM bitacora;

USE biblionet1;
SELECT * FROM libros;

DROP PROCEDURE IF EXISTS sp_insertar_prestamo;

DELIMITER //

CREATE PROCEDURE sp_insertar_prestamo(
    IN p_id_estudiante INT,
    IN p_fecha_prestamo DATE,
    IN p_fecha_devolucion DATE,
    OUT p_id_prestamo INT
)
BEGIN
    DECLARE v_prestamos_activos INT DEFAULT 0;

    -- Validar si el estudiante tiene préstamos con libros pendientes de devolución
    SELECT COUNT(DISTINCT p.id_prestamo) INTO v_prestamos_activos
    FROM prestamos p
    INNER JOIN detalle_prestamos dp ON p.id_prestamo = dp.id_prestamo
    LEFT JOIN devoluciones d ON (d.id_prestamo = p.id_prestamo AND d.cod_libro = dp.cod_libro)
    WHERE p.id_estudiante = p_id_estudiante AND d.id_devolucion IS NULL;

    -- Si tiene al menos un préstamo activo sin devolver, bloquear la transacción
    IF v_prestamos_activos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bloqueo de negocio: El estudiante ya tiene un préstamo vigente y debe devolverlo primero.';
    END IF;

    -- Si no tiene préstamos activos, proceder con el registro
    INSERT INTO prestamos (id_estudiante, fecha_prestamo, fecha_devolucion)
    VALUES (p_id_estudiante, p_fecha_prestamo, p_fecha_devolucion);
    
    SET p_id_prestamo = LAST_INSERT_ID();
END //

DELIMITER ;
