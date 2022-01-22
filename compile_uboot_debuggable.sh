#!/bin/bash
ROOT_DIR=/opt/eclipse
IMX6ULL_OPENWRT_DIR=imx6ull-openwrt
U_BOOT_DIR=build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2020.10

sed -i 's/.*CONFIG_TOOLS_DEBUG.*/CONFIG_TOOLS_DEBUG=y/g' "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$U_BOOT_DIR/.config"
sed -i 's/.*CONFIG_CC_OPTIMIZE_FOR_SIZE.*/# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set/g' "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$U_BOOT_DIR/.config"
cd "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$U_BOOT_DIR"
make -j $(nproc) u-boot.imx
dd if=./u-boot-dtb.bin of=./u-boot.dtb bs=1 skip=$(stat -c %s ./u-boot-nodtb.bin)


