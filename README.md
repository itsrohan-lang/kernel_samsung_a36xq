# Kernel Tree for Samsung Galaxy A36 5G (SM-A366E / a36xq)

This repository contains the kernel configuration, module definitions, and build scripts for the **Samsung Galaxy A36 5G (SM-A366E / a36xq)**.

---

## Kernel Information

| Parameter | Value |
| :--- | :--- |
| **Linux Version** | `6.6.118-android15` |
| **Kernel Build String** | `Linux version 6.6.118-android15-8-34442516-user-abA366EXXUCDZIF-4k` |
| **Architecture** | `arm64` (4KB page size) |
| **Compiler** | Android Clang 18.0.0 (`r510928`), LLD 18.0.0 |
| **SoC Platform** | Qualcomm Snapdragon (`parrot` / SM6450) |
| **GKI Architecture** | Android 15 GKI 2.0 (Generic Kernel Image) |
| **Stock Defconfig** | `arch/arm64/configs/a36xq_defconfig` |

---

## Architecture: GKI & Dynamic Modules (DLKM)

Modern Samsung devices running Android 14/15 use Google's **Generic Kernel Image (GKI)** architecture:

1. **Generic Kernel Image (`Image`)**:
   * A unified generic Linux 6.6 kernel provided by Google.
   * Does not contain device-specific SoC or board drivers.
2. **Device Trees (`dtb.img` & `dtbo.img`)**:
   * Prebuilt DTB (`dtb.img`) contains Qualcomm `parrot` (SM6450) hardware device trees.
   * Prebuilt DTBO (`dtbo.img`) contains Samsung panel, board, and sensor overlays.
3. **Vendor DLKM Modules (`vendor_dlkm`)**:
   * All hardware-specific drivers are compiled as loadable kernel modules (`.ko`):
     * **GPU:** `msm_kgsl.ko`, `governor_msm_adreno_tz.ko`
     * **Display:** `msm_drm.ko`, `sec_panel_notifier_v2.ko`
     * **Camera:** `camera.ko`, `camcc-parrot.ko`
     * **Audio:** `wcd938x_dlkm.ko`, `wsa883x_dlkm.ko`, `tfa9878_dlkm.ko`
     * **Wi-Fi / BT:** `qca_cld3_adrastea.ko`, `cnss_utils.ko`, `btpower.ko`
     * **Battery & Power:** `s2mf301_charger.ko`, `sec-battery.ko`, `sec-direct-charger.ko`
     * **Touchscreen:** `goodix_ts_berlin.ko`, `sec_input_notifier.ko`
     * **Fingerprint:** `fingerprint.ko`

---

## How to Use with Custom ROMs

### Option 1: Use Prebuilt GKI Kernel (Recommended)
Because the Samsung Galaxy A36 5G uses standard GKI 2.0:
* The prebuilt `kernel` (`Image`), `dtb.img`, `dtbo.img`, and module sets are already archived in:
  * `device/samsung/a36xq/prebuilts/`
* In [`BoardConfig.mk`](../device_samsung_a36xq/BoardConfig.mk):
  ```make
  TARGET_FORCE_PREBUILT_KERNEL := true
  TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilts/kernel
  TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilts/dtb.img
  BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilts/dtbo.img
  ```
This allows building and booting LineageOS/AOSP immediately without having to set up a 40 GB Bazel/Kleaf build environment.

---

### Option 2: Build GKI Kernel from Source (Google Common)
To build a custom GKI kernel:
```bash
# Initialize Google Android 15 common kernel repo
repo init -u https://android.googlesource.com/kernel/manifest -b common-android15-6.6
repo sync -j$(nproc)

# Build using Bazel / Kleaf
tools/bazel run //common:kernel_aarch64_dist
```
Copy the resulting `Image` into `device/samsung/a36xq/prebuilts/kernel`.

---

### Option 3: Full Kernel Source from Samsung Open Source
To build the complete kernel including out-of-tree Samsung & Qualcomm modules:
1. Visit [opensource.samsung.com](https://opensource.samsung.com).
2. Search for model **`SM-A366E`** (Build: `A366EXXUCDZIF`).
3. Download and extract the source archive into `kernel/samsung/a36xq`.
4. Apply [`a36xq_defconfig`](arch/arm64/configs/a36xq_defconfig).
5. Compile using Kleaf or `./build_kernel.sh`.
