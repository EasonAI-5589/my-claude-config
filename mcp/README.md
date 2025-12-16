# MCP 服务器配置

本目录包含所有 MCP (Model Context Protocol) 服务器的详细说明和配置方法。

## MCP 列表

| MCP | 说明 | 安装命令 |
|-----|------|----------|
| [context7](./context7.md) | 查询库/框架最新文档 | `claude mcp add context7 -- npx @upstash/context7-mcp@latest` |
| [brave-search](./brave-search.md) | 网页搜索 | `claude mcp add search --env BRAVE_API_KEY=xxx -- npx -y @modelcontextprotocol/server-brave-search` |
| [deepwiki](./deepwiki.md) | GitHub 项目解读 | `claude mcp add --transport http deepwiki https://mcp.deepwiki.com/mcp` |
| [fetch](./fetch.md) | 获取网页内容 | `claude mcp add fetch -- uvx mcp-server-fetch` |
| [playwright](./playwright.md) | 浏览器自动化 | `claude mcp add playwright -- npx @playwright/mcp@latest --headless` |
| [xiaohongshu-mcp](./xiaohongshu-mcp.md) | 小红书操作 | `claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp` |

## 一键安装所有 MCP

```bash
# Context7
claude mcp add context7 -- npx @upstash/context7-mcp@latest

# Brave Search (需要 API Key)
claude mcp add search --env BRAVE_API_KEY=YOUR_KEY -- npx -y @modelcontextprotocol/server-brave-search

# DeepWiki
claude mcp add --transport http deepwiki https://mcp.deepwiki.com/mcp

# Fetch
claude mcp add fetch -- uvx mcp-server-fetch

# Playwright
claude mcp add playwright -- npx @playwright/mcp@latest --headless

# 小红书 MCP (需要先启动 Docker 服务)
claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp
```

## 验证安装

```bash
claude mcp list
```

## MCP 资源

- [MCP 官方文档](https://modelcontextprotocol.io)
- [MCPHub.io](https://mcphub.io/registry) - MCP 服务器目录
- [GitHub MCP Registry](https://github.com/modelcontextprotocol/registry)
