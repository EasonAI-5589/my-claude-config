# Zotero MCP (54yyyu/zotero-mcp)

连接 Zotero 文献库与 Claude 的 MCP 服务器，支持语义搜索、标注提取、引用导出等功能。

## 功能

- 🧠 **AI 语义搜索** - 用自然语言搜索文献
- 🔍 **文献检索** - 按标题、作者、内容搜索
- 📚 **内容访问** - 获取论文元数据和全文
- 📝 **标注提取** - 提取 PDF 高亮和笔记
- 📑 **引用导出** - 导出 BibTeX 格式引用

## 安装

**注意：** 需要安装旧版 FastMCP 绕过兼容性问题。

```bash
# 1. 安装旧版 FastMCP（绕过 bug）
pip install "fastmcp<2.10"

# 2. 安装 zotero-mcp
pip install git+https://github.com/54yyyu/zotero-mcp.git

# 3. 添加到 Claude Code
claude mcp add zotero -e ZOTERO_LOCAL=true -- /Users/guoyichen/.local/bin/zotero-mcp
```

## 配置

```json
{
  "mcpServers": {
    "zotero": {
      "command": "/Users/guoyichen/.local/bin/zotero-mcp",
      "env": {
        "ZOTERO_LOCAL": "true"
      }
    }
  }
}
```

## 使用前提

1. **Zotero 7+** 已安装
2. **Zotero 桌面端正在运行**
3. **本地 API 已开启**：
   - Zotero → 设置 → 高级
   - 勾选 "Allow other applications to access Zotero via local API"

## 使用示例

```
搜索我文献库中关于 transformer 的论文
```

```
获取最近添加的 10 篇文献
```

```
提取这篇论文的所有 PDF 标注
```

```
导出这几篇论文的 BibTeX 引用
```

## 语义搜索（可选）

```bash
# 配置语义搜索
zotero-mcp setup

# 更新语义搜索数据库
zotero-mcp update-db

# 检查数据库状态
zotero-mcp db-status
```

## 参考链接

- [GitHub 仓库](https://github.com/54yyyu/zotero-mcp)
- [官方文档](https://stevenyuyy.us/zotero-mcp/)
- [Zotero 官网](https://www.zotero.org/)

## 已知问题

FastMCP 2.10+ 移除了 `dependencies` 参数，导致安装失败。解决方案是安装旧版 FastMCP：

```bash
pip install "fastmcp<2.10"
```
