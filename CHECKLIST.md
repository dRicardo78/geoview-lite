# 🔍 Checklist de Instalación

Esta lista de verificación te guía a través de los pasos para asegurar que todo está correctamente configurado.

## ✅ Paso 1: Estructura del Proyecto

Verifica que tu carpeta `geoview-lite/` contenga:

```
☐ index.html                        (Visor 2D principal)
☐ config.json                       (Configuración global)
☐ README.md                         (Documentación)
☐ PIPELINE_LAZ_3D.md               (Guía completa de conversión)
☐ LICENSE                           (Licencia MIT)
☐ CHECKLIST.md                      (Este archivo)

☐ css/
  ☐ styles.css
☐ data/
  ☐ predio.geojson
  ☐ (opcional) archivo.kml
☐ 3d-viewer/
  ☐ visor-3d.html
☐ datasets-3d/
  ☐ index.json
☐ tools/
  ☐ convert.bat
  ☐ convert.sh
```

## ✅ Paso 2: Iniciar Servidor HTTP

**Elije UNA opción:**

### Opción A: Live Server (VS Code)
```
1. Instalar extensión "Live Server"
2. Click derecho en index.html
3. Seleccionar "Open with Live Server"
4. Debería abrir http://localhost:5500
```

### Opción B: Python (Recomendado)
```bash
cd geoview-lite/
python -m http.server 8000
# Abrir: http://localhost:8000
```

### Opción C: Node.js
```bash
npm install -g http-server
cd geoview-lite/
http-server -p 8000
```

### Opción D: PowerShell
```powershell
cd geoview-lite
python -m http.server 8000
```

**Verificación:** ✅ Servidor respondiendo en http://localhost:8000

## ✅ Paso 3: Probar Visor 2D

En el navegador:
1. Abre: `http://localhost:8000`
2. Deberías ver:
   - ☐ Mapa con tiles (Satélite o Calles)
   - ☐ Botón 📍 en esquina superior izquierda
   - ☐ Panel lateral (inicialmente cerrado)
   - ☐ Predios cargados desde `data/predio.geojson`

**Funciones a probar:**
- ☐ Click en predio → Panel se abre con detalles
- ☐ Botón ✏️ Editar → Modo edición
- ☐ Botón 🎯 Ver en 3D → Abre visor 3D (si existen datasets)
- ☐ Botón 📍 Ubicarme → Centra en tu posición (requiere permiso)

## ✅ Paso 4: Probar Visor 3D

En el navegador:
1. Abre directamente: `http://localhost:8000/3d-viewer/visor-3d.html`
2. Deberías ver:
   - ☐ Panel de control en esquina superior izquierda
   - ☐ Panel de información en esquina inferior derecha
   - ☐ Dropdown "Seleccionar dataset"
   - ☐ Advertencia: "No hay datasets disponibles" (esperado sin LAZ convertidos)

## ✅ Paso 5: Cargar Archivo GeoJSON o KML

En Visor 2D:
1. Busca campo "📁 Importar archivo"
2. Selecciona un archivo `.geojson` o `.kml`
3. Click en "Cargar" o "Importar"
4. Deberías ver:
   - ☐ Los predios aparecen en el mapa
   - ☐ Panel lateral muestra propiedades
   - ☐ Puedes editar y guardar

## ✅ Paso 6: Configurar PotreeConverter (Opcional)

Para convertir archivos LAZ reales:

### Descargar
```bash
# Ir a: https://github.com/potree/PotreeConverter/releases
# Descargar: PotreeConverter_windows_x64_2.0.0.zip
# (O versión para tu SO)
```

### Instalar
```bash
# Extraer en: geoview-lite/tools/
# Resultado:
# tools/
#   PotreeConverter_windows_x64_2.0.0/
#     PotreeConverter.exe
#     ...
```

### Convertir Archivo LAZ
```bash
cd geoview-lite/tools/
convert.bat C:\ruta\archivo.laz mi-primera-nube

# Resultado esperado:
# datasets-3d/mi-primera-nube/
#   cloud.js
#   cloud.json
#   octree/
```

## ✅ Paso 7: Agregar Dataset a config.json

Una vez convertido un LAZ:

1. Editar `datasets-3d/index.json`
2. Cambiar `"enabled": false` → `"enabled": true`
3. O agregar nueva entrada:

```json
{
  "id": "mi-nube",
  "name": "Mi Primera Nube",
  "path": "mi-nube/cloud.js",
  "enabled": true,
  "metadata": {
    "points_total": 50000000,
    "area_km2": 10.5,
    "resolution_cm": 5
  }
}
```

## ✅ Paso 8: Probar Sincronización 2D ↔ 3D

1. En Visor 2D: Selecciona un predio
2. Click en botón 🎯 "Ver en 3D"
3. Debería:
   - ☐ Abrir nueva ventana
   - ☐ Mostrar visor 3D
   - ☐ Cámara centrada en coordenadas del predio

## 🐛 Troubleshooting

### Problema: "CORS error"
```
❌ Error: Access to XMLHttpRequest blocked by CORS policy
✅ Solución: Asegurar que estás usando http://localhost:8000
❌ NO usar: file:///C:/proyecto/index.html
```

### Problema: "Nube no se ve en visor 3D"
```
1. ☐ ¿Existe datasets-3d/nombre/cloud.js?
2. ☐ ¿El archivo index.json tiene enabled: true?
3. ☐ ¿Abriste el visor 3D desde visor 2D o directamente?
4. ☐ Abre consola (F12) y busca errores
```

### Problema: "Predios no se ven en mapa 2D"
```
1. ☐ ¿Cargaste el archivo GeoJSON/KML?
2. ☐ ¿El archivo es válido? (Ver en https://geojson.io)
3. ☐ Abre consola (F12) y busca errores de JavaScript
```

### Problema: "Servidor HTTP no responde"
```
Windows (PowerShell):
  # Verificar que Python está instalado
  python --version
  
  # Si no: Descargar de https://python.org
  # Luego:
  python -m http.server 8000

Linux/Mac:
  # Verificar que Python está instalado
  python3 --version
  
  # Luego:
  python3 -m http.server 8000
```

## 📊 Tabla de Verificación Final

Completa esta tabla para confirmar que todo funciona:

| Feature | Status | Notes |
|---------|--------|-------|
| Visor 2D carga | ☐ ✅ | http://localhost:8000 |
| Mapa visible | ☐ ✅ | Con tiles de OpenStreetMap |
| Predios se muestran | ☐ ✅ | Desde data/predio.geojson |
| Panel abre al click | ☐ ✅ | Botón ✕ cierra panel |
| Edición funciona | ☐ ✅ | Cambios se guardan |
| Importar archivo | ☐ ✅ | Acepta .geojson y .kml |
| Visor 3D carga | ☐ ✅ | En /3d-viewer/visor-3d.html |
| Controls visor 3D | ☐ ✅ | Point Budget, FOV, etc |
| Sincronización 2D→3D | ☐ ✅ | Botón "Ver en 3D" funciona |
| Datasets dropdown | ☐ ✅ | Muestra lista (aunque esté vacía) |

## 📞 Próximos Pasos

### Si TODO funciona ✅
1. Descargar PotreeConverter
2. Convertir archivos LAZ reales
3. Agregar datasets a `datasets-3d/index.json`
4. Disfrutar del visor completo

### Si algo NO funciona ❌
1. Consultar sección "Troubleshooting" arriba
2. Abrir consola del navegador (F12)
3. Revisar archivo PIPELINE_LAZ_3D.md
4. Verificar que el servidor HTTP está activo

## 📚 Recursos Rápidos

- **Documentación completa:** [PIPELINE_LAZ_3D.md](PIPELINE_LAZ_3D.md)
- **Manual de uso:** [README.md](README.md)
- **Validar GeoJSON:** https://geojson.io
- **Potree Docs:** https://potree.org/
- **Leaflet Docs:** https://leafletjs.com/

---

**Última actualización:** 5 de mayo de 2026  
✅ **Estado:** Guía de instalación completa
