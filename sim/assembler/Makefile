default: elf

GCC_OPTS ?= -march=rv32i -mabi=ilp32 -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf --specs=nosys.specs
LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T ../common/program.ld
SOURCE_FILES ?= test.S

elf:
	riscv64-unknown-elf-gcc $(GCC_OPTS) $(SOURCE_FILES) $(LINK_OPTS) -o test.elf
hex:
	riscv64-unknown-elf-objcopy -O ihex "test.elf" "test.hex"
bin:
	riscv64-unknown-elf-objcopy -S test.elf -O binary test.bin
lst:
	riscv64-unknown-elf-objdump -D -S test.elf > test.lst
verilog:
	riscv64-unknown-elf-objcopy -S test.elf -O verilog test.verilog
	sed -i 's/@204/@000/g' test.verilog