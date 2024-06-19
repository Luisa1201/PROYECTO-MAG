<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener los datos del cliente a actualizar
$id = $_POST['id'];
$nombre = $_POST['nombre'];
$usuario = $_POST['usuario'];
$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];


// Consulta SQL para actualizar los datos del cliente
$query = "UPDATE public.usuarios
          SET nombre='$nombre', correo='$correo', usuario='$usuario', contrasena='$contrasena'
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
