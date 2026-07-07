@chcp 65001 >nul
@echo off
setlocal enabledelayedexpansion

REM ===== RUTAS =====
set "VAULT_ROOT=C:\Users\Lenovo\Documents\INTER 2025\INTERNADADO"
set "LOS150=%VAULT_ROOT%\NÚCLEO ESCATOLÓGICO\LOS 150"
set "ATTACH=%LOS150%\Attachments"
set "CONTENT=C:\Users\Lenovo\prueba2\content"

echo ============================================
echo  Verificando que LOS 150 existe...
echo ============================================
if not exist "%LOS150%" (
    echo ERROR: No se encontro la carpeta:
    echo %LOS150%
    echo Revisa tildes/mayusculas y NO sigas con el script.
    pause
    exit /b 1
)
echo OK: carpeta encontrada.
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
echo  2) Sincronizando LOS 150 completo hacia content
echo ============================================

robocopy "%LOS150%" "%CONTENT%" /MIR /XD .obsidian /XF .DS_Store

echo.
echo ============================================
echo  Listo. Revisa la carpeta content y las imagenes
echo  ANTES de hacer git add/commit/push.
echo ============================================
pause
