<?php
session_start();


// Redirigir a la página principal
header("Location: /LoginMag/menu/html/home.html");
exit(); // Asegura que el script se detenga aquí y la redirección se ejecute correctamente
?>
