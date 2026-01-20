---
phase: 1
plan: 3
wave: 2
---

# Plan 1.3: Audio Capture & Playback Test

## Objective
Implementar y validar la pipeline básica de audio: capturar audio del micrófono y reproducirlo en VB-Cable Input, demostrando que el flujo de audio funciona end-to-end antes de agregar procesamiento de voz.

## Context
- SPEC.md — Success criteria: "Captura audio del micrófono" y "Reproduce audio en micrófono virtual"
- .gsd/phases/1/RESEARCH.md — Arquitectura de audio pipeline con sounddevice streams
- src/audio/utils.py — Funciones de device discovery (de Plan 1.2)

## Tasks

<task type="auto">
  <name>Implementar módulo de captura de audio</name>
  <files>src/audio/capture.py</files>
  <action>
    Crear src/audio/capture.py con clase AudioCapture:
    
    ```python
    class AudioCapture:
        def __init__(self, device_index=None, sample_rate=16000, channels=1, chunk_size=1024):
            """
            Inicializa captura de audio.
            
            Args:
                device_index: Índice del dispositivo de entrada (None = default)
                sample_rate: Sample rate en Hz (16000 para Whisper)
                channels: Número de canales (1 = mono)
                chunk_size: Tamaño del buffer en samples
            """
            
        def start(self, callback):
            """
            Inicia stream de captura.
            
            Args:
                callback: Función que recibe (audio_data, frames, time, status)
            """
            
        def stop(self):
            """Detiene stream de captura."""
            
        def is_active(self):
            """Retorna True si el stream está activo."""
    ```
    
    IMPORTANTE:
    - Usar sounddevice.InputStream
    - El callback debe ser thread-safe
    - Manejar errores de dispositivo no disponible
    - Incluir logging básico (print statements OK por ahora)
  </action>
  <verify>python -c "from src.audio.capture import AudioCapture; print('OK')"</verify>
  <done>src/audio/capture.py implementado con clase AudioCapture funcional</done>
</task>

<task type="auto">
  <name>Implementar módulo de reproducción de audio</name>
  <files>src/audio/playback.py</files>
  <action>
    Crear src/audio/playback.py con clase AudioPlayback:
    
    ```python
    class AudioPlayback:
        def __init__(self, device_index=None, sample_rate=16000, channels=1):
            """
            Inicializa reproducción de audio.
            
            Args:
                device_index: Índice del dispositivo de salida (None = default)
                sample_rate: Sample rate en Hz
                channels: Número de canales
            """
            
        def play(self, audio_data):
            """
            Reproduce audio_data (numpy array).
            
            Args:
                audio_data: numpy array con samples de audio
            """
            
        def start_stream(self, callback):
            """
            Inicia stream de reproducción continua.
            
            Args:
                callback: Función que genera audio data cuando se necesita
            """
            
        def stop(self):
            """Detiene stream de reproducción."""
    ```
    
    IMPORTANTE:
    - Usar sounddevice.OutputStream
    - Manejar underruns (cuando no hay data disponible)
    - El device_index debe apuntar a "CABLE Input" para VB-Cable
  </action>
  <verify>python -c "from src.audio.playback import AudioPlayback; print('OK')"</verify>
  <done>src/audio/playback.py implementado con clase AudioPlayback funcional</done>
</task>

<task type="auto">
  <name>Crear script de test de audio loopback</name>
  <files>src/test_audio.py</files>
  <action>
    Crear src/test_audio.py que:
    
    1. Importa AudioCapture, AudioPlayback, y find_device_by_name
    2. Busca automáticamente "CABLE Input" para output
    3. Usa micrófono default para input
    4. Crea un loopback simple:
       - Captura audio del mic
       - Lo envía directamente a VB-Cable Input
       - Usa queue.Queue para pasar data entre threads
    5. Muestra en consola:
       ```
       === Test de Audio Pipeline ===
       Input: [nombre del mic] (índice X)
       Output: CABLE Input (índice Y)
       
       Presiona Ctrl+C para detener...
       [Capturando...] [Reproduciendo...]
       ```
    6. Maneja Ctrl+C gracefully para detener streams
    
    IMPORTANTE:
    - Este es un test CRÍTICO: si funciona, la pipeline básica está OK
    - Si VB-Cable no está instalado, mostrar error claro
    - Incluir instrucciones: "Habla al micrófono. Deberías escucharte en Discord si seleccionaste CABLE Output como mic"
  </action>
  <verify>python src/test_audio.py (ejecutar por 5 segundos y detener con Ctrl+C)</verify>
  <done>src/test_audio.py ejecuta, captura audio del mic, y lo reproduce en VB-Cable Input sin errores</done>
</task>

## Success Criteria
- [ ] AudioCapture implementado y puede capturar audio del micrófono
- [ ] AudioPlayback implementado y puede reproducir audio en VB-Cable Input
- [ ] test_audio.py ejecuta y crea loopback funcional (mic → VB-Cable)
- [ ] Usuario puede verificar que su voz llega a Discord/juego a través de VB-Cable
- [ ] Manejo de errores para VB-Cable no instalado o dispositivos no disponibles
