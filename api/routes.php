<?php

$router->get('/estado', 'EstadoController@ver');
$router->get('/tablas', 'ConsultasController@tablas');
$router->get('/consultas', 'ConsultasController@consultas');
