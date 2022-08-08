default:file sim

RTL_DIR = ../../../rtl
FILES  := $(addsuffix \n,$(wildcard ${RTL_DIR}/../sim/*.sv ${RTL_DIR}/*.v ${RTL_DIR}/*/*.v))

file:
	-rm *.f -rf
	echo -e "$(FILES)" >> filelist.f
	echo -e "+incdir+$(RTL_DIR)/core/" >> filelist.f
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
