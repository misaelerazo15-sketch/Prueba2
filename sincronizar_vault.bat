@echo off
setlocal

REM ===== RUTAS =====
set "VAULT_ROOT=C:\Users\Lenovo\Documents\INTER 2025\INTERNADADO"
set "LOS150=%VAULT_ROOT%\NÚCLEO ESCATOLÓGICO\LOS 150"
set "ATTACH=%LOS150%\Attachments"
set "CONTENT=C:\Users\Lenovo\prueba2\content"

echo ============================================
echo  1) Moviendo imagenes sueltas de la raiz del vault
echo     hacia LOS 150\Attachments
echo ============================================

if not exist "%ATTACH%" mkdir "%ATTACH%"

REM Mueve imagenes que esten SUELTAS directamente en la raiz de INTERNADADO
REM (no toca subcarpetas, solo lo que esta al nivel raiz)
for %%E in (png jpg jpeg gif webp) do (
    for %%F in ("%VAULT_ROOT%\*.%%E") do (
        echo Moviendo: %%~nxF
        move /Y "%%F" "%ATTACH%\" >nul
    )
)

echo.
echo ============================================
echo  2) Sincronizando LOS 150 completo hacia content
echo ============================================

robocopy "%LOS150%" "%CONTENT%" /MIR /XD .obsidian /XF .DS_Store

echo.
echo ============================================
echo  Listo. Revisa la carpeta content y las imagenes.
echo ============================================
pause
