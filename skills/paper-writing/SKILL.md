---
name: paper-writing
description: AI学术论文写作助手。针对顶会论文(CVPR/ICCV/ICML/NeurIPS)的各部分提供专业润色prompts，支持LaTeX公式、数据分析、实验描述。
---

# 论文写作 Skill

## 何时使用
- 写作学术论文各部分（Introduction, Method, Experiment等）
- 润色包含 LaTeX 公式的文本
- 描述实验结果和数据分析
- 生成算法伪代码
- 投稿顶会/顶刊论文

## 目标会议/期刊风格
- AI 顶会：CVPR, ICCV, ICML, NeurIPS, ICLR, AAAI
- 期刊：TPAMI, IJCV, Nature, Science

---

## 一、Title & Abstract

### 标题生成
```
I am submitting a paper to [CONFERENCE/JOURNAL].
The main contribution is: [YOUR CONTRIBUTION]
The key technique is: [YOUR METHOD]

Please suggest 5 academic titles that:
1. Are concise yet descriptive
2. Highlight the novelty
3. Follow the style of top AI venues
4. Consider creating a memorable acronym if appropriate
```

### 摘要润色
```
Polish the following abstract for a [CONFERENCE] submission.
Make it:
1. Start with motivation/problem statement
2. Clearly state the key contribution
3. Highlight main results with specific numbers
4. End with broader impact/significance
Keep within [WORD_LIMIT] words.

[YOUR ABSTRACT]
```

### ⚠️ Abstract 写作避坑指南

#### 1. 绝对不要放引用 (Citation-Free Rule)
```
❌ 错误：
Recent methods~\cite{smith2024,zhang2025,...} have shown improvements...

✅ 正确：
Recent training-free methods have shown improvements...
```
**原因**：
- Abstract 应该自包含，读者可能只读 Abstract
- 引用会让 Abstract 显得累赘，占用宝贵的字数
- 顶会论文的 Abstract 几乎不放引用

#### 2. 字数控制参考标准
| 会议 | 字数范围 | 参考论文示例 |
|------|----------|-------------|
| ACL/EMNLP | 150-200 | - |
| CVPR/ICCV | 150-250 | VCD (CVPR 2024) ~165 words |
| ICML/NeurIPS | 100-200 | VISTA (ICML 2025) ~230 words |

**建议**：
- 参考同领域顶会论文的 Abstract 长度
- 用 Google Scholar 或 arXiv 查看近期录用论文
- 用注释记录目标字数和参考论文

```latex
% ============================================================
% ABSTRACT STRUCTURE (Target: 180-200 words, Current: ~185 words)
% ============================================================
% 参考: VCD (CVPR 2024) ~165 words, VISTA (ICML 2025) ~230 words
% ACL 标准: 150-200 words
% ...
% ============================================================
```

#### 3. 具体化 vs 抽象化
```
❌ 太抽象：
Existing methods apply static corrections uniformly across samples...

✅ 具体化：
Existing methods apply static corrections---such as fixed attention
amplification or pre-computed steering vectors---uniformly across samples...
```
**为什么要具体化**：
- 让审稿人清楚你在批评什么
- 避免 "straw man" 攻击（批评一个不存在的假想敌）
- 给出具体例子更有说服力

#### 4. 与 baseline 方法明确区分
```
❌ 模糊区分：
Unlike existing methods, our approach is adaptive...

✅ 明确区分：
Unlike fixed-vector steering methods, our corrections adapt in
real-time based on each sample's observed drift...
```
**关键要素**：
- 指出 baseline 的核心特征（fixed-vector, pre-computed）
- 明确你的方法的核心特征（real-time, sample-specific）
- 使用对比词：Unlike, In contrast to, Different from

#### 5. 结果表述的谦虚原则
| 方法状态 | 错误表述 | 正确表述 |
|----------|----------|----------|
| 陪跑阶段 | "improves by X%" | "achieves competitive performance" |
| SOTA | "achieves SOTA" | "achieves state-of-the-art performance" |
| 部分领先 | "outperforms all baselines" | "outperforms most baselines" |

**注意**：
- 如果你的方法还在"陪跑"（和 baseline 差不多），不要过度承诺
- 用 "competitive" 而非具体数字
- 强调 novelty 而非 performance

### 模型命名
```
I am submitting to a top AI conference. My model does [DESCRIPTION].
The current name is too simple: [CURRENT_NAME]

Please suggest professional academic names that:
1. Have sophisticated taste suitable for top venues
2. Consider meaningful acronyms
3. Avoid simple/generic terms
```

---

## 二、Introduction

### ⚠️ Introduction 写作核心原则

#### 1. 绝对不要写公式！
```
❌ 错误：在 Introduction 写公式
\begin{equation}
    \mathcal{E}_l = \log p(y|h^{(l+1)}) - \beta \cdot D_l
\end{equation}

✅ 正确：高层次概念描述
"We propose a self-consistency measure that balances prediction
confidence against distributional drift."
```

**原因**：
- Introduction 讲 "what" 和 "why"，不讲 "how"
- 公式 = 技术细节 = 属于 Method 部分
- 参考 DAMO/DoLA/VCD/VISTA 等顶会论文，Introduction 都没有公式

#### 2. 保持已有的好段落
```
❌ 错误做法：
- 看到别人写的段落，觉得可以改得更好
- 大幅重写已经写好的开头段落
- 用啰嗦的例子替换简洁的学术表述

✅ 正确做法：
- 先看原来的版本是否已经很好
- 只修改明确有问题的部分
- 保持原有的学术风格和简洁性
```

**教训**：
- 学术写作要简洁，不要啰嗦
- 已有的好段落不要轻易大改
- 改写前先问：原来的版本有什么问题？

#### 3. 典型 Introduction 结构（7段 + Figure）

```
[Para 1] Problem Statement (~100 words)
  - 领域进展 → 问题定义 → 关键应用风险

[Para 2] Existing Understanding (~120 words)
  - 问题原因分析（3 factors）
  - 现有解决方法
  - 局限性

[Figure] Overview figure - 放在这里！

[Para 3] Existing Methods Limitation (~90 words)
  - 共同局限：static, predefined strategies
  - 具体例子
  - 问题：over/under-correction

[Para 4-5] Our Insight (~180 words)
  - 核心观察（conceptual, no formulas）
  - 区分有益/有害的现象
  - 自洽性度量（概念层面）

[Para 6] Our Method (~110 words)
  - 方法名称 + 高层次描述
  - 关键机制（概念，无公式）
  - 与现有方法对比

[Para 7] Contributions (~50 words)
  - 3-4 点贡献列表
```

### 📌 Overview Figure 放置建议

**推荐位置**：Para 2 之后、Para 3 之前

```latex
Recent studies have attributed hallucination...
Nevertheless, these approaches treat hallucination primarily
as a static factual deficiency.

\begin{figure*}[!t]  % 注意用 [!t] 强制置顶
    \centering
    \includegraphics[width=\textwidth]{figures/overview.png}
    \caption{...}
    \label{fig:overview}
\end{figure*}

However, a fundamental limitation underlies this progress...
```

**为什么这个位置好**：
- Para 2 讲完了现有理解，自然引出 overview
- 图片出现后，Para 3-6 可以引用图片说明
- 排版更稳定，容易排到第二页开头

**图片位置调试经验**：
- `[!t]` placement 只是建议，实际位置更重要
- 如果排版不理想，尝试移动到前一段或后一段
- 通常需要试 2-3 次才能找到最佳位置
- 图片太靠后可能跑到第三页去

### Introduction 结构润色
```
Polish my Introduction section following the classic structure:
1. Hook: What is the big picture problem?
2. Gap: What's missing in current approaches?
3. Contribution: What do we propose?
4. Results preview: What did we achieve?
5. Paper organization (optional)

Keep all LaTeX commands. Follow top AI conference style.

[YOUR INTRODUCTION]
```

### 动机段落
```
I'm writing a paper on [TOPIC]. Help me write a compelling motivation paragraph that:
1. Establishes the importance of the problem
2. Identifies limitations of existing methods
3. Naturally leads to our proposed solution

Keep academic tone, cite-ready (leave [CITE] placeholders).
```

### 贡献列表
```
Based on my paper's content:
[BRIEF DESCRIPTION OF YOUR WORK]

Help me write a clear "Our contributions are summarized as follows:" section with 3-4 bullet points that:
1. Each contribution is specific and verifiable
2. Ordered by importance
3. Uses precise language (avoid "novel", prefer specific claims)
```

---

## 三、Related Work

### Related Work 结构化
```
I'm writing related work for a paper on [YOUR TOPIC].
The main categories of related work are:
1. [CATEGORY 1]
2. [CATEGORY 2]
3. [CATEGORY 3]

For each category, help me write 1-2 paragraphs that:
1. Summarize the main approaches
2. Identify their limitations
3. Position our work's difference
Keep [CITE] placeholders for references.
```

### 方法对比段落
```
Compare and contrast the following methods in the context of [RESEARCH DOMAIN]:
- Method A: [DESCRIPTION]
- Method B: [DESCRIPTION]
- Our method: [DESCRIPTION]

Write an academic paragraph highlighting:
1. What each method does
2. Their respective limitations
3. How our approach addresses these limitations
```

---

## 四、Method（重点）

### 整体方法润色（保留LaTeX）
```
The following is my Method section. Polish it to meet top AI conference standards:
- Improve clarity, coherence, and academic style
- Make the flow logical and interconnected
- Keep ALL LaTeX commands and equations unchanged
- Follow CVPR/ICCV/NeurIPS writing conventions

[YOUR METHOD SECTION]
```

### 公式解释
```
I have the following equation in my paper:
[YOUR LATEX EQUATION]

Write a clear explanation paragraph that:
1. Introduces what this equation computes
2. Defines each variable/symbol (e.g., "where $x$ denotes...")
3. Explains the intuition behind the formulation
4. Connects to the overall method

Keep academic style, suitable for top AI venues.
```

### Loss Function 描述
```
I designed the following loss function:
[YOUR LOSS FUNCTION]

Help me write a subsection "Training Objective" that:
1. Introduces the overall training objective
2. Explains each loss term and its purpose
3. Describes weighting factors if any
4. Optionally discusses why this formulation is effective

Example structure:
"Our model is trained end-to-end by minimizing:
$\mathcal{L} = ...$
where the first term ... and the second term ..."
```

### 算法伪代码生成
```
Generate LaTeX pseudo-algorithm (algorithm2e or algorithmic) based on this PyTorch code.
Focus on:
1. Major computational steps
2. Clear input/output specification
3. Key operations highlighted

[YOUR PYTORCH CODE]
```

### 架构描述
```
Describe the following neural network architecture for an academic paper:
- Input: [DESCRIPTION]
- Components: [LIST MODULES]
- Output: [DESCRIPTION]

Write 2-3 paragraphs covering:
1. Overall architecture overview (with figure reference)
2. Each component's role and design choice
3. How information flows through the network
```

### 数学推导
```
I derived this equation:
[TARGET EQUATION]

From this starting point:
[STARTING EQUATION]

Help me write clear intermediate derivation steps suitable for:
- Main paper (key steps only)
- OR supplementary material (detailed derivation)

Specify which.
```

---

## 五、Experiment（重点）

### 实验部分整体润色
```
Polish my Experiment section:
- Improve academic style and readability
- Make descriptions concise but complete
- Ensure logical flow between subsections
- Keep all LaTeX commands (tables, figures, equations)
- Follow top AI conference conventions

Typical structure:
1. Experimental Setup (datasets, metrics, baselines, implementation)
2. Main Results (quantitative comparison)
3. Ablation Studies
4. Qualitative Results / Visualization
5. Analysis / Discussion

[YOUR EXPERIMENT SECTION]
```

### 实验设置描述
```
Write an "Experimental Setup" subsection including:

**Datasets:**
[LIST YOUR DATASETS WITH BRIEF STATS]

**Evaluation Metrics:**
[LIST METRICS]

**Baselines:**
[LIST COMPARED METHODS]

**Implementation Details:**
[KEY HYPERPARAMETERS, HARDWARE, TRAINING TIME]

Make it concise, complete, and reproducibility-focused.
```

### 结果表格描述
```
Here is my results table:
[YOUR LATEX TABLE]

Write 1-2 paragraphs analyzing these results:
1. Overall performance summary
2. Comparison with state-of-the-art
3. Performance on different subsets/scenarios
4. Notable observations

Be objective, acknowledge where we don't outperform.
```

### Ablation Study 描述
```
Here are my ablation study results:
[YOUR ABLATION TABLE]

Write analysis paragraphs that:
1. State the purpose of ablation study
2. Analyze contribution of each component
3. Discuss which components are most important
4. Draw insights about the method design

Structure: One paragraph per ablation group.
```

### 统计显著性描述
```
Report the following results with proper statistical rigor:
- Our method: mean=[X], std=[Y], n=[Z] runs
- Baseline: mean=[X], std=[Y], n=[Z] runs

Write a statistically sound paragraph that:
1. Reports mean ± std correctly
2. Discusses significance if applicable
3. Follows ML reporting best practices
```

### 定性结果描述
```
I have qualitative visualizations showing:
[DESCRIBE WHAT YOUR FIGURES SHOW]

Write:
1. A paragraph describing the qualitative results
2. Figure caption(s) in academic style

Highlight what the visualizations demonstrate about the method's effectiveness.
```

### Failure Case 分析
```
Our method fails in these cases:
[DESCRIBE FAILURE CASES]

Write an honest "Limitations" or "Failure Cases" paragraph that:
1. Objectively describes when the method fails
2. Analyzes potential reasons
3. Suggests future directions to address them

This demonstrates scientific rigor.
```

---

## 六、Conclusion

### Conclusion 生成
```
Write a Conclusion section based on:

Main contribution: [YOUR CONTRIBUTION]
Key results: [BRIEF RESULTS]
Limitations: [KNOWN LIMITATIONS]

Structure:
1. Summary of what we did (1-2 sentences)
2. Key findings/contributions
3. Limitations and future work (brief)
4. Broader impact (optional, 1 sentence)

Keep within [WORD_LIMIT] words.
```

---

## 七、通用润色工具

### 学术风格转换（保留LaTeX）
```
I would like to enlist your services as an academic writing consultant.
Refine the following text with more sophisticated academic language.

IMPORTANT:
- Preserve ALL LaTeX commands in original format
- Keep the fundamental meaning unchanged
- Follow top AI conference style (CVPR/NeurIPS)
- If Chinese appears, translate and integrate naturally
- Only return the improved text, no explanations

[YOUR TEXT]
```

### 段落连接
```
Write a transition sentence to connect these two paragraphs smoothly:

Paragraph 1: [FIRST PARAGRAPH]
Paragraph 2: [SECOND PARAGRAPH]

The transition should be natural and maintain academic flow.
```

### 重复词检查
```
Identify words and phrases used more than 3 times in this text.
Provide synonyms appropriate for academic writing.

[YOUR TEXT]
```

### Reviewer 视角检查
```
Act as a critical reviewer for [CONFERENCE].
Review the following section and point out:
1. Clarity issues
2. Missing information
3. Logical gaps
4. Potential reviewer concerns

[YOUR SECTION]
```

---

## 八、Rebuttal 写作

### Rebuttal 回复模板
```
Reviewer comment:
"[REVIEWER COMMENT]"

Help me write a professional rebuttal response that:
1. Thanks the reviewer for the feedback
2. Addresses the concern directly
3. Provides evidence/clarification
4. Describes any changes made (if applicable)

Keep tone respectful and constructive.
```

---

## 九、投稿前 Checklist

### 📋 格式与引用检查

#### LaTeX 引用格式
- [ ] **统一引用格式** - 所有引用使用 `~\cite{...}`（波浪号不可断行空格）
  - ❌ 错误：`text \cite{key}`
  - ✅ 正确：`text~\cite{key}`
- [ ] **引用命令统一** - 不混用 `\cite` 和 `\citep`
  - 如果需要文本引用，使用 `\citet{key}`
  - 如果需要括号引用，统一使用 `\cite{key}`
- [ ] **引用 key 拼写检查** - 验证所有 cite key 在 .bib 文件中存在
  ```bash
  # 检查命令
  grep -oh "\\cite{[^}]*}" *.tex | sed 's/\\cite{//;s/}//' | sort -u
  ```
- [ ] **BibTeX 条目完整性**
  - 所有引用都有完整的 author、title、year
  - 会议/期刊名称规范（使用全称或缩写保持一致）
  - URL 和 DOI 格式正确

#### LaTeX 编译检查
- [ ] 运行 `pdflatex` 无 warning
- [ ] 运行 `bibtex` 无错误
- [ ] 所有引用都正确显示（无 `[?]`）
- [ ] 所有 cross-reference 正确（`\ref`, `\eqref`）
- [ ] 所有图表都正确引用

#### 公式与符号
- [ ] 所有数学符号定义清晰（首次使用时说明）
- [ ] 公式编号一致（equation vs. align vs. gather）
- [ ] 变量命名规范
  - 标量：斜体 `$x$`
  - 向量：粗体 `$\mathbf{x}$` 或箭头 `$\vec{x}$`
  - 矩阵：大写粗体 `$\mathbf{X}$`
  - 集合：花体 `$\mathcal{X}$`
- [ ] 公式后标点符号正确
  ```latex
  \begin{equation}
      \mathcal{L} = \mathcal{L}_1 + \mathcal{L}_2, \label{eq:loss}
  \end{equation}
  where ...
  ```

### 📝 内容完整性检查

#### Abstract
- [ ] 包含 4 个要素：问题、方法、结果、意义
- [ ] 字数在会议限制内（通常 150-250 词）
  - 参考同领域顶会论文（Google Scholar / arXiv）
  - 用注释记录目标字数和参考论文
- [ ] **绝对不要有引用** - Abstract 必须 citation-free
- [ ] 现有方法描述具体化（给出具体例子，避免抽象批评）
- [ ] 与 baseline 方法明确区分（指出核心差异）
- [ ] 结果表述谦虚（陪跑阶段用 "competitive performance"）
- [ ] 包含具体数字（性能提升、数据集规模等）- 除非方法还在陪跑

#### Introduction
- [ ] Hook 段落吸引人
- [ ] 清晰陈述研究问题
- [ ] 现有方法的局限性
- [ ] 本文贡献列表（3-4 点）
- [ ] 组织结构说明（可选）

#### Related Work
- [ ] 分类清晰（2-4 个子类别）
- [ ] 每个类别都有代表性工作
- [ ] 指出每类方法的局限性
- [ ] 明确本文与相关工作的区别

#### Method
- [ ] 整体框架图（Figure 1 或 Figure 2）
- [ ] 符号定义表（Notation table）
- [ ] 每个公式都有解释
- [ ] 算法伪代码（如适用）
- [ ] Loss function 定义清晰
- [ ] 训练/推理流程描述

#### Experiment
- [ ] **Datasets** - 名称、规模、split、来源
- [ ] **Metrics** - 定义评价指标
- [ ] **Baselines** - 列出对比方法（≥3 个）
- [ ] **Implementation Details**
  - 模型架构参数
  - 训练超参数（lr, batch size, epochs）
  - 硬件环境（GPU 型号、数量）
  - 训练时间
- [ ] **Main Results** - 主实验表格
- [ ] **Ablation Study** - 消融实验
- [ ] **Visualization** - 定性结果图
- [ ] **Statistical Significance** - 报告 mean ± std

#### Conclusion
- [ ] 总结主要贡献（2-3 句）
- [ ] Limitations（诚实描述）
- [ ] Future work（简短）

### 🎯 会议特定要求

#### CVPR/ICCV
- [ ] 页数限制：8 页正文 + N 页参考文献
- [ ] 双栏格式
- [ ] Supplementary Material 准备
- [ ] Blind review（匿名化）
- [ ] Ethics Statement（如适用）

#### NeurIPS/ICML
- [ ] 页数限制：9 页正文（NeurIPS）/ 8 页（ICML）
- [ ] Broader Impact Statement
- [ ] Reproducibility Checklist
- [ ] Code/Data 提交

#### ACL/EMNLP
- [ ] 长文 8 页 / 短文 4 页
- [ ] Limitations 部分（ACL 2023+）
- [ ] Ethics Statement

### 🔍 质量检查

#### 语言与风格
- [ ] 无拼写错误（使用 Grammarly / LanguageTool）
- [ ] 无语法错误
- [ ] 时态一致（通常用现在时描述方法，过去时描述实验）
- [ ] 避免口语化表达
- [ ] 避免模糊词汇（"some", "several" → 给出具体数字）
- [ ] 避免绝对词汇（"always", "never" → "typically", "often"）

#### 图表
- [ ] 所有图表都有 caption
- [ ] Caption 独立可读（不依赖正文）
- [ ] 图表清晰（字体大小适中）
- [ ] 图表在正文中被引用
- [ ] 表格使用 booktabs 包（`\toprule`, `\midrule`, `\bottomrule`）
- [ ] 最佳结果加粗（`\textbf{}`）

#### 可复现性
- [ ] 代码链接（GitHub）
- [ ] 数据集链接
- [ ] 预训练模型链接
- [ ] 超参数完整记录
- [ ] Random seed 设置

### ⚠️ 常见错误检查

- [ ] **Abstract 包含引用** - 这是最严重的错误！Abstract 必须 citation-free
- [ ] **Abstract 太抽象** - 批评现有方法时要给具体例子
- [ ] **与 baseline 区分不清** - 要明确指出核心差异
- [ ] **引用格式混乱** - 见上方"LaTeX 引用格式"
- [ ] **图表编号跳跃** - 确保连续（Figure 1, 2, 3...）
- [ ] **参考文献不完整** - 缺少 year, venue, pages
- [ ] **公式编号遗漏** - 重要公式都要编号
- [ ] **实验结果不报告方差** - 多次运行报告 mean ± std
- [ ] **Baseline 对比不足** - 至少对比 3 个 SOTA 方法
- [ ] **Ablation 不充分** - 每个组件都要验证
- [ ] **Supplementary 未提及** - 正文中引用附录内容
- [ ] **Overview figure 位置不当** - 建议放在第二页开头（Related Work 之前）

---

## 十、Citation 验证工作流（Few-Shot Examples）

### 示例 1: 验证并修正错误引用

```
❌ 错误引用（AI 可能编造的）:
Recent work on diffusion models~\cite{smith2024diffusion} shows...

🔍 验证步骤：
1. Google Scholar 搜索: "Smith 2024 diffusion"
2. 结果：找不到此论文 ❌

✅ 修正：
搜索: "diffusion models 2024"
找到: "Denoising Diffusion Probabilistic Models" (Ho et al., NeurIPS 2020)

正确引用:
Recent work on diffusion models~\cite{ho2020denoising} shows...

BibTeX:
@inproceedings{ho2020denoising,
  title={Denoising Diffusion Probabilistic Models},
  author={Ho, Jonathan and Jain, Ajay and Abbeel, Pieter},
  booktitle={Advances in Neural Information Processing Systems (NeurIPS)},
  year={2020}
}
```

### 示例 2: 从 Google Scholar 获取正确格式

```
需要引用: "Attention Is All You Need"

🔍 Google Scholar 步骤：
1. 搜索: "Attention Is All You Need"
2. 点击 "Cite" → 选择 "BibTeX"
3. 获取：

@article{vaswani2017attention,
  title={Attention is all you need},
  author={Vaswani, Ashish and Shazeer, Noam and ...},
  journal={Advances in neural information processing systems},
  volume={30},
  year={2017}
}

⚠️ 修正（这是会议不是期刊）：
@inproceedings{vaswani2017attention,
  title={Attention is All You Need},
  author={Vaswani, Ashish and Shazeer, Noam and Parmar, Niki and ...},
  booktitle={Advances in Neural Information Processing Systems (NeurIPS)},
  year={2017}
}
```

### 示例 3: 验证引用格式一致性

```
❌ 格式不一致：
@inproceedings{paper1,
  booktitle={CVPR},  % 缩写
  year={2024}
}
@inproceedings{paper2,
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition},  % 全称
  year={2024}
}

✅ 统一格式：
@inproceedings{paper1,
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
  year={2024}
}
@inproceedings{paper2,
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
  year={2024}
}
```

### 示例 4: 检查引用 key 拼写

```
LaTeX 文件:
We use ResNet~\cite{he2016deep} architecture.

.bib 文件:
@inproceedings{he2016resnet,  % ❌ key 不匹配！
  title={Deep Residual Learning...},
  ...
}

✅ 修正（两种方式）：
方式 1: 改 LaTeX
We use ResNet~\cite{he2016resnet} architecture.

方式 2: 改 .bib (推荐，保持引用 key 的可读性)
@inproceedings{he2016deep,
  title={Deep Residual Learning...},
  ...
}
```

### AI 验证 Prompt (简化版)

```
验证这个引用是否正确：

Title: [TITLE]
Authors: [AUTHORS]
Year: [YEAR]
Venue: [VENUE]

步骤：
1. Google Scholar 搜索标题
2. 检查作者、年份、会议是否匹配
3. 如不匹配，提供正确的 BibTeX

输出：
✅ 正确 / ❌ 错误: [原因]
正确 BibTeX: [如需修正]
```

---

## 常用工具

| 工具 | 用途 |
|------|------|
| **TeXGPT** | Overleaf 内置 AI |
| **Grammarly** | 语法检查 |
| **ChatPaper** | 论文阅读 |
| **chatgpt_academic** | 学术专用 GPT |
| **Writefull** | 学术写作辅助 |

## 注意事项

1. **必须核实引用** - AI 可能生成假引用
2. **保持原创性** - AI 用于润色，不是代写
3. **检查 AI 痕迹** - 编辑过度使用的破折号等
4. **保留 LaTeX** - 始终强调保留公式命令
5. **迭代优化** - 分段润色，不要一次性全文

---

## 参考资源

- [ChatGPT-Academic-Prompt](https://github.com/xuhangc/ChatGPT-Academic-Prompt)
- [chatgpt-prompts-for-academic-writing](https://github.com/ahmetbersoz/chatgpt-prompts-for-academic-writing)
- [chatgpt_academic](https://github.com/binary-husky/chatgpt_academic)
