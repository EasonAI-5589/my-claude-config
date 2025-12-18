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
