#!/bin/bash
ROOT_DIR=/opt/eclipse
IMX6ULL_OPENWRT_DIR=imx6ull-openwrt
KERNEL_DIR=build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168

cd "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$KERNEL_DIR"
make -j64 uImage LOADADDR=0x80008000
cp $HOME/kernel/.cproject "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$KERNEL_DIR/"
cp $HOME/kernel/.project "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$KERNEL_DIR/"
mkdir -p "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$KERNEL_DIR/.settings"
cp $HOME/kernel/org.eclipse.cdt.core.prefs "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/$KERNEL_DIR/.settings/"


