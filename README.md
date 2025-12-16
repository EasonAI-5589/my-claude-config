# My Claude Code Configuration

我的 Claude Code 配置合集，包含 MCP 服务器配置、全局规则和 Docker 服务。

## 目录结构

```
my-claude-config/
├── README.md                 # 本文件
├── docs/                     # 文档
│   └── advanced-guide.md    # 进阶配置指南 ⭐
├── claude/                   # Claude Code 配置
│   ├── CLAUDE.md            # 全局规则（MCP 调用规则、语言偏好等）
│   └── settings.json        # 权限和工具设置
├── mcp/                      # MCP 服务器说明
│   ├── README.md            # MCP 总览
│   ├── context7.md          # 文档查询
│   ├── brave-search.md      # 网页搜索
│   ├── deepwiki.md          # GitHub 项目解读
│   ├── fetch.md             # 网页内容获取
│   ├── playwright.md        # 浏览器自动化
│   └── xiaohongshu-mcp.md   # 小红书操作
├── docker/                   # Docker 配置
│   └── xiaohongshu-mcp/
│       └── docker-compose.yml
└── scripts/
    └── setup.sh             # 一键安装脚本
```

## 配置状态

| 功能 | 状态 | 说明 |
|------|------|------|
| 全局规则 CLAUDE.md | ✅ | MCP 调用、语言偏好 |
| 权限设置 | ✅ | 工具白名单/黑名单 |
| MCP 服务器 (6个) | ✅ | context7, search, deepwiki, fetch, playwright, xiaohongshu |
| Extended Thinking | ✅ | 深度思考模式 |
| 自定义命令 | ❌ | 待配置 |
| Hooks | ❌ | 待配置 |
| Skills | ❌ | 待配置 |
| Memory | ❌ | 待配置 |

👉 查看 [进阶配置指南](docs/advanced-guide.md) 了解如何配置更多功能。

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/my-claude-config.git
cd my-claude-config

# 运行安装脚本
./scripts/setup.sh
```

## MCP 服务器概览

| MCP | 用途 | 类型 |
|-----|------|------|
| context7 | 查询库/框架最新文档 | stdio |
| search (Brave) | 网页搜索 | stdio |
| deepwiki | GitHub 项目解读 | http |
| fetch | 获取网页内容 | stdio |
| playwright | 浏览器自动化 | stdio |
| xiaohongshu-mcp | 小红书内容操作 | http (Docker) |

## 环境要求

- macOS / Linux
- Claude Code CLI
- Docker Desktop (用于小红书 MCP)
- Node.js (用于 npx 命令)
- Python + uv (用于 fetch MCP)

## License

MIT
