# Lark OpenAPI MCP (飞书 MCP)

官方飞书/Lark OpenAPI MCP 服务器，连接 Claude 与飞书平台，支持文档处理、消息管理、日历等功能。

## 功能

- 📄 **云文档** - 创建、编辑、查看飞书文档
- 📊 **多维表格** - 操作多维表格数据
- 💬 **消息与群组** - 发送消息、管理群组
- 📅 **日历** - 日程管理
- 📁 **云空间** - 文件管理

## 安装

```bash
claude mcp add lark-mcp -- npx -y @larksuiteoapi/lark-mcp mcp -a <APP_ID> -s <APP_SECRET>
```

## 配置

```json
{
  "mcpServers": {
    "lark-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "@larksuiteoapi/lark-mcp",
        "mcp",
        "-a",
        "<your_app_id>",
        "-s",
        "<your_app_secret>"
      ]
    }
  }
}
```

## 获取 App ID 和 App Secret

1. 访问 [飞书开放平台](https://open.feishu.cn/app)
2. 点击"创建企业自建应用"
3. 填写应用信息并创建
4. 在"凭证与基础信息"页面获取 App ID 和 App Secret

## 权限配置

在飞书开放平台的"权限管理"中开通以下权限：

### 云文档权限
- `docx:document` - 创建及编辑新版文档
- `docx:document:readonly` - 查看新版文档
- `docx:document.block:convert` - 文本内容转换为云文档块

### 多维表格权限
- `bitable:app` - 查看、评论、编辑和管理多维表格

### 消息权限（可选）
- `im:message` - 获取与发送单聊、群组消息
- `im:chat` - 获取与更新群组信息

## 使用示例

```
创建一个飞书文档，标题是"文献整理"
```

```
在飞书文档中添加一段关于机器学习的内容
```

```
获取我的飞书文档列表
```

## 高级配置

### 使用配置文件

```bash
lark-mcp mcp --config ./config.json
```

config.json 示例：
```json
{
  "appId": "cli_xxxx",
  "appSecret": "xxxx",
  "domain": "https://open.feishu.cn",
  "language": "zh"
}
```

### 环境变量配置

```bash
export APP_ID=cli_xxxx
export APP_SECRET=yyyyy
lark-mcp mcp
```

### Lark 国际版

```bash
lark-mcp mcp -a <APP_ID> -s <APP_SECRET> -d https://open.larksuite.com
```

## 参考链接

- [GitHub 仓库](https://github.com/larksuite/lark-openapi-mcp)
- [飞书开放平台](https://open.feishu.cn/)
- [飞书 API 文档](https://open.feishu.cn/document/)

## 注意事项

1. 应用创建后需要发布才能正式使用
2. 部分权限可能需要管理员审核
3. 确保飞书账号有相应的文档访问权限
