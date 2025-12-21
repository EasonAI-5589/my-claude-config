#!/usr/bin/env python3
"""
每日总结邮件发送脚本
发送到: guoyichen021004@163.com
"""

import smtplib
import os
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
from pathlib import Path

# 配置
SMTP_SERVER = "smtp.163.com"
SMTP_PORT = 465  # SSL
SENDER_EMAIL = "guoyichen021004@163.com"
RECEIVER_EMAIL = "guoyichen021004@163.com"

# 授权码从环境变量读取（安全起见不硬编码）
# 需要在 163 邮箱设置中开启 SMTP 并获取授权码
AUTH_CODE = os.environ.get("EMAIL_163_AUTH_CODE", "")


def read_daily_summary(date_str: str = None) -> str:
    """读取每日总结文件"""
    if date_str is None:
        date_str = datetime.now().strftime("%Y-%m-%d")

    summary_path = Path.home() / ".claude" / "daily-summaries" / f"{date_str}.md"

    if summary_path.exists():
        return summary_path.read_text(encoding="utf-8")
    else:
        return f"# {date_str} 暂无总结\n\n今天还没有生成每日总结。"


def send_email(subject: str, content: str) -> bool:
    """发送邮件"""
    if not AUTH_CODE:
        print("错误: 未设置 EMAIL_163_AUTH_CODE 环境变量")
        print("请先在 163 邮箱开启 SMTP 服务并设置授权码:")
        print("  1. 登录 mail.163.com")
        print("  2. 设置 -> POP3/SMTP/IMAP -> 开启 SMTP")
        print("  3. 获取授权码")
        print("  4. 设置环境变量: export EMAIL_163_AUTH_CODE='你的授权码'")
        return False

    try:
        # 创建邮件
        msg = MIMEMultipart("alternative")
        msg["Subject"] = subject
        msg["From"] = SENDER_EMAIL
        msg["To"] = RECEIVER_EMAIL

        # Markdown 转 HTML（简单处理）
        html_content = markdown_to_html(content)

        # 添加纯文本和 HTML 版本
        part1 = MIMEText(content, "plain", "utf-8")
        part2 = MIMEText(html_content, "html", "utf-8")
        msg.attach(part1)
        msg.attach(part2)

        # 发送
        with smtplib.SMTP_SSL(SMTP_SERVER, SMTP_PORT) as server:
            server.login(SENDER_EMAIL, AUTH_CODE)
            server.sendmail(SENDER_EMAIL, RECEIVER_EMAIL, msg.as_string())

        print(f"✅ 邮件发送成功: {subject}")
        return True

    except smtplib.SMTPAuthenticationError:
        print("❌ 邮件认证失败，请检查授权码是否正确")
        return False
    except Exception as e:
        print(f"❌ 邮件发送失败: {e}")
        return False


def markdown_to_html(md_content: str) -> str:
    """简单的 Markdown 转 HTML"""
    html = md_content

    # 标题
    lines = html.split("\n")
    result = []
    for line in lines:
        if line.startswith("### "):
            result.append(f"<h3>{line[4:]}</h3>")
        elif line.startswith("## "):
            result.append(f"<h2>{line[3:]}</h2>")
        elif line.startswith("# "):
            result.append(f"<h1>{line[2:]}</h1>")
        elif line.startswith("- [x]"):
            result.append(f"<li>✅ {line[6:]}</li>")
        elif line.startswith("- [ ]"):
            result.append(f"<li>⬜ {line[6:]}</li>")
        elif line.startswith("- "):
            result.append(f"<li>{line[2:]}</li>")
        elif line.startswith("**") and line.endswith("**"):
            result.append(f"<strong>{line[2:-2]}</strong>")
        elif line.strip() == "---":
            result.append("<hr>")
        elif line.startswith("|"):
            # 表格行
            result.append(line)
        else:
            result.append(f"<p>{line}</p>" if line.strip() else "<br>")

    html = "\n".join(result)

    # 包装
    return f"""
    <html>
    <head>
        <style>
            body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                   max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; }}
            h1 {{ color: #333; border-bottom: 2px solid #4A90D9; padding-bottom: 10px; }}
            h2 {{ color: #4A90D9; margin-top: 30px; }}
            h3 {{ color: #666; }}
            li {{ margin: 5px 0; }}
            hr {{ border: none; border-top: 1px solid #eee; margin: 20px 0; }}
            table {{ border-collapse: collapse; width: 100%; }}
            th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        </style>
    </head>
    <body>
        {html}
        <hr>
        <p style="color: #999; font-size: 12px;">
            🤖 由 Claude Code 每日总结系统自动生成
        </p>
    </body>
    </html>
    """


def main():
    """主函数"""
    # 支持指定日期
    date_str = sys.argv[1] if len(sys.argv) > 1 else datetime.now().strftime("%Y-%m-%d")

    # 读取总结
    content = read_daily_summary(date_str)

    # 生成标题
    subject = f"📋 每日总结 - {date_str}"

    # 发送邮件
    success = send_email(subject, content)

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
