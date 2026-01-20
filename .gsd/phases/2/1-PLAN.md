---
phase: 2
plan: 1
wave: 1
---

# Plan 2.1: Voice Activity Detection (VAD) Module

## Objective
Implementar detección de actividad de voz usando Silero VAD para identificar cuándo el usuario está hablando vs silencio/ruido, optimizando el procesamiento y reduciendo transcripciones innecesarias.

## Context
- SPEC.md — Requirement: "Detección de actividad de voz (VAD)" (should-have)
- .gsd/phases/2/RESEARCH.md — Decisión de usar Silero VAD por precisión
- src/audio/capture.py — Módulo de captura ya implementado

## Tasks

<task type="auto">
  <name>Actualizar requirements.txt con Silero VAD</name>
  <files>requirements.txt</files>
  <action>
    Agregar silero-vad a requirements.txt:
    
    Después de la sección "# Speech Recognition (Phase 2)", agregar:
    ```
    silero-vad>=5.0.0
    ```
    
    IMPORTANTE: torch ya está incluido como dependencia de openai-whisper, no agregarlo de nuevo.
  </action>
  <verify>type requirements.txt | findstr silero-vad</verify>
  <done>requirements.txt contiene silero-vad>=5.0.0</done>
</task>

<task type="auto">
  <name>Implementar módulo VAD con Silero</name>
  <files>src/audio/vad.py</files>
  <action>
    Crear src/audio/vad.py con clase VoiceActivityDetector:
    
    ```python
    class VoiceActivityDetector:
        def __init__(self, sample_rate=16000, threshold=0.5):
            """
            Initialize VAD using Silero VAD model.
            
            Args:
                sample_rate: Audio sample rate (must be 16000 for Silero)
                threshold: Confidence threshold (0.0-1.0). Higher = more strict.
            """
            # Load Silero VAD model
            # Store sample_rate and threshold
            
        def is_speech(self, audio_chunk):
            """
            Detect if audio chunk contains speech.
            
            Args:
                audio_chunk: numpy array with audio samples
                
            Returns:
                bool: True if speech detected, False otherwise
            """
            # Run VAD on audio chunk
            # Return True if confidence > threshold
            
        def reset(self):
            """Reset VAD internal state."""
            # Reset model state for new audio stream
    ```
    
    IMPORTANTE:
    - Usar torch.hub.load para cargar modelo Silero VAD
    - Silero requiere sample_rate = 16000 (ya lo usamos)
    - Manejar conversión de numpy array a torch tensor
    - Incluir docstrings claros
    - Agregar logging básico (print statements)
  </action>
  <verify>python -c "from src.audio.vad import VoiceActivityDetector; print('OK')"</verify>
  <done>src/audio/vad.py implementado con clase VoiceActivityDetector funcional</done>
</task>

<task type="auto">
  <name>Crear script de test de VAD</name>
  <files>src/test_vad.py</files>
  <action>
    Crear src/test_vad.py que:
    
    1. Importa VoiceActivityDetector y AudioCapture
    2. Captura audio del micrófono en tiempo real
    3. Procesa cada chunk con VAD
    4. Muestra en consola:
       ```
       === Test de Voice Activity Detection ===
       
       🎤 Capturando audio...
       Presiona Ctrl+C para detener
       
       [SPEECH] ████████████ (confidence: 0.85)
       [SILENCE] ░░░░░░░░░░░░ (confidence: 0.12)
       [SPEECH] ████████████ (confidence: 0.92)
       ```
    5. Usa colores o símbolos para distinguir speech vs silence
    6. Maneja Ctrl+C gracefully
    
    IMPORTANTE:
    - Este script ayuda a ajustar el threshold de VAD
    - Debe ser fácil de usar para el usuario
    - Mostrar confidence score para debugging
  </action>
  <verify>python src/test_vad.py (ejecutar por 5 segundos y detener)</verify>
  <done>src/test_vad.py ejecuta y muestra detección de voz en tiempo real</done>
</task>

## Success Criteria
- [ ] requirements.txt actualizado con silero-vad
- [ ] VoiceActivityDetector implementado y puede detectar voz en audio chunks
- [ ] test_vad.py ejecuta y muestra detección en tiempo real
- [ ] VAD distingue correctamente entre voz y silencio
- [ ] Usuario puede ajustar threshold si es necesario
