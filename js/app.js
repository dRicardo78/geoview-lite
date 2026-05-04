// =========================
//  MAPA BASE
// =========================

var map = L.map('map').setView([7.125, -73.119], 13);

L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
  attribution: 'Esri World Imagery'
}).addTo(map);


// =========================
//  CONTROL DE SELECCIÓN
// =========================

var capaSeleccionada = null;

var estiloDefault = {
  color: "#3388ff",
  weight: 2,
  fillColor: "#3388ff",
  fillOpacity: 0.3
};

var estiloSeleccionado = {
  color: "yellow",
  weight: 4,
  fillColor: "yellow",
  fillOpacity: 0.5
};


// =========================
//  CARGA DE GEOJSON
// =========================

fetch('data/predio.geojson')
  .then(res => res.json())
  .then(data => {
    console.log("GeoJSON cargado:", data);

    var capa = L.geoJSON(data, {

      style: function () {
        return estiloDefault;
      },

      onEachFeature: function (feature, layer) {

        // =========================
        //  POPUP (FICHA DE PREDIO)
        // =========================

        layer.bindPopup(`
          <div style="font-family: Arial; width: 220px;">
            <h3 style="margin:5px 0;">🏷️ ${feature.properties.nombre || "Predio"}</h3>
            <hr>
            <p>📐 <b>Área:</b> ${feature.properties.area || "No definida"}</p>
            <p>👤 <b>Propietario:</b> ${feature.properties.propietario || "No registrado"}</p>
          </div>
        `);

        // =========================
        //  INTERACCIÓN CLICK
        // =========================

        layer.on('click', function () {
          console.log("CLICK EN PREDIO");

          // ✅ Resetear estilo del predio anterior
          if (capaSeleccionada && capaSeleccionada !== layer) {
            capaSeleccionada.setStyle(estiloDefault);
          }

          // ✅ Guardar nuevo seleccionado
          capaSeleccionada = layer;

          // ✅ Resaltar actual
          layer.setStyle(estiloSeleccionado);

          // ✅ Zoom automático al predio
          map.fitBounds(layer.getBounds(), {
            padding: [20, 20]
          });

          // ✅ Abrir popup
          layer.openPopup();

          // ✅ Actualizar panel de detalles
        
            // ✅ Llenar panel lateral
            document.getElementById('p-nombre').textContent = feature.properties.nombre || "Sin nombre";
            document.getElementById('p-area').textContent = feature.properties.area || "No definida";
            document.getElementById('p-propietario').textContent = feature.properties.propietario || "No registrado";
    
        }); // <-- cierra layer.on('click', ...)

      } // <-- cierra onEachFeature

    }).addTo(map);

    map.fitBounds(capa.getBounds());

  });


// =========================
//  UBICACIÓN DEL USUARIO
// =========================

function ubicarUsuario() {

  if (!navigator.geolocation) {
    alert("Geolocalización no soportada");
    return;
  }

  navigator.geolocation.getCurrentPosition(
    position => {
      var lat = position.coords.latitude;
      var lon = position.coords.longitude;

      L.marker([lat, lon])
        .addTo(map)
        .bindPopup("📍 Estás aquí")
        .openPopup();

      map.setView([lat, lon], 16);
    },
    error => {
      alert("No se pudo obtener tu ubicación: " + error.message);
    },
    { enableHighAccuracy: true, timeout: 10000 }
  );

}

document.getElementById("fileInput").addEventListener("change", function (e) {
  const file = e.target.files[0];

  if (!file) return;

  const reader = new FileReader();

  reader.onload = function (event) {
    console.log("ARCHIVO CARGADO OK");
    console.log(event.target.result);
    const geojson = JSON.parse(event.target.result);

    // eliminar capa anterior si existe
    if (window.capaGeoJSON) {
      map.removeLayer(window.capaGeoJSON);
    }

    // nueva capa
    window.capaGeoJSON = L.geoJSON(geojson, {
      onEachFeature: function (feature, layer) {

        layer.bindPopup(`
          <b>${feature.properties.nombre || "Predio"}</b>
        `);

        layer.on('click', function () {

          document.getElementById("p-nombre").innerText =
            feature.properties.nombre || "Sin nombre";

          document.getElementById("p-area").innerText =
            feature.properties.area || "No definida";

          document.getElementById("p-propietario").innerText =
            feature.properties.propietario || "No registrado";

          map.fitBounds(layer.getBounds());

        });

      }
    }).addTo(map);

    map.fitBounds(window.capaGeoJSON.getBounds());
  };

  reader.readAsText(file);
});