SIM ?= verilator
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/shift_8x64_taps.sv

TOPLEVEL=shift_8x64_taps
MODULE=testbench_shift8x64


include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY : clear
clear :
	rm -rf sim_build
	rm -f *.vcd 

