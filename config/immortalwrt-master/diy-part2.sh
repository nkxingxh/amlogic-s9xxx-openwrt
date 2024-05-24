#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

# iStore 应用商店
git clone https://github.com/linkease/istore.git package/luci-app-store

# 应用过滤
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

# 哪吒监控
git clone https://github.com/Erope/openwrt_nezha.git package/openwrt_nezha

# 替换 https://github.com/immortalwrt/luci 的 luci-app-qbittorrent
rm -rf feeds/luci/applications/luci-app-qbittorrent
git clone https://github.com/sbwml/luci-app-qbittorrent.git feeds/luci/applications/luci-app-qbittorrent


# 从插件合集中获取部分插件
mkdir package_community

# kiddin9 的插件仓库 (opkg 软件源 https://dl.openwrt.ai/packages-23.05/aarch64_generic/kiddin9/)
git clone https://github.com/kiddin9/openwrt-packages.git package_community/kiddin9

# kenzok8 的插件仓库 (opkg 软件源 https://op.dllkids.xyz/packages/aarch64_generic/)
# git clone https://github.com/kenzok8/small-package.git package_community/kenzok8

# 统一文件共享
mv -f package_community/kiddin9/luci-app-unishare package
mv -f package_community/kiddin9/unishare package
mv -f package_community/kiddin9/webdav2 package

# 易有云
mv -f package_community/kiddin9/luci-app-linkease package
mv -f package_community/kiddin9/linkease package
mv -f package_community/kiddin9/ffmpeg-remux package
mv -f package_community/kiddin9/linkmount package

# 文件传输
mv -f package_community/kiddin9/luci-app-filetransfer package
mv -f package_community/kiddin9/luci-lib-fs package

# iStore 首页
mv -f package_community/kiddin9/luci-app-quickstart package
mv -f package_community/kiddin9/quickstart package

# CUPS 打印
mv -f package_community/kiddin9/luci-app-cupsd package
rm -rf feeds/packages/utils/cups
mv -f package_community/kiddin9/cups feeds/packages/utils
rm -rf feeds/packages/utils/cups-bjnp
mv -f package_community/kiddin9/cups-bjnp feeds/packages/utils

# turboacc 网络加速
mv -f package_community/kiddin9/luci-app-turboacc package

# 哪吒监控 (不从合集中引入)
# mv -f package_community/kiddin9/luci-app-nezha package
# mv -f package_community/kiddin9/openwrt-nezha package/nezha-agent

rm -rf package_community
# end of package_community
