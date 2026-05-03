# OpenWrt for ZXHN H198A / ZTE E8820S (SPI NOR edition)

Custom firmware for ZTE E8820S / FR1000-2 / ZXHN H198A with **SPI NOR flash** (W25Q512JV 64MB).

**WARNING:** This build is ONLY for devices that have been hardware‑modified to use SPI NOR flash instead of the original NAND. If your device still has the stock NAND chip, use the original ZTE_E8820S target.

## How to use

1. Clone OpenWrt:
git clone https://github.com/openwrt/openwrt.git
cd openwrt
git checkout v24.10.5 # or any supported version

text

2. Copy the patch files:
cp patch/mt7621_zte_e8820s-spi.dts target/linux/ramips/dts/
cp patch/mt7621.mk target/linux/ramips/image/
cp patch/01_leds target/linux/ramips/mt7621/base-files/etc/board.d/
cp patch/upgrade.sh target/linux/ramips/mt7621/base-files/lib/upgrade/platform.sh
cp patch/99-default-settings package/base-files/files/etc/uci-defaults/

text

3. Configure the build:
make menuconfig

text
Select:
- Target System: MediaTek Ralink MIPS
- Subtarget: MT7621 based boards
- Target Profile: ZTE E8820S-SPI
- LuCI (if needed): LuCI -> Collections -> luci (or luci-ssl)
- Save and exit

4. Build the firmware:
make -j$(nproc) defconfig download clean world

text

The output images will be in `bin/targets/ramips/mt7621/`.

## U‑Boot

You need a custom U‑Boot that supports your SPI NOR flash. Use the [DragonBluep/uboot-mt7621](https://github.com/KharunDima/uboot-mt7621) project and build with these parameters:

- Flash type: `NOR`
- Partition table: `192k(u-boot),64k(u-boot-env),64k(factory),-(firmware)`
- Kernel offset: `0x140000`
- Reset button GPIO: `18`
- System LED GPIO: `16`
- CPU frequency: `880`
- DRAM frequency: `1200`
- DDR param: `DDR3-128MiB`
- Baud rate: `115200`
- **Enable "Use Old DDR Timing Parameters"**

Also add support for the W25Q512JV chip in `spi_flash_ids.c` (ID `0xef7020`).

Flash the resulting `u-boot-mt7621.bin` to the beginning of your SPI NOR with an external programmer.

## Included packages

- kmod-mt7603 (2.4GHz Wi-Fi)
- kmod-mt76x2 (5GHz Wi-Fi)
- kmod-usb3
- LuCI (web interface) with Russian language and terminal
- Podkop, B4 (see their respective repositories)
- All required dependencies (curl, jq, kmod-nft-tproxy, etc.)

## License

Same as OpenWrt. The DTS and config files are provided under the MIT license.

## Credits

Original work by [srt19/ZTE-E8820S](https://github.com/srt19/ZTE-E8820S). Adapted for SPI NOR by [KharunDima/Din].
