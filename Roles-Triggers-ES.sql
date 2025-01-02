Create database Roles;
use Roles;

SHOW GRANTS FOR CURRENT_USER();
-- Super Admin
CREATE USER 'super_admin'@'localhost' IDENTIFIED BY 'S3gur0P@ss_super';
GRANT ALL PRIVILEGES ON *.* TO 'super_admin'@'localhost';

-- usuario Administrador para gestionar usuarios y procesos.
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'S3gur0P@ss_admin';
GRANT CREATE USER, PROCESS ON *.* TO 'admin'@'localhost';

-- usuario CRUD para realizar operaciones completas en tablas.
CREATE USER 'crud_user'@'localhost' IDENTIFIED BY 'S3gur0P@ss_crud';
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'crud_user'@'localhost';

-- usuario CRU para realizar operaciones limitadas en tablas.
CREATE USER 'cru_user'@'localhost' IDENTIFIED BY 'S3gur0P@ss_cru';
GRANT SELECT, INSERT, UPDATE ON *.* TO 'cru_user'@'localhost';


-- usuario Solo Lectura para consultas en las tablas.
CREATE USER 'read_only'@'localhost' IDENTIFIED BY 'S3gur0P@ss_read';
GRANT SELECT ON *.* TO 'read_only'@'localhost';


FLUSH PRIVILEGES;






CREATE TABLE Empleados (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Departamento VARCHAR(100) NOT NULL,
    Salario DECIMAL(10, 2) NOT NULL
);


CREATE TABLE Auditoria (
    AudID INT AUTO_INCREMENT PRIMARY KEY,
    Accion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    EmpID INT,
    Nombre VARCHAR(100),
    Departamento VARCHAR(100),
    Salario DECIMAL(10, 2),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //
CREATE TRIGGER trg_auditoria_empleados_insert
AFTER INSERT ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('INSERT', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_auditoria_empleados_update
AFTER UPDATE ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('UPDATE', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_auditoria_empleados_delete
AFTER DELETE ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('DELETE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END//
DELIMITER ;

SELECT * FROM Auditoria ORDER BY Fecha DESC;

-- Tarea Realizada por el estudiante Edwin Sarango