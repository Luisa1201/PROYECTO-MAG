$(document).ready(function() {
    // Arreglo para almacenar las tareas
    var tasks = [];

    // Inicializar el calendario
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'es',
        events: '../php/guardar_tarea.php', // URL para cargar las tareas
        editable: true, // Permite arrastrar y soltar eventos
        eventDrop: function(info) {
            // Actualizar la fecha de la tarea cuando se arrastra en el calendario
            var taskIndex = tasks.findIndex(task => task.title === info.event.title);
            if (taskIndex !== -1) {
                tasks[taskIndex].start = info.event.startStr;
            }
            updateCalendar();
        }
    });
    calendar.render();

    // Función para cargar tareas desde el servidor
    function loadTasks() {
        fetch('../php/guardar_tarea.php')
            .then(response => response.json())
            .then(data => {
                tasks = data; // Almacenar las tareas en el arreglo
                renderTaskList(); // Renderizar lista de tareas en la tabla
                updateCalendar(); // Actualizar el calendario con las tareas cargadas
            })
            .catch(error => {
                console.error('Error al cargar las tareas:', error);
            });
    }

    // Llamar a la función para cargar tareas al cargar la página
    loadTasks();

    // Formulario para agregar tarea
    $('#taskForm').submit(function(e) {
        e.preventDefault();

        var taskName = $('#taskName').val().trim();
        var taskDate = $('#taskDate').val().trim();

        if (taskName === '' || taskDate === '') {
            swal("Error", "Por favor ingrese tanto el nombre como la fecha de la tarea.", "error");
            return;
        }

        // Llamar a la función para guardar la tarea
        saveTask(taskName, taskDate);
    });

    // Función para guardar una nueva tarea en el servidor
    function saveTask(taskName, taskDate) {
        $.ajax({
            type: 'POST',
            url: '../php/guardar_tarea.php',
            data: {
                nombreTarea: taskName,
                fechaTarea: taskDate
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Agregar tarea al arreglo local
                    tasks.push({
                        title: taskName,
                        start: taskDate,
                        allDay: true
                    });

                    // Limpiar campos del formulario
                    $('#taskName').val('');
                    $('#taskDate').val('');

                    // Mostrar alerta modal de éxito con SweetAlert
                    swal("¡Tarea agregada!", response.message, "success")
                        .then(() => {
                            // Actualizar la lista de tareas y el calendario
                            renderTaskList();
                            updateCalendar();
                        });
                } else {
                    // Mostrar alerta de error con SweetAlert
                    swal("Error", response.message, "error");
                }
            },
            error: function(xhr, status, error) {
                // Mostrar alerta de error genérico con SweetAlert
                swal("Error", "Error en la solicitud AJAX", "error");
            }
        });
    }

    // Función para renderizar la lista de tareas en la tabla
    function renderTaskList() {
        var taskTableBody = document.getElementById('taskTableBody');
        taskTableBody.innerHTML = ''; // Limpiar contenido previo

        tasks.forEach(function(task, index) {
            var row = document.createElement('tr');

            // Celda para el nombre de la tarea
            var taskNameCell = document.createElement('td');
            taskNameCell.textContent = task.title;
            row.appendChild(taskNameCell);

            // Celda para la fecha de la tarea
            var taskDateCell = document.createElement('td');
            taskDateCell.textContent = task.start;
            row.appendChild(taskDateCell);

            // Celda para el botón de eliminar tarea
            var deleteBtnCell = document.createElement('td');
            var deleteBtn = document.createElement('button');
            deleteBtn.classList.add('btn', 'btn-danger', 'btn-sm');
            deleteBtn.textContent = 'Eliminar';
            deleteBtn.addEventListener('click', function() {
                var taskToDelete = tasks[index].title;

                $.ajax({
                    type: 'POST',
                    url: '../php/guardar_tarea.php',
                    data: {
                        nombreTarea: taskToDelete
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Eliminar la tarea del arreglo local
                            tasks.splice(index, 1);
                            // Renderizar lista actualizada
                            renderTaskList();
                            // Actualizar el calendario
                            updateCalendar();
                            // Mostrar alerta modal de éxito con SweetAlert
                            swal("¡Tarea eliminada!", response.message, "success");
                        } else {
                            // Mostrar alerta de error con SweetAlert
                            swal("Error", response.message, "error");
                        }
                    },
                    error: function(xhr, status, error) {
                        // Mostrar alerta de error genérico con SweetAlert
                        swal("Error", "Error en la solicitud AJAX", "error");
                    }
                });
            });
            deleteBtnCell.appendChild(deleteBtn);
            row.appendChild(deleteBtnCell);

            // Agregar la fila a la tabla
            taskTableBody.appendChild(row);
        });
    }

    // Función para actualizar el calendario con las tareas
    function updateCalendar() {
        calendar.removeAllEvents(); // Limpiar eventos existentes
        calendar.addEventSource(tasks); // Agregar nuevas tareas
        calendar.render();
    }
});
