# E2B Sandbox Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                          HOST SYSTEM                                 │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              Claude Code Orchestration System               │   │
│  │                                                              │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │   │
│  │  │  Claude  │  │  Coder   │  │  Tester  │  │ Planner  │  │   │
│  │  │   (200k  │  │ Subagent │  │ Subagent │  │ Subagent │  │   │
│  │  │ context) │  │(Ctx7 +   │  │(Play-    │  │(TASK-    │  │   │
│  │  │          │  │ ctxkit)  │  │wright)   │  │MASTER)   │  │   │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  │   │
│  │       │             │             │             │          │   │
│  │       └─────────────┴─────────────┴─────────────┘          │   │
│  │                            │                                │   │
│  └────────────────────────────┼────────────────────────────────┘   │
│                               │                                     │
│                               ▼                                     │
│         ┌─────────────────────────────────────────────┐            │
│         │         start-e2b-sandbox.sh                 │            │
│         │  (Launcher with environment detection)       │            │
│         └─────────────────┬───────────────────────────┘            │
│                           │                                         │
└───────────────────────────┼─────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    E2B DOCKER CONTAINER                              │
│                   (Isolated Sandbox)                                 │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              docker-entrypoint.sh                           │   │
│  │  • Environment checks (GITHUB_TOKEN)                        │   │
│  │  • System information display                               │   │
│  │  • MCP server status                                        │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              GitHub Copilot CLI                             │   │
│  │  • Natural language code generation                         │   │
│  │  • Git operations                                           │   │
│  │  • Repository navigation                                    │   │
│  │  • Command suggestions                                      │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              Node.js 22 + npm 10                            │   │
│  │  • Modern JavaScript runtime                                │   │
│  │  • Package management                                       │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              Mounted Workspace                              │   │
│  │  /workspace -> Host project directory                       │   │
│  │  (Read/Write access to project files)                       │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────┬────────────────────────────────────┬───────────────────┘
              │                                    │
              │ Port 8080                         │ Port 8081
              ▼                                    ▼
┌─────────────────────────┐          ┌─────────────────────────┐
│   Awesome Copilot MCP   │          │   Additional MCP        │
│       Server            │          │     Services            │
│                         │          │                         │
│ • Search instructions   │          │ • Playwright MCP        │
│ • Load instructions     │          │ • Context7 MCP          │
│ • Browse categories     │          │ • ctxkit MCP            │
│ • Preview content       │          │ • Custom MCPs           │
└─────────────────────────┘          └─────────────────────────┘
```

## Component Details

### 1. Host System Layer

**Claude Code Orchestration**
- 200k context window for big picture management
- Coordinates all subagents
- Delegates tasks to E2B sandbox for safe execution

**Subagents**
- **Coder**: Implements features with self-service docs (Context7 + ctxkit MCP)
- **Tester**: Verifies implementations (can use E2B sandbox with Playwright)
- **Planner**: AI-powered project planning (TASKMASTER CLI)

**Launcher Script**
- `start-e2b-sandbox.sh`: One-command setup
- Checks Docker installation
- Auto-builds image if needed
- Detects and passes environment variables

### 2. E2B Container Layer

**Base Image**
- Node.js 22 (bullseye-slim)
- Minimal Debian base for security

**Entry Point**
- `docker-entrypoint.sh`: Container initialization
- Environment validation
- User-friendly status messages

**GitHub Copilot CLI**
- Installed at runtime
- Natural language interface for code operations
- Integrated with GitHub authentication

**Workspace**
- Mounted from host system
- Access to project files
- Changes persist on host

### 3. MCP Server Layer

**Port 8080: Awesome Copilot MCP**
- Community prompts and instructions
- Search and load capabilities
- Integration with awesome-copilot repository

**Port 8081: Additional Services**
- Playwright for visual testing
- Jina AI for web research
- Extensible for custom MCPs

## Data Flow

### Code Generation Workflow

```
1. User Request
   └─> Claude (Orchestrator)
       └─> Creates todo list
           └─> Delegates to Coder Subagent
               └─> Generates code
                   └─> Requests E2B sandbox for safe execution
                       ├─> E2B Container
                       │   ├─> GitHub Copilot CLI analyzes
                       │   ├─> Code executes safely
                       │   └─> Results returned
                       └─> Tester Subagent verifies
                           └─> Success/Failure reported to Claude
```

### MCP Integration Workflow

```
1. Documentation Lookup
   └─> Coder Agent
       └─> Context7 or ctxkit MCP Server
           ├─> Framework docs (Context7)
           ├─> llm.txt discovery (ctxkit)
           └─> Results returned to Coder

2. Visual Testing Request
   └─> Tester Subagent
       └─> E2B Container
           └─> Playwright MCP
               ├─> Browser automation
               ├─> Screenshots captured
               └─> Results verified

3. Prompt Discovery Request
   └─> Developer/Agent
       └─> Awesome Copilot MCP (port 8080)
           ├─> Search instructions
           ├─> Load instruction
           └─> Apply to workflow
```

## Security Model

### Isolation Layers

```
┌─────────────────────────────────────────┐
│         Host System (Protected)         │
│  • Main project files (original)       │
│  • User credentials (secure)           │
│  • System resources (limited access)   │
└──────────────┬──────────────────────────┘
               │ Volume Mount (controlled)
               ▼
┌─────────────────────────────────────────┐
│      E2B Container (Isolated)           │
│  • Sandboxed execution                 │
│  • Limited file system                 │
│  • Network restrictions possible       │
│  • Process isolation                   │
└─────────────────────────────────────────┘
```

### Security Features

1. **Container Isolation**
   - Process isolation via Docker
   - File system boundaries
   - Network namespace separation

2. **Credential Management**
   - Environment variables (not hardcoded)
   - No secrets in image layers
   - .gitignore prevents commits

3. **Minimal Attack Surface**
   - Slim base image
   - Only required packages
   - Runtime installation of tools

## Configuration Files

### Core Configuration

```
.mcp.json
├─ playwright (local MCP)
├─ context7 (MCP for documentation)
├─ ctxkit (MCP for llm.txt discovery)
├─ sequential-thinking (Official Anthropic MCP)
└─ awesome-copilot (remote MCP, disabled by default)

e2b-sandbox.config.json
├─ sandbox metadata
├─ environment variables
├─ startup procedures
└─ MCP server definitions

Dockerfile.e2b
├─ base image (node:22-bullseye-slim)
├─ system dependencies
├─ workspace setup
└─ entry point configuration
```

## Usage Patterns

### Pattern 1: Safe Code Execution

```bash
# Host
./start-e2b-sandbox.sh

# Container
npm install -g @github/copilot
copilot /login
copilot -p "generate a Python script"
# Execute safely in sandbox
python generated_script.py
```

### Pattern 2: Integrated Development

```bash
# Host: Claude Code
claude

# User: "Build a feature with latest best practices"
# Claude: Creates todos
# Coder: Self-service docs via Context7/ctxkit, generates code
# Coder: Requests E2B for testing if needed
# E2B: Copilot CLI analyzes, executes, reports
# Tester: Verifies with Playwright MCP
# Claude: Marks complete, moves to next todo
```

### Pattern 3: Prompt Discovery

```bash
# Host: Start Awesome Copilot MCP
docker run -p 8080:8080 awesome-copilot:latest

# Enable in .mcp.json
"awesome-copilot": { "disabled": false }

# Use in Claude Code or directly
# Search for prompts, load instructions, apply to workflow
```

## Scalability & Extension

### Horizontal Scaling

```
Multiple E2B Containers
├─ Container 1: Development tasks
├─ Container 2: Testing tasks
├─ Container 3: Research tasks
└─ Container N: Specialized tasks
```

### Vertical Extension

```
Additional MCP Servers
├─ Database MCP (PostgreSQL, MongoDB)
├─ Cloud Provider MCP (AWS, Azure, GCP)
├─ Custom Domain MCP (your specific needs)
└─ Community MCPs (explore & integrate)
```

## Deployment Options

### Option 1: Local Docker
- Development & testing
- Full control
- Free

### Option 2: E2B Cloud
- Managed infrastructure
- Fast spin-up (<200ms)
- Scalable
- Team collaboration

### Option 3: Hybrid
- Local for development
- E2B Cloud for production
- CI/CD integration

## Monitoring & Debugging

### Container Logs

```bash
# View real-time logs
docker logs -f alex-copilot-sandbox

# Inspect container
docker inspect alex-stack-e2b:latest

# Enter running container
docker exec -it alex-copilot-sandbox bash
```

### MCP Server Health

```bash
# Check Awesome Copilot MCP
curl http://localhost:8080/health

# Check Context7 MCP (if accessible)
# (Check via Claude Code MCP: List Servers)

# Playwright MCP status
# (Check via Claude Code MCP: List Servers)
```

## Performance Characteristics

### Startup Times
- Docker build: ~100 seconds (first time)
- Container start: <5 seconds
- Copilot CLI ready: <10 seconds

### Resource Usage
- Base image: ~200MB
- With Copilot: ~300MB
- Memory: ~512MB recommended
- CPU: 1 core minimum

## Troubleshooting Flow

```
Issue Detected
    ├─> Container won't start
    │   └─> Check Docker status
    │       └─> Verify image exists
    │           └─> Rebuild if needed
    │
    ├─> Copilot CLI fails
    │   └─> Check GITHUB_TOKEN
    │       └─> Re-authenticate
    │           └─> Verify network
    │
    └─> MCP server unreachable
        └─> Check port mappings
            └─> Verify server running
                └─> Check firewall rules
```

## Future Enhancements

### Phase 2
- [ ] E2B Cloud templates
- [ ] Pre-built images on registry
- [ ] GitHub Actions integration

### Phase 3
- [ ] Multi-language support
- [ ] Team collaboration features
- [ ] Enhanced monitoring

### Phase 4
- [ ] AI-powered optimization
- [ ] Auto-scaling capabilities
- [ ] Advanced security features

---

**Last Updated:** November 6, 2025  
**Version:** 1.0.0  
**Status:** Production Ready
