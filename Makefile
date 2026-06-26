NASM ?= nasm
PYTHON ?= python3
QEMU ?= qemu-system-i386

BUILD_DIR := build
BOOT_BIN := $(BUILD_DIR)/boot.bin
KERNEL_BIN := $(BUILD_DIR)/kernel.bin
IMAGE := $(BUILD_DIR)/bonebox.img
KERNEL_SECTORS := 32

.PHONY: all run verify clean

all: $(IMAGE)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BOOT_BIN): boot/boot.asm | $(BUILD_DIR)
	$(NASM) -f bin $< -o $@

$(KERNEL_BIN): kernel/core_v017.asm | $(BUILD_DIR)
	$(NASM) -f bin $< -o $@

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN) tools/mkimage.py
	$(PYTHON) tools/mkimage.py --boot $(BOOT_BIN) --kernel $(KERNEL_BIN) --out $(IMAGE) --kernel-sectors $(KERNEL_SECTORS)

run: $(IMAGE)
	$(QEMU) -machine pc -drive file=$(IMAGE),format=raw,index=0,media=disk

verify: $(IMAGE)
	$(PYTHON) tools/check_image.py $(IMAGE)
	$(PYTHON) tools/smoke_image.py $(IMAGE)
	$(PYTHON) tools/inspect_image.py $(IMAGE)

clean:
	rm -rf $(BUILD_DIR)
