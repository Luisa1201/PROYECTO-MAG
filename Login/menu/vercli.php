<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

$query = "SELECT * FROM clientes";
$result = pg_query($conn, $query);

if (!$result) {
    die("Error al obtener datos de la base de datos");
}

$clientes = array();

while ($row = pg_fetch_assoc($result)) {
    $clientes[] = $row;
}

echo json_encode($clientes);

pg_close($conn);
?>
