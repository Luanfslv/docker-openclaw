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

### 6. Ollama trunca contexto para 4096 tokens

**Causa:** Ollama tem default `num_ctx=4096`. O parametro `contextWindow` do OpenClaw nao e passado para o Ollama via API OpenAI-compatible.

**Sintoma no log:**
```
truncating input prompt limit=4096 prompt=11504
```

**Solucao:** Criar modelo customizado com Modelfile:
```
FROM qwen2.5:32b
PARAMETER num_ctx 32768
```

Depois criar:
```bash
ollama create qwen2.5-32k -f Modelfile
```

---

### 7. "gateway token mismatch"

**Causa:** `gateway.remote.token` nao corresponde a `gateway.auth.token`.

**Solucao:** Adicionar em `openclaw.json`:
```json
"gateway": {
  "auth": {
    "mode": "token",
    "token": "seu-token"
  },
  "remote": {
    "token": "seu-token"
  }
}
```

---

### 8. Telegram "access not configured" / pairing required

**Causa:** Usuario nao esta aprovado no bot.

**Solucao:**
1. Usuario envia mensagem para o bot
2. Bot retorna codigo de pairing (ex: `DJX5TL6K`)
3. Aprovar no container:
```bash
docker compose exec openclaw-gateway node /app/openclaw.mjs pairing approve telegram <CODIGO>
```

---

### 9. Config Telegram com chave errada

**Causa:** Usar `token` ao inves de `botToken`.

**Errado:**
```json
"telegram": { "token": "xxx" }
```

**Correto:**
```json
"channels": {
  "telegram": {
    "botToken": "xxx"
  }
}
```

---

### 10. Telegram 401 Unauthorized

**Causa:** Token do bot expirado, revogado ou incorreto.

**Sintoma no log:**
```
[telegram] setMyCommands failed: Call to 'setMyCommands' failed! (401: Unauthorized)
[telegram] [default] channel exited: Call to 'getMe' failed! (401: Unauthorized)
```

**Verificar token:**
```bash
curl -s "https://api.telegram.org/bot<SEU_TOKEN>/getMe"
```

**Solucao:**
1. Abrir Telegram e falar com @BotFather
2. Usar `/mybots` → selecionar bot → `API Token`
3. Revogar token antigo e gerar novo
4. Atualizar em `openclaw.json`:
```json
"channels": {
  "telegram": {
    "botToken": "<NOVO_TOKEN>"
  }
}
```
5. Reiniciar gateway: `docker compose restart openclaw-gateway`

---

## Modelo Avancado: qwen-agentic (Tool-Tuned)

Baseado no [guia do Thomas Hegghammer](https://gist.github.com/Hegghammer/86d2070c0be8b3c62083d6653ad27c23).

### Requisitos
- **VRAM:** 24-48GB
- **Modelo base:** Qwen 2.5 72B Q3_K_M (37GB)

### Modelfile (qwen-agentic.Modelfile)
```
FROM qwen2.5:72b-instruct-q3_K_M

PARAMETER num_ctx 16384

SYSTEM """You are a helpful assistant with access to tools.

CRITICAL TOOL BEHAVIOR:
- When you have tools available, USE THEM directly without asking for confirmation
- Don't describe what you could do — just do it
- Never say "I don't have access to X" when you have a tool that provides X
- Execute the task, then report results

Be concise. Act decisively. Don't ask permission for routine tool use."""
```

### Criar modelo
```bash
ollama pull qwen2.5:72b-instruct-q3_K_M
ollama create qwen-agentic -f qwen-agentic.Modelfile
```

### Configuracao OpenClaw
```json
{
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "http://localhost:11434/v1",
        "apiKey": "ollama",
        "api": "openai-completions",
        "models": [{
          "id": "qwen-agentic:latest",
          "name": "Qwen 2.5 72B Agentic",
          "contextWindow": 16384,
          "maxTokens": 8192
        }]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/qwen-agentic:latest"
      }
    }
  }
}
```

### Variaveis de ambiente Ollama (recomendadas)
```bash
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_CONTEXT_LENGTH=16384
```

### Performance medida (qwen-agentic 72B Q3)

| Hardware | Tokens/s | Observacao |
|----------|----------|------------|
| 2x RTX 3090 (48GB) | ~16 tok/s | Estimativa do autor |
| NVIDIA GB10 (119GB unified) | **~5 tok/s** | Testado em 2026-02-02 |

**Nota:** A performance no GB10 ficou abaixo do esperado. Possiveis causas:
- Memoria unificada vs VRAM dedicada
- Overhead de quantizacao Q3_K_M
- Uso de swap (2.7GB durante teste)

**Uso de memoria durante inferencia:**
- Ollama container: ~15GB
- Gateway container: ~350MB
- RAM total usada: ~67GB / 119GB

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
| **qwen-agentic (72B Q3)** | Ollama | 37GB | Funciona (~5 tok/s) | Excelente | **Sim (tool-tuned)** |
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
