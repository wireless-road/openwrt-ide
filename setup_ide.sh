#!/bin/bash
ROOT_DIR=/opt/eclipse
IMX6ULL_OPENWRT_DIR=imx6ull-openwrt
ECLIPSE_DIR=eclipse
ECLIPSE_WORKSPACE=workspace

tar -xf m2m-eclipse.tar.gz -C "$ROOT_DIR" 

echo "alias eclipse=/opt/eclipse/eclipse/eclipse" >> ~/.bashrc
echo "alias jl_server='JLinkGDBServer -device MCIMX6Y2 -if JTAG -speed 1000'" >> ~/.bashrc
echo "alias jl_kernel='gdb-multiarch vmlinux --nx'" >> ~/.bashrc
echo "alias jl_uboot='gdb-multiarch u-boot --nx'" >> ~/.bashrc

echo "export PATH=/opt/eclipse/imx6ull-openwrt/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168/scripts/dtc:/opt/eclipse/imx6ull-openwrt/staging_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/host/bin:/opt/eclipse/imx6ull-openwrt-2021/staging_dir/hostpkg/bin:/opt/eclipse/imx6ull-openwrt/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-8.4.0_musl_eabi/bin:/opt/eclipse/imx6ull-openwrt/staging_dir/host/bin/:$PATH" >> ~/.bashrc
echo export ARCH=arm >> ~/.bashrc
echo export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi- >> ~/.bashrc
echo export STAGING_DIR=/opt/eclipse/imx6ull/imx6ull-openwrt/staging_dir/ >> ~/.bashrc

git clone --recurse-submodules -b imx6ull-2021-cand https://github.com/wireless-road/openwrt.git "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR"
cd "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR"
./compile.sh flexcan_wifi
# make package/boot/uboot-imx6ull/compile

source $HOME/env.sh

cd ~
cp u-boot/.cproject "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2020.10/"
cp u-boot/.project "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2020.10/"
mkdir -p "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2020.10/.settings"
cp u-boot/org.eclipse.cdt.core.prefs "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2020.10/.settings"

cp kernel/.cproject "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168/"
cp kernel/.project "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168/"
mkdir -p "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168/.settings"
cp kernel/org.eclipse.cdt.core.prefs "$ROOT_DIR/$IMX6ULL_OPENWRT_DIR/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168/.settings"
