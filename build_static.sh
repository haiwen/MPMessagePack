#!/bin/bash

# For the helper tool, we need to embed all dep frameworks because it would be
# installed to a system-dependent location.
#
# Code borrowed from https://github.com/Carthage/Carthage/blob/9259756d/Documentation/StaticFrameworks.md
#

set -e
set -x
set -o pipefail

CURRENT_PWD="$(dirname "${BASH_SOURCE[0]}")"
cd ${CURRENT_PWD}

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

echo "LD = $PWD/static-ld.py" > $xcconfig
echo "DEBUG_INFORMATION_FORMAT = dwarf" >> $xcconfig

export XCODE_XCCONFIG_FILE="$xcconfig"

xcodebuild ARCHS=x86_64 ONLY_ACTIVE_ARCH=NO -xcconfig $xcconfig
