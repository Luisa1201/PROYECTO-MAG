<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener el término de búsqueda del formulario
$searchTerm = $_POST['search'];

// Consulta SQL para buscar servicios que coincidan con el término de búsqueda
$query = "SELECT id, nombre, descripcion
          FROM public.servicios
          WHERE nombre LIKE '%$searchTerm%' OR descripcion LIKE '%$searchTerm%'";

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
