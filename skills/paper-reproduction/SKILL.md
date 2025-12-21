---
name: paper-reproduction
description: 论文信息验证工作流。通过多源交叉验证确保论文链接、会议状态、GitHub仓库的准确性。
---

# 论文信息验证 Skill

## 何时使用
- 添加新方法到项目时
- 检查现有论文信息是否正确
- 验证会议接收状态

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
