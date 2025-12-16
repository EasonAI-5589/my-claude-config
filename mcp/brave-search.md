# Brave Search MCP

网页搜索，获取实时信息。

## 安装

```bash
# 需要 Brave Search API Key
# 获取地址: https://brave.com/search/api/
claude mcp add search --env BRAVE_API_KEY=YOUR_KEY -- npx -y @modelcontextprotocol/server-brave-search
```

## 用途

- 搜索最新资讯和新闻
- 查找知识库之外的内容
- 实时信息查询

## 注意事项

- 免费计划有速率限制 (1次/秒)
- 建议串行执行搜索，避免并行触发限制

## 链接

- [Brave Search API](https://brave.com/search/api/)
- [GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/brave-search)
