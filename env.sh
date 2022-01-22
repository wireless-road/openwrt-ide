#!/bin/bash

export PATH=/opt/eclipse/imx6ull-openwrt/staging_dir/host/bin/:$PATH
export PATH=/opt/eclipse/imx6ull-openwrt/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-8.4.0_musl_eabi/bin:$PATH
export PATH=/opt/eclipse/imx6ull-openwrt-2021/staging_dir/hostpkg/bin:$PATH
export PATH=/opt/eclipse/imx6ull-openwrt/staging_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/host/bin:$PATH
export PATH=/opt/eclipse/imx6ull-openwrt/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/linux-imx6ull_cortexa7/linux-5.4.168/scripts/dtc:$PATH

export ARCH=arm
export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi-
export STAGING_DIR=/opt/eclipse/imx6ull/imx6ull-openwrt/staging_dir/

alias eclipse=/opt/eclipse/eclipse/eclipse
alias jl_server='JLinkGDBServer -device MCIMX6Y2 -if JTAG -speed 1000'
alias jl_kernel='gdb-multiarch vmlinux --nx'
alias jl_uboot='gdb-multiarch u-boot --nx'

