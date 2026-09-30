-- =====================================================================
-- Tarea 11 - Sistema de Inscripciones a Torneos de eSports
-- Caso de estudio: "Liga de eSports"
-- Materia: Programacion FullStack - 3ME Informatica
-- Motor: MySQL 8.0 / InnoDB / utf8mb4
-- =====================================================================
-- Contenido del archivo:
--   PARTE 2 - A) Creacion del esquema (DDL)
--   PARTE 2 - B) Insercion de datos (INSERT)
--   PARTE 2 - C) Modificacion de datos (UPDATE)
--   PARTE 2 - D) Eliminacion de datos (DELETE)
--   PARTE 3 - Seccion A) Consultas simples (ejercicios 1 al 10)
--   PARTE 3 - Seccion B) Consultas relacionales JOIN (ejercicios 11 al 15)
-- =====================================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Base de datos
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS `liga_esports`;
CREATE DATABASE `liga_esports`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `liga_esports`;


-- =====================================================================
-- PARTE 2 - A) CREACION DEL ESQUEMA (DDL)
-- El orden de creacion respeta las claves foraneas:
--   1) Equipos y Torneos (tablas independientes / fuertes)
--   2) Jugadores (depende de Equipos)
--   3) Inscripciones (depende de Jugadores y de Torneos)
-- =====================================================================

-- Tabla: Equipos -------------------------------------------------------
CREATE TABLE `Equipos` (
  `Codigo_equipo` INT NOT NULL AUTO_INCREMENT,
  `Nombre`        VARCHAR(60) NOT NULL,
  `Pais`          VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Codigo_equipo`),
  UNIQUE KEY `UQ_equipo_nombre` (`Nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Torneos -------------------------------------------------------
CREATE TABLE `Torneos` (
  `Codigo_torneo` INT NOT NULL AUTO_INCREMENT,
  `Nombre`        VARCHAR(80) NOT NULL,
  `Videojuego`    VARCHAR(50) NOT NULL,
  `Premio`        DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`Codigo_torneo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Jugadores -----------------------------------------------------
-- Relacion 1:N con Equipos -> la FK Codigo_equipo viaja al lado "muchos".
CREATE TABLE `Jugadores` (
  `ID_jugador`       INT NOT NULL AUTO_INCREMENT,
  `Nickname`         VARCHAR(40) NOT NULL,
  `Email`            VARCHAR(100) NOT NULL,
  `Fecha_nacimiento` DATE NOT NULL,
  `Codigo_equipo`    INT NOT NULL,
  PRIMARY KEY (`ID_jugador`),
  UNIQUE KEY `UQ_jugador_nickname` (`Nickname`),
  KEY `FK_jugador_equipo` (`Codigo_equipo`),
  CONSTRAINT `FK_jugador_equipo`
    FOREIGN KEY (`Codigo_equipo`) REFERENCES `Equipos` (`Codigo_equipo`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Inscripciones -------------------------------------------------
-- Tabla intermedia que resuelve la relacion N:N entre Jugadores y Torneos.
-- Tiene PK propia (ID_inscripcion) y atributos propios (fecha y estado).
CREATE TABLE `Inscripciones` (
  `ID_inscripcion`     INT NOT NULL AUTO_INCREMENT,
  `Fecha_inscripcion`  DATE NOT NULL,
  `Estado`             ENUM('Confirmado','Pendiente','Cancelado')
                       NOT NULL DEFAULT 'Pendiente',
  `ID_jugador`         INT NOT NULL,
  `Codigo_torneo`      INT NOT NULL,
  PRIMARY KEY (`ID_inscripcion`),
  KEY `FK_inscripcion_jugador` (`ID_jugador`),
  KEY `FK_inscripcion_torneo` (`Codigo_torneo`),
  CONSTRAINT `FK_inscripcion_jugador`
    FOREIGN KEY (`ID_jugador`) REFERENCES `Jugadores` (`ID_jugador`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_inscripcion_torneo`
    FOREIGN KEY (`Codigo_torneo`) REFERENCES `Torneos` (`Codigo_torneo`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================================
-- PARTE 2 - B) INSERCION DE DATOS (DML)
-- =====================================================================

-- 2) 4 Equipos (de distintos paises) -----------------------------------
INSERT INTO `Equipos` (`Codigo_equipo`, `Nombre`, `Pais`) VALUES
(1, 'Natus Vincere', 'Ucrania'),
(2, 'FURIA Esports', 'Brasil'),
(3, 'paiN Gaming',   'Brasil'),
(4, 'Nova Legion',   'Uruguay');

-- 3) 10 Jugadores (distribuidos entre los distintos equipos) -----------
INSERT INTO `Jugadores`
  (`ID_jugador`, `Nickname`, `Email`, `Fecha_nacimiento`, `Codigo_equipo`) VALUES
(1,  'Maria',   'maria.gonzalez@gmail.com',   '1997-10-02', 1),
(2,  'Pepe',    'pepe.rodriguez@gmail.com',   '2003-04-17', 1),
(3,  'Nacho',   'nacho.perez@outlook.com',    '1996-08-30', 1),
(4,  'Rodolfo', 'rodolfo.silva@gmail.com',    '1999-05-11', 2),
(5,  'Momo',    'momo.fernandez@gmail.com',   '2001-01-23', 2),
(6,  'Lucia',   'lucia.martinez@gmail.com',   '1999-09-08', 2),
(7,  'Carlos',  'carlos.gomez@gmail.com',     '1995-03-14', 3),
(8,  'Sofia',   'sofia.lopez@gmail.com',      '2004-07-19', 3),
(9,  'Juli',    'julian.castro@gmail.com',    '1993-12-21', 4),
(10, 'Ana',     'ana.torres@outlook.com',     '2005-11-05', 4);

-- 4) 4 Torneos (2 videojuegos distintos + uno con premio muy alto) -----
INSERT INTO `Torneos` (`Codigo_torneo`, `Nombre`, `Videojuego`, `Premio`) VALUES
(1, 'Copa Sudamericana CS2',  'CS2',               25000.00),
(2, 'Liga Continental LoL',   'League of Legends', 40000.00),
(3, 'The Rioplatense Major',  'Dota 2',           150000.00),  -- premio muy alto
(4, 'Winter Clash CS2',       'CS2',               12000.00);  -- queda sin inscriptos

-- 5) 12 Inscripciones (con distintos estados) --------------------------
INSERT INTO `Inscripciones`
  (`ID_inscripcion`, `Fecha_inscripcion`, `Estado`, `ID_jugador`, `Codigo_torneo`) VALUES
(1,  '2026-01-15', 'Confirmado', 1,  1),
(2,  '2026-01-15', 'Confirmado', 2,  1),
(3,  '2026-01-16', 'Pendiente',  3,  1),
(4,  '2026-01-18', 'Confirmado', 4,  1),
(5,  '2026-02-02', 'Confirmado', 5,  2),
(6,  '2026-02-03', 'Pendiente',  6,  2),
(7,  '2026-02-05', 'Cancelado',  7,  2),
(8,  '2026-02-07', 'Pendiente',  8,  2),
(9,  '2026-03-10', 'Confirmado', 9,  3),   -- Juli (jugador sancionado)
(10, '2026-03-11', 'Pendiente',  10, 3),
(11, '2026-03-12', 'Cancelado',  9,  1),   -- Juli (jugador sancionado)
(12, '2026-01-15', 'Confirmado', 2,  1);   -- carga duplicada por error de sistema


-- =====================================================================
-- PARTE 2 - C) MODIFICACION DE DATOS (UPDATE)
-- =====================================================================

-- 6) Nuevo patrocinador: se aumenta el premio del torneo 2 (Liga Continental LoL)
--    de 40.000 a 65.000 dolares.
UPDATE `Torneos`
SET `Premio` = 65000.00
WHERE `Codigo_torneo` = 2;

-- 7) Dos inscripciones que estaban "Pendiente" pasan a "Confirmado"
--    (inscripcion 3 de Nacho y inscripcion 6 de Lucia).
UPDATE `Inscripciones`
SET `Estado` = 'Confirmado'
WHERE `ID_inscripcion` IN (3, 6);


-- =====================================================================
-- PARTE 2 - D) ELIMINACION DE DATOS (DELETE)
-- =====================================================================

-- 8) Registro duplicado: la inscripcion 12 es una copia exacta de la
--    inscripcion 2 (mismo jugador, mismo torneo, misma fecha).
DELETE FROM `Inscripciones`
WHERE `ID_inscripcion` = 12;

-- 9) Jugador baneado: "Juli" (ID_jugador = 9) fue sancionado por
--    arreglo de partidos. El apodo hace referencia al caso "322" de
--    Dota 2: en 2013 el jugador Alexey "Solo" Berezin apostó 322 dolares
--    a que su propio equipo (RoX.KIS) perdia el partido, y perdio a
--    proposito. Desde entonces "322" es el numero que la escena de eSports
--    usa para identificar un partido arreglado. Se eliminan TODAS sus
--    inscripciones (2 registros: ID 9 y ID 11) usando su ID de jugador.
DELETE FROM `Inscripciones`
WHERE `ID_jugador` = 9;


-- =====================================================================
-- PARTE 3 - REPORTES Y CONSULTAS (DQL)
-- =====================================================================

-- ---------------------------------------------------------------------
-- SECCION A: Consultas simples (filtrado y operadores)
-- ---------------------------------------------------------------------

-- 1) DISTINCT: paises diferentes que tienen equipos registrados.
SELECT DISTINCT `Pais`
FROM `Equipos`;

-- 2) LIKE: nickname y correo de los jugadores con email de Gmail.
SELECT `Nickname`, `Email`
FROM `Jugadores`
WHERE `Email` LIKE '%@gmail.com';

-- 3) BETWEEN: jugadores nacidos entre el 01/01/2000 y el 31/12/2005.
SELECT *
FROM `Jugadores`
WHERE `Fecha_nacimiento` BETWEEN '2000-01-01' AND '2005-12-31';

-- 4) IN: torneos de "League of Legends" o "CS2".
SELECT *
FROM `Torneos`
WHERE `Videojuego` IN ('League of Legends', 'CS2');

-- 5) NOT IN: nombre y videojuego de los torneos que no son de "Dota 2".
SELECT `Nombre`, `Videojuego`
FROM `Torneos`
WHERE `Videojuego` NOT IN ('Dota 2');

-- 6) COUNT: cantidad total de inscripciones registradas en el sistema.
SELECT COUNT(*) AS `Total_inscripciones`
FROM `Inscripciones`;

-- 7) Operador <: jugadores nacidos antes del anio 1999.
SELECT `Nickname`, `Fecha_nacimiento`
FROM `Jugadores`
WHERE `Fecha_nacimiento` < '1999-01-01';

-- 8) AND: inscripciones del torneo 1 que ademas esten "Confirmado".
SELECT `ID_inscripcion`, `Fecha_inscripcion`
FROM `Inscripciones`
WHERE `Codigo_torneo` = 1
  AND `Estado` = 'Confirmado';

-- 9) AND + IN: inscripciones "Pendiente" o "Cancelado" del torneo 2.
SELECT *
FROM `Inscripciones`
WHERE `Codigo_torneo` = 2
  AND `Estado` IN ('Pendiente', 'Cancelado');

-- 10) ORDER BY: equipos ordenados por pais (A-Z) y, ante empate,
--     por nombre de equipo descendente (Z-A).
SELECT *
FROM `Equipos`
ORDER BY `Pais` ASC, `Nombre` DESC;


-- ---------------------------------------------------------------------
-- SECCION B: Consultas relacionales (JOIN)
-- ---------------------------------------------------------------------

-- 11) Cruce simple 1:N: nickname de cada jugador + nombre de su equipo.
SELECT j.`Nickname`,
       e.`Nombre` AS `Equipo`
FROM `Jugadores` j
INNER JOIN `Equipos` e
        ON j.`Codigo_equipo` = e.`Codigo_equipo`;

-- 12) Cruce simple con la tabla intermedia:
--     nombre del torneo + estado de cada inscripcion registrada.
SELECT t.`Nombre` AS `Torneo`,
       i.`Estado`
FROM `Torneos` t
INNER JOIN `Inscripciones` i
        ON t.`Codigo_torneo` = i.`Codigo_torneo`;

-- 13) Cruce multiple (4 tablas) - "El reporte completo":
--     jugador, equipo, torneo y estado de la inscripcion.
SELECT j.`Nickname`       AS `Jugador`,
       e.`Nombre`         AS `Equipo`,
       t.`Nombre`         AS `Torneo`,
       i.`Estado`         AS `Estado_inscripcion`
FROM `Inscripciones` i
INNER JOIN `Jugadores` j ON i.`ID_jugador`    = j.`ID_jugador`
INNER JOIN `Equipos`   e ON j.`Codigo_equipo` = e.`Codigo_equipo`
INNER JOIN `Torneos`   t ON i.`Codigo_torneo` = t.`Codigo_torneo`
ORDER BY t.`Nombre`, j.`Nickname`;

-- 14) LEFT JOIN - "Torneos vacios": todos los torneos y el ID de sus
--     inscripciones. Los torneos sin inscriptos aparecen con NULL.
SELECT t.`Nombre` AS `Torneo`,
       i.`ID_inscripcion`
FROM `Torneos` t
LEFT JOIN `Inscripciones` i
       ON t.`Codigo_torneo` = i.`Codigo_torneo`
ORDER BY t.`Codigo_torneo`;

-- 15) RIGHT JOIN - mismo resultado que el ejercicio 14.
--     Se invierte el orden de las tablas en el FROM: la tabla que debe
--     mostrarse completa (Torneos) pasa a la derecha del JOIN.
SELECT t.`Nombre` AS `Torneo`,
       i.`ID_inscripcion`
FROM `Inscripciones` i
RIGHT JOIN `Torneos` t
        ON t.`Codigo_torneo` = i.`Codigo_torneo`
ORDER BY t.`Codigo_torneo`;

-- =====================================================================
-- FIN DEL ARCHIVO
-- =====================================================================
