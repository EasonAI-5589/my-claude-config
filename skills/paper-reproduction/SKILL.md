---
name: paper-reproduction
description: 论文复现工作流。当复现学术论文代码、验证实验结果、对比基准测试时使用。支持多种 VLM 幻觉缓解方法的统一实现。
---

# 论文复现 Skill

## 何时使用
- 复现学术论文的代码实现
- 验证论文链接和仓库的正确性
- 运行基准测试（POPE、CHAIR 等）
- 对比不同方法的实验结果
- 整合多个方法到统一框架

---

## 一、复现前准备

### 1. 论文信息收集

**必须验证的信息**
```markdown
| 项目 | 验证方式 |
|------|----------|
| 论文链接 | 访问 arXiv/OpenReview 确认标题一致 |
| GitHub 仓库 | 访问仓库确认 README 描述匹配 |
| 会议/期刊 | 在官网（如 openreview.net）确认接收状态 |
| 发表类型 | Poster/Spotlight/Oral 需从官方来源确认 |
```

**验证流程**
1. 获取论文 arXiv/OpenReview 链接
2. 访问链接确认论文标题和摘要
3. 获取官方 GitHub 仓库链接
4. 访问仓库确认与论文对应
5. 搜索会议官网确认接收状态（不要只看 arXiv）

### 2. 代码分析

**核心文件识别**
```
官方仓库结构分析:
├── model/           # 模型定义
├── decode/          # 解码策略（重点）
├── eval/            # 评估脚本
├── scripts/         # 运行脚本
└── README.md        # 使用说明
```

**关键代码提取**
- 找到核心算法实现位置
- 识别关键超参数和默认值
- 理解与基础模型的接口方式

---

## 二、实现流程

### 1. 代码迁移策略

**方法分类**
| 类型 | 特点 | 实现位置 |
|------|------|----------|
| Attention 修改 | 修改注意力权重 | `model/attention.py` |
| Logits 处理 | 后处理 logits | `decode/logits_processor.py` |
| Hidden State 干预 | 修改隐藏状态 | `decode/layers.py` |
| 解码策略 | 修改生成流程 | `decode/generate.py` |

**统一接口设计**
```python
# 配置类
@dataclass
class MethodConfig:
    enabled: bool = True
    start_layer: int = 2
    end_layer: int = 32
    # 方法特定参数...

# 应用函数
def apply_method(model, config: MethodConfig):
    """统一的方法应用接口"""
    pass

# 移除函数
def remove_method(model):
    """清理方法修改"""
    pass
```

### 2. 实现检查清单

```markdown
- [ ] 核心算法正确实现
- [ ] 超参数与论文一致
- [ ] 支持多 GPU 并行
- [ ] 与基础模型兼容
- [ ] 不影响其他方法
- [ ] 添加配置选项到脚本
```

---

## 三、验证流程

### 1. 基准测试

**POPE 评估**
```bash
# 标准评估命令
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 bash scripts/v1_5/7b/pope_decode.sh \
    --decode [METHOD] --dataset [gqa|coco|aokvqa]
```

**CHAIR 评估**
```bash
# 标准评估命令
CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 bash scripts/v1_5/7b/chair.sh \
    --decode [METHOD]
```

### 2. 结果验证

**结果对比模板**
```markdown
| Setting | 论文报告 | 我们复现 | 差异 |
|---------|----------|----------|------|
| POPE Random | xx.x | xx.x | ±x.x |
| POPE Popular | xx.x | xx.x | ±x.x |
| POPE Adversarial | xx.x | xx.x | ±x.x |
| CHAIR_s | xx.x | xx.x | ±x.x |
| CHAIR_i | xx.x | xx.x | ±x.x |
```

**可接受偏差**
- POPE Accuracy: ±1.0%
- CHAIR 指标: ±2.0%
- 超出需排查原因

### 3. 差异排查

**常见问题**
1. 超参数不一致
2. 数据预处理差异
3. 随机种子影响
4. 模型版本不同
5. 评估脚本差异

---

## 四、文档更新

### 1. README 更新检查清单

```markdown
添加新方法后需更新:
- [ ] Supported Methods 表格
- [ ] Benchmark Results 表格
- [ ] Quick Start 示例
- [ ] Script Options 说明
- [ ] Method 详细文档章节
- [ ] Citation 引用信息
- [ ] Acknowledgement 致谢
```

### 2. 方法文档模板

```markdown
## [METHOD] Method

**[METHOD] ([Full Name])** [一句话描述方法核心思想]

### Key Insight
[方法的核心观察/动机]

### Core Implementation
\`\`\`python
# 核心代码片段
\`\`\`

### Parameters
| Parameter | Default | Official | Description |
|-----------|---------|----------|-------------|
| param1 | x.x | x.x | 描述 |

### Files
\`\`\`
llava/decode/
├── method_xxx.py    # 主要实现
└── method_utils.py  # 配置和工具
\`\`\`

### Usage
\`\`\`bash
# 使用示例
\`\`\`
```

---

## 五、常用工具

### 链接验证
- arXiv: `https://arxiv.org/abs/XXXX.XXXXX`
- OpenReview: `https://openreview.net/forum?id=XXXXXX`
- 会议官网: ICLR/ICML/NeurIPS/CVPR virtual site

### 代码对比
```bash
# 对比官方实现和本地实现
diff -u official_repo/method.py local_repo/method.py
```

### 结果记录
```bash
# 保存实验结果
python eval/pope_eval.py ... 2>&1 | tee results/method_pope_$(date +%Y%m%d).log
```

---

## 六、质量标准

### 代码质量
- 清晰的函数命名
- 充分的注释说明
- 与现有代码风格一致
- 模块化设计，易于扩展

### 文档质量
- 准确的论文/仓库链接
- 与官方一致的超参数
- 可复现的使用示例
- 完整的结果报告

### 实验质量
- 使用官方推荐的超参数
- 在多个数据集上验证
- 报告均值和标准差（如适用）
- 记录硬件和软件环境

---

## 七、工作流示例

### 添加新方法的完整流程

```
1. 收集信息
   ├── 获取论文链接
   ├── 获取 GitHub 仓库
   └── 确认会议接收状态

2. 代码分析
   ├── 阅读官方 README
   ├── 找到核心实现
   └── 理解接口设计

3. 实现迁移
   ├── 创建配置类
   ├── 实现核心算法
   ├── 添加到统一框架
   └── 更新脚本选项

4. 验证测试
   ├── 运行 POPE 评估
   ├── 运行 CHAIR 评估
   └── 对比论文结果

5. 文档更新
   ├── 更新 README 表格
   ├── 添加方法文档
   └── 更新使用示例

6. 最终检查
   ├── 验证所有链接
   ├── 检查超参数
   └── 确认结果可复现
```

---

## 相关 Skills

- **paper-reading**: 阅读和理解论文内容
- **paper-writing**: 撰写技术文档和论文
