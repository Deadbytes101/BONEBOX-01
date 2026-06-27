NASM ?= nasm
PYTHON ?= python
QEMU ?= qemu-system-i386

BUILD_DIR := build
BOOT_BIN := $(BUILD_DIR)/boot.bin
KERNEL_BIN := $(BUILD_DIR)/kernel.bin
IMAGE := $(BUILD_DIR)/bonebox.img
ISO := $(BUILD_DIR)/bonebox.iso
MANIFEST := $(BUILD_DIR)/bonebox.manifest.json
KERNEL_SECTORS := 32

.PHONY: all run run-iso verify current current-latest kernels manifest iso clean

all: $(IMAGE) $(ISO)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

current:
	$(PYTHON) tools/check_current.py .

current-latest:
	$(PYTHON) tools/set_current.py latest --root .

kernels:
	$(PYTHON) tools/list_kernels.py .

manifest: $(IMAGE)
	$(PYTHON) tools/write_manifest.py . $(IMAGE) $(MANIFEST)

iso: $(ISO)

$(BOOT_BIN): boot/boot.asm | $(BUILD_DIR)
	$(NASM) -f bin $< -o $@

$(KERNEL_BIN): kernel/current.asm | $(BUILD_DIR)
	$(NASM) -f bin kernel/current.asm -o $@

$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN) tools/mkimage.py
	$(PYTHON) tools/mkimage.py --boot $(BOOT_BIN) --kernel $(KERNEL_BIN) --out $(IMAGE) --kernel-sectors $(KERNEL_SECTORS)

$(ISO): $(IMAGE) tools/mkiso.py
	$(PYTHON) tools/mkiso.py --image $(IMAGE) --out $(ISO)

run: $(IMAGE)
	$(QEMU) -machine pc -drive file=$(IMAGE),format=raw,index=0,media=disk

run-iso: $(ISO)
	$(QEMU) -machine pc -cdrom $(ISO) -boot d

verify: current $(IMAGE) $(ISO)
	$(PYTHON) tools/check_image.py $(IMAGE)
	$(PYTHON) tools/smoke_image.py $(IMAGE)
	$(PYTHON) tools/inspect_image.py $(IMAGE)

clean:
	rm -rf $(BUILD_DIR)
