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

## 功能列表（12 个工具）

### 账号管理

| 工具 | 说明 |
|------|------|
| `check_login_status` | 检查小红书登录状态 |
| `get_login_qrcode` | 获取登录二维码（返回 Base64 图片和超时时间） |
| `delete_cookies` | 删除 cookies 文件，重置登录状态 |

### 内容浏览

| 工具 | 说明 |
|------|------|
| `list_feeds` | 获取首页 Feeds 推荐列表 |
| `search_feeds` | 搜索小红书内容（支持筛选：排序、时间、类型、位置） |
| `get_feed_detail` | 获取笔记详情（内容、图片、互动数据、评论列表） |
| `user_profile` | 获取用户主页（基本信息、关注/粉丝/获赞量、笔记列表） |

### 内容发布

| 工具 | 说明 |
|------|------|
| `publish_content` | 发布图文内容（标题、正文、图片、话题标签） |
| `publish_with_video` | 发布视频内容（仅支持本地单个视频文件） |

### 互动操作

| 工具 | 说明 |
|------|------|
| `like_feed` | 点赞/取消点赞笔记 |
| `favorite_feed` | 收藏/取消收藏笔记 |
| `post_comment_to_feed` | 发表评论到笔记 |
| `reply_comment_in_feed` | 回复笔记下的指定评论 |

## 参数说明

### search_feeds 筛选参数

| 参数 | 可选值 |
|------|--------|
| `sort_by` | 综合、最新、最多点赞、最多评论、最多收藏 |
| `publish_time` | 不限、一天内、一周内、半年内 |
| `note_type` | 不限、视频、图文 |
| `location` | 不限、同城、附近 |
| `search_scope` | 不限、已看过、未看过、已关注 |

### publish_content 参数

| 参数 | 说明 | 必填 |
|------|------|------|
| `title` | 标题（最多 20 字） | ✅ |
| `content` | 正文（不含话题标签） | ✅ |
| `images` | 图片路径列表（至少 1 张，支持 URL 或本地路径） | ✅ |
| `tags` | 话题标签列表，如 `["美食", "旅行"]` | ❌ |

### get_feed_detail 参数

| 参数 | 说明 | 必填 |
|------|------|------|
| `feed_id` | 笔记 ID | ✅ |
| `xsec_token` | 访问令牌（从 Feed 列表获取） | ✅ |
| `load_all_comments` | 是否加载全部评论（默认只返回前 10 条） | ❌ |
| `click_more_replies` | 是否展开二级回复 | ❌ |

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
