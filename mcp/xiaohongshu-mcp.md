# 小红书 MCP

小红书内容操作，包括搜索、发布、获取详情等。

## 安装

### 1. 克隆项目

```bash
git clone https://github.com/xpzouying/xiaohongshu-mcp.git ~/xiaohongshu-mcp
```

### 2. 登录小红书

```bash
cd ~/xiaohongshu-mcp
./xiaohongshu-login-darwin-arm64  # macOS Apple Silicon
```

### 3. 使用 Docker 运行（推荐）

```bash
# 构建 ARM64 镜像 (Apple Silicon Mac)
docker build -f Dockerfile.arm64 -t xiaohongshu-mcp:arm64 .

# 安装 Chromium 到容器（原镜像不含浏览器）
docker run -d --name xiaohongshu-mcp-temp xiaohongshu-mcp:arm64 sleep infinity
docker exec xiaohongshu-mcp-temp bash -c '
  cd /tmp &&
  wget -q https://playwright.azureedge.net/builds/chromium/1148/chromium-linux-arm64.zip -O chromium.zip &&
  apt-get update && apt-get install -y unzip > /dev/null 2>&1 &&
  unzip -q chromium.zip -d /opt/ &&
  ln -sf /opt/chrome-linux/chrome /usr/bin/google-chrome
'
docker commit xiaohongshu-mcp-temp xiaohongshu-mcp:arm64-with-chromium
docker rm -f xiaohongshu-mcp-temp

# 复制 cookies 到 docker 目录
cp cookies.json docker/data/

# 启动服务
cd docker
docker compose up -d
```

### 4. 添加到 Claude Code

```bash
claude mcp add --transport http xiaohongshu-mcp http://localhost:18060/mcp
```

## 功能

| 工具 | 说明 |
|------|------|
| `check_login_status` | 检查登录状态 |
| `search_feeds` | 搜索小红书内容 |
| `list_feeds` | 获取首页推荐列表 |
| `get_feed_detail` | 获取帖子详情 |
| `publish_content` | 发布图文内容 |
| `publish_with_video` | 发布视频内容 |
| `post_comment_to_feed` | 发表评论 |
| `user_profile` | 获取用户主页 |

## Docker Compose 配置

```yaml
name: xiaohongshu-mcp

services:
  xiaohongshu-mcp:
    image: xiaohongshu-mcp:arm64-with-chromium
    container_name: xiaohongshu-mcp
    restart: unless-stopped
    tty: true
    volumes:
      - ./data:/app/data
      - ./images:/app/images
    environment:
      - ROD_BROWSER_BIN=/usr/bin/google-chrome
      - COOKIES_PATH=/app/data/cookies.json
    ports:
      - "18060:18060"
```

## 注意事项

- 小红书同一账号不允许多个网页端登录
- 每天发帖量上限约 50 篇
- 标题不超过 20 字，正文不超过 1000 字

## 链接

- [GitHub](https://github.com/xpzouying/xiaohongshu-mcp)
