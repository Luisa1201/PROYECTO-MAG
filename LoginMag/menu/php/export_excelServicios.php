<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

// Conectar a la base de datos
$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Consulta SQL para obtener todos los datos de servicios
$query = "SELECT * FROM servicios";
$result = pg_query($conn, $query);

if (!$result) {
    die("Error al ejecutar la consulta.");
}

// Nombre del archivo CSV
$filename = "servicios_" . date('Ymd') . ".csv";

// Enviar cabeceras para forzar la descarga
header('Content-Type: text/csv');
header('Content-Disposition: attachment;filename=' . $filename);

// Abrir el archivo en modo escritura
$output = fopen('php://output', 'w');

// Escribir la fila de encabezados
fputcsv($output, array('ID', 'Nombre', 'Descripción'), ';');

// Escribir los datos de los servicios
while ($row = pg_fetch_assoc($result)) {
    fputcsv($output, $row, ';');
}

// Cerrar la conexión y el archivo
fclose($output);
pg_close($conn);
exit();
?>
