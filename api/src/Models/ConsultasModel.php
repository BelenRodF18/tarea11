<?php
namespace App\Models;

class ConsultasModel {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    // Las 4 tablas del modelo, con todos sus datos.
    public function tablas() {
        $salida = [];
        foreach (['Equipos', 'Jugadores', 'Torneos', 'Inscripciones'] as $tabla) {
            $stmt = $this->db->query("SELECT * FROM $tabla");
            $salida[] = [
                'nombre' => $tabla,
                'filas'  => $stmt->fetchAll(\PDO::FETCH_ASSOC)
            ];
        }
        return $salida;
    }

    // Las 15 consultas 
    private function listado() {
        return [
            [1, 'DISTINCT', 'Paises diferentes que tienen equipos registrados.',
             "SELECT DISTINCT Pais\nFROM Equipos;"],

            [2, 'LIKE', 'Nickname y correo de los jugadores con email de Gmail.',
             "SELECT Nickname, Email\nFROM Jugadores\nWHERE Email LIKE '%@gmail.com';"],

            [3, 'BETWEEN', 'Jugadores nacidos entre el 01/01/2000 y el 31/12/2005.',
             "SELECT *\nFROM Jugadores\nWHERE Fecha_nacimiento BETWEEN '2000-01-01' AND '2005-12-31';"],

            [4, 'IN', 'Torneos de "League of Legends" o "CS2".',
             "SELECT *\nFROM Torneos\nWHERE Videojuego IN ('League of Legends', 'CS2');"],

            [5, 'NOT IN', 'Nombre y videojuego de los torneos que no son de "Dota 2".',
             "SELECT Nombre, Videojuego\nFROM Torneos\nWHERE Videojuego NOT IN ('Dota 2');"],

            [6, 'COUNT', 'Cantidad total de inscripciones registradas.',
             "SELECT COUNT(*) AS Total_inscripciones\nFROM Inscripciones;"],

            [7, 'Operador <', 'Jugadores nacidos antes del anio 1999.',
             "SELECT Nickname, Fecha_nacimiento\nFROM Jugadores\nWHERE Fecha_nacimiento < '1999-01-01';"],

            [8, 'AND', 'Inscripciones del torneo 1 que ademas esten "Confirmado".',
             "SELECT ID_inscripcion, Fecha_inscripcion\nFROM Inscripciones\nWHERE Codigo_torneo = 1\n  AND Estado = 'Confirmado';"],

            [9, 'AND + IN', 'Inscripciones "Pendiente" o "Cancelado" del torneo 2.',
             "SELECT *\nFROM Inscripciones\nWHERE Codigo_torneo = 2\n  AND Estado IN ('Pendiente', 'Cancelado');"],

            [10, 'ORDER BY', 'Equipos por pais (A-Z) y, ante empate, por nombre (Z-A).',
             "SELECT *\nFROM Equipos\nORDER BY Pais ASC, Nombre DESC;"],

            [11, 'JOIN 1:N', 'Nickname de cada jugador y el nombre de su equipo.',
             "SELECT j.Nickname,\n       e.Nombre AS Equipo\nFROM Jugadores j\nINNER JOIN Equipos e\n        ON j.Codigo_equipo = e.Codigo_equipo;"],

            [12, 'JOIN tabla intermedia', 'Nombre del torneo y estado de cada inscripcion.',
             "SELECT t.Nombre AS Torneo,\n       i.Estado\nFROM Torneos t\nINNER JOIN Inscripciones i\n        ON t.Codigo_torneo = i.Codigo_torneo;"],

            [13, 'JOIN de 4 tablas', 'El reporte completo: jugador, equipo, torneo y estado.',
             "SELECT j.Nickname AS Jugador,\n       e.Nombre   AS Equipo,\n       t.Nombre   AS Torneo,\n       i.Estado   AS Estado_inscripcion\nFROM Inscripciones i\nINNER JOIN Jugadores j ON i.ID_jugador    = j.ID_jugador\nINNER JOIN Equipos   e ON j.Codigo_equipo = e.Codigo_equipo\nINNER JOIN Torneos   t ON i.Codigo_torneo = t.Codigo_torneo\nORDER BY t.Nombre, j.Nickname;"],

            [14, 'LEFT JOIN', 'Todos los torneos y el ID de sus inscripciones. Los torneos vacios quedan en NULL.',
             "SELECT t.Nombre AS Torneo,\n       i.ID_inscripcion\nFROM Torneos t\nLEFT JOIN Inscripciones i\n       ON t.Codigo_torneo = i.Codigo_torneo\nORDER BY t.Codigo_torneo;"],

            [15, 'RIGHT JOIN', 'El mismo resultado que la 14, invirtiendo el orden de las tablas.',
             "SELECT t.Nombre AS Torneo,\n       i.ID_inscripcion\nFROM Inscripciones i\nRIGHT JOIN Torneos t\n        ON t.Codigo_torneo = i.Codigo_torneo\nORDER BY t.Codigo_torneo;"],
        ];
    }

    // Ejecuta cada consulta y devuelve el SQL junto con su resultado.
    public function consultas() {
        $salida = [];
        foreach ($this->listado() as $c) {
            list($numero, $operador, $enunciado, $sql) = $c;
            $stmt = $this->db->query($sql);
            $salida[] = [
                'numero'    => $numero,
                'operador'  => $operador,
                'enunciado' => $enunciado,
                'sql'       => $sql,
                'filas'     => $stmt->fetchAll(\PDO::FETCH_ASSOC)
            ];
        }
        return $salida;
    }
}
