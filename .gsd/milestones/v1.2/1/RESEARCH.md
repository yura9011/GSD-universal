# Phase 1 Research: Environment Setup & Audio Pipeline

**Date**: 2026-01-19
**Phase**: 1 - Environment Setup & Audio Pipeline

## Research Questions

1. ¿Qué biblioteca de audio Python es mejor para captura en tiempo real?
2. ¿Cómo integrar Python con VB-Audio Virtual Cable?
3. ¿Qué dependencias necesitamos para el proyecto?

---

## Audio Capture Libraries Comparison

### PyAudio
**Pros:**
- Bindings para PortAudio (cross-platform)
- Ampliamente usado y documentado
- Soporte para streaming en tiempo real

**Cons:**
- Instalación puede ser complicada en Windows (requiere compilación o wheels)
- Menos activamente mantenido
- API más verbosa

### sounddevice
**Pros:**
- También usa PortAudio pero con API más moderna
- Integración nativa con NumPy arrays
- Más fácil de instalar (pip install sounddevice)
- Activamente mantenido
- API más simple y pythónica

**Cons:**
- Menos ejemplos disponibles que PyAudio

**Decisión:** Usar `sounddevice` por su facilidad de instalación y API moderna.

Fuente: [Real Python - Playing and Recording Sound](https://realpython.com/playing-and-recording-sound-python/), [python-sounddevice docs](https://python-sounddevice.readthedocs.io/)

---

## VB-Audio Virtual Cable Integration

### Hallazgos clave:

1. **VB-Audio Virtual Cable NO se puede crear desde Python**
   - Es un driver de kernel-mode que debe instalarse manualmente
   - Python solo puede USAR el dispositivo una vez instalado
   - Fuente: [Stack Overflow - Virtual Audio Cable](https://stackoverflow.com/questions/77094894/)

2. **Cómo usar VB-Cable desde Python:**
   - VB-Cable aparece como un dispositivo de audio normal en Windows
   - Se puede listar con `sounddevice.query_devices()`
   - Se puede seleccionar como output device por nombre o índice
   - El audio enviado al "CABLE Input" sale automáticamente por "CABLE Output"

3. **Setup requerido:**
   - Usuario debe descargar e instalar VB-Cable manualmente desde [vb-audio.com](https://vb-audio.com/Cable/)
   - Después de instalación, reiniciar puede ser necesario
   - En Discord/juegos, seleccionar "CABLE Output" como micrófono de entrada

---

## Dependencies Stack

### Core Dependencies:
```
sounddevice>=0.4.6    # Audio I/O
numpy>=1.24.0         # Array processing (requerido por sounddevice)
openai-whisper        # Speech-to-text (Phase 2)
pyttsx3>=2.90         # Text-to-speech (Phase 3)
googletrans==4.0.0rc1 # Translation (Phase 3)
```

### System Requirements:
- Python 3.8+
- Windows 10/11 (o macOS con CoreAudio)
- VB-Audio Virtual Cable (instalación manual)

---

## Audio Pipeline Architecture

```
[Micrófono Real]
      ↓
[sounddevice.InputStream] ← Captura audio chunks
      ↓
[Buffer/Queue] ← Almacena temporalmente
      ↓
[Procesamiento] ← Whisper, Translate, TTS (Phases 2-3)
      ↓
[sounddevice.OutputStream] → Envía a VB-Cable Input
      ↓
[VB-Cable Output] → Discord/Juego escucha como "micrófono"
```

---

## Implementation Notes

1. **Chunk size y latencia:**
   - Chunks más pequeños = menor latencia pero más overhead
   - Recomendado: 1024-2048 samples @ 16kHz
   - Esto da ~64-128ms de latencia de captura

2. **Sample rate:**
   - Whisper funciona mejor con 16kHz
   - Resamplear si el mic captura a 44.1kHz o 48kHz

3. **Threading:**
   - Audio I/O debe correr en threads separados
   - Usar `queue.Queue` para comunicación thread-safe

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| VB-Cable no instalado | README claro con link de descarga y pasos |
| sounddevice no encuentra dispositivos | Listar todos los devices al inicio, permitir selección manual |
| Latencia alta en captura | Usar chunks pequeños, optimizar buffer size |
| Instalación de dependencias falla | Proveer requirements.txt testeado, documentar troubleshooting |

---

## Next Steps for Planning

1. Crear estructura de proyecto Python básica
2. Setup requirements.txt con dependencias core
3. Implementar script de prueba de audio (captura + reproducción)
4. Crear README con instrucciones de VB-Cable
5. Validar que audio fluye correctamente a través del cable virtual

---

*Research completed: 2026-01-19*
