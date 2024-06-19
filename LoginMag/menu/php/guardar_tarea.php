<?php
$host = 'localhost';
$bd = 'dbmag'; // Nombre de tu base de datos
$user = 'postgres'; // Usuario de la base de datos
$pass = 'Postgresql'; // Contraseña de la base de datos

// Conexión a la base de datos PostgreSQL
$conn = pg_connect("host=$host dbname=$bd user=$user password=$pass");

if (!$conn) {
    die("Error de conexión a la base de datos");
}

// Verificar si se está enviando una solicitud POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Agregar nueva tarea
    if (isset($_POST['nombreTarea']) && isset($_POST['fechaTarea'])) {
        // Procesar la inserción de nueva tarea
        $nombreTarea = $_POST['nombreTarea'];
        $fechaTarea = $_POST['fechaTarea'];

        // Preparar la consulta SQL para insertar la tarea
        $queryInsert = "INSERT INTO tareas (nombre_tarea, fecha_tarea) VALUES ($1, $2)";
        $resultInsert = pg_query_params($conn, $queryInsert, array($nombreTarea, $fechaTarea));

        if ($resultInsert) {
            // Si la inserción fue exitosa, devolver respuesta JSON de éxito
            echo json_encode(array("success" => true, "message" => "La tarea '$nombreTarea' se ha agregado correctamente."));
        } else {
            // Si hubo un error en la inserción, devolver respuesta JSON de error
            echo json_encode(array("success" => false, "message" => 'Error al agregar la tarea: ' . pg_last_error($conn)));
        }
        exit; // Terminar el script después de procesar la solicitud de agregar tarea
    }

    // Eliminar tarea
    if (isset($_POST['nombreTarea'])) {
        // Procesar la eliminación de tarea
        $taskName = $_POST['nombreTarea'];

        // Preparar la consulta SQL para eliminar la tarea
        $queryDelete = "DELETE FROM tareas WHERE nombre_tarea = $1";
        $resultDelete = pg_query_params($conn, $queryDelete, array($taskName));

        if ($resultDelete) {
            // Si la eliminación fue exitosa, devolver respuesta JSON de éxito
            echo json_encode(array("success" => true, "message" => "La tarea '$taskName' se ha eliminado correctamente."));
        } else {
            // Si hubo un error en la eliminación, devolver respuesta JSON de error
            echo json_encode(array("success" => false, "message" => "Error al eliminar la tarea: " . pg_last_error($conn)));
        }
        exit; // Terminar el script después de procesar la solicitud de eliminar tarea
    }

    // Si no se recibió correctamente el nombre de la tarea para eliminar, devolver un mensaje de error
    echo json_encode(array("success" => false, "message" => "No se proporcionó el nombre de la tarea para eliminar."));
    exit; // Terminar el script después de verificar la solicitud POST
}

// Consulta SQL para obtener todas las tareas
$querySelect = "SELECT nombre_tarea AS title, fecha_tarea AS start FROM tareas";
$resultSelect = pg_query($conn, $querySelect);

if (!$resultSelect) {
    die("Error al ejecutar la consulta: " . pg_last_error($conn));
}

$tareas = array();

while ($row = pg_fetch_assoc($resultSelect)) {
    $tareas[] = $row;
}

// Devolver las tareas en formato JSON
echo json_encode($tareas);

// Cerrar conexión
pg_close($conn);
?>
