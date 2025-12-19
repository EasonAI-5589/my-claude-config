# Claude Code 全局规则

> **⚠️ 必读：配置变更检查清单**
>
> 当新增/修改 MCP 或 Skills 时，**必须同时更新**：
> - [ ] `README.md` - 目录结构、配置状态、概览表格、工作流
> - [ ] `skill-rules.json` - 触发关键词（如果是 Skill）
> - [ ] 相关文档（mcp/*.md 或 skills/README.md）
>
> **不要忘记 push 到 GitHub！**

---

## 核心概念：MCP vs Skills vs Hooks

| 概念 | 本质 | 作用 | 类比 |
|------|------|------|------|
| **MCP** | 外接工具/API | 让 Claude 能访问外部服务 | 工具箱里的工具 |
| **Skills** | 个人工作流 | 告诉 Claude 如何完成任务 | 使用工具的说明书 |
| **Hooks** | 事件触发器 | 在特定事件时自动执行脚本 | 自动化开关 |

### 简单理解
```
MCP    = 你能做什么（能力）  → 访问 Zotero、飞书、小红书
Skills = 你怎么做（方法）    → 论文怎么读、文档怎么写
Hooks  = 什么时候做（触发）  → 检测到关键词自动激活 Skill
```

### 协作流程
```
用户输入: "帮我读一下这篇论文"
    ↓
[Hook] skill-activation-prompt 检测到 "论文" 关键词
    ↓
[Skill] 激活 paper-reading，提供阅读流程和模板
    ↓
[MCP] 调用 zotero 获取论文，调用 lark-mcp 输出到飞书
```

---

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
- **服务重启后必须重启 Claude Code 会话**才能加载新工具

**发布前必检清单**：
1. `check_login_status` - 确认已登录
2. 标题字数 ≤ 20（含标点！）
3. 图片使用绝对路径
4. 展示预览让用户确认后再发布

**常见错误处理**：
- `标题长度超过限制` → 缩短标题
- `Node is detached` → 调用 check_login_status 后重试
- `工具不存在` → 重启 Claude Code

### Zotero MCP - 文献管理（自动使用）
当需要以下文献相关操作时，自动使用 zotero MCP：
- 搜索文献库中的论文
- 获取论文元数据和全文
- 提取 PDF 标注和高亮
- 导出 BibTeX 引用
- 语义搜索相关文献

**重要：Zotero MCP 需要 Zotero 桌面端运行**
- 确保 Zotero 7+ 已安装并正在运行
- 在 Zotero 设置中开启本地 API：设置 → 高级 → 勾选 "Allow other applications to access Zotero via local API"

### 飞书 MCP - 文档操作（自动使用）
当需要以下飞书相关操作时，自动使用 lark-mcp：
- 创建飞书文档
- 编辑飞书文档内容
- 查看飞书文档
- 操作多维表格
- Markdown 转飞书文档块

**已开通权限**：
- `docx:document` - 创建及编辑文档
- `docx:document:readonly` - 查看文档
- `docx:document.block:convert` - Markdown/HTML 转文档块
- `bitable:app` - 多维表格读写

## 工作流：文献整理到飞书

当用户需要整理文献到飞书时，按以下流程操作：

1. **Zotero 获取文献** - 使用 zotero MCP 搜索和获取论文信息
2. **Claude 整理分析** - 提取关键信息、生成摘要
3. **飞书输出** - 使用 lark-mcp 创建文档或更新多维表格

示例命令：
```
帮我把 Zotero 里关于 transformer 的论文整理成飞书文档
```

## Skills 自动调用规则

Skills 存放在 `~/.claude/skills/`，Claude 会根据任务自动判断使用。

### paper-reading - 论文阅读
当需要以下操作时，参考此 Skill：
- 阅读和分析学术论文
- 提取论文关键信息（方法、实验、结论）
- 批判性分析研究质量

### literature-to-feishu - 文献整理
当需要以下操作时，参考此 Skill：
- 将 Zotero 文献整理到飞书
- 创建文献综述文档
- 批量处理论文信息

### xiaohongshu-writer - 小红书写作
当需要以下操作时，参考此 Skill：
- 创作小红书图文笔记
- 分析爆款内容结构
- 优化标题和文案

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
- `~/.claude/skills/` → `my-claude-config/skills/`
- MCP 相关配置 → `my-claude-config/mcp/`
- Docker 配置 → `my-claude-config/docker/`

**远程仓库**: https://github.com/EasonAI-5589/my-claude-config

### 工作流变更时必须更新的文件

**重要：当 MCP 或 Skills 发生变化时，必须同时更新以下文件：**

1. **新增/删除 MCP 时**：
   - `mcp/README.md` - 更新 MCP 列表和安装命令
   - `README.md` - 更新 MCP 概览表格和数量
   - `claude/CLAUDE.md` - 更新 MCP 调用规则

2. **新增/删除 Skills 时**：
   - `skills/README.md` - 更新 Skills 列表
   - `README.md` - 更新 Skills 概览表格和数量
   - `claude/CLAUDE.md` - 更新 Skills 调用规则

3. **工作流变更时**：
   - `README.md` - 更新核心工作流图示
   - `claude/CLAUDE.md` - 更新工作流章节

**同步步骤**:
```bash
cd ~/my-claude-config
git add .
git commit -m "描述更新内容"
git push
```

## 权限白名单配置

`~/.claude/settings.json` 中的 `allowedTools` 控制哪些操作自动允许（无需确认）：

### 自动允许的编辑
- `Edit(~/.claude/CLAUDE.md)` - 本文件的编辑
- `Edit(~/.claude/settings.json)` - 权限配置的编辑

### 自动允许的命令
- 文件操作：`ls`, `cat`, `cp`, `mv`, `mkdir`, `touch`, `chmod`
- 开发工具：`git`, `npm`, `npx`, `node`, `pnpm`, `yarn`
- Python：`python`, `python3`, `pip`, `pip3`, `uv`, `uvx`
- 容器：`docker`, `docker-compose`
- 其他：`curl`, `wget`, `jq`, `grep`, `awk`, `sed`, `tar`, `unzip`

### 禁止的命令
- `rm -rf` - 防止误删
- `sudo` - 防止权限滥用

## 语言偏好

- 默认使用中文回复
- 代码注释使用英文
