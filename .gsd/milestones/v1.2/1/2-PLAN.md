---
phase: 1
plan: 2
wave: 1
---

# Plan 1.2: Audio Device Discovery & Listing

## Objective
Implementar un script de utilidad que liste todos los dispositivos de audio disponibles en el sistema, permitiendo al usuario identificar su micrófono y VB-Cable para configuración posterior.

## Context
- SPEC.md — Requirement: "Configuración de dispositivos de audio" (nice-to-have)
- .gsd/phases/1/RESEARCH.md — sounddevice.query_devices() para listar dispositivos
- requirements.txt — sounddevice ya incluido

## Tasks

<task type="auto">
  <name>Crear módulo de utilidades de audio</name>
  <files>src/audio/utils.py</files>
  <action>
    Crear src/audio/utils.py con las siguientes funciones:
    
    1. `list_audio_devices()`:
       - Usar sounddevice.query_devices() para obtener todos los dispositivos
       - Retornar lista de dispositivos con índice, nombre, y tipo (input/output)
       - Incluir información de sample rate y channels
    
    2. `find_device_by_name(name_pattern: str, device_type: str = 'output')`:
       - Buscar dispositivo que contenga name_pattern en su nombre
       - device_type puede ser 'input' o 'output'
       - Retornar índice del dispositivo o None si no se encuentra
       - Útil para encontrar "CABLE Input" automáticamente
    
    3. `get_default_devices()`:
       - Retornar dispositivos de entrada y salida por defecto del sistema
       - Usar sounddevice.default.device
    
    IMPORTANTE:
    - Manejar excepciones si sounddevice no puede acceder a dispositivos
    - Incluir docstrings claros en cada función
    - NO usar print(), retornar datos estructurados
  </action>
  <verify>python -c "from src.audio.utils import list_audio_devices; print(list_audio_devices())"</verify>
  <done>src/audio/utils.py existe con las 3 funciones implementadas y documentadas</done>
</task>

<task type="auto">
  <name>Crear script de prueba de dispositivos</name>
  <files>src/list_devices.py</files>
  <action>
    Crear src/list_devices.py como script ejecutable que:
    
    1. Importa list_audio_devices, find_device_by_name, get_default_devices de audio.utils
    2. Muestra en consola:
       - Título: "=== Dispositivos de Audio Disponibles ==="
       - Lista todos los dispositivos con formato legible:
         ```
         [0] Micrófono (Realtek Audio) - Input - 2 channels @ 48000 Hz
         [1] Speakers (Realtek Audio) - Output - 2 channels @ 48000 Hz
         [2] CABLE Input (VB-Audio Cable) - Output - 2 channels @ 48000 Hz
         [3] CABLE Output (VB-Audio Cable) - Input - 2 channels @ 48000 Hz
         ```
       - Dispositivos por defecto del sistema
       - Búsqueda automática de VB-Cable:
         - Si encuentra "CABLE Input": mostrar "✓ VB-Cable detectado en índice X"
         - Si NO encuentra: mostrar "⚠ VB-Cable no detectado. Instalar desde https://vb-audio.com/Cable/"
    
    3. Manejar errores gracefully:
       - Si no hay dispositivos: mensaje claro
       - Si sounddevice falla: sugerir reinstalar o verificar drivers
    
    IMPORTANTE: Este script será usado por el usuario para verificar su setup.
  </action>
  <verify>python src/list_devices.py</verify>
  <done>src/list_devices.py ejecuta correctamente y muestra todos los dispositivos de audio formateados</done>
</task>

<task type="auto">
  <name>Crear __init__.py para módulo audio</name>
  <files>src/audio/__init__.py</files>
  <action>
    Crear src/audio/__init__.py para hacer audio un paquete Python:
    
    ```python
    """
    Audio module for voice translator.
    Handles audio capture, playback, and device management.
    """
    
    from .utils import list_audio_devices, find_device_by_name, get_default_devices
    
    __all__ = ['list_audio_devices', 'find_device_by_name', 'get_default_devices']
    ```
    
    Esto permite imports limpios: `from src.audio import list_audio_devices`
  </action>
  <verify>python -c "from src.audio import list_audio_devices; print('OK')"</verify>
  <done>src/audio/__init__.py existe y permite imports del módulo</done>
</task>

## Success Criteria
- [ ] src/audio/utils.py implementado con 3 funciones de gestión de dispositivos
- [ ] src/list_devices.py ejecuta y muestra dispositivos de audio formateados
- [ ] Script detecta automáticamente si VB-Cable está instalado
- [ ] Manejo de errores implementado para casos sin dispositivos o drivers faltantes
- [ ] Usuario puede ejecutar `python src/list_devices.py` para verificar su configuración
