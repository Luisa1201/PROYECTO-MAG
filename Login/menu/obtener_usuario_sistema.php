<?php

$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Consulta SQL para obtener todos los datos de la tabla de usuarios
$query = "SELECT id, nombre, usuario, correo, contrasena
          FROM public.usuarios";

$result = pg_query($conn, $query);

if ($result) {
    $clientes = array();

    // Obtener todos los datos de los clientes
    while ($row = pg_fetch_assoc($result)) {
        $clientes[] = $row;
    }

    // Devolver los datos en formato JSON
    echo json_encode($clientes);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
