#!/bin/bash
# 服务器常用 Snippets
# 用法: 复制粘贴对应的代码块到终端

# ============================================================
# 智源 (BAAI) 服务器 - 一键启动代理 + Happy（使用自己的 Clash）
# ============================================================
# 推荐先开 tmux: tmux new -s happy
# 然后粘贴以下代码:

: '
pkill clash 2>/dev/null
cd /share/project/guoyichen/clash && nohup ./clash -d . > /dev/null 2>&1 &
sleep 2
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890
git config --global http.proxy http://127.0.0.1:7890 && git config --global https.proxy http://127.0.0.1:7890
cd /share/project/guoyichen
happy
'

# ============================================================
# 智源服务器 - 仅启动代理（不启动 Happy）
# ============================================================

: '
pkill clash 2>/dev/null
cd /share/project/guoyichen/clash && nohup ./clash -d . > /dev/null 2>&1 &
sleep 2
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890
git config --global http.proxy http://127.0.0.1:7890 && git config --global https.proxy http://127.0.0.1:7890
cd /share/project/guoyichen
'

# ============================================================
# 智源服务器 - 切换节点（避免香港，用日本/美国）
# ============================================================
# 香港节点可能被 Anthropic 封禁（403），推荐日本节点

: '
# 查看可用节点
curl -s http://127.0.0.1:9090/proxies | grep -o "\"name\":\"[^\"]*\"" | head -20

# 切换到日本节点
curl -X PUT "http://127.0.0.1:9090/proxies/🚀%20节点选择" -d "{\"name\":\"🇯🇵 日本 01\"}"

# 验证当前节点
curl -s http://127.0.0.1:9090/proxies/🚀%20节点选择 | grep -o "\"now\":\"[^\"]*\""
'

# ============================================================
# 智源服务器 - 上传本地 Clash 配置到服务器
# ============================================================
# 在 Mac 本地终端运行：

: '
scp "/Users/guoyichen/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/profiles/RsKj8g2pNIi2.yaml" "BAAI2-ssh.platform-sz.jingneng-inner.ac.cn:/share/project/guoyichen/clash/config.yaml"
'

# ============================================================
# 智源服务器 - Git 凭据配置
# ============================================================

: '
git config --global credential.helper store
echo "https://EasonAI-5589:YOUR_GITHUB_TOKEN@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials
git config --global pull.rebase false
'
