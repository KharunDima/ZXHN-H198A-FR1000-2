define Device/zte_e8820s-nand256
  $(Device/dsa-migration)
  $(Device/uimage-lzma-loader)
  DEVICE_DTS := mt7621_zte_e8820s-nand256
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_SIZE := 4096k
  UBINIZE_OPTS := -E 5
  IMAGE_SIZE := 130304k
  IMAGES += factory.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
  IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-ubi | \
       check-size
  DEVICE_VENDOR := ZTE
  DEVICE_MODEL := E8820S-NAND256
  DEVICE_PACKAGES := kmod-mt7603 kmod-mt76x2 kmod-usb3 uboot-envtools kmod-mtd-rw nand-utils atftp wget-ssl luci
endef
TARGET_DEVICES += zte_e8820s-nand256

define Device/zte_e8820s-nand
  $(Device/dsa-migration)
  $(Device/uimage-lzma-loader)
  DEVICE_DTS := mt7621_zte_e8820s-nand
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_SIZE := 4096k
  UBINIZE_OPTS := -E 5
  IMAGE_SIZE := 130304k
  IMAGES += factory.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
  IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-ubi | \
       check-size
  DEVICE_VENDOR := ZTE
  DEVICE_MODEL := E8820S-NAND
  DEVICE_PACKAGES := kmod-mt7603 kmod-mt76x2 kmod-usb3 uboot-envtools kmod-mtd-rw nand-utils atftp wget-ssl luci
endef
TARGET_DEVICES += zte_e8820s-nand

define Device/zte_e8820s-spi
  DEVICE_DTS := mt7621_zte_e8820s-spi
  DEVICE_VENDOR := ZTE
  DEVICE_MODEL := E8820S-SPI
  DEVICE_PACKAGES := kmod-mt7603 kmod-mt76x2 kmod-usb3 luci luci-i18n-base-ru luci-app-ttyd curl jq kmod-nft-tproxy coreutils-base64 bind-dig kmod-nfnetlink kmod-nf-conntrack kmod-nf-conntrack-netlink kmod-ipt-nfqueue kmod-nfnetlink-queue kmod-nft-queue kmod-nf-nat wget-ssl ca-certificates
  IMAGE_SIZE := 64896k
  KERNEL_SIZE := 4096k
  IMAGES += factory.bin sysupgrade.bin
  IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-rootfs | pad-rootfs
  IMAGE/sysupgrade.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-rootfs | pad-rootfs | append-metadata | check-size
  DEVICE_TITLE := ZTE E8820S (SPI NOR)
  SUPPORTED_DEVICES += zte,e8820s
  DEVICE_COMPAT_VERSION := 1.1
  DEVICE_COMPAT_MESSAGE := "Partition layout has changed (kernel and rootfs are now sub-partitions of firmware)"
endef
TARGET_DEVICES += zte_e8820s-spi
