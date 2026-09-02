SIM ?= verilator
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/two_flipflop.sv

TOPLEVEL=sync_2dff
MODULE=testbench_2flipflop


include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY : clear
clear :
	rm -rf sim_build
	rm -f *.vcd 

