#!/bin/bash
# =========================================================
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# =========================================================
set -e

# 引入最新 PassWall2 与 SSR-Plus (helloworld) 官方插件源
# 注：HomeProxy 与 Argon 主题已内置于 ImmortalWrt 23.05 官方源中
echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> "feeds.conf.default"
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main" >> "feeds.conf.default"
