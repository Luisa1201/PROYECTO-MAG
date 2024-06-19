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
$servicioId = $_POST['id'];

// Consulta SQL para obtener los datos del profesional por su ID
$query = "SELECT id, nombre, descripcion
          FROM public.servicios
          WHERE id = $servicioId";

$result = pg_query($conn, $query);

if ($result) {
    $servicio = pg_fetch_assoc($result); // Obtener los datos del profesional

    // Devolver los datos en formato JSON
    echo json_encode($servicio);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
