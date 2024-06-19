<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Consulta SQL para obtener todos los datos de clientes
$query = "SELECT * FROM clientes";
$result = pg_query($conn, $query);

if ($result) {
    $clientes = array(); // Array para almacenar los datos de los clientes

    while ($row = pg_fetch_assoc($result)) {
        $clientes[] = $row; // Agregar cada fila de cliente al array
    }

    // Devolver los datos en formato JSON
    echo json_encode($clientes);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
