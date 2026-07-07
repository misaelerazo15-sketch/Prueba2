@echo off
setlocal enabledelayedexpansion

REM ===== RUTAS BASE (sin tildes para evitar problemas de codificacion) =====
set "VAULT_ROOT=C:\Users\Lenovo\Documents\INTER 2025\INTERNADADO"
set "CONTENT=C:\Users\Lenovo\prueba2\content"

echo ============================================
echo  Buscando carpetas candidatas...
echo ============================================

set "COUNT=0"
set "NUCLEO="
set "NUCLEO_NAME="
for /d %%D in ("%VAULT_ROOT%\N*ESCATOL*") do (
    set /a COUNT+=1
    set "NUCLEO=%%D"
    set "NUCLEO_NAME=%%~nxD"
    echo Encontrada candidata !COUNT!: %%D
)

if !COUNT! EQU 0 (
    echo ERROR: No se encontro ninguna carpeta candidata.
    echo NO se hizo ningun cambio.
    pause
    exit /b 1
)

if !COUNT! GTR 1 (
    echo.
    echo ATENCION: se encontraron !COUNT! carpetas parecidas.
    echo Borra o renombra las que sobran y volve a correr el script.
    echo NO se hizo ningun cambio.
    pause
    exit /b 1
)

echo.
echo Usando: %NUCLEO%
set "LOS150=%NUCLEO%\LOS 150"

if not exist "%LOS150%" (
    echo ERROR: No se encontro la carpeta LOS 150 dentro de:
    echo %NUCLEO%
    echo NO se hizo ningun cambio.
    pause
    exit /b 1
)

echo Encontrada: %LOS150%
set "ATTACH=%LOS150%\Attachments"

echo.
echo ============================================
echo  1) Moviendo imagenes sueltas de la raiz del vault
echo     hacia LOS 150\Attachments
echo ============================================

if not exist "%ATTACH%" mkdir "%ATTACH%"

for %%E in (png jpg jpeg gif webp) do (
    for %%F in ("%VAULT_ROOT%\*.%%E") do (
        echo Moviendo: %%~nxF
        move /Y "%%F" "%ATTACH%\" >nul
    )
)

echo.
echo ============================================
echo  2) Limpiando restos sueltos en la raiz de content
echo     (de la sincronizacion plana anterior)
echo ============================================

for /d %%X in ("%LOS150%\*") do (
    if exist "%CONTENT%\%%~nxX" (
        echo Borrando resto: %%~nxX
        rd /s /q "%CONTENT%\%%~nxX"
    )
)
for %%X in ("%LOS150%\*.*") do (
    if exist "%CONTENT%\%%~nxX" (
        echo Borrando resto: %%~nxX
        del /q "%CONTENT%\%%~nxX"
    )
)

echo.
echo ============================================
echo  3) Sincronizando hacia content\%NUCLEO_NAME%\LOS 150
echo ============================================

set "DEST=%CONTENT%\%NUCLEO_NAME%\LOS 150"
if not exist "%DEST%" mkdir "%DEST%"

robocopy "%LOS150%" "%DEST%" /MIR /XD .obsidian /XF .DS_Store

echo.
echo ============================================
echo  Listo. Revisa la carpeta content y las imagenes
echo  ANTES de hacer git add/commit/push.
echo ============================================
pause
