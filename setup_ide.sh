#!/bin/bash
ROOT_DIR=/opt/eclipse
IMX6ULL_OPENWRT_DIR=imx6ull-openwrt
ECLIPSE_DIR=eclipse
ECLIPSE_WORKSPACE=workspace

tar -xf m2m-eclipse.tar.gz -C "$ROOT_DIR" 
echo alias eclipse=/opt/eclipse/eclipse/eclipse >> ~/.bashrc
alias eclipse=/opt/eclipse/eclipse/eclipse

git clone --recurse-submodules https://github.com/wireless-road/imx6ull-openwrt.git "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR"
cd "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR"
./compile.sh flexcan_wifi

cd ~
cp u-boot/.cproject "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2017.07/"
cp u-boot/.project "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2017.07/"
mkdir -p "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2017.07/.settings"
cp u-boot/org.eclipse.cdt.core.prefs "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2017.07/.settings"

