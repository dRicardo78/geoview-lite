# 🔄 Pipeline LAZ → Visor 3D
## Documentación Completa del Sistema

---

## 📋 Contenido
1. [Requisitos](#requisitos)
2. [Arquitectura del Sistema](#arquitectura)
3. [FASES 1-8](#fases)
4. [Instalación](#instalación)
5. [Conversión LAZ → Potree](#conversión)
6. [Servidor HTTP](#servidor)
7. [Estructura de Carpetas](#estructura)
8. [Troubleshooting](#troubleshooting)

---

## <a name="requisitos"></a>📦 Requisitos

### Software Necesario
- **Node.js** 12+ o **Python** 3.7+ (para PotreeConverter)
- **PotreeConverter** (herramienta de conversión)
- **Servidor HTTP** (Live Server, Python, etc.)
- **Navegador moderno** (Chrome, Firefox, Edge)

### Archivos de Datos
- Archivos `.laz` o `.las` (LiDAR data)
- Mínimo 1M puntos, máximo 500M puntos

---

## <a name="arquitectura"></a>🏗️ Arquitectura del Sistema

```
GeoView (Sistema completo)
│
├── VISOR 2D (Leaflet)
│   ├── index.html
│   ├── css/
│   ├── data/ (GeoJSON, predios)
│   └── Soporta: KML, GeoJSON
│
├── VISOR 3D (Potree)
│   ├── 3d-viewer/
│   │   └── visor-3d.html
│   └── Soporta: Nubes convertidas
│
├── DATASETS 3D (Datos convertidos)
│   └── datasets-3d/
│       ├── dataset-1/
│       │   ├── cloud.js
│       │   ├── metadata.json
│       │   └── octree/ (niveles de detalle)
│       └── dataset-2/
│
├── TOOLS (Scripts de utilidad)
│   ├── PotreeConverter (descargado)
│   └── Scripts batch/shell
│
└── SERVIDOR HTTP
    └── Ejecutado en localhost:8000/8080/5500
```

---

## <a name="fases"></a>🎯 FASES 1-8

### ✅ FASE 0: Separación de Arquitectura
**Estado:** COMPLETADO
- ✅ Visor 2D independiente (index.html)
- ✅ Visor 3D separado (visor-3d.html)
- ✅ Carpeta datasets-3d creada
- ✅ Carpeta tools creada

### ✅ FASE 1: Entrada de Datos (.LAZ)
**Objetivo:** Definir formato de entrada

**Puntos clave:**
- ❌ NO renderizar .laz directamente
- ✅ Archivos .laz → conversión previa
- ✅ Salida esperada: estructura Potree

**Formatos soportados:**
- `.laz` (LiDAR comprimido)
- `.las` (LiDAR sin comprimir)
- `.e57` (Escáner 3D)
- `.ply` (Point clouds genéricas)

---

### ✅ FASE 2: Conversión LAZ → Potree
**Herramienta:** PotreeConverter

#### Instalación de PotreeConverter

**Opción A: Descarga precompilada**
```bash
# Descargar desde GitHub
https://github.com/potree/PotreeConverter/releases

# Extraer en: tools/PotreeConverter
```

**Opción B: Compilar desde fuente**
```bash
# Clonar repositorio
git clone https://github.com/potree/PotreeConverter.git
cd PotreeConverter
mkdir build && cd build
cmake ..
make
```

#### Uso Básico

**Línea de comando:**
```bash
PotreeConverter.exe archivo.laz -o dataset-salida -c
```

**Parámetros importantes:**
```
-o              : Carpeta de salida
-c              : Crear carpeta si no existe
--point-limit   : Máximo puntos por octante (default: 50000)
--cubic-meter   : Clasificación por volumen
--color-range   : Rango de colores (RGB)
--recursive     : Procesar carpetas recursivamente
```

#### Ejemplo completo:

```bash
# Conversión básica
PotreeConverter.exe cloud.laz -o datasets-3d/cloud-converted -c

# Conversión optimizada (Point Budget 2M)
PotreeConverter.exe cloud.laz \
  -o datasets-3d/cloud-optimized \
  --point-limit 30000 \
  --cubic-meter \
  -c

# Batch: convertir múltiples archivos
for file in *.laz; do
  PotreeConverter.exe "$file" -o "datasets-3d/${file%.laz}" -c
done
```

#### Estructura de salida:

```
dataset-salida/
├── cloud.js               # Loader Potree
├── cloud.json            # Metadata
├── octree/
│   ├── r/               # Root (nivel 0)
│   │   ├── 0
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   └── hierarchy.bin  # Estructura jerárquica
│   ├── r/0/
│   │   ├── 0
│   │   ├── 1
│   │   ├── 2
│   │   ├── 3
│   │   └── hierarchy.bin
│   └── ... (niveles de detalle)
└── metadata/
    ├── bounds.json
    └── statistics.json
```

**⚠️ Archivos críticos:**
- `cloud.js`: Descriptor de carga
- `metadata.json`: Información de la nube
- `octree/`: Estructura jerárquica (LoD)

---

### ✅ FASE 3: Infraestructura de Carga (Servidor)
**Requisito:** Servidor HTTP activo

#### Por qué se necesita servidor:

❌ **NO funciona:** `file:///` (limitaciones CORS)
✅ **FUNCIONA:** `http://localhost:8000/`

#### Opción A: Live Server (VS Code)

1. Instalar extensión "Live Server"
2. Botón derecho en `index.html` → "Open with Live Server"
3. Acceder a: `http://localhost:5500`

#### Opción B: Python

```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# Acceder: http://localhost:8000
```

#### Opción C: Node.js (http-server)

```bash
npm install -g http-server
http-server -p 8000 -c-1

# Acceder: http://localhost:8000
```

#### Opción D: Nginx (producción)

```nginx
server {
    listen 80;
    server_name localhost;
    root /path/to/geoview-lite;
    
    location /datasets-3d/ {
        add_header 'Access-Control-Allow-Origin' '*';
        try_files $uri $uri/ =404;
    }
}
```

---

### ✅ FASE 4: Renderizado 3D (Motor Visual)
**Tecnología:** Potree 1.8+

#### Point Budget (Presupuesto de Puntos)

**Concepto clave:** No renderizar todos los puntos, solo los visibles

**Configuración:**

```javascript
// Rango recomendado
viewer.setPointBudget(1000000);   // 1M puntos (por defecto)
viewer.setPointBudget(2000000);   // 2M puntos (alto rendimiento)
viewer.setPointBudget(500000);    // 500K puntos (bajo rendimiento)
```

**Implicaciones:**

| Presupuesto | Rendimiento | Calidad | Dispositivo |
|-------------|-------------|---------|------------|
| 500K        | 60+ FPS     | Normal  | Móvil |
| 1M          | 45-60 FPS   | Buena   | Desktop |
| 2M          | 30-45 FPS   | Muy Buena | Desktop potente |
| 5M+         | <30 FPS     | Excelente | Workstation |

#### Modos de visualización:

```javascript
// RGB (color natural)
pointCloud.material.pointColorType = Potree.PointColorType.RGB;

// Altura (gradiente)
pointCloud.material.pointColorType = Potree.PointColorType.HEIGHT;

// Intensidad (reflectancia)
pointCloud.material.pointColorType = Potree.PointColorType.INTENSITY;

// Clasificación LiDAR
pointCloud.material.pointColorType = Potree.PointColorType.CLASSIFICATION;
```

#### Nivel de Detalle (LoD):

Potree maneja automáticamente:
- **Cercano:** Todos los puntos
- **Medio:** Submuestreo 50%
- **Lejano:** Submuestreo 90%

No requiere configuración manual.

---

### ✅ FASE 5: Interacción del Usuario
**Controles implementados:**

| Acción | Control |
|--------|---------|
| Rotación | Click derecho + arrastrar |
| Zoom | Rueda del ratón |
| Desplazamiento | Click central + arrastrar |
| Fit Screen | Botón "Resetear Vista" |

#### Panel de Control:

- **Dataset Selector:** Cambiar nube de puntos
- **Point Budget:** Ajustar cantidad de puntos visibles
- **Field of View:** Zoom angular (20-100°)
- **Render Mode:** Visualización (RGB, Altura, etc.)
- **Reset Button:** Restaurar vista inicial

---

### ✅ FASE 6: Sincronización 2D ↔ 3D

#### Flujo de datos:

```
Visor 2D (Leaflet)
  │
  ├─ Click en predio
  │
  └─ Extrae: [lat, lon]
      │
      └─ Envía a Visor 3D
          │
          └─ Recibe en: receiveCoordinatesFrom2D()
              │
              └─ Centra cámara
                  │
                  └─ Visualiza en 3D
```

#### Implementación:

**Desde Visor 2D (index.html):**
```javascript
// Abrir visor 3D
function openVisor3D(lat, lon) {
    const url = 'file:///.../3d-viewer/visor-3d.html';
    const window3d = window.open(url, 'Visor3D');
    
    // Esperar a que se cargue
    setTimeout(() => {
        window3d.receiveCoordinatesFrom2D(lat, lon);
    }, 2000);
}
```

**Desde Visor 3D (visor-3d.html):**
```javascript
// Recibir coordenadas del 2D
window.receiveCoordinatesFrom2D = function(lat, lon, height = null) {
    // Centrar cámara en punto
    const camera = viewer.scene.getActiveCamera();
    camera.position.set(x, y, z);
};
```

---

### ✅ FASE 7: Gestión de Datasets

#### Estructura de configuración:

**Archivo: `datasets-3d/index.json`**

```json
{
  "datasets": [
    {
      "id": "dataset-001",
      "name": "Nube 1 - Campus",
      "description": "Escaneo LiDAR del campus",
      "path": "dataset-001/cloud.js",
      "metadata": {
        "points": 150000000,
        "bounds": {
          "min": {"x": 0, "y": 0, "z": 0},
          "max": {"x": 1000, "y": 500, "z": 200}
        },
        "conversion_date": "2024-01-15",
        "point_budget": 2000000
      }
    },
    {
      "id": "dataset-002",
      "name": "Nube 2 - Terreno",
      "description": "Modelo digital del terreno",
      "path": "dataset-002/cloud.js",
      "metadata": {
        "points": 75000000,
        "bounds": {...},
        "conversion_date": "2024-01-20",
        "point_budget": 1000000
      }
    }
  ]
}
```

#### Acceso a datasets:

```javascript
// Cargar índice
fetch('datasets-3d/index.json')
  .then(r => r.json())
  .then(data => {
    console.log('Datasets disponibles:', data.datasets);
  });

// Acceso a un dataset específico
const dataset = datasets[0];
const cloudUrl = `datasets-3d/${dataset.path}`;
Potree.POCLoader.load(cloudUrl, function(event) {
    // Cargar...
}).then(function(geometry) {
    // Mostrar...
});
```

---

### ✅ FASE 8: Flujo Completo

#### Secuencia de usuario:

```
1. Usuario abre Visor 2D (index.html)
   ↓
2. Ve mapa con predios
   ↓
3. Click en botón "Ver en 3D" para un predio
   ↓
4. Se abre Visor 3D (visor-3d.html)
   ↓
5. Selector de dataset muestra nubes disponibles
   ↓
6. Usuario selecciona nube → Se carga en Potree
   ↓
7. Interactúa (rotación, zoom, etc.)
   ↓
8. (Opcional) Sincronización con mapa 2D
   ↓
9. Cambio de dataset → Recarga automática
```

#### Diagrama de contexto:

```
┌─────────────────────────────────────────┐
│         SERVIDOR HTTP (8000)            │
│  http://localhost:8000/geoview-lite/    │
└─────────────────────────────────────────┘
          │                    │
    ┌─────▼──────┐      ┌──────▼──────┐
    │ index.html │      │visor-3d.html│
    │(Leaflet)   │      │(Potree)     │
    └─────┬──────┘      └──────┬──────┘
          │                    │
    ┌─────▼────────────────────▼──────┐
    │    DATASETS-3D (archivos estát) │
    │  dataset-1/, dataset-2/, ...    │
    └────────────────────────────────┘
          │
    ┌─────▼──────────────────┐
    │  LOCALSTORAGE / CONFIG │
    │  (persistencia local)  │
    └──────────────────────┘
```

---

## <a name="instalación"></a>🚀 Instalación Completa

### Paso 1: Descargar PotreeConverter

```bash
# Opción: descargar zip desde GitHub
https://github.com/potree/PotreeConverter/releases

# Extraer en proyecto
mkdir -p tools
unzip PotreeConverter_windows_x64_2.0.0.zip -d tools/
```

### Paso 2: Convertir archivo LAZ

```bash
cd tools/PotreeConverter_2.0.0_windows/
PotreeConverter.exe C:\ruta\al\archivo.laz -o ../../datasets-3d/mi-nube -c
```

### Paso 3: Iniciar servidor HTTP

```bash
# Desde la carpeta del proyecto
python -m http.server 8000

# O usar Live Server (VS Code)
```

### Paso 4: Acceder

```
http://localhost:8000/index.html      # Visor 2D
http://localhost:8000/3d-viewer/visor-3d.html  # Visor 3D
```

---

## <a name="estructura"></a>📁 Estructura de Carpetas

```
geoview-lite/
├── index.html                 # Visor 2D (Leaflet)
├── css/
│   └── styles.css
├── data/
│   ├── predio.geojson        # Predios 2D
│   └── predio_test.kml
├── js/
│   └── (scripts auxiliares)
├── 3d-viewer/
│   └── visor-3d.html         # Visor 3D (Potree)
├── datasets-3d/              # ⭐ CRÍTICO
│   ├── dataset-001/
│   │   ├── cloud.js          # Descriptor
│   │   ├── cloud.json        # Metadata
│   │   ├── octree/           # Estructura LoD
│   │   │   ├── r/
│   │   │   ├── r/0/
│   │   │   └── ...
│   │   └── metadata/
│   └── dataset-002/
│       └── (igual estructura)
├── tools/
│   ├── PotreeConverter/      # Herramienta de conversión
│   └── scripts/
│       ├── convert.bat       # Script batch
│       └── convert.sh        # Script bash
├── README.md                 # Este archivo
└── PIPELINE.md               # Documentación adicional
```

---

## <a name="troubleshooting"></a>🔧 Solución de Problemas

### ❌ Problema: "CORS error al cargar nube"

**Solución:**
```
❌ Usar: file:///path/to/index.html
✅ Usar: http://localhost:8000/index.html
```

### ❌ Problema: "Nube no carga / blank screen"

**Verificar:**
1. ¿Existe `datasets-3d/dataset-name/cloud.js`?
2. ¿El servidor HTTP está activo?
3. ¿La conversión se completó correctamente?

```bash
# Validar estructura
ls -la datasets-3d/mi-nube/
# Debe mostrar: cloud.js, cloud.json, octree/
```

### ❌ Problema: "Rendimiento bajo (FPS bajo)"

**Soluciones:**
```javascript
// Reducir Point Budget
viewer.setPointBudget(500000);  // 500K en lugar de 1M

// Reducir FOV
camera.fov = 30;
camera.updateProjectionMatrix();

// Desabilitar EDL (if not needed)
viewer.setEDLEnabled(false);
```

### ❌ Problema: "Conversión LAZ muy lenta"

**Optimizaciones:**
```bash
# Reducir puntos antes de conversión (si es posible)
PotreeConverter.exe file.laz -o output --point-limit 10000 -c

# O comprimir archivo original
```

### ❌ Problema: "Memory overflow al cargar nube grande"

**Soluciones:**
1. Reducir Point Budget a 500K
2. Usar conversión con `--cubic-meter`
3. Dividir nube en múltiples sub-datasets

---

## 📚 Referencias

- **Potree Documentación:** https://potree.org/
- **PotreeConverter GitHub:** https://github.com/potree/PotreeConverter
- **LiDAR Format Spec:** https://www.asprs.org/standards/lidar/
- **Three.js Docs:** https://threejs.org/docs/

---

**Última actualización:** Mayo 2026
**Versión:** 1.0 (Pipeline Completo)
