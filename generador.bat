@echo off
:: Habilitar soporte para caracteres UTF-8
chcp 65001 > nul
setlocal enabledelayedexpansion

:: =========================================
:: DEFINICION DE COLORES ANSI
:: =========================================
set "ESC="
set "C_RESET=%ESC%[0m"
set "C_BOLD=%ESC%[1m"
set "C_RED=%ESC%[91m"
set "C_GREEN=%ESC%[92m"
set "C_YELLOW=%ESC%[93m"
set "C_CYAN=%ESC%[96m"
set "C_WHITE=%ESC%[97m"
set "BG_BLUE=%ESC%[44m"

:: Iconos
set "ICO_OK=✅ "
set "ICO_ERR=❌ "
set "ICO_TOOL=🔧 "

:: =========================================
:: BIENVENIDA Y VERIFICACION
:: =========================================
cls
echo %C_BOLD%%BG_BLUE%%C_WHITE%======================================================%C_RESET%
echo %C_BOLD%%BG_BLUE%%C_WHITE%   🚀 GENERADOR DE PROYECTOS WEB ELITE (FINAL) 🚀    %C_RESET%
echo %C_BOLD%%BG_BLUE%%C_WHITE%======================================================%C_RESET%
echo.

set "HAS_NPM=0"
set "HAS_GIT=0"

echo %C_BOLD%[1/2] Comprobando herramientas...%C_RESET%
call npm --version >nul 2>&1
if !errorlevel! EQU 0 (
    set "HAS_NPM=1"
    echo   !ICO_OK! !C_GREEN!Node/NPM detectado.!C_RESET!
) else (
    echo   !ICO_ERR! !C_RED!NPM no encontrado. Instalacion manual requerida.!C_RESET!
)

call git --version >nul 2>&1
if !errorlevel! EQU 0 (
    set "HAS_GIT=1"
    echo   !ICO_OK! !C_GREEN!Git detectado.!C_RESET!
) else (
    echo   !ICO_ERR! !C_RED!Git no encontrado.!C_RESET!
)
echo.

echo %C_BOLD%[2/2] Validando permisos...%C_RESET%
copy /y nul .wtest >nul 2>&1
if !errorlevel! NEQ 0 (
    echo   !ICO_ERR! !C_RED!ERROR: No tienes permisos de escritura aqui.!C_RESET!
    pause
    exit /b
)
del .wtest >nul 2>&1
echo   !ICO_OK! !C_GREEN!Permisos OK.!C_RESET!
echo.
echo =======================================================
echo.

:: =========================================
:: INPUTS INTERACTIVOS (Seguros, sin simbolos raros)
:: =========================================
:AskName
set /p APP_NAME="%C_WHITE%%C_BOLD%? Nombre del proyecto (ej. mi-app): %C_RESET%"
if "!APP_NAME!"=="" goto AskName
set "APP_NAME=!APP_NAME: =!"

echo.
echo %C_BOLD%? Elige la Arquitectura:%C_RESET%
choice /c RAM /n /m "  [R] React, [A] Angular, [M] Mixta - Elige una letra: "
if !errorlevel! EQU 1 set "ARCH=React"
if !errorlevel! EQU 2 set "ARCH=Angular"
if !errorlevel! EQU 3 set "ARCH=Mixta"
echo  Seleccion: %C_CYAN%!ARCH!%C_RESET%

echo.
echo %C_BOLD%? Elige el Lenguaje:%C_RESET%
choice /c JT /n /m "  [J] JavaScript, [T] TypeScript - Elige una letra: "
if !errorlevel! EQU 1 set "LANG=JS"
if !errorlevel! EQU 2 set "LANG=TS"
echo  Seleccion: %C_CYAN%!LANG!%C_RESET%

set "IS_REACT=0"
set "IS_ANGULAR=0"
set "IS_TS=0"

if "!ARCH!"=="React" set "IS_REACT=1"
if "!ARCH!"=="Mixta" set "IS_REACT=1" & set "IS_ANGULAR=1"
if "!ARCH!"=="Angular" set "IS_ANGULAR=1"
if "!LANG!"=="TS" set "IS_TS=1"

if !IS_TS! EQU 1 (
    set "EXT=ts"
    set "JSX_EXT=tsx"
) else (
    set "EXT=js"
    set "JSX_EXT=jsx"
)

echo.
set "RUN_NPM=N"
if !HAS_NPM! EQU 1 (
    choice /c SN /n /m "%C_WHITE%? Instalar dependencias ahora? (S/N): %C_RESET%"
    if !errorlevel! EQU 1 set "RUN_NPM=S"
)

set "RUN_GIT=N"
if !HAS_GIT! EQU 1 (
    choice /c SN /n /m "%C_WHITE%? Inicializar repositorio Git? (S/N): %C_RESET%"
    if !errorlevel! EQU 1 set "RUN_GIT=S"
)

:: =========================================
:: GENERACION (Aplanada para evitar crasheos)
:: =========================================
cls
echo %C_BOLD%%BG_BLUE%%C_WHITE%======================================================%C_RESET%
echo %C_BOLD%%BG_BLUE%%C_WHITE%🚀   CREANDO PROYECTO: !APP_NAME!   🚀%C_RESET%
echo %C_BOLD%%BG_BLUE%%C_WHITE%======================================================%C_RESET%
echo.

if not exist "!APP_NAME!" mkdir "!APP_NAME!"
cd "!APP_NAME!"

call :ShowStep "1/5" "Carpetas base..."
mkdir src 2>nul
mkdir public 2>nul
mkdir src\styles 2>nul

if !IS_REACT! EQU 1 call :CreateReactFolders
if !IS_ANGULAR! EQU 1 call :CreateAngularFolders

call :ShowStep "2/5" "Archivos de configuracion..."
call :CreateGitignore
call :CreateViteConfig
if !IS_TS! EQU 1 call :CreateTSConfig
call :CreatePackageJson
call :CreateGlobalCSS

call :ShowStep "3/5" "Codigo fuente..."
if !IS_REACT! EQU 1 call :CreateReactFiles
if !IS_ANGULAR! EQU 1 call :CreateAngularFiles

if "!RUN_NPM!"=="S" (
    call :ShowStep "4/5" "Instalando paquetes (npm install)..."
    call npm install >nul 2>&1
    echo   !ICO_OK! !C_GREEN!Instalacion completada.!C_RESET!
) else (
    call :ShowStep "4/5" "Saltando npm install..."
)

if "!RUN_GIT!"=="S" (
    call :ShowStep "5/5" "Inicializando Git..."
    call git init >nul 2>&1
    call git add . >nul 2>&1
    call git commit -m "Commit inicial" >nul 2>&1
    echo   !ICO_OK! !C_GREEN!Git configurado.!C_RESET!
) else (
    call :ShowStep "5/5" "Saltando Git..."
)

:: =========================================
:: FIN DEL SCRIPT
:: =========================================
echo.
echo =======================================================
echo %ICO_OK% %C_BOLD%%C_GREEN%PROYECTO CREADO CON EXITO!%C_RESET%
echo =======================================================
echo Pasos a seguir:
echo   1. cd !APP_NAME!
if "!RUN_NPM!"=="N" echo   2. npm install
echo   3. npm run dev
echo =======================================================
pause
exit /b

:: =====================================================================
:: SUBRUTINAS (100% Seguras)
:: =====================================================================

:ShowStep
echo %C_BOLD%[%~1]%C_RESET% %ICO_TOOL% %~2
exit /b

:CreateReactFolders
mkdir src\components 2>nul
mkdir src\pages 2>nul
exit /b

:CreateAngularFolders
mkdir src\app 2>nul
mkdir src\app\core\services 2>nul
exit /b

:CreateGitignore
echo node_modules/ > .gitignore
echo dist/ >> .gitignore
echo .env >> .gitignore
exit /b

:CreateViteConfig
set "VITE_EXT=js"
if !IS_TS! EQU 1 set "VITE_EXT=ts"

echo import { defineConfig } from 'vite'; > vite.config.!VITE_EXT!
if !IS_REACT! EQU 1 echo import react from '@vitejs/plugin-react'; >> vite.config.!VITE_EXT!
echo. >> vite.config.!VITE_EXT!
echo export default defineConfig({ >> vite.config.!VITE_EXT!
if !IS_REACT! EQU 1 echo   plugins: [react()], >> vite.config.!VITE_EXT!
echo   server: { port: 3000, open: true } >> vite.config.!VITE_EXT!
echo }); >> vite.config.!VITE_EXT!
exit /b

:CreateTSConfig
echo { > tsconfig.json
echo   "compilerOptions": { >> tsconfig.json
echo     "target": "ES2020", >> tsconfig.json
echo     "lib": ["ES2020", "DOM", "DOM.Iterable"], >> tsconfig.json
echo     "module": "ESNext", >> tsconfig.json
echo     "skipLibCheck": true, >> tsconfig.json
echo     "moduleResolution": "bundler", >> tsconfig.json
echo     "noEmit": true, >> tsconfig.json
if !IS_REACT! EQU 1 echo     "jsx": "react-jsx", >> tsconfig.json
echo     "strict": true >> tsconfig.json
echo   }, >> tsconfig.json
echo   "include": ["src"] >> tsconfig.json
echo } >> tsconfig.json
exit /b

:CreatePackageJson
echo { > package.json
echo   "name": "!APP_NAME!", >> package.json
echo   "private": true, >> package.json
echo   "version": "1.0.0", >> package.json
echo   "type": "module", >> package.json
echo   "scripts": { >> package.json
echo     "dev": "vite", >> package.json
echo     "build": "vite build" >> package.json
echo   }, >> package.json
echo   "dependencies": { >> package.json
if !IS_REACT! EQU 1 echo     "react": "^18.2.0", >> package.json
if !IS_REACT! EQU 1 echo     "react-dom": "^18.2.0" >> package.json
if !IS_ANGULAR! EQU 1 if !IS_REACT! EQU 0 echo     "rxjs": "^7.8.1" >> package.json
echo   }, >> package.json
echo   "devDependencies": { >> package.json
echo     "vite": "^5.2.0" >> package.json
if !IS_TS! EQU 1 echo     ,"typescript": "^5.2.2" >> package.json
if !IS_REACT! EQU 1 echo     ,"@vitejs/plugin-react": "^4.2.1" >> package.json
if !IS_REACT! EQU 1 if !IS_TS! EQU 1 echo     ,"@types/react": "^18.2.66", "@types/react-dom": "^18.2.22" >> package.json
echo   } >> package.json
echo } >> package.json
exit /b

:CreateGlobalCSS
echo body { > src\styles\global.css
echo   margin: 0; >> src\styles\global.css
echo   background: #121212; >> src\styles\global.css
echo   color: #ffffff; >> src\styles\global.css
echo   font-family: sans-serif; >> src\styles\global.css
echo } >> src\styles\global.css
exit /b

:CreateReactFiles
echo ^<!DOCTYPE html^> > index.html
echo ^<html lang="es"^> >> index.html
echo   ^<body^> >> index.html
echo     ^<div id="root"^>^</div^> >> index.html
echo     ^<script type="module" src="/src/main.!JSX_EXT!"^>^</script^> >> index.html
echo   ^</body^> >> index.html
echo ^</html^> >> index.html

echo import React from 'react'; > src\main.!JSX_EXT!
echo import ReactDOM from 'react-dom/client'; >> src\main.!JSX_EXT!
echo import App from './components/App'; >> src\main.!JSX_EXT!
echo import './styles/global.css'; >> src\main.!JSX_EXT!
echo ReactDOM.createRoot(document.getElementById('root')).render( >> src\main.!JSX_EXT!
echo   ^<React.StrictMode^>^<App /^>^</React.StrictMode^> >> src\main.!JSX_EXT!
echo ); >> src\main.!JSX_EXT!

echo import React from 'react'; > src\components\App.!JSX_EXT!
echo export default function App() { >> src\components\App.!JSX_EXT!
echo   return ^<h1^>!APP_NAME! - React Listo!^</h1^>; >> src\components\App.!JSX_EXT!
echo } >> src\components\App.!JSX_EXT!
exit /b

:CreateAngularFiles
if !IS_REACT! EQU 0 (
    echo ^<!DOCTYPE html^> > index.html
    echo ^<html lang="es"^> >> index.html
    echo   ^<body^> >> index.html
    echo     ^<app-root^>^<h1^>!APP_NAME! - Angular Base^</h1^>^</app-root^> >> index.html
    echo     ^<script type="module" src="/src/main.!EXT!"^>^</script^> >> index.html
    echo   ^</body^> >> index.html
    echo ^</html^> >> index.html
)
echo console.log('Iniciando Angular...'); > src\main.!EXT!
echo export class AppService {} > src\app\core\services\app.service.!EXT!
exit /b