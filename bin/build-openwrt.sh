#!/bin/bash
#set -o errexit

dir="$(realpath "$(dirname "$0")/..")"
. $dir/lib/functions.sh
. $dir/lib/default-env

profilename=${1:-"default"}
profiledir="$dir/profiles/$profilename"
output="$(pwd)/output/$profilename-$(date +%Y-%m-%d-%H%M)"

. $profiledir/env

clone $REPO_URL $REPO_BRANCH openwrt

lndir ~/cache/ccache ~/.ccache
lndir ~/cache/download openwrt/dl
# lndir ~/cache/build_dir openwrt/build_dir
# lndir ~/cache/staging_dir openwrt/staging_dir
lndir "$output" openwrt/bin

cd openwrt

makeFeeds $profiledir
updateFeeds -a
installFeeds -a

patchdir $dir/profiles/common/patches 1
patchdir $profiledir/patches 1

runscript "$dir/profiles/common/custom.sh"
runscript "$profiledir/custom.sh"
makeConfig $profiledir $output
makeDownload
makeCompile

ccache-swig -s
