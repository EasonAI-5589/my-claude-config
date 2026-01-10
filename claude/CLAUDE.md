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

### Brave Search - 实时搜索（自动使用，已付费 ✅）

**当前计划**：Base AI（$5/1000次，20次/秒）

当需要以下信息时，**主动使用** Brave Search：
- 最新资讯和新闻
- 知识库之外的内容
- 实时信息查询
- **不确定的事实、数据、定价等** ← 主动搜索验证

**并行搜索已解锁**：
- 可同时发起多个搜索请求（最多 20 个/秒）
- 不再需要串行等待，大幅提升效率

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

#### 小红书登录工作流（⚠️ 重要）

**登录状态检查**：
```bash
# 1. 先检查登录状态
check_login_status  # MCP 工具

# 2. 如果未登录，cookies 可能过期
ls -la ~/xiaohongshu-mcp/cookies.json  # 检查 cookies 文件
```

**登录方式（按优先级）**：

| 方式 | 命令 | 说明 |
|------|------|------|
| ✅ **推荐：专用登录工具** | `cd ~/xiaohongshu-mcp && ./xiaohongshu-login-darwin-arm64` | 会弹出浏览器窗口显示二维码 |
| ❌ MCP get_login_qrcode | - | 终端可能无法显示二维码图片 |
| ❌ Playwright 打开网页 | - | 会被小红书检测为机器人 |
| ❌ 浏览器手动登录 | - | cookies 不与 MCP 共享 |

**正确的登录流程**：
```bash
# Step 1: 确保 MCP 服务在运行
lsof -i :18060  # 检查端口

# Step 2: 运行专用登录工具（会弹出浏览器）
cd ~/xiaohongshu-mcp && ./xiaohongshu-login-darwin-arm64

# Step 3: 用小红书 App 扫码登录

# Step 4: 验证登录状态
check_login_status  # MCP 工具
```

**踩坑记录**：
| 问题 | 原因 | 解决方案 |
|------|------|----------|
| MCP 二维码显示不出来 | 终端不支持 iTerm2 图片协议 | 使用 `xiaohongshu-login-darwin-arm64` |
| Playwright 显示"安全限制" | headless 浏览器被检测 | 不要用 Playwright 登录小红书 |
| 浏览器登录后 MCP 仍未登录 | cookies 存储位置不同 | 必须用专用登录工具 |
| imgcat 安装后仍看不到图片 | 需要 iTerm2 且开启图片支持 | 使用专用登录工具更可靠 |

**发布前必检清单**：
1. `check_login_status` - 确认已登录
2. 标题字数 ≤ 20（含标点！）
3. 图片使用绝对路径
4. 展示预览让用户确认后再发布

**常见错误处理**：
- `标题长度超过限制` → 缩短标题
- `Node is detached` → 调用 check_login_status 后重试
- `工具不存在` → 重启 Claude Code
- `未登录` → 运行 `xiaohongshu-login-darwin-arm64`

### Email MCP - 邮件发送（⚠️ 必须确认）

**重要：发送邮件前必须先让用户确认！**

当需要发送邮件时，**严格按以下流程执行**：
1. **先展示邮件预览** - 显示收件人、标题、正文全文、附件列表
2. **等待用户确认** - 明确询问"确认发送吗？"
3. **用户确认后才发送** - 不要自作主张直接发送

**禁止行为**：
- ❌ 未经确认直接发送邮件
- ❌ 自行编写邮件内容后直接发送
- ❌ 发送错误后用【更正】标题补发
- ❌ 批量发送前不逐一确认

**正确流程示例**：
```
用户: 帮我给这三位老师发套磁邮件

Claude 应该:
1. 展示第一封邮件预览（收件人、标题、正文）
2. 询问："确认发送给 xxx 吗？"
3. 用户确认后发送
4. 重复以上步骤发送下一封
```

**踩坑记录**：
| 问题 | 后果 | 教训 |
|------|------|------|
| 直接发送未确认的邮件 | 名字写错、内容错误 | 必须先预览确认 |
| 用【更正】补发 | 显得非常不专业 | 宁可多确认一步 |

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

## 工作流：MinerU 论文图表深度分析（推荐 ⭐）

> **核心价值**：论文中的 Figure/Table 包含大量信息，MinerU 可高保真提取图表，
> 配合 Claude Vision 进行深度分析，生成结构化笔记。

### 完整工作流架构

```
┌─────────────────────────────────────────────────────────────┐
│              MinerU 论文图表笔记工作流 v2.0                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Step 0: Zotero MCP 获取论文 PDF                            │
│                    ↓                                        │
│  Step 1: MinerU 解析 PDF                                    │
│          magic-pdf -p paper.pdf -o output/ -m auto          │
│          → 输出: Markdown + images/ + content.json          │
│                    ↓                                        │
│  Step 2: Claude Vision 批量分析图表                         │
│          - 架构图: 输入→模块→输出→数据流                    │
│          - 实验图: 对比项→指标→关键数据→发现                │
│          - 表格: 结构化数据提取                              │
│                    ↓                                        │
│  Step 3: 整合到 paper-reading 模板                          │
│          Section 1-4 + 图表分析嵌入                         │
│                    ↓                                        │
│  Step 4: 输出到 飞书/Obsidian/本地                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 触发条件
- 用户要求"深度阅读"或"分析图表"
- 论文图表较多（>5张）
- 需要理解复杂架构图
- 关键词：MinerU、图表分析、深度阅读、Figure 分析

### MinerU 工具信息

**GitHub**: https://github.com/opendatalab/MinerU (⭐ 30k+)
**特点**：
- 上海 AI Lab 开源，专为学术论文优化
- 自动提取图片、表格、公式，复杂表格用 HTML 保留样式
- 支持 84 种语言 OCR
- 输出 Markdown + 图片文件夹

**安装**：
```bash
# 推荐使用 uv（更快）
uv pip install magic-pdf

# 首次运行自动下载模型（约 2GB）
```

**使用**：
```bash
magic-pdf -p /path/to/paper.pdf -o /path/to/output/ -m auto
```

### 执行流程示例
```
用户: 帮我用 MinerU 工作流深度阅读这篇论文

Claude 执行:
1. Zotero 获取 PDF
2. 运行 magic-pdf 解析
3. 读取 images/ 中的图表
4. 对每张图执行 Vision 分析
5. 按 Section 1-4 模板整合
6. 询问输出目标（飞书/本地）
```

### 何时使用

| 场景 | 推荐方式 | 原因 |
|------|----------|------|
| 图表多（>5张）、需深度分析 | ✅ MinerU 工作流 | 批量提取 + Vision 分析 |
| 复杂架构图需要理解 | ✅ MinerU 工作流 | Vision LLM 理解图表 |
| 大量实验表格 | ✅ MinerU 工作流 | 保留表格结构 |
| 快速浏览、短论文 | ⚪ 传统 Zotero 方式 | 全文即可 |
| 只需摘要/结论 | ⚪ 传统 Zotero 方式 | 无需图表分析 |

## Skills 强制调用规则

> **⚠️ 重要：Skills 是强制性的工作流模板，不是可选参考！**
>
> 当任务匹配 Skill 触发条件时，**必须**：
> 1. 先读取对应 Skill 文件（`~/.claude/skills/<skill-name>/SKILL.md`）
> 2. **严格按照 Skill 定义的格式和流程执行**
> 3. 不得使用简化格式或自由发挥

Skills 存放在 `~/.claude/skills/`。

---

### paper-reading - 论文阅读（强制格式）

**触发条件**（满足任一即触发）：
- 用户要求阅读/分析论文
- 用户要求创建论文笔记
- 用户要求提取论文信息（方法、实验、结论）
- 关键词：读论文、论文笔记、paper notes、阅读论文、分析论文

**强制规则**：
1. **必须先读取** `~/.claude/skills/paper-reading/SKILL.md`
2. **必须按 Section 1-4 结构输出**：
   - Section 1: Motivation & Problem Definition（含图片分析、案例分析）
   - Section 2: Related Work（按论文原始分类的表格）
   - Section 3: Method（公式解析：输入→计算→输出→直觉理解）
   - Section 4: Experiments（消融实验、关键发现表格）
3. **必须分析论文中的图片**（Figure 1, 2, 3...）
4. **必须解析关键公式**（不只是列出，要解释）
5. **建议分批输出**（长论文分 3-4 次对话完成）

**禁止行为**：
- ❌ 写简化摘要代替完整笔记
- ❌ 跳过图片分析
- ❌ 只列公式不解释
- ❌ 参考已有的简化笔记格式

**正确流程示例**：
```
用户: 帮我读一下 OpenVLA 这篇论文

Claude 应该:
1. 从 Zotero 获取论文全文
2. 读取 ~/.claude/skills/paper-reading/SKILL.md
3. 询问：是否分批输出？先做 Section 1+2？
4. 按 Skill 模板严格输出
```

---

### paper-reproduction - 论文复现（强制流程）

**触发条件**：
- 用户要求复现论文中的方法/算法
- 用户要求实现论文代码
- 关键词：复现、implement、实现论文

**强制规则**：
1. **必须先读取** `~/.claude/skills/paper-reproduction/SKILL.md`
2. **代码实现前必须先读论文全文**
3. **每个超参数都要标注出处**（论文哪一页/哪个表格）
4. 必须验证：论文链接、会议状态、GitHub 仓库

**核心流程**：
1. Zotero 获取论文全文
2. 阅读 Method + Appendix（超参数表格）
3. GitHub 查看官方实现
4. OpenReview 查看审稿问答
5. 实现时标注参数出处

---

### literature-to-feishu - 文献整理

**触发条件**：
- 用户要求将文献整理到飞书
- 用户要求创建文献综述文档
- 关键词：整理到飞书、文献综述、批量整理论文

**强制规则**：
1. **必须先读取** `~/.claude/skills/literature-to-feishu/SKILL.md`
2. 按 Skill 定义的格式输出到飞书

---

### xiaohongshu-writer - 小红书写作

**触发条件**：
- 用户要求创作小红书内容
- 用户要求分析爆款内容
- 关键词：小红书、写笔记、爆款分析

**强制规则**：
1. **必须先读取** `~/.claude/skills/xiaohongshu-writer/SKILL.md`
2. 按 Skill 定义的格式和流程创作

---

### paper-review - 论文审稿（强制格式）

**触发条件**：
- 用户要求审稿/写 review
- 用户提供论文 PDF 并要求评审
- 关键词：审稿、review、peer review、写审稿意见

**强制规则**：
1. **必须先读取** `~/.claude/skills/paper-review/SKILL.md`
2. **必须先读取论文全文**（不能只看摘要）
3. **按会议指定格式输出**（CVPR/NeurIPS/ICLR 各不同）
4. **Major Weaknesses 必须有具体证据**（不能空泛批评）
5. **"done before" 必须给引用**（不能无凭据声明）

**审稿评分参考**：
| 会议 | 推荐分 | 置信度 |
|------|--------|--------|
| CVPR 2026 | 1-6 | 1-5 |
| NeurIPS/ICLR | 1-10 | 1-5 |
| ACL Rolling | 1-5 (多维度) | 1-5 |

**禁止行为**：
- ❌ Ignorance: 无理由声称论文错误
- ❌ Pure Opinion: 主观判断无解释
- ❌ Novelty Fallacy: 仅因"新颖"接受或"渐进"拒绝
- ❌ Blank Assertions: "这已经做过了"无引用
- ❌ Policy Entrepreneurism: 自创标准要求

---

### notion-daily - Notion 每日内容快速访问

**触发条件**：
- 用户要求查看 Notion 今日内容
- 关键词：今日内容、今日待办、今天做什么、看看今天、打开 Notion

**强制规则**：
1. **必须先读取** `~/.claude/skills/notion-daily/SKILL.md`
2. **直接 fetch Getting Started 页面**（不要搜索！）
3. 从子页面列表中找到今天日期的页面
4. Fetch 并显示内容

**核心优化**：
- ⚠️ 每日待办是子页面，Notion 搜索 API 找不到
- ✅ 使用固定 URL 直接访问，跳过搜索步骤

---

### Skill 调用自检清单

每次执行 Skill 相关任务时，自问：

- [ ] 我是否读取了对应的 SKILL.md 文件？
- [ ] 我是否按照 Skill 定义的**完整格式**输出？
- [ ] 我是否分析了论文中的图片（如适用）？
- [ ] 我是否解析了关键公式（如适用）？
- [ ] 我是否在参考已有的简化文件而非 Skill 模板？（这是错误的！）

## 搜索行为规则

### 主动搜索原则 🔍

**遇到不确定的情况，主动联网搜索验证！**

以下场景应主动搜索（无需用户要求）：
- 不确定的事实、数据、统计
- 产品/服务的最新定价
- 工具/库的最新版本和用法
- 时效性强的信息（新闻、政策、活动）
- 自己知识库可能过时的内容

### 搜索触发关键词
当用户消息包含以下关键词时，自动启用多源搜索：
- **直接搜索**：搜索、搜一下、查一下、查询、找一下
- **调研类**：调研、调查、了解一下、研究一下
- **信息获取**：最新、有没有、怎么样、好不好、推荐

### 多源搜索策略（默认启用）
当触发搜索时，**默认使用多个搜索源**以获取更全面的信息：

| 搜索源 | 工具 | 适用场景 | 优先级 |
|--------|------|----------|--------|
| **Web 搜索** | WebSearch / Brave Search | 通用信息、新闻、技术文档 | 必用 |
| **Google 搜索** | google-search MCP | 更精准的 Google 结果 | 可选 |
| **Google Scholar** | google-scholar MCP | 学术论文、引用、作者信息 | 学术话题 |
| **小红书** | xiaohongshu-mcp | 生活经验、产品评测、用户口碑 | 生活话题 |
| **学术文献** | zotero MCP | 本地论文库、已有文献 | 学术话题 |

**执行顺序**（串行，避免速率限制）：
1. WebSearch / Brave - 获取通用网页结果
2. Google Scholar - 获取学术论文（学术/技术话题）
3. 小红书搜索 - 获取用户经验（生活/消费话题）
4. Zotero 语义搜索 - 检索本地论文库（学术话题）

**场景判断**：
| 话题类型 | 使用搜索源 |
|----------|------------|
| 学术/技术 | Web + Google Scholar + Zotero |
| 生活/消费 | Web + 小红书 |
| 产品评测 | Web + 小红书 + Google |
| 综合调研 | 全部 |

**示例**：
```
用户: "搜索一下 Vision Transformer 的最新进展"
→ WebSearch: 技术博客、新闻
→ Google Scholar: 最新论文、引用
→ Zotero: 本地已有论文

用户: "查一下这个耳机怎么样"
→ WebSearch: 评测文章
→ 小红书: 用户真实体验
```

**指定单一来源**：
- "只搜 web" / "只搜谷歌" → 仅 Web/Google
- "只搜小红书" → 仅小红书
- "只搜论文" / "学术搜索" → Google Scholar + Zotero

### 并行搜索策略（已付费解锁 ✅）
Brave Search 已升级付费计划，**可以并行搜索**：
- 最多 20 个请求/秒
- 多个关键词可同时搜索
- 不同搜索源可并行调用（Brave + 小红书 + Zotero）

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

## 每日记忆系统

### 记忆存储位置
`~/.claude/daily-summaries/YYYY-MM-DD.md`

### 触发词（自动读取记忆）
当用户说以下内容时，自动读取最近的总结文件：
- "查询记忆" / "记忆" / "回忆" / "回忆回忆"
- "查询之前" / "之前做了什么" / "昨天做了什么"
- "继续昨天的进度" / "接着上次"
- "读一下总结" / "看看历史"

### 触发词（生成每日总结）
当用户说以下内容时，执行完整的每日总结流程：
- "总结今天" / "今天做了啥"
- "生成每日总结" / "每日总结"
- "/daily-summary"

### 每日总结工作流
1. **读取会话历史** - 从 `~/.claude/projects/` 读取当天所有 JSONL 会话
2. **按板块分类** - 将会话按主题分类（科研、小红书、Claude配置、工具调研等）
3. **生成总结文件** - 保存到 `~/.claude/daily-summaries/YYYY-MM-DD.md`
4. **导出飞书** - 使用 lark-mcp 导出到飞书文档
5. **发送邮件通知** - 使用 `~/.claude/scripts/send_daily_email.py` 发送到 163 邮箱

### 邮件通知配置
**邮箱**: guoyichen021004@163.com
**脚本**: `~/.claude/scripts/send_daily_email.py`

**首次使用需配置授权码**:
1. 登录 mail.163.com
2. 设置 → POP3/SMTP/IMAP → 开启 SMTP 服务
3. 按提示获取授权码（不是邮箱密码！）
4. 设置环境变量:
   ```bash
   # 添加到 ~/.zshrc 或 ~/.bashrc
   export EMAIL_163_AUTH_CODE='你的授权码'
   ```

**手动发送邮件**:
```bash
~/.claude/scripts/send_daily_email.py           # 发送今天的总结
~/.claude/scripts/send_daily_email.py 2025-12-21  # 发送指定日期
```

### 相关命令
- `/memory` - 查询最近的记忆
- `/daily-summary` - 生成今日总结

## 待办清单系统

### 持久化存储
**文件位置**: `~/.claude/todos.md`

每次会话开始时自动读取此文件，待办变更时自动更新。

### 触发词（查看待办）
当用户说以下内容时，**自动读取 `~/.claude/todos.md`**：
- "看看待办" / "待办清单" / "有啥没做完"
- "我的任务" / "还有什么要做" / "todo list"

### 触发词（添加待办）
- "记一下" / "待办加一个" / "先存着"
- "想做 xxx" / "之后要做" / "别忘了"
- "有个想法" / "todo" / "加到清单"

→ 添加后自动更新 `~/.claude/todos.md`

### 触发词（更新状态）
- "开始做 xxx" → 标记 in_progress
- "xxx 做完了" / "完成 xxx" → 标记 completed
- "不做 xxx 了" / "取消 xxx" → 从清单移除

→ 更新后自动保存到 `~/.claude/todos.md`

### 待办管理规则
- 用户随口提到的想法，主动询问是否加入待办
- 每日总结时展示待办进度
- 长期未动的待办（>7天）提醒用户是否还要做
- **会话结束前检查待办是否有变更，如有则更新文件**

### 反思与建议记忆
完成任务或总结工作流后，主动反思并建议可添加的记忆：

**触发时机**：
- 完成复杂任务后
- 总结工作流时
- 发现重复性操作时
- 用户遇到可避免的问题时

**建议格式**：
```
💡 建议添加到记忆：
1. [规则内容] - 原因
2. [规则内容] - 原因
```

**冲突检查流程**（建议前必做）：
1. 先读取当前 CLAUDE.md 内容
2. 检查是否有矛盾规则 → 标注 ⚠️ 冲突
3. 检查是否有重复规则 → 跳过或合并
4. 检查范围是否重叠 → 明确优先级

**建议格式（含冲突标注）**：
```
💡 建议添加：
1. ✅ [新规则] - 无冲突
2. ⚠️ [新规则] - 与「xxx」冲突，建议替换为...
3. 🔄 [新规则] - 已有类似规则，建议合并
```

**其他注意**：
- 用户确认后再用 `#` 添加
- 定期清理过时规则（每月 1 次）

## 网络与代理配置

### 环境检测规则
会话开始时，根据以下情况判断网络环境：
- **需要代理**：访问 Google、GitHub、Docker Hub 等超时或失败
- **不需要代理**：海外网络环境，或已配置透明代理

### 代理命令（zshrc 中定义）
```bash
proxy     # 启用代理 - 端口 7897 (HTTP/SOCKS5)
unproxy   # 关闭代理
```

### 当前代理配置
| 协议 | 地址 | 用途 |
|------|------|------|
| HTTP/HTTPS | `127.0.0.1:7897` | 常规网页访问 |
| SOCKS5 | `127.0.0.1:7897` | Git/SSH 等 |

### 需要代理的服务（在中国大陆）
- Google 搜索 / Google Scholar / Gmail
- GitHub (clone, push, pull, API)
- Docker Hub / ghcr.io
- npm registry (部分包)
- Brave Search API
- OpenAI / Anthropic API
- **Happy** (happy.engineering) - Claude Code 的增强服务

### 不需要代理的服务（no_proxy）
```
localhost,127.0.0.1,::1,*.local,192.168.*,10.*,172.16.*,100.64.*,100.100.100.100
```
- 飞书 API (lark-mcp)
- 小红书 (xiaohongshu-mcp)
- 国内镜像源
- 本地 MCP 服务
- Tailscale 内网 (100.64.* / 100.100.100.100)

### 代理故障排查
当遇到网络超时或连接失败时：

1. **检查代理状态**
   ```bash
   echo $http_proxy   # 查看是否启用
   curl -I https://www.google.com  # 测试连通性
   ```

2. **切换代理状态**
   ```bash
   proxy    # 启用代理
   unproxy  # 关闭代理
   ```

3. **检查代理软件**
   - 确认 ClashX / Surge / V2Ray 等正在运行
   - 检查端口是否正确（当前：7897）

4. **常见问题**
   | 错误信息 | 可能原因 | 解决方案 |
   |----------|----------|----------|
   | `Connection refused` | 代理软件未运行 | 启动代理软件 |
   | `Connection timeout` | 代理服务器无响应 | 切换节点或关闭代理 |
   | `SSL certificate` | 代理 MITM 问题 | 检查证书配置 |

### Claude Code 网络注意事项
- MCP 服务器连接**不走代理**（本地服务）
- WebFetch/WebSearch 可能需要代理
- `git clone` GitHub 仓库需要代理

### MCP 代理配置（重要！）

**问题场景**：当同时运行以下软件时，MCP 工具可能无法访问外网：
- **奇安信 VPN** (TrustAgent) - 企业安全软件，会拦截直连请求
- **Tailscale** - mesh VPN
- **Clash Verge** - 代理软件

**根因**：
```
Shell 环境：有 http_proxy → curl 走代理 → ✅ 成功
MCP 进程：无 http_proxy → 直接连接 → ❌ 被奇安信拦截/超时
```

**解决方案**：在 `~/.claude.json` 的 MCP 配置中显式添加代理环境变量：
```json
"search": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-brave-search"],
  "env": {
    "BRAVE_API_KEY": "xxx",
    "http_proxy": "http://127.0.0.1:7897",
    "https_proxy": "http://127.0.0.1:7897",
    "no_proxy": "localhost,127.0.0.1,::1,*.local,192.168.*,10.*,172.16.*,100.64.*,100.100.100.100"
  }
}
```

**国内/国外切换**：
- **国内**：保持 Clash Verge 运行，代理生效
- **国外**：也保持 Clash 运行，依赖 Clash 智能分流（国内直连、国外走代理）
- **TODO**：后续可能需要一个"国外翻回国内"的梯子

**诊断命令**：
```bash
# 检查 MCP 进程是否有代理环境变量
pgrep -f "mcp-server" | head -1 | xargs -I{} ps eww {}

# 测试直连 vs 代理
curl --noproxy '*' --max-time 5 https://api.search.brave.com  # 直连
curl --max-time 5 https://api.search.brave.com                # 走代理

# 清理僵尸 MCP 进程
pkill -f "mcp-server-brave-search"
```

**踩坑记录**：
| 问题 | 原因 | 解决方案 |
|------|------|----------|
| MCP 工具 fetch failed | MCP 进程无代理环境变量 | 在 MCP 配置中添加 http_proxy |
| 僵尸进程堆积 | 旧会话残留 | `pkill -f "mcp-server"` |
| DNS 解析异常 | 奇安信 DNS 代理 | 检查 `dig @8.8.8.8 域名` |

## Vibe Coding 最佳实践

### 深度思考自动触发

当遇到以下场景时，**自动使用扩展思考模式**（无需用户手动输入 think）：

| 场景 | 触发条件 | 思考级别 |
|------|----------|----------|
| **论文复现** | 实现论文中的算法/方法 | `ultrathink` |
| **修改开源仓库** | 修改他人代码库的核心逻辑 | `ultrathink` |
| **复杂 Bug** | 多轮对话仍未解决的问题 | `ultrathink` |
| **架构设计** | 设计系统架构、模块划分 | `think hard` |
| **性能优化** | 优化算法复杂度、内存使用 | `think hard` |

**思考级别说明**：
- `think` - 标准深度思考
- `think hard` - 更长时间思考，适合复杂问题
- `ultrathink` - 最深度思考，适合论文复现、修改仓库等高难度任务

**自动触发关键词**：
- 论文复现相关：复现、implement、实现论文、reproduce、replication
- 开源仓库相关：修改仓库、改代码、fork、PR、pull request
- Bug 相关：fix bug、debug、报错、error、异常
- 架构相关：设计架构、模块设计、系统设计

### 论文复现强制工作流

> ⚠️ **触发 paper-reproduction Skill 时，必须严格按以下流程执行**

**执行前**：
1. 自动读取 `~/.claude/skills/paper-reproduction/SKILL.md`
2. 自动启用 `ultrathink` 深度思考
3. 查询 memory：是否复现过类似方法？有无踩坑记录？

**执行中**（按 Skill 定义的优先级）：
```
Step 0: Zotero 获取论文 PDF
Step 1: 🔥 DeepWiki 理解官方 GitHub（最重要）
Step 2: 阅读论文 Method + Appendix
Step 3: OpenReview 查看审稿问答
Step 4: 实现（每个参数标注出处）
```

**执行后（强制反思）**：
1. 总结踩过的坑和解决方案
2. 记录关键超参数和来源
3. 写入 memory（更新 `~/.claude/daily-summaries/`）
4. 询问用户是否添加到待办清单的「已完成」

### 复现后反思模板

任务完成后，自动生成反思记录：

```markdown
## 🔬 复现反思: [方法名]

### 📅 时间
YYYY-MM-DD

### 📝 复现内容
- 论文: [标题]
- 仓库: [GitHub 链接]

### ⚠️ 踩坑记录
1. [问题1] → [解决方案]
2. [问题2] → [解决方案]

### 🎯 关键参数
| 参数 | 值 | 来源 |
|------|-----|------|
| xxx | xxx | Paper Table X / Code default |

### 💡 经验教训
- [可复用的经验]

### 🔗 相关资源
- 论文: [arXiv 链接]
- 代码: [GitHub 链接]
- OpenReview: [链接]
```

### Memory 联动

**复现前自动查询**：
```
1. 检索 ~/.claude/daily-summaries/ 中是否有相关方法的记录
2. 检索是否有类似踩坑经验
3. 如有相关记录，先展示给用户参考
```

**复现后自动记录**：
```
1. 将反思记录追加到当天的 daily-summary
2. 如果是重要经验，建议添加到 CLAUDE.md
3. 更新待办清单状态
```

### 会话管理原则

1. **一个会话一个任务** - 完成就 `/clear`，避免上下文压缩
2. **几轮对话解决不了就重开** - 比继续纠缠更高效
3. **出问题就回滚** - `git checkout .` 回到上次提交重新开始
4. **复杂任务用 Plan 模式** - 简单修改直接改，复杂用 plan

### 代码质量保障

- 使用 Hooks 和 pre-commit 保障代码质量
- 不依赖 Claude 做格式检查等机械性工作
- 每次修改后用 Git 管理，每个任务创建分支

## 语言偏好

- 默认使用中文回复
- 代码注释使用英文
