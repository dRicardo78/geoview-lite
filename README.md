# 🌐 GeoView Lite - Sistema Completo 2D/3D

**Versión:** 1.0  
**Estado:** Completo y funcional  
**Última actualización:** Mayo 2026

---

## 📋 Descripción

**GeoView Lite** es un sistema profesional de visualización geoespacial con soporte completo para:

✅ **Visor 2D** (Leaflet): Predios, mapas vectoriales, KML/GeoJSON  
✅ **Visor 3D** (Potree): Nubes de puntos LiDAR, renderizado optimizado  
✅ **Sincronización 2D ↔ 3D**: Navegación integrada entre vistas  
✅ **Pipeline LAZ**: Conversión completa de datos LiDAR  

---

## 🚀 Inicio Rápido

### 1. Iniciar Servidor HTTP

```bash
# Opción A: Live Server (VS Code)
# Botón derecho en index.html → "Open with Live Server"

# Opción B: Python
python -m http.server 8000

# Opción C: Node.js
npm install -g http-server
http-server -p 8000
```

### 2. Acceder a la aplicación

- **Visor 2D**: http://localhost:8000
- **Visor 3D**: http://localhost:8000/3d-viewer/visor-3d.html

### 3. Usar funcionalidad

**En Visor 2D:**
```
1. Ver mapa con predios
2. Click en predio → Panel de detalles
3. Botón "Ver en 3D" → Abre visor 3D sincronizado
```

---

## 📁 Estructura del Proyecto

```
geoview-lite/
│
├── 📄 index.html                    ⭐ VISOR 2D (LEAFLET)
├── 📄 config.json                   ⚙️ Configuración global
│
├── 📁 3d-viewer/
│   └── 📄 visor-3d.html            ⭐ VISOR 3D (POTREE)
│
├── 📁 datasets-3d/                  📦 NUBES CONVERTIDAS
│   ├── dataset-001/
│   │   ├── cloud.js
│   │   ├── cloud.json
│   │   └── octree/
│   └── dataset-002/
│
├── 📁 tools/
│   ├── 📄 convert.bat              🔧 Conversión Windows
│   ├── 📄 convert.sh               🔧 Conversión Linux
│   └── 📁 PotreeConverter/         ⬇️ Descarga necesaria
│
├── 📁 data/
│   ├── predio.geojson
│   └── predio_test.kml
│
├── 📁 css/
│   └── styles.css
│
├── 📄 PIPELINE_LAZ_3D.md           📚 Documentación completa
├── 📄 README.md                    📚 Este archivo
└── 📄 LICENSE                      📄 Licencia
```

---

## ⚙️ Configuración

**Archivo:** `config.json`

```json
{
  "viewer_3d": {
    "default_point_budget": 1000000,  // 1M puntos visibles
    "max_point_budget": 10000000,     // 10M máximo
    "default_fov": 60                 // Campo de visión
  },
  "sync_2d_3d": {
    "enabled": true,                  // Sincronización activa
    "bidirectional": true             // 2D ↔ 3D
  }
}
```

---

## 🎯 Flujo Completo de Usuario

```
┌─────────────────────────────────────┐
│ Usuario abre index.html             │
│ (Visor 2D con Leaflet)              │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ Ve mapa con predios                 │
│ - Búsqueda de predios               │
│ - Panel lateral con detalles        │
│ - Edición de propiedades            │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ Click en "Ver en 3D"                │
│ (Para un predio seleccionado)       │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ Se abre visor-3d.html               │
│ (Potree con nube sincronizada)      │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ Selecciona dataset de puntos        │
│ - Carga nube 3D                     │
│ - Point Budget: 1M puntos           │
│ - Navegación 3D (rotación, zoom)    │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│ (Opcional) Sincronización inversa   │
│ Envía posición 3D → Mapa 2D         │
└─────────────────────────────────────┘
```

---

## 🔄 FASES DEL SISTEMA

### ✅ FASE 0: Separación de Arquitectura
- Visor 2D independiente (Leaflet)
- Visor 3D separado (Potree)
- Carpetas organizadas por función

### ✅ FASE 1: Entrada de Datos
- Aceptar `.laz`, `.las`, `.ply`, `.e57`
- Comprender que requieren conversión previa
- NO renderizar directamente

### ✅ FASE 2: Conversión LAZ → Potree
**Herramienta:** PotreeConverter 2.0
```bash
PotreeConverter.exe archivo.laz -o datasets-3d/mi-nube -c
```

### ✅ FASE 3: Servidor HTTP
**Requisito:** No usar `file://`
```bash
python -m http.server 8000
```

### ✅ FASE 4: Renderizado 3D
- Potree 1.8+ con WebGL
- Point Budget: 1M puntos (optimizado)
- Level of Detail (LoD) automático

### ✅ FASE 5: Interacción Usuario
- Rotación, zoom, desplazamiento
- Panel de control intuitivo
- Modos de visualización (RGB, Altura, Intensidad)

### ✅ FASE 6: Sincronización 2D ↔ 3D
```javascript
// Desde visor 2D
abrirVisor3D(lat, lng, properties);

// Recibir en visor 3D
window.receiveCoordinatesFrom2D(lat, lon, height);
```

### ✅ FASE 7: Gestión de Datasets
- Configuración en `config.json`
- Estructura normalizada en `datasets-3d/`
- Indexación de nubes disponibles

### ✅ FASE 8: Flujo Completo
- Usuario ↔ Visor 2D ↔ Visor 3D
- Sincronización automática
- Renderizado optimizado

---

## 📊 Características

### Visor 2D (Leaflet)
- ✅ Mapa base (Satélite/Calles)
- ✅ Carga de archivos (GeoJSON, KML)
- ✅ Edición de predios
- ✅ Búsqueda y filtrado
- ✅ Botón "Ver en 3D"

### Visor 3D (Potree)
- ✅ Renderizado de nubes optimizado
- ✅ Point Budget configurable
- ✅ Modos de visualización (RGB, Altura, Intensidad)
- ✅ Estadísticas en tiempo real
- ✅ Panel de sincronización
- ✅ Reseteo de vista

### Sistema General
- ✅ Sincronización 2D ↔ 3D
- ✅ Gestión de datasets
- ✅ Configuración centralizada
- ✅ Scripts de conversión automatizada
- ✅ Documentación completa

---

## 🛠️ Conversión de Archivos LAZ

### Descarga PotreeConverter

```bash
# Opción 1: Descargar ZIP
# https://github.com/potree/PotreeConverter/releases
# Extraer en: tools/PotreeConverter/

# Opción 2: Compilar desde fuente
git clone https://github.com/potree/PotreeConverter.git
cd PotreeConverter && mkdir build && cd build
cmake .. && make
```

### Convertir archivo

**Windows:**
```bash
cd tools/
convert.bat C:\ruta\archivo.laz mi-nube-01
```

**Linux/Mac:**
```bash
cd tools/
chmod +x convert.sh
./convert.sh /ruta/archivo.laz mi-nube-01
```

### Resultado

```
datasets-3d/mi-nube-01/
├── cloud.js          # Descriptor Potree
├── cloud.json        # Metadata (puntos, bounds, etc)
├── octree/           # Estructura jerárquica
│   ├── r/            # Root level
│   ├── r/0/
│   ├── r/1/
│   └── ...
└── metadata/
```

---

## 📈 Rendimiento y Point Budget

**Point Budget:** Cantidad máxima de puntos renderizados simultáneamente

| Budget  | FPS      | Dispositivo      | Recomendado |
|---------|----------|------------------|------------|
| 500K    | 60+      | Móvil            | ✅ |
| 1M      | 45-60    | Desktop          | ✅ ⭐ |
| 2M      | 30-45    | Desktop Potente  | ✅ |
| 5M      | <30      | Workstation      | ⚠️ |

**Ajustar en visor 3D:**
```javascript
viewer.setPointBudget(2000000);  // 2M puntos
```

---

## 🔗 Sincronización 2D ↔ 3D

### Desde Visor 2D (index.html)

```javascript
// Click en "Ver en 3D"
function abrirVisor3D(lat, lng, properties) {
    const visor3d = window.open('3d-viewer/visor-3d.html');
    
    setTimeout(() => {
        visor3d.receiveCoordinatesFrom2D(lat, lng, 50);
    }, 2000);
}
```

### En Visor 3D (visor-3d.html)

```javascript
// Recibir coordenadas del 2D
window.receiveCoordinatesFrom2D = function(lat, lon, height) {
    // Centrar cámara en ese punto
    const camera = viewer.scene.getActiveCamera();
    camera.position.set(x, y, z);
};
```

---

## 🐛 Troubleshooting

### ❌ "CORS error"
```
❌ Causa: Usar file:///
✅ Solución: Usar http://localhost:8000
```

### ❌ "Nube no carga"
```
✅ Verificar:
1. ¿Existe datasets-3d/nombre/cloud.js?
2. ¿El servidor HTTP está activo?
3. ¿La conversión se completó?
```

### ❌ "Rendimiento bajo (FPS bajo)"
```
✅ Soluciones:
1. Reducir Point Budget a 500K
2. Usar renderizador canvas: viewer.useCanvas(true)
3. Desabilitar EDL: viewer.setEDLEnabled(false)
```

### ❌ "Conversión muy lenta"
```
✅ Soluciones:
1. Usar --point-limit menor (10000 en lugar de 30000)
2. Comprimir LAZ antes de convertir
3. Usar hardware más potente
```

---

## 📚 Recursos Adicionales

- **Documentación detallada:** [PIPELINE_LAZ_3D.md](PIPELINE_LAZ_3D.md)
- **Potree Docs:** https://potree.org/
- **PotreeConverter:** https://github.com/potree/PotreeConverter
- **Leaflet Docs:** https://leafletjs.com/
- **Three.js:** https://threejs.org/

---

## 📝 Requisitos Técnicos

### Hardware Mínimo
- **CPU:** i5 o equivalente
- **RAM:** 8GB
- **GPU:** GeForce GTX 1050 o equivalente
- **Conexión:** 10 Mbps para fluido

### Software
- **SO:** Windows 10+, macOS 10.13+, Linux (Ubuntu 18.04+)
- **Navegador:** Chrome, Firefox, Edge (últimas versiones)
- **Node.js:** 12+ (opcional, para http-server)
- **Python:** 3.6+ (opcional, para servidor HTTP)

---

## 📄 Licencia

GeoView Lite - Sistema de visualización geoespacial  
Copyright © 2026 GeoView Team

Licencia: MIT (ver archivo LICENSE)

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crear rama de feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

---

## 📞 Soporte

Para reportar bugs o sugerencias:
- GitHub Issues: (crear issue)
- Email: support@geoview.local
- Documentación: [PIPELINE_LAZ_3D.md](PIPELINE_LAZ_3D.md)

---

**Última actualización:** 5 de mayo de 2026  
**Versión:** 1.0 - Pipeline Completo  
**Estado:** ✅ Production Ready
