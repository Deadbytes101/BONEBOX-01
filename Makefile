NASM ?= nasm
PYTHON ?= python
QEMU ?= qemu-system-i386

BUILD_DIR := build
BOOT_BIN := $(BUILD_DIR)/boot.bin
KERNEL_BIN := $(BUILD_DIR)/kernel.bin
IMAGE := $(BUILD_DIR)/bonebox.img
MANIFEST := $(BUILD_DIR)/bonebox.manifest.json
KERNEL_SECTORS := 32

.PHONY: all run verify current kernels manifest clean

all: $(IMAGE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

current:
	$(PYTHON) tools/check_current.py .

kernels:
	$(PYTHON) tools/list_kernels.py .

manifest: $(IMAGE)
	$(PYTHON) tools/write_manifest.py . $(IMAGE) $(MANIFEST)

$(BOOT_BIN): boot/boot.asm | $(BUILD_DIR)
	$(NASM) -f bin $< -o $@

$(KERNEL_BIN): kernel/current.asm kernel/core_v017.asm | $(BUILD_DIR)
	$(NASM) -f bin kernel/current.asm -o $@

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN) tools/mkimage.py
	$(PYTHON) tools/mkimage.py --boot $(BOOT_BIN) --kernel $(KERNEL_BIN) --out $(IMAGE) --kernel-sectors $(KERNEL_SECTORS)

run: $(IMAGE)
	$(QEMU) -machine pc -drive file=$(IMAGE),format=raw,index=0,media=disk

verify: current $(IMAGE)
	$(PYTHON) tools/check_image.py $(IMAGE)
	$(PYTHON) tools/smoke_image.py $(IMAGE)
	$(PYTHON) tools/inspect_image.py $(IMAGE)

clean:
	rm -rf $(BUILD_DIR)
