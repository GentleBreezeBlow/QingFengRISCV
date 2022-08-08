default: all_sim

sim_dir=$(abspath .)
isa_dir=$(sim_dir)/isa/generated

INSTR_NAME += $(notdir $(wildcard $(isa_dir)/rv32ui*.verilog))

all_sim:
	$(foreach name, $(INSTR_NAME), cp $(sim_dir)/demo $(sim_dir)/$(name) -r && \
	cp $(isa_dir)/$(name) $(sim_dir)/$(name)/main.verilog && \
	cd $(sim_dir)/$(name) && \
	make;)

test:
	@echo $(INSTR_NAME)

clean:
	rm -rf ./*.verilog