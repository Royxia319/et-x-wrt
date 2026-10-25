# EdgeRouter X (MT7621) ImmortalWrt 自动编译项目 (`et-x-wrt`)

本项目基于 GitHub Actions 自动拉取最新 **ImmortalWrt (`openwrt-23.05` 分支)** 源码以及最新科学上网插件源，为 **Ubiquiti EdgeRouter X (`ubnt_edgerouter-x`)** 定时编译固件并发布到 GitHub Releases。

## 为什么选择 `openwrt-23.05` 分支？

1. **支持从 `18.06-k5.4` 网页端直接升级**：
   - OpenWrt / ImmortalWrt 从 `24.10`（Linux 6.6 内核）开始，由于内核体积超过 EdgeRouter X 原厂 3MB 内核分区限制，必须通过 SSH 脚本重新划分闪存分区才能刷入，**无法**直接从旧版本网页端升级。
   - 而 **`openwrt-23.05`（Linux 5.15 内核）** 保持了原厂 3MB 内核分区布局，支持直接在你现有的 `18.06-k5.4` 网页端（LuCI）刷入 `sysupgrade.bin` 完成升级。
2. **原生支持 `HomeProxy` + `PassWall2` + `SSR-Plus`**：
   - `HomeProxy` 依赖 `fw4` (`nftables`)，仅在 `23.05` 及以上分支提供。因此 `openwrt-23.05` 是同时满足**网页端直接升级**与**三大插件全齐**的最佳版本。

## 固件内置特性

| 类别 | 内置组件与说明 |
| :--- | :--- |
| **目标设备** | Ubiquiti EdgeRouter X (`ramips/mt7621`, 256MB NAND + 256MB RAM) |
| **科学上网插件** | `HomeProxy` (`luci-app-homeproxy`)、`PassWall2` (`luci-app-passwall2`)、`SSR-Plus` (`luci-app-ssr-plus`) |
| **代理核心** | `Sing-box`、`Xray-core`、`Hysteria`、`Shadowsocks-Rust`、`Trojan`、`TUIC-Client`、`ChinaDNS-NG` |
| **硬件加速** | 默认开启 MT7621 软件 + 硬件流量分载 (`flow_offloading=1` & `flow_offloading_hw=1`) |
| **主题与常用工具** | `Argon` 主题（含配置器）、DDNS、UPnP、网络唤醒 (WoL)、Watchcat、TTYD 网页终端、释放内存、定时重启 |

> **内存使用建议**：EdgeRouter X 拥有 256MB 闪存，足以同时安装以上三个插件；但运行时请**只开启其中一个插件**（推荐日常开启 `HomeProxy` 或 `PassWall2`），避免多个内核同时常驻耗尽 256MB 内存。

## 快速上传至你的私有仓库 `et-x-wrt`

### 方法一：网页端直接上传（最简单）
1. 打开 [GitHub 新建仓库页面](https://github.com/new)，Repository name 填写 **`et-x-wrt`**，选择 **Private（私有）**，点击 **Create repository**。
2. 在新建的仓库页面点击 **uploading an existing file**，将解压后的 `erx.config`、`diy-part1.sh`、`diy-part2.sh`、`README.md` 以及 `.github/workflows/build-erx.yml` 拖入上传并点击 **Commit changes**。
   - *注意*：如果网页拖拽没有自动识别隐藏目录 `.github`，可点击 **Add file -> Create new file**，在文件名输入框输入 `.github/workflows/build-erx.yml`，然后将工作流内容粘贴进去提交即可。

### 方法二：使用脚本一键创建并推送
如果你本地安装了 Git 和 GitHub CLI (`gh`)，解压后在目录终端执行：
```bash
chmod +x init-github-repo.sh
./init-github-repo.sh
```

## 自动编译与手动触发说明

- **每月自动更新**：工作流已配置 `cron: '0 18 1 * *'`，会在**每月 1 日北京时间凌晨 02:00** 自动拉取最新 ImmortalWrt 23.05 源码与最新插件源码进行编译，并自动发布到仓库右侧的 **Releases** 中。
- **随时手动编译**：进入仓库顶部 **Actions** 选项卡 -> 点击左侧 **Build EdgeRouter X ImmortalWrt** -> 点击右侧 **Run workflow** 即可立即开始编译（耗时约 40～60 分钟）。
- **关于私有仓库额度**：GitHub 免费账号的 Private 仓库每月享有 **2,000 分钟** 免费 Actions 额度，每月编译 1～2 次仅消耗约 50～100 分钟，完全够用。

## 从 ImmortalWrt 18.06 网页直接升级步骤（必看）

1. 编译完成后，在仓库 **Releases** 页面下载：
   `immortalwrt-ramips-mt7621-ubnt_edgerouter-x-squashfs-sysupgrade.bin`
2. 登录你现有的 EdgeRouter X 网页后台（LuCI 18.06） -> **系统 (System)** -> **备份/升级 (Backup / Flash Firmware)**。
3. 在「刷写新的固件」区域上传刚刚下载的 `*-squashfs-sysupgrade.bin`。
4. **关键步骤（防变砖）**：
   - **务必取消勾选「保留配置 (Keep settings)」**：`18.06` 采用旧版 `swconfig` 交换机驱动，而 `23.05` 采用 `DSA` 独立端口架构且更换了防火墙 `fw4`，保留旧配置会导致升级后 LAN 口无法分配 IP。
   - **勾选「强制升级 (Force upgrade)」**：从 `18.06` 跨越到 `23.05` 时，设备树名称从 `ubnt-erx` 规范化为 `ubnt,edgerouter-x`，系统可能会提示镜像不匹配警告，勾选强制升级即可正常刷入。
5. 点击继续后等待约 2～3 分钟，路由器重启完成后通过默认地址 `http://192.168.1.1`（默认密码为空或 `password`）登录全新的 ImmortalWrt 23.05 后台。
6. **后续月度更新**：一旦升级到 `23.05` 后，今后每个月下载新编译的 `23.05` 固件升级时，均可**正常勾选「保留配置」**无缝升级。
