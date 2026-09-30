<?php
namespace App\Models;

class LigaModel {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    // Cuenta las filas de una de las tablas del caso de estudio.
    public function contar($tabla) {
        $permitidas = ['Equipos', 'Jugadores', 'Torneos', 'Inscripciones'];
        if (!in_array($tabla, $permitidas, true)) {
            return false;
        }
        try {
            $stmt = $this->db->query("SELECT COUNT(*) AS total FROM $tabla");
            $fila = $stmt->fetch(\PDO::FETCH_ASSOC);
            return (int) $fila['total'];
        } catch (\Exception $e) {
            // Si la tabla todavia no existe
            return false;
        }
    }
}
