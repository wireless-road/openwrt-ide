## GUI IDE for OpenWrt Development

This project makes two things:

1. Simplifies setup of [openwrt](https://github.com/wireless-road/openwrt/tree/imx6ull-2021-cand) repository on local machine by avoiding inconsistency and incompatibility of different packages required to be installed to compile OpenWrt image for [imx6ull NetSoM](https://m2m-tele.com/product/netsom/)
2. Setups Eclipse as graphical IDE that lets to:
   1. navigate through source code using GUI instead command line utilities like [grep](https://man7.org/linux/man-pages/man1/grep.1.html) and [find](https://man7.org/linux/man-pages/man1/find.1.html).
   2. debug u-boot, kernel (not implemented yet) using external J-Link USB debugger connected to the [NetSoM Development Board](https://m2m-tele.com/product/imx6-development-board/) using JTAG interface:
   3. debug user layer application using onboard gdb server.

![jlink_netsom_development_board](./doc/jlink_netsom_dev_board.jpg "jlink + netsom")

## Getting started

Clone the repository:
```
https://github.com/wireless-road/openwrt-ide/tree/openwrt-2021.02
```

Open `docker-compose.yml` and replace left side of `- /home/al/docker/ide/:/opt/eclipse/` volume declaration to the path you want openwrt sources and eclipse to be placed.
Create that folder on host machine.
Then build a container:
```
$ docker-compose run --name openwrt openwrt
```
as a result you should get access to container's console. Next you have to setup Eclipse and openwrt sources by running:
```
$ . ./setup_ide.sh
```

Pay attention to "dot space dot slash" notation to execute script in current shell without foring a sub shell.

It makes few things:
1. clones OpenWrt sources from [imx6ull-openwrt](https://github.com/wireless-road/imx6ull-openwrt)
2. build simpliest device configuration image to get toolchain compiled.
3. installs eclipse.

After finishing you may find `/opt/eclipse` with inner `eclipse` and `imx6ull-openwrt` folders.

As eclipse has very limited possibilities for creation and configuration projects from command line but luckely it is portable we did a trick:
installed Eclipse on host machine at same path (`/opt/eclipse/eclipse`), created project from existing makefile project for `u-boot` sources (`kernel` project to be added soon, I hope), packet resulted folder to archive and here is preconfigured Eclipse installer. So don't move `eclipse` and `imx6ull-openwrt` folders to different pathes as it will brake Eclipse`s projects.

So after you finished setup (just once) you can start to work with source code using command line or eclipse GUI.

### command line mode

just move to source code folder:

```
$ cd /opt/eclipse/imx6ull-openwrt
```

and here as usual like on the host machine:
```
$ ./compile.sh list
$ ./compile.sh <any available configuration>
```

the only pros of using docker image in that case is fastest way to getting started: no need to deal with possible troubles that might happens on requirements installation or sources compilation.


### gui mode

launch eclipse:
```
$ /opt/eclipse/eclipse/eclipse
```
Import existing project you want to work on as existing Makefile project. Guides to do that might be found [here](https://m2m-tele.com/blog/2021/09/07/embedded-linux-development-and-remote-debugging-using-eclipse-ide/) and [here](https://m2m-tele.com/blog/2021/09/07/embedded-linux-development-and-remote-debugging-using-eclipse-ide-part-2/).

Pre-installed u-boot project might be found on Eclipse opening:

![eclipse](./doc/u-boot.png "u-boot")

right click on project and press to `Clean Project`.
right click on project and press to `Build Project`:
![build and clean](./doc/build_clean_project.png "u-boot")


### Debugging U-boot
The unexpected thing you must keep in mind when you start debug U-boot is that it [relocates](https://source.denx.de/u-boot/u-boot/blob/HEAD/doc/README.arm-relocation) itself from one RAM memory address to another (to the end of RAM).


#### Command line debugging
So in command line mode debugging you have to:

**1.** Start GDB server:
```
$ jl_server
```
**2.** Start GDB session:
```
$ cd /opt/eclipse/imx6ull-openwrt/build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/u-boot-wirelessroad_ecspi3/u-boot-2020.10/
$ jl_uboot
```
**3.** Use `/gdb_script/u-boot.txt` script to debug U-boot:

**3.1.** connect to remote target and load image:

```
(gdb) set confirm off
(gdb) target remote localhost:2331
Remote debugging using localhost:2331
Cannot access memory at address 0x8000004
Cannot access memory at address 0x8000000
Cannot access memory at address 0x8000004
0x8ff5cfc4 in ?? ()
(gdb) monitor reset
Resetting target
(gdb) monitor halt
(gdb) monitor sleep 200
Sleep 200ms
(gdb) load
Loading section .text, size 0x3a8 lma 0x87800000
Loading section .efi_runtime, size 0xf68 lma 0x878003a8
Loading section .text_rest, size 0x7aec4 lma 0x87801320
Loading section .rodata, size 0x16f42 lma 0x8787c1e8
Loading section .hash, size 0x18 lma 0x8789312c
Loading section .data, size 0x7bf4 lma 0x87893148
Loading section .got.plt, size 0xc lma 0x8789ad3c
Loading section .u_boot_list, size 0x126c lma 0x8789ad48
Loading section .efi_runtime_rel, size 0xd0 lma 0x8789bfb4
Loading section .rel.dyn, size 0x10198 lma 0x8789c084
Loading section .dynsym, size 0x30 lma 0x878ac21c
Loading section .dynstr, size 0x1 lma 0x878ac24c
Loading section .dynamic, size 0x90 lma 0x878ac250
Loading section .gnu.hash, size 0x18 lma 0x878ac2e0
Start address 0x87800000, load size 705243
Transfer rate: 69 KB/sec, 13060 bytes/write.
(gdb) load
Loading section .text, size 0x3a8 lma 0x87800000
Loading section .efi_runtime, size 0xf68 lma 0x878003a8
Loading section .text_rest, size 0x7aec4 lma 0x87801320
Loading section .rodata, size 0x16f42 lma 0x8787c1e8
Loading section .hash, size 0x18 lma 0x8789312c
Loading section .data, size 0x7bf4 lma 0x87893148
Loading section .got.plt, size 0xc lma 0x8789ad3c
Loading section .u_boot_list, size 0x126c lma 0x8789ad48
Loading section .efi_runtime_rel, size 0xd0 lma 0x8789bfb4
Loading section .rel.dyn, size 0x10198 lma 0x8789c084
Loading section .dynsym, size 0x30 lma 0x878ac21c
Loading section .dynstr, size 0x1 lma 0x878ac24c
Loading section .dynamic, size 0x90 lma 0x878ac250
Loading section .gnu.hash, size 0x18 lma 0x878ac2e0
Start address 0x87800000, load size 705243
Transfer rate: 69 KB/sec, 13060 bytes/write.
```

**3.2.** Restore binary device tree by appending u-boot.dtb file at the end of u-boot image:

```
(gdb) b fdtdec_prepare_fdt
Breakpoint 1 at 0x87870be4: file lib/fdtdec.c, line 587.
(gdb) c
Continuing.

Breakpoint 1, fdtdec_prepare_fdt () at lib/fdtdec.c:587
587		if (!gd->fdt_blob || ((uintptr_t)gd->fdt_blob & 3) ||
(gdb) set gd->fdt_blob = _end
(gdb) restore u-boot.dtb binary _end
Restoring binary file u-boot.dtb into memory (0x878ac21c to 0x878b38bb)
```

**3.3.** Handle code relocation:

```
(gdb) b setup_reloc
Breakpoint 2 at 0x8781a874: file common/board_f.c, line 680.
(gdb) c
Continuing.

Breakpoint 2, setup_reloc () at common/board_f.c:680
680		if (gd->flags & GD_FLG_SKIP_RELOC) {
(gdb) p /x gd->relocaddr
$1 = 0x8ff37000
(gdb) set $s = gd->relocaddr
(gdb) add-symbol-file u-boot $s
add symbol table from file "u-boot" at
	.text_addr = 0x8ff37000
Reading symbols from u-boot...
(gdb) b relocate_code
Breakpoint 3 at 0x87801bc4: file arch/arm/lib/relocate.S, line 81.
(gdb) c
Continuing.

Breakpoint 3, relocate_code () at arch/arm/lib/relocate.S:81
81		ldr	r1, =__image_copy_start	/* r1 <- SRC &__image_copy_start */
(gdb) p /x $pc
$5 = 0x87801bc4
(gdb) fin
Run till exit from #0  relocate_code () at arch/arm/lib/relocate.S:81
?? () at arch/arm/lib/crt0.S:145
145		bl	relocate_vectors
(gdb) p /x $pc
$6 = 0x8ff386a8
```

**3.4.** Pass till the end to jump to kernel:

```
(gdb) b boot_jump_linux
Breakpoint 4 at 0x87801cd0: boot_jump_linux. (2 locations)
(gdb) c
Continuing.

Breakpoint 4, boot_jump_linux (images=images@entry=0x8ffd3bcc, flag=flag@entry=1024) at arch/arm/lib/bootm.c:378
378		unsigned long machid = gd->bd->bi_arch_number;
(gdb) n
384		kernel_entry = (void (*)(int, int, uint))images->ep;
(gdb) n
389		s = env_get("machid");
(gdb) n
390		if (s) {
(gdb) n
400		bootstage_mark(BOOTSTAGE_ID_RUN_OS);
(gdb) n
401		announce_and_cleanup(fake);
(gdb) n
403		if (IMAGE_ENABLE_OF_LIBFDT && images->ft_len)
(gdb) n
404			r2 = (unsigned long)images->ft_addr;
(gdb) n
406			r2 = gd->bd->bi_boot_params;
(gdb) n
408		if (!fake) {
(gdb) n
416				kernel_entry(0, machid, r2);
```

#### GUI debugging

To start debugging press `Run --> Debug Configurations`, select `u-boot Default` configuration.
Pay attention for following settings:
![dtb_and_relocation](./doc/u_boot_relocation_workaround.png "dtb_and_relocation")
Then press `Debug`:
![debug_configuration](./doc/debug_configuration.png "debug_configuration")
Eclipse suggests to swith to Debug perspective - accept it. Wait few seconds before image to be uploaded to hardware:
![debugging](./doc/debugging_1.png "debugging")
Don't mind about `no debug information available` message, just press to `Resume (F8)` button:
![debugging_2](./doc/debugging_2.png "debugging")
and navigate through the code. If you left breakpoint unchanged it should stop you at `relocate_code` function. So to pass relocation successfully you should manually place `u-boot` image at relocation address. For that open `Debugger Console` and type commands explained before:
![debugging_2](./doc/u_boot_relocation.png "relocation")
Than you can continue to debug code even after relocation.


#### container restarting

on exit from container console it stops:
```
$ exit
```

to enter it back:
```
$ docker start openwrt
$ docker exec -it openwrt bash
```

#### user layer applications development
here two developers guide to develop and debug user layer applications:
- [u-boot debugging guide](https://m2m-tele.com/blog/2021/09/19/how-to-debug-u-boot/)
- [u-boot debugging guide part 2. Relocation workaround.](https://m2m-tele.com/blog/2021/10/24/u-boot-debugging-part-2/)
- [openwrt development and debugging using eclipse ide](https://m2m-tele.com/blog/2021/09/07/embedded-linux-development-and-remote-debugging-using-eclipse-ide/)
- [openwrt development and debugging using eclipse ide. part 2.](https://m2m-tele.com/blog/2021/09/07/embedded-linux-development-and-remote-debugging-using-eclipse-ide-part-2/)


#### add new project
if you made some changes using eclipse IDE (created and added new projects, for example),
```
tar -zcvf m2m-eclipse.tar.gz eclipse/
```

