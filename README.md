# 🚀 Generador de Proyectos Web Élite

Un potente script interactivo en Batch (`.bat`) para Windows que inicializa al instante arquitecturas web modernas y escalables. Olvídate de crear carpetas a mano o configurar Vite desde cero; este script hace todo el trabajo pesado por ti con una interfaz de terminal amigable y a prueba de errores.

✨ Características Principales

* **🖥️ UI/UX en Terminal:** Menús interactivos y limpios. Olvídate de escribir; simplemente presiona la tecla de tu elección (R/A/M).
* **⚡ Vite por Defecto:** Todos los proyectos se configuran automáticamente con Vite para un entorno de desarrollo ultrarrápido (HMR).
* **⚛️ Multi-Arquitectura:** Soporte nativo para generar bases de **React**, **Angular** o una estructura **Mixta**.
* **📘 Soporte TypeScript:** Elige entre JavaScript tradicional o TypeScript (genera tu `tsconfig.json` listo para Vite).
* **📦 Automatización Total:** Detecta si tienes Node.js y Git instalados para ejecutar automáticamente `npm install`, inicializar el repositorio y hacer el primer commit.
* **🛡️ A Prueba de Fallos:** Validación de permisos de escritura de Windows y generación de archivos JSON dinámicos 100% seguros.

---

## 📋 Requisitos Previos

Para sacarle el máximo provecho a este script, se recomienda tener instalado en tu sistema:

- **Sistema Operativo:** Windows 10 u 11 (requiere entorno Batch).
- **Node.js y NPM:** Para la instalación automática de dependencias (Recomendado v18+).
- **Git:** Para la inicialización automática del repositorio.

*(Nota: Si no tienes Git o NPM, el script lo detectará de forma inteligente y omitirá esos pasos sin fallar).*

---

## 🚀 Cómo Usarlo

1. **Descarga el script:** Descarga el archivo `generador.bat` de este repositorio.
2. **Ubícalo:** Mueve el archivo a la carpeta raíz donde sueles guardar tus proyectos (ej. `C:\Users\TuUsuario\Documentos\Proyectos`).
3. **Ejecútalo:** Haz doble clic sobre `generador.bat` (o ejecútalo desde tu terminal).
4. **Sigue el asistente:** - Escribe el nombre de tu proyecto.
   - Elige la arquitectura (React, Angular, Mixta).
   - Elige el lenguaje (JS o TS).
   - Confirma si deseas instalar paquetes y configurar Git.
5. **¡A programar!**
   ```bash
   cd nombre-de-tu-proyecto
   npm run dev
