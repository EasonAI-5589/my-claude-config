---
name: paper-reproduction
description: 论文复现工作流。通过多源交叉验证确保论文链接、会议状态、GitHub仓库、超参数设置的准确性。
---

# 论文复现 Skill

## 何时使用
- 复现论文中的方法/算法
- 添加新方法到项目时
- 检查现有论文信息是否正确
- 验证会议接收状态

---

## 🔴 代码复现工作流（最重要）

**核心原则：先读官方代码，再读论文，最后实现。每个参数都要有出处。**

> ⚠️ **我们做的是集成实现，不是从零开始。官方代码永远是第一参考源。**

### Step 0: 获取论文和官方仓库
```
# 使用 Zotero MCP 搜索论文
zotero_search_items("方法名 关键词")
zotero_get_item_fulltext(item_key)

# 找到官方 GitHub 仓库
```

### Step 1: 🔥 阅读官方 GitHub（最优先）

**如果有官方实现，这一步最重要！**

```bash
# 使用 DeepWiki MCP 理解仓库结构
mcp__deepwiki__read_wiki_structure("owner/repo")
mcp__deepwiki__ask_question("owner/repo", "what are the core modifications to the model?")

# 重点检查：
1. 核心算法实现文件（哪些文件被修改）
2. config 文件 / argparse 默认值
3. README 中的使用示例和超参数
4. 与 baseline 的 diff（改了什么）
```

**总结核心修改清单：**
- [ ] 修改了哪些文件？
- [ ] 核心算法在哪个函数/类？
- [ ] 默认超参数是什么？
- [ ] 需要新增哪些依赖？

### Step 2: 阅读论文关键部分

| 部分 | 重点内容 |
|------|----------|
| Method | 公式、算法伪代码、关键概念 |
| Experiments | 实验设置、基线对比 |
| Appendix | **超参数表格**（验证与代码一致）|
| Implementation Details | 框架、batch size、学习率等 |

**交叉验证：论文参数 vs 代码默认值**
```
论文 Table X 说 alpha=0.5
代码 argparse default=0.5
✓ 一致
```

### Step 3: OpenReview 补充信息
```
# 搜索论文的审稿意见和作者回复
site:openreview.net "论文标题"

# 重点关注：
- 审稿人对实现细节的质疑
- 作者的澄清和补充说明
- Rebuttal 中的额外实验/超参数
```

### Step 4: 实现（参考官方代码结构）

```python
# 参考官方实现的文件结构
# 例如官方是 vcd/vcd_utils.py，我们也创建类似结构

# 每个关键参数都要注释来源
alpha = 1.0      # Official GitHub default + Paper Section 4.1
beta = 0.1       # Official GitHub default + Paper Section 4.1
noise_step = 500 # Paper Appendix A: "500 for CHAIR"
```

### 代码复现检查清单
- [ ] **阅读官方 GitHub 核心实现**
- [ ] **总结官方修改了哪些文件/函数**
- [ ] 阅读论文 Method 部分的公式
- [ ] 阅读论文 Appendix 的超参数表格
- [ ] 交叉验证：论文参数 = 代码默认值？
- [ ] 每个参数都有论文/代码出处

---

## 🔴 严格审查流程（Code Reviewer 模式）

> **核心原则：带有批判性地审查，有一点问题就会导致实验失败。必须保证完全复现。**

### 审查触发条件
- 添加新方法到项目后
- 修改现有方法的实现后
- 实验结果与论文不符时
- 定期合规性检查

### Step 1: 超参数逐项核对

**必须对照官方源（GitHub/论文）逐一核对每个超参数：**

```markdown
## 超参数核对表 - [方法名]

| 参数 | 官方值 | 来源 | 本地实现 | 状态 |
|------|--------|------|----------|------|
| alpha | 0.2 | GitHub README | 0.5 | 🔴 不匹配 |
| beta | 0.1 | Paper Table 6 | 0.1 | ✅ 匹配 |
| ... | ... | ... | ... | ... |

**官方参考**:
- GitHub: https://github.com/xxx/xxx
- Paper: Section X.X / Table X / Appendix A
```

### Step 2: 多模型一致性检查

**同一方法在不同模型上的参数必须一致（除非论文明确指出不同）：**

```markdown
| 参数 | 官方值 | LLaVA | mPLUG-Owl2 | InstructBLIP | 问题 |
|------|--------|-------|------------|--------------|------|
| alpha | 0.2 | 0.2 | 0.5 | 0.2 | mPLUG 不一致 |
```

### Step 3: 常见错误模式检查

**重点检查这些容易出错的地方：**

| 错误类型 | 检查要点 | 如何验证 |
|----------|----------|----------|
| **超参数错误** | alpha/beta/gamma/lambda 值 | 对照官方 README 和 argparse 默认值 |
| **层索引错误** | start_layer, end_layer | 检查论文是否有模型特定设置 |
| **token 数量错误** | visual_token_num | LLaVA=576, mPLUG-Owl2=65, InstructBLIP=32 |
| **公式实现错误** | 对照论文中的数学公式 | 逐行对比官方代码 |
| **默认值假设** | 官方没写的参数 | 搜索 argparse 的 default= |

### Step 4: 生成审查报告

```markdown
## 🔴 [方法名] 复现审查报告

### 发现的问题

#### 🔴 严重问题（必须修复）
1. **[参数名]**: 官方值 X，本地值 Y
   - 官方来源: [链接/引用]
   - 影响: [描述影响]
   - 修复: `文件:行号` 改为 ...

#### ⚠️ 需确认问题
1. **[参数名]**: 本地值 X，官方未明确
   - 需要确认: [具体问题]

#### ✅ 已验证正确
- [参数1]: 官方值 X，本地值 X ✓
- [参数2]: 官方值 Y，本地值 Y ✓

### 修复建议
1. 修改 `路径/文件.py:行号`: `参数 = 正确值`
2. ...
```

### 审查检查清单
- [ ] 每个超参数都有官方来源（GitHub/论文）
- [ ] 所有模型的参数一致性（或有明确理由不同）
- [ ] 核心公式与论文一致
- [ ] 默认值与官方 argparse 一致
- [ ] 生成详细审查报告

---

## 🐛 Bug 修复流程

**遇到 bug 时，优先查官方实现！**

```
1. 官方 GitHub 怎么写的？ ← 第一步
2. 我们的实现哪里不一样？
3. 对齐官方实现
```

### 常见问题排查
| 问题类型 | 排查顺序 |
|----------|----------|
| 输出格式不对 | 官方的输入输出格式 → 我们的适配 |
| 数值不一致 | 官方默认参数 → 我们的参数 |
| 维度错误 | 官方 tensor shape → 我们的 shape |
| 效果差 | 官方实验设置 → 我们的设置 |

### Bug 修复检查清单
- [ ] 查看官方实现的对应函数
- [ ] 对比官方 vs 我们的实现差异
- [ ] 确认输入输出格式一致
- [ ] 确认超参数一致

---

## 复现优先级

```
1. 官方 GitHub 代码 ← 最可信，直接看实现
2. 论文 Appendix    ← 超参数表格
3. 论文 Method      ← 理解原理
4. OpenReview      ← 补充细节
5. 其他复现仓库    ← 参考，但需验证
```

---

## 验证清单

对于每篇论文，按优先级验证：

| 优先级 | 验证源 | 验证内容 |
|--------|--------|----------|
| **1** | **OpenReview** | 会议接收状态、Poster/Spotlight/Oral（最准确） |
| 2 | arXiv | 论文标题、作者 |
| 3 | GitHub | 仓库与论文对应 |
| 4 | Google Scholar | 交叉确认（可选） |

---

## 验证流程

### Step 1: OpenReview 验证（最重要）
```
搜索: site:openreview.net "论文标题"
或访问: https://openreview.net/forum?id=XXXXXX

确认:
- "Published as a conference paper at XXX" → 已接收
- 查看会议 virtual site 确认类型:
  - https://iclr.cc/virtual/2025/poster/XXXXX → Poster
  - https://iclr.cc/virtual/2025/spotlight/XXXXX → Spotlight
  - https://icml.cc/virtual/2025/poster/XXXXX → Poster
```

### Step 2: arXiv 验证
```
访问: https://arxiv.org/abs/XXXX.XXXXX
确认: 论文标题、作者一致
```

### Step 3: GitHub 验证
```
访问: 仓库链接
确认: README 中的论文标题、arXiv 链接一致
```

### Step 4: Google Scholar 交叉验证（可选）
```
搜索: 论文标题
确认: 发表年份、会议名称
```

---

## 常用验证链接

| 来源 | URL 模板 |
|------|----------|
| arXiv | `https://arxiv.org/abs/XXXX.XXXXX` |
| OpenReview | `https://openreview.net/forum?id=XXXXXX` |
| ICLR 2025 | `https://iclr.cc/virtual/2025/poster/XXXXX` |
| ICML 2025 | `https://icml.cc/virtual/2025/poster/XXXXX` |
| CVPR | `https://openaccess.thecvf.com/` |

---

## 输出格式

验证完成后，更新 README 表格：

```markdown
| Method | Paper | Code | Description |
|--------|-------|------|-------------|
| **NAME** | [VENUE YEAR](arxiv_link) | [GitHub](repo_link) | 简短描述 |
```

**注意**:
- 只写 `ICLR 2025`，不要随意加 `Spotlight` 除非确认
- 使用 OpenReview 或会议官网确认接收类型
