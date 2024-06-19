<?php
$host='localhost';
$bd='dbmag';
$user='postgres';
$pass = 'Postgresql';
$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener datos del formulario
$nombre = $_POST['nombreservi'];
$descripcion = $_POST['descripcionservi'];

// Consulta preparada para insertar datos
$query = "INSERT INTO servicios (nombre, descripcion) 
          VALUES ($1, $2)";
$params = array($nombre, $descripcion);

$prepared = pg_prepare($conn, "insert_servic", $query);

if ($prepared) {
    $result = pg_execute($conn, "insert_servic", $params);

    if ($result) {
        $response = array("success" => true, "message" => "Registro exitoso.");
    } else {
        $response = array("success" => false, "message" => "Error al registrar servicio.");
    }
} else {
    $response = array("success" => false, "message" => "Error al preparar la consulta.");
}

// Enviar respuesta como JSON
echo json_encode($response);

// Cerrar conexión
pg_close($conn);
?>
