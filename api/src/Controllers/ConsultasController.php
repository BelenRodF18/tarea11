<?php
namespace App\Controllers;

use App\Models\ConsultasModel;

class ConsultasController {
    private $modelo;

    public function __construct($db) {
        $this->modelo = new ConsultasModel($db);
    }

    private function responder($data) {
        echo json_encode(['status' => 'ok', 'data' => $data], JSON_UNESCAPED_UNICODE);
    }

    // Las 4 tablas con sus datos.
    public function tablas() {
        $this->responder($this->modelo->tablas());
    }

    // Las 15 consultas de la Parte 3 con su resultado.
    public function consultas() {
        $this->responder($this->modelo->consultas());
    }
}
