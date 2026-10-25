#!/bin/bash
# =========================================================
# 一键在 GitHub 创建私有仓库 et-x-wrt 并推送所有配置
# 前提：已安装 Git 与 GitHub CLI (gh)，且已执行过 `gh auth login`
# =========================================================
set -e

REPO_NAME="et-x-wrt"

git init
git branch -M main
git add .
git commit -m "Initial commit: EdgeRouter X ImmortalWrt 23.05 auto-build workflow"

if command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --private --source=. --remote=origin --push
  echo "✅ 已成功创建私有仓库 $REPO_NAME 并推送全部文件！"
else
  echo "⚠️ 未检测到 GitHub CLI (gh)。请先在 GitHub 网页新建私有仓库 et-x-wrt，然后执行："
  echo "   git remote add origin https://github.com/<你的GitHub用户名>/et-x-wrt.git"
  echo "   git push -u origin main"
fi
