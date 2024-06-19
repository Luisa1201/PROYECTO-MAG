<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener los datos del servicio a actualizar
$id = $_POST['id'];
$nombre = $_POST['nombre'];
$descripcion = $_POST['descripcion'];


// Consulta SQL para actualizar los datos del servicio
$query = "UPDATE public.servicios
          SET nombre='$nombre', descripcion='$descripcion'
          WHERE id=$id";

$result = pg_query($conn, $query);

$response = array(); // Inicializar el array de respuesta

if ($result) {
    $response['success'] = true;
} else {
    $response['success'] = false;
}

// Enviar la respuesta como JSON
header('Content-Type: application/json');
echo json_encode($response);

// Cerrar conexión
pg_close($conn);
?>
