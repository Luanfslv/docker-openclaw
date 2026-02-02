<p align="center">
  <img src="assets/openclaw-banner.png" alt="OpenClaw - Personal AI Assistant" width="100%">
</p>

# 🦞 Docker OpenClaw

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-22-339933?logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Security Hardened](https://img.shields.io/badge/Security-Hardened-green?logo=shieldsdotio)](SECURITY.md)
[![Docs](https://img.shields.io/badge/Docs-docs.openclaw.ai-blue)](https://docs.openclaw.ai)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?logo=discord&logoColor=white)](https://discord.gg/clawd)

Setup Docker para o [OpenClaw](https://openclaw.ai) — seu assistente pessoal de IA. Qualquer SO. Qualquer plataforma. The lobster way. 🦞

> **OpenClaw** é um assistente de IA que roda na sua própria máquina. Ele se conecta a LLMs (Claude, GPT, Gemini, etc.), tem ferramentas (busca na web, execução de código, controle de navegador, canvas, voice) e conversa com você via Telegram, WhatsApp, Discord, Slack, webchat e mais. Este repo te dá um setup Docker pronto pra rodar com boas práticas de segurança já configuradas.

---

## ✨ Funcionalidades

- 🔒 **Segurança reforçada** — segue o [Checklist Top 10 de Segurança](SECURITY.md)
- 🐳 **Setup em um comando** — `docker compose up -d`
- 🔐 **Secrets via variáveis de ambiente** — sem credenciais em texto puro nos arquivos de config
- 👤 **Container não-root** — roda como usuário sem privilégios `openclaw`
- 📝 **Logging habilitado** — trilha de auditoria por padrão
- 📱 **Multi-canal** — Telegram, WhatsApp, Discord, Slack, Signal, iMessage, Google Chat, Teams, Matrix, webchat e mais
- 🎙️ **Voice Wake + Talk Mode** — sempre ativo para fala (macOS/iOS/Android)
- 🎨 **Live Canvas com A2UI** — workspaces visuais para o agente
- 🌐 **Browser Control** — automação de navegador com CDP
- 🛠️ **Skills Platform** — skills bundled, managed e customizados
- 🧠 **200+ modelos via OpenRouter** — Claude, GPT, Gemini, Llama, DeepSeek e mais com uma única API key
- 🪟 **Compatível com Windows** — `.gitattributes` força terminações LF, Dockerfile corrige CRLF
- 🔄 **Auto-restart** — política de reinício `unless-stopped`
- 🌐 **Rede segura** — gateway vinculado ao loopback, isolamento de rede Docker disponível

---

## 📋 Pré-requisitos

| Plataforma | Requisito | Instalação |
|------------|-----------|------------|
| **Windows** | Docker Desktop | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |
| **Windows** | Git | [git-scm.com](https://git-scm.com/download/win) |
| **Mac** | Docker Desktop | [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) |
| **Linux** | Docker Engine + Compose V2 | Ver instruções abaixo |

---

## 🐳 Instalação do Docker

### Windows

1. **Baixe o Docker Desktop:**
   - Acesse [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
   - Clique em "Download for Windows"

2. **Execute o instalador:**
   - Abra o arquivo `.exe` baixado
   - Aceite os termos e siga o wizard de instalação
   - O instalador vai pedir para habilitar o **WSL 2** — aceite

3. **Reinicie o computador** (se solicitado)

4. **Inicie o Docker Desktop:**
   - Abra pelo menu Iniciar
   - Espere até aparecer "Docker is running" (ícone 🐳 na bandeja do sistema)

5. **Verifique a instalação:**
   ```powershell
   docker --version
   docker compose version
   ```

> ⚠️ **WSL 2 não instalado?** Se o Docker Desktop pedir para instalar o WSL 2, siga as instruções na tela. Isso é necessário para rodar containers Linux no Windows.

> ⚠️ **Erro "WSL docker-desktop Stopped"?** Abra o Docker Desktop pelo menu Iniciar — ele inicia o WSL automaticamente.

### Linux (Ubuntu/Debian)

O Docker Compose V2 já vem integrado ao Docker Engine (comando `docker compose`, sem hífen).

1. **Instale o Docker** (script oficial):
   ```bash
   curl -fsSL https://get.docker.com | sh
   ```

2. **Inicie o serviço:**
   ```bash
   sudo systemctl start docker
   ```

3. **Habilite no boot:**
   ```bash
   sudo systemctl enable docker
   ```

4. **Verifique se está rodando:**
   ```bash
   sudo systemctl status docker
   ```
   > Deve mostrar `Active: active (running)`. Pressione `q` para sair.

5. **Adicione seu usuário ao grupo docker** (para rodar sem `sudo`):
   ```bash
   sudo usermod -aG docker $USER
   ```

6. **Faça logout e login novamente** para aplicar a mudança

7. **Verifique a instalação:**
   ```bash
   docker --version
   docker compose version
   docker ps  # Deve mostrar lista vazia (sem erro)
   ```

### Mac

1. **Baixe o Docker Desktop:**
   - Acesse [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
   - Escolha a versão para seu chip (Intel ou Apple Silicon)

2. **Arraste para Applications** e abra o Docker Desktop

3. **Verifique a instalação:**
   ```bash
   docker --version
   docker compose version
   ```

---

## 🚀 Início Rápido

### Passo 1: Clone o repo

**Linux / Mac:**
```bash
git clone https://github.com/inematds/docker-openclaw.git
cd docker-openclaw
```

**Windows (CMD):**
```cmd
git clone https://github.com/inematds/docker-openclaw.git
cd docker-openclaw
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/inematds/docker-openclaw.git
cd docker-openclaw
```

### Passo 2: Configure o ambiente

**Linux / Mac:**
```bash
cp .env.example .env
nano .env  # Fill in your API keys
```

**Windows (CMD):**
```cmd
copy .env.example .env
notepad .env
```

**Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
notepad .env
```

> ⚠️ **IMPORTANTE:** Você **PRECISA** criar E editar o arquivo `.env` antes de rodar `docker compose up`. O container não vai funcionar com os valores de exemplo.

Abra o arquivo `.env` e substitua os valores de exemplo pelas suas chaves reais:

```env
# ❌ ERRADO — esses são placeholders, não vão funcionar:
OPENROUTER_API_KEY=sk-or-your-key-here
GATEWAY_AUTH_TOKEN=your-secure-token-here

# ✅ CERTO — suas chaves reais:
OPENROUTER_API_KEY=sk-or-v1-abc123-your-actual-real-key
GATEWAY_AUTH_TOKEN=a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6
DEFAULT_MODEL=openrouter/anthropic/claude-sonnet-4.5
```

### Passo 3: Gere um token seguro para o gateway

O `GATEWAY_AUTH_TOKEN` protege a API do seu gateway contra acesso não autorizado. Gere um aleatório:

**Linux / Mac:**
```bash
openssl rand -hex 24
```

**Windows (PowerShell):**
```powershell
-join ((1..48) | ForEach-Object { '{0:x}' -f (Get-Random -Max 16) })
```

**Ou** use qualquer string aleatória longa (pelo menos 24 caracteres). Você pode usar um gerenciador de senhas para gerar uma.

Copie o token gerado para o seu arquivo `.env` como `GATEWAY_AUTH_TOKEN`.

### Passo 4: Configure sua chave OpenRouter

Este setup usa **OpenRouter** como gateway unificado de LLMs. Com uma única API key, você tem acesso a 200+ modelos:

| Categoria | Modelos Disponíveis |
|-----------|---------------------|
| **Claude** | Opus 4.5, Sonnet 4.5, Haiku 3.5, etc. |
| **GPT** | GPT-4o, GPT-4 Turbo, o1-preview, etc. |
| **Gemini** | Gemini 2.0 Flash (FREE), Pro, etc. |
| **Open Source** | Qwen3 Coder 480B (FREE) ⭐, Llama 3.3 70B (FREE), etc. |

**Obtenha sua chave:**
1. Acesse [openrouter.ai](https://openrouter.ai/)
2. Faça login com Google/GitHub
3. Vá para [Keys](https://openrouter.ai/keys) e crie uma nova API key
4. Copie a key (começa com `sk-or-v1-...`)
5. Cole no seu `.env` como `OPENROUTER_API_KEY`

**Escolha seu modelo padrão:**

Edite `DEFAULT_MODEL` no `.env` para escolher qual modelo usar.

⚠️ **IMPORTANTE:** O formato correto é `openrouter/<provider>/<model>` (com o prefixo `openrouter/`)

```env
# Opção 1: Claude Sonnet 4.5 (melhor qualidade, recomendado) ⭐
DEFAULT_MODEL=openrouter/anthropic/claude-sonnet-4.5

# Opção 2: Claude Opus 4.5 (máximo poder)
DEFAULT_MODEL=openrouter/anthropic/claude-opus-4-5

# Opção 3: GPT-4o (excelente para código)
DEFAULT_MODEL=openrouter/openai/gpt-4o

# Opção 4: Qwen3 Coder 480B (GRÁTIS, melhor para código) 🆓 ⭐
DEFAULT_MODEL=openrouter/qwen/qwen3-coder:free

# Opção 5: Llama 3.3 70B (GRÁTIS, open source) 🆓
DEFAULT_MODEL=openrouter/meta-llama/llama-3.3-70b-instruct:free

# Opção 6: DeepSeek R1 (GRÁTIS, raciocínio avançado) 🆓
# ⚠️ NOTA: DeepSeek R1 usa tags <think> que podem causar problemas
DEFAULT_MODEL=openrouter/deepseek/deepseek-r1
```

> ⚠️ **ATENÇÃO:** NÃO esqueça do prefixo `openrouter/` no início! Sem ele o modelo não será reconhecido.

> 💡 **Dica:** Você pode trocar de modelo a qualquer momento editando o `.env` e executando:
> ```bash
> docker compose down -v && docker compose up -d
> ```

> 💰 **Modelos Grátis:** Qwen3 Coder 480B, Llama 3.3 70B e DeepSeek R1 são totalmente gratuitos no OpenRouter. Perfeito para testar!

> 📋 **Modelos Testados:** Veja [MODELOS-TESTADOS.md](MODELOS-TESTADOS.md) para documentação completa de modelos testados, problemas encontrados e recomendações.

> 📊 **Preços e limites:** Consulte [openrouter.ai/models](https://openrouter.ai/models) para ver preços, limites de contexto e velocidade de cada modelo.

### Passo 5: Build e execução

```bash
docker compose up -d
```

> 💡 **Primeira execução** leva alguns minutos para buildar a imagem (baixa Node.js, FFmpeg, Python, etc). As execuções seguintes iniciam instantaneamente.

> ⚠️ **Erro no Windows `open //./pipe/dockerDesktopLinuxEngine`?** O Docker Desktop não está rodando. Abra-o pelo menu Iniciar e espere até mostrar "Docker is running", depois tente novamente.

> ✨ **Configuração automática:** O script `entrypoint.sh` detecta automaticamente qual provedor de LLM você configurou no `.env` e cria a configuração ideal. Você **não precisa** editar arquivos JSON manualmente!

### Passo 6: Acesse o Webchat

Abra no seu navegador:
```
http://localhost:18789/chat
```

Quando solicitado, digite seu `GATEWAY_AUTH_TOKEN` do arquivo `.env` para autenticar.

> 💡 **Dica:** Você também pode acessar diretamente com: `http://localhost:18789/?token=SEU_TOKEN`

### Passo 7: Verifique o status

```bash
# Acompanhe os logs (Ctrl+C para parar)
docker compose logs -f

# Ou veja só as últimas 50 linhas
docker compose logs --tail 50
```

Você deve ver uma saída como:
```
🦞 First run — creating config from template...
🔑 Setting gateway auth token...
📱 Enabling Telegram...
🌐 Setting gateway bind to lan (required for Docker port mapping)...
📝 Configuring logging...
🦞 Starting OpenClaw...
```

### Passo 8: Configuração pós-instalação

Depois que o container estiver rodando, use esses comandos para ajustar seu setup:

```bash
# Auto-detecte e corrija problemas de config
docker exec openclaw openclaw doctor

# Verifique a saúde geral
docker exec openclaw openclaw gateway --verbose

# Atualize para a versão mais recente
docker exec openclaw openclaw update --channel stable
```

| Comando | O que faz |
|---------|-----------|
| `openclaw doctor` | Auto-detecta e mostra problemas de config |
| `openclaw update --channel stable` | Atualiza para a versão estável mais recente |
| `openclaw gateway --verbose` | Inicia gateway com logs detalhados |

---

## 💬 Comandos de Chat

Dentro das conversas (grupo ou DM), você pode usar estes comandos:

| Comando | Descrição |
|---------|-----------|
| `/status` | Status da sessão (modelo, tokens, custo) |
| `/new` ou `/reset` | Resetar sessão |
| `/compact` | Comprimir contexto |
| `/think <level>` | Controle de thinking (off/minimal/low/medium/high/xhigh) |
| `/verbose on\|off` | Toggle de verbosidade |
| `/usage off\|tokens\|full` | Relatório de uso |
| `/restart` | Reiniciar gateway (owner-only em grupos) |
| `/activation mention\|always` | Toggle de ativação em grupos |

---

## 📱 Configuração do Telegram

O Telegram é a forma mais fácil de falar com seu OpenClaw de qualquer lugar.

### Passo a passo:

1. **Crie um bot** — Abra o Telegram e mande mensagem pro [@BotFather](https://t.me/BotFather)
2. **Envie `/newbot`** — Siga as instruções para nomear seu bot
3. **Copie o token** — O BotFather te dá um token tipo `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`
4. **Adicione ao `.env`:**
   ```env
   TELEGRAM_BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
   ```
5. **Reinicie o container:**
   ```bash
   docker compose restart
   ```
6. **Mande mensagem pro seu bot** no Telegram — ele vai te dar um **código de pareamento**
7. **Aprove o pareamento** dentro do container:
   ```bash
   docker exec openclaw openclaw pairing approve telegram <code>
   ```

> 💡 O sistema de pareamento garante que só usuários aprovados possam falar com seu bot. É uma funcionalidade de segurança — sem aprovação, o bot não responde a estranhos.

---

## 📲 Configuração do WhatsApp

Você pode conectar o OpenClaw ao WhatsApp via pareamento por QR code.

### Passo a passo:

1. **Execute o comando de login:**
   ```bash
   docker exec -it openclaw openclaw channels login whatsapp
   ```
2. **Escaneie o QR code** com seu WhatsApp (Configurações → Aparelhos Conectados → Conectar um Aparelho)
3. **Pronto!** Seu OpenClaw agora está conectado ao WhatsApp

### ⚠️ Número Pessoal vs. Número Dedicado

**Usando seu número pessoal:**
- O bot vai ver mensagens de todos os seus contatos
- Por padrão, a política de DM é `pairing` — outros podem receber um prompt de pareamento
- **Recomendado:** Defina `dmPolicy: allowlist` com apenas o seu número

**Usando um número dedicado (recomendado):**
- Pegue um chip pré-pago barato ou um número do Google Voice
- Separação mais limpa entre mensagens pessoais e do bot

---

## 💜 Configuração do Discord

1. **Crie um bot no Discord Developer Portal:**
   - Acesse [discord.com/developers/applications](https://discord.com/developers/applications)
   - Crie uma nova aplicação
   - Vá em "Bot" → "Add Bot"
   - Copie o token

2. **Adicione ao `.env`:**
   ```env
   DISCORD_BOT_TOKEN=your-discord-token-here
   ```

3. **Reinicie o container:**
   ```bash
   docker compose restart
   ```

---

## 💼 Configuração do Slack

1. **Crie um Slack App:**
   - Acesse [api.slack.com/apps](https://api.slack.com/apps)
   - Crie um novo app
   - Adicione os scopes necessários (chat:write, etc.)
   - Instale no seu workspace
   - Copie o Bot Token (`xoxb-...`) e App Token (`xapp-...`)

2. **Adicione ao `.env`:**
   ```env
   SLACK_BOT_TOKEN=xoxb-your-bot-token
   SLACK_APP_TOKEN=xapp-your-app-token
   ```

3. **Reinicie o container:**
   ```bash
   docker compose restart
   ```

---

## 🔒 Segurança

Este setup Docker implementa **7 de 10** medidas de hardening de segurança automaticamente. Veja o [SECURITY.md](SECURITY.md) para o checklist completo.

### O que o Docker faz automaticamente:
| Proteção | Status |
|----------|--------|
| Gateway vinculado apenas ao `127.0.0.1` (lado do host) | ✅ Automático |
| Política de DM requer aprovação de pareamento | ✅ Automático |
| Arquivos de config com `chmod 600` | ✅ Automático |
| Container roda como usuário não-root | ✅ Automático |
| Sem escalação de privilégios (`no-new-privileges`) | ✅ Automático |
| Logging e diagnósticos habilitados | ✅ Automático |
| Secrets via variáveis de ambiente | ✅ Automático |

### Auditoria de segurança:
```bash
docker exec openclaw openclaw doctor
```

---

## 📦 Volumes

Volumes Docker persistem seus dados entre reinícios e rebuilds do container.

| Volume | Caminho no Container | Finalidade |
|--------|---------------------|------------|
| `openclaw-data` | `/home/openclaw/.openclaw` | Config, dados de sessão, tokens de auth, info de pareamento |
| `openclaw-workspace` | `/home/openclaw/workspace` | Workspace do agente — AGENTS.md, SOUL.md, skills, arquivos de projeto |
| `openclaw-logs` | `/home/openclaw/logs` | Arquivos de log (NÃO em /tmp — sobrevive a reinícios) |

### Faça backup dos seus dados:
```bash
# Backup de todos os volumes
docker run --rm -v openclaw-data:/data -v $(pwd):/backup alpine tar czf /backup/openclaw-data.tar.gz -C /data .
docker run --rm -v openclaw-workspace:/data -v $(pwd):/backup alpine tar czf /backup/openclaw-workspace.tar.gz -C /data .
```

### Resetar tudo:
```bash
docker compose down -v  # ⚠️ Apaga TODOS os dados incluindo config e workspace
```

---

## 🛠️ Comandos Úteis

```bash
# === Ciclo de vida ===
docker compose up -d              # Start in background
docker compose down               # Stop and remove container
docker compose restart            # Restart
docker compose stop               # Stop without removing

# === Logs ===
docker compose logs -f            # Follow logs (Ctrl+C to stop)
docker compose logs --tail 100    # Last 100 lines

# === Acesso ao shell ===
docker compose exec openclaw bash  # Open shell inside container

# === OpenClaw CLI ===
docker exec openclaw openclaw doctor            # Check for issues
docker exec openclaw openclaw update --channel stable  # Update to latest

# === Atualizar OpenClaw ===
docker compose build --no-cache   # Rebuild image (pulls latest openclaw)
docker compose up -d              # Restart with new image

# === Limpeza ===
docker system prune -a            # Remove unused images (reclaim disk space)
```

---

## 🖥️ Acesso ao Webchat (Remoto)

O gateway é vinculado ao `127.0.0.1` (apenas loopback). Para acessar o webchat de outra máquina, use um **túnel SSH**:

```bash
# Na sua máquina local (a que tem o navegador):
ssh -L 18789:localhost:18789 user@your-server-ip

# Depois abra no navegador:
# http://127.0.0.1:18789/chat
```

Esta é a forma mais segura de acessar a interface web remotamente — sem portas expostas, todo tráfego criptografado via SSH.

### Alternativa: Tailscale (recomendado para uso frequente)

O OpenClaw tem suporte nativo a Tailscale. Configure `gateway.tailscale.mode`:

- `off` — sem automação (padrão)
- `serve` — HTTPS apenas na tailnet
- `funnel` — HTTPS público (requer autenticação por senha)

```bash
# No seu servidor:
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Acesse o webchat via: http://<tailscale-ip>:18789/chat
```

---

## 🔧 Solução de Problemas

### Problemas no Windows

| Erro | Causa | Solução |
|------|-------|---------|
| `open //./pipe/dockerDesktopLinuxEngine: O sistema não pode encontrar o arquivo` | Docker Desktop não está rodando | Abra o Docker Desktop pelo menu Iniciar, espere por "Docker is running" |
| `.env not found` | Arquivo de config faltando | Execute `copy .env.example .env` e depois `notepad .env` |
| `WSL docker-desktop Stopped` | WSL não iniciou | Abra o Docker Desktop — ele inicia o WSL automaticamente |
| Build trava ou falha | RAM insuficiente | Docker Desktop → Settings → Resources → aumente para 4GB+ |
| `exec entrypoint.sh: no such file or directory` | Terminações de linha CRLF do Windows | Clone o repo novamente: `git config --global core.autocrlf input` e depois `git clone` |

### Problemas no Linux / Mac

| Erro | Causa | Solução |
|------|-------|---------|
| `permission denied` | Não está no grupo docker | `sudo usermod -aG docker $USER` e depois **faça logout e login novamente** |
| `port already in use` | Outro serviço na porta 18789 | Mude a porta no `docker-compose.yml` ou pare o outro serviço |
| `no space left on device` | Disco cheio | `docker system prune -a` para limpar imagens antigas |

### Problemas de Túnel SSH / Acesso Remoto

Se você não consegue acessar o webchat localmente na sua máquina após criar um túnel SSH, siga estes passos:

**1. Remova a chave SSH antiga (se o IP do servidor mudou):**
```bash
ssh-keygen -R seu-servidor-ip
```

**2. Teste a conexão SSH:**
```bash
ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes usuario@seu-servidor-ip "echo 'Conexão SSH OK!' && hostname"
```

> 💡 Se falhar, adicione sua chave pública ao `~/.ssh/authorized_keys` do servidor.

**3. Crie o túnel SSH:**
```bash
# Túnel em foreground (fecha quando você sair do terminal)
ssh -L 18789:127.0.0.1:18789 usuario@seu-servidor-ip

# Túnel em background (roda silenciosamente)
ssh -f -N -L 18789:127.0.0.1:18789 usuario@seu-servidor-ip
```

**4. Acesse o webchat:**
```
http://127.0.0.1:18789/chat
```

| Problema | Causa | Solução |
|----------|-------|---------|
| `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED` | IP do servidor mudou ou reinstalou | `ssh-keygen -R seu-servidor-ip` e reconecte |
| `Permission denied (publickey)` | Chave SSH não configurada | Adicione sua chave pública ao servidor: `ssh-copy-id usuario@servidor` |
| `Connection refused` na porta 18789 | Túnel não criado ou container parado | Verifique se o túnel está ativo e se o container está rodando |
| `bind: Address already in use` | Porta local já em uso | Use outra porta: `ssh -L 18790:127.0.0.1:18789 ...` e acesse via `http://127.0.0.1:18790/chat` |

### Problemas de Configuração

| Problema | Causa | Solução |
|----------|-------|---------|
| **"Unknown model: anthropic/claude-sonnet-4.5"** | Falta o prefixo `openrouter/` | Use `openrouter/anthropic/claude-sonnet-4.5` (sempre inclua o prefixo `openrouter/`) |
| **Bot não responde após mudar o modelo** | Config corrompida ou modelo inválido | Execute `docker compose down -v` (⚠️ apaga dados), depois `docker compose up -d` para começar do zero |
| **Mudanças no .env não aplicadas** | `docker compose restart` não recarrega variáveis de ambiente | Use `docker compose down && docker compose up -d` para recarregar o `.env` |

---

## 🔄 Migração do Moltbot/Clawdbot

Se você está vindo do setup antigo `docker-moltbot` ou `docker-clawdbot`, aqui está o que mudou:

### O que é diferente:

| Antigo (Moltbot/Clawdbot) | Novo (OpenClaw) |
|---------------------------|-----------------|
| Pacote: `clawdbot` / `moltbot` | Pacote: `openclaw` |
| CLI: `clawdbot` / `moltbot` | CLI: `openclaw` |
| Dir de config: `~/.clawdbot` / `~/.moltbot` | Dir de config: `~/.openclaw` |
| Docs: `docs.molt.bot` | Docs: `docs.openclaw.ai` |
| Container: `moltbot` | Container: `openclaw` |

### Passos da migração:

1. **Faça backup dos seus dados:**
   ```bash
   # Do setup antigo
   cd docker-moltbot
   docker run --rm -v moltbot-data:/data -v $(pwd):/backup alpine tar czf /backup/moltbot-data-backup.tar.gz -C /data .
   ```

2. **Pare o container antigo:**
   ```bash
   docker compose down
   ```

3. **Clone o novo repo:**
   ```bash
   git clone https://github.com/inematds/docker-openclaw.git
   cd docker-openclaw
   ```

4. **Copie seu .env:**
   ```bash
   cp ../docker-moltbot/.env .env
   ```

5. **Inicie o novo container:**
   ```bash
   docker compose up -d
   ```

---

## 💻 Requisitos

| Recurso | Mínimo | Recomendado |
|---------|--------|-------------|
| **RAM** | 2 GB | 4 GB (com Whisper) |
| **Disco** | 5 GB | 10+ GB |
| **CPU** | 1 core | 2+ cores |
| **Docker** | Engine 24+ / Compose v2+ | Última versão estável |
| **SO** | Linux, macOS, Windows 10+ | Ubuntu 22.04+ / macOS 13+ |
| **Rede** | Acesso à internet | Banda larga estável |

---

## 🤝 Contribuindo

PRs são bem-vindos! Siga o checklist de segurança em [SECURITY.md](SECURITY.md).

1. Faça fork do repo
2. Crie uma branch de feature: `git checkout -b my-feature`
3. Faça commit das suas mudanças: `git commit -m 'Add my feature'`
4. Faça push: `git push origin my-feature`
5. Abra um Pull Request

---

## 📜 Licença

[MIT](LICENSE) — use como quiser.

---

<p align="center">
  <a href="https://openclaw.ai">openclaw.ai</a> •
  <a href="https://docs.openclaw.ai">Documentação</a> •
  <a href="https://discord.gg/clawd">Discord</a> •
  <a href="https://github.com/openclaw/openclaw">GitHub</a>
</p>
