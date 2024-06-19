<?php
session_start();

// Eliminar todas las variables de sesión
$_SESSION = array();

// Finalmente, destruir la sesión
session_destroy();

// Redirigir a la página de inicio de sesión u otra página
header("Location: LoginMag/menu/html/index.html");
exit();
?>
