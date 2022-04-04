#!/bin/bash

#################################################################
# DEFINES (*** DO NOT MODIFY ***)                               #
#################################################################

TOP=${PWD}
source $TOP/build/envsetup.sh > /dev/null 2>&1
PATCH_DIR=$( dirname "${BASH_SOURCE[0]}" )

NOCOLOR='\033[0m'
GREEN='\033[0;32m'
LIGHTBLUE='\033[1;34m'

function apply_patch {
    echo ""
    echo -e "${GREEN}Applying patch...${NOCOLOR}"
    echo -e "${LIGHTBLUE}Target repo:${NOCOLOR} $1"
    echo -e "${LIGHTBLUE}Patch file:${NOCOLOR} $2"
    echo ""

    cd $1
    git am -3 --ignore-whitespace $PATCH_DIR/$2
    cd $TOP
    echo ""
}

#################################################################
# PATCHES                                                       #
#                                                               #
# Example: apply_patch [REPO_DIR] [PATCH_FILE]                  #
#################################################################

# android_build_soong
repopick -f 327111

# Ultra Legacy
repopick -P art -f 318097
repopick -P external/perfetto -f 287706
repopick 321934 326385
repopick -P system/bpf -f 320591
repopick -P system/netd -f 320592

# frameworks/av
repopick 320337

# Camera - twelve-qcom-cam - twelve-hal1-legacy
repopick -t twelve-restore-camera-hal1
repopick -t twelve-camera-extension
repopick 320528-320530                              
repopick -P hardware/interfaces 320531-320532
repopick -t twelve-legacy-camera

# Extras
repopick 320514

# Misc
apply_patch vendor/lineage PATCH_DIR/moto/0001-TEMP-Disable-ADB-authentication.patch

# Themed icons
apply_patch packages/apps/Trebuchet $PATCH_DIR/moto/0001-launcher-Add-support-for-themed-icons.patch
apply_patch packages/apps/Trebuchet $PATCH_DIR/moto/0002-Launcher3-Import-more-themed-icons.patch

# Davey logspam
apply_patch $PATCH_DIR/frameworks/base $PATCH_DIR/0001-hwui-Silence-Davey-logs-for-now.patch

# Legacy telephony stuff
apply_patch $PATCH_DIR/frameworks/opt/telephony $PATCH_DIR/moto/0001-telephony-Squashed-support-for-simactivation-feature.patch
apply_patch $PATCH_DIR/frameworks/opt/telephony $PATCH_DIR/moto/0002-Avoid-SubscriptionManager-getUriForSubscriptionId-ca.patch
apply_patch $PATCH_DIR/frameworks/opt/telephony $PATCH_DIR/moto/0003-RIL-Fix-manual-network-selection-with-old-modem.patch
apply_patch $PATCH_DIR/frameworks/opt/telephony $PATCH_DIR/moto/0004-2G-wants-proper-signal-strength-too.patch
apply_patch $PATCH_DIR/frameworks/opt/telephony $PATCH_DIR/moto/0005-Telephony-Add-option-for-using-regular-poll-state-fo.patch

# System sepolicy
apply_patch $PATCH_DIR/system/sepolicy $PATCH_DIR/moto/0001-Fix-storaged-access-to-sys-block-mmcblk0-stat-after-.patch
apply_patch $PATCH_DIR/system/sepolicy $PATCH_DIR/moto/0002-sepolicy-Treat-proc-based-DT-fstab-the-same-and-sys-.patch
apply_patch $PATCH_DIR/system/sepolicy $PATCH_DIR/moto/0003-Allow-init-to-write-to-proc-cpu-alignment.patch
