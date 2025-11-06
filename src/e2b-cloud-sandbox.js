#!/usr/bin/env node

/**
 * E2B Cloud Sandbox with Docker MCP Gateway Integration
 * 
 * This script creates and manages E2B Cloud sandboxes with:
 * - Docker MCP Gateway for 200+ verified tools
 * - GitHub Copilot CLI pre-installed
 * - Automatic MCP server orchestration
 * 
 * Usage:
 *   node e2b-cloud-sandbox.js create    - Create new sandbox with MCP gateway
 *   node e2b-cloud-sandbox.js list      - List active sandboxes
 */

import { Sandbox } from 'e2b';
import * as dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Load environment variables
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: join(__dirname, '..', '.env') });

// Configuration
const config = {
  e2bApiKey: process.env.E2B_API_KEY,
  githubToken: process.env.GITHUB_TOKEN,
  jinaApiKey: process.env.JINA_API_KEY,
  notionApiKey: process.env.NOTION_API_KEY,
  browserbaseApiKey: process.env.BROWSERBASE_API_KEY,
  browserbaseProjectId: process.env.BROWSERBASE_PROJECT_ID,
  timeout: parseInt(process.env.E2B_SANDBOX_TIMEOUT || '300000'),
  template: process.env.E2B_SANDBOX_TEMPLATE || 'base'
};

// Validate required environment variables
function validateConfig() {
  if (!config.e2bApiKey) {
    console.error('❌ Error: E2B_API_KEY is required');
    console.error('   Get your API key from https://e2b.dev/dashboard');
    console.error('   Set it in .env file or environment variables');
    process.exit(1);
  }
  
  if (!config.githubToken) {
    console.warn('⚠️  Warning: GITHUB_TOKEN not set');
    console.warn('   GitHub Copilot CLI and GitHub MCP tools will not work');
  }
}

/**
 * Create E2B Cloud sandbox with Docker MCP Gateway
 */
async function createSandbox() {
  console.log('🚀 Creating E2B Cloud Sandbox with Docker MCP Gateway...\n');
  
  validateConfig();
  
  try {
    // Configure MCP servers to enable in the sandbox
    const mcpConfig = {};
    
    // GitHub MCP server (for repository operations, issues, PRs)
    if (config.githubToken) {
      mcpConfig.github = {
        token: config.githubToken
      };
      console.log('✓ GitHub MCP server configured');
    }
    
    // Jina AI MCP server (for web search and content extraction)
    if (config.jinaApiKey) {
      mcpConfig.jina = {
        apiKey: config.jinaApiKey
      };
      console.log('✓ Jina AI MCP server configured');
    }
    
    // Notion MCP server (for Notion integration)
    if (config.notionApiKey) {
      mcpConfig.notion = {
        internalIntegrationToken: config.notionApiKey
      };
      console.log('✓ Notion MCP server configured');
    }
    
    // Browserbase MCP server (for browser automation)
    if (config.browserbaseApiKey && config.browserbaseProjectId) {
      mcpConfig.browserbase = {
        apiKey: config.browserbaseApiKey,
        projectId: config.browserbaseProjectId
      };
      console.log('✓ Browserbase MCP server configured');
    }
    
    console.log('\n📦 Initializing E2B sandbox...');
    
    // Create sandbox with MCP gateway
    const sandbox = await Sandbox.create({
      apiKey: config.e2bApiKey,
      template: config.template,
      timeoutMs: config.timeout,
      mcp: mcpConfig
    });
    
    console.log(`✅ Sandbox created: ${sandbox.sandboxId}\n`);
    
    // Get MCP Gateway URL and token
    const mcpUrl = sandbox.getMcpUrl();
    const mcpToken = await sandbox.getMcpToken();
    
    console.log('🔗 MCP Gateway Information:');
    console.log(`   URL: ${mcpUrl}`);
    // Do not print secrets by default. Provide a masked fingerprint for troubleshooting.
    const tokenFingerprint = Buffer.from(await crypto.subtle.digest(
      'SHA-256',
      new TextEncoder().encode(mcpToken)
    ))
      .toString('hex')
      .slice(0, 8);
    console.log(`   Token fingerprint: ${tokenFingerprint} (full token hidden)`);
    console.log(`   Internal URL: http://localhost:50005/mcp\n`);
    
    console.log('📦 Installing GitHub Copilot CLI...');
    const installCopilot = async () => {
      const attempt = async (label) => {
        return sandbox.commands.run(
          'npm install -g @github/copilot',
          {
            timeoutMs: 180000,
            onStdout: (data) => process.stdout.write(data.line + '\n'),
            onStderr: (data) => process.stderr.write(data.line + '\n')
          }
        );
      };
      let result = await attempt('first');
      if (result.exitCode !== 0) {
        console.warn('⚠️  Copilot CLI install failed. Retrying once after 3s...');
        await new Promise(r => setTimeout(r, 3000));
        result = await attempt('retry');
      }
      return result;
    };

    const installResult = await installCopilot();
    const verifyInstall = await sandbox.commands.run('command -v copilot || which copilot || echo "NOT_FOUND"', { timeoutMs: 10000 });
    if (installResult.exitCode === 0 && verifyInstall.stdout && !verifyInstall.stdout.includes('NOT_FOUND')) {
      console.log('✅ GitHub Copilot CLI installed successfully\n');
    } else {
      console.warn('⚠️  GitHub Copilot CLI installation failed or binary not found. You may need to install it manually.\n');
    }
    
    // Verify Copilot CLI installation
    console.log('🔍 Verifying Copilot CLI...');
    const verifyResult = await sandbox.commands.run(
      'copilot --version || echo "Not installed"',
      { timeoutMs: 10000 }
    );
    
    if (verifyResult.stdout) {
      console.log(`✓ Copilot CLI version: ${verifyResult.stdout.trim()}\n`);
    }
    
    // Display usage information
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🎉 E2B Cloud Sandbox is Ready!\n');
    console.log('📝 Sandbox Details:');
    console.log(`   • Sandbox ID: ${sandbox.sandboxId}`);
    console.log(`   • MCP Gateway: ${mcpUrl}`);
    console.log(`   • Template: ${config.template}`);
    console.log(`   • Timeout: ${config.timeout}ms\n`);
    
    console.log('🛠️  How to Use:');
    console.log('   1. Connect to sandbox via SSH or API');
    console.log('   2. Use Copilot CLI: copilot /login');
    console.log('   3. Access MCP tools via gateway URL');
    console.log('   4. Run commands: await sandbox.commands.run("your-command")');
    console.log('\n💡 Example Commands:');
    console.log('   # List available MCP tools');
    console.log('   curl -H "Authorization: Bearer <token>" <mcpUrl>/tools');
    console.log('   ');
    console.log('   # Use Copilot CLI');
    console.log('   copilot suggest -p "Create a React component"');
    console.log('   ');
    console.log('   # Run code in sandbox');
    console.log('   node your-script.js');
    console.log('\n⚠️  Remember to close the sandbox when done:');
    console.log('   await sandbox.close()');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    // Keep sandbox alive for interactive use
    console.log('🔄 Sandbox is running. Press Ctrl+C to close and cleanup...\n');
    
    // Handle cleanup on exit
    process.on('SIGINT', async () => {
      console.log('\n\n🛑 Closing sandbox...');
      await sandbox.close();
      console.log('✅ Sandbox closed successfully');
      process.exit(0);
    });
    
    // Return sandbox instance for programmatic use
    return sandbox;
    
  } catch (error) {
    console.error('❌ Error creating sandbox:', error.message);
    if (error.response) {
      console.error('   Response:', error.response.data);
    }
    process.exit(1);
  }
}

/**
 * List active sandboxes
 */
async function listSandboxes() {
  console.log('📋 Listing E2B Sandboxes...\n');
  
  validateConfig();
  
  // Note: E2B SDK doesn't provide a method for listing active sandboxes.
  // This functionality is available in the E2B dashboard.
  console.log('ℹ️  The E2B SDK does not support listing sandboxes directly.');
  console.log('   Please visit your dashboard to view active sandboxes: https://e2b.dev/dashboard\n');
}

/**
 * Main CLI handler
 */
async function main() {
  const command = process.argv[2];
  
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║  E2B Cloud Sandbox + Docker MCP Gateway + GitHub Copilot    ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');
  
  switch (command) {
    case 'create':
      await createSandbox();
      break;
      
    case 'list':
      await listSandboxes();
      break;
      
    default:
      console.log('Usage:');
      console.log('  npm run create-sandbox    Create new E2B sandbox with MCP gateway');
      console.log('  npm run list-sandboxes    List active sandboxes');
      console.log('\nFor more information, see E2B_CLOUD_GUIDE.md\n');
      process.exit(1);
  }
}

// Run if called directly
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  main().catch(error => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
}

export { createSandbox, listSandboxes };
