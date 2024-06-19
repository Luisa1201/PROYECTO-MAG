//grafico de barras

document.addEventListener('DOMContentLoaded', function() {
    // Gráfica de ingresos (gráfico lineal)
    var incomeData = {
        labels: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio'],
        datasets: [{
            label: 'Ventas Mensuales',
            data: [12, 19, 3, 5, 2, 3],
            fill: false,
            borderColor: '#4BC0C0',
            tension: 0.1
        }, {
            label: 'Servicios Mensuales',
            data: [5, 8, 2, 4, 1, 2],
            fill: false,
            borderColor: '#FF6384',
            tension: 0.1
        }]
    };

    var incomeChart = new Chart(document.getElementById('incomeChart'), {
        type: 'line',
        data: incomeData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    grid: {
                        display: true,
                        drawBorder: false,
                    }
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        display: true,
                        drawBorder: false,
                    }
                }
            }
        }
    });
    
    // Ajuste de tamaño de la fuente para las etiquetas
    Chart.defaults.font.size = 14;
});

//grafico circular
$(document).ready(function() {
    $.ajax({
        url: '../php/grafico.php', // Ruta a tu script PHP que devuelve los datos
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            $('#profesionales').text(data.profesionales);
            $('#clientes').text(data.clientes);
            $('#servicios').text(data.servicios);
            $('#ventas').text(data.ventas);

            // Configurar los datos para el gráfico circular (pie chart)
            var ctx = document.getElementById('employeesClientsServicesChart').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'pie', // Tipo de gráfico circular (pie chart)
                data: {
                    labels: ['Profesionales', 'Clientes', 'Servicios'],
                    datasets: [{
                        label: 'Cantidad',
                        data: [data.profesionales, data.clientes, data.servicios],
                        backgroundColor: ['#3498db', '#2ecc71', '#e74c3c'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        position: 'bottom' // Posición de la leyenda
                    }
                }
            });
        },
        error: function() {
            alert('Error al obtener los datos.');
        }
    });
});
//el grafico de cantidad en forma cuadrados
$(document).ready(function() {
    $.ajax({
        url: '../php/grafico.php', // Cambia esto por la ruta a tu script PHP
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            $('#profesionales').text(data.profesionales);
            $('#clientes').text(data.clientes);
            $('#servicios').text(data.servicios);
            $('#ventas').text(data.ventas);
        },
        error: function() {
            alert('Error al obtener los datos.');
        }
    });
});



$(document).ready(function() {
    $('#modoOscuroBtn').click(function() {
        $('body').toggleClass('dark-mode');
    });
});
