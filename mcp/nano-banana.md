# Nano Banana MCP

AI 图片生成 MCP 服务器，使用 Google Gemini 2.5 Flash Image API。

## 功能

- **generate_image** - 文字生成图片
- **edit_image** - 编辑现有图片
- **continue_editing** - 继续优化上一张图片
- **get_last_image_info** - 获取上一张图片信息
- **configure_gemini_token** - 配置 API Key
- **get_configuration_status** - 检查配置状态

## 配置

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

## 使用示例

```
生成一张赛博朋克风格的城市夜景
```

```
编辑这张图片，添加一些飞鸟
```

```
继续优化，让画面更有戏剧性
```

## 图片存储位置

- **macOS/Linux**: `./generated_imgs/`
- **Windows**: `%USERPROFILE%\Documents\nano-banana-images\`

## 参考链接

- [GitHub 仓库](https://github.com/ConechoAI/Nano-Banana-MCP)
- [Gemini API 定价](https://ai.google.dev/gemini-api/docs/pricing)
- [Google AI Studio](https://aistudio.google.com/)
