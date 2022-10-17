default: elf verilog sim

GCC_OPTS ?= -march=rv32i -mabi=ilp32 -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O0 -ffast-math -fno-common -fno-builtin-printf --specs=nosys.specs
LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T ../common/program.ld
SOURCE_FILES ?= ../common/*.h ../common/*.S main.c
RTL_DIR = ../../rtl
FILES  := $(addsuffix \n,$(wildcard ${RTL_DIR}/../sim/*.sv ${RTL_DIR}/*.v ${RTL_DIR}/*/*.v))

file:
	echo -e "$(FILES)" > filelist.f
	echo -e "+incdir+$(RTL_DIR)/core/" >> filelist.f
elf:
	riscv64-unknown-elf-gcc $(GCC_OPTS) $(SOURCE_FILES) $(LINK_OPTS) -o main.elf
hex:
	riscv64-unknown-elf-objcopy -O ihex "main.elf" "main.hex"
bin:
	riscv64-unknown-elf-objcopy -S main.elf -O binary main.bin
lst:
	riscv64-unknown-elf-objdump -D -S main.elf > main.lst
verilog:
	riscv64-unknown-elf-objcopy -S main.elf -O verilog main.verilog
	sed -i 's/@800/@000/g' main.verilog
sim:
	vcs +v2k \
	-sverilog \
	-V \
	-debug_access+all \
	-f filelist.f \
	-l vcs.log \
	-full64 \
	-cpp g++-4.8 -cc gcc-4.8 \
	-LDFLAGS -Wl,--no-as-needed \
	+sdfverbose \
	+neg_tchk \
	-negdelay \
	+no_notifier \
	-R +FSDB_DUMP|tee sim.log

deb:
	verdi -f filelist.f -autoalias  -nologo -workMode hardwareDebug -sv -top tb -ssf *.fsdb -sswr 1.rc &
clean:
	rm -rf ./csrc *.daidir *.log simv* *.key *.vpd ucli* ./DVEfiles *.fsdb *.conf *.rc ./verdiLog ${OUTPUT} *.vdb
