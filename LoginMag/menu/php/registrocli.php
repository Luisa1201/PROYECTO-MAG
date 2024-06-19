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
$nombre = $_POST['nombrecli'];
$apellidos = $_POST['apellidoscli'];
$cedula = $_POST['cedulacli'];
$nit = $_POST['nitcli'];
$email = $_POST['emailcli'];
$telefono = $_POST['telefonocli'];
$direccion = $_POST['direccioncli'];
$estado = $_POST['estadocli'];

// Consulta preparada para insertar datos
$query = "INSERT INTO clientes (nombre, apellidos, cedula, nit, email, telefono, direccion, estado) 
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8)";
$params = array($nombre, $apellidos, $cedula, $nit, $email, $telefono, $direccion, $estado);

$prepared = pg_prepare($conn, "insert_client", $query);

if ($prepared) {
    $result = pg_execute($conn, "insert_client", $params);

    if ($result) {
        $response = array("success" => true, "message" => "Registro exitoso.");
    } else {
        $response = array("success" => false, "message" => "Error al registrar cliente.");
    }
} else {
    $response = array("success" => false, "message" => "Error al preparar la consulta.");
}

// Enviar respuesta como JSON
echo json_encode($response);

// Cerrar conexión
pg_close($conn);
?>
