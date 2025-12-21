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

对于每篇论文，必须验证以下 4 项：

| 项目 | 验证源 | 验证内容 |
|------|--------|----------|
| **论文链接** | arXiv | 标题、作者一致 |
| **会议状态** | OpenReview / 会议官网 | 是否接收、Poster/Spotlight/Oral |
| **GitHub 仓库** | GitHub | README 与论文对应 |
| **年份/会议** | Google Scholar | 交叉确认 |

---

## 验证流程

### Step 1: arXiv 验证
```
访问: https://arxiv.org/abs/XXXX.XXXXX
确认: 论文标题与方法名称一致
```

### Step 2: OpenReview 验证（关键）
```
搜索: https://openreview.net/search?term=论文标题
确认:
- 是否被接收 (看 "Published as a conference paper at XXX")
- 接收类型 (Poster / Spotlight / Oral)
- 或查看会议 virtual site: https://iclr.cc/virtual/2025/poster/XXXXX
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
