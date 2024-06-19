<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Consulta SQL para obtener todos los datos de servicios
$query = "SELECT * FROM public.servicios";
$result = pg_query($conn, $query);

if ($result) {
    $servicios = array(); // Array para almacenar los datos de los servicios

    while ($row = pg_fetch_assoc($result)) {
        $servicios[] = $row; // Agregar cada fila de servicio al array
    }

    // Devolver los datos en formato JSON
    echo json_encode($servicios);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
