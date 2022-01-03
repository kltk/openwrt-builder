#!/bin/bash

grouprun() {
  label=$*
  if [ "$2" != "" ]; then
    label=$1
    shift
  fi
  echo "::group::$label"
  $*
  echo "::endgroup::"
}

clone() {
  grouprun "clone $1#$2" git clone --depth=1 "$1" -b "$2" "$3"
}

applyPatch() {
  for p in `find $1 -iname "*.patch"`; do
    # -d	设置工作目录
    # -N	忽略修补的数据较原始文件的版本更旧，或该版本的修补数据已使　用过
    # -t	自动略过错误，不询问任何问题
    patch -Ntp$2 < $p
  done
}

applyConfig() {
  for i in `find $1 -iname "*.config"`; do
    echo apply config $i
    cat $i >> $2
  done
}

loadProfile() {
  echo "PROFILE_PATH=$1/profiles/$2" >> $3
  cat $1/lib/default-env >> $3
  cat $1/profiles/$2/env >> $3
}

move() {
  [ -e $1 ] && mv $1 $2
}

runscript() {
  [ -e $1 ] && $*
}

loadFeeds() {
  move "$PROFILE_PATH/$FEEDS_CONF" feeds.conf.default
  runscript $PROFILE_PATH/$1
  grouprun "./scripts/feeds update -a"
  grouprun "./scripts/feeds install -a"
}

loadConfig() {
  move "$PROFILE_PATH/files" files
  move "$PROFILE_PATH/$CONFIG_FILE" .config
  grouprun "applyConfig $PROFILE_PATH .config"
  grouprun "applyPatch $PROFILE_PATH 1"
  runscript $PROFILE_PATH/$1
  # 确认配置
  grouprun "cat .config"
  make defconfig
  # 确认生成的配置
  grouprun "cat .config"
  grouprun "$GITHUB_WORKSPACE/openwrt/scripts/diffconfig.sh"
  # 确认补丁
  grouprun "git diff"
  mkdir bin
  cp .config bin/config
}

downloadPackage() {
  make download -j8
  find dl -size -1024c -exec ls -l {} \;
  find dl -size -1024c -exec rm -f {} \;
}

compile() {
  echo -e "$(nproc) thread compile"
  make -j$(nproc) || make -j1 || make -j1 V=s
}
