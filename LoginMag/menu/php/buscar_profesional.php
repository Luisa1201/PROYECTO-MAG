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

// Consulta SQL para buscar clientes que coincidan con el término de búsqueda
$query = "SELECT id, nombre, apellidos, especializacion, email, telefono, direccion, estado
          FROM public.profesionales
          WHERE nombre LIKE '%$searchTerm%' OR apellidos LIKE '%$searchTerm%' OR especializacion LIKE '%$searchTerm%' OR email LIKE '%$searchTerm%' OR telefono LIKE '%$searchTerm%' OR direccion LIKE '%$searchTerm%'";

$result = pg_query($conn, $query);

if ($result) {
    $profesionales = array(); // Array para almacenar los datos de los clientes

    while ($row = pg_fetch_assoc($result)) {
        $profesionales[] = $row; // Agregar cada fila de cliente al array
    }

    // Devolver los datos en formato JSON
    echo json_encode($profesionales);
} else {
    echo "Error al ejecutar la consulta.";
}

// Cerrar conexión
pg_close($conn);
?>
