# Claude Code 进阶配置指南

基于小红书热门教程、官方文档和社区最佳实践整理。

> 更新时间：2025-12-16
> 参考来源：Anthropic 官方博客、小红书热门帖（6000+ 收藏）、GitHub 社区

## 当前配置状态

### ✅ 已完成

| 功能 | 说明 | 位置 |
|------|------|------|
| 全局规则 CLAUDE.md | MCP 调用规则、语言偏好、同步规则 | `~/.claude/CLAUDE.md` |
| 权限设置 | 允许/禁止的工具白名单 | `~/.claude/settings.json` |
| MCP 服务器 (6个) | context7, search, deepwiki, fetch, playwright, xiaohongshu | 已配置 |
| Docker 部署 | 小红书 MCP 容器化 | `docker/xiaohongshu-mcp/` |
| Extended Thinking | 启用深度思考模式 | `alwaysThinkingEnabled: true` |
| 搜索行为优化 | 避免并行搜索触发速率限制 | CLAUDE.md |
| 工具推荐规则 | 过滤低 star 项目 | CLAUDE.md |

### ❌ 待配置

| 功能 | 说明 | 优先级 |
|------|------|--------|
| 自定义命令 (Slash Commands) | 创建可复用的命令模板 | ⭐⭐⭐ |
| Hooks | 工具调用前后的自动化脚本 | ⭐⭐⭐ |
| Think 模式进阶 | think/ultrathink 深度推理 | ⭐⭐⭐ |
| 项目级 CLAUDE.md | 每个项目的专属规则 | ⭐⭐ |
| Memory 记忆系统 | 跨会话保持上下文 | ⭐⭐ |
| 成本监控 | 实时显示 Token 消耗 | ⭐⭐ |
| 子代理 (Sub-agents) | 并行执行复杂任务 | ⭐ |

---

## 1. 自定义命令 (Slash Commands)

在 `~/.claude/commands/` 目录下创建 `.md` 文件：

### 示例：代码审查命令

```bash
mkdir -p ~/.claude/commands
```

**~/.claude/commands/review.md**
```markdown
请审查当前文件或目录的代码：

1. **代码质量**：命名规范、代码结构、可读性
2. **潜在问题**：Bug、安全漏洞、性能问题
3. **最佳实践**：是否遵循语言/框架惯例
4. **改进建议**：具体可操作的优化方案

输出格式：
- 问题严重程度：🔴 严重 / 🟡 警告 / 🟢 建议
- 每个问题附带修复代码示例
```

使用方式：`/review`

### 示例：Git 提交命令

**~/.claude/commands/commit.md**
```markdown
分析当前 git 改动并生成规范的提交信息：

1. 运行 `git status` 和 `git diff`
2. 分析改动类型（feat/fix/docs/refactor/test/chore）
3. 生成符合 Conventional Commits 规范的提交信息
4. 执行 `git add . && git commit`

提交信息格式：
<type>(<scope>): <description>

<body>
```

使用方式：`/commit`

---

## 2. Hooks（钩子）

在 `~/.claude/settings.json` 中配置：

```json
{
  "hooks": {
    "preToolCall": [
      {
        "tool": "Bash",
        "command": "echo '[$(date +%H:%M:%S)] 执行命令: $TOOL_INPUT' >> ~/.claude/tool.log"
      }
    ],
    "postToolCall": [
      {
        "tool": "Edit",
        "command": "echo '文件已修改: $TOOL_INPUT' | say"
      }
    ]
  }
}
```

### 常用 Hook 场景

| Hook | 用途 |
|------|------|
| 代码修改后自动格式化 | `prettier --write $FILE` |
| 提交前自动运行测试 | `npm test` |
| 敏感操作前确认 | `read -p "确认执行？"` |
| 操作日志记录 | 写入 `~/.claude/audit.log` |

---

## 3. Skills（技能）

Skills 是预定义的专家模式，放在 `~/.claude/skills/` 目录：

**~/.claude/skills/react-expert.md**
```markdown
你是一个 React 专家，请遵循以下规则：

## 代码规范
- 使用函数式组件和 Hooks
- 优先使用 TypeScript
- 组件文件使用 PascalCase 命名

## 状态管理
- 简单状态用 useState
- 复杂状态用 useReducer
- 全局状态优先考虑 Zustand

## 性能优化
- 大列表使用虚拟滚动
- 使用 React.memo 避免不必要渲染
- 图片使用懒加载
```

激活方式：`/skill react-expert`

---

## 4. Memory 记忆系统

### 项目记忆 (~/.claude/memories/)

```bash
mkdir -p ~/.claude/memories
```

**~/.claude/memories/project-context.md**
```markdown
## 当前项目

- 项目名：my-app
- 技术栈：Next.js 14 + TypeScript + Tailwind
- 数据库：PostgreSQL + Prisma
- 部署：Vercel

## 重要决策

- 2024-12-01: 选择 Zustand 替代 Redux
- 2024-12-10: API 统一使用 tRPC

## 待办事项

- [ ] 完成用户认证模块
- [ ] 添加单元测试
```

---

## 5. 项目级 CLAUDE.md

每个项目根目录放置 `CLAUDE.md`：

```markdown
# 项目规则

## 技术栈
- Python 3.11 + FastAPI
- PostgreSQL + SQLAlchemy
- pytest 测试框架

## 代码规范
- 使用 Black 格式化
- 类型注解必须完整
- 每个函数必须有 docstring

## 禁止事项
- 不使用 print 调试，使用 logging
- 不直接操作数据库，使用 Repository 模式
- 不在代码中硬编码配置

## 常用命令
- 启动：`uvicorn main:app --reload`
- 测试：`pytest -v`
- 迁移：`alembic upgrade head`
```

---

## 6. 成本监控

### 方法一：使用 `/cost` 命令

```bash
# 查看当前会话消耗
/cost
```

### 方法二：状态栏显示

```bash
# 启用状态栏费用显示
claude config set showTokenUsage true
```

### 方法三：日志分析

```bash
# 查看历史消耗
cat ~/.claude/history.jsonl | jq -r 'select(.type=="conversation") | .cost' | awk '{s+=$1} END {print "Total: $"s}'
```

---

## 7. 上下文管理技巧

### /compact 压缩上下文

当对话过长时，使用 `/compact` 压缩历史：

```
/compact 保留最近 10 条消息的核心内容
```

### /clear 清空上下文

```
/clear    # 清空所有
/clear 5  # 保留最近 5 条
```

### 使用 TodoWrite 追踪任务

复杂任务自动使用 TodoWrite 工具追踪进度，避免遗漏。

---

## 8. 高级 MCP 组合用法

### Context7 + DeepWiki

```
1. 用 DeepWiki 了解开源项目架构
2. 用 Context7 查询具体 API 用法
3. 生成符合项目风格的代码
```

### Playwright + 小红书

```
1. 用 Playwright 截取网页设计
2. 分析设计元素
3. 用小红书 MCP 发布设计分享
```

---

## 推荐配置文件结构

```
~/.claude/
├── CLAUDE.md              # 全局规则
├── settings.json          # 权限和配置
├── commands/              # 自定义命令
│   ├── review.md
│   ├── commit.md
│   └── deploy.md
├── skills/                # 技能模板
│   ├── react-expert.md
│   └── python-expert.md
├── memories/              # 记忆文件
│   └── project-context.md
└── hooks/                 # 钩子脚本
    ├── pre-commit.sh
    └── post-edit.sh
```

---

## 9. Think 模式进阶

Claude Code 提供多级思考深度：

```bash
# 基础思考（默认）
claude "实现登录功能"

# 深度思考 - 适合复杂问题
claude "think 设计一个高并发订单系统"

# 超深度思考 - 适合架构设计
claude "ultrathink 设计微服务架构迁移方案"
```

### Think 模式选择指南

| 模式 | 适用场景 | Token 消耗 |
|------|----------|------------|
| 默认 | 简单修改、快速问答 | 低 |
| think | 复杂逻辑、多文件修改 | 中 |
| ultrathink | 架构设计、技术选型 | 高 |

---

## 10. 子代理 (Sub-agents)

使用 Task 工具并行执行复杂任务：

```
# 在对话中触发
"请并行执行以下任务：
1. 分析 src/ 目录的代码结构
2. 搜索所有 TODO 注释
3. 生成测试覆盖报告"
```

Claude 会自动创建子代理并行处理，显著提升效率。

---

## 11. Tree of Thoughts (ToT) 提示技巧

让 Claude 更系统地思考：

```
请使用 Tree of Thoughts 方法分析这个问题：
1. 生成 3 个不同的解决方案
2. 对每个方案进行优缺点分析
3. 模拟实施后可能遇到的问题
4. 选择最优方案并解释原因
```

---

## 12. 高效 Prompt 模板

### 代码生成模板

```markdown
## 任务
[具体任务描述]

## 技术要求
- 语言/框架：
- 依赖限制：
- 性能要求：

## 代码规范
- 命名风格：
- 注释要求：
- 错误处理：

## 示例
[提供类似代码示例]
```

### Debug 模板

```markdown
## 问题描述
[错误现象]

## 复现步骤
1.
2.
3.

## 期望行为
[应该发生什么]

## 已尝试
- 方案1：结果
- 方案2：结果

## 相关代码
[粘贴代码片段]
```

---

## 13. 成本优化策略

### 策略一：分层模型

```bash
# 简单任务用 Haiku（便宜）
claude --model haiku "格式化这段代码"

# 复杂任务用 Sonnet（平衡）
claude --model sonnet "重构这个模块"

# 关键决策用 Opus（最强）
claude --model opus "设计系统架构"
```

### 策略二：上下文管理

```bash
# 定期压缩上下文
/compact

# 开启新任务前清理
/clear
```

### 策略三：预设停止条件

在 CLAUDE.md 中添加：

```markdown
## 成本控制
- 单次对话不超过 $5
- 超过限制前提醒用户
- 优先使用缓存结果
```

---

## 14. 推荐 GitHub 项目

学习高级用法的优质开源项目：

| 项目 | 说明 | Star |
|------|------|------|
| [diet103/claude-code-infrastructure-showcase](https://github.com/diet103/claude-code-infrastructure-showcase) | 6 个月使用经验总结 | 热门 |
| [anthropics/claude-code](https://github.com/anthropics/claude-code) | 官方仓库 | 官方 |

---

## 参考资源

### 官方资源
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices) - Anthropic 官方博客
- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [GitHub](https://github.com/anthropics/claude-code)

### 社区教程（小红书）
- "30个进阶技巧榨干Claude Code" - @饼干哥哥 AGI (338收藏)
- "看他用ClaudeCode让我感觉自己像个新兵蛋子" - @好记星.ai (6268收藏)
- "如何管理Claude Code上下文" - @一蛙 (766收藏)
- "Claude Code详细攻略，一期视频精通" - @技术爬爬虾 (1693收藏)

### 中文博客
- [Claude Code完全指南](https://blog.csdn.net/qq254606826/article/details/145865855) - CSDN
- [最强Coding Agent: Claude Code权威实践指南](https://zhuanlan.zhihu.com/p/1920263182062163086) - 知乎
