# Source provenance

Samsung has **not** published an Android 17 / One UI 9 open-source archive for
`SM-A366E / A366EXXUCDZIF`. This repository is therefore a **reconstructed
kernel-only tree**, not a bit-for-bit copy of Samsung's unpublished source.

## What is in this tree

| Component | Source | Why |
| :--- | :--- | :--- |
| `kernel_platform/common` | AOSP GKI `android15-6.6-2026-01_r42` | Linux `6.6.118`, closest match to the shipped `6.6.118-android15-8-34442516` kernel. |
| `kernel_platform/msm-kernel` | AOSP GKI `android15-6.6-2026-01_r42` + retained UAPI exports | Same GKI baseline; Samsung's downstream `msm-kernel` for Android 17 is not published. |
| `vendor/qcom/opensource` | Samsung `SM-A366E_CIS_16_Opensource.zip` | Latest published A366E kernel techpack source; used as the module-source baseline. |
| `arch/arm64/configs/a36xq_defconfig` |(device tree) | Retained device config used for header/module generation. |

## GKI tag

```text
repository: https://android.googlesource.com/kernel/common
tag:        android15-6.6-2026-01_r42
commit:     443a198f58bf4c502508fdc246eebdfd4fce1f74
date:       2026-09-28
Makefile:   VERSION=6 PATCHLEVEL=6 SUBLEVEL=118
```

`r42` was selected because its commit date matches the firmware build date
(`Mon Sep 28 02:48:43 UTC 2026`) and its `gki_defconfig` carries the same
`CONFIG_LOCALVERSION="-4k"` as the shipped kernel.

## Samsung archive used for techpack baseline

```text
name:   SM-A366E_CIS_16_Opensource.zip
sha256: a5298c54f177ac7de4e0f56cd5db8900f6a4114d93779dda73743e45f305d57e
```

This archive is Android 16 / kernel `6.6.77`. It is **not** the Android 17
source. It is only retained here for the Qualcomm/Samsung out-of-tree module
sources that have no newer published equivalent.

## Shipped kernel (authoritative for boot)

```text
path:   device/samsung/a36xq/prebuilts/kernel
sha256: 0b815939160005cdb939680e36234b1678bbb8c76cdcd8768692de1641f23399
Linux version 6.6.118-android15-8-34442516-user-abA366EXXUCDZIF-4k
```

The prebuilt kernel remains the image used by the ROM. This tree is for source
review, `headers_install`, and kernel-only build checks.

## Retained local fixes

- `.find-ignore` keeps kernel-tree `Android.bp` / `Android.mk` files out of Soong discovery.
- `kernel_platform/msm-kernel/include/uapi/Kbuild` keeps `linux/sched/types.h` out of the exported UAPI set.
- `kernel_platform/msm-kernel/arch/arm64/include/uapi/Kbuild` keeps `asm/ptrace.h` and `asm/sigcontext.h` out of the exported UAPI set.
- `include/uapi/audio/**` and `include/uapi/display/**` are mirrored so `generated_kernel_includes` can export them to vendor modules.

## Reproduce the GKI baseline

```bash
git clone --depth 1 --branch android15-6.6-2026-01_r42 \
  https://android.googlesource.com/kernel/common gki_r42
```

No PixelOS build was performed to validate this tree.
