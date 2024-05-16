<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener el ID del cliente
$clienteId = $_POST['id'];

// Consulta SQL para obtener los datos del cliente por su ID
$query = "SELECT id, nombre, usuario, correo, contrasena
          FROM public.usuarios
          WHERE id = $clienteId";

$result = pg_query($conn, $query);

if ($result) {
    $cliente = pg_fetch_assoc($result); // Obtener los datos del cliente

    // Devolver los datos en formato JSON
    echo json_encode($cliente);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
