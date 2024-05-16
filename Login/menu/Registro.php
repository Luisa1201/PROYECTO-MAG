<?php
$host = 'localhost';
$bd = 'dbmag';
$user = 'postgres';
$pass = 'Postgresql';

$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Obtener datos del formulario
$nombre = $_POST['nombre'];
$correo = $_POST['correo'];
$usuario = $_POST['usuario'];
$contrasena = $_POST['contrasena']; // Aquí debes considerar el hash de la contraseña si lo necesitas

// Validar longitud de usuario y contraseña
if (strlen($usuario) > 20 || strlen($contrasena) > 20) {
    die("Error: El nombre de usuario y la contraseña no pueden superar los 20 caracteres.");
}

// Verificar restricciones de longitud para nombre y correo
if (strlen($nombre) < 3 || strlen($correo) < 5) {
    die("Error: El nombre debe tener al menos 3 caracteres y el correo debe tener al menos 5 caracteres.");
}

// Iniciar una transacción
pg_query($conn, "BEGIN");

// Consulta preparada para insertar datos
$query = "INSERT INTO usuarios (nombre, correo, usuario, contrasena) VALUES ($1, $2, $3, $4)";
$params = array($nombre, $correo, $usuario, $contrasena);

$prepared = pg_prepare($conn, "insert_user", $query);

if ($prepared) {
    $result = pg_execute($conn, "insert_user", $params);

    if ($result) {
        // Confirmar la transacción si la inserción fue exitosa
        pg_query($conn, "COMMIT");
        echo json_encode(array("success" => true)); // Envía una respuesta JSON indicando éxito
    } else {
        // Si la inserción falla, revertir la transacción
        pg_query($conn, "ROLLBACK");
        echo json_encode(array("success" => false)); // Envía una respuesta JSON indicando fallo
    }
} else {
    // Si la preparación de la consulta falla, revertir la transacción
    pg_query($conn, "ROLLBACK");
    echo json_encode(array("success" => false)); // Envía una respuesta JSON indicando fallo
}

// Cerrar conexión
pg_close($conn);
?>
