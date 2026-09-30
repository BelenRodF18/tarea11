<?php
namespace App\Controllers;

// Importamos el molde del Modelo
use App\Models\LigaModel;

class EstadoController {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function ver() {
        // 1. Preparamos la respuesta base
        $respuesta = [
            'status' => 'ok',
            'message' => 'La API responde',
            'base_datos' => 'conectada (liga_esports)',
            'tablas' => []
        ];

        // 2. Instanciamos el Modelo pasandole la conexion
        $ligaModel = new LigaModel($this->db);

        // 3. Le pedimos al Modelo la cantidad de filas de cada tabla
        foreach (['Equipos', 'Jugadores', 'Torneos', 'Inscripciones'] as $tabla) {
            $cantidad = $ligaModel->contar($tabla);
            $respuesta['tablas'][$tabla] = ($cantidad !== false)
                ? $cantidad
                : 'falta crear la tabla (phpMyAdmin o init.sql)';
        }

        // 4. Entregamos el JSON
        echo json_encode($respuesta, JSON_UNESCAPED_UNICODE);
    }
}
