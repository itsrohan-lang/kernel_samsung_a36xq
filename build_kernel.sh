#!/usr/bin/env bash
# Build script for Samsung Galaxy A36 5G (SM-A366E / a36xq) Kernel
set -e

KERNEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVICE="a36xq"
DEFCONFIG="a36xq_defconfig"
ARCH="arm64"
SUBARCH="arm64"

echo "================================================="
echo "Building Kernel for Samsung Galaxy A36 5G ($DEVICE)"
echo "Linux 6.6.118-android15 GKI (Qualcomm parrot / SM6450)"
echo "================================================="

# Toolchain configuration (Clang 18 / LLVM)
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
export LLVM=1
export LLVM_IAS=1

# Output directory
OUT_DIR="${KERNEL_DIR}/out"
mkdir -p "${OUT_DIR}"

if [ -f "${KERNEL_DIR}/Makefile" ]; then
    make O="${OUT_DIR}" ARCH=${ARCH} ${DEFCONFIG}
    make O="${OUT_DIR}" ARCH=${ARCH} -j$(nproc) Image dtbo.img
    echo "Build complete. Output kernel: ${OUT_DIR}/arch/arm64/boot/Image"
else
    echo "Full kernel tree source missing. Refer to README.md to clone the GKI or Samsung source."
fi
