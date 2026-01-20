---
phase: 2
plan: 3
wave: 2
---

# Plan 2.3: Integrated Speech Recognition Pipeline

## Objective
Integrar VAD y Whisper en una pipeline completa que captura audio, detecta voz, acumula chunks, y transcribe automáticamente cuando hay suficiente audio, optimizando latencia y precisión.

## Context
- SPEC.md — Success criteria: "Captura audio del micrófono y detecta voz en español"
- .gsd/phases/2/RESEARCH.md — Estrategia de buffering y pipeline
- src/audio/vad.py — VAD implementado (Plan 2.1)
- src/audio/transcription.py — Whisper implementado (Plan 2.2)

## Tasks

<task type="auto">
  <name>Implementar buffer manager para audio</name>
  <files>src/audio/buffer.py</files>
  <action>
    Crear src/audio/buffer.py con clase AudioBuffer:
    
    ```python
    class AudioBuffer:
        def __init__(self, sample_rate=16000, max_duration=5.0, min_duration=0.5):
            """
            Manage audio buffering for speech recognition.
            
            Args:
                sample_rate: Audio sample rate
                max_duration: Maximum buffer duration in seconds
                min_duration: Minimum buffer duration before processing
            """
            # Initialize buffer (list of numpy arrays)
            # Store sample_rate, max_duration, min_duration
            # Track total duration
            
        def add_chunk(self, audio_chunk):
            """Add audio chunk to buffer."""
            # Append chunk to buffer
            # Update total duration
            # Check if max_duration exceeded
            
        def get_audio(self):
            """Get concatenated audio from buffer."""
            # Concatenate all chunks into single numpy array
            # Return audio data
            
        def clear(self):
            """Clear buffer."""
            # Reset buffer and duration
            
        def is_ready(self):
            """Check if buffer has minimum duration."""
            # Return True if duration >= min_duration
            
        def is_full(self):
            """Check if buffer exceeded maximum duration."""
            # Return True if duration >= max_duration
            
        def get_duration(self):
            """Get current buffer duration in seconds."""
            # Return total duration
    ```
    
    IMPORTANTE:
    - Buffer debe ser thread-safe si se usa con threading
    - Limitar tamaño máximo para evitar memory leaks
    - Permitir configuración de min/max duration
  </action>
  <verify>python -c "from src.audio.buffer import AudioBuffer; print('OK')"</verify>
  <done>src/audio/buffer.py implementado con clase AudioBuffer funcional</done>
</task>

<task type="auto">
  <name>Implementar pipeline integrada VAD + Whisper</name>
  <files>src/audio/speech_pipeline.py</files>
  <action>
    Crear src/audio/speech_pipeline.py con clase SpeechRecognitionPipeline:
    
    ```python
    class SpeechRecognitionPipeline:
        def __init__(self, 
                     vad_threshold=0.5,
                     whisper_model='tiny',
                     min_speech_duration=0.5,
                     max_speech_duration=5.0,
                     silence_duration=0.5):
            """
            Integrated speech recognition pipeline with VAD and Whisper.
            
            Args:
                vad_threshold: VAD confidence threshold
                whisper_model: Whisper model size
                min_speech_duration: Minimum speech duration to transcribe
                max_speech_duration: Maximum speech duration to buffer
                silence_duration: Silence duration to trigger transcription
            """
            # Initialize VAD
            # Initialize Whisper
            # Initialize AudioBuffer
            # Track speech/silence state
            # Track silence counter
            
        def process_audio_chunk(self, audio_chunk):
            """
            Process audio chunk through VAD and buffering.
            
            Args:
                audio_chunk: numpy array with audio samples
                
            Returns:
                str or None: Transcribed text if ready, None otherwise
            """
            # Run VAD on chunk
            # If speech detected:
            #   - Add to buffer
            #   - Reset silence counter
            # If silence detected:
            #   - Increment silence counter
            #   - If silence_duration reached and buffer has min_duration:
            #     - Transcribe buffer
            #     - Clear buffer
            #     - Return transcription
            # If buffer is full:
            #   - Transcribe immediately
            #   - Clear buffer
            #   - Return transcription
            # Return None if no transcription ready
            
        def reset(self):
            """Reset pipeline state."""
            # Clear buffer
            # Reset VAD
            # Reset counters
    ```
    
    IMPORTANTE:
    - Pipeline debe ser stateful (mantener buffer entre llamadas)
    - Detectar fin de frase con silence_duration
    - Forzar transcripción si buffer lleno (max_duration)
    - Retornar None si no hay transcripción lista
    - Incluir logging de estados (speech detected, transcribing, etc.)
  </action>
  <verify>python -c "from src.audio.speech_pipeline import SpeechRecognitionPipeline; print('OK')"</verify>
  <done>src/audio/speech_pipeline.py implementado con pipeline integrada funcional</done>
</task>

<task type="auto">
  <name>Crear script de test de pipeline completa</name>
  <files>src/test_speech_pipeline.py</files>
  <action>
    Crear src/test_speech_pipeline.py que:
    
    1. Importa SpeechRecognitionPipeline y AudioCapture
    2. Inicializa pipeline con configuración por defecto
    3. Captura audio del micrófono en tiempo real
    4. Procesa cada chunk con pipeline
    5. Muestra en consola:
       ```
       === Test de Speech Recognition Pipeline ===
       
       Configuración:
       - Modelo: Whisper Tiny
       - VAD Threshold: 0.5
       - Min Speech: 0.5s
       - Max Speech: 5.0s
       - Silence Trigger: 0.5s
       
       🎤 Escuchando...
       Habla en español. Presiona Ctrl+C para detener.
       
       [SPEECH DETECTED] Acumulando audio... (0.8s)
       [SILENCE] Esperando fin de frase...
       
       🔄 Transcribiendo...
       ⏱️  Tiempo: 0.92s
       📝 "Hola, esto es una prueba"
       
       🎤 Escuchando...
       ```
    6. Muestra transcripciones en tiempo real
    7. Mide latencia total (desde fin de frase hasta transcripción)
    8. Maneja Ctrl+C gracefully
    
    IMPORTANTE:
    - Este es el test CRÍTICO de Phase 2
    - Debe demostrar que la pipeline funciona end-to-end
    - Latencia total debe ser < 3 segundos
    - Usuario debe poder hablar naturalmente y ver transcripciones
  </action>
  <verify>python src/test_speech_pipeline.py (hablar varias frases y verificar transcripciones)</verify>
  <done>src/test_speech_pipeline.py ejecuta y transcribe frases en tiempo real correctamente</done>
</task>

## Success Criteria
- [ ] AudioBuffer implementado para gestionar acumulación de audio
- [ ] SpeechRecognitionPipeline integra VAD + Whisper correctamente
- [ ] test_speech_pipeline.py ejecuta y transcribe frases en tiempo real
- [ ] Pipeline detecta fin de frase con silencio
- [ ] Latencia total < 3 segundos (desde fin de frase hasta transcripción)
- [ ] Usuario puede hablar naturalmente y ver transcripciones automáticas
