@echo off
REM ==============================
REM Script de conversion LAZ -> Potree
REM Uso: convert.bat archivo.laz [dataset-name]
REM ==============================

setlocal enabledelayedexpansion

REM Verificar argumentos
if "%~1"=="" (
    echo.
    echo Uso: convert.bat archivo.laz [nombre-dataset]
    echo.
    echo Ejemplo:
    echo   convert.bat C:\data\cloud.laz mi-nube-01
    echo.
    pause
    exit /b 1
)

REM Configuracion
set LAZ_FILE=%~1
set DATASET_NAME=%~2
if "!DATASET_NAME!"=="" (
    REM Usar nombre del archivo sin extension
    set DATASET_NAME=%~n1
)

set OUTPUT_DIR=..\datasets-3d\!DATASET_NAME!
set POTREE_CONVERTER=PotreeConverter_windows_x64_2.0.0\PotreeConverter.exe

echo.
echo ==============================
echo Converter LAZ a Potree
echo ==============================
echo.
echo Archivo:     !LAZ_FILE!
echo Dataset:     !DATASET_NAME!
echo Salida:      !OUTPUT_DIR!
echo.

REM Verificar que el archivo existe
if not exist "!LAZ_FILE!" (
    echo Error: Archivo no encontrado: !LAZ_FILE!
    pause
    exit /b 1
)

REM Verificar que PotreeConverter existe
if not exist "!POTREE_CONVERTER!" (
    echo Error: PotreeConverter no encontrado en:
    echo !POTREE_CONVERTER!
    echo.
    echo Descargar desde: https://github.com/potree/PotreeConverter/releases
    pause
    exit /b 1
)

echo Iniciando conversion...
echo.

REM Ejecutar conversion con optimizaciones
"!POTREE_CONVERTER!" "!LAZ_FILE!" ^
    -o "!OUTPUT_DIR!" ^
    --point-limit 30000 ^
    -c

echo.
if %ERRORLEVEL% equ 0 (
    echo ✓ Conversion completada exitosamente
    echo.
    echo Salida en: !OUTPUT_DIR!
    echo.
    echo Archivos generados:
    echo   - cloud.js (descriptor)
    echo   - cloud.json (metadata)
    echo   - octree/ (estructura jerarchica)
    echo.
) else (
    echo X Error durante la conversion
    pause
    exit /b 1
)

REM Actualizar indice de datasets
echo.
echo Actualizando indice de datasets...
REM (Aqui se ejecutaria un script para actualizar datasets-3d/index.json)

echo.
echo ✓ Conversion completada
echo.
pause
