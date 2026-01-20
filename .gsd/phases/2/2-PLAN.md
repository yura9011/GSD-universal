---
phase: 2
plan: 2
wave: 1
---

# Plan 2.2: Whisper Speech Recognition Module

## Objective
Implementar reconocimiento de voz en español usando Whisper Tiny, optimizado para CPU, que transcribe audio a texto con baja latencia.

## Context
- SPEC.md — Requirement: "Speech-to-text en español (Whisper tiny/base)" (must-have)
- .gsd/phases/2/RESEARCH.md — Decisión de usar Whisper Tiny para velocidad
- requirements.txt — openai-whisper ya incluido

## Tasks

<task type="auto">
  <name>Implementar módulo de transcripción con Whisper</name>
  <files>src/audio/transcription.py</files>
  <action>
    Crear src/audio/transcription.py con clase WhisperTranscriber:
    
    ```python
    class WhisperTranscriber:
        def __init__(self, model_size='tiny', language='es', device='cpu'):
            """
            Initialize Whisper transcriber.
            
            Args:
                model_size: 'tiny', 'base', 'small' (default: 'tiny')
                language: Language code (default: 'es' for Spanish)
                device: 'cpu' or 'cuda' (default: 'cpu')
            """
            # Load Whisper model using whisper.load_model()
            # Store language and device
            
        def transcribe(self, audio_data, sample_rate=16000):
            """
            Transcribe audio to text.
            
            Args:
                audio_data: numpy array with audio samples
                sample_rate: Sample rate of audio
                
            Returns:
                str: Transcribed text in Spanish, or empty string if no speech
            """
            # Ensure audio is float32 and normalized
            # Run Whisper transcription
            # Extract text from result
            # Return transcribed text
            
        def get_model_info(self):
            """Get information about loaded model."""
            # Return model size, language, device
    ```
    
    IMPORTANTE:
    - Usar whisper.load_model(model_size) para cargar modelo
    - Especificar language='es' en transcribe() para forzar español
    - Normalizar audio a float32 en rango [-1, 1]
    - Manejar casos donde Whisper no detecta nada (retornar "")
    - Incluir logging de tiempo de transcripción
    - Agregar docstrings claros
  </action>
  <verify>python -c "from src.audio.transcription import WhisperTranscriber; print('OK')"</verify>
  <done>src/audio/transcription.py implementado con clase WhisperTranscriber funcional</done>
</task>

<task type="auto">
  <name>Crear script de test de Whisper</name>
  <files>src/test_whisper.py</files>
  <action>
    Crear src/test_whisper.py que:
    
    1. Importa WhisperTranscriber y AudioCapture
    2. Captura audio del micrófono por 3-5 segundos
    3. Transcribe el audio capturado
    4. Muestra en consola:
       ```
       === Test de Whisper Speech Recognition ===
       
       Modelo: Whisper Tiny (español)
       Device: CPU
       
       🎤 Habla durante 3 segundos...
       [Recording...] ████████████████████ 100%
       
       🔄 Transcribiendo...
       ⏱️  Tiempo: 0.85s
       
       📝 Transcripción:
       "Hola, esto es una prueba del reconocimiento de voz"
       
       ✅ Test completado!
       ```
    5. Mide y muestra tiempo de transcripción
    6. Permite múltiples intentos (loop)
    7. Maneja Ctrl+C para salir
    
    IMPORTANTE:
    - Este test valida que Whisper funciona en CPU
    - Debe mostrar latencia real para verificar < 3s total
    - Ayuda al usuario a probar diferentes frases
  </action>
  <verify>python src/test_whisper.py (grabar una frase y verificar transcripción)</verify>
  <done>src/test_whisper.py ejecuta, graba audio, y transcribe correctamente en español</done>
</task>

<task type="auto">
  <name>Actualizar __init__.py del módulo audio</name>
  <files>src/audio/__init__.py</files>
  <action>
    Actualizar src/audio/__init__.py para exportar nuevas clases:
    
    ```python
    """
    Audio module for voice translator.
    Handles audio capture, playback, device management, VAD, and transcription.
    """
    
    from .utils import list_audio_devices, find_device_by_name, get_default_devices
    from .capture import AudioCapture
    from .playback import AudioPlayback
    from .vad import VoiceActivityDetector
    from .transcription import WhisperTranscriber
    
    __all__ = [
        'list_audio_devices',
        'find_device_by_name', 
        'get_default_devices',
        'AudioCapture',
        'AudioPlayback',
        'VoiceActivityDetector',
        'WhisperTranscriber'
    ]
    ```
    
    Esto permite imports limpios de todas las clases de audio.
  </action>
  <verify>python -c "from src.audio import WhisperTranscriber, VoiceActivityDetector; print('OK')"</verify>
  <done>src/audio/__init__.py actualizado con exports de VAD y Whisper</done>
</task>

## Success Criteria
- [ ] WhisperTranscriber implementado y puede transcribir audio en español
- [ ] test_whisper.py ejecuta y transcribe correctamente frases en español
- [ ] Latencia de transcripción < 2 segundos en CPU (Whisper Tiny)
- [ ] Manejo de errores para audio vacío o sin voz
- [ ] __init__.py actualizado para exports limpios
