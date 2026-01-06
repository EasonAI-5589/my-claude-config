# Nano Banana MCP

AI 图片生成 MCP 服务器，使用 Google Gemini API。

## 版本对比

| 版本 | 包名 | 模型 | 特点 |
|------|------|------|------|
| **Nano Banana** | `nano-banana-mcp` | Gemini 2.5 Flash | 快速，基础功能 |
| **Nano Banana Pro** | `@rafarafarafa/nano-banana-pro-mcp` | Gemini 3 Pro | 高质量，更多功能 |

---

## Nano Banana Pro (推荐)

### 功能

- **generate_image** - 文字生成图片（支持参考图）
- **edit_image** - 编辑现有图片
- **describe_image** - 图片描述/分析

### 配置

```json
{
  "mcpServers": {
    "nano-banana-pro": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@rafarafarafa/nano-banana-pro-mcp"],
      "env": {
        "GEMINI_API_KEY": "your-gemini-api-key",
        "IMAGE_OUTPUT_DIR": "/Users/yourname/generated_imgs"
      }
    }
  }
}
```

### 代理配置（中国大陆必需）

```json
{
  "mcpServers": {
    "nano-banana-pro": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@rafarafarafa/nano-banana-pro-mcp"],
      "env": {
        "GEMINI_API_KEY": "your-gemini-api-key",
        "IMAGE_OUTPUT_DIR": "/Users/yourname/generated_imgs",
        "NODE_USE_ENV_PROXY": "1",
        "http_proxy": "http://127.0.0.1:7897",
        "https_proxy": "http://127.0.0.1:7897"
      }
    }
  }
}
```

> ⚠️ **重要**: `NODE_USE_ENV_PROXY=1` 是关键！Node.js 原生 fetch 默认不读取代理环境变量。
>
> 详见 [MCP 代理问题排查指南](./mcp-proxy-troubleshooting.md)

### 支持的模型

| 模型 | 说明 |
|------|------|
| `gemini-3-pro-image-preview` | 默认，最高质量 |
| `gemini-2.5-flash-preview-05-20` | 快速版本 |
| `gemini-2.0-flash-exp` | 广泛可用的备选 |

### 图片参数

| 参数 | 可选值 | 默认 |
|------|--------|------|
| `aspectRatio` | `1:1`, `3:4`, `4:3`, `9:16`, `16:9` | `1:1` |
| `imageSize` | `1K`, `2K`, `4K` | `1K` |

### 使用示例

```
生成一张赛博朋克风格的城市夜景，16:9 比例，4K 分辨率
```

```
帮我把这张图片编辑一下，添加一些霓虹灯效果
```

---

## Nano Banana (基础版)

### 功能

- **generate_image** - 文字生成图片
- **edit_image** - 编辑现有图片
- **continue_editing** - 继续优化上一张图片
- **get_last_image_info** - 获取上一张图片信息
- **configure_gemini_token** - 配置 API Key
- **get_configuration_status** - 检查配置状态

### 配置

```json
{
  "mcpServers": {
    "nano-banana": {
      "command": "npx",
      "args": ["nano-banana-mcp"],
      "env": {
        "GEMINI_API_KEY": "your-gemini-api-key"
      }
    }
  }
}
```

---

## 获取 API Key

1. 访问 [Google AI Studio](https://aistudio.google.com/app/apikey)
2. 创建新的 API Key
3. 复制到配置中

## 免费额度

- Google Cloud 新用户有 **$300 赠金**（90天有效）
- 免费层有每日请求限制（约 500-1500 RPD）
- 超额会返回错误，不会自动扣费（除非绑定付款方式）

## 价格参考

| 类型 | 免费层 | 付费价格 |
|------|--------|----------|
| 文本输入 | 有限制 | $2.00/1M tokens |
| 图片输出 | 有限制 | ~$0.13/张 (1K-2K), ~$0.24/张 (4K) |

## 图片存储位置

- **自定义**: `IMAGE_OUTPUT_DIR` 环境变量
- **默认 macOS/Linux**: `./generated_imgs/`
- **默认 Windows**: `%USERPROFILE%\Documents\nano-banana-images\`

## 常见问题

### fetch failed

**原因**: Node.js 原生 fetch 不支持 `http_proxy` 环境变量

**解决**: 添加 `NODE_USE_ENV_PROXY=1` 到 env 配置

详见 [MCP 代理问题排查指南](./mcp-proxy-troubleshooting.md)

### API Key 无效

1. 确认 Key 来自 [Google AI Studio](https://aistudio.google.com/app/apikey)
2. 检查是否过期或被撤销
3. 测试: `curl "https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_KEY"`

### 图片生成失败

- 检查 prompt 是否触发内容审核
- 尝试更换模型 (`gemini-2.0-flash-exp` 限制较少)
- 查看错误信息中的具体原因

## 参考链接

- [Nano Banana Pro GitHub](https://github.com/mrafaeldie12/nano-banana-pro-mcp)
- [Nano Banana GitHub](https://github.com/ConechoAI/Nano-Banana-MCP)
- [Gemini API 定价](https://ai.google.dev/gemini-api/docs/pricing)
- [Google AI Studio](https://aistudio.google.com/)

## 更新日志

- 2025-01-06: 添加 Pro 版本配置、代理配置说明
- 2024-12-17: 初版
