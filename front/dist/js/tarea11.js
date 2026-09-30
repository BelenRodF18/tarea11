// front/dist/js/tarea11.js
// Pide a la API las tablas y las consultas, y las dibuja en la pagina.

// Escapamos lo que viene de la base antes de meterlo en el HTML.
function esc(valor) {
    if (valor === null) return '<i>NULL</i>';
    return String(valor).replace(/[&<>"']/g, (c) => ({
        '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[c]));
}

// Arma una tabla HTML a partir de las filas que devolvio la consulta.
function armarTabla(filas) {
    if (!filas || filas.length === 0) {
        return '<p class="sin-datos">La consulta no devolvio filas.</p>';
    }

    const columnas = Object.keys(filas[0]);

    const encabezado = '<tr>' + columnas.map((c) => '<th>' + esc(c) + '</th>').join('') + '</tr>';

    const cuerpo = filas.map((fila) =>
        '<tr>' + columnas.map((c) => '<td>' + esc(fila[c]) + '</td>').join('') + '</tr>'
    ).join('');

    return '<table><thead>' + encabezado + '</thead><tbody>' + cuerpo + '</tbody></table>';
}

async function cargarTablas() {
    const caja = document.getElementById('tablas');
    const res = await API.request('/tablas');

    if (res.status !== 'ok') {
        caja.innerHTML = '<p class="sin-datos">No se pudo conectar con la base de datos.</p>';
        return;
    }

    caja.innerHTML = res.data.map((t) =>
        '<h3>' + esc(t.nombre) + ' (' + t.filas.length + ' filas)</h3>' +
        '<div class="desplazable">' + armarTabla(t.filas) + '</div>'
    ).join('');
}

async function cargarConsultas() {
    const caja = document.getElementById('consultas');
    const res = await API.request('/consultas');

    if (res.status !== 'ok') {
        caja.innerHTML = '<p class="sin-datos">No se pudieron ejecutar las consultas.</p>';
        return;
    }

    caja.innerHTML = res.data.map((c) =>
        '<h3>' + c.numero + '. ' + esc(c.operador) + '</h3>' +
        '<p class="enunciado">' + esc(c.enunciado) + '</p>' +
        '<pre>' + esc(c.sql) + '</pre>' +
        '<div class="desplazable">' + armarTabla(c.filas) + '</div>'
    ).join('');
}

document.addEventListener('DOMContentLoaded', () => {
    cargarTablas();
    cargarConsultas();
});
