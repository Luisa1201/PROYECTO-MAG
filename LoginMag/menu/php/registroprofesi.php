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
$nombre = $_POST['nombreprofe'];
$apellidos = $_POST['apellidosprofe'];
$especializacion = $_POST['especializacionprofe'];
$email = $_POST['emailprofe'];
$telefono = $_POST['telefonoprofe'];
$direccion = $_POST['direccionprofe'];
$estado = $_POST['estadoprofe'];

// Consulta preparada para insertar datos
$query = "INSERT INTO profesionales (nombre, apellidos, especializacion, email, telefono, direccion, estado) 
          VALUES ($1, $2, $3, $4, $5, $6, $7)";
$params = array($nombre, $apellidos, $especializacion, $email, $telefono, $direccion, $estado);

$prepared = pg_prepare($conn, "insert_profesio", $query);

if ($prepared) {
    $result = pg_execute($conn, "insert_profesio", $params);

    if ($result) {
        $response = array("success" => true, "message" => "Registro exitoso.");
    } else {
        $response = array("success" => false, "message" => "Error al registrar profesional.");
    }
} else {
    $response = array("success" => false, "message" => "Error al preparar la consulta.");
}

// Enviar respuesta como JSON
echo json_encode($response);

// Cerrar conexión
pg_close($conn);
?>
