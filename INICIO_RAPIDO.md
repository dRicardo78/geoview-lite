# 🚀 GUÍA RÁPIDA DE INICIO

**GeoView Lite v1.0** - Sistema de visualización geoespacial 2D/3D completo

---

## ⚡ 5 Minutos para Empezar

### 1️⃣ **Iniciar Servidor (30 segundos)**

**Windows PowerShell:**
```powershell
cd geoview-lite
python -m http.server 8000
```

**macOS/Linux Terminal:**
```bash
cd geoview-lite
python3 -m http.server 8000
```

### 2️⃣ **Abrir Navegador (10 segundos)**

```
Dirección: http://localhost:8000
```

✅ Verás el **Visor 2D** con predios en un mapa satelital

### 3️⃣ **Interactuar (3 minutos)**

```
1. Click en un PREDIO (cualquier región coloreada)
   → Panel lateral muestra detalles

2. Click en botón ✏️ "Editar"
   → Puedes cambiar propiedades

3. Click en botón 🎯 "Ver en 3D"
   → Se abre visor 3D (si hay datos LiDAR)
```

---

## 📍 Dónde Están Las Cosas

| Función | Ubicación |
|---------|-----------|
| 🗺️ Mapa principal | http://localhost:8000 |
| 🎨 Editor de predios | Panel lateral (click en predio) |
| 🔍 Importar archivos | Campo "Importar archivo" |
| 🎯 Visor 3D | http://localhost:8000/3d-viewer/visor-3d.html |
| 📄 Documentación | PIPELINE_LAZ_3D.md |

---

## 📁 Cargar Tus Propios Datos

### Formato 1: GeoJSON
```
1. Prepara archivo: datos.geojson
2. En Visor 2D: Botón "Importar archivo"
3. Selecciona datos.geojson
4. Click "Cargar"
✅ Aparecen en el mapa
```

### Formato 2: KML (Google Earth)
```
1. Prepara archivo: datos.kml
2. En Visor 2D: Botón "Importar archivo"
3. Selecciona datos.kml
4. Click "Cargar"
✅ Se convierte automáticamente a GeoJSON
```

### Formato 3: LAZ (LiDAR)
```
⚠️ Requiere procesamiento previo:

1. Descargar PotreeConverter
   https://github.com/potree/PotreeConverter/releases

2. Convertir archivo:
   PotreeConverter.exe archivo.laz -o datasets-3d/mi-nube -c

3. Actualizar datasets-3d/index.json:
   "enabled": true

4. Abrir visor 3D → Seleccionar dataset

Ver: PIPELINE_LAZ_3D.md para detalles
```

---

## 🎮 Controles del Visor 3D

### Mouse
- **Rotación:** Click izquierdo + arrastrar
- **Zoom:** Rueda del mouse
- **Desplazamiento:** Click derecho + arrastrar

### Controles del Panel
- **Point Budget:** Slider (más puntos = más detalle, menos FPS)
- **FOV:** Campo de visión (60° recomendado)
- **Modo Visualización:** RGB, Altura, Intensidad, Clasificación
- **Reset Cámara:** Botón para volver a vista inicial

---

## 📊 Controles del Visor 2D

### Mapa
- **Zoom:** Rueda del mouse o botones +/-
- **Mover:** Click izquierdo + arrastrar
- **Seleccionar predio:** Click sobre región

### Panel Lateral
- **Editar:** Cambiar propiedades del predio
- **Ver en 3D:** Si existen datos LiDAR sincronizados
- **Cerrar:** Botón ✕

---

## 🔧 Configuración Rápida

### Cambiar Punto Presupuestario (Rendimiento 3D)
```json
// Archivo: config.json
"viewer_3d": {
  "default_point_budget": 500000  // Reduce si baja FPS
}
```

### Cambiar Centro del Mapa 2D
```json
// Archivo: config.json
"viewer_2d": {
  "default_center": [7.125, -73.119]  // [lat, lon]
}
```

### Habilitar/Deshabilitar Dataset
```json
// Archivo: datasets-3d/index.json
{
  "id": "mi-nube",
  "enabled": true  // Cambiar a false para ocultarlo
}
```

---

## ⚠️ Problemas Comunes

### ❌ "Mapa no carga"
```
✅ Verificar:
   1. ¿Servidor está corriendo? (python -m http.server 8000)
   2. ¿URL correcta? (http://localhost:8000)
   3. Abrir consola (F12) y buscar errores
```

### ❌ "Visor 3D está vacío"
```
✅ Verificar:
   1. ¿Convertiste un archivo LAZ?
   2. ¿Está habilitado en datasets-3d/index.json?
   3. Revisar PIPELINE_LAZ_3D.md
```

### ❌ "Predios no se ven"
```
✅ Verificar:
   1. ¿Cargaste un archivo GeoJSON/KML?
   2. ¿El archivo es válido? (https://geojson.io)
   3. Abrir consola (F12) y buscar errores
```

### ❌ "Rendimiento bajo (FPS bajo)"
```
✅ Soluciones:
   1. Reducir Point Budget en visor 3D
   2. Cambiar Render Mode a "RGB" (más rápido)
   3. Desabilitar EDL si está muy lento
```

---

## 🎓 Aprender Más

| Tema | Archivo |
|------|---------|
| Sistema completo | README.md |
| Pipeline LAZ completo | PIPELINE_LAZ_3D.md |
| Checklist instalación | CHECKLIST.md |
| Código de visor 2D | index.html |
| Código de visor 3D | 3d-viewer/visor-3d.html |

---

## 💡 Tips y Trucos

### Tip 1: Validar GeoJSON antes de cargar
```
Ir a: https://geojson.io
Pegar contenido o subir archivo
Si muestra el mapa, es válido ✅
```

### Tip 2: Exportar predios modificados
```
En Visor 2D:
1. Editar predios
2. Botón 💾 "Descargar GeoJSON"
3. Guardar archivo actualizado
```

### Tip 3: Sincronizar con Google Earth
```
1. En Google Earth: Exportar como KML
2. En GeoView: Importar el KML
3. Automáticamente se convierte a GeoJSON
```

### Tip 4: Capturar vista 3D
```
En Visor 3D:
1. Usar PrintScreen o Snip & Sketch
2. Guardar como imagen
3. Compartir en reportes
```

---

## 📋 Checklist de Inicio

```
☐ Servidor HTTP corriendo (python -m http.server 8000)
☐ http://localhost:8000 abierto en navegador
☐ Mapa 2D visible con predios
☐ Panel abre al hacer click en predio
☐ Botón "Ver en 3D" visible (aunque esté vacío)
☐ Consola del navegador sin errores (F12)

Si TODO está ✅: ¡Listo para usar!
```

---

## 🌟 Próximos Pasos

### Paso 1: Cargar datos reales
```
1. Preparar archivo GeoJSON o KML
2. Importar en visor 2D
3. Disfrutar de la visualización
```

### Paso 2: Agregar datos LiDAR (Opcional)
```
1. Descargar PotreeConverter
2. Convertir archivo LAZ
3. Habilitar en datasets-3d/index.json
4. Ver en visor 3D
```

### Paso 3: Personalizar
```
1. Editar config.json
2. Cambiar colores en css/styles.css
3. Modificar limites iniciales del mapa
```

---

## 📞 Soporte

- 📚 Documentación: Leer **PIPELINE_LAZ_3D.md**
- 🐛 Errores: Revisar consola (F12)
- 📖 Wiki: Ver README.md
- ✓ Validar: https://geojson.io (para archivos)

---

**Versión:** 1.0  
**Última actualización:** 5 de mayo de 2026  
**Estado:** ✅ Listo para producción
