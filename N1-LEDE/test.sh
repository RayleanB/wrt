#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" rurl="$2" localdir="$3" && shift 3
  git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
  cd $localdir
  git sparse-checkout init --cone
  git sparse-checkout set $@
  mv -n $@ ../
  cd ..
  rm -rf $localdir
}

###########################################################################
# 自定义添加
# git clone --depth=1 https://github.com/vernesong/OpenClash package/OpenClash
git clone --depth=1 https://github.com/tty228/luci-app-wechatpush package/wechatpush
# git clone --depth=1 https://github.com/sundaqiang/openwrt-packages package/openwrt-packages
# mv package/openwrt-packages/luci-app-wolplus package/luci-app-wolplus
# rm -rf package/openwrt-packages
# git clone --depth=1 https://github.com/kuoruan/openwrt-frp package/openwrt-frp
# git clone --depth=1 https://github.com/superzjg/luci-app-frpc_frps package/luci-app-frpc_frps
# git clone --depth=1 https://github.com/gw826943555/openwrt_msd_lite package/openwrt_msd_lite
# git clone --depth=1 https://github.com/riverscn/openwrt-iptvhelper package/openwrt-iptvhelper
###########################################################################
# Add packages
rm -rf feeds/luci/applications/luci-app-wrtbwmon
git clone --depth 1 https://github.com/brvphoenix/wrtbwmon package/wrtbwmon
git clone --depth 1 https://github.com/brvphoenix/luci-app-wrtbwmon package/luci-app-wrtbwmon

# nps
rm -rf feeds/packages/net/nps
rm -rf feeds/luci/applications/luci-app-nps
git clone --depth=1 https://github.com/djylb/nps-openwrt package/nps-openwrt

git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky
#git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite
#git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite

git_sparse_clone main "https://github.com/RayleanB/packages" package 18.06/small-packages
sed -i 's|("OpenClash"), 50)|("OpenClash"), 1)|g' small-packages/luci-app-openclash/luasrc/controller/*.lua
sed -i 's/"admin", "control"/"admin", "network"/g' small-packages/luci-app-timecontrol/luasrc/controller/*.lua
sed -i 's/("Internet Time Control"), 10)/("Internet Time Control"), 90)/g' small-packages/luci-app-timecontrol/luasrc/controller/*.lua


#添加科学上网源
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo

git clone https://github.com/sirpdboy/netspeedtest.git package/netspeedtest

git clone -b lua --single-branch --depth 1 https://github.com/sbwml/luci-app-alist package/alist

# Remove packages
#删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/themes/luci-theme-design
#rm -rf feeds/luci/applications/luci-app-design-config

# rm -rf feeds/packages/admin/netdata
# rm -rf feeds/luci/applications/luci-app-netdata
# git clone https://github.com/sirpdboy/openwrt-netdata package/openwrt-netdata
# git clone https://github.com/sirpdboy/luci-app-netdata package/luci-app-netdata

git clone -b lua --single-branch --depth 1 https://github.com/sirpdboy/luci-app-adguardhome package/luci-app-adguardhome

git clone https://github.com/sirpdboy/sirpdboy-package package/sirpdboy-package
mv package/sirpdboy-package/luci-app-wolplus package/luci-app-wolplus
rm -rf package/sirpdboy-package

# 自定义
rm -rf feeds/packages/net/ddns-go


# rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/packages/net/lucky

sed -i 's/"admin", "vpn"/"admin", "nas"/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/*.lua


# 1 启用 frps
rm -rf feeds/packages/net/frp
git clone https://github.com/kuoruan/openwrt-frp feeds/packages/net/frp
# git clone https://github.com/kuoruan/openwrt-frp -b v0.53.2-1 feeds/packages/net/frp
# git clone https://github.com/user1121114685/frp.git feeds/packages/net/frp
# rm -rf feeds/luci/applications/luci-app-frps
# git clone https://github.com/user1121114685/luci-app-frps.git feeds/luci/applications/luci-app-frps

# Default IP
#sed -i 's/192.168.1.1/192.168.6.50/g' package/base-files/files/bin/config_generate

# Set DISTRIB_REVISION
sed -i "s/OpenWrt /Lein Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template

# 修改主机名
#sed -i 's/LEDE/OpenWrt/g' package/base-files/files/bin/config_generate
#sed -i 's/LEDE/N1/g' package/base-files/luci2/bin/config_generate

# Modify default IP   第一行19.07的路径   第二行23.05的路径
#sed -i 's/192.168.1.1/192.168.123.2/g' package/base-files/files/bin/config_generate
#sed -i 's/192.168.1.1/192.168.6.50/g' package/base-files/luci2/bin/config_generate

# golang版本修复
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# mosdns
# 旧版luci(lua)
git clone -b v5-lua --single-branch --depth 1 https://github.com/sbwml/luci-app-mosdns package/mosdns
sed -i 's|("MosDNS"), 30)|("MosDNS"), 5)|g' package/mosdns/luci-app-mosdns/luasrc/controller/*.lua

#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
#git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
#git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 修改主题为默认
sed -i 's/luci-theme-argon/luci-theme-bootstrap/g' ./feeds/luci/collections/luci/Makefile

#修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
