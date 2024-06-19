<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener el ID del profesional
$profesionalId = $_POST['id'];

// Consulta SQL para obtener los datos del profesional por su ID
$query = "SELECT id, nombre, apellidos, especializacion, email, telefono, direccion
          FROM public.profesionales
          WHERE id = $profesionalId";

$result = pg_query($conn, $query);

if ($result) {
    $profesional = pg_fetch_assoc($result); // Obtener los datos del profesional

    // Devolver los datos en formato JSON
    echo json_encode($profesional);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
