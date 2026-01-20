---
phase: 5
plan: 1
wave: 1
milestone: v1.1
---

# Plan 5.1: Remove Emojis from Python Code

## Objective
Eliminar todos los emojis de los archivos Python en src/, reemplazándolos con texto descriptivo profesional.

## Context
- ROADMAP.md — Phase 1: Code Cleanup - "Remover emojis de src/*.py"
- src/ — Contiene todos los archivos Python con emojis en prints y comentarios

## Tasks

<task type="auto">
  <name>Remove emojis from src/voice_translator.py</name>
  <files>src/voice_translator.py</files>
  <action>
    Reemplazar todos los emojis con texto descriptivo:
    
    Emojis a reemplazar:
    - "🔄" → "[INFO]"
    - "✓" → "[OK]"
    - "⚠️" → "[WARNING]"
    - "🎤" → "[LISTENING]"
    - "📝" → "[DETECTED]"
    - "🔊" → "[PLAYING]"
    - "⏱️" → "[TIMING]"
    - "✅" → "[COMPLETE]"
    - "❌" → "[ERROR]"
    - "🛑" → "[STOPPED]"
    
    Ejemplos de cambios:
    - "🔄 Inicializando..." → "[INFO] Initializing..."
    - "✓ VB-Cable detectado" → "[OK] VB-Cable detected"
    - "🎤 ESCUCHANDO..." → "[LISTENING] Waiting for speech..."
    - "📝 Detectado (ES):" → "[DETECTED] Spanish text:"
    - "🔊 Reproduciendo (PT):" → "[PLAYING] Portuguese audio:"
    
    IMPORTANTE:
    - Mantener toda la funcionalidad
    - Usar texto en inglés para consistencia profesional
    - Mantener la misma estructura de logging
    - No cambiar la lógica del código
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from voice_translator import VoiceTranslator; print('OK')"</verify>
  <done>src/voice_translator.py sin emojis, usando texto descriptivo profesional</done>
</task>

<task type="auto">
  <name>Remove emojis from src/main.py</name>
  <files>src/main.py</files>
  <action>
    Reemplazar emojis en main.py:
    
    - Banner: Eliminar caracteres especiales del banner, usar texto simple
    - "🛑" → "[STOPPED]"
    - "❌" → "[ERROR]"
    
    Cambiar banner de:
    ```
    ╔══════════════════════════════════════════════════════════╗
    ║  Traductor de Voz ES→PT en Tiempo Real                  ║
    ╚══════════════════════════════════════════════════════════╝
    ```
    
    A:
    ```
    ============================================================
    Real-time Spanish to Portuguese Voice Translator
    For gaming (Dota 2, Discord, etc.)
    ============================================================
    ```
    
    IMPORTANTE:
    - Mantener funcionalidad del CLI
    - Usar texto en inglés
    - Banner simple con caracteres ASCII estándar
  </action>
  <verify>python src/main.py --help</verify>
  <done>src/main.py sin emojis, con banner profesional ASCII</done>
</task>

<task type="auto">
  <name>Remove emojis from translator modules</name>
  <files>src/translator/translation.py, src/translator/tts.py, src/translator/pipeline.py</files>
  <action>
    Reemplazar emojis en módulos de traducción:
    
    **src/translator/translation.py**:
    - "✓" → "[OK]"
    - "⚠" → "[WARNING]"
    - "❌" → "[ERROR]"
    - "⏱️" → "[TIMING]"
    
    **src/translator/tts.py**:
    - "🔄" → "[INFO]"
    - "✓" → "[OK]"
    - "⚠" → "[WARNING]"
    - "❌" → "[ERROR]"
    - "⏱️" → "[TIMING]"
    
    **src/translator/pipeline.py**:
    - "🔄" → "[INFO]"
    - "✓" → "[OK]"
    - "📝" → "[TEXT]"
    - "⏱️" → "[TIMING]"
    
    IMPORTANTE:
    - Mantener toda la funcionalidad
    - Usar prefijos consistentes: [INFO], [OK], [WARNING], [ERROR], [TIMING]
    - Texto en inglés
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from translator import Translator, TextToSpeech, TranslationTTSPipeline; print('OK')"</verify>
  <done>Módulos de translator sin emojis, usando prefijos profesionales</done>
</task>

<task type="auto">
  <name>Remove emojis from audio modules</name>
  <files>src/audio/capture.py, src/audio/playback.py, src/audio/speech_pipeline.py, src/audio/transcription.py, src/audio/vad.py</files>
  <action>
    Reemplazar emojis en módulos de audio:
    
    Buscar y reemplazar en todos los archivos:
    - "✓" → "[OK]"
    - "⚠" → "[WARNING]"
    - "❌" → "[ERROR]"
    - "🔄" → "[INFO]"
    - "⏱️" → "[TIMING]"
    - "🎤" → "[AUDIO]"
    - "🔊" → "[PLAYBACK]"
    
    IMPORTANTE:
    - Revisar cada archivo en src/audio/
    - Mantener funcionalidad completa
    - Usar prefijos consistentes
    - Texto en inglés
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from audio import AudioCapture, AudioPlayback, SpeechRecognitionPipeline; print('OK')"</verify>
  <done>Módulos de audio sin emojis, usando prefijos profesionales</done>
</task>

## Success Criteria
- [ ] Todos los archivos Python sin emojis
- [ ] Mensajes de consola profesionales con prefijos [INFO], [OK], [WARNING], [ERROR]
- [ ] Funcionalidad completa mantenida
- [ ] Imports funcionando correctamente
- [ ] Texto en inglés para consistencia profesional
