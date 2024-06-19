<?php
$host = 'localhost';
$db = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

// Conexión a la base de datos
$conn = pg_connect("host=$host dbname=$db user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Consulta para obtener los datos
$queryProfesionales = 'SELECT COUNT(*) as count FROM profesionales';
$queryClientes = 'SELECT COUNT(*) as count FROM clientes';
$queryServicios = 'SELECT COUNT(*) as count FROM servicios';

$resultProfesionales = pg_query($conn, $queryProfesionales);
$resultClientes = pg_query($conn, $queryClientes);
$resultServicios = pg_query($conn, $queryServicios);

if (!$resultProfesionales || !$resultClientes || !$resultServicios) {
    die("Error en la consulta");
}

$profesionales = pg_fetch_assoc($resultProfesionales)['count'];
$clientes = pg_fetch_assoc($resultClientes)['count'];
$servicios = pg_fetch_assoc($resultServicios)['count'];

$data = [
    'profesionales' => $profesionales,
    'clientes' => $clientes,
    'servicios' => $servicios,
    'ventas' => 150 // Supongamos que el valor de ventas es estático para este ejemplo
];

// Devolver los datos en formato JSON
header('Content-Type: application/json');
echo json_encode($data);
?>
