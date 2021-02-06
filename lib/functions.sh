#!/bin/sh

patchdir() {
  echo "::group::patch dir use $1"
  for i in $1/*.patch; do
    patch -Ntp$2 < $i
  done
  echo "::endgroup::"
}

runscript() {
  if [ -f $1 ]; then
    echo "::group::run script $1"
    chmod +x $1
    . $1
    echo "::endgroup::"
  fi
}

lndir() {
  if [ ! -e $2 ]; then
    mkdir -p $1
    ln -sfT $1 $2
  fi
}

clone() {
  echo "::group::Clone repo $1#$2"
  git clone --depth=1 $1 -b $2 $3
  echo "::endgroup::"
}

makeFeeds() {
  if [ -f "$1/feeds" ]; then
    echo "use custom feeds $1/feeds"
    cp "$1/feeds" feeds.conf
  fi
}

updateFeeds() {
  echo "::group::Update feeds"
  ./scripts/feeds update $@
  echo "::endgroup::"
}

installFeeds() {
  echo "::group::Install feeds"
  ./scripts/feeds install $@
  echo "::endgroup::"
}

makeConfig() {
  echo "::group::Make config"
  echo "copy config from $1"
  cat $1/*.config > .config
  make defconfig
  cp .config $2/config
  ./scripts/diffconfig.sh > $2/config.diff
  echo "::endgroup::"
}

makeDownload() {
  echo "::group::Download package"
  make -j8 V=s download
  echo "::endgroup::"
}

makeCompile() {
  echo "::group::$(nproc) thread compile"
  make -j$(nproc) || make -j1 V=s
  echo "::endgroup::"
}
