#!/bin/sh
set -e

: ${PPA:='vdr'}
: ${PPA_URL:='http://ppa.launchpad.net/aap'}
: ${DIR:="$(cd "$(dirname "$0")" && pwd)"}

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_DIR="$DIR"
REV='master'

[ ! -f "$HOME/.build.config" ] || . "$HOME/.build.config" && IGNORE_GLOBAL_CONFIG='true'
[ ! -f "$DIR/build.config" ]   || . "$DIR/build.config" && IGNORE_CONFIG='true'

: ${PPA_BUILDER:="$DIR/ppa-builder"}
: ${PPA_BUILDER_URL:='https://github.com/AndreyPavlenko/ppa-builder.git'}
DEPENDS="$DEPENDS git"

[ -d "$PPA_BUILDER" ] || git clone "$PPA_BUILDER_URL" "$PPA_BUILDER"
. "$PPA_BUILDER/build.sh"

update() {
    echo "Update:"
}

_checkout() {
    echo "Checkout:"
    local dest="$1"
    mkdir -p "$dest"
    cp -rv "$DIR/chorder" "$DIR/README" "$DIR/examples" "$dest"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

version() {
    local version="$(grep -m 1 '^VERSION' chorder | awk -F "[=']" '{print $3}')"
    local ci_count=$(git --git-dir="$DIR/.git" log --format='%H' | wc -l)
    local sha_short=$(git --git-dir="$DIR/.git" rev-parse --short HEAD)
    echo "${version}-${ci_count}~${sha_short}"
}

_main $@
