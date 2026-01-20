---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Project Structure & Dependencies

## Objective
Crear la estructura básica del proyecto Python con todas las dependencias necesarias para el traductor de voz, incluyendo configuración de entorno y documentación inicial.

## Context
- SPEC.md — Requirements y constraints del proyecto
- .gsd/phases/1/RESEARCH.md — Decisiones sobre sounddevice y stack tecnológico

## Tasks

<task type="auto">
  <name>Crear estructura de directorios del proyecto</name>
  <files>
    src/
    src/audio/
    src/translator/
    tests/
  </files>
  <action>
    Crear la estructura de directorios:
    - src/ — Código fuente principal
    - src/audio/ — Módulos de captura y reproducción de audio
    - src/translator/ — Módulos de traducción (para phases futuras)
    - tests/ — Tests unitarios
    
    NO crear archivos .py todavía, solo la estructura de carpetas.
  </action>
  <verify>dir src /s /b (Windows) o ls -R src (Unix)</verify>
  <done>Directorios src/, src/audio/, src/translator/, tests/ existen</done>
</task>

<task type="auto">
  <name>Crear requirements.txt con dependencias</name>
  <files>requirements.txt</files>
  <action>
    Crear requirements.txt con las siguientes dependencias:
    
    ```
    # Audio I/O
    sounddevice>=0.4.6
    numpy>=1.24.0
    
    # Speech Recognition (Phase 2)
    openai-whisper>=20231117
    
    # Translation (Phase 3)
    googletrans==4.0.0rc1
    
    # Text-to-Speech (Phase 3)
    pyttsx3>=2.90
    ```
    
    IMPORTANTE: Usar versiones específicas para evitar breaking changes.
    Incluir comentarios para organizar por funcionalidad.
  </action>
  <verify>type requirements.txt (Windows) o cat requirements.txt (Unix)</verify>
  <done>requirements.txt existe con todas las dependencias listadas y comentadas</done>
</task>

<task type="auto">
  <name>Crear README.md con instrucciones de setup</name>
  <files>README.md</files>
  <action>
    Crear README.md con las siguientes secciones:
    
    1. **Título y descripción**: Traductor de Voz ES→PT en Tiempo Real
    2. **Requisitos previos**:
       - Python 3.8+
       - VB-Audio Virtual Cable (link de descarga: https://vb-audio.com/Cable/)
    3. **Instalación**:
       - Pasos para instalar VB-Cable (descargar, ejecutar instalador, reiniciar)
       - Crear virtual environment: `python -m venv venv`
       - Activar venv: `venv\Scripts\activate` (Windows) o `source venv/bin/activate` (Unix)
       - Instalar dependencias: `pip install -r requirements.txt`
    4. **Configuración de VB-Cable**:
       - Verificar que "CABLE Input" y "CABLE Output" aparecen en dispositivos de audio
       - En Discord/juego: seleccionar "CABLE Output" como micrófono
    5. **Uso** (placeholder para Phase 4):
       - `python src/main.py` (a implementar)
    6. **Troubleshooting**:
       - Si VB-Cable no aparece: reiniciar PC
       - Si sounddevice no instala: verificar Python version
    
    Usar lenguaje claro y directo. El usuario no es técnico avanzado.
  </action>
  <verify>type README.md (Windows) o cat README.md (Unix)</verify>
  <done>README.md existe con todas las secciones de setup y configuración de VB-Cable</done>
</task>

## Success Criteria
- [ ] Estructura de directorios creada (src/, src/audio/, src/translator/, tests/)
- [ ] requirements.txt con todas las dependencias necesarias
- [ ] README.md con instrucciones claras de instalación de VB-Cable y setup del proyecto
- [ ] Proyecto listo para comenzar implementación de audio pipeline
