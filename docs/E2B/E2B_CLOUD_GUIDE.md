# E2B Cloud Sandbox with Docker MCP Gateway Integration

Complete guide for using E2B Cloud sandboxes with Docker MCP Gateway and GitHub Copilot CLI.

## 🎯 Overview

This implementation provides **cloud-based sandboxes** powered by E2B with native Docker MCP Gateway integration, giving you:

- ☁️ **Cloud-managed sandboxes** - No local Docker required
- 🔌 **200+ MCP tools** - GitHub, Notion, Browserbase, and more
- 🤖 **GitHub Copilot CLI** - Pre-installed and ready to use
- 🔒 **Secure execution** - Isolated environments with audit trails
- ⚡ **Fast spin-up** - Sandboxes ready in <200ms

## 🆚 Local Docker vs E2B Cloud

| Feature | Local Docker Container | E2B Cloud Sandbox |
|---------|----------------------|-------------------|
| **Hosting** | Your machine | E2B Cloud |
| **MCP Gateway** | Manual config | Automatic |
| **MCP Tools** | 3 servers (manual) | 200+ servers (automated) |
| **Setup Time** | Minutes | Seconds |
| **Cost** | Free | Free tier + paid plans |
| **Scaling** | Limited by hardware | Unlimited |
| **Best For** | Development, testing | Production, collaboration |

## 📋 Prerequisites

1. **E2B Account & API Key**
   - Sign up at [e2b.dev](https://e2b.dev)
   - Get API key from [dashboard](https://e2b.dev/dashboard)

2. **GitHub Token** (for Copilot CLI and GitHub MCP)
   - Generate at [github.com/settings/tokens](https://github.com/settings/tokens)
   - Required scopes: `repo`, `read:org`, `user`

3. **Node.js 18+**
   - Check: `node --version`

4. **Optional: Additional API Keys**
   - Jina AI: [jina.ai](https://jina.ai)
   - Notion: [notion.so/my-integrations](https://www.notion.so/my-integrations)
   - Browserbase: [browserbase.com](https://browserbase.com)

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```bash
# Required
E2B_API_KEY=e2b_xxx...
GITHUB_TOKEN=ghp_xxx...

# Optional - for additional MCP servers
JINA_API_KEY=jina_xxx...
NOTION_API_KEY=secret_xxx...
BROWSERBASE_API_KEY=xxx...
BROWSERBASE_PROJECT_ID=xxx...
```

### 3. Create Your First Sandbox

```bash
npm run create-sandbox
```

This will:
1. ✅ Create E2B Cloud sandbox
2. ✅ Enable Docker MCP Gateway
3. ✅ Configure MCP servers (GitHub, Jina, etc.)
4. ✅ Install GitHub Copilot CLI
5. ✅ Provide connection details

## 📖 Usage Examples

### Example 1: Create Sandbox Programmatically

```javascript
import { createSandbox } from './src/e2b-cloud-sandbox.js';

// Create sandbox
const sandbox = await createSandbox();

// Get MCP Gateway details
const mcpUrl = sandbox.getMcpUrl();
const mcpToken = await sandbox.getMcpToken();

console.log('MCP Gateway URL:', mcpUrl);

// Run commands in sandbox
const result = await sandbox.commands.run('ls -la');
console.log(result.stdout);

// Use Copilot CLI
await sandbox.commands.run('copilot suggest -p "create a React component"');

// Clean up
await sandbox.close();
```

### Example 2: Use MCP Tools from Sandbox

```javascript
import { Sandbox } from 'e2b';

const sandbox = await Sandbox.create({
  apiKey: process.env.E2B_API_KEY,
  mcp: {
    github: { token: process.env.GITHUB_TOKEN },
    jina: { apiKey: process.env.JINA_API_KEY }
  }
});

// GitHub MCP: Create an issue
await sandbox.commands.run(`
  curl -X POST ${sandbox.getMcpUrl()}/tools/github/create-issue \\
    -H "Authorization: Bearer ${await sandbox.getMcpToken()}" \\
    -d '{"repo":"owner/repo","title":"Test Issue","body":"Created via MCP"}'
`);

// Jina MCP: Search the web
await sandbox.commands.run(`
  curl -X POST ${sandbox.getMcpUrl()}/tools/jina/search \\
    -H "Authorization: Bearer ${await sandbox.getMcpToken()}" \\
    -d '{"query":"E2B Docker MCP integration"}'
`);

await sandbox.close();
```

### Example 3: Interactive Copilot Session

```javascript
const sandbox = await createSandbox();

// Start interactive session
const session = await sandbox.commands.run(
  'copilot',
  { 
    timeoutMs: 0, // No timeout for interactive
    onStdout: (data) => process.stdout.write(data.line),
    onStderr: (data) => process.stderr.write(data.line)
  }
);

// Copilot is now running interactively in the sandbox
// You can send commands to it via stdin
```

### Example 4: File Operations in Sandbox

```javascript
// Upload file to sandbox
await sandbox.files.write('script.js', `
  console.log('Hello from E2B sandbox!');
  console.log('MCP Gateway:', process.env.MCP_GATEWAY_URL);
`);

// Execute file
const result = await sandbox.commands.run('node script.js');
console.log(result.stdout);

// Download file from sandbox
const content = await sandbox.files.read('output.txt');
console.log(content);
```

## 🔌 Available MCP Servers

When you create a sandbox, these MCP servers are automatically available:

### GitHub MCP Server
**Tools available:**
- Create/update issues
- Manage pull requests
- Search repositories
- Clone repos
- Execute git commands

**Configuration:**
```javascript
mcp: {
  github: { token: process.env.GITHUB_TOKEN }
}
```

### Jina AI MCP Server
**Tools available:**
- Web search (AI-powered)
- Content extraction (Jina Reader)
- Image search
- Semantic search
- Embeddings & reranking

**Configuration:**
```javascript
mcp: {
  jina: { apiKey: process.env.JINA_API_KEY }
}
```

### Notion MCP Server
**Tools available:**
- Query databases
- Create/update pages
- Search content
- Manage blocks

**Configuration:**
```javascript
mcp: {
  notion: { internalIntegrationToken: process.env.NOTION_API_KEY }
}
```

### Browserbase MCP Server
**Tools available:**
- Browser automation
- Screenshot capture
- Web scraping
- Session recording

**Configuration:**
```javascript
mcp: {
  browserbase: {
    apiKey: process.env.BROWSERBASE_API_KEY,
    projectId: process.env.BROWSERBASE_PROJECT_ID
  }
}
```

## 🎓 Advanced Usage

### Custom Sandbox Templates

Create custom templates with pre-installed tools:

```javascript
// 1. Create a custom Dockerfile
// Dockerfile.e2b-custom
FROM node:22-bullseye-slim
RUN npm install -g @github/copilot typescript tsx
RUN apt-get update && apt-get install -y python3 pip

// 2. Build and push to E2B
e2b template build -f Dockerfile.e2b-custom

// 3. Use custom template
const sandbox = await Sandbox.create({
  template: 'your-custom-template-id',
  mcp: { ... }
});
```

### Multiple Sandboxes for Parallel Work

```javascript
// Create multiple sandboxes
const sandboxes = await Promise.all([
  createSandbox(), // Sandbox 1
  createSandbox(), // Sandbox 2
  createSandbox()  // Sandbox 3
]);

// Run parallel tasks
const results = await Promise.all([
  sandboxes[0].commands.run('npm test'),
  sandboxes[1].commands.run('npm run build'),
  sandboxes[2].commands.run('npm run lint')
]);

// Cleanup all
await Promise.all(sandboxes.map(s => s.close()));
```

### Long-Running Processes

```javascript
// Start a server in the sandbox
const process = await sandbox.commands.run(
  'npm run dev',
  {
    timeoutMs: 0, // No timeout
    background: true // Run in background
  }
);

// Do other work while server runs
await sandbox.commands.run('npm run test');

// Stop the server
await process.kill();
```

### MCP Gateway Authentication

Access MCP tools from outside the sandbox:

```javascript
const mcpUrl = sandbox.getMcpUrl();
const mcpToken = await sandbox.getMcpToken();

// Use with curl
const response = await fetch(`${mcpUrl}/tools`, {
  headers: {
    'Authorization': `Bearer ${mcpToken}`
  }
});

const tools = await response.json();
console.log('Available tools:', tools);
```

## 🔒 Security Best Practices

1. **Never commit API keys**
   - Use `.env` files (already in `.gitignore`)
   - Use environment variables in CI/CD
   - Rotate keys regularly

2. **Sandbox isolation**
   - Each sandbox is fully isolated
   - No cross-sandbox access
   - Automatic cleanup on close

3. **MCP Gateway security**
   - Token-based authentication
   - Scoped permissions per tool
   - Audit logs in E2B dashboard

4. **Resource limits**
   - Set timeout limits
   - Monitor usage in dashboard
   - Use auto-cleanup

## 🐛 Troubleshooting

### Error: E2B_API_KEY is required

**Solution:**
```bash
# Check if .env file exists
cat .env

# Ensure E2B_API_KEY is set
export E2B_API_KEY="your-key-here"
```

### Error: Failed to install Copilot CLI

**Solution:**
```javascript
// Install manually in sandbox
await sandbox.commands.run('npm install -g @github/copilot', {
  timeoutMs: 180000 // Increase timeout
});
```

### Error: MCP Gateway not responding

**Solution:**
```javascript
// Check gateway status
const status = await sandbox.commands.run(
  'curl http://localhost:50005/mcp/health'
);
console.log(status.stdout);
```

### Sandbox timeout issues

**Solution:**
```javascript
// Increase timeout in .env
E2B_SANDBOX_TIMEOUT=600000  // 10 minutes

// Or per-sandbox
const sandbox = await Sandbox.create({
  timeoutMs: 600000,
  mcp: { ... }
});
```

## 📊 Monitoring & Costs

### Usage Dashboard

Monitor your sandboxes at [e2b.dev/dashboard](https://e2b.dev/dashboard):
- Active sandboxes
- Compute time used
- API calls made
- Cost breakdown

### Free Tier

E2B offers generous free tier:
- ✅ 100 hours/month compute time
- ✅ Unlimited sandboxes
- ✅ All MCP tools included

### Pricing

After free tier:
- $0.10 per hour compute time
- No per-sandbox fees
- Pay only for what you use

## 🔄 Migration from Local Docker

Already using the local Docker container? Here's how to migrate:

### What Stays the Same
- ✅ GitHub Copilot CLI commands
- ✅ Project files and structure
- ✅ MCP server concepts

### What Changes
- ❌ No `docker run` needed
- ❌ No manual MCP configuration
- ✅ Use SDK: `Sandbox.create()`
- ✅ Automatic MCP Gateway

### Migration Steps

1. **Install E2B SDK**
   ```bash
   npm install e2b
   ```

2. **Set E2B API Key**
   ```bash
   echo "E2B_API_KEY=your-key" >> .env
   ```

3. **Replace Docker commands**
   ```bash
   # Old: Local Docker
   ./start-e2b-sandbox.sh
   
   # New: E2B Cloud
   npm run create-sandbox
   ```

4. **Update scripts**
   ```javascript
   // Old: Direct Docker exec
   docker exec sandbox-id npm test
   
   // New: E2B SDK
   await sandbox.commands.run('npm test');
   ```

## 🤝 Integration with Claude Code

Use E2B sandboxes in your Claude Code orchestration:

```javascript
// In coder subagent
import { createSandbox } from './src/e2b-cloud-sandbox.js';

async function executeInSandbox(code) {
  const sandbox = await createSandbox();
  
  try {
    // Write code to sandbox
    await sandbox.files.write('task.js', code);
    
    // Execute with Copilot assistance
    const result = await sandbox.commands.run('node task.js');
    
    return {
      success: true,
      output: result.stdout,
      error: result.stderr
    };
  } finally {
    await sandbox.close();
  }
}
```

## 📚 Additional Resources

### Official Documentation
- [E2B Documentation](https://e2b.dev/docs)
- [E2B MCP Integration](https://e2b.dev/docs/mcp)
- [Docker MCP Catalog](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
- [GitHub Copilot CLI](https://docs.github.com/copilot/cli)

### Example Projects
- [E2B MCP Demo](https://github.com/e2b-dev/mcp-demo)
- [E2B Cookbook](https://e2b.dev/docs/examples)

### Community
- [E2B Discord](https://discord.gg/U7KEcGErtQ)
- [GitHub Discussions](https://github.com/e2b-dev/e2b/discussions)

## 🎯 Next Steps

1. ✅ Create your first sandbox: `npm run create-sandbox`
2. ✅ Try Copilot CLI in the cloud
3. ✅ Explore MCP tools
4. ✅ Build automated workflows
5. ✅ Deploy to production

---

**Questions?** Check the [troubleshooting section](#-troubleshooting) or open an issue on GitHub.

**Ready to scale?** Upgrade your E2B plan at [e2b.dev/pricing](https://e2b.dev/pricing).
