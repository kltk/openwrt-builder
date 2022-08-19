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
	luci-app-autoreboot \
	luci-app-filetransfer \
	luci-app-ramfree \
"
for i in $list; do
  sed -i "/DEFAULT_PACKAGES.tweak/,/^\s*$/s/$i//" include/target.mk
  sed -i "/DEFAULT_PACKAGES/,//s/$i//" target/linux/ipq60xx/Makefile
done

clone https://github.com/vernesong/OpenClash master package/luci-app-openclash

echo "src-git diy1 https://github.com/xiaorouji/openwrt-passwall" >> feeds.conf.default
echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
