#!/usr/bin/env bash
# Kernel-only build/check script for Samsung Galaxy A36 5G (SM-A366E / a36xq)
set -euo pipefail

KERNEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_SRC="${KERNEL_DIR}/kernel_platform/common"
OUT_DIR="${KERNEL_DIR}/out"
DEFCONFIG="${DEFCONFIG:-gki_defconfig}"

echo "================================================="
echo "Building Kernel for Samsung Galaxy A36 5G (a36xq)"
echo "AOSP GKI 6.6.118 / android15-6.6-2026-01_r42"
echo "================================================="

if [ ! -f "${KERNEL_SRC}/Makefile" ]; then
    echo "Missing GKI source at ${KERNEL_SRC}; see SOURCE_PROVENANCE.md." >&2
    exit 1
fi

# Locate a Clang toolchain. Prefer the Samsung/AOSP r510928 toolchain, then
# fall back to any AOSP clang checkout two levels up.
if [ -n "${CLANG_PATH:-}" ]; then
    CLANG_BIN="${CLANG_PATH%/}"
elif [ -x "${KERNEL_DIR}/prebuilts/clang/host/linux-x86/clang-r510928/bin/clang" ]; then
    CLANG_BIN="${KERNEL_DIR}/prebuilts/clang/host/linux-x86/clang-r510928"
elif [ -x "${KERNEL_DIR}/../../../prebuilts/clang/host/linux-x86/clang-r510928/bin/clang" ]; then
    CLANG_BIN="${KERNEL_DIR}/../../../prebuilts/clang/host/linux-x86/clang-r510928"
else
    CLANG_BIN=""
    while IFS= read -r candidate; do
        if [ -x "${candidate}/bin/clang" ] && [ -x "${candidate}/bin/ld.lld" ]; then
            CLANG_BIN="${candidate}"
            break
        fi
    done < <(find "${KERNEL_DIR}/../../../prebuilts/clang/host/linux-x86" -maxdepth 1 -type d -name 'clang-*' 2>/dev/null | sort -r)
fi

if [ -z "${CLANG_BIN}" ]; then
    echo "No Clang toolchain found. Set CLANG_PATH to a directory with bin/clang." >&2
    exit 1
fi

echo "Using Clang: ${CLANG_BIN}"
export PATH="${CLANG_BIN}/bin:${PATH}"
export CC=clang
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
export LLVM=1
export LLVM_IAS=1
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_COMPAT=arm-linux-gnueabi-

mkdir -p "${OUT_DIR}"
make -C "${KERNEL_SRC}" O="${OUT_DIR}" ARCH="${ARCH}" "${DEFCONFIG}"
make -C "${KERNEL_SRC}" O="${OUT_DIR}" ARCH="${ARCH}" -j"$(nproc)" Image

echo "Build complete: ${OUT_DIR}/arch/arm64/boot/Image"
