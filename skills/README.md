# Claude Code Skills

本目录包含个人定制的 Claude Code Skills（技能）。

## 什么是 Skills？

Skills 是 Claude Code 的**个人工作流模板**，用于封装你的使用习惯、工作流程和领域知识。

### Skills vs MCP 的区别

| 维度 | MCP | Skills |
|------|-----|--------|
| **本质** | 外接工具/API | 个人工作流/习惯 |
| **作用** | 连接外部服务（Zotero、飞书、小红书等） | 定义如何使用这些工具 |
| **类比** | 工具箱里的工具 | 使用工具的方法论 |
| **存储** | 服务进程 | 本地 Markdown 文件 |
| **调用** | Claude 调用工具 API | Claude 参考 Skill 指南 |

### 简单理解

```
MCP = 你能做什么（能力）
Skills = 你怎么做（方法）
```

**例子**：
- MCP `zotero` 让你能访问 Zotero 文献库
- Skill `paper-reading` 告诉 Claude 如何帮你读论文（提取什么、格式是什么）

## 为什么需要 Skills？

1. **一致性** - 每次执行相同任务时，输出格式和流程一致
2. **效率** - 不需要每次都重复描述你的偏好
3. **知识沉淀** - 把最佳实践固化下来
4. **可复用** - 可以分享给他人或跨项目使用

## 当前 Skills 列表

| Skill | 用途 | 触发场景 | 优先级 |
|-------|------|----------|--------|
| [paper-writing](./paper-writing/SKILL.md) | 论文写作 | 写论文、润色、投稿顶会 | 12 |
| [paper-reproduction](./paper-reproduction/SKILL.md) | 论文复现 | 复现代码、验证实验 | 11 |
| [paper-reading](./paper-reading/SKILL.md) | 论文阅读 | 阅读论文、分析方法 | 10 |
| [memory](./memory/SKILL.md) | 记忆查询 | 回忆、待办、历史 | 9 |
| [daily-summary](./daily-summary/SKILL.md) | 每日总结 | 总结今天、日报 | 9 |
| [literature-to-feishu](./literature-to-feishu/SKILL.md) | 文献整理 | Zotero → 飞书 | 8 |
| [xiaohongshu-writer](./xiaohongshu-writer/SKILL.md) | 小红书写作 | 创作笔记、爆款分析 | 8 |

## 如何创建新 Skill

### 1. 创建目录和文件

```bash
mkdir -p ~/.claude/skills/my-skill
touch ~/.claude/skills/my-skill/SKILL.md
```

### 2. 编写 SKILL.md

```yaml
---
name: my-skill
description: 简短描述这个 Skill 做什么，何时使用。
---

# Skill 名称

## 何时使用
- 场景1
- 场景2

## 流程步骤
1. 第一步
2. 第二步

## 输出模板
[定义输出格式]

## 注意事项
[特殊说明]
```

### 3. 关键要点

- `name`: 小写字母、数字、连字符（最多 64 字符）
- `description`: 必须说明**做什么**和**何时使用**（最多 1024 字符）
- 内容不超过 500 行（过长会影响上下文）

## Skills 与 MCP 的协作

Skills 和 MCP 配合使用效果最佳：

```
用户请求: "帮我整理 Zotero 里的 transformer 论文到飞书"

Claude 执行:
1. 识别任务 → 激活 literature-to-feishu Skill
2. 调用 zotero MCP → 获取论文列表
3. 按 Skill 定义的格式 → 整理信息
4. 调用 lark-mcp → 创建飞书文档
```

## 同步到 GitHub

Skills 更新后，同步到配置仓库：

```bash
cp -r ~/.claude/skills/* ~/my-claude-config/skills/
cd ~/my-claude-config
git add . && git commit -m "Update skills" && git push
```

## 参考资源

- [Claude Code Skills 官方文档](https://docs.anthropic.com/claude-code/skills)
- [Skills 示例仓库](https://github.com/anthropics/claude-code-skills-examples)
