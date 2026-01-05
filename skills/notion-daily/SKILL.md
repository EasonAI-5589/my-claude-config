# Notion Daily - 工作区结构说明

## 工作区信息
- **所有者**: 沫若 郭 (moruoguo5589@gmail.com)
- **主页**: Getting Started

## 页面结构

### 📍 Getting Started (固定入口)
**URL**: `https://www.notion.so/78d656a53dae407d916aa740247799c0`

**子页面**:
- `YYYY-MM-DD 待办` - 每日待办清单（格式：2026-01-05 待办）
- `PhD套磁指南` - 教授联系信息

**页面内容**:
- 个人AI系统搭建计划
- 云服务器方案
- 目标追踪（进度百分比）
- 日记/随记
- 周复盘

## 快速访问规则

### 触发词：今日内容 / 今日待办 / 今天做什么
1. 直接 `fetch` Getting Started (不要搜索！)
2. 从 `<page>` 标签中找今天日期的子页面
3. `fetch` 该子页面 URL

### 触发词：套磁 / PhD / 教授
1. `fetch` Getting Started
2. 找到 PhD套磁指南 子页面
3. `fetch` 显示内容

## 重要提示
⚠️ **每日待办是子页面，搜索API找不到！必须通过父页面访问**
✅ **直接用固定URL，不要浪费时间搜索**
