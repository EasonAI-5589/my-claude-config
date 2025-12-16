# Claude Code 全局规则

## MCP 自动调用规则

### Context7 - 文档查询（自动使用）
当涉及以下场景时，自动使用 Context7 MCP 查询最新文档：
- 代码生成或实现功能
- 库/框架的 API 使用
- 配置和设置步骤
- 任何第三方库相关问题

### DeepWiki - 开源项目解读（自动使用）
当询问 GitHub 开源项目相关问题时，自动使用 DeepWiki MCP：
- 项目架构和设计
- 源码解读
- 使用方法

### Playwright - 浏览器自动化（自动使用）
当需要以下操作时，自动使用 Playwright MCP：
- 网页自动化测试
- 爬取网页数据
- 截图或网页交互

### Brave Search - 实时搜索（自动使用）
当需要以下信息时，使用 Brave Search：
- 最新资讯和新闻
- 知识库之外的内容
- 实时信息查询

### Fetch - 网页内容获取（自动使用）
当需要获取特定 URL 内容时，使用 Fetch MCP。

### 小红书 MCP - 小红书内容操作（自动使用）
当需要以下小红书相关操作时，自动使用 xiaohongshu-mcp：
- 搜索小红书内容
- 获取小红书帖子详情
- 获取推荐列表
- 发布图文/视频内容

**重要：小红书 MCP 需要本地服务**
- 使用前先检查服务状态：`claude mcp list | grep xiaohongshu`
- 如果显示 `Failed to connect`，需要先启动服务：
  ```bash
  cd ~/xiaohongshu-mcp && ./xiaohongshu-mcp-darwin-arm64 &
  ```
- 服务运行在 `http://localhost:18060/mcp`

## 搜索行为规则

### 避免并行搜索
使用 Brave Search 时，串行执行搜索请求（不要并行），避免触发免费计划的速率限制（1次/秒）。

### 小红书内容评估
评估小红书帖子质量时，综合考虑多个指标（不只看收藏量）：
- **点赞数** - 内容受欢迎程度
- **收藏数** - 实用价值
- **评论数** - 讨论热度和互动质量
- 优先关注高互动帖子（点赞 > 500 或 收藏 > 300）

## 工具推荐规则

### 过滤低质量项目
推荐工具/库时，自动过滤 star 数量太少的项目：
- GitHub star < 100 的项目不推荐
- 优先推荐成熟、活跃维护的项目
- 检查最后更新时间，超过 6 个月未更新的谨慎推荐

## 配置同步规则

### 自动同步到 GitHub
当以下文件有更新时，自动同步到远程仓库：
- `~/.claude/CLAUDE.md` → `my-claude-config/claude/CLAUDE.md`
- `~/.claude/settings.json` → `my-claude-config/claude/settings.json`
- MCP 相关配置 → `my-claude-config/mcp/`
- Docker 配置 → `my-claude-config/docker/`

**远程仓库**: https://github.com/EasonAI-5589/my-claude-config

**同步步骤**:
```bash
cd ~/my-claude-config
git add .
git commit -m "描述更新内容"
git push
```

## 语言偏好

- 默认使用中文回复
- 代码注释使用英文
