#!/bin/bash
# =========================================================
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# =========================================================
set -e

# 1. 更新 Golang 至最新版本，确保最新 Sing-box 与 Xray-core 编译不报错
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 2. 优先安装最新插件源中的核心包（覆盖旧版同名包）
./scripts/feeds install -a -f -p passwall_packages
./scripts/feeds install -a -f -p passwall2
./scripts/feeds install -a -f -p helloworld

# 3. 写入首次启动默认配置：默认开启 MT7621 软件+硬件流量分载 (HWNAT)，并设置 Argon 为默认主题
mkdir -p package/base-files/files/etc/uci-defaults
cat << 'EOF' > package/base-files/files/etc/uci-defaults/99-erx-custom
uci set firewall.@defaults[0].flow_offloading='1'
uci set firewall.@defaults[0].flow_offloading_hw='1'
uci commit firewall

uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-erx-custom
