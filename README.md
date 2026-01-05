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
├── mcp/                      # MCP 服务器说明 (8个)
│   ├── README.md            # MCP 总览
│   ├── context7.md          # 文档查询
│   ├── brave-search.md      # 网页搜索
│   ├── deepwiki.md          # GitHub 项目解读
│   ├── fetch.md             # 网页内容获取
│   ├── playwright.md        # 浏览器自动化
│   ├── xiaohongshu-mcp.md   # 小红书操作
│   ├── nano-banana.md       # AI 图片生成
│   ├── zotero-mcp.md        # Zotero 文献管理
│   └── lark-mcp.md          # 飞书文档操作
├── skills/                   # Claude Skills (个人工作流)
│   ├── skill-rules.json     # Skill 自动激活规则 ⭐
│   ├── paper-writing/       # 论文写作（顶会投稿）⭐
│   ├── paper-reading/       # 论文阅读分析
│   ├── literature-to-feishu/ # 文献整理到飞书
│   ├── xiaohongshu-writer/  # 小红书写作
│   └── notion-daily/        # Notion 每日内容快速访问 ⭐ 新增
├── hooks/                    # Claude Code Hooks
│   └── skill-activation-prompt.sh  # Skill 自动激活 hook
├── docker/                   # Docker 配置
│   └── xiaohongshu-mcp/
│       └── docker-compose.yml
├── scripts/
│   ├── setup.sh             # 一键安装脚本
│   └── send_daily_email.py  # 每日总结邮件发送 ⭐ 新增
└── commands/                 # 自定义命令 ⭐ 新增
    ├── daily-summary.md     # 生成每日总结
    └── memory.md            # 查询记忆
```

## 配置状态

| 功能 | 状态 | 说明 |
|------|------|------|
| 全局规则 CLAUDE.md | ✅ | MCP 调用、语言偏好、工作流 |
| 权限设置 | ✅ | 工具白名单/黑名单 |
| MCP 服务器 (8个) | ✅ | context7, search, deepwiki, fetch, playwright, xiaohongshu, zotero, lark-mcp |
| Skills (5个) | ✅ | paper-writing, paper-reading, literature-to-feishu, xiaohongshu-writer, notion-daily |
| Hooks (1个) | ✅ | skill-activation-prompt (Skill 自动激活) |
| Extended Thinking | ✅ | 深度思考模式 |
| 自定义命令 (2个) | ✅ | /daily-summary, /memory ⭐ 新增 |
| Memory 系统 | ✅ | 每日总结 + 邮件通知 ⭐ 新增 |

👉 查看 [进阶配置指南](docs/advanced-guide.md) 了解如何配置更多功能。

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/my-claude-config.git
cd my-claude-config

# 运行安装脚本
./scripts/setup.sh
```

## MCP vs Skills：为什么需要两者？

### 简单理解

```
MCP = 你能做什么（能力/工具）
Skills = 你怎么做（方法/习惯）
```

### 详细对比

| 维度 | MCP | Skills |
|------|-----|--------|
| **本质** | 外接工具/API 连接 | 个人工作流/方法论 |
| **作用** | 让 Claude 能访问外部服务 | 告诉 Claude 如何完成任务 |
| **类比** | 工具箱里的锤子、螺丝刀 | 使用工具的说明书 |
| **例子** | zotero MCP 能读取文献库 | paper-reading Skill 定义如何分析论文 |
| **存储** | 服务进程/API | 本地 Markdown 文件 |

### 为什么需要 MCP？

- **连接外部世界** - 访问 Zotero、飞书、小红书等服务
- **获取实时数据** - 搜索网页、获取最新文档
- **执行操作** - 创建文档、发布内容、自动化浏览器

### 为什么需要 Skills？

- **固化最佳实践** - 把你的工作习惯模板化
- **保证输出一致** - 每次执行相同任务，格式和流程一致
- **提高效率** - 不需要每次都重复描述偏好
- **知识沉淀** - 领域知识和方法论可复用

### 协作示例

```
用户: "帮我整理 Zotero 里的 transformer 论文到飞书"

Claude 执行:
1. 识别任务 → 激活 literature-to-feishu Skill（方法）
2. 调用 zotero MCP → 获取论文数据（工具）
3. 按 Skill 定义的格式 → 整理信息（方法）
4. 调用 lark-mcp → 创建飞书文档（工具）
```

## MCP 服务器概览

| MCP | 用途 | 类型 |
|-----|------|------|
| context7 | 查询库/框架最新文档 | stdio |
| search (Brave) | 网页搜索 | stdio |
| deepwiki | GitHub 项目解读 | http |
| fetch | 获取网页内容 | stdio |
| playwright | 浏览器自动化 | stdio |
| xiaohongshu-mcp | 小红书内容操作 | http (本地服务) |
| zotero | Zotero 文献管理 | stdio |
| lark-mcp | 飞书文档操作 | stdio |

## Skills 概览

| Skill | 用途 | 触发关键词 |
|-------|------|----------|
| **paper-writing** | 论文写作（顶会投稿）⭐ | 写论文、润色、method、experiment、CVPR、latex |
| paper-reading | 论文阅读分析 | 论文、paper、arxiv、研究、zotero |
| literature-to-feishu | 文献整理到飞书 | 整理文献、文献综述、飞书文档 |
| xiaohongshu-writer | 小红书写作 | 小红书、笔记、爆款、种草、文案 |
| notion-daily | Notion 每日内容快速访问 | 今日内容、今日待办、今天做什么、打开 Notion |

## Hooks 系统：Skill 自动激活

### 核心问题
Claude Code 的 Skills 是**被动的**，不会自动触发。你必须手动记住使用哪个 Skill。

### 解决方案
通过 `skill-activation-prompt` hook，根据用户输入的关键词**自动建议**相关 Skill：

```
用户输入: "帮我读一下这篇论文"
    ↓
Hook 检测到关键词 "论文"
    ↓
匹配 skill-rules.json 中的 paper-reading
    ↓
显示: "💡 检测到相关 Skill: paper-reading"
```

### 配置文件

**skill-rules.json** - 定义触发规则：
```json
{
  "skills": [
    {
      "name": "paper-reading",
      "triggers": {
        "keywords": ["论文", "paper", "arxiv", "研究"]
      }
    }
  ]
}
```

**settings.json** - 注册 hook：
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/skill-activation-prompt.sh" }
        ]
      }
    ]
  }
}
```

## 核心工作流

### 工作流 1：文献整理
```
Zotero (文献管理) → Claude (整理分析) → 飞书 (文档输出)
```
使用示例：
```
帮我把 Zotero 里关于 transformer 的论文整理成飞书文档
```

### 工作流 2：论文写作 ⭐ 新增
```
LaTeX 草稿 → Claude (润色/公式解释/实验描述) → 顶会投稿
```
使用示例：
```
帮我润色 Method 部分，保留 LaTeX 公式
帮我写 Ablation Study 的分析段落
帮我生成这段 PyTorch 代码的伪代码
```

**paper-writing Skill 包含**：
- Title/Abstract、Introduction、Related Work
- Method（公式解释、Loss描述、伪代码）
- Experiment（结果分析、Ablation、统计显著性）
- Conclusion、Rebuttal 回复模板

### 工作流 3：每日记忆系统 ⭐ 新增
```
会话历史 → Claude (分类统计) → 本地 Markdown + 飞书 + 邮件通知
```
使用示例：
```
总结今天      # 生成今日总结
查询记忆      # 查看之前的总结
/daily-summary  # slash 命令
/memory         # 查询历史
```

**每日总结包含**：
- 会话统计（按项目目录分类）
- 分板块整理（科研、小红书、Claude配置、工具调研等）
- 待办事项追踪
- 自动导出飞书 + 邮件通知

**邮件通知配置**：
```bash
# 1. 在 163 邮箱开启 SMTP，获取授权码
# 2. 设置环境变量
export EMAIL_163_AUTH_CODE='你的授权码'

# 3. 发送邮件
~/.claude/scripts/send_daily_email.py
```

## 环境要求

- macOS / Linux
- Claude Code CLI
- Docker Desktop (用于小红书 MCP)
- Node.js (用于 npx 命令)
- Python + uv (用于 fetch MCP)

## License

MIT
