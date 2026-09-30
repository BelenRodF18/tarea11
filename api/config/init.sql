CREATE TABLE Equipos (
    Codigo_equipo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre        VARCHAR(60) NOT NULL UNIQUE,
    Pais          VARCHAR(50) NOT NULL
);

CREATE TABLE Torneos (
    Codigo_torneo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre        VARCHAR(80) NOT NULL,
    Videojuego    VARCHAR(50) NOT NULL,
    Premio        DECIMAL(12,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE Jugadores (
    ID_jugador       INT AUTO_INCREMENT PRIMARY KEY,
    Nickname         VARCHAR(40) NOT NULL UNIQUE,
    Email            VARCHAR(100) NOT NULL,
    Fecha_nacimiento DATE NOT NULL,
    Codigo_equipo    INT NOT NULL,
    FOREIGN KEY (Codigo_equipo) REFERENCES Equipos(Codigo_equipo)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Inscripciones (
    ID_inscripcion    INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_inscripcion DATE NOT NULL,
    Estado            ENUM('Confirmado','Pendiente','Cancelado') NOT NULL DEFAULT 'Pendiente',
    ID_jugador        INT NOT NULL,
    Codigo_torneo     INT NOT NULL,
    FOREIGN KEY (ID_jugador) REFERENCES Jugadores(ID_jugador)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Codigo_torneo) REFERENCES Torneos(Codigo_torneo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Equipos (Codigo_equipo, Nombre, Pais) VALUES
(1, 'Natus Vincere', 'Ucrania'),
(2, 'FURIA Esports', 'Brasil'),
(3, 'paiN Gaming',   'Brasil'),
(4, 'Nova Legion',   'Uruguay');

INSERT INTO Jugadores (ID_jugador, Nickname, Email, Fecha_nacimiento, Codigo_equipo) VALUES
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

INSERT INTO Torneos (Codigo_torneo, Nombre, Videojuego, Premio) VALUES
(1, 'Copa Sudamericana CS2',  'CS2',               25000.00),
(2, 'Liga Continental LoL',   'League of Legends', 40000.00),
(3, 'The Rioplatense Major',  'Dota 2',           150000.00),
(4, 'Winter Clash CS2',       'CS2',               12000.00);

INSERT INTO Inscripciones (ID_inscripcion, Fecha_inscripcion, Estado, ID_jugador, Codigo_torneo) VALUES
(1,  '2026-01-15', 'Confirmado', 1,  1),
(2,  '2026-01-15', 'Confirmado', 2,  1),
(3,  '2026-01-16', 'Pendiente',  3,  1),
(4,  '2026-01-18', 'Confirmado', 4,  1),
(5,  '2026-02-02', 'Confirmado', 5,  2),
(6,  '2026-02-03', 'Pendiente',  6,  2),
(7,  '2026-02-05', 'Cancelado',  7,  2),
(8,  '2026-02-07', 'Pendiente',  8,  2),
(9,  '2026-03-10', 'Confirmado', 9,  3),
(10, '2026-03-11', 'Pendiente',  10, 3),
(11, '2026-03-12', 'Cancelado',  9,  1),
(12, '2026-01-15', 'Confirmado', 2,  1);

UPDATE Torneos
SET Premio = 65000.00
WHERE Codigo_torneo = 2;

UPDATE Inscripciones
SET Estado = 'Confirmado'
WHERE ID_inscripcion IN (3, 6);

DELETE FROM Inscripciones
WHERE ID_inscripcion = 12;

DELETE FROM Inscripciones
WHERE ID_jugador = 9;
