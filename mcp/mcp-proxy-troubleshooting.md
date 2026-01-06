# MCP 代理问题排查指南

> 解决 MCP 服务器 `fetch failed` / 网络超时问题

## 问题现象

```
Error: Failed to generate image: fetch failed
Error: fetch failed
Error: Connection timeout
```

MCP 工具调用失败，但 Shell 环境中 `curl` 可以正常访问同一 API。

---

## 根因分析

### 核心问题：Node.js 原生 fetch 不支持代理

| 组件 | 是否支持 http_proxy | 说明 |
|------|---------------------|------|
| `curl` | ✅ 支持 | 自动读取环境变量 |
| `axios` | ✅ 支持 | 自动读取环境变量 |
| `node-fetch` | ❌ 不支持 | 需要手动传入 agent |
| **Node.js 原生 fetch** | ❌ 默认不支持 | 需要 `NODE_USE_ENV_PROXY=1` |
| `http`/`https` 模块 | ❌ 不支持 | 可用 global-agent 拦截 |

### 为什么 global-agent 无效？

```javascript
// global-agent 只拦截这些模块
const http = require('http');
const https = require('https');

// 不拦截原生 fetch
fetch('https://api.example.com');  // 直接连接，不走代理
```

大多数现代 MCP 服务器使用原生 `fetch()`，所以 `global-agent` 和 `NODE_OPTIONS=--require global-agent/bootstrap.js` 都无效。

---

## 解决方案

### 方案 1: NODE_USE_ENV_PROXY=1 (推荐 ⭐)

**适用版本**: Node.js 21+

Node.js 21 引入了 `NODE_USE_ENV_PROXY` 环境变量，使原生 fetch 能读取代理设置。

**配置示例** (`~/.claude.json`):

```json
{
  "mcpServers": {
    "nano-banana-pro": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@rafarafarafa/nano-banana-pro-mcp"],
      "env": {
        "GEMINI_API_KEY": "your_api_key",
        "NODE_USE_ENV_PROXY": "1",
        "http_proxy": "http://127.0.0.1:7897",
        "https_proxy": "http://127.0.0.1:7897",
        "no_proxy": "localhost,127.0.0.1"
      }
    }
  }
}
```

**验证 Node 版本**:
```bash
node --version  # 需要 v21.0.0 或更高
```

**验证配置生效**:
```bash
# 检查 MCP 进程的环境变量
pgrep -f "mcp-server-name" | head -1 | xargs -I{} ps eww {} | tr ' ' '\n' | grep -E "^(NODE_USE_ENV_PROXY|http_proxy)="
```

---

### 方案 2: 使用支持代理的 MCP 替代版本

有些 MCP 有社区维护的代理兼容版本：

```json
{
  "mcpServers": {
    "nanobanana": {
      "command": "npx",
      "args": ["-y", "@ion-aluminium/nanobanana-mcp-cliproxyapi"],
      "env": {
        "CLIPROXY_BASE_URL": "http://127.0.0.1:7897"
      }
    }
  }
}
```

---

### 方案 3: 直连（需要海外网络）

如果有海外网络环境，可以移除代理配置：

```bash
unproxy  # 关闭 Shell 代理
```

配置中不添加任何代理相关环境变量。

---

## 诊断流程

### Step 1: 确认问题是代理相关

```bash
# 1. Shell 环境测试（应该成功）
curl -s --max-time 10 "https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_KEY" | head -c 100

# 2. 直连测试（可能失败）
curl -s --noproxy '*' --max-time 10 "https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_KEY"
```

如果直连失败，说明需要代理。

### Step 2: 检查 MCP 进程环境变量

```bash
# 找到 MCP 进程
ps aux | grep -i "mcp-server-name" | grep -v grep

# 查看进程环境变量
pgrep -f "mcp-server-name" | head -1 | xargs -I{} ps eww {}
```

### Step 3: 检查 Node.js 版本

```bash
node --version
# NODE_USE_ENV_PROXY 需要 v21+
```

### Step 4: 重启 MCP

```bash
# 终止旧进程
pkill -f "mcp-server-name"

# 重启 Claude Code（MCP 会自动重新加载）
```

---

## 常见 MCP 代理配置

### Brave Search MCP

```json
"search": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-brave-search"],
  "env": {
    "BRAVE_API_KEY": "xxx",
    "NODE_USE_ENV_PROXY": "1",
    "http_proxy": "http://127.0.0.1:7897",
    "https_proxy": "http://127.0.0.1:7897"
  }
}
```

### Nano Banana Pro MCP

```json
"nano-banana-pro": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@rafarafarafa/nano-banana-pro-mcp"],
  "env": {
    "GEMINI_API_KEY": "xxx",
    "IMAGE_OUTPUT_DIR": "/path/to/output",
    "NODE_USE_ENV_PROXY": "1",
    "http_proxy": "http://127.0.0.1:7897",
    "https_proxy": "http://127.0.0.1:7897"
  }
}
```

### OpenAI 类 MCP

```json
"openai-mcp": {
  "command": "npx",
  "args": ["-y", "@some/openai-mcp"],
  "env": {
    "OPENAI_API_KEY": "xxx",
    "NODE_USE_ENV_PROXY": "1",
    "http_proxy": "http://127.0.0.1:7897",
    "https_proxy": "http://127.0.0.1:7897"
  }
}
```

---

## 不需要代理的 MCP

以下 MCP 连接本地/国内服务，不需要代理：

| MCP | 原因 |
|-----|------|
| `lark-mcp` | 飞书 API 在国内 |
| `xiaohongshu-mcp` | 小红书在国内 |
| `zotero-mcp` | 连接本地 Zotero |
| `playwright` | 本地浏览器控制 |

对于这些 MCP，确保 `no_proxy` 包含相关域名：

```json
"env": {
  "no_proxy": "localhost,127.0.0.1,*.feishu.cn,*.xiaohongshu.com"
}
```

---

## 踩坑记录

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| `fetch failed` | 原生 fetch 不读代理 | 添加 `NODE_USE_ENV_PROXY=1` |
| global-agent 无效 | 只拦截 http/https 模块 | 改用 `NODE_USE_ENV_PROXY` |
| 修改配置后仍失败 | 需要重启 Claude Code | 退出并重新运行 `claude` |
| 进程环境变量为空 | 配置文件格式错误 | 用 `jq` 验证 JSON 语法 |
| Node 版本过低 | 不支持 `NODE_USE_ENV_PROXY` | 升级到 Node 21+ |

---

## 参考资料

- [Node.js fetch 代理支持讨论](https://github.com/nodejs/node/issues/42814)
- [NODE_USE_ENV_PROXY 文档](https://nodejs.org/docs/latest/api/cli.html#node_use_env_proxy1)
- [global-agent 限制说明](https://github.com/gajus/global-agent)

---

## 更新日志

- 2025-01-06: 初版，解决 nano-banana-pro fetch failed 问题
