#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

. $GITHUB_WORKSPACE/lib/functions.sh

list="\
  autosamba              ddns-scripts_aliyun   ddns-scripts_dnspod \
  luci-app-accesscontrol luci-app-adbyby-plus  luci-app-arpbind      luci-app-autoreboot \
  luci-app-cpufreq       luci-app-ddns         luci-app-filetransfer luci-app-ipsec-vpnd \
  luci-app-nlbwmon       luci-app-ramfree      luci-app-ssr-plus     luci-app-turboacc \
  luci-app-unblockmusic  luci-app-unblockmusic luci-app-upnp         luci-app-vlmcsd \
  luci-app-vsftpd        luci-app-wol          luci-app-zerotier \
"
for i in $list; do
  sed -i    "/router:=/,/^\s*$/s/$i//" include/target.mk
  sed -i "/DEFAULT_PACKAGES/,//s/$i//" target/linux/ipq40xx/Makefile
done

grouprun "git diff"

clone https://github.com/vernesong/OpenClash master package/luci-app-openclash


echo "src-git lienol https://github.com/Lienol/openwrt-package.git;main" >> feeds.conf.default
echo "src-git other https://github.com/Lienol/openwrt-package.git;other" >> feeds.conf.default
echo "src-git diy1 https://github.com/xiaorouji/openwrt-passwall" >> feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
