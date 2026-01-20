# Phase 2 Research: Speech Recognition (ES)

**Date**: 2026-01-19
**Phase**: 2 - Speech Recognition (ES)

## Research Questions

1. ¿Qué modelo de Whisper usar para CPU sin GPU? (tiny vs base)
2. ¿Cómo implementar Voice Activity Detection (VAD) eficientemente?
3. ¿Cómo optimizar latencia en el reconocimiento de voz?

---

## Whisper Model Selection

### Model Comparison

| Model | Parameters | VRAM | CPU Performance | Accuracy | Latency |
|-------|-----------|------|-----------------|----------|---------|
| Tiny | 39M | ~1GB | ⭐⭐⭐ Excellent | ⭐⭐ Fair | ~0.5-1s |
| Base | 74M | ~1GB | ⭐⭐ Good | ⭐⭐⭐ Good | ~1-2s |
| Small | 244M | ~2GB | ⭐ Poor | ⭐⭐⭐⭐ Very Good | ~3-5s |

**Key Findings:**
- Tiny and Base models work well on CPU without GPU
- Tiny is fastest but less accurate (more transcription errors)
- Base offers better balance between speed and accuracy
- Small is too slow for real-time on CPU

**Decision:** Start with **Whisper Tiny** for speed, allow upgrade to Base if accuracy is insufficient.

Fuentes: [Restack - Faster Whisper](https://www.restack.io/p/speech-to-text-answer-faster-whisper-vs-insanely-fast-whisper-cat-ai), [Northflank - STT Benchmarks](https://northflank.com/blog/best-open-source-speech-to-text-stt-model-in-2025-benchmarks)

---

## Voice Activity Detection (VAD)

### Options Evaluated

#### 1. WebRTC VAD
**Pros:**
- Muy ligero y rápido
- Biblioteca madura (py-webrtcvad)
- Funciona bien en CPU

**Cons:**
- Más falsos positivos
- Tecnología más antigua
- Menos preciso que modelos modernos

#### 2. Silero VAD
**Pros:**
- Modelo DNN moderno y preciso
- Menos falsos positivos que WebRTC
- Enterprise-grade quality
- Funciona bien en CPU con PyTorch
- Activamente mantenido

**Cons:**
- Requiere PyTorch (ya lo tenemos para Whisper)
- Ligeramente más pesado que WebRTC

**Decision:** Usar **Silero VAD** por su mejor precisión y calidad enterprise.

Fuentes: [Silero VAD PyPI](https://pypi.org/project/silero-vad/), [GitHub - Silero VAD](https://github.com/snakers4/silero-vad), [Best VAD 2025](https://pv-beta.net/blog/best-voice-activity-detection-vad-2025/)

---

## Implementation Strategy

### Audio Processing Pipeline

```
[Audio Chunks from Mic]
      ↓
[VAD - Silero] ← Detecta si hay voz
      ↓
[Buffer de Audio] ← Acumula chunks con voz
      ↓
[Whisper Tiny] ← Transcribe cuando hay suficiente audio
      ↓
[Texto en Español] → A Phase 3
```

### Buffering Strategy

1. **Chunk size**: 512-1024 samples @ 16kHz (~32-64ms)
2. **VAD threshold**: Acumular mínimo 0.5-1 segundo de audio con voz
3. **Max buffer**: 5 segundos (evitar frases muy largas)
4. **Silence detection**: Si 0.5s de silencio después de voz → procesar buffer

### Latency Optimization

**Target latency breakdown:**
- Audio capture: ~50ms (buffering)
- VAD detection: ~10ms (muy rápido)
- Audio accumulation: ~500-1000ms (esperar frase completa)
- Whisper transcription: ~500-1000ms (Tiny model en CPU)
- **Total**: ~1-2 segundos (dentro del objetivo < 3s)

---

## Dependencies

### New Dependencies for Phase 2:
```
# Already in requirements.txt:
openai-whisper>=20231117

# Need to add:
silero-vad>=5.0.0
torch>=1.12.0  # Required by Whisper and Silero
```

**Note:** torch ya es dependencia de openai-whisper, así que solo agregar silero-vad.

---

## Technical Considerations

### 1. Threading
- VAD debe correr en thread separado del audio capture
- Whisper transcription debe ser async para no bloquear audio
- Usar queues para comunicación thread-safe

### 2. Memory Management
- Limpiar buffers después de transcripción
- Limitar tamaño máximo de buffer (5s)
- Evitar memory leaks en loops largos

### 3. Error Handling
- Manejar casos donde Whisper no detecta nada
- Timeout si Whisper tarda demasiado
- Fallback si VAD falla (procesar todo el audio)

---

## Testing Strategy

1. **VAD Test**: Script que muestra cuando detecta voz vs silencio
2. **Whisper Test**: Script que transcribe audio de prueba
3. **Integration Test**: Pipeline completa con audio en vivo

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Whisper muy lento en CPU | Usar Tiny model, considerar faster-whisper si es necesario |
| VAD con muchos falsos positivos | Ajustar threshold de Silero VAD |
| Latencia > 3 segundos | Optimizar buffer size, reducir tiempo de acumulación |
| Transcripciones incorrectas | Permitir upgrade a Base model, agregar logging para debug |

---

## Next Steps for Planning

1. Agregar silero-vad a requirements.txt
2. Implementar módulo VAD con Silero
3. Implementar módulo de transcripción con Whisper
4. Crear buffer manager para acumular audio
5. Integrar VAD + Whisper en pipeline
6. Crear script de test para validar transcripciones

---

*Research completed: 2026-01-19*
