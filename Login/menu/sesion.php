<!-- Enlace al archivo CSS de Bootstrap -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<!-- Enlace a los archivos JavaScript de Bootstrap y jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<?php
require 'conexion.php';

session_start();

$usuario = $_POST['user'];
$clave = $_POST['pass'];

$query = "SELECT * FROM usuarios 
    WHERE usuario='$usuario' AND contrasena='$clave'";



$consulta = pg_query($conexion, $query);


$cantidad = pg_num_rows($consulta);


if ($cantidad > 0) {


    $_SESSION['nombre_usuario'] = $usuario;
 
    header('Location: ingreso.php');
} else {
    // Generar código HTML para la ventana modal en la misma página
    echo '<div class="modal" id="modalDatosIncorrectos">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Datos incorrectos</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        Los datos ingresados son incorrectos. Por favor, inténtalo de nuevo.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>';

    // Agregar script para mostrar la ventana modal y redirigir al cerrar
    echo '<script>
            $(document).ready(function(){
                $("#modalDatosIncorrectos").modal("show");
                $("#modalDatosIncorrectos").on("hidden.bs.modal", function () {
                    window.location.href = "index.html";
                });
            });
        </script>';
}
?> 