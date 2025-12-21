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

**核心原则：先读论文，再写代码。每个参数都要有出处。**

### Step 0: 获取论文全文
```
# 使用 Zotero MCP 搜索和获取论文
zotero_search_items("方法名 关键词")
zotero_get_item_fulltext(item_key)
```

### Step 1: 阅读论文关键部分
| 部分 | 重点内容 |
|------|----------|
| Method | 公式、算法伪代码、关键概念 |
| Experiments | 实验设置、基线对比 |
| Appendix | **超参数表格**（最重要！）|
| Implementation Details | 框架、batch size、学习率等 |

### Step 2: 查看官方 GitHub
```
# 使用 DeepWiki MCP 或直接访问
ask_question("github_repo", "what are the default hyperparameters?")

# 重点检查：
- config 文件 / argparse 默认值
- README 中的使用示例
- 核心算法实现
```

### Step 3: OpenReview 补充信息
```
# 搜索论文的审稿意见和作者回复
site:openreview.net "论文标题"

# 重点关注：
- 审稿人对实现细节的质疑
- 作者的澄清和补充说明
- Rebuttal 中的额外实验
```

### Step 4: 实现时标注出处
```python
# 每个关键参数都要注释来源
alpha = 0.7      # Table 6, Appendix A
beta1 = 0.20     # Table 6, LLaVA POPE setting
temperature = 0  # Section 4.1 "we set temperature to 0"
```

### 代码复现检查清单
- [ ] 阅读论文 Method 部分的公式
- [ ] 阅读论文 Appendix 的超参数表格
- [ ] 查看官方 GitHub 的默认配置
- [ ] 确认 temperature、seed 等实验设置
- [ ] 每个参数都有论文/代码出处

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
