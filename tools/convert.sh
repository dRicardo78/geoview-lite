#!/bin/bash

# ==============================
# Script de conversion LAZ -> Potree
# Uso: ./convert.sh archivo.laz [dataset-name]
# ==============================

# Verificar argumentos
if [ -z "$1" ]; then
    echo "Uso: ./convert.sh archivo.laz [nombre-dataset]"
    echo ""
    echo "Ejemplo:"
    echo "  ./convert.sh /path/to/cloud.laz mi-nube-01"
    echo ""
    exit 1
fi

# Configuración
LAZ_FILE="$1"
DATASET_NAME="${2:-$(basename "$1" .laz)}"
OUTPUT_DIR="../datasets-3d/$DATASET_NAME"
POTREE_CONVERTER="./PotreeConverter_linux_x64_2.0.0/PotreeConverter"

echo ""
echo "=============================="
echo "Converter LAZ a Potree"
echo "=============================="
echo ""
echo "Archivo:     $LAZ_FILE"
echo "Dataset:     $DATASET_NAME"
echo "Salida:      $OUTPUT_DIR"
echo ""

# Verificar que el archivo existe
if [ ! -f "$LAZ_FILE" ]; then
    echo "Error: Archivo no encontrado: $LAZ_FILE"
    exit 1
fi

# Verificar que PotreeConverter existe
if [ ! -f "$POTREE_CONVERTER" ]; then
    echo "Error: PotreeConverter no encontrado en:"
    echo "$POTREE_CONVERTER"
    echo ""
    echo "Descargar desde: https://github.com/potree/PotreeConverter/releases"
    exit 1
fi

echo "Iniciando conversion..."
echo ""

# Ejecutar conversion con optimizaciones
"$POTREE_CONVERTER" "$LAZ_FILE" \
    -o "$OUTPUT_DIR" \
    --point-limit 30000 \
    -c

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Conversion completada exitosamente"
    echo ""
    echo "Salida en: $OUTPUT_DIR"
    echo ""
    echo "Archivos generados:"
    echo "  - cloud.js (descriptor)"
    echo "  - cloud.json (metadata)"
    echo "  - octree/ (estructura jerarchica)"
    echo ""
else
    echo ""
    echo "X Error durante la conversion"
    exit 1
fi

echo "✓ Proceso completado"
echo ""
