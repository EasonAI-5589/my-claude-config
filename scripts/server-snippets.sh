#!/bin/bash
# 服务器常用 Snippets
# 用法: 复制粘贴对应的代码块到终端

# ============================================================
# 智源 (BAAI) 服务器 - 一键启动代理 + Happy
# ============================================================
# 推荐先开 tmux: tmux new -s happy
# 然后粘贴以下代码:

: '
cd /share/project/yunfan/clash && pkill clash 2>/dev/null; ./clash -d . &
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
cd /share/project/yunfan/clash && pkill clash 2>/dev/null; ./clash -d . &
sleep 2
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890
git config --global http.proxy http://127.0.0.1:7890 && git config --global https.proxy http://127.0.0.1:7890
cd /share/project/guoyichen
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
