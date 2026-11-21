# Kernel Tree for Samsung Galaxy A36 5G (SM-A366E / a36xq)

This repository contains the reconstructed kernel source, configuration, module
definitions, and build scripts for the **Samsung Galaxy A36 5G
(SM-A366E / a36xq)**.

> **Important:** Samsung has not published an Android 17 open-source archive for
> `A366EXXUCDZIF`. The GKI trees here are rebuilt from the matching AOSP GKI
> `6.6.118` tag. This is a source-compatible reconstruction for validation and
> header generation, not a bit-for-bit Samsung release. See
> [`SOURCE_PROVENANCE.md`](SOURCE_PROVENANCE.md) for exact provenance.

---

## Kernel Information

| Parameter | Value |
| :--- | :--- |
| **Linux Version** | `6.6.118-android15` |
| **Kernel Build String** | `Linux version 6.6.118-android15-8-34442516-user-abA366EXXUCDZIF-4k` |
| **Architecture** | `arm64` (4 KB page size) |
| **Compiler used by Samsung** | Android Clang 18.0.0 (`r510928`), LLD 18.0.0 |
| **SoC Platform** | Qualcomm Snapdragon (`parrot` / SM6450) |
| **GKI Architecture** | Android 15 GKI 2.0 |
| **GKI baseline** | `android15-6.6-2026-01_r42` / `443a198f58bf` |
| **Stock Defconfig** | `arch/arm64/configs/a36xq_defconfig` |

---

## Architecture: GKI & Dynamic Modules (DLKM)

1. **Generic Kernel Image (`Image`)**
   * AOSP GKI 6.6.118 baseline with `CONFIG_LOCALVERSION="-4k"`.
2. **Device Trees (`dtb.img` & `dtbo.img`)**
   * Prebuilt DTB/DTBO from the stock firmware are used by the ROM.
3. **Vendor DLKM modules**
   * Qualcomm/Samsung techpack sources are kept under `vendor/qcom/opensource`.

---

## Using this tree with the ROM

### Option 1: Use the prebuilt GKI kernel (recommended)

The boot image ships Samsung's stock kernel, DTB and DTBO:

```make
TARGET_NO_KERNEL_OVERRIDE := true
PRODUCT_COPY_FILES += $(DEVICE_PATH)/prebuilts/kernel:kernel
```

This remains the authoritative path for booting.

### Option 2: Build/check the GKI kernel from source

```bash
./build_kernel.sh
```

The script builds `kernel_platform/common` with `gki_defconfig` and produces:

```text
out/arch/arm64/boot/Image
```

Set `CLANG_PATH` to a directory containing `bin/clang` if the script cannot
find a toolchain automatically.

### Option 3: Exact Samsung Android 17 source

Not available. Do not substitute the Android 16 `*_16_Opensource.zip` archive
and call it an Android 17 source; it contains kernel `6.6.77`.

---

## Retained UAPI fixes

These fixes are required by the ROM's `generated_kernel_includes` action:

* `.find-ignore` prevents duplicate Soong module discovery.
* `linux/sched/types.h` is excluded from exported UAPI headers.
* `asm/ptrace.h` and `asm/sigcontext.h` are excluded from exported AArch64 UAPI headers.
* `include/uapi/audio/**` and `include/uapi/display/**` are mirrored for vendor modules.

Because the exported UAPI header set changed from `6.6.77` to `6.6.118`, the
device tree's `A36XQ_KERNEL_UAPI_REV` must be bumped.
