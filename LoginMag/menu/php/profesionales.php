<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Consulta SQL para obtener todos los datos de profesionales
$query = "SELECT * FROM public.profesionales";
$result = pg_query($conn, $query);

if ($result) {
    $profesionales = array(); // Array para almacenar los datos de los profesionales

    while ($row = pg_fetch_assoc($result)) {
        $profesionales[] = $row; // Agregar cada fila de profesional al array
    }

    // Devolver los datos en formato JSON
    echo json_encode($profesionales);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
