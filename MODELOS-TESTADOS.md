# Modelos Testados com OpenClaw + Ollama

Documentacao dos testes realizados com diferentes modelos LLM via Ollama.

## Hardware de Teste

- GPU: NVIDIA GB10
- RAM: 119GB
- Storage: Volume Docker (`/var/lib/docker/volumes/openclaw-ollama-local_ollama-data/_data`)

## Modelos Testados

### 1. llama3.2 (3B) - 2.0GB

**Status:** Funciona

**Problemas:**
- Respostas de baixa qualidade
- Nao responde bem em portugues (responde em ingles)
- Context window pequeno para prompts complexos

**Conclusao:** Bom apenas para testes basicos.

---

### 2. llama3.1:8b - 4.9GB

**Status:** Funciona

**Problemas:**
- Qualidade mediana
- Portugues fraco (tende a responder em ingles)
- Dificuldade com system prompts complexos do OpenClaw

**Conclusao:** Funciona mas nao recomendado para uso real.

---

### 3. deepseek-r1:14b - 9.0GB

**Status:** NAO FUNCIONA via OpenClaw

**Problemas:**
- Modelo usa tags `<think>...</think>` para raciocinio
- OpenClaw nao processa essas tags corretamente
- Funciona diretamente via `ollama run deepseek-r1:14b`
- Nao responde via gateway do OpenClaw

**Conclusao:** Incompativel com OpenClaw devido ao formato de output do modelo.

---

### 4. qwen2.5:14b - 9.0GB

**Status:** Funciona

**Problemas:**
- Portugues ainda fraco
- Qualidade de resposta mediana

**Conclusao:** Funciona mas portugues insuficiente.

---

### 5. qwen2.5:32b - 19GB

**Status:** Funciona (RECOMENDADO PARA OLLAMA LOCAL)

**Vantagens:**
- Melhor suporte multilingual
- Bom portugues
- Qualidade de resposta superior

**Conclusao:** Melhor opcao testada para uso com portugues via Ollama.

---

### 6. command-r:35b - 18GB

**Status:** Funciona

**Problemas:**
- Qualidade de resposta ruim nos testes
- Portugues fraco apesar de ser multilingual

**Conclusao:** Nao recomendado.

---

### 7. llama3.1:70b - 42GB

**Status:** Funciona mas INVIAVEL

**Problemas:**
- Com 32k context: ~57GB VRAM, muito lento
- Com 16k context: ainda muito lento
- Inferencia demora demais para uso pratico

**Conclusao:** Inviavel para uso local mesmo com GPU potente.

---

## Modelos via OpenRouter (API)

### 1. Claude Sonnet 4 (anthropic/claude-sonnet-4)

**Status:** Funciona (PAGO)

**Vantagens:**
- Alta qualidade
- Excelente portugues
- Rapido

**Custo:** $3/M input, $15/M output

**Conclusao:** Melhor opcao se budget permitir.

---

### 2. Gemini 2.0 Flash Free (google/gemini-2.0-flash-exp:free)

**Status:** NAO FUNCIONA

**Problema:** ID do modelo nao existe mais no OpenRouter.

**Conclusao:** Modelo descontinuado ou ID alterado.

---

### 3. Llama 3.3 70B Free (meta-llama/llama-3.3-70b-instruct:free)

**Status:** Funciona

**Vantagens:**
- Gratuito
- Bom portugues
- Qualidade superior aos modelos locais pequenos
- Rapido

**Limite:** ~20 req/min, logs armazenados pelo provider

**Conclusao:** Boa opcao gratuita via OpenRouter.

---

### 4. Qwen3 Coder 480B Free (qwen/qwen3-coder:free)

**Status:** Funciona (RECOMENDADO GRATUITO)

**Vantagens:**
- Gratuito
- 480B parametros (MoE com 35B ativos)
- Otimizado para codigo e tarefas agenticas
- Bom portugues

**Limite:** ~20 req/min, logs armazenados pelo provider

**Conclusao:** Melhor opcao gratuita para coding via OpenRouter.

---

## Modelos Nao Testados (Candidatos)

| Modelo | Tamanho | Portugues | Notas |
|--------|---------|-----------|-------|
| command-r | 35B | Excelente | Feito para multilingual |
| mixtral | 8x7B | Muito bom | MoE architecture |
| llama3.1:70b | 70B | Bom | Precisa muita VRAM |
| deepseek-r1:32b | 32B | ? | Pode ter mesmo problema do 14b |

---

## Problemas Encontrados e Solucoes

### 1. "Gateway start blocked: set gateway.mode=local"

**Causa:** Configuracao do gateway incorreta.

**Solucao:** Adicionar em `openclaw.json`:
```json
"gateway": {
  "mode": "local"
}
```

---

### 2. "pairing required" / "disconnected (1008)"

**Causa:** OpenClaw exige autenticacao de dispositivo por padrao.

**Solucao:** Adicionar em `openclaw.json`:
```json
"gateway": {
  "controlUi": {
    "dangerouslyDisableDeviceAuth": true
  }
}
```

---

### 3. "device identity required"

**Causa:** Multiplas abas do navegador ou cookies conflitantes.

**Solucao:**
1. Adicionar `"allowInsecureAuth": true` em `controlUi`
2. Usar janela anonima do navegador
3. Usar apenas uma aba

---

### 4. DeepSeek-R1 nao responde

**Causa:** Modelo usa formato `<think>` que OpenClaw nao processa.

**Solucao:** Usar outro modelo (qwen2.5, llama3.1, etc).

---

### 5. Modelo responde em ingles (nao portugues)

**Causa:** Modelos menores tem suporte multilingual fraco.

**Solucao:** Usar modelos maiores (32B+) como qwen2.5:32b ou command-r.

---

## Resumo - Tabela de Modelos

| Modelo | Provider | Tamanho | Status | Portugues | Recomendado |
|--------|----------|---------|--------|-----------|-------------|
| llama3.2 | Ollama | 2GB | Funciona | Ruim | Nao |
| llama3.1:8b | Ollama | 4.9GB | Funciona | Ruim | Nao |
| deepseek-r1:14b | Ollama | 9GB | Nao funciona | - | Nao |
| qwen2.5:14b | Ollama | 9GB | Funciona | Fraco | Nao |
| **qwen2.5:32b** | Ollama | 19GB | Funciona | Bom | **Sim (local)** |
| command-r:35b | Ollama | 18GB | Funciona | Fraco | Nao |
| llama3.1:70b | Ollama | 42GB | Muito lento | Bom | Nao |
| Claude Sonnet 4 | OpenRouter | - | Funciona | Excelente | Sim (pago) |
| Gemini 2.0 Flash | OpenRouter | - | Nao existe | - | Nao |
| Llama 3.3 70B | OpenRouter | - | Funciona | Bom | Sim (free) |
| **Qwen3 Coder 480B** | OpenRouter | - | Funciona | Bom | **Sim (free)** |

---

## Configuracao Recomendada - Ollama Local

`~/.openclaw/openclaw.json`:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/qwen2.5:32b"
      }
    }
  },
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "http://ollama:11434/v1",
        "apiKey": "ollama-local",
        "api": "openai-completions",
        "models": [
          {
            "id": "qwen2.5:32b",
            "name": "Qwen 2.5 32B",
            "reasoning": false,
            "input": ["text"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 32768,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "gateway": {
    "mode": "local",
    "bind": "lan",
    "controlUi": {
      "dangerouslyDisableDeviceAuth": true,
      "allowInsecureAuth": true
    },
    "auth": {
      "mode": "token",
      "token": "<SEU_TOKEN>"
    }
  }
}
```

---

## Configuracao Recomendada - OpenRouter (Gratuito)

`~/.openclaw/openclaw.json`:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/qwen/qwen3-coder:free"
      }
    }
  },
  "models": {
    "providers": {
      "openrouter": {
        "baseUrl": "https://openrouter.ai/api/v1",
        "apiKey": "<SUA_API_KEY>",
        "api": "openai-completions",
        "models": [
          {
            "id": "qwen/qwen3-coder:free",
            "name": "Qwen3 Coder 480B (Free)",
            "reasoning": false,
            "input": ["text"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 131072,
            "maxTokens": 8192
          },
          {
            "id": "meta-llama/llama-3.3-70b-instruct:free",
            "name": "Llama 3.3 70B (Free)",
            "reasoning": false,
            "input": ["text"],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 131072,
            "maxTokens": 8192
          },
          {
            "id": "anthropic/claude-sonnet-4",
            "name": "Claude Sonnet 4",
            "reasoning": false,
            "input": ["text", "image"],
            "cost": {
              "input": 3,
              "output": 15,
              "cacheRead": 0.3,
              "cacheWrite": 3.75
            },
            "contextWindow": 200000,
            "maxTokens": 16000
          }
        ]
      }
    }
  },
  "gateway": {
    "mode": "local",
    "bind": "lan",
    "controlUi": {
      "dangerouslyDisableDeviceAuth": true,
      "allowInsecureAuth": true
    },
    "auth": {
      "mode": "token",
      "token": "<SEU_TOKEN>"
    }
  }
}
```

---

## Comandos Uteis

```bash
# Listar modelos instalados
docker compose exec ollama ollama list

# Baixar novo modelo
docker compose exec ollama ollama pull <modelo>

# Testar modelo diretamente
docker compose exec ollama ollama run <modelo> "Ola, tudo bem?"

# Reiniciar gateway apos mudar config
docker compose restart openclaw-gateway

# Ver logs do gateway
docker compose logs -f openclaw-gateway

# Ver uso de GPU
nvidia-smi
```

---

## Espaco em Disco

Modelos apos testes:

| Modelo | Tamanho |
|--------|---------|
| llama3.2 | 2.0 GB |
| llama3.1:8b | 4.9 GB |
| deepseek-r1:14b | 9.0 GB |
| qwen2.5:14b | 9.0 GB |
| qwen2.5:32b | 19 GB |
| **Total** | **~44 GB** |

Para liberar espaco:
```bash
docker compose exec ollama ollama rm <modelo>
```
