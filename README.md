# OpenWrt для ZXHN H198A / ZTE E8820S (SPI NOR и NAND)

## Состав репозитория

| Папка / Файл | Назначение |
|---|---|
| `patch/` | Патчи для OpenWrt (DTS, конфигурация сборки, LED, скрипт апгрейда) |
| `bootloader/` | Готовые загрузчики для NAND и NOR (breed, U-Boot от DragonBluep и yuzhii0718) |
| `boot_mode_resistors_nand_nor/` | Схемы перестановки резисторов для выбора режима NAND или NOR |
| `eeprom/` | Два варианта калибровок (EEPROM / ART) |
| `stok_dump/` | Ссылка на стоковый дамп NAND чипа |
| `bard/` | Информация о чипах памяти и стоковый лог загрузки (UART) |

---

## Как собрать прошивку

1. **Клонируйте OpenWrt:**
   ```bash
   git clone https://github.com/openwrt/openwrt.git
   cd openwrt
   git checkout v24.10.5   # или любая поддерживаемая версия
   ```
2. **Скопируйте файлы патчей:**

```bash
cp patch/mt7621_zte_e8820s-spi.dts   target/linux/ramips/dts/
cp patch/mt7621_zte_e8820s-nand.dts  target/linux/ramips/dts/   # DTS для NAND (опционально)
cp patch/mt7621.mk                   target/linux/ramips/image/
cp patch/leds                        target/linux/ramips/mt7621/base-files/etc/board.d/
cp patch/upgrade.sh                  target/linux/ramips/mt7621/base-files/lib/upgrade/platform.sh
cp patch/99-default-settings         package/base-files/files/etc/uci-defaults/
```
3. **Настройте сборку:**

```bash
make menuconfig
```
Выберите:

Target System: MediaTek Ralink MIPS

Subtarget: MT7621 based boards

Target Profile: ZTE E8820S-SPI

LuCI: LuCI → Collections → luci (или luci-ssl)

Сохраните и выйдите.

4. **Соберите прошивку:**

```bash
make -j$(nproc) defconfig download clean world
```
Готовые образы появятся в bin/targets/ramips/mt7621/.

---

## Загрузчики (U-Boot / Breed)

В папке `bootloader/` находятся готовые загрузчики под разные конфигурации:

| Загрузчик | Flash | Источник |
|---|---|---|
| `breed/nand-breed.bin` | NAND | Breed |
| `u-boot/dragonBluep-uboot-mt7621/` | NAND и NOR | DragonBluep |
| `u-boot/yuzhii0718-uboot-mt7621-dhcpd/` | NAND и NOR | yuzhii0718 (с DHCPD) |

### Самостоятельная сборка U-Boot

Если вы хотите собрать U-Boot самостоятельно, используйте проект [DragonBluep/uboot-mt7621](https://github.com/KharunDima/uboot-mt7621). Ниже приведены параметры для GitHub Actions (вкладка **Actions → Build U-Boot → Run workflow**).

#### Для NOR flash

Заполните форму следующими значениями:

| Параметр | Значение |
|---|---|
| Flash type | `NOR` |
| Partition table | `192k(u-boot),64k(u-boot-env),64k(factory),-(firmware)` |
| Kernel offset | `0x140000` |
| Reset button GPIO | `18` |
| System LED GPIO | `16` |
| CPU frequency | `880` |
| DRAM frequency | `1200` |
| DDR param | `DDR3-128MiB` |
| Baud rate | `115200` |
| Use Old DDR Timing Parameters | ✓ (поставьте галочку) |

Также необходимо добавить поддержку чипа W25Q512JV в `spi_flash_ids.c` (ID `0xef7020`).

Нажмите **Run workflow**. Готовый `u-boot-mt7621.bin` прошейте в начало SPI NOR с помощью внешнего программатора.

#### Для NAND flash

Заполните форму следующими значениями:

| Параметр | Значение |
|---|---|
| Flash type | `NAND` (не NMBM!) |
| Partition table | `512k(u-boot),512k(u-boot-env),256k(factory),-(firmware)` |
| Kernel offset | `0x140000` |
| Reset button GPIO | `18` |
| System LED GPIO | `16` |
| CPU frequency | `880` |
| DRAM frequency | `1200` |
| DDR param | `DDR3-128MiB` |
| Baud rate | `115200` |
| Use Old DDR Timing Parameters | ✓ (поставьте галочку) |

Нажмите **Run workflow**. Готовый `u-boot-mt7621.bin` прошейте в начало NAND с помощью внешнего программатора.

---

## Переключение между NAND и NOR

В папке `boot_mode_resistors_nand_nor/` лежат фотографии (`nand.jpg`, `nor.jpg`), показывающие, какие резисторы необходимо перепаять для активации соответствующего режима памяти.

---

## Лицензия

Как и OpenWrt. Файлы DTS и конфигурации предоставлены под лицензией MIT.

---

## Благодарности

- Оригинальная работа: [srt19/ZTE-E8820S](https://github.com/srt19/ZTE-E8820S)
- Адаптация под SPI NOR и доработки: [KharunDima](https://github.com/KharunDima)
