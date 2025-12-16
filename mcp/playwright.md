# Playwright MCP

浏览器自动化，网页交互和截图。

## 安装

```bash
claude mcp add playwright -- npx @playwright/mcp@latest --headless
```

## 用途

- 网页自动化测试
- 爬取网页数据
- 截图或网页交互
- 填写表单、点击按钮等操作

## 常用操作

- `browser_navigate` - 导航到 URL
- `browser_snapshot` - 获取页面快照
- `browser_click` - 点击元素
- `browser_type` - 输入文本
- `browser_take_screenshot` - 截图

## 示例

```
"打开 https://example.com 并截图"
→ Playwright 会打开网页并返回截图
```

## 链接

- [Playwright 官网](https://playwright.dev)
- [GitHub](https://github.com/microsoft/playwright)
