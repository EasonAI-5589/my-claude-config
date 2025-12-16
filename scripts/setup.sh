#!/bin/bash

# My Claude Code Configuration Setup Script
# 一键安装所有 MCP 服务器

set -e

echo "🚀 开始安装 Claude Code MCP 配置..."

# 检查依赖
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ 缺少依赖: $1"
        echo "请先安装 $1"
        exit 1
    fi
}

echo "📋 检查依赖..."
check_dependency "claude"
check_dependency "npx"
check_dependency "docker"

# 安装 MCP 服务器
echo ""
echo "📦 安装 MCP 服务器..."

echo "  → Context7 (文档查询)"
claude mcp add context7 -- npx @upstash/context7-mcp@latest 2>/dev/null || echo "    已存在，跳过"

echo "  → DeepWiki (GitHub 项目解读)"
claude mcp add --transport http deepwiki https://mcp.deepwiki.com/mcp 2>/dev/null || echo "    已存在，跳过"

echo "  → Fetch (网页内容获取)"
claude mcp add fetch -- uvx mcp-server-fetch 2>/dev/null || echo "    已存在，跳过"

echo "  → Playwright (浏览器自动化)"
claude mcp add playwright -- npx @playwright/mcp@latest --headless 2>/dev/null || echo "    已存在，跳过"

# Brave Search 需要 API Key
if [ -n "$BRAVE_API_KEY" ]; then
    echo "  → Brave Search (网页搜索)"
    claude mcp add search --env BRAVE_API_KEY=$BRAVE_API_KEY -- npx -y @modelcontextprotocol/server-brave-search 2>/dev/null || echo "    已存在，跳过"
else
    echo "  → Brave Search (跳过 - 需要设置 BRAVE_API_KEY 环境变量)"
fi

# 小红书 MCP 需要先启动 Docker 服务
echo ""
echo "📋 小红书 MCP 需要额外步骤:"
echo "  1. 克隆项目: git clone https://github.com/xpzouying/xiaohongshu-mcp.git ~/xiaohongshu-mcp"
echo "  2. 登录: cd ~/xiaohongshu-mcp && ./xiaohongshu-login-darwin-arm64"
echo "  3. 构建镜像: docker build -f Dockerfile.arm64 -t xiaohongshu-mcp:arm64 ."
echo "  4. 启动服务: cd docker && docker compose up -d"
echo "  5. 添加 MCP: claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp"

# 复制 CLAUDE.md
echo ""
echo "📄 复制 CLAUDE.md 到 ~/.claude/"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/../claude/CLAUDE.md" ~/.claude/CLAUDE.md 2>/dev/null || echo "  复制失败，请手动复制"

echo ""
echo "✅ 安装完成！"
echo ""
echo "验证安装:"
echo "  claude mcp list"
